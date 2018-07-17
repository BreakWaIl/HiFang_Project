<?php
/**
 * Created by PhpStorm.
 * User: zfc
 * Date: 2018/4/15
 * Time: 17:51
 */

namespace app\api\controller;


use app\common\model\AccountDetails;
use think\Exception;
use think\Log;
use think\Request;
use think\Db;

class Account extends Basic
{
    public $account;
    public $register_icon;
    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->account = new AccountDetails();
        $this->register_icon = Tool::getConfigInfo(74);
    }

    /**
     * 将用户每次流水插入到表中[并且将该用户的用户表钱包余额更新][暂时停用]
     * by songjian
     * param basicinfo 用户基本信息
     * param alipayinfo 阿里返回信息
     */
    public function insert($basicinfo='',$alipayinfo='')
    {
        $this->account->pay_msg = $alipayinfo['pay_msg'];
        $this->account->order_id = $alipayinfo['order_id'];
        $this->account->pay_date = $alipayinfo['pay_date'];
        $this->account->payer_show_name = $alipayinfo['payer_show_name'];
        $this->account->payee_real_name = $alipayinfo['payee_real_name'];
        $this->account->payremark = $alipayinfo['payremark'];
        $this->account->payee_account = $alipayinfo['pay_account'];
        $this->account->avatar = $alipayinfo['avatar'];
        $this->account->amount = $alipayinfo['amount'];

        $this->account->member_id = $basicinfo['member_id'];
        $this->account->withdrawals_id = $basicinfo['withdrawals_id'];
        $this->account->video_id = $basicinfo['video_id'];
        $this->account->remarks = $basicinfo['remarks'];
        $this->account->img = $basicinfo['img'];
        $this->account->type = $basicinfo['type'];
        if ($basicinfo['type'] !== 4 && $basicinfo['type'] !== 5){
            $this->account->money = $money =  $basicinfo['money'];
        }else{
            $this->account->money = $money = -intval($basicinfo['money']);
        }
        $this->account->app_version = $basicinfo['app_version'];

        $res = $this->account->save();
        if (!$res){
            $data = array('code'=>130,'msg'=>'插入账户明细失败');
        }else{
            //目前账户中的金额
            //$balance = Db::table('yf_hf_member')->field('balance')->where('id',$this->userId)->find()['balance'];
            if ($basicinfo['type'] !== 4 && $basicinfo['type'] !== 5){
                $update = Db::table('yf_hf_member')->where('id',$this->userId)->setInc('balance',$basicinfo['money']);
            }else{
                $update = Db::table('yf_hf_member')->where('id',$this->userId)->setDec('balance',$basicinfo['money']);
            }
            if ($update){
                $data = array('code'=>200,'msg'=>'插入账户明细成功');
            }else{
                $data = array('code'=>101,'msg'=>'插入账户明细成功，更新用户钱包失败');
            }
        }
        return $data;
    }

    /**
     * 计算“我的钱包”页面该用户的合计积分等数据
     * by songjian
     * @param $member_id 用户的id
     * return json
     */
    public function total()
    {
        $member_id = $this->userId;
        if (empty($member_id)){
            $data['code'] = 101;
            $data['message'] = '没有拿到用户id，请用户登录';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        //本用户总嗨币
        $total = Db::table('yf_hf_member')->field(['balance'])->where('id',$member_id)->find()['balance'];
        //一块钱兑换嗨币
        $exchange_icon = Tool::getConfigInfo(75);
        $real_money = ($total/$exchange_icon);
        //小数点后精确两位
        $real_money = number_format($real_money, 2);
        //注册人奖励金额
        $register_icon = Tool::getConfigInfo(74);
        //邀请好友奖励金额
        $request_register_icon = Tool::getConfigInfo(67);
        //创作发布视频奖励金额
        $create_video_icon = Tool::getConfigInfo(65);
        //分享视频完成一次观看奖励金额
        $forward_read_icon = Tool::getConfigInfo(66);
        //举报审核通过奖励金额
        $report_icon = Tool::getConfigInfo(68);
        //满多少钱可以提现到支付宝
        $put_forward_alipay = Tool::getConfigInfo(72);
        $data = array(
            'code' =>200,
            'message'  =>'合计数据成功',
            'data' => array(
                'total'                 => $total,
                'real_money'            => $real_money,
                'register_icon'         => $register_icon,
                'request_register_icon' => $request_register_icon,
                'create_video_icon'     => $create_video_icon,
                'forward_read_icon'     => $forward_read_icon,
                'report_icon'           => $report_icon,
                'put_forward_alipay'    => $put_forward_alipay
            )

        );
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     *  获取用户收支明细列表
     *  by songjian
     * @param $member_id 用户的id
     * @return json
     */
    public function detail(){
        header("Access-Control-Allow-Origin: *");
        //一个视频的最多奖励总额
        $total = Tool::getConfigInfo(73);
        //兑换比率
        $exchange_icon = Tool::getConfigInfo(75);
        //转发一次阅读奖励金额
        $once  = Tool::getConfigInfo(66);
        $member_id = $this->userId;  //eg: member_id = 213
        $infos = $this->account->getDetailInfo($member_id);
        $len = count($infos);
        //判断是否查询出数据
        if (!$infos){
            $data['code'] = 101;
            $data['message'] = '没有查询纪录';
        }else{
            $data['code'] = 200;
            $data['message'] = '接收明细列表成功';
        }
        /**
         * 增加
         */
        //计算总发放金额
        $data['have'] = Db::table('yf_hf_account_details')->field('sum(money) money')->where('member_id',$member_id)->where('(type=1 and status=1) or type=2 or type=3 or type=7 or type=8')->find()['money'];
        //$data['have'] = Db::table('yf_hf_account_details')->field('sum(money) money')->where('member_id',$member_id)->where('type',['=',1],['=',2],['=',3],['=',7],['=',8],'or')->find()['money'];
        //计算总提现金额
        $account_detail = Db::table('yf_hf_account_details')->where('member_id',$member_id)->where('type',['=',4],['=',5],'or')->where('status',1)->select();
        if(!$account_detail){
            $data['forward'] = '0.00';
        }else{
            $data['forward'] = Db::table('yf_hf_account_details')->field('sum(money) money')->where('member_id',$member_id)->where('type',['=',4],['=',5],'or')->where('status',1)->find()['money'];
        }

        for ($i=0;$i<$len;$i++){
            //当type=1时为发布视频，积分为正
            if ($infos[$i]['type'] == 1)
            {
                $data['data'][$i]['money'] = $infos[$i]['money'];
                //将视频表的视频数据整合
                $res = Db::table('yf_hf_video')->field(['title','video_cover'])->where('id',$infos[$i]['video_id'])->find();
                $data['data'][$i]['img'] = $res['video_cover'];
                $data['data'][$i]['title'] = $res['title'];
                $data['data'][$i]['type'] =  1;
                $data['data'][$i]['status'] = $infos[$i]['status'];
                $data['data'][$i]['time'] = date('m-d H:i',$infos[$i]['update_time']);
                continue;
            }
            //当type=2时为推荐视频，积分为正
            elseif ($infos[$i]['type'] == 2)
            {
                $money = Db::table('yf_hf_account_details')
                    ->where('video_id',$infos[$i]['video_id'])
                    ->where('type',2)    //新加条件
                    ->where('member_id',$member_id)
                    ->sum('money');
                $update_time = Db::table('yf_hf_account_details')
                    ->field(['update_time'])
                    ->where('video_id',$infos[$i]['video_id'])
                    ->where('type',2)    //新加条件
                    ->where('member_id',$member_id)
                    ->order('update_time desc')
                    ->find()['update_time'];
                //将视频表的视频数据整合
                $res = Db::table('yf_hf_video')
                    ->field(['title','video_cover'])
                    ->where('id',$infos[$i]['video_id'])
                    ->where('member_id',$member_id)
                    ->find();
                $data['data'][$i]['money'] = $money;
                $data['data'][$i]['img'] = $res['video_cover'];
                $data['data'][$i]['title'] = $res['title'];
                $data['data'][$i]['type'] =  2;
                $data['data'][$i]['status'] = 1;
                $data['data'][$i]['once'] = $once;
                $data['data'][$i]['total'] = $total;
                $data['data'][$i]['time'] = date('m-d H:i',$update_time);
                continue;
            }
            //当type=3时为邀请好友，积分为正
            elseif ($infos[$i]['type'] == 3)
            {
                //将用户表的用户数据整合
                $res = Db::table('yf_hf_member')->where('id',$infos[$i]['recommend_member_id'])->find();
                $data['data'][$i]['money'] = $infos[$i]['money'];
                $data['data'][$i]['img'] = $res['headimgurl'];
                $data['data'][$i]['title'] = '邀请'.$res['nickname'].'同志';
                $data['data'][$i]['type'] =  3;
                $data['data'][$i]['status'] = $infos[$i]['status'];
                $data['data'][$i]['time'] = date('m-d H:i',$infos[$i]['update_time']);
                continue;
            }
            //当type=4时为购买推荐位，积分为负[本版本不做]
            /*elseif ($infos[$i]['type'] == 4)
            {
                $data['data'][$i]['money'] = $infos[$i]['money'];
                //将视频表的视频数据整合
                $res = Db::table('yf_hf_video')->field(['title','video_cover'])->where('id',$infos[$i]['video_id'])->select()[0];
                $data['data'][$i]['img'] = $res['video_cover'];
                $data['data'][$i]['title'] = $res['title'];
                $data['data'][$i]['type'] =  4;
                $data['data'][$i]['status'] = $infos[$i]['status'];
                $data['data'][$i]['time'] = date('Y-m-d H:i:s',$infos[$i]['update_time']);
            }*/
            //当type=5时为提现，积分为负
            elseif ($infos[$i]['type'] == 5)
            {
                $data['data'][$i]['money'] = $infos[$i]['money'];
                $data['data'][$i]['img'] = '';   //红包img
                $data['data'][$i]['title'] = '提现到支付宝';
                $data['data'][$i]['type'] =  5;
                $data['data'][$i]['status'] = $infos[$i]['status'];
                $data['data'][$i]['time'] = date('m-d H:i',$infos[$i]['update_time']);
                continue;
            }
            //当type=6时为支付宝提现审核失败，退回账户，积分为正
            elseif ($infos[$i]['type'] == 6)
            {
                $data['data'][$i]['money'] = $infos[$i]['money'];
                $data['data'][$i]['img'] = '';   //支付宝img
                $data['data'][$i]['title'] = '支付宝退回';
                $data['data'][$i]['type'] =  6;
                $data['data'][$i]['status'] = $infos[$i]['status'];
                $data['data'][$i]['time'] = date('m-d H:i',$infos[$i]['update_time']);
                continue;
            }
            //当type=7时为举报审核
            elseif ($infos[$i]['type'] == 7)
            {
                $data['data'][$i]['money'] = $infos[$i]['money'];
                $data['data'][$i]['img'] = '';   //举报img
                $data['data'][$i]['title'] = $infos[$i]['remarks'];
                $data['data'][$i]['type'] =  7;
                $data['data'][$i]['status'] = $infos[$i]['status'];
                $data['data'][$i]['time'] = date('m-d H:i',$infos[$i]['update_time']);
                continue;
            }
            //当type=8时为注册奖励
            elseif ($infos[$i]['type'] == 8)
            {
                $data['data'][$i]['money'] = $infos[$i]['money'];
                $data['data'][$i]['img'] = '';
                //$data['data'][$i]['title'] = $infos[$i]['remarks'];
                $data['data'][$i]['title'] = '注册奖励';
                $data['data'][$i]['type'] =  8;
                $data['data'][$i]['status'] = $infos[$i]['status'];
                $data['data'][$i]['time'] = date('m-d H:i',$infos[$i]['update_time']);
                continue;
            }
        }
        $datas = Tool::remove_duplicate($data['data']);
        $data['data'] = $datas;
        $data['exchange_icon'] = $exchange_icon;
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 当验证邀请码成功之后，要将此邀请码的用户表的钱包余额信息，和账单详情表更新
     * by songjian
     * return bool
     */
    public function updateBalanceAndDetail($invite_code,$user_id){
        $info = Db::table('yf_hf_member')->field(['id','nickname'])->where('invite_code',$invite_code)->find();
        //首先通过userid来判断此用户是否已经邀请够了定义人数，若是则不再给用户余额更新
        $user_total = Tool::getConfigInfo(61);
        //加了where type 3 条件
        $account = Db::table('yf_hf_account_details')->where('type',3)->where('member_id',$info['id'])->count();
        if ($user_total > $account || $invite_code == "666666"){
            //将此邀请码用户的用户表余额信息更新
            //$money = Tool::getRandMoney();
            $money = Tool::getConfigInfo(67);
            $res1 = Db::table('yf_hf_member')->where('invite_code',$invite_code)->setInc('balance',$money);
            //将此邀请码用户的账单详情表更新
            $version = Db::table('yf_hf_member')->field('app_version')->where('id',$info['id'])->find()['app_version'];
            $basicinfo = array(
                'id'        => 0,
                'member_id' => $info['id'],
                'Recommend_member_id' => $user_id,
                'money' => $money,
                'type' => 3,
                'status' => 0,
                'nickname' => $info['nickname'],
                'app_version' => $version,
                'create_time' => time(),
                'update_time' => time(),
            );

            //注册人获得奖励插入数据
            /*$user_detail_info = [
                'id'        => 0,
                'member_id' => $user_id,
                'Recommend_member_id' => '',
                'money'     => $this->register_icon,
                'type'      => 8,
                'status'    => 1,
                'create_time' => time(),
                'update_time' => time(),
            ];*/
            $res2 = $this->account->insert($basicinfo);
            //$this->account->insert($user_detail_info);
            //同时给该用户奖励
            //Db::table('yf_hf_member')->where('id',$user_id)->setInc('balance',$this->register_icon);
            if (!$res1){
                return 101;
            }
            if (!$res2){
                return 102;
            }
            return 200;
        }else{
            /*$version = Db::table('yf_hf_member')->field('app_version')->where('id',$info['id'])->find()['app_version'];
            $basicinfo = array(
                'id'        => 0,
                'member_id' => $info['id'],
                'Recommend_member_id' => $user_id,
                'money' => 0,
                'type' => 3,
                'status' => 0,
                'remarks' => '被邀请的用户总数量已满',
                'nickname' => $info['nickname'],
                'app_version' => $version,
                'create_time' => time(),
                'update_time' => time(),
            );
            $res = $this->account->insert($basicinfo);
            if ($res){
                return 202;
            }else{
                return 103;
            }*/
            return 200;
        }
    }


    /**
     * 当验证邀请码成功之后，要将此邀请码的用户表的钱包余额信息，和账单详情表更新
     * 当验证邀请码成功之后，要将此邀请码的用户表的嗨币金额加500，并锁定嗨币
     * by songjian
     * return bool
     */
    public function updateBalanceAndDetails($invite_code,$user_id){
        Log::info("===============test2======================");
        $info = Db::table('yf_hf_member')->field(['id','nickname'])->where('invite_code',$invite_code)->find();
        //首先通过userid来判断此用户是否已经邀请够了定义人数，若是则不再给用户余额更新
        $user_total = Tool::getConfigInfo(61);
        //加了where type 3 条件
        $account = Db::table('yf_hf_account_details')->where('type',3)->where('member_id',$info['id'])->count();
        if ($user_total > $account || $invite_code == "666666"){
            Log::info("===============test3======================");
            /**
             * 将用户的钱包奖励机制改为n元随机奖励
             * update by songjian
             */
            $member_id = Db::table('yf_hf_member')->field(['id'])->where('invite_code',$invite_code)->find()['id'];
            //发红包的总金额
            Log::info("===============test4======================");
            $amount = Tool::getConfigInfo(91);
            $res = Db::table('yf_hf_redpacket')->where('member_id',$member_id)->select();
            if (empty($res)){
                //在红包表中创建十条数据，1、4、7条金额为平均数+1~+3
                Log::info("===============test5======================");
                $avage = $amount/10;
                for ($i=1;$i<11;$i++){
                    if ($i==1||$i==4||$i==7){
                        $moneys = $this->rands($avage+1,$avage+3);
                        $infos['id'] = 0;
                        $infos['member_id'] = $member_id;
                        $infos['enter_id'] = 0;
                        $infos['num'] =$i;
                        $infos['money'] = $moneys;
                        $infos['create_time'] = time();
                        $infos['update_time'] = time();
                        Db::table('yf_hf_redpacket')->insert($infos);
                        continue;
                    }elseif($i==9){
                        $now_money = Db::table('yf_hf_redpacket')->where('member_id',$member_id)->sum('money');
                        $rest_money = $amount - $now_money;
                        $moneys = $this->rands(0,$rest_money);
                        $infos['id'] = 0;
                        $infos['member_id'] = $member_id;
                        $infos['enter_id'] = 0;
                        $infos['num'] =$i;
                        $infos['money'] = $moneys;
                        $infos['create_time'] = time();
                        $infos['update_time'] = time();
                        Db::table('yf_hf_redpacket')->insert($infos);
                        continue;
                    }elseif ($i!=10){
                        //当次数出现的不是1\4\7\10的时候
                        $now_money = Db::table('yf_hf_redpacket')->where('member_id',$member_id)->sum('money');
                        $rest_money = $amount - $now_money;
                        $avage_money = $rest_money/(10-$i);
                        $moneys = $this->rands($avage_money-1,$avage_money+1);
                        $infos['id'] = 0;
                        $infos['member_id'] = $member_id;
                        $infos['enter_id'] = 0;
                        $infos['num'] =$i;
                        $infos['money'] = $moneys;
                        $infos['create_time'] = time();
                        $infos['update_time'] = time();
                        Db::table('yf_hf_redpacket')->insert($infos);
                        continue;
                    }else{
                        $now_money = Db::table('yf_hf_redpacket')->where('member_id',$member_id)->sum('money');
                        $rest_money = $amount - $now_money;
                        $infos['id'] = 0;
                        $infos['member_id'] = $member_id;
                        $infos['enter_id'] = 0;
                        $infos['num'] =$i;
                        $infos['money'] = $rest_money;
                        $infos['create_time'] = time();
                        $infos['update_time'] = time();
                        Db::table('yf_hf_redpacket')->insert($infos);
                        continue;
                    }
                }
            }
            Log::info("===============test6======================");
            $exchange_icon = Tool::getConfigInfo(75);
            $count = Db::table('yf_hf_redpacket')->where('member_id',$member_id)->where('enter_id','neq',0)->count();
            $money = (Db::table('yf_hf_redpacket')->field(['money'])->where('member_id',$member_id)->where('num',$count+1)->find()['money'])*$exchange_icon;
            Db::table('yf_hf_redpacket')->where('member_id',$member_id)->where('num',$count+1)->update(['enter_id'=>$user_id]);
            Log::info("===============test7======================");

            //将此邀请码用户的用户表余额信息更新
            //$money = Tool::getRandMoney();
            //$money = Tool::getConfigInfo(67);
            $res1 = Db::table('yf_hf_member')->where('invite_code',$invite_code)->setInc('balance',$money);
            //将此邀请码用户的账单详情表更新
            $version = Db::table('yf_hf_member')->field('app_version')->where('id',$info['id'])->find()['app_version'];
            $result = Db::table('yf_hf_account_details')->where('member_id',$info['id'])->where('Recommend_member_id',$user_id)->where('type',3)->find();

            //注册人填写邀请码即可赠送500嗨币，嗨币为锁定状态  by liyang
            $HiMoney = 500;
            $user_register_money = [
                'id'        => 0,
                'member_id' => $user_id,
                'Recommend_member_id' => '',
                'money'     => $HiMoney,
                'type'      => 8,
                'status'    => 1,
                'create_time' => time(),
                'update_time' => time(),
            ];
            //获取到已经增加的嗨币数量 插入数据表
            $this->account->insert($user_register_money);

            if ($result){
                return 100;
            }else{
                $basicinfo = array(
                    'id'        => 0,
                    'member_id' => $info['id'],
                    'Recommend_member_id' => $user_id,
                    'money' => $money,
                    'type' => 3,
                    'status' => 0,
                    'nickname' => $info['nickname'],
                    'app_version' => $version,
                    'create_time' => time(),
                    'update_time' => time(),
                );

                //注册人获得奖励插入数据
                /*$user_detail_info = [
                    'id'        => 0,
                    'member_id' => $user_id,
                    'Recommend_member_id' => '',
                    'money'     => $this->register_icon,
                    'type'      => 8,
                    'status'    => 1,
                    'create_time' => time(),
                    'update_time' => time(),
                ];*/
                $res2 = $this->account->insert($basicinfo);
                //$this->account->insert($user_detail_info);
                //同时给该用户奖励
                //Db::table('yf_hf_member')->where('id',$user_id)->setInc('balance',$this->register_icon);
                if (!$res1){
                    return 101;
                }
                if (!$res2){
                    return 102;
                }
                return 200;
            }
        }else{
            $version = Db::table('yf_hf_member')->field('app_version')->where('id',$info['id'])->find()['app_version'];
            $basicinfo = array(
                'id'        => 0,
                'member_id' => $info['id'],
                'Recommend_member_id' => $user_id,
                'money' => 0,
                'type' => 3,
                'status' => 0,
                'remarks' => '被邀请的用户总数量已满',
                'nickname' => $info['nickname'],
                'app_version' => $version,
                'create_time' => time(),
                'update_time' => time(),
            );
            $res = $this->account->insert($basicinfo);
            if ($res){
                return 200;
            }else{
                return 103;
            }
        }
    }

    public function rands($a,$b){
        $num=$this->randomFloat($a,$b);
        $newNum  = sprintf("%.1f",$num);
        return $newNum;
    }
    function randomFloat($min, $max) {
        return $min + mt_rand() / mt_getrandmax() * ($max - $min);
    }
}