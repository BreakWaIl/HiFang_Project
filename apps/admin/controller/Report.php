<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/28
 * Time: 17:23
 */
namespace app\admin\controller;

use app\admin\controller\Admin;
use app\api\controller\Getui;
use app\api\untils\GeTuiUntils;
use app\common\model\AccountDetails;
use think\Db;

/**
 * Class Report
 * @package app\admin\controller
 */
class Report extends Admin{
    function _initialize()
    {
        parent::_initialize();

        $this->questionModel = model('common/Question');
        $this->reportModel = model('common/Report');
        $this->accountModel = model('common/AccountDetails');
    }

    /**
     * 举报列表
     * by zyt
     */
    public function index(){
        // 获取所有用户
        $info = Db::table('yf_hf_report')->alias('r')
                ->join('yf_hf_member m', 'm.id=r.member_id', 'left')
                ->field('r.id,r.member_id,r.video_id,r.content_id,r.status,r.create_time,r.update_time,m.nickname,m.phone')
                ->order('r.create_time desc')
                ->select();
        for ($i=0;$i<count($info);$i++) {
            $where = 'id in ('. $info[$i]['content_id'] .')';
            $content = Db::table('yf_hf_question')->where($where)->select();
            $contents = '';
            foreach ($content as $v) {
                $contents .= $v['id'].'.'.$v['title'];
            }
            $info[$i]['content'] = $contents;
        }

        $this->assign('info',$info);
        return view('index');
    }

    /**
     * 筛选举报列表
     * by zyt
     */
    public function search(){
        $nickname = $_POST['nickname'];
        $phone = $_POST['phone'];
        $id = $_POST['id'];
        $video_id = $_POST['video_id'];
        $start_time = strtotime($_POST['start']);
        $stop_time = strtotime($_POST['stop']) + 86400;
        $query = Db::table('yf_hf_report')->alias('r')
            ->join('yf_hf_member m', 'm.id=r.member_id', 'left')
            ->field('r.id,r.member_id,r.video_id,r.content_id,r.status,r.create_time,r.update_time,m.nickname,m.phone');
        if ($nickname) {
            $query = $query->where('m.nickname','like',"%$nickname%");
        }
        if ($phone) {
            $query = $query->where('m.phone','like',"%$phone%");
        }
        if ($start_time && $stop_time) {
            $query = $query->where('r.create_time','>',$start_time)->where('r.create_time','<',$stop_time);
        }
        if ($id) {
            $query = $query->where('r.id','like',"%$id%");
        }
        if ($video_id) {
            $query = $query->where('r.video_id','like',"%$video_id%");
        }

        $info = $query->select();
        for ($i=0;$i<count($info);$i++) {
            $where = 'id in ('. $info[$i]['content_id'] .')';
            $content = Db::table('yf_hf_question')->where($where)->select();
            $contents = '';
            foreach ($content as $v) {
                $contents .= $v['id'].'.'.$v['title'];
            }
            $info[$i]['content'] = $contents;
        }

        $this->assign('id',$id);
        $this->assign('start_time',$_POST['start']);
        $this->assign('stop_time',$_POST['stop']);
        $this->assign('nickname',$nickname);
        $this->assign('phone',$phone);
        $this->assign('id',$id);
        $this->assign('video_id',$video_id);
        $this->assign('info',$info);
        return view('index');
    }

    /**
     * 举报原因列表
     * @return [type] [description]
     * @date   2018-06-04
     * @author zyt
     */
    public function report_index(){
        // 获取列表
        $map = ['type'=>0];
        list($list,$total) = $this->questionModel->search('id|title')->getListByPage($map,true,'create_time desc');

        return builder('list')
            ->setMetaTitle('举报原因列表') // 设置页面标题
            ->addTopButton('addnew')  // 添加新增按钮
            ->addTopButton('delete')  // 添加删除按钮
            ->keyListItem('id','举报原因id','id')
            ->keyListItem('title','举报标题','title')
            ->keyListItem('create_time','创建时间','create_time')
            ->keyListItem('update_time','更新时间','update_time')
            ->keyListItem('right_button', '操作', 'btn')
            ->setListPrimaryKey('id')
            ->setListData($list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            ->addRightButton('edit')
            ->addRightButton('self', ['href'=>url('delete',['id'=>'__data_id__']),'title'=>'删除','icon'=>'fa fa-trash'])  // 添加编辑按钮
            ->fetch();
    }
    /**
     * 添加或编辑举报
     * @return [type] [description]
     * @date   2018-06-04
     * @author zyt
     */
    public function edit($id = 0) {
        $title = $id ? "编辑" : "新增";
        if (IS_POST) {
            $data = input('param.');
            $data['type'] = 0;
            $id  = isset($data['id']) && $data['id']>0 ? intval($data['id']) : false;
            if ($id>0) {
                $this->validateData($data,'Question.edit');
            } else{
                $data['id'] = 0;
                $this->validateData($data,'Question.add');
            }


            // 提交数据
            //$data里包含主键id，则editData就会更新数据，否则是新增数据
            $result = $this->questionModel->editData($data);

            if ($result) {
                if ($id==is_login()) {//如果是编辑状态下
                    logic('common/Question')->updateLoginSession($id);
                }
                $this->success($title.'成功', url('report_index'));
            } else {
                $this->error($this->questionModel->getError());
            }

        } else {
            $info=[];
            // 获取账号信息
            if ($id!=0) {
                $info = $this->questionModel->get($id);
            }

            $builder = builder('Form');
            $builder->setMetaTitle($title.'举报')  // 设置页面标题
                ->addFormItem('id', 'hidden', 'ID', '')
                ->addFormItem('title', 'text', '', '填写举报标题','','require');
            return $builder
                ->setFormData($info)
                ->addButton('submit')->addButton('back')    // 设置表单按钮
                ->fetch();
        }
    }


    /**举报详情
     * @param string $id
     * @return mixed
     */
    public function agree($id=''){
        /*if ($id!=0) {
            $info = Db::table('yf_hf_report')->alias('r')
                ->join('yf_hf_member m', 'm.id=r.member_id', 'left')
                ->field('r.id,r.member_id,r.video_id,r.content_id,r.status,r.create_time,r.update_time,m.nickname,m.phone')->find($id);
        }
        $builder = builder('Form');
        $builder->setMetaTitle('举报审核')  // 设置页面标题
            ->addFormItem('id', 'hidden', 'ID', '')
            ->addFormItem('nickname', 'onlyreadly', '', '举报人','','require')
            ->addFormItem('phone','onlyreadly', '', '举报人手机号','','require')
            ->addFormItem('video_id','onlyreadly', '', '视频id','','require')
            ->addFormItem('content', 'onlyreadly', '', '举报内容','','require')
            ->addFormItem('create_time', 'onlyreadly', '', '举报时间','','require');
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
                ->addButton('stop','未通过')
                ->addButton('back')    // 设置表单按钮
                ->fetch();
        }else{
            return $builder
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('look','审核通过',url('verify',['id'=>$id,'type'=>1]))
                ->addButton('look','审核不通过',url('verify',['id'=>$id,'type'=>1]))
                ->addButton('back')    // 设置表单按钮
                ->fetch();
        }*/
    }

    /**
     * 删除
     */
    public function delete ($id=0)
    {
        if (empty($id)) {
            $this->error('参数错误！');
        }

        $result = model('question')->where('id',$id)->delete();
        if($result){
            return $this->success('操作成功', url('report_index'));
        } else {
            return $this->error('操作失败', url('report_index'));
        }
    }

    /**举报审核
     * @param $id
     * @param $type 1审核通过 2审核不通过
     * @auther zyt
     */
    public function verify($id)
    {
        if (IS_POST){
            $id = $_POST['id'];
            $map = ['id'=>$id];
            $report = model('report')->where($map)->find();
            $type = $_POST['status'];
            if (!isset($_POST['reason'])) {
                $data = [
                    'status'      => $type,
                    'update_time' => time()
                ];
            } else {
                $data = [
                    'status'      => $type,
                    'reason'     => $_POST['reason'],
                    'update_time' => time()
                ];
            }
            if ($type == 1) {
                $res       = model('report')->where($map)->update($data);
                if (!$res) {
                    $this->error('审核失败！');
                }
                //明细表修改状态
                $where = [
                    'member_id'   => $report['member_id'],
                    'video_id'    => $report['video_id'],
                    'type'        => 7
                ];
                $res = $this->accountModel->where($where)->update(['status'=>$type,'update_time'=>time()]);
                //用户表修改余额
                $report_icon = Db::table('yf_config')->where('id',68)->value('value');
                $member = Db::table('yf_hf_member')->where('id',$report['member_id'])->find();
                $balance = $member['balance'] + $report_icon;
                $result = Db::table('yf_hf_member')->where('id',$report['member_id'])->update(['balance'=>$balance]);

                //推送信息
                $ge_tui = new GeTuiUntils();
                if ($result !== false) {
                    $data = '您的举报已被核实,请查看';//举报通过
                    //$rem = $getui->pushMessage($type=4,1,$report['member_id'],$data);
                    $device_id = DB::table('yf_hf_device')->where('member_id',$report['member_id'])->value('device_id');
                    //$device_id = '09f4817821e08139c910fc035bb680e5';
                    //$device_id = '09f4817821e08139c910fc035bb680e5';
                    $rem = $ge_tui->public_push_message_for_one(1,$device_id,'举报',$data,$type=4);
                    //推送记录存入task表
                    $arr = [
                        'id'           => 0,
                        'member_id'    => $report['member_id'],
                        'content'      => $data,
                        'type'         => 4,
                        'is_show'      => 0,
                        'create_time'  => time(),
                        'update_time'  => time()
                    ];
                    $res = Db::table('yf_hf_task')->insert($arr);
                    $this->success('审核成功,奖励积分'.$report_icon, url('index'));
                } else {
                    $this->error('审核失败！', url('index'));
                }
            } elseif($type == 2){
                $res       = model('report')->where($map)->update($data);
                if (!$res) {
                    $this->error('审核失败！');
                }
                //明细表修改状态
                $where = [
                    'member_id'   => $report['member_id'],
                    'video_id'    => $report['video_id'],
                    'type'        => 7
                ];
                $result = $this->accountModel->where($where)->update(['status'=>$type,'update_time'=>time()]);

                //推送信息
                $ge_tui = new GeTuiUntils();
                if ($result !== false) {
                    $data = '您的举报已被核实,请查看';//举报不通过
                    //$rem = $getui->pushMessage($type=4,1,$report['member_id'],$data);
                    $device_id = DB::table('yf_hf_device')->where('member_id',$report['member_id'])->value('device_id');
                    //$device_id = '09f4817821e08139c910fc035bb680e5';
                    //$device_id = '09f4817821e08139c910fc035bb680e5';
                    $rem = $ge_tui->public_push_message_for_one(1,$device_id,'举报',$data,$type=4);
                    //推送记录存入task表
                    $arr = [
                        'id'           => 0,
                        'member_id'    => $report['member_id'],
                        'content'      => $data,
                        'type'         => 4,
                        'is_show'      => 0,
                        'create_time'  => time(),
                        'update_time'  => time()
                    ];
                    $res = Db::table('yf_hf_task')->insert($arr);
                    $this->success('审核为不通过成功', url('index'));
                } else {
                    $this->error('审核失败！', url('index'));
                }
            }
        }

        $info = Db::table('yf_hf_report')->field('id,status,reason')->where('id',$id)->find();
        $this->assign('info',$info);
        return view('verify',['id'=>$id]);
    }

}