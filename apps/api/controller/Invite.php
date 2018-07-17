<?php
/**
 * Created by PhpStorm.
 * User: ASUS
 * Date: 2018/4/25
 * Time: 9:38
 */

namespace app\api\controller;


use app\common\model\Member as memberModel;
use think\Db;
use think\Log;
use think\Request;
use app\common\model\Invite as InviteModel;


class Invite extends Basic
{
    public $inviteModel;
    public $memberModel;
    public function __construct($request = null)
    {
        $this->inviteModel = new InviteModel();
        $this->memberModel = new memberModel();
        parent::__construct($request);
    }

    /**
     * 获取邀请好友页面的推荐用户列表
     * by songjian
     * @return json
     */
    public function inviteUser(){
        $userId = $this->userId;
        $data['code'] = 101;
        $data['message'] = '';
        //查询用户表中最有钱的三十个用户
        $datas = $this->inviteModel->getInviteUser(30);
        //如果未查询到，则搞一下
        if (empty($datas)){
            $data['code'] = 200;
            $data['message'] = '未查询到用户数据';
        }else{
            /**
             * 查询是否是自己关注的用户
             * by songjian
             */
            //查询我关注的人
            $res = Db::table('yf_hf_follow')->where(['member_id'=>$userId, 'type'=>0, 'is_followed'=>1])->select();
            // 添加status 0 未关注 1 已关注
            if (count($datas) > 0) {
                for ($i=0;$i<count($datas);$i++) {
                    $datas[$i]['status'] = 0;
                    if (count($res) > 0) {
                        for ($j=0;$j<count($res);$j++) {
                            if ($datas[$i]['id'] == $res[$j]['followed_id']) {
                                $datas[$i]['status'] = 1;
                            }
                        }
                    }
                    //手机/微信头像适配
                    if ($datas[$i]['unionid']){
                    }else{
                        $datas[$i]['headimgurl'] = Tool::getDomain().$datas[$i]['headimgurl'];
                    }
                }
            }
            $data['code'] = 200;
            $data['message'] = '查询用户成功';
            $data['data'] = $datas;
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 邀请好友页面已邀请列表
     * by songjian
     */
    public function inviteList(){
        $data['code'] = 200;
        $data['message'] = "接口调用成功";
        $user_id = $this->userId;
        //查找本用户邀请码已被使用几次
        $num = Tool::getConfigInfo(61);
        $info = Db::table('yf_hf_account_details')->where('member_id',$user_id)->where('type',3)->select();
        $count = count($info);
        if ($count>$num){
            $data['data']['now'] = $count;
            $data['data']['num'] = 0;
        }else{
            $data['data']['now'] = $count;
            $data['data']['num'] = (int)($num-$count);
        }
        for ($i=0;$i<$count;$i++){
            $recommend_member_id = $info[$i]['Recommend_member_id'];
            $res = Db::table('yf_hf_member')->where('id',$recommend_member_id)->find();
            $recommend_member_count = Db::table('yf_hf_account_details')->where('member_id',$recommend_member_id)->where('type',3)->count();
            $data['data']['list'][$i]['nickname'] = $res['nickname'];
            $data['data']['list'][$i]['sign']     = $res['sign'];
            $data['data']['list'][$i]['headimgurl'] = $res['headimgurl'];
            $data['data']['list'][$i]['count']    = $recommend_member_count;
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 邀请好友-获取我的邀请码
     * by songjian
     * @return json
     */
    public function getInviteCode(){
        $data['code'] = 101;
        $data['message'] = '';
        $user_id = $this->userId;
        //获取邀请码
        $code = $this->inviteModel->getInviteCode($user_id);
        if (empty($code)){
            $data['message'] = '暂无邀请码';
        }else{
            //查找本用户邀请码已被使用几次
            $num = Tool::getConfigInfo(61);
            $count = Db::table('yf_hf_account_details')->where('member_id',$user_id)->where('type',3)->count();
            if ($count>$num){
                $data['data']['num'] = 0;
            }else{
                $data['data']['num'] = (int)($num-$count);
            }
            $data['code'] = 200;
            $data['message'] = '邀请码查找成功';
            $data['data']['invite_code'] = $code;
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 微信/朋友圈邀请好友的返回地址
     * by songjian
     */
    public function wxInvite(){
        $data['code'] = 200;
        $data['message'] = "地址拼接成功";
        $website = "www.xxx.com?userid={$this->userId}";
        $data['website'] = $website;
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 邀请好友-显示通讯录邀请信息
     * by songjian
     * @return json
     */
    public function getChatNote(Request $request){
        $data['code'] = 101;
        $data['message'] = '';
        $info = $request->post('info');
        $info = json_decode($info,true);
        if (empty($info)){
            $data['message'] = '您未传入任何数据';
        }
        $count = count($info);
        //针对每一个用户进行判断是否存在本库，如果存在则返回库内信息，如果不存在则返回app返回的信息
        for ($i=0;$i<$count;$i++){
            $res = Db::table('yf_hf_member')
                ->field(['nickname','unionid','phone','headimgurl','sign','id'])
                ->where('phone',$info[$i]['phone'])
                ->find();
            if ($res){
                //手机/微信头像适配
                if ($res['unionid']){
                }else{
                    $res['headimgurl'] = Tool::getDomain().$res['headimgurl'];
                }
                //查询是否是我关注的人
                $result = Db::table('yf_hf_follow')->where(['member_id'=>$this->userId,'followed_id'=>$res['id'],'type'=>0, 'is_followed'=>1])->select();
                // 添加type 1 关注 2 未关注
                if ($result){
                    $res['type'] = 1;
                }else{
                    $res['type'] = 2;
                }
                $res['name'] = $info[$i]['name'];
                $data['data'][$i] = $res;
            }else{
                $res = array(
                    'nickname'  => '',
                    'phone'     => $info[$i]['phone'],
                    'headimgurl'=> '后期要加一个默认照片',
                    'sign'      => '一个默认的签名',
                    'type'      => 0,
                    'name'      => $info[$i]['name'],
                );
                $data['data'][$i] = $res;
            }
        }
        $data['code'] = 200;
        $data['message'] = '通信录列表拼接成功';
        $data['total'] = $count;
        return json_encode($data,JSON_UNESCAPED_UNICODE);
       /* $data['code'] = 101;
        $data['message'] = '';
        $info = $request->post('info');
        $info = json_decode($info,true);
        $count = count($info);
        $pageNo = empty($request->post('pageNo'))? 1 : $request->post('pageNo');
        $pagesize = 10;
        if (empty($info)){
            $data['message'] = '您未传入任何数据';
        }
        $page = ceil($count/$pagesize);
        $nowsize = ($pageNo-1)*$pagesize;
        $tosize = $nowsize+$pagesize;
        //针对每一个用户进行判断是否存在本库，如果存在则返回库内信息，如果不存在则返回app返回的信息
        for (;$nowsize<$tosize;$nowsize++){
            if ($info[$nowsize] == null){
                $data['message'] = '查询数据为空';
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
            $res = Db::table('yf_hf_member')
                    ->field(['nickname','phone','headimgurl','sign','id'])
                    ->where('phone',$info[$nowsize]['phone'])
                    ->find();
            if ($res){
                //查询是否是我关注的人
                $result = Db::table('yf_hf_follow')->where(['member_id'=>$this->userId,'followed_id'=>$res['id'],'type'=>0, 'is_followed'=>1])->select();
                // 添加type 1 关注 2 未关注
                if ($result === true){
                    $res['type'] = 1;
                }else{
                    $res['type'] = 2;
                }
                $res['name'] = $info[$nowsize]['name'];
                $data['data'][$nowsize] = $res;
            }else{
                $res = array(
                    'nickname'  => '',
                    'phone'     => $info[$nowsize]['phone'],
                    'headimgurl'=> '后期要加一个默认照片',
                    'sign'      => '一个默认的签名',
                    'type'      => 0,
                    'name'      => $info[$nowsize]['name'],
                );
                $data['data'][$nowsize] = $res;
            }
        }
        $data['code'] = 200;
        $data['message'] = '通信录列表拼接成功';
        $data['page'] = $page;
        return json_encode($data,JSON_UNESCAPED_UNICODE);*/
    }

    /**
     * 判断此用户是否填写过他人邀请码
     * by songjian
     * @return json
     */
    public function isWrite(){
        $data['code'] = 101;
        $data['message'] = '';
        $id = $this->userId;
        $res = $this->memberModel->isWrite($id);
        if ($res == 1){
            $data['code'] = 200;
            $data['message'] = '已填写过邀请码，无需再次输入';
            $data['status'] = false;
        }else{
            $data['code'] = 200;
            $data['message'] = '未填写过邀请码，可以填写';
            $data['status'] = true;
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }


    /**
     * 输入邀请码，验证邀请码是否有效，若有效则给本用户is_power加特权
     * by songjian
     * @return json
     */
    public function checkInviteCode(Request $request){
        Log::info("===============test0======================");
        $invite_code = $request->post('invite_code');
        if (empty($invite_code)){
            $data['code'] = 101;
            $data['message'] = '邀请码为空，请输入邀请码';
            $data['data']['status'] = 0;
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }

        //先通过is_power判断用户是否已经存在权限
        $is_power = $this->inviteModel->checkIsPower($this->userId);
        if ($is_power == 1){
            $data['code'] = 101;
            $data['message'] = '已有邀请码，不用输入邀请码';
            $data['data']['status'] = 1;
        }else{
            //获取我的邀请码
            $self_code = $this->inviteModel->getInviteCode($this->userId);
            //判断用户表中的邀请码是否匹配
            /*$invite_codes = $this->inviteModel->getAllInviteCode();
            $codes = [];
                //将邀请码全部放到一个数组中，然后进行匹配
            foreach ($invite_codes as $res){
                $codes[] .= $res['invite_code'];
            }   //去重去除自己的邀请码
            $codes =array_unique($codes);
            var_dump($codes);exit;
            $codes = array_merge(array_diff($codes, array($self_code)));
            $res = in_array($invite_code,$codes);*/
            $res = Db::table('yf_hf_member')->where('invite_code',"{$invite_code}")->where('invite_code','neq',"{$self_code}")->find();
            //update
            if ($res != null){
                //当验证成功时，将此用户记录表中is_power状态修改
                //当验证成功后，将此邀请码的用户钱包余额和账户流水详情表更新
                Log::info("===============test1======================");
                $res1 = action('Account/updateBalanceAndDetail',['invite_code'=>$invite_code,'user_id'=>$this->userId]);
                Log::info("===============test10======================");
                if ($res1 == 101 || $res1 == 102 || $res1 == 103){
                    $data['code'] = 101;
                    $data['message'] = '邀请码的用户钱包余额或账户流水详情表更新失败';
                    $data['data']['status'] = 2;
                }elseif ($res1 == 100){
                    $data['code'] = 101;
                    $data['message'] = '不能重复插入数据';
                    $data['data']['status'] = 2;
                }elseif ($res1 == 202){
                    $data['code'] = 101;
                    $data['message'] = '邀请超出上限，不奖励金';
                    $data['data']['status'] = 3;
                }else{
                    //将此用户is_power、invite_from_id更新
                    $result = $this->inviteModel->updateIsPower($this->userId,$invite_code);
                    if ($result) {
                        $data['code'] = 200;
                        $data['message'] = '邀请码验证成功';
                        $data['data']['status'] = 4;
                    }else{
                        //更新用户权限失败
                        $data['code'] = 101;
                        $data['data']['status'] = 5;
                        $data['message'] = '邀请码验证失败';
                    }
                }
            }else{
                $data['code'] = 101;
                $data['message'] = '邀请码验证错误';
                $data['data']['status'] = 6;
            }
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }



    /**
     * 输入邀请码，验证邀请码是否有效，若有效则给本用户is_power加特权
     * by songjian
     * @return json
     */
    public function checkInviteCodes(Request $request){
        Log::info("===============test0======================");
        $invite_code = $request->post('invite_code');
        if (empty($invite_code)){
            $data['code'] = 101;
            $data['message'] = '邀请码为空，请输入邀请码';
            $data['data']['status'] = 0;
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }

        //先通过is_power判断用户是否已经存在权限
        $is_power = $this->inviteModel->checkIsPower($this->userId);
        if ($is_power == 1){
            $data['code'] = 101;
            $data['message'] = '已有邀请码，不用输入邀请码';
            $data['data']['status'] = 1;
        }else{
            //获取我的邀请码
            $self_code = $this->inviteModel->getInviteCode($this->userId);
            //判断用户表中的邀请码是否匹配
            /*$invite_codes = $this->inviteModel->getAllInviteCode();
            $codes = [];
                //将邀请码全部放到一个数组中，然后进行匹配
            foreach ($invite_codes as $res){
                $codes[] .= $res['invite_code'];
            }   //去重去除自己的邀请码
            $codes =array_unique($codes);
            var_dump($codes);exit;
            $codes = array_merge(array_diff($codes, array($self_code)));
            $res = in_array($invite_code,$codes);*/
            $res = Db::table('yf_hf_member')->where('invite_code',"{$invite_code}")->where('invite_code','neq',"{$self_code}")->find();
            //update
            if ($res != null){
                //当验证成功时，将此用户记录表中is_power状态修改
                //当验证成功后，将此邀请码的用户钱包余额和账户流水详情表更新
                //当验证成功后，将此邀请码的用户的嗨币数量加500，并锁定嗨币
                Log::info("===============test1======================");
                $res1 = action('Account/updateBalanceAndDetails',['invite_code'=>$invite_code,'user_id'=>$this->userId]);
                Log::info("===============test10======================");
                if ($res1 == 101 || $res1 == 102 || $res1 == 103){
                    $data['code'] = 101;
                    $data['message'] = '邀请码的用户钱包余额或账户流水详情表更新失败';
                    $data['data']['status'] = 2;
                }elseif ($res1 == 100){
                    $data['code'] = 101;
                    $data['message'] = '不能重复插入数据';
                    $data['data']['status'] = 2;
                }elseif ($res1 == 202){
                    $data['code'] = 101;
                    $data['message'] = '邀请超出上限，不奖励金';
                    $data['data']['status'] = 3;
                }else{
                    //将此用户is_power、invite_from_id更新
                    $result = $this->inviteModel->updateIsPower($this->userId,$invite_code);
                    if ($result) {
                        $data['code'] = 200;
                        $data['message'] = '邀请码验证成功';
                        $data['data']['status'] = 4;
                    }else{
                        //更新用户权限失败
                        $data['code'] = 101;
                        $data['data']['status'] = 5;
                        $data['message'] = '邀请码验证失败';
                    }
                }
            }else{
                $data['code'] = 101;
                $data['message'] = '邀请码验证错误';
                $data['data']['status'] = 6;
            }
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }





    /**
     * 发红包页面接口
     * by songjian
     */
    public function redPacket(){
        $data['code'] = 200;
        $data['message'] = "查询成功";
        $user_id = $this->userId;
        $count = Db::table('yf_hf_redpacket')->where('member_id',$user_id)->where('enter_id','neq',0)->count();

        $img = Tool::getConfigInfo(87);
        $path = Db::table('yf_attachment')->field(['path'])->where('id',$img)->find()['path'];
        $image_url = Tool::getDomain().$path;
        $packetSender = Tool::getConfigInfo(88);
        $packetOperation = Tool::getConfigInfo(89);
        $packageNotes = Tool::getConfigInfo(90);
        $amount = Tool::getConfigInfo(91);
        $data['data']['image_url'] = $image_url;
        $data['data']['packet_sender'] = $packetSender;
        $data['data']['packet_operation'] = $packetOperation;
        $data['data']['package_notes'] = $packageNotes;
        $data['data']['amount'] = $amount;
        $data['data']['count']  = $count;
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 红包详情页面
     * by songjian
     */
    public function redPacketDetail(Request $request){
        header("Access-Control-Allow-Origin: *");
        $data['code'] = 101;
        $data['message'] = "";
        $member_id = $request->param('member_id');
        $info = Db::table('yf_hf_redpacket')->where('member_id',$member_id)->where('enter_id','neq',0)->select();
        if ($info){
            $data['code'] = 200;
            $data['message'] = "接口调用成功";
            $count = count($info);
            for ($i=0;$i<$count;$i++){
                $res = Db::table('yf_hf_member')->where('id',$info[$i]['enter_id'])->find();
                $data['data'][$i]['nickname'] = $res['nickname'];
                $data['data'][$i]['headimgurl'] = str_replace('http://','https://',$res['headimgurl']);
                $data['data'][$i]['money'] = $info[$i]['money'];
                $data['data'][$i]['create_time'] = $info[$i]['create_time'];
            }
        }else{
            $data['code'] = 200;
            $data['message'] = "没有红包详情";
        }
        $total_money = Db::table('yf_hf_redpacket')->where('member_id',$member_id)->where('enter_id','neq',0)->sum('money');
        $count = Db::table('yf_hf_redpacket')->where('member_id',$member_id)->where('enter_id','neq',0)->count();
        $img = Tool::getConfigInfo(87);
        $path = Db::table('yf_attachment')->field(['path'])->where('id',$img)->find()['path'];
        $image_url = str_replace('http://','https://',Tool::getDomain().$path);
        //红包发送人
        $packetSender = Tool::getConfigInfo(88);
        //红包备注
        $packageNotes = Tool::getConfigInfo(90);
        //发红包总计金额
        $amount = Tool::getConfigInfo(91);
        $data['image_url'] = $image_url;
        $data['packet_sender'] = $packetSender;
        $data['package_notes'] = $packageNotes;
        $data['amount'] = $amount;
        $data['count']  = $count;
        $data['total_money'] = $total_money;
        $data['surplus_money'] = $amount-$total_money;
        //记录行为,便于统计
        $behavior = Behavior::insertBackBehavior($this->userId,30);
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }
}