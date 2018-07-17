<?php
/**
 * Created by PhpStorm.
 * User: zfc
 * Date: 2018/4/15
 * Time: 17:02
 */

namespace app\admin\controller;

use app\api\controller\QiniuYun;
use app\api\controller\Tool;
use app\api\extend\QiniuTools;
use app\api\untils\GeTuiUntils;
use app\common\model\Video as VideoModel;
use phpDocumentor\Reflection\DocBlock\Tags\Var_;
use Qiniu\Auth;
use Qiniu\Storage\UploadManager;
use think\Db;
use think\Exception;
use think\Log;
use think\Request;

/*
 * 视频管理
 */
class Video extends Admin
{
    public  $videoModel;
    public  $videoFiveModel;

    function _initialize()
    {
        parent::_initialize();

        $this->videoModel = model('common/Video');
        $this->videoFiveModel = model('common/Videofive');
    }
    /**
     * 视频列表
     * @return [type] [description]
     * @date   2018-04-13
     * @author zyt
     */
    /*public function index(){
        // 获取视频列表
        $map = [];
        //list($list,$total) = $this->videoModel->search('id|title|video_type|status')->getListByPage($map,true,'create_time desc');

        $alias = 'v';
        $join = 'yf_hf_member m';
        $condition = 'm.id=v.member_id';
        $type = 'left';
        $field = 'v.id,v.member_id,v.building_id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_room,v.num_hall,v.area,v.price,v.create_time,v.update_time,m.nickname,m.phone';
        $like = 'v.id|m.phone|m.nickname';
        list($list,$total) = $this->videoModel->getListByPages($alias,$join,$condition,$like,$type,$map,$field,'v.create_time desc');

        return builder('list')
            ->setMetaTitle('视频列表') // 设置页面标题
            ->addTopButton('addnew')  // 添加新增按钮
            //->addTopButton('delete')  // 添加删除按钮
            ->keyListItem('id','视频','id')
            ->keyListItem('title','视频标题','title')
            ->keyListItem('video_type','视频类型','array',[0=>'出租',1=>'出售'])
            ->keyListItem('video_cover', '视频封面', 'image')
            ->keyListItem('status','是否上架下架','array',[0=>'下架',1=>'上架'])
            ->keyListItem('num_room','几室','num_room')
            ->keyListItem('num_hall','几厅','num_hall')
            ->keyListItem('area','面积','area')
            ->keyListItem('price','房价','price')
            ->keyListItem('nickname','用户昵称','nickname')
            ->keyListItem('phone','用户手机号','phone')
            ->keyListItem('create_time','创建时间','create_time')
            ->keyListItem('update_time','更新时间','update_time')
            ->keyListItem('right_button', '操作', 'btn')
            ->setListPrimaryKey('id')
            ->setListData($list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            ->addRightButton('self',['href'=>url('detail',['id'=>'__data_id__']),'title'=>'观看视频','icon'=>'fa fa-video-camera'])
            ->addRightButton('self',['href'=>url('imgDetail',['id'=>'__data_id__']),'title'=>'查看户型图','icon'=>'fa fa-file-image-o'])
            ->addRightButton('self',['href'=>url('downVideo',['id'=>'__data_id__']),'title'=>'下架视频','icon'=>'fa fa-arrow-down'])
            ->addRightButton('restore')
            ->addRightButton('edit')
            ->addRightButton('deleteVideo')  // 添加编辑按钮
            ->fetch();
    }*/

    /**
     * 视频列表
     * @return [type] [description]
     * @date   2018-04-20
     * @author zyt
     */
    public function index(){
        // 获取所有视频列表
        $info = Db::table('yf_hf_video')->alias('v')
            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
            ->field('v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.examine,v.is_delete,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.member_id,v.create_time,v.update_time,b.name,m.nickname,m.hiid,m.phone,m.is_robot')
            ->where('v.is_delete',0)
            ->order('v.id','desc')
            ->paginate(12);

        $this->assign('info',$info);
        return view('index');
    }

    /**
     * 视频待审核列表
     * @return [type] [description]
     * @date   2018-06-25
     * @author zyt
     */
    public function verifyList(){
        // 获取所有视频列表
        $info = Db::table('yf_hf_video')->alias('v')
            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
            ->field('v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.is_delete,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.member_id,v.create_time,v.update_time,b.name,m.nickname,m.phone,m.is_robot,m.hiid')
            ->where('v.examine',0)
            ->where('v.is_delete',0)
            ->where('m.is_robot',0)
            ->paginate(12);

        $this->assign('info',$info);
        return view('index');
    }



    /**
     * 筛选视频列表
     * by zyt
     */
    public function search(){
        $hiid = $_POST['hiid']?$_POST['hiid']:'';
        $phone = $_POST['phone']?$_POST['phone']:'';
        $status = $_POST['status']?$_POST['status']:'';
        $nickname = $_POST['nickname']?$_POST['nickname']:'';
        $start_time = strtotime($_POST['start']);
        $stop_time = strtotime($_POST['stop']) + 86400;
        $title = $_POST['title']?$_POST['title']:'';
        $building_name = $_POST['name']?$_POST['name']:'';


        $query = Db::table('yf_hf_video')->alias('v')
            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
            ->field('v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.examine,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.member_id,v.create_time,v.update_time,b.name,m.nickname,m.hiid,m.phone,m.is_robot')
            ->where('v.is_delete',0);
        if ($phone) {
            $query = $query->where('m.phone','like',"%$phone%");
        }
        if ($start_time && $stop_time) {
            $query = $query->where('v.create_time','>',$start_time)->where('v.create_time','<',$stop_time);
        }
        if ($hiid) {
            $query = $query->where('m.hiid','like',"%$hiid%");
        }
        if ($nickname) {
            $query = $query->where('m.nickname','like',"%$nickname%");
        }
        if ($title) {
            $query = $query->where('v.title','like',"%$title%");
        }
        if ($status == 0 || $status == 1) {
            $query = $query->where('v.status',$status);
        }
        if ($building_name) {
            $query = $query->where('b.name','like',"%$building_name%");
        }


        $info = $query->paginate(12);
        $this->assign('hiid',$hiid);
        $this->assign('nickname',$nickname);
        $this->assign('title',$title);
        $this->assign('start_time',$_POST['start']);
        $this->assign('stop_time',$_POST['stop']);
        $this->assign('phone',$phone);
        $this->assign('status',$status);
        $this->assign('building_name',$building_name);
        $this->assign('info',$info);
        return view('index');
    }

    /**
     * detailtongji search
     * 视频详情页统计搜索
     * by liyang
     */
    public function searchdetailtongji(){
        $hiid = isset($_POST['hiid'])?$_POST['hiid']:'';
        $start_time = strtotime(isset($_POST['start']));
        $stop_time = strtotime(isset($_POST['stop'])) + 86400;
        $building_name = isset($_POST['name'])?$_POST['name']:'';

        $query = Db::table('yf_hf_video')->alias('v')
            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
            ->join('yf_hf_behavior h','h.video_id = v.id','left')
            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
            ->field('v.id,m.hiid,v.title,b.`name`,m.`hiid`,count(case when type=6 then type end) begin_watch ,count(case when type=7 then type end) all_watch,count(case when type=8 then type end) top ,count(case when type=9 then type end) review ,count(case when type=10 then type end) forward ,count(case when type=11 then type end) entervillage ,count(case when type=12 then type end) enterauthor')
            ->where('v.is_delete',0)->group('v.id');
        if ($start_time && $stop_time) {
            $query = $query->where('v.create_time','>',$start_time)->where('v.create_time','<',$stop_time);
        }
        if ($hiid) {
            $query = $query->where('m.hiid','like',"%$hiid%");
        }
        if ($building_name) {
            $query = $query->where('b.name','like',"%$building_name%");
        }
        if ($start_time && $stop_time) {
            $query = $query->where('v.create_time','>',$start_time)->where('v.create_time','<',$stop_time);
        }

        $info = $query->paginate(12);
        $this->assign('hiid',$hiid);
        $this->assign('start_time',isset($_POST['start']));
        $this->assign('stop_time',isset($_POST['stop']));
        $this->assign('building_name',$building_name);
        $this->assign('info',$info);
        return view('detailtongji');
    }

    /**
     * detailpublishtongji search
     * 视频发布流程统计搜索
     * by liyang
     */
    public function searchdetailpublishtongji()
    {
        Log::info("====== searchdetailpublishtongji ========");
        $hiid = isset($_POST['hiid'])?$_POST['hiid']:'';
        $nickname = isset($_POST['nickname'])?$_POST['nickname']:'';
        $start_time = strtotime(isset($_POST['start']));
        $stop_time = strtotime(isset($_POST['stop'])) + 86400;
        Log::info(input('post.'));
        $query = Db::table('yf_hf_behavior')
            ->alias('b')
            ->join('yf_hf_member m','b.userid=m.id','left')
            ->field('b.userid id, m.hiid,m.nickname,count(case when type=1 then type end) click_publish ,count(case when type=2 then type end) add_music ,count(case when type=3 then type end) add_cover ,count(case when type=4 then type end) add_info ,count(case when type=5 then type end) success_publish')
//            ->where("b.userid!=0 and b.create_time BETWEEN '{$start_time}' AND '{$stop_time}'")
            ->where("b.userid!=0 and b.create_time")
            ->group("b.userid");
        Log::info("====== search1 ========");
        if ($start_time && $stop_time) {
            $query = $query->where('m.create_time','>',$start_time)->where('m.create_time','<',$stop_time);
        }
        if ($hiid) {
            $query = $query->where('m.hiid','like',"%$hiid%");
        }
        if ($nickname) {
            $query = $query->where('m.nickname','like',"%$nickname%");
        }

        Log::info("====== search2 ========");
        $info = $query->paginate(20,false,['query'=>Request::instance()->param()]);
        $this->assign('hiid',$hiid);
        $this->assign('nickname',$nickname);
        $this->assign('start_time',isset($_POST['start']));
        $this->assign('stop_time',isset($_POST['stop']));
        $this->assign('info',$info);
        return view('detailpublishtongji');
    }

    /**
     * detailrepaytongji search
     * 视频转发统计搜索
     * by liyang
     */
    public function searchdetailrepaytongji()
    {
        $title = isset($_POST['title'])?$_POST['title']:'';
        $name = isset($_POST['name'])?$_POST['name']:'';
        $start_time = strtotime(isset($_POST['start']));
        $stop_time = strtotime(isset($_POST['stop'])) + 86400;

        $query = Db::table('yf_hf_behavior')
            ->alias('h')
            ->join('yf_hf_video v','v.id = h.video_id')
            ->join('yf_hf_buildings b','b.id = v.building_id')
            ->field('v.id,v.title,b.`name`,v.create_time,count(case when h.type=10 then h.type end) repay_video ,count(case when h.type=14 then h.type end) enter_web ,count(case when h.type=15 then h.type end) click_play ,count(case when h.type=16 then h.type end) palyend ,count(case when h.type=17 then h.type end) download')
            ->where("v.building_id = b.id and h.video_id = v.id and v.create_time")
            ->group("v.id");
        if ($start_time && $stop_time) {
            $query = $query->where('b.create_time','>',$start_time)->where('b.create_time','<',$stop_time);
        }
        if ($title) {
            $query = $query->where('v.title','like',"%$title%");
        }
        if ($name) {
            $query = $query->where('b.name','like',"%$name%");
        }


        $info = $query->paginate(20,false,['query'=>Request::instance()->param()]);
        $this->assign('title',$title);
        $this->assign('name',$name);
        $this->assign('start_time',isset($_POST['start']));
        $this->assign('stop_time',isset($_POST['stop']));
        $this->assign('info',$info);
        return view('detailrepaytongji');
    }

    /**
     * 视频回收站列表
     * @return [type] [description]
     * @date   2018-06-13
     * @author zyt
     */
    public function trash(){
        // 获取所有视频列表
        $info = Db::table('yf_hf_video')->alias('v')
            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
            ->field('v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.examine,v.is_delete,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.member_id,v.create_time,v.update_time,b.name,m.nickname,m.hiid,m.phone,m.is_robot')
            ->where('v.is_delete',1)
            ->order('v.id','desc')
            ->paginate(12);

        $this->assign('info',$info);
        return view('trash');
    }
    /**
     * 筛选视频回收站视频列表
     * by zyt
     */
    public function searchTrash(){
        $hiid = $_POST['hiid'];
        $phone = $_POST['phone'];
        $nickname = $_POST['nickname'];
        $title = $_POST['title'];
        $building_name = $_POST['name'];

        $query = Db::table('yf_hf_video')->alias('v')
            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
            ->field('v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.examine,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.member_id,v.create_time,v.update_time,b.name,m.nickname,m.hiid,m.phone,m.is_robot')
            ->where('v.is_delete',1);
        if ($phone) {
            $query = $query->where('m.phone','like',"%$phone%");
        }
        if ($hiid) {
            $query = $query->where('m.hiid','like',"%$hiid%");
        }
        if ($nickname) {
            $query = $query->where('m.nickname','like',"%$nickname%");
        }
        if ($title) {
            $query = $query->where('v.title','like',"%$title%");
        }
        if ($building_name) {
            $query = $query->where('b.name','like',"%$building_name%");
        }


        $info = $query->paginate(12);
        $this->assign('hiid',$hiid);
        $this->assign('nickname',$nickname);
        $this->assign('title',$title);
        $this->assign('phone',$phone);
        $this->assign('building_name',$building_name);
        $this->assign('info',$info);
        return view('trash');
    }


    /**删除评论
     * @param string $id
     * @return mixed
     * @auther zyt
     */
    public function delete($id=0){
        if (empty($id)) {
            $this->error("非法操作!", '');
        }
        $video = model('video')->where('id',$id)->find();

        if ($video) {
            //删除七牛云视频和封面图
            $video_url = $video['video_link'];
            $img_url   = $video['video_cover'];
            $videoUrl  = explode('/', $video_url);
            $imgUrl    = explode('/', $img_url);
            //视频key
            $videoKey  = $videoUrl[count($videoUrl)-1];
            //封面图key
            $imgKey    = $imgUrl[count($imgUrl)-1];
            QiniuTools::delete($videoKey);
            QiniuTools::delete($imgKey);
            $result = model('video')->where('id',$id)->update(['is_delete'=>1]);
            //删除图片
            $del = Db::table('yf_hf_imgs')->where('video_id',$id)->delete();
            //更新发布数setDec
            $update_member = Db::table('yf_hf_member')->where('id',$video['member_id'])->setDec('num_publish');
            //删除账单详情表记录
            $account_detail = Db::table('yf_hf_account_details')->where('video_id',$id)->update(['status'=>2]);
            //给用户发送删除推送
            $content = '您发布的视频不符合平台要求,已被管理员删除';
            $arr = [
                'id'           => 0,
                'member_id'    => $video['member_id'],
                'content'      => $content,
                'type'         => 21,
                'is_show'      => 0,
                'create_time'  => time(),
                'update_time'  => time()
            ];
            $res = Db::table('yf_hf_task')->insert($arr);
            $device_id = Db::table('yf_hf_device')->where('member_id',$video['member_id'])->value('device_id');
            $ge_tui = new GeTuiUntils();
            Log::info('=======video/delete/GeTuiUntils=======');
            $ge_tui->public_push_message_for_one(1,$device_id,'删除',$content,$type=21);
            Log::info('=======video/delete/public_push_message_for_one=======');
            /*//关注表里面的数据(关注点赞该视频的数据)
            $follow = Db::table('yf_hf_follow')->where(['type'=>2,'followed_id'=>$id,'is_followed'=>1])->select();
            if ($follow) {
                for ($i=0;$i<count($follow);$i++) {
                    //更新yf_hf_member表
                    if ($follow[$i]['member_id'] == $video['member_id']) {
                        //更新发布数setDec和获赞数和点赞视频数
                        $member = Db::table('yf_hf_member')->where('id',$video['member_id'])->find();
                        $num_publish = $member['num_publish'] - 1;
                        $num_prise = $member['num_prise'] - count($follow);
                        $num_good_video = $member['num_good_video'] - 1;
                        $update_member = Db::table('yf_hf_member')->where('id',$video['member_id'])->update(['num_publish'=>$num_publish,'num_prise'=>$num_prise,'num_good_video'=>$num_good_video]);
                    } else {
                        $update_member = Db::table('yf_hf_member')->where('id',$follow[$i]['member_id'])->setDec('num_good_video');
                    }
                    //删除yf_hf_follow表
                    $update_follow = Db::table('yf_hf_follow')->where(['type'=>2,'followed_id'=>$id])->delete();
                }
            } else {
                //更新发布数setDec
                $update_member = Db::table('yf_hf_member')->where('id',$video['member_id'])->setDec('num_publish');
            }*/
            if ($result) {
                $this->success('删除成功，不可恢复！',url('index'));
            } else {
                $this->error('删除失败',url('index'));
            }
        } else {
            $this->error('该数据不存在,请重试');
        }
    }

    /**视频回收站列表中的彻底删除删除评论
     * @param string $id
     * @return mixed
     * @auther zyt
     */
    public function deleteVideo($id=0){
        if (empty($id)) {
            $this->error("非法操作!", '');
        }
        $video = model('video')->where('id',$id)->find();

        if ($video) {
            //删除七牛云视频和封面图
            $video_url = $video['video_link'];
            $img_url   = $video['video_cover'];
            $videoUrl  = explode('/', $video_url);
            $imgUrl    = explode('/', $img_url);
            //视频key
            $videoKey  = $videoUrl[count($videoUrl)-1];
            //封面图key
            $imgKey    = $imgUrl[count($imgUrl)-1];
            QiniuTools::delete($videoKey);
            QiniuTools::delete($imgKey);
            $result = model('video')->where('id',$id)->delete();
            //关注表里面的数据(关注点赞该视频的数据)
            $follow = Db::table('yf_hf_follow')->where(['type'=>2,'followed_id'=>$id,'is_followed'=>1])->select();
            if ($follow) {
                for ($i=0;$i<count($follow);$i++) {
                    //更新yf_hf_member表
                    if ($follow[$i]['member_id'] == $video['member_id']) {
                        //更新发布数setDec和获赞数和点赞视频数
                        $member = Db::table('yf_hf_member')->where('id',$video['member_id'])->find();
                        //$num_publish = $member['num_publish'] - 1;
                        $num_prise = ($member['num_prise'] - count($follow)) < 0 ? 0 : ($member['num_prise'] - count($follow));
                        $num_good_video = ($member['num_good_video'] - 1) < 0 ? 0 : ($member['num_good_video'] - 1);
                        $update_member = Db::table('yf_hf_member')->where('id',$video['member_id'])->update(['num_prise'=>$num_prise,'num_good_video'=>$num_good_video]);
                    } else {
                        $update_member = Db::table('yf_hf_member')->where('id',$follow[$i]['member_id'])->setDec('num_good_video');
                    }
                    //删除yf_hf_follow表
                    $update_follow = Db::table('yf_hf_follow')->where(['type'=>2,'followed_id'=>$id])->delete();
                }
            }
            if ($result) {
                $this->success('删除成功，不可恢复！');
            } else {
                $this->error('删除失败');
            }
        } else {
            $this->error('该数据不存在,请重试');
        }
    }

    /**
     * 添加或编辑视频
     * * @return [type] [description]
     * @date   2018-04-16
     * @author zyt
     */
    public function edit($id = 0) {
        $title = $id ? "编辑" : "新增";
        if (IS_POST) {
            $data = input('param.');

            $id  = isset($data['id']) && $data['id']>0 ? intval($data['id']) : false;
            if ($id>0) {
                $this->validateData($data,'Video.edit');
            } else{
                $this->validateData($data,'Video.add');
            }


            // 提交数据
            //$data里包含主键id，则editData就会更新数据，否则是新增数据
            $result = $this->videoModel->editData($data);

            if ($result) {
                if ($id==is_login()) {//如果是编辑状态下
                    logic('common/Video')->updateLoginSession($id);
                }
                $this->success($title.'成功', url('index'));
            } else {
                $this->error($this->videoModel->getError());
            }

        } else {
            $info=[];
            // 获取账号信息
            if ($id!=0) {
                $info = $this->videoModel->get($id);
                //unset($info['member_id']);
            }

            $builder = builder('Form');
            $builder->setMetaTitle($title.'关注')  // 设置页面标题
            ->addFormItem('id', 'hidden', 'ID', '')
                ->addFormItem('title', 'text', '', '填写视频标题','','require')
                ->addFormItem('video_link', 'text', '', '填写视频链接','','require')
                ->addFormItem('video_type', 'text', '', '填写视频类型','','require')
                ->addFormItem('video_cover','text', '', '填写视频封面','','require')
                ->addFormItem('status','text', '', '选择是否上架下架','','require')
                ->addFormItem('sort','text', '', '排序','','require')
                ->addFormItem('num_room','text', '', '几室','','require')
                ->addFormItem('num_hall','text', '', '几厅','','require')
                ->addFormItem('area','text', '', '面积','','require')
                ->addFormItem('price','text', '', '房价','','require')
                ->addFormItem('member_id','text', '', '用户id','','require')
                ->addFormItem('app_version','text', '', '用户当前版本','','require')
                ->addFormItem('remarks','text', '', '个人备注','');
            return $builder
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('submit')->addButton('back')    // 设置表单按钮
                ->fetch();
        }
    }

    /**
     * 批量删除视频
     * by songjian
     */
    public function deleteAll($deletenum){
        $video_id = explode(',',$deletenum);
        Db::startTrans();
        try{
            foreach ($video_id as $value){
                $video = model('video')->where('id',$value)->find();
                //删除七牛云视频和封面图
                $video_url = $video['video_link'];
                $img_url   = $video['video_cover'];
                $videoUrl  = explode('/', $video_url);
                $imgUrl    = explode('/', $img_url);
                //视频key
                $videoKey  = $videoUrl[count($videoUrl)-1];
                //封面图key
                $imgKey    = $imgUrl[count($imgUrl)-1];
                QiniuTools::delete($videoKey);
                QiniuTools::delete($imgKey);
                $result = model('video')->where('id',$value)->update(['is_delete'=>1]);
                //删除图片
                $del = Db::table('yf_hf_imgs')->where('video_id',$value)->delete();
                //更新发布数setDec
                $update_member = Db::table('yf_hf_member')->where('id',$video['member_id'])->setDec('num_publish');
                //删除账单详情表记录
                $account_detail = Db::table('yf_hf_account_details')->where('video_id',$value)->update(['status'=>2]);

            }
            $data['status'] = 1;
            $data['message'] = "删除成功";
            Db::commit();
        }catch (Exception $exception){
            Db::rollback();
            $data['status'] = 0;
            $data['message'] = "删除失败";
        }
        return $data;
    }

    /**
     * 查看视频
     * @author zyt
     */
    public function detail($id = 0) {
        $this->assign('meta_title','观看视频');
        //$url = $_SERVER['HTTP_HOST'];
        $http_referer = $_SERVER['HTTP_REFERER'];
        //dump(strrpos($http_referer, '/'));exit;
        //$http_referer = 'https://hifang.fujuhaofang.com/admin.php/admin/video/index';
        $url = substr($http_referer, 0, strrpos($http_referer, '/')) . '/';

        if (empty($id)) {
            $this->error('参数错误！');
        }
        $info = Db::table('yf_hf_video')->alias('v')
            ->join('yf_hf_buildings b','b.id=v.building_id')
            ->field('v.id,v.video_link,v.building_id,b.name,b.address')->where('v.id',$id)->find();
        $this->assign('info',$info);
        $this->assign('url',$url);
        return $this->fetch();
    }
    /**
     * 修改视频对应的小区名
     * @auther zyt
     */
    public function updateBuildingName($video_id,$area_id,$building_id){
        $result = Db::table('yf_hf_video')->where('id',$video_id)->update(['area_id'=>$area_id,'building_id'=>$building_id]);
        return $result;
    }


    /**
     * 查看户型图
     * @author zyt
     */
    public function imgDetail($id = 0) {
        $this->assign('meta_title','查看户型图');
        if (empty($id)) {
            $this->error('参数错误！');
        }
        $file_list = Db::table('yf_hf_imgs')->where('video_id',$id)->select();
        $imgs = [];
        $website = Tool::getDomain();
        foreach ($file_list as $list) {
            $create_time = Db::table('yf_hf_imgs')->field('create_time')->where('id',$list['id'])->select()[0]['create_time'];
            $timearr = explode(" ",$create_time);
            $time = str_replace('-','',$timearr[0]);
            $imgs[] = [
                'id'         => $list['id'],
                'image_name' => $website . '/uploads/img/'. $time . '/' . ($list['image_name']),
            ];
        }
        $this->assign('image_list_data',$imgs);//列表数据
        return $this->fetch();
    }

    /**
     * 视频下架
     * @auther zyt
     */
    public function downVideo($id=0)
    {
        if (empty($id)) {
            $this->error('参数错误！');
        }
        $video = model('video')->where('id',$id)->find();
        if ($video['status'] == 0){
            $result = model('video')->where('id',$id)->update(['status'=>1]);
        } elseif ($video['status'] == 1) {
            $result = model('video')->where('id',$id)->update(['status'=>0]);
        }
        if($result){
            return $this->success('操作成功', url('index'));
        } else {
            return $this->error('操作失败', url('index'));
        }
    }

    /**
     * 视频详情页统计
     * by songjian
     */
    public function tongji(){
        $timegap = input('timegap');
        if($timegap){
            $gap = explode('—', $timegap);
            $begin = $gap[0];
            $end = $gap[1];
        }else{
            $lastweek = date('Y-m-d',strtotime("-1 month"));//30天前
            $begin = input('begin',$lastweek);
            $end =  input('end',date('Y-m-d'));
        }
        $this->assign('timegap',$begin.'—'.$end);
        $this->assign('meta_title','视频详情页统计');
        $begin = strtotime($begin);
        $end = strtotime($end)+86399;
        $today = strtotime(date('Y-m-d'));
        $month = strtotime(date('Y-m-01'));

        $user = [
            'today'      => $this->videoModel->where("create_time>$today")->count(),//今日发布视频
            'month'      => $this->videoModel->where("create_time>$month")->count(),//本月新增视频
            'total'      => $this->videoModel->count(),//视频总数
        ];
        $this->assign('user',$user);

        //开始观看
        $begin_watch = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',6)->count();
        //完整观看
        $all_watch = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',7)->count();
        //点赞视频
        $top = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',8)->count();
        //评论视频
        $review = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',9)->count();
        //转发视频
        $forward  = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',10)->count();
        //进入小区主页
        $entervillage = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',11)->count();
        //进入ta个人主页
        $enterauthor = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',12)->count();
        $brr[0] = $begin_watch;
        $brr[1] = $all_watch;
        $brr[2] = $top;
        $brr[3] = $review;
        $brr[4] = $forward;
        $brr[5] = $entervillage;
        $brr[6] = $enterauthor;
        $result = array('data'=>$brr);
        $this->assign('result',json_encode($result));
        return $this->fetch();
    }

    /**
     * 视频详情页详情统计
     * by songjian
     */
//    public function detailtongji($time){
//        $times = $time;
//        $time = explode('—',$time);
//        $start_time = strtotime($time[0]);
//        $stop_time = strtotime($time[1])+86400;
//        $paged     = input('param.paged',1);//分页值
//        $page_size = input('param.page_size') ? (int)input('param.page_size') :(int)config('admin_page_size');
//        $page = ($paged-1)*$page_size;
//        $sql =  "select v.id,m.hiid,v.title,b.`name`,count(case when type=6 then type end) begin_watch ,count(case when type=7 then type end) all_watch,count(case when type=8 then type end) top ,count(case when type=9 then type end) review ,count(case when type=10 then type end) forward ,count(case when type=11 then type end) entervillage ,count(case when type=12 then type end) enterauthor from (((`yf_hf_video` as v left join `yf_hf_buildings` as b on v.building_id = b.id) left join  `yf_hf_behavior` as h on h.video_id = v.id) left join `yf_hf_member` as m on v.member_id=m.id) WHERE v.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP BY v.id limit $page,$page_size";
//        $sqls = "select v.id,m.hiid,v.title,b.`name`,count(case when type=6 then type end) begin_watch ,count(case when type=7 then type end) all_watch,count(case when type=8 then type end) top ,count(case when type=9 then type end) review ,count(case when type=10 then type end) forward ,count(case when type=11 then type end) entervillage ,count(case when type=12 then type end) enterauthor from (((`yf_hf_video` as v left join `yf_hf_buildings` as b on v.building_id = b.id) left join  `yf_hf_behavior` as h on h.video_id = v.id) left join `yf_hf_member` as m on v.member_id=m.id) WHERE v.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP BY v.id";
//        //$sql = "select v.id,v.title,b.`name`,count(case when type=6 then type end) begin_watch ,count(case when type=7 then type end) all_watch,count(case when type=8 then type end) top ,count(case when type=9 then type end) review ,count(case when type=10 then type end) forward ,count(case when type=11 then type end) entervillage ,count(case when type=12 then type end) enterauthor from (`yf_hf_video` as v INNER JOIN `yf_hf_buildings` as b on v.building_id=b.id) LEFT JOIN `yf_hf_behavior` as h ON v.member_id=h.userid where v.building_id = b.id and h.video_id = v.id and v.create_time BETWEEN '{$start_time}' AND '{$stop_time}'";
//        $list = Db::query($sql);
//        $lists = Db::query($sqls);
//        if (empty($list)){
//            $list = null;
//        }
//        $total = count($lists);
//
//        $back = [
//            'title'=>'返回',
//            'href'=>url('tongji')
//        ];
//
//        return builder('list')
//            ->setMetaTitle('单个视频详情统计') // 设置页面标题
//            ->addTopButton('self',['title'=>"查询日期{$times}"])  // 添加新增按钮
//            ->addTopButton('self',$back)  // 添加新增按钮
//            ->keyListItem('id','视频ID','id')
//            ->keyListItem('hiid','用户hiid','hiid')
//            ->keyListItem('title','所在小区','title')
//            ->keyListItem('begin_watch','开始观看','begin_watch')
//            ->keyListItem('all_watch','完整观看','all_watch')
//            ->keyListItem('top','点赞','top')
//            ->keyListItem('review','评论','review')
//            ->keyListItem('forward','转发','forward')
//            ->keyListItem('entervillage','进入小区','entervillage')
//            ->keyListItem('enterauthor','进入TA主页','enterauthor')
//            ->setListPrimaryKey('id')
//            ->setListData($list)    // 数据列表
//            ->setListPage($total) // 数据列表分页
//            ->fetch();
//    }

    /**
     * 视频详情页统计
     * by liyang
     */
    public function detailtongji($time){
        $times = $time;
        $time = explode('—',$time);
        $start_time = strtotime($time[0]);
        $stop_time = strtotime($time[1])+86400;
        $paged     = input('param.paged',1);//分页值
        $page_size = input('param.page_size') ? (int)input('param.page_size') :(int)config('admin_page_size');
        $page = ($paged-1)*$page_size;
        $sql =  "select v.id,m.hiid,v.title,b.`name`,count(case when type=6 then type end) begin_watch ,count(case when type=7 then type end) all_watch,count(case when type=8 then type end) top ,count(case when type=9 then type end) review ,count(case when type=10 then type end) forward ,count(case when type=11 then type end) entervillage ,count(case when type=12 then type end) enterauthor from (((`yf_hf_video` as v left join `yf_hf_buildings` as b on v.building_id = b.id) left join  `yf_hf_behavior` as h on h.video_id = v.id) left join `yf_hf_member` as m on v.member_id=m.id) WHERE v.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP BY v.id limit $page,$page_size";
        $sqls = "select v.id,m.hiid,v.title,b.`name`,count(case when type=6 then type end) begin_watch ,count(case when type=7 then type end) all_watch,count(case when type=8 then type end) top ,count(case when type=9 then type end) review ,count(case when type=10 then type end) forward ,count(case when type=11 then type end) entervillage ,count(case when type=12 then type end) enterauthor from (((`yf_hf_video` as v left join `yf_hf_buildings` as b on v.building_id = b.id) left join  `yf_hf_behavior` as h on h.video_id = v.id) left join `yf_hf_member` as m on v.member_id=m.id) WHERE v.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP BY v.id";
        //$sql = "select v.id,v.title,b.`name`,count(case when type=6 then type end) begin_watch ,count(case when type=7 then type end) all_watch,count(case when type=8 then type end) top ,count(case when type=9 then type end) review ,count(case when type=10 then type end) forward ,count(case when type=11 then type end) entervillage ,count(case when type=12 then type end) enterauthor from (`yf_hf_video` as v INNER JOIN `yf_hf_buildings` as b on v.building_id=b.id) LEFT JOIN `yf_hf_behavior` as h ON v.member_id=h.userid where v.building_id = b.id and h.video_id = v.id and v.create_time BETWEEN '{$start_time}' AND '{$stop_time}'";
        $info = Db::table('yf_hf_video')
            ->alias('v')
            ->join('yf_hf_buildings b','v.building_id = b.id','left')
            ->join('yf_hf_behavior h','h.video_id = v.id','left')
            ->join('yf_hf_member m','v.member_id=m.id','left')
            ->field('v.id,m.hiid,v.title,b.`name`,count(case when type=6 then type end) begin_watch ,count(case when type=7 then type end) all_watch,count(case when type=8 then type end) top ,count(case when type=9 then type end) review ,count(case when type=10 then type end) forward ,count(case when type=11 then type end) entervillage ,count(case when type=12 then type end) enterauthor')
            ->where("v.create_time BETWEEN '{$start_time}' AND '{$stop_time}'")
            ->group('v.id')
            ->paginate(10);
//        dump($info);exit;
        $this->assign('info',$info);
        return view('detailtongji');
//        $list = Db::query($sql);
//        $lists = Db::query($sqls);
//        if (empty($list)){
//            $list = null;
//        }
//        $total = count($lists);
//
//        $back = [
//            'title'=>'返回',
//            'href'=>url('tongji')
//        ];
//
//        $this->assign('info',$lists);
//        return view('detailtongji');
    }

    /**
     * 筛选用户
     * by songjian
     */
//    public function searchMsg(Request $req){
//        $nickname = $req->param('nickname');
//        $hiid = $req->param('hiid');
//        $phone = $req->param('phone');
//        $title = $req->param('title');
//        $start_time = strtotime($req->param('start'));
//        $stop_time = strtotime($req->param('stop'));
//
//        //echo $start_time,$stop_time;exit;
//        $query = Db::table('yf_hf_member')
//            ->alias('m')
//            ->join('yf_hf_account_details d','m.id = d.member_id','left')
//            ->field(['m.*,sum(case when d.type=1 or d.type=2 or d.type=3 or d.type=6 or d.type=7 or d.type=8 then d.money end) have,sum(case when d.type=4 or d.type=5 then d.money end) forward'])
//            ->where('m.is_robot',0);
//
//        if ($phone) {
//            $query = $query->where('m.phone','like',"%$phone%");
//        }
//        if ($nickname) {
//            $query = $query->where('m.nickname','like',"%$nickname%");
//        }
//        if ($hiid) {
//            $query = $query->where('m.hiid','like',"%$hiid%");
//        }
//
//        if ($start_time || $stop_time) {
//            $query = $query->where('m.create_time','>',$start_time)->where('m.create_time','<',$stop_time+86400);
//        }
//        $info = $query->group('m.id')->paginate(20);
//
//        $this->assign('nickname',$nickname);
//        $this->assign('hiid',$hiid);
//        $this->assign('start_time',$req->param('start'));
//        $this->assign('stop_time',$req->param('stop'));
//        $this->assign('phone',$phone);
//        $this->assign('title',$title);
//        $this->assign('info',$info);
//        return view('detailtongji');
//    }
    /**
     * 视频发布流程统计
     * by songjian
     */
    public function publishtongji(){
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
        $this->assign('meta_title','视频详情页统计');

        $today = strtotime(date('Y-m-d'));
        $month = strtotime(date('Y-m-01'));

        $user = [
            'today'      => $this->videoModel->where("create_time>$today")->count(),//今日发布视频
            'month'      => $this->videoModel->where("create_time>$month")->count(),//本月新增视频
            'total'      => $this->videoModel->count(),//视频总数
        ];
        $this->assign('user',$user);

        //点击发布按钮
        $click_publish = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',1)->count();
        //添加音乐
        $add_music = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',2)->count();
        //添加封面
        $add_cover = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',3)->count();
        //添加房源信息
        $add_info = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',4)->count();
        //成功发布
        $success_publish  = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',5)->count();
        $brr[0] = $click_publish;
        $brr[1] = $add_music;
        $brr[2] = $add_cover;
        $brr[3] = $add_info;
        $brr[4] = $success_publish;
        $result = array('data'=>$brr);
        $this->assign('result',json_encode($result));
        return $this->fetch();
    }

    /**
     * 视频发布流程详情统计
     * by songjian
     */

    public function detailpublishtongji($time){
        $times = $time;
        $time = explode('—',$time);
        $start_time = strtotime($time[0]);
        $stop_time = strtotime($time[1])+86400;
//        $paged     = input('param.paged',1);//分页值
//        $page_size = config('admin_page_size');
//        $page = ($paged-1)*$page_size;
//        $sql = "select b.userid id, m.hiid,m.nickname,count(case when type=1 then type end) click_publish ,count(case when type=2 then type end) add_music ,count(case when type=3 then type end) add_cover ,count(case when type=4 then type end) add_info ,count(case when type=5 then type end) success_publish from `yf_hf_behavior` as b LEFT JOIN `yf_hf_member` as m on b.userid=m.id where b.userid!=0 and b.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP BY b.userid limit $page,$page_size";
//        $sqls = "select userid id,count(case when type=1 then type end) click_publish ,count(case when type=2 then type end) add_music ,count(case when type=3 then type end) add_cover ,count(case when type=4 then type end) add_info ,count(case when type=5 then type end) success_publish ,create_time from `yf_hf_behavior` where userid!=0 and `create_time` BETWEEN '{$start_time}' AND '{$stop_time}' GROUP BY userid";
        $res = Db::table('yf_hf_behavior')
            ->alias('b')
            ->join('yf_hf_member m','b.userid=m.id','left')
            ->field('b.userid id, m.hiid,m.nickname,count(case when type=1 then type end) click_publish ,count(case when type=2 then type end) add_music ,count(case when type=3 then type end) add_cover ,count(case when type=4 then type end) add_info ,count(case when type=5 then type end) success_publish')
            ->where("b.userid!=0 and b.create_time BETWEEN '{$start_time}' AND '{$stop_time}'")
            ->group("b.userid")
            ->paginate(10);
        $this->assign('info',$res);
        return view('detailpublishtongji');
//        dump($res);exit;
//        $list = Db::query($sql);
//        $lists = Db::query($sqls);
//        $total = count($lists);

//        if ($list[0]['id'] == null){
//            $list = null;
//        }
//
//        $back = [
//            'title'=>'返回',
//            'href'=>url('publishtongji')
//        ];
//
//        return builder('list')
//            ->setMetaTitle('单个用户视频发布流程') // 设置页面标题
//            ->addTopButton('self',['title'=>"查询日期{$times}"])  // 添加新增按钮
//            ->addTopButton('self',$back)  // 添加新增按钮
//            ->keyListItem('id','用户ID','id')
//            ->keyListItem('hiid','hiid','hiid')
//            ->keyListItem('nickname','用户昵称','nickname')
//            ->keyListItem('click_publish','点击发布')
//            ->keyListItem('add_music','添加音乐')
//            ->keyListItem('add_cover','添加封面')
//            ->keyListItem('add_info','添加房源信息')
//            ->keyListItem('success_publish','发布成功')
//            //->keyListItem('create_time','发布时间','time')
//            ->setListPrimaryKey('id')
//            ->setListData($list)    // 数据列表
//            ->setListPage($total) // 数据列表分页
//            ->fetch();
    }

    /**
     * 视频发布流程详情统计
     * by liyang
     */

    /**
     * 视频转发效果统计
     * by songjian
     */
    public function repaytongji(){
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
        $this->assign('meta_title','视频详情页统计');

        $today = strtotime(date('Y-m-d'));
        $month = strtotime(date('Y-m-01'));

        $user = [
            'today'      => $this->videoModel->where("create_time>$today")->count(),//今日发布视频
            'month'      => $this->videoModel->where("create_time>$month")->count(),//本月新增视频
            'total'      => $this->videoModel->count(),//视频总数
        ];
        $this->assign('user',$user);

        //视频转发量
        $repay_video = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',10)->count();
        //进入被转视频转发页面
        $enter_web = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',14)->count();
        //转发视频点击播放
        $click_play = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',15)->count();
        //转发视频完整观看
        $palyend = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',16)->count();
        //下载过app
        $download  = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',26)->count();
        $brr[0] = $repay_video;
        $brr[1] = $enter_web;
        $brr[2] = $click_play;
        $brr[3] = $palyend;
        $brr[4] = $download;
        $result = array('data'=>$brr);
        $this->assign('result',json_encode($result));
        return $this->fetch();
    }

    /**
     *  视频转发效果详情统计
     *  by songjian
     */
    public function detailrepaytongji($time){
        $times = $time;
        $time = explode('—',$time);
        $start_time = strtotime($time[0]);
        $stop_time = strtotime($time[1])+86400;
//        $paged     = input('param.paged',1);//分页值
//        $page_size = input('param.page_size') ? (int)input('param.page_size') :(int)config('admin_page_size');
//        $page = ($paged-1)*$page_size;
        //$sql =  "select v.id,v.title,b.`name`,count(case when h.type=10 then h.type end) repay_video ,count(case when h.type=14 then h.type end) enter_web ,count(case when h.type=15 then h.type end) click_play ,count(case when h.type=16 then h.type end) palyend ,count(case when h.type=17 then h.type end) download, FROM_UNIXTIME(v.create_time) create_time from `yf_hf_video` as v, `yf_hf_buildings` as b, `yf_hf_behavior` as h where v.building_id = b.id and h.video_id = v.id and v.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP by v.id limit $page,$page_size";
//        $sql =  "select v.id,v.title,b.`name`,count(case when h.type=10 then h.type end) repay_video ,count(case when h.type=14 then h.type end) enter_web ,count(case when h.type=15 then h.type end) click_play ,count(case when h.type=16 then h.type end) palyend ,count(case when h.type=17 then h.type end) download,FROM_UNIXTIME(v.create_time) create_time from  ((`yf_hf_behavior` as h left join `yf_hf_video` as v  on v.id=h.video_id) left JOIN `yf_hf_buildings` as b on b.id=v.building_id)  where v.building_id = b.id and h.video_id = v.id and v.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP by v.id limit $page,$page_size";
        //$sqls = "select v.id,v.title,b.`name`,count(case when h.type=10 then h.type end) repay_video ,count(case when h.type=14 then h.type end) enter_web ,count(case when h.type=15 then h.type end) click_play ,count(case when h.type=16 then h.type end) palyend ,count(case when h.type=17 then h.type end) download, FROM_UNIXTIME(v.create_time) create_time from `yf_hf_video` as v, `yf_hf_buildings` as b, `yf_hf_behavior` as h where v.building_id = b.id and h.video_id = v.id and v.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP by v.id";
//        $sqls = "select v.id,v.title,b.`name`,count(case when h.type=10 then h.type end) repay_video ,count(case when h.type=14 then h.type end) enter_web ,count(case when h.type=15 then h.type end) click_play ,count(case when h.type=16 then h.type end) palyend ,count(case when h.type=17 then h.type end) download,FROM_UNIXTIME(v.create_time) create_time from  ((`yf_hf_behavior` as h left join `yf_hf_video` as v  on v.id=h.video_id) left JOIN `yf_hf_buildings` as b on b.id=v.building_id)  where v.building_id = b.id and h.video_id = v.id and v.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP by v.id";
        $res = Db::table('yf_hf_behavior')
            ->alias('h')
            ->join('yf_hf_video v','v.id = h.video_id')
            ->join('yf_hf_buildings b','b.id = v.building_id')
            ->field('v.id,v.title,b.`name`,v.create_time,count(case when h.type=10 then h.type end) repay_video ,count(case when h.type=14 then h.type end) enter_web ,count(case when h.type=15 then h.type end) click_play ,count(case when h.type=16 then h.type end) palyend ,count(case when h.type=17 then h.type end) download')
            ->where("v.building_id = b.id and h.video_id = v.id and v.create_time BETWEEN '{$start_time}' AND '{$stop_time}'")
            ->group("v.id")
            ->paginate(10);
//        dump($res);exit;
        $this->assign('info',$res);
        return $this->fetch('detailrepaytongji');


//        $list = Db::query($sql);
//        if (empty($list)){
//            $list = null;
//        }
//        $total = count(Db::query($sqls));
//
//        $back = [
//            'title'=>'返回',
//            'href'=>url('repaytongji')
//        ];
//
//        return builder('list')
//            ->setMetaTitle('单个视频详情统计') // 设置页面标题
//            ->addTopButton('self',['title'=>"查询日期{$times}"])  // 添加新增按钮
//            ->addTopButton('self',$back)
//            ->keyListItem('id','视频ID','id')
//            ->keyListItem('title','视频主题','title')
//            ->keyListItem('name','所在小区','name')
//            ->keyListItem('repay_video','视频转发','repay_video')
//            ->keyListItem('enter_web','进入被转页面','enter_web')
//            ->keyListItem('click_play','点击播放','click_play')
//            ->keyListItem('palyend','完整观看','palyend')
//            ->keyListItem('download','下载过app','download')
//            ->keyListItem('create_time','创建时间','create_time')
//            ->setListPrimaryKey('id')
//            ->setListData($list)    // 数据列表
//            ->setListPage($total) // 数据列表分页
//            ->fetch();
    }

    /**
     * 视频转发统计详情搜索
     * by liyang
     */
//    public function search(){
//        $id = $_POST['id']?$_POST['id']:'';  //未定义id索引
////        $hiid = $_POST['hiid']?$_POST['hiid']:'';
//        $name = $_POST['name']?$_POST['name']:'';
//        $start_time = strtotime($_POST['start']);
//        $stop_time = strtotime($_POST['stop']) + 86400;
//
//        $query = Db::table('yf_hf_video')->alias('v')
//            ->join('yf_hf_behavior h','v.id = h.video_id')
//            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
//            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
//            ->field('v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.examine,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.member_id,v.create_time,v.update_time,b.name,m.nickname,m.hiid,m.phone,m.is_robot,count(case when h.type=10 then h.type end) repay_video,count(case when h.type=14 then h.type end) enter_web ,count(case when h.type=15 then h.type end) click_play ,count(case when h.type=16 then h.type end) palyend ,count(case when h.type=17 then h.type end) download')
//            ->where('v.is_delete',0);
////        dump(Db::getLastSql());exit;
//        if ($id) {
//            $query = $query->where('v.id','like',"%$id%");
//        }
//        if ($start_time && $stop_time) {
//            $query = $query->where('v.create_time','>',$start_time)->where('v.create_time','<',$stop_time);
//        }
////        if ($hiid) {
////            $query = $query->where('m.hiid','like',"%$hiid%");
////        }
//        if ($name) {
//            $query = $query->where('b.name','like',"%$name%");
//        }
//        $info = $query->paginate(12);
////        $this->assign('hiid',$hiid);
//        $this->assign('name',$name);
//        $this->assign('start_time',$_POST['start']);
//        $this->assign('stop_time',$_POST['stop']);
//        $this->assign('id',$id);
//        $this->assign('info',$info);
////        return view('index');
//        return view('detailrepaytongji');
////        return view('detailtonji');
//    }

    /**
     * 单个视频详情统计 搜索
     * by liyang
     */
//    public function searchDetail(){
//        $id = $_POST['id']?$_POST['id']:'';  //未定义id索引
//        $hiid = $_POST['hiid']?$_POST['hiid']:'';
//        $name = $_POST['name']?$_POST['name']:'';
//        $start_time = strtotime($_POST['start']);
//        $stop_time = strtotime($_POST['stop']) + 86400;
//
//        $query = Db::table('yf_hf_video')->alias('v')
//            ->join('yf_hf_behavior h','v.id = h.video_id')
//            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
//            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
//            ->field('v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.examine,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.member_id,v.create_time,v.update_time,b.name,m.nickname,m.hiid,m.phone,m.is_robot,count(case when type=6 then type end) begin_watch ,count(case when type=7 then type end) all_watch,count(case when type=8 then type end) top ,count(case when type=9 then type end) review ,count(case when type=10 then type end) forward ,count(case when type=11 then type end) entervillage ,count(case when type=12 then type end) enterauthor')
//            ->where('v.is_delete',0);
////        dump(Db::getLastSql());exit;
//        if ($id) {
//            $query = $query->where('v.id','like',"%$id%");
//        }
//        if ($start_time && $stop_time) {
//            $query = $query->where('v.create_time','>',$start_time)->where('v.create_time','<',$stop_time);
//        }
//        if ($hiid) {
//            $query = $query->where('m.hiid','like',"%$hiid%");
//        }
//        if ($name) {
//            $query = $query->where('b.name','like',"%$name%");
//        }
//
//        $info = $query->paginate(12);
//        $this->assign('id',$id);
//        $this->assign('hiid',$hiid);
//        $this->assign('name',$name);
//        $this->assign('start_time',$_POST['start']);
//        $this->assign('stop_time',$_POST['stop']);
//        $this->assign('info',$info);
//        return view('detailtongji');
//    }

    //搜索功能实现
    //20180716
    //by liyang
    //搜索语句有误 视频 用户 所在小区
//    public function searchvideo(){
//        //接收查询条件
//        $id = $_POST['id']?$_POST['id']:'';
//        $hiid = $_POST['hiid']?$_POST['hiid']:'';
//        $name = $_POST['name']?$_POST['name']:'';
//        $start_time = strtotime($_POST['start']);
//        $stop_time = strtotime($_POST['stop']) + 86400;
//        //拼接查询语句
//        $query  = Db::table('yh_hf_video')
//            ->alias('v')
//            ->join('yf_hf_behavior h','v.id = h.video_id')
//            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
//            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
//            ->field('v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.examine,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.member_id,v.create_time,v.update_time,b.name,m.nickname,m.hiid,m.phone,m.is_robot,count(case when type=6 then type end) begin_watch ,count(case when type=7 then type end) all_watch,count(case when type=8 then type end) top ,count(case when type=9 then type end) review ,count(case when type=10 then type end) forward ,count(case when type=11 then type end) entervillage ,count(case when type=12 then type end) enterauthor,count(case when h.type=10 then h.type end) repay_video,count(case when h.type=14 then h.type end) enter_web ,count(case when h.type=15 then h.type end) click_play ,count(case when h.type=16 then h.type end) palyend ,count(case when h.type=17 then h.type end) download')
//            ->where('v.is_delete',0);
//        if ($id) {
//            $query = $query->where('v.id','like',"%$id%");
//        }
//        if ($hiid) {
//            $query = $query->where('m.hiid','like',"%$hiid%");
//        }
//        if ($name) {
//            $query = $query->where('b.name','like',"%$name%");
//        }
//        if ($start_time && $stop_time) {
//            $query = $query->where('v.create_time','>',$start_time)->where('v.create_time','<',$stop_time);
//        }
//        $info = $query->paginate(12);
//        $this->assign('id',$id);
//        $this->assign('hiid',$hiid);
//        $this->assign('name',$name);
//        $this->assign('start_time',$_POST['start']);
//        $this->assign('stop_time',$_POST['stop']);
//        $this->assign('info',$info);
//        return view('detailtongji');
//    }
//-------------------------------------七牛云后台审核上传-------------------------------------------------------//
    /**
     * 视频审核上传七牛云
     * by songjian
     */
    public function createqiniu(){
        // 获取小区列表
        $res = Db::table('yf_hf_buildings')->alias('b')
            ->join('yf_hf_area a','b.area_id=a.id')
            ->join('yf_hf_video_58 v','b.name=v.building')
            ->field('v.building as name,v.id as video_id,b.*')
            ->select();
        $ids = [];
        foreach ($res as $v) {
            $ids[] = $v['video_id'];
        }
        $map = [
            'status' => 1
        ];

        //list($data_list,$total) = $this->videoFiveModel->search('id|name|address|building|area')->getListByPage($map,true,'id desc');

        $paged     = input('param.paged',1);//分页值
        $page_size = config('admin_page_size');
        $data_list = DB::table('yf_hf_video_58')->where('status',1)->whereNotIn('id',$ids)->order('id desc')->page($paged,$page_size)->select();
        $total = DB::table('yf_hf_video_58')->where('status',1)->whereNotIn('id',$ids)->count();

        return builder('list')
            ->setMetaTitle('带审核上传七牛列表') // 设置页面标题
            //->addTopButton('self',['href'=>url('uploadQiniuVideo',['id'=>'__data_id__']),'title'=>'批量上传'])// 添加新增按钮
            //->addTopButton('delete')  // 添加删除按钮
            ->keyListItem('address','区域','address')
            ->keyListItem('building','小区名','building')
            ->keyListItem('title','说明','title')
            ->keyListItem('area','占地面积','area')
            ->keyListItem('price','金额','price')
            ->keyListItem('right_button', '操作', 'btn')
            ->setListPrimaryKey('id')
            ->setListData($data_list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            ->addRightButton('self',['href'=>url('editQiniuVideo',['id'=>'__data_id__']),'title'=>'去上传'])
            ->addRightButton('delete')  // 添加编辑按钮
            ->fetch();
    }

    /**
     * 上传七牛视频的编辑功能
     * by songjian
     */
    /*public function editQiniuVideo($id){
        $info = Db::table('yf_hf_video_58')->where('id',$id)->find();
        $build_name = $info['building'];
        //搜索yf_hf_video表小区
        $sql = "select b.id as building_id,b.name as building_name,a.id as area_id,a.dic_value from `yf_hf_buildings` b left join `yf_hf_area` a on b.area_id=a.id WHERE b.name like '%{$build_name}%' ";
        $buildings = Db::query($sql);

        $this->assign('info',$info);
        $this->assign('buildings',$buildings);
        $this->assign('meta_title','七牛云视频上传编辑');
        return view('editVideo',['id'=>$id]);
    }*/
    public function editQiniuVideo($id){
        $info = Db::table('yf_hf_video_58')->where('id',$id)->find();
        $this->assign('info',$info);
        $this->assign('meta_title','七牛云视频上传编辑');
        return view('editVideo',['id'=>$id]);
    }

    /**
     * 上传视频
     * by songjian
     */
    public function upload($video_filePath,$filename){
        //$video_filePath = "F:/php/wamp64/www/haifang/public/uploads/download/{$filename}";
        $video_filePath = PUBLIC_PATH."uploads/download/haifang/{$filename}";
        // 需要填写你的 Access Key 和 Secret Key
        $accessKey ="2HzSOxN30PJk8km94quVwVtmKvrA0_NyqFVcZQaW";
        $secretKey = "yxjfFeYNDKPhOq2sQd1b2OrGkgjqkVz_BXs_WMNq";
        $bucket = "hifang";
        // 构建鉴权对象
        $auth = new Auth($accessKey, $secretKey);
        // 生成上传 Token
        $token = $auth->uploadToken($bucket);
        // 上传到七牛后保存的文件名
        $video_key = $filename;        //视频的文件名
        //初始化 UploadManager 对象并进行文件的上传。
        $uploadMgr = new UploadManager();
        // 调用 UploadManager 的 putFile 方法进行文件的上传。
        //第一步，上传视频
        list($ret1, $err1) = $uploadMgr->putFile($token, $video_key, $video_filePath);
        //echo "\n====> putFile result: \n";
        if ($err1 !== null) {
            $data['code'] = 101;
            return $data;
        } else {
            //合成音乐结果
            $res = Tool::createMusic($video_key);
            if ($res == true){
                //下载此视频的封面图
                $url='http://p79qkwz6c.bkt.clouddn.com/'.$video_key.'?vframe/jpg/offset/5';
                $filenames = $video_key."_img.jpg";
                $res = $this->GrabImage($url,$dir='./uploads/download/img',$filenames);
                if ($res){
                    $data['code'] = 200;
                    $data['img_name']   = $filenames;
                    $data['img_path']   = $res;
                    $data['video_path'] = 'http://p79qkwz6c.bkt.clouddn.com/'.$video_key;
                    return $data;
                }else{
                    $data['code'] = 101;
                    return $data;
                }
            }else{
                return false;
            }
        }
    }
    /**
     * 上传封面图
     * By songjian
     */
    public function uploadImg($img_filePath,$img_name){
        // 需要填写你的 Access Key 和 Secret Key
        $accessKey ="2HzSOxN30PJk8km94quVwVtmKvrA0_NyqFVcZQaW";
        $secretKey = "yxjfFeYNDKPhOq2sQd1b2OrGkgjqkVz_BXs_WMNq";
        $bucket = "hifang";
        // 构建鉴权对象
        $auth = new Auth($accessKey, $secretKey);
        // 生成上传 Token
        $token = $auth->uploadToken($bucket);
        // 要上传文件的本地路径
        // 上传到七牛后保存的文件名
        $img_key   = $img_name;    //封面图的文件名
        //$img_filePath   = "F:/php/wamp64/www/haifang/public/uploads/download/img/test_img.jpg";
        //初始化 UploadManager 对象并进行文件的上传。
        $uploadMgr = new UploadManager();
        // 调用 UploadManager 的 putFile 方法进行文件的上传。
        //上传图片
        list($ret1, $err1) = $uploadMgr->putFile($token, $img_key, $img_filePath);
        //echo "\n====> putFile result: \n";
        if ($err1 !== null) {
            $data['code'] = 101;
            return $data;
        } else {
            $data['code'] = 200;
            $data['img_path'] = 'http://p79qkwz6c.bkt.clouddn.com/'.$img_key;;
            return $data;
        }
    }

    /**
     * 将网络资源封面图下载到本地文件夹
     * by songjian
     */
    public function GrabImage($url='', $dir='./uploads/download/img', $filename=''){
        if(empty($url)){
            return false;
        }
        $ext = strrchr($url, '.');
        //为空就当前目录
        if(empty($dir))$dir = './';
        $dir = realpath($dir);
        //目录+文件
        $filename = $dir . (empty($filename) ? '/'.time().$ext : '/'.$filename);
        //开始捕捉
        ob_start();
        readfile($url);
        $img = ob_get_contents();
        ob_end_clean();
        $size = strlen($img);
        $fp2 = fopen($filename , "a");
        fwrite($fp2, $img);
        fclose($fp2);
        return $filename;
    }

    /**
     * 通过关键字搜索小区名，并且拿到小区id、地区id
     * by songjian
     */
    public function searchBuilding($build_name){
        $sql = "select b.id as building_id,b.name as building_name,a.id as area_id,a.dic_value,b.address from `yf_hf_buildings` b left join `yf_hf_area` a on b.area_id=a.id WHERE b.name like '%{$build_name}%' ";
        $res = Db::query($sql);
        if ($res){
            $data['code'] = 200;
            $data['message'] = "搜索小区成功";
            $data['data'] = $res;
        }else{
            $data['code'] = 101;
            $data['message'] = "搜索小区失败，没有信息";
        }
        return $data;
    }

    /**
     * 将新整合的信息放到video表中
     * By songjian
     */
    public function insertVideo($building_id,$video_id,$video_path,$img_path){
        $video_info = Db::table('yf_hf_video_58')->where('id',$video_id)->find();
        $area_id = Db::table('yf_hf_buildings')->field(['area_id'])->where('id',$building_id)->find()['area_id'];
        $data = array(
            'id' => 0,
            'title' => $video_info['title'],
            'video_link' => $video_path,
            'video_type' => 1,
            'video_cover'=> $img_path,
            'status'     => 1,
            'sort'       => 1,
            'num_room'   => $video_info['num_room'],
            'num_hall'   => $video_info['num_hall'],
            'num_toilet' => $video_info['num_toilet'],
            'area'       => $video_info['area'],
            'price'      => $video_info['price'],
            'area_id'    => $area_id,
            'member_id'  => rand(650,2000),
            'building_id'=> $building_id,
            'longitude'  => $video_info['longitude'],
            'latitude'   => $video_info['latitude'],
            'app_version'=> '1.0.0',
            'remarks'    => '',
            'examine'    => 1,
            'create_time'=> time(),
            'update_time'=> time()
        );
        $res= Db::table('yf_hf_video')->insert($data);
        if ($res){
            $result = Db::table('yf_hf_video_58')->where('id',$video_id)->update(['status'=>0]);
            if ($result){
                return true;
            }else{
                return false;
            }
        }else{
            return false;
        }
    }

    /**
     * 后台视频+封面图上传至七牛云+视频记录插入数据库
     * @auther zyt
     */
    public function uploadVideos () {

        // 获取小区列表
        $res = Db::table('yf_hf_buildings')->alias('b')
            ->join('yf_hf_area a','b.area_id=a.id')
            ->join('yf_hf_video_58 v','b.name=v.building')
            ->field('v.building as name,v.id as video_id,b.*')
            ->select();
        $ids = [];
        foreach ($res as $v) {
            $ids[] = $v['video_id'];
        }
        $map = [
            'status' => 1
        ];

        //list($data_list,$total) = $this->videoFiveModel->search('id|name|address|building|area')->getListByPage($map,true,'id desc');

        $paged     = input('param.paged',1);//分页值
        $page_size = config('admin_page_size');
        $data_list = Db::table('yf_hf_video_58')->where('status',1)->whereIn('id',$ids)->order('id desc')->page($paged,$page_size)->select();
        $total = Db::table('yf_hf_video_58')->where('status',1)->whereIn('id',$ids)->count();

        return builder('list')
            ->setMetaTitle('审核上传七牛列表') // 设置页面标题
            //->addTopButton('self',['href'=>url('uploadQiniuVideo',['id'=>'__data_id__']),'title'=>'批量上传'])// 添加新增按钮
            //->addTopButton('delete')  // 添加删除按钮
            ->keyListItem('id','区域','id')
            ->keyListItem('address','区域','address')
            ->keyListItem('building','小区名','building')
            ->keyListItem('title','说明','title')
            ->keyListItem('area','占地面积','area')
            ->keyListItem('price','金额','price')
            ->keyListItem('right_button', '操作', 'btn')
            ->setListPrimaryKey('id')
            ->setListData($data_list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            ->addRightButton('self',['href'=>url('uploadQiniuyun',['id'=>'__data_id__']),'title'=>'去上传'])
            ->addRightButton('delete')  // 添加编辑按钮
            ->fetch();
    }
    public function uploadQiniuyun(){
        Log::info("========uploadQiniuyun1=======");
        $query = "select v.id from yf_hf_video_58 v join yf_hf_buildings b on b.name=v.building where status=1";
        $arr = Db::query($query);
        Log::info($arr);
        for ($i=0;$i<count($arr);$i++) {
            $id = $arr[$i]['id'];
            Log::info($id);
            $arr = Db::table('yf_hf_buildings')->alias('b')
                ->join('yf_hf_area a', 'b.area_id=a.id')
                ->join('yf_hf_video_58 v', 'b.name=v.building')
                ->field('v.building as name,v.id,b.id as building_id')
                ->where('v.id', $id)
                ->find();
            $video_id = $arr['id'];
            $building_id = $arr['building_id'];

            $info = Db::table('yf_hf_video_58')->where('id', $video_id)->find();
            $filename = $info['videoname'];
            /*
             * 1.上传视频
             */
            Log::info("========1.上传视频=======");
            $video_filePath = PUBLIC_PATH . "uploads/download/haifang/{$filename}";
            // 需要填写你的 Access Key 和 Secret Key
            $accessKey = "2HzSOxN30PJk8km94quVwVtmKvrA0_NyqFVcZQaW";
            $secretKey = "yxjfFeYNDKPhOq2sQd1b2OrGkgjqkVz_BXs_WMNq";
            $bucket = "hifang";
            // 构建鉴权对象
            $auth = new Auth($accessKey, $secretKey);
            // 生成上传 Token
            $token = $auth->uploadToken($bucket);
            // 上传到七牛后保存的文件名
            $video_key = $filename;        //视频的文件名
            //初始化 UploadManager 对象并进行文件的上传。
            $uploadMgr = new UploadManager();
            // 调用 UploadManager 的 putFile 方法进行文件的上传。
            //第一步，上传视频
            list($ret1, $err1) = $uploadMgr->putFile($token, $video_key, $video_filePath);
            if ($err1 === null) {
                //合成音乐结果
                $res = Tool::createMusic($video_key);
                if ($res == true) {
                    //下载此视频的封面图
                    $url = 'http://p79qkwz6c.bkt.clouddn.com/' . $video_key . '?vframe/jpg/offset/5';
                    $filenames = $video_key . "_img.jpg";
                    $res = $this->GrabImage($url, $dir = './uploads/download/img', $filenames);
                    $video_path = 'http://p79qkwz6c.bkt.clouddn.com/' . $video_key;
                }
            }
            /*
             * 2.上传封面图
             */
            Log::info("========2.上传封面图=======");
            // 要上传文件的本地路径
            // 上传到七牛后保存的文件名
            $img_key = $filenames;    //封面图的文件名
            //初始化 UploadManager 对象并进行文件的上传。
            $uploadMgr = new UploadManager();
            // 调用 UploadManager 的 putFile 方法进行文件的上传。
            //上传图片
            list($ret1, $err1) = $uploadMgr->putFile($token, $img_key, $res);
            $img_path = 'http://p79qkwz6c.bkt.clouddn.com/' . $img_key;
            /*
             * 3.将新整合的信息放到video表中
             */
            Log::info("========3.将新整合的信息放到video表中=======");
            $video_info = Db::table('yf_hf_video_58')->where('id', $video_id)->find();
            $area_id = Db::table('yf_hf_buildings')->field(['area_id'])->where('id', $building_id)->find()['area_id'];
            $data = array(
                'id' => 0,
                'title' => $video_info['title'],
                'video_link' => $video_path,
                'video_type' => 1,
                'video_cover' => $img_path,
                'status' => 1,
                'sort' => 1,
                'num_room' => $video_info['num_room'],
                'num_hall' => $video_info['num_hall'],
                'num_toilet' => $video_info['num_toilet'],
                'area' => $video_info['area'],
                'price' => $video_info['price'],
                'area_id' => $area_id,
                'member_id' => rand(650, 2000),
                'building_id' => $building_id,
                'longitude' => $video_info['longitude'],
                'latitude' => $video_info['latitude'],
                'app_version' => '1.0.0',
                'remarks' => '',
                'examine' => 1,
                'create_time' => time(),
                'update_time' => time()
            );
            $res = Db::table('yf_hf_video')->insert($data);
            Log::info($res);
            if ($res) {
                $result = Db::table('yf_hf_video_58')->where('id', $video_id)->update(['status' => 0]);
                if ($result) {
                    return $this->success('操作成功', url('video/index'));
                } else {
                    return $this->error('操作失败', url('video/index'));
                }
            } else {
                return $this->success('操作成功', url('video/index'));
            }
        }
    }

}