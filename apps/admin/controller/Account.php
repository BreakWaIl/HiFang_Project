<?php
/**
 * Created by PhpStorm.
 * User: ASUS
 * Date: 2018/5/2
 * Time: 17:40
 */

namespace app\admin\controller;


use app\admin\controller\Alipay;
use app\api\controller\Getui;
use app\api\controller\Tool;
use app\api\untils\GeTuiUntils;
use think\Db;

class Account extends Admin
{
    public $accountModel;
    public $iexchange_icon;
    function _initialize()
    {
        parent::_initialize();
        $this->accountModel = model('common/AccountDetails');
        //一块钱兑换嗨币
        $this->iexchange_icon = Tool::getConfigInfo(75);
    }

    /**
     * 账单详情管理页面
     * by songjian
     */
    public function index(){
        //查询统计金额
        $money = $this->accountModel->count();
        //查询账单信息
        $info = Db::table('yf_hf_account_details')
                    ->alias('a')
                    ->join('yf_hf_member m', 'm.id=a.member_id', 'left')
                    ->field('a.id,a.member_id,m.phone,m.nickname,a.type,a.status,a.money,a.create_time')
                    ->select();
        $this->assign('info',$info);
        $this->assign('money',$money);
        $this->assign('type','');
        $this->assign('iexchange_icon',$this->iexchange_icon);
        return view('index');
    }

    /**
     * 条件搜索页面
     * by songjian
     */

    public function search(){
        //查询统计金额
        $money = $this->accountModel->count();
        //用户手机号
        $phone = $_POST['phone'];
        //账单明细类型
        $type = $_POST['type'];
        //用户id
        $member_id = $_POST['member_id'];
        $start_time = strtotime($_POST['start']);
        $stop_time = strtotime($_POST['stop']);
        if ($stop_time == 0){
            $stop_time = 9999999999;
        }
        $info = Db::table('yf_hf_account_details')
            ->alias('a')
            ->join('yf_hf_member m', 'm.id=a.member_id', 'left')
            ->field('a.id,a.member_id,m.phone,a.type,a.status,a.money,a.create_time')
            ->where('m.phone','like',"%$phone%")
            ->where('a.member_id','like',"%$member_id%")
            ->where('a.create_time','>',$start_time)
            ->where('a.create_time','<',$stop_time);
        if ($type != ''){
            $res = $info->where('a.type',$type)->select();
        }else{
            $res = $info->select();
        }
        $this->assign('start_time',$_POST['start']);
        $this->assign('stop_time',$_POST['stop']);
        $this->assign('phone',$phone);
        $this->assign('member_id',$member_id);
        $this->assign('money',$money);
        $this->assign('type',$type);
        $this->assign('iexchange_icon',$this->iexchange_icon);
        $this->assign('info',$res);
        return view('index');
    }
    /**
     * 提现审核页面
     * by songjian
     */
    public function look($id=''){
        if ($id!=0) {
            $info = $this->accountModel->get($id);
        }
        $money = $info['money'];
        $info['money'] = ($money / $this->iexchange_icon);
        $builder = builder('Form');
        $builder->setMetaTitle('账单审核')  // 设置页面标题
        ->addFormItem('id', 'hidden', 'ID', '')
            ->addFormItem('money', 'onlyreadly', '', '金额','','require')
            ->addFormItem('type', 'selectonlyreadly', '','变动类型',[1=>'发布视频',2=>'推荐视频',3=>'邀请好友',4=>'获取推荐位子',5=>'支付宝提现',6=>'支付宝退回',7=>'举报核实'])
            ->addFormItem('status', 'selectonlyreadly', '', '状态',[0=>'处理中',1=>'成功',2=>'失败'])
            ->addFormItem('pay_status','selectonlyreadly', '', '支付状态',[1=>'成功',0=>'失败'])
            ->addFormItem('remarks','onlyreadly', '', '备注','','require')
            ->addFormItem('order_id','onlyreadly', '', '支付宝交易码','','require')
            ->addFormItem('payee_account','onlyreadly', '', '收款支付宝','','require')
            ->addFormItem('payer_show_name','onlyreadly', '', '转出名称','','require')
            ->addFormItem('payee_real_name','onlyreadly', '', '支付宝姓名','','require')
            ->addFormItem('nickname','onlyreadly', '', '昵称','','require')
            ->addFormItem('update_time','onlyreadly', '', '更新时间','','require');
        if ($info['status']==1){
            //当审核已经通过的时候
            return $builder
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('stop','已通过')
                ->addButton('back')    // 设置表单按钮
                ->fetch();
        }elseif ($info['status']==2){
            return $builder
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('stop','已未通过')
                ->addButton('back')    // 设置表单按钮
                ->fetch();
        }else{
            return $builder
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('look','审核通过',url('verify',['id'=>$id,'type'=>1,'order'=>$info['order_id'],'amount'=>$info['money'],'payee_account'=>$info['payee_account'],'payer_show_name'=>$info['payer_show_name'],'payee_real_name'=>$info['payee_real_name'],'remark'=>$info['remarks']]))
                ->addButton('look','未通过',url('verify',['id'=>$id,'type'=>0,'order'=>$info['order_id'],'amount'=>$info['money']]))
                ->addButton('back')    // 设置表单按钮
                ->fetch();
        }
    }

    /**
     * 对提现功能的审核操作
     * by songjian
     * @param $id
     * @param $type
     * @param $order
     * @param $amount
     * @param $payee_account
     * @param $payer_show_name
     * @param $payee_real_name
     * @param $remark
     */
    public function verify($id,$type,$order='',$amount='',$payee_account='',$payer_show_name='',$payee_real_name='',$remark=''){
        //连表查询本操作用户纪录的id和余额
        $result = Db::query("select m.id,m.balance from `yf_hf_member` as m INNER JOIN `yf_hf_account_details` as a on a.member_id = m.id where a.id={$id}");
        $member_id = $result[0]['id'];
        $balance = $result[0]['balance'];
        //$ge_tui = new Getui();
        $ge_tui = new GeTuiUntils();
        if ($type==0){
            //若是审核未通过操作，不用处理提现业务,只进行数据库更新
            $res2 = $this->accountModel->verify($id,$type,$order,$amount,$payee_account,$member_id,$balance);
            if ($res2){
                /**
                 * 活动消息推送
                 * by songjian
                 */
                $data1 = '您的提现已被拒绝,请查看';//提现审核不通过
                $data2 = '您的提现已退回,请查看';//提现已退回
                $arr = [
                    [
                        'id'           => 0,
                        'member_id'    => $member_id,
                        'content'      => $data1,
                        'type'         => 52,
                        'is_show'      => 0,
                        'create_time'  => time(),
                        'update_time'  => time()
                    ],
                    [
                        'id'           => 0,
                        'member_id'    => $member_id,
                        'content'      => $data2,
                        'type'         => 51,
                        'is_show'      => 0,
                        'create_time'  => time(),
                        'update_time'  => time()
                    ]
                ];
                $res = Db::table('yf_hf_task')->insertAll($arr);
                //$member_id = Db::table('yf_hf_account_details')->field(['member_id'])->where('id',$id)->find()['member_id'];
                $device_id = Db::table('yf_hf_device')->where('member_id',$member_id)->value('device_id');
                $ge_tui->public_push_message_for_one(1,$device_id,'提现',$data1,$type=52);
                //$member_id = Db::table('yf_hf_account_details')->field(['member_id'])->where('id',$id)->find()['member_id'];
                $device_id = Db::table('yf_hf_device')->where('member_id',$member_id)->value('device_id');
                $ge_tui->public_push_message_for_one(1,$device_id,'提现',$data2,$type=51);
                /**
                 * 活动消息推送
                 * by songjian
                 */
                return $this->success('审核成功','index');
            }else{
                return $this->error('审核失败');
            }

        }else{
            //先进行提现操作
            $alipay = new Alipay();
            $res1 =$alipay->getMoney($id,$order,$amount,$payee_account,$payer_show_name,$payee_real_name,$remark);
            $result = json_decode($res1);
            if ($result->code == 200){
                //再修改数据库操作
                $res2 = $this->accountModel->verify($id,$type);
                if ($res2){
                    /**
                     * 活动推送
                     * by songjian
                     */
                    $data1 = '您的提现已成功,请查看';//提现审核不通过
                    $arr = [
                        'id'           => 0,
                        'member_id'    => $member_id,
                        'content'      => $data1,
                        'type'         => 50,
                        'is_show'      => 0,
                        'create_time'  => time(),
                        'update_time'  => time()
                    ];
                    $res = Db::table('yf_hf_task')->insert($arr);
                    //$member_id = Db::table('yf_hf_account_details')->field(['member_id'])->where('id',$id)->find()['member_id'];
                    $device_id = Db::table('yf_hf_device')->where('member_id',$member_id)->value('device_id');
                    $ge_tui->public_push_message_for_one(1,$device_id,'提现',$data1,$type=50);
                    /**
                     * 活动推送
                     * by songjian
                     */
                    return $this->success('审核成功','index');
                }else{
                    return $this->error("{$result->message}");
                }
            }else{
                return $this->error('审核失败:'.$result->message);
            }
        }
    }
    /**
     * 创作审核页面
     * by songjian
     */
    public function create($id=''){
        if (IS_POST){
            $id = $_POST['id'];
            $time = time();
            $data['status'] = isset($_POST['status'])? $_POST['status'] : 0 ;
            $data['remarks'] = isset($_POST['remarks'])? $_POST['remarks'] : '' ;
            $data['update_time'] = $time;
            //更新账单详情表
            $res = $this->accountModel->updateCreateVideo($id,$data);
            $ge_tui = new GeTuiUntils();
            if ($res == 1 || $res == 3){
                //审核成功
                //将本视频的审核字段更新
                $video_info = Db::table('yf_hf_account_details')->where('id',$id)->find();
                $result = Db::table('yf_hf_video')->where('id',$video_info['video_id'])->update(['examine'=>1]);
                if ($result){
                    /**
                     * 活动推送
                     * by songjian
                     */
                    if ($res == 1){
                        $member_id = Db::table('yf_hf_account_details')->field(['member_id'])->where('id',$id)->find()['member_id'];
                        $data = '您的创作奖励已审核到账';//审核成功
                        $arr = [
                            'id'           => 0,
                            'member_id'    => $member_id,
                            'content'      => $data,
                            'type'         => 1,
                            'is_show'      => 0,
                            'create_time'  => $time,
                            'update_time'  => $time
                        ];
                        $res = Db::table('yf_hf_task')->insert($arr);
                        $device_id = Db::table('yf_hf_device')->where('member_id',$member_id)->value('device_id');
                        $ge_tui->public_push_message_for_one(1,$device_id,'发布',$data,$type=1);
                    }elseif ($res == 3){
                        $member_id = Db::table('yf_hf_account_details')->field(['member_id'])->where('id',$id)->find()['member_id'];
                        $data = '你发布的视频已审核通过，快邀好友来发视频，获取嗨币';//审核成功
                        $arr = [
                            'id'           => 0,
                            'member_id'    => $member_id,
                            'content'      => $data,
                            'type'         => 11,
                            'is_show'      => 0,
                            'create_time'  => $time,
                            'update_time'  => $time
                        ];
                        $res = Db::table('yf_hf_task')->insert($arr);
                        $device_id = Db::table('yf_hf_device')->where('member_id',$member_id)->value('device_id');
                        $ge_tui->public_push_message_for_one(1,$device_id,'发布',$data,$type=11);
                    }
                }
                return $this->success("审核通过成功,奖励：{$video_info['money']}嗨币",'video/index');
            }elseif($res == 2){
                /**
                 * 活动推送
                 * by songjian
                 */
                $data = '您的创作奖励已被拒绝';//发布审核不通过
                $member_id = Db::table('yf_hf_account_details')->field(['member_id'])->where('id',$id)->find()['member_id'];
                $arr = [
                    'id'           => 0,
                    'member_id'    => $member_id,
                    'content'      => $data,
                    'type'         => 2,
                    'is_show'      => 0,
                    'create_time'  => $time,
                    'update_time'  => $time
                ];
                $res = Db::table('yf_hf_task')->insert($arr);
                $device_id = Db::table('yf_hf_device')->where('member_id',$member_id)->value('device_id');
                $ge_tui->public_push_message_for_one(1,$device_id,'发布',$data,$type=2);
                return $this->success('审核“不通过”成功','video/index');
            }else{
                return $this->error('审核失败');
            }
        }
        $info = Db::table('yf_hf_account_details')->field(['id','status','remarks'])->where('type',1)->where('video_id',$id)->find();
        $this->assign('info',$info);
        return view('account/create',['id'=>$info['id']]);
    }
    /**
     * 返回视频连接，用户前台播放
     * by songjian
     */
    public function createUrl($id){
        //返回给前台当前创作视频账单的视频连接
        $video_link =  $this->accountModel->createUrl($id);
        return $video_link;
    }

    /**
     * 订单详情页面
     * by songjian
     */
    public function order($id=''){
        if ($id!=0) {
            $info = $this->accountModel->get($id);
        }
        $builder = builder('Form');
        $builder->setMetaTitle('账单详情')  // 设置页面标题
        ->addFormItem('id', 'hidden', 'ID', '')
            ->addFormItem('money', 'onlyreadly', '', '金额','','require')
            ->addFormItem('type', 'selectonlyreadly', '','变动类型',[1=>'发布视频',2=>'推荐视频',3=>'邀请好友',4=>'获取推荐位子',5=>'支付宝提现',6=>'支付宝退回',7=>'举报核实'])
            ->addFormItem('status', 'selectonlyreadly', '', '状态',[0=>'处理中',1=>'成功',2=>'失败'])
            ->addFormItem('remarks','onlyreadly', '', '备注','','require');
            return $builder
            ->setFormData($info)//->setAjaxSubmit(false)
            ->addButton('back')    // 设置表单按钮
            ->fetch();
    }
}