<?php
/**
 * Created by songjian.
 * User: ASUS
 * Date: 2018/4/26
 * Time: 17:56
 */

namespace app\user\admin;

use app\common\model\ChatMessage;
use think\Db;
use think\Request;

class admin extends \app\admin\controller\Admin
{
    public $adminModel;
    public $chatmessageModel;
    function _initialize()
    {
        parent::_initialize();
        $this->adminModel = model('common/Users');
        $this->chatmessageModel = model('common/ChatMessage');
    }

    /**
     * 前台用户列表
     * by songjian
     */
    public function index(){
        // 获取所有用户
        // $info = Db::query('select * from yf_hf_member where is_robot = 0 order by create_time desc');

        //$info = Db::table('yf_hf_member')->where('is_robot',0)->order('create_time','desc')->paginate(20);


        $info = Db::table('yf_hf_member')
            ->alias('m')
            ->join('yf_hf_account_details d','m.id = d.member_id','left')
            ->field(['m.*,sum(case when ((d.type=1 and d.status=1) or d.type=2 or d.type=3 or d.type=7 or d.type=8) then d.money end) have,sum(case when d.type=4 or d.type=5 then d.money end) forward'])
            ->where('m.is_robot',0)
            ->order('m.create_time','desc')
            ->group('m.id')
            ->paginate(20);

        $this->assign('info',$info);
        return view('admin');
    }

    /**
     * 修改用户身份标签
     * @auther zyt
     */
    public function updateLabel($id,$label){
        $result = Db::table('yf_hf_member')->where('id',$id)->update(['label'=>$label]);
        return $result;
    }

    /**
     * 编辑用户
     * by songjian
     */
    public function edit($id = 0) {
        $title = $id ? "编辑" : "新增";
        if (IS_POST) {
            $data['id'] = input('param.id');
            $data['is_power'] = input('param.is_power');
            // 密码为空表示不修改密码
            /*if ($data['password'] === '') {
                $data['password']=123456;
            }*/
            $uid  = isset($data['id']) && $data['id']>0 ? intval($data['id']) : false;
            if ($uid>0) {
                //全局验证
                //$this->validateData($data,'User.edit');
            } else{
                $this->validateData($data,'User.add');
            }
            // 提交数据
            //$data里包含主键id，则editData就会更新数据，否则是新增数据
            $result = $this->adminModel->editData($data);

            if ($result) {

                if ($uid==is_login()) {//如果是编辑状态下
                    logic('common/User')->updateLoginSession($uid);
                }
                $this->success($title.'成功', url('index'));
            } else {
                $this->error($this->adminModel->getError());
            }

        } else {
            // 获取账号信息
            if ($id!=0) {
                //$info = $this->adminModel->get($id);
                $sql = "select m.id,m.nickname,m.phone,m.hiid,m.sex,m.num_follow,m.num_publish,m.num_good_video,m.num_buildings,m.num_prise,m.num_member,m.balance,m.sign,m.birthday,m.is_power,a.dic_value,(select phone from `yf_hf_member` where id= d.member_id) as Recommend_member_phone,(select nickname from `yf_hf_member` where id= d.member_id) as Recommend_member_name from ((`yf_hf_member` as m LEFT JOIN `yf_hf_area` as a on m.area_id = a.id) left join `yf_hf_account_details` as d on m.id=d.recommend_member_id) where m.id={$id} and a.id=m.area_id";
                $info = Db::query($sql)[0];
                //unset($info['password']);
            }
            $builder = builder('Form');
            $builder->setMetaTitle('用户详情')  // 设置页面标题
                ->addFormItem('id', 'hidden', 'ID', '')
                ->addFormItem('nickname', 'onlyreadly', '昵称')
                ->addFormItem('phone', 'onlyreadly', '手机号')
                ->addFormItem('hiid', 'onlyreadly', '嗨房id')
                ->addFormItem('birthday', 'onlyreadly', '出生日期')
                ->addFormItem('sign', 'onlyreadly', '签名')
                ->addFormItem('sex', 'selectonlyreadly', '性别','',[0=>'保密',1=>'男',2=>'女'])
                //->addFormItem('country', 'onlyreadly', '国家')
                //->addFormItem('province', 'onlyreadly', '省份')
                //->addFormItem('city', 'onlyreadly', '城市')
                ->addFormItem('num_follow', 'onlyreadly', '粉丝数')
                ->addFormItem('num_publsh', 'onlyreadly', '发布数')
                ->addFormItem('num_good_video', 'onlyreadly', '点赞视频数')
                ->addFormItem('num_buildings', 'onlyreadly', '关注小区数')
                ->addFormItem('num_prise', 'onlyreadly', '获赞')
                ->addFormItem('num_member', 'onlyreadly', '关注人数')
                ->addFormItem('balance', 'onlyreadly', '钱包余额')
                ->addFormItem('is_power', 'onlyreadly', '是否有权限发视频(是否填写过邀请码) (0代表否,1代表是)')
                ->addFormItem('Recommend_member_phone', 'onlyreadly', '邀请人手机号')
                ->addFormItem('Recommend_member_name', 'onlyreadly', '邀请人昵称');
            return $builder
                //->addFormItem('status', 'select', '状态', '',[0=>'禁用',1=>'正常',2=>'待验证'])
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('back')    // 设置表单按钮
                ->fetch();
        }
    }
    /**
     * 筛选用户
     * by songjian
     */
    public function search(Request $req){
        $nickname = $req->param('nickname');
        $hiid = $req->param('hiid');
        $phone = $req->param('phone');
        $start_time = strtotime($req->param('start'));
        $stop_time = strtotime($req->param('stop'));

        //echo $start_time,$stop_time;exit;
        $query = Db::table('yf_hf_member')
            ->alias('m')
            ->join('yf_hf_account_details d','m.id = d.member_id','left')
            ->field(['m.*,sum(case when d.type=1 or d.type=2 or d.type=3 or d.type=6 or d.type=7 or d.type=8 then d.money end) have,sum(case when d.type=4 or d.type=5 then d.money end) forward'])
            ->where('m.is_robot',0);

        if ($phone) {
            $query = $query->where('m.phone','like',"%$phone%");
        }
        if ($nickname) {
            $query = $query->where('m.nickname','like',"%$nickname%");
        }
        if ($hiid) {
            $query = $query->where('m.hiid','like',"%$hiid%");
        }

        if ($start_time || $stop_time) {
            $query = $query->where('m.create_time','>',$start_time)->where('m.create_time','<',$stop_time+86400);
        }
        $info = $query->group('m.id')->paginate(20);

        $this->assign('nickname',$nickname);
        $this->assign('hiid',$hiid);
        $this->assign('start_time',$req->param('start'));
        $this->assign('stop_time',$req->param('stop'));
        $this->assign('phone',$phone);
        $this->assign('info',$info);
        return view('admin');
    }

    /**
     * 设置用户的状态[删除]
     * by songjian
     */
    public function setStatus($model = CONTROLLER_NAME,$script=false){
        $ids = input('param.ids/a');
        if (is_array($ids)) {
            if(in_array('1', $ids)) {
                $this->error('超级管理员不允许操作');
            }
        }else{
            if($ids === '1') {
                $this->error('超级管理员不允许操作');
            }
        }
        parent::setStatus('Users');
    }

    /**
     * 获取聊天对象
     * by zyt
     * time 2018/5/8 18:56
     */
    public function getFriend ($id=0)
    {
        if (empty($id)) {
            $this->error('参数错误！');
        }
        $message = $this->chatmessageModel->getChatFriendList($id,$pageNo=1);
        return view('friend',['info'=>$message]);
    }

    /**
     *  聊天记录
     * by zyt
     */
    public function getChatMessage ($from, $to)
    {
        if (empty($from) || empty($to)) {
            $this->error('参数错误！');
        }
        $message = DB::table('yf_hf_chat_message')->alias('cm')
                ->join('yf_hf_member m', 'm.id=cm.to', 'left')
                ->field('cm.id,cm.from,cm.to,cm.data,cm.timestamp,cm.type,m.nickname,m.headimgurl')
                ->where(['cm.from'=>$from,'cm.to'=>$to])
                ->whereOr(['cm.from'=>$to,'cm.to'=>$from])
                ->order('cm.timestamp asc')->select();
        //dump($message);exit;
        $data = $times = [];
        foreach ($message as $r) {
            $time = date('Y-m-d H:i:s',$r['timestamp']);
            $times[$time][] = [
                'mid'                => $r['id'],
                'from'               => $r['from'],
                'to'                 => $r['to'],
                'data'               => json_decode($r['data'])->content,
                'type'               => $r['type'],
                'nickname'           => $r['nickname'],
                'headimgurl'         => $r['headimgurl']
            ];
        }
        foreach ($times as $keys=>$values) {
            $data[] = [
                'timestamp' => $keys,
                'value'     =>$values
            ];
        }
        return view('chatMessage',['info'=>$data, 'id'=>$from]);
    }

    /**
     * 邀请好友统计
     * by songjian
     */
    public function tongji(){
        $timegap = input('timegap');
        if($timegap){
            $gap = explode('—', $timegap);
            $begin = $gap[0];
            $end = $gap[1];
        } else {
            $lastweek = date('Y-m-d',strtotime("-1 month"));//30天前
            $begin = input('begin',$lastweek);
            $end =  input('end',date('Y-m-d'));
        }
        $begin = strtotime($begin);
        $end = strtotime($end)+86399;
        $this->assign('timegap',date('Y-m-d',$begin).'—'.date('Y-m-d',$end));
        $this->assign('meta_title','邀请好友统计');

        $today = strtotime(date('Y-m-d'));
        $month = strtotime(date('Y-m-01'));

        //在此地添加邀请好友数量分布
        $info = Db::query("select count(*) as member from yf_hf_behavior where type = 17 group by userid");
        $data = $this->inviteNum($info);
        $user = [
            'today'      => Db::table('yf_hf_behavior')->where('type',17)->where("create_time>$today")->count(),//今日邀请好友
            'month'      => Db::table('yf_hf_behavior')->where('type',17)->where("create_time>$month")->count(),//本月邀请好友
            'total'      => Db::table('yf_hf_behavior')->where('type',17)->count(),//邀请总数
            'onetothree' => $data['onetothree'],
            'fourtosix' => $data['fourtosix'],
            'seventonine' => $data['seventonine'],
            'tenplus' => $data['tenplus']
        ];
        $this->assign('user',$user);

        //邀请好友、进入被转页面、登录记录
        $follow_count = Db::table('yf_hf_behavior')->where('type',17)->where('create_time','>',$begin)->where('create_time','<',$end)->count(); //邀请好友总数
        $rent = Db::table('yf_hf_behavior')->where('type',18)->where('create_time','>',$begin)->where('create_time','<',$end)->count(); //进入被转页面总数
        $sell = Db::table('yf_hf_behavior')->where('type',19)->where('create_time','>',$begin)->where('create_time','<',$end)->count(); //登录记录
        $brr[0] = $follow_count;
        $brr[1] = $rent;
        $brr[2] = $sell;
        $result = array('data'=>$brr);
        $this->assign('result',json_encode($result));
        return $this->fetch();
    }

    /**
     * 单个用户邀请好友统计
     * by songjian
     * modify by liyang
     */
    public function usertongji($time){
        $times = $time;
        $time = explode('—',$time);
        $start_time = strtotime($time[0]);
        $stop_time = strtotime($time[1])+86400;

        $paged     = input('param.paged',1);//分页值
        $page_size = input('param.page_size') ? (int)input('param.page_size') :(int)config('admin_page_size');
        $page = ($paged-1)*$page_size;

        /*邀请好友统计 13.进入(打开)邀请页面*/
        $sql =  "select h.userid,m.nickname,m.hiid,count(case when h.type=17 then h.type end) invite, count(case when h.type=18 then h.type end) invited, count(case when h.type=19 then h.type end) login from yf_hf_behavior as h inner join yf_hf_member as m on h.userid=m.id WHERE h.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP BY h.userid limit $page,$page_size";
//        dump($sql);exit;
        $sqls = "select h.userid,m.nickname,m.hiid,count(case when h.type=17 then h.type end) invite, count(case when h.type=18 then h.type end) invited, count(case when h.type=19 then h.type end) login from yf_hf_behavior as h inner join yf_hf_member as m on h.userid=m.id GROUP BY h.userid";
//        dump($sqls);exit;
        $info = Db::table("yf_hf_behavior")
            ->alias('h')
            ->join("yf_hf_member m","h.userid=m.id","inner")
            ->field("h.id,h.userid,m.nickname,m.hiid,count(case when h.type=17 then h.type end) invite, count(case when h.type=18 then h.type end) invited, count(case when h.type=19 then h.type end) login")
            ->where("h.create_time BETWEEN '{$start_time}' AND '{$stop_time}'")
            ->group("h.userid")
            ->paginate(10);
        $this->assign('info',$info);
        return view('usertongji');

//        $list = Db::query($sql);
//        $lists = Db::query($sqls);
//        $total = count($lists);
//
//        $back = [
//            'title'=>'返回',
//            'href'=>url('admin/tongji')
//        ];

//        return builder('list')
//            ->setMetaTitle('单个视频详情统计') // 设置页面标题
//            ->addTopButton('self',['title'=>"查询日期{$times}"])  // 添加新增按钮
//            ->addTopButton('self',$back)  // 返回按钮
//            ->keyListItem('userid','用户ID','userid')
//            ->keyListItem('hiid','用户hiid','hiid')
//            ->keyListItem('nickname','用户昵称','nickname')
//            ->keyListItem('invite','微信邀请好友','invite')
//            ->keyListItem('invited','进入邀请页面','invited')
//            ->keyListItem('login','注册','login')
//            ->setListPrimaryKey('id')
//            ->setListData($list)    // 数据列表
//            ->setListPage($total) // 数据列表分页
//            ->fetch();
    }

    /**
     * 本用户邀请关系
     * by songjian
     */
    public function invite($id){
        $this->assign('meta_title','本人邀请好友');
        return view('admin/invite',['id'=>$id]);
    }

    public function inviteData($id){
        $results = array();
        //查询出一级（本用户信息）
        $userinfo = Db::table('yf_hf_member')->field(['nickname','phone'])->where('id',$id)->find();
        //查询出一级邀请过的用户信息
        $datas = Db::table('yf_hf_account_details')->field(['member_id','Recommend_member_id'])->where('member_id',$id)->where('type',3)->select();
        //首次循环
        for ($i=0;$i<count($datas);$i++){
            //查询出二级用户
            $res = Db::table('yf_hf_member')->field(['id','nickname','phone'])->where('id',$datas[$i]['Recommend_member_id'])->find();
            $results[$i]['name'] = $res['nickname'];
            $results[$i]['value']= $res['phone'];
            //查询出二级邀请过的用户信息
            $small_datas = Db::table('yf_hf_account_details')->field(['member_id','Recommend_member_id'])->where('member_id',$res['id'])->where('type',3)->select();
            //再次循环
            $small_results = array();
            for ($j=0;$j<count($small_datas);$j++){
                //查询出三级用户
                $small_res = Db::table('yf_hf_member')->field(['id','nickname','phone'])->where('id',$small_datas[$j]['Recommend_member_id'])->find();
                $small_results[$j]['name'] = $small_res['nickname'];
                $small_results[$j]['value']= $small_res['phone'];
            }
            $results[$i]['children'] =$small_results;
        }
        $dataes = array(
            "name" => $userinfo['nickname'],"value"=>$userinfo['phone'],
            "children" =>$results
        );
        $datas = json_encode($dataes);
        print_r($datas);
    }

    /**
     * 此用户邀请数量统计
     */
    public function inviteNum($userinfo){
        $data['onetothree'] = 0;
        $data['fourtosix'] = 0;
        $data['seventonine'] = 0;
        $data['tenplus'] = 0;
        foreach ($userinfo as $value){
            if ($value['member'] > 0 && $value['member'] <= 3){
                ++$data['onetothree'];
                continue;
            }elseif ($value['member'] > 3 && $value['member'] <= 6){
                ++$data['fourtosix'];
                continue;
            }elseif ($value['member'] > 6 && $value['member'] <= 9){
                ++$data['seventonine'];
                continue;
            }else{
                ++$data['tenplus'];
                continue;
            }
        }
        return $data;
    }
}