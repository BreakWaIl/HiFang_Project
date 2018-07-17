<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/15
 * Time: 10:30
 */
namespace app\admin\controller;

use app\admin\controller\Admin;
use app\api\controller\Tool;
use app\api\untils\GeTuiUntils;
use app\common\model\Buildings as BuildingsModel;
use think\Db;
use think\Log;
use think\Request;

/**
 * Class Buildings
 * @package app\admin\controller
 */
class Buildings extends Admin{
    public $buildingsModel;
    function _initialize()
    {
        parent::_initialize();

        $this->buildingsModel = model('common/buildings');
    }
    /**
     * 小区列表
     * @return [type] [description]
     * @date   2018-04-15
     * @author zyt
     */
    public function index(){
        // 获取小区列表
        $map = [
            'is_confirm'=>1
        ];
        list($data_list,$total) = $this->buildingsModel->search('id|name|average_price|architectural_age|architectural_type')->getListByPage($map,true,'id desc');

        return builder('list')
            ->setMetaTitle('小区列表') // 设置页面标题
            ->addTopButton('addnew')  // 添加新增按钮
            ->addTopButton('delete')  // 添加删除按钮
            ->keyListItem('id','小区id','id')
            ->keyListItem('name','小区名称','name')
            ->keyListItem('average_price','均价','average_price')
            ->keyListItem('architectural_age','建筑年代','architectural_age')
            ->keyListItem('architectural_type','建筑类型','architectural_type')
            ->keyListItem('property_cost','物业费用','property_cost')
            ->keyListItem('property_company','物业公司','property_company')
            ->keyListItem('longitude','小区经度','longitude')
            ->keyListItem('latitude','小区纬度','latitude')
            ->keyListItem('address','小区地址','address')
            ->keyListItem('developers','开发商','developers')
            ->keyListItem('num_building','楼栋总数','num_building')
            ->keyListItem('num_room','房屋总数','num_room')
            ->keyListItem('is_user_add','添加小区人类型','array',[0=>'机器添加',1=>'管理员',2=>'普通用户'])
            ->keyListItem('create_time','创建时间','create_time')
            ->keyListItem('update_time','更新时间','update_time')
            ->keyListItem('right_button', '操作', 'btn')
            ->setListPrimaryKey('id')
            ->setListData($data_list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            ->addRightButton('self',['href'=>url('tongji',['id'=>'__data_id__']),'title'=>'查看统计','icon'=>'fa fa-area-chart'])
            ->addRightButton('edit')
            ->addRightButton('self',['href'=>url('delete',['id'=>'__data_id__']),'title'=>'删除','icon'=>'fa fa-trash'])
            ->fetch();
    }

    /**
     * 添加或编辑小区
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
                $this->validateData($data,'Buildings.edit');
            } else{
                $data['id'] = 0;
                $this->validateData($data,'Buildings.add');
            }


            // 提交数据
            //$data里包含主键id，则editData就会更新数据，否则是新增数据
            $result = $this->buildingsModel->editData($data);
            if ($result) {
                if ($id==is_login()) {//如果是编辑状态下
                    logic('common/Buildings')->updateLoginSession($id);
                }
                //每添加一个小区后要随机加一些关注
                Tool::robotRules(2,$result);
                $this->success($title.'成功', url('index'));
            } else {
                $this->error($this->buildingsModel->getError());
            }

        } else {
            $info=[];
            // 获取账号信息
            if ($id!=0) {
                $info = $this->buildingsModel->get($id);
                //unset($info['member_id']);
            }
            $builder = builder('Form');
            $builder->setMetaTitle($title.'小区')  // 设置页面标题
                ->addFormItem('id', 'hidden', 'ID', '')
                ->addFormItem('name', 'text', '', '填写小区名称','','require')
                ->addFormItem('average_price', 'text', '', '填写均价','','require')
                ->addFormItem('architectural_age', 'text', '', '填写建筑年代','','require')
                ->addFormItem('architectural_type','text', '', '填写建筑类型','','require')
                ->addFormItem('property_cost','text', '', '物业费用','','require')
                ->addFormItem('property_company','text', '', '物业公司','','require')
                ->addFormItem('longitude','text', '', '小区经度','','require')
                ->addFormItem('latitude','text', '', '小区纬度','','require')
                ->addFormItem('address','text', '', '小区地址','','require')
                ->addFormItem('developers','text', '', '开发商','','require')
                ->addFormItem('num_building','text', '', '楼栋总数','','require')
                ->addFormItem('num_room','text', '', '房屋总数','','require');
            return $builder
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('submit')->addButton('back')    // 设置表单按钮
                ->fetch();
        }
    }

    /**
     * 删除小区
     * @auther zyt
     * @time 2018/7/12 10:00
     */
    public function delete($id=0){
        $id = input('id');

        $building = Db::table('yf_hf_buildings')->where('id',$id)->find();
        if (!$building) {
            $this->error('不存在该小区');
        }
        //删除小区  同时删除follow表被关注的数据,修改用户关注小区数
        $deleteBuilding = Db::table('yf_hf_buildings')->where('id',$id)->delete();
        $follow = Db::table('yf_hf_follow')->where(['followed_id'=>$id,'type'=>1])->select();
        if ($follow) {
            $member_ids = [];
            for ($i=0;$i<count($follow);$i++) {
                $member_ids[] = $follow[$i]['member_id'];
            }
            //修改用户关注小区数
            $updateFollow = Db::table('yf_hf_member')->whereIn('id',$member_ids)->setDec('num_buildings');
            Db::table('yf_hf_follow')->where(['followed_id'=>$id,'type'=>1])->delete();
        }

        if ($deleteBuilding) {
            $this->success('删除成功',url('index'));
        } else {
            $this->success('删除失败,请重试',url('index'));
        }

    }

    /**
     * 上报小区列表(未审核)
     * @auther zyt
     * @time 2018/7/4
     */
    public function addBuildingsList(){
        // 获取小区列表
        $info = Db::table('yf_hf_buildings')->alias('b')
            ->join('yf_hf_member m','m.id=b.user_id')
            ->field('b.id,b.name,b.address,b.is_confirm,b.user_id,b.remarks,b.create_time,b.update_time,m.nickname,m.hiid,m.phone')
            ->where('b.is_confirm',0)
            ->order('b.id','desc')
            ->paginate(12);

        $this->assign('info',$info);
        return $this->fetch();
    }
    /**
     * 搜索上报小区
     * @auther zyt
     * @time 2018/7/4
     */
    public function searchBuildingList(Request $request){
        $hiid     = $request->param('hiid');
        $nickname = $request->param('nickname');
        $phone    = $request->param('phone');
        $name     = $request->param('name');

        $query = Db::table('yf_hf_buildings')->alias('b')
            ->join('yf_hf_member m','m.id=b.user_id')
            ->field('b.id,b.name,b.address,b.is_confirm,b.user_id,b.remarks,b.create_time,b.update_time,m.nickname,m.hiid,m.phone')
            ->where('b.is_confirm',0);
        if ($hiid) {
            $query = $query->where('m.hiid','like',"%{$hiid}%");
        }
        if ($nickname) {
            $query = $query->where('m.nickname','like',"%{$nickname}%");
        }
        if ($phone) {
            $query = $query->where('m.phone','like',"%{$phone}%");
        }
        if ($name) {
            $query = $query->where('m.name','like',"%{$name}%");
        }
        $info = $query->order('b.id','desc')->paginate(12);

        $this->assign('hiid',$hiid);
        $this->assign('nickname',$nickname);
        $this->assign('phone',$phone);
        $this->assign('info',$info);
        $this->assign('name',$name);
        return view('addbuildingslist');
    }

    /**
     * 审核小区
     * @auther zyt
     * @auther zyt
     * @time 2018/7/4
     */
    public function verifyBuilding($building_id,$type){
        if ($type == 0) { //审核为不通过
            $res = 0;
        } elseif ($type == 1) { //审核为通过
            //修改yf_hf_buildings表字段is_confirm
            $res = Db::table('yf_hf_buildings')->where('id',$building_id)->update(['is_confirm'=>1]);
        }

        return $res;
    }
    /**
     * 审核通过跳转至编辑小区界面
     * @auther zyt
     * @time 2018/7/4
     */
    public function editBuilding () {
        $id = input('building_id');

        if (IS_POST) {
            $data = input('param.');
            $id  = isset($data['id']) && $data['id']>0 ? intval($data['id']) : false;
            if ($id>0) {
                $this->validateData($data,'Buildings.edit');
            }

            // 提交数据
            $result = $this->buildingsModel->editData($data);
            if ($result) {
                if ($id==is_login()) {//如果是编辑状态下
                    logic('common/Buildings')->updateLoginSession($id);
                }
                //每添加一个小区后要随机加一些关注

                $this->success('编辑成功', url('index'));
            } else {
                $this->error($this->buildingsModel->getError());
            }

        } else {
            $info = [];
            $info = $this->buildingsModel->get($id);
            $builder = builder('Form');
            $builder->setMetaTitle('编辑小区')// 设置页面标题
                ->addFormItem('id', 'hidden', 'ID', '')
                ->addFormItem('name', 'text', '', '填写小区名称', '', 'require')
                ->addFormItem('average_price', 'text', '', '填写均价', '', 'require')
                ->addFormItem('architectural_age', 'text', '', '填写建筑年代', '', 'require')
                ->addFormItem('architectural_type', 'text', '', '填写建筑类型', '', 'require')
                ->addFormItem('property_cost', 'text', '', '物业费用', '', 'require')
                ->addFormItem('property_company', 'text', '', '物业公司', '', 'require')
                ->addFormItem('longitude', 'text', '', '小区经度', '', 'require')
                ->addFormItem('latitude', 'text', '', '小区纬度', '', 'require')
                ->addFormItem('address', 'text', '', '小区地址', '', 'require')
                ->addFormItem('developers', 'text', '', '开发商', '', 'require')
                ->addFormItem('num_building', 'text', '', '楼栋总数', '', 'require')
                ->addFormItem('num_room', 'text', '', '房屋总数', '', 'require');
            return $builder
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('submit')->addButton('back')// 设置表单按钮
                ->fetch();
        }
    }
    /**
     * 审核不通过删除
     * @auther zyt
     * @time 2018/7/4
     */
    public function deleteBuilding () {
        $id = input('building_id');
        //查询该小区信息
        $building = Db::table('yf_hf_buildings')->where('id',$id)->find($id);
        //删除该小区
        $deleteBuilding = '';
        if ($building){
            $deleteBuilding = Db::table('yf_hf_buildings')->where('id',$id)->delete($id);
        }
        //查询是否有人关注过该小区,若有这删除
        $follow = Db::table('yf_hf_follow')->where(['followed_id'=>$id,'type'=>1])->select();
        if ($follow) {
            $member_ids = [];
            for ($i=0;$i<count($follow);$i++) {
                $member_ids[] = $follow[$i]['member_id'];
            }
            //修改用户关注小区数
            $updateFollow = Db::table('yf_hf_member')->whereIn('id',$member_ids)->setDec('num_buildings');
            Db::table('yf_hf_follow')->where(['followed_id'=>$id,'type'=>1])->delete();
        }

        //删除该用户发布的相关视频和修改发布数
        $video = Db::table('yf_hf_video')->where(['building_id'=>$id])->select();
        $deleteVideo = '';
        if ($video) {
            $deleteVideo = Db::table('yf_hf_video')->where(['building_id'=>$id])->update(['is_delete'=>1]);
            $updatePublishNum = Db::table('yf_hf_member')->where('id',$building['user_id'])->setDec('num_publish');
        }
        //添加推送
        //给用户发送删除推送
        $content = '您创建的小区，经过核实，已被拒绝通过，相关的视频也已被删除';
        $arr = [
            'id'           => 0,
            'member_id'    => $building['user_id'],
            'content'      => $content,
            'type'         => 22,
            'is_show'      => 0,
            'create_time'  => time(),
            'update_time'  => time()
        ];
        $res = Db::table('yf_hf_task')->insert($arr);
        $device_id = Db::table('yf_hf_device')->where('member_id',$building['user_id'])->value('device_id');
        $ge_tui = new GeTuiUntils();
        $ge_tui->public_push_message_for_one(1,$device_id,'删除',$content,$type=22);

        if($deleteBuilding || $deleteVideo){
            $this->success('删除成功', url('addBuildingsList'));
        } else {
            $this->success('删除失败', url('addBuildingsList'));
        }
    }


    /**
     * 小区统计
     * by songjian
     */
    public function tongji($id='1'){
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
        $this->assign('meta_title','小区统计');

        $today = strtotime(date('Y-m-d'));
        $month = strtotime(date('Y-m-01'));

        $user = [
            'today'      => $this->buildingsModel->where("create_time>$today")->count(),//今日入驻小区
            'month'      => $this->buildingsModel->where("create_time>$month")->count(),//本月新增小区
            'total'      => $this->buildingsModel->count(),//小区总数
        ];
        $this->assign('user',$user);

        //搜索小区关注总数、出租房源、出售房源>
        //$follow_count = Db::table('yf_hf_buildings')->field(['follow_count'])->where('create_time','>',$begin)->where('create_time','<',$end)->where('id',$id)->find()['follow_count'];
        //$rent = Db::table('yf_hf_video')->field(['count("title") title'])->where('create_time','>',$begin)->where('create_time','<',$end)->where('building_id',$id)->where('video_type',0)->find()['title']; //出租数量
        //$sell = Db::table('yf_hf_video')->field(['count("title") title'])->where('create_time','>',$begin)->where('create_time','<',$end)->where('building_id',$id)->where('video_type',1)->find()['title']; //出售数量
        $follow_count = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',22)->count();  //小区关注总数
        $rent = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',23)->count();  //出租数量
        $sell = Db::table('yf_hf_behavior')->where('create_time','>',$begin)->where('create_time','<',$end)->where('type',24)->count();  //出售数量
        $brr[0] = $follow_count;
        $brr[1] = $rent;
        $brr[2] = $sell;
        $result = array('data'=>$brr);
        $this->assign('result',json_encode($result));
        return $this->fetch();
    }

    /**
     * 单个小区统计
     * By songjian
     */
    public function detailTongji($time){
        $times = $time;
        $time = explode('—',$time);
        $start_time = strtotime($time[0]);
        $stop_time = strtotime($time[1])+86400;
        $paged     = input('param.paged',1);//分页值
        $page_size = input('param.page_size') ? (int)input('param.page_size') :(int)config('admin_page_size');
        $page = ($paged-1)*$page_size;
        //$sql = "select b.id,b.`name`,b.follow_count,count(case when type=23 then type end) rent,count(case when type=24 then type end) sell from (yf_hf_buildings as b LEFT JOIN yf_hf_video as v on b.id = v.building_id) LEFT JOIN yf_hf_behavior as h on h.video_id = v.id where v.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP BY b.id HAVING (rent!=0 || sell!=0) ORDER BY b.follow_count ASC limit $page,$page_size";
        $sql =  "select b.id,b.`name`,b.follow_count,count(case when type=23 then type end) rent,count(case when type=24 then type end) sell from (yf_hf_behavior as h LEFT JOIN yf_hf_video as v on h.video_id = v.id) LEFT JOIN yf_hf_buildings as b on b.id = v.building_id where v.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP BY b.id HAVING (rent!=0 || sell!=0) ORDER BY b.follow_count ASC limit $page,$page_size";
        $sqls = "select b.id,b.`name`,b.follow_count,count(case when type=23 then type end) rent,count(case when type=24 then type end) sell from (yf_hf_buildings as b LEFT JOIN yf_hf_video as v on b.id = v.building_id) LEFT JOIN yf_hf_behavior as h on h.video_id = v.id where v.create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP BY b.id HAVING (rent!=0 || sell!=0) ORDER BY b.follow_count ASC";
        $info = Db::table("yf_hf_behavior")
            ->alias('h')
            ->join("yf_hf_video v",'h.video_id = v.id','left')
            ->join("yf_hf_buildings b","b.id = v.building_id",'left')
            ->field("b.id,b.`name`,b.follow_count,count(case when type=23 then type end) rent,count(case when type=24 then type end) sell")
            ->where("v.create_time BETWEEN '{$start_time}' AND '{$stop_time}'")
            ->group("b.id")
            ->order("b.follow_count",'asc')
            ->paginate(10);
//        dump($info);exit;
        $this->assign('info',$info);
        return view('detailtongji');
        //        $list = Db::query($sql);
//        $lists = Db::query($sqls);
//        if ($list == null){
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
//            ->setMetaTitle('单个用户视频发布流程') // 设置页面标题
//            ->addTopButton('self',['title'=>"查询日期{$times}"])  // 添加新增按钮
//            ->addTopButton('self',$back)  // 添加新增按钮
//            ->keyListItem('name','小区名称','name')
//            ->keyListItem('follow_count','关注')
//            ->keyListItem('sell','上传出租房源数')
//            ->keyListItem('rent','上传出售房源数')
//            ->setListPrimaryKey('id')
//            ->setListData($list)    // 数据列表
//            ->setListPage($total) // 数据列表分页
//            ->fetch();
    }

    /**
     * @param Request $req
     * @return \think\response\View
     * @throws \think\exception\DbException
     * 数据筛选
     * 视频转发统计详情页 数据筛选有误 小区表buildings & 用户表users
     */
    public function search(Request $req)
    {
        Log::info("============search==========");
        Log::info(input('post.'));
        $name = $req->param('name');
//        $nickname = $req->param('nickname');
//        $hiid = $req->param('hiid');
//        $phone = $req->param('phone');
        $start_time = strtotime($req->param('start'));
        $stop_time = strtotime($req->param('stop'));
        Log::info("============search1==========");
        //echo $start_time,$stop_time;exit;

        //查询语句
//        $query = Db::table('yf_hf_buildings')
//            ->alias('m')
//            ->join('yf_hf_account_details d','m.id = d.member_id','left')
//            ->field(['m.*,sum(case when d.type=1 or d.type=2 or d.type=3 or d.type=6 or d.type=7 or d.type=8 then d.money end) have,sum(case when d.type=4 or d.type=5 then d.money end) forward'])
//            ->field('m.*')
//            ->where('m.is_robot',0);
//            ->where('m.user_id', 0);
        //原生sql
//        $sql =
//            "select b.id,b.name,sum(case when v.video_type=1 then 1 end) as chushou,sum(case when v.video_type=2 or  v.video_type=0 then 1 end) as chuzu from yf_hf_buildings b
//left join yf_hf_video v
//on v.building_id=b.id
//where b.id=7437
//group by b.name";

        $query = Db::table('yf_hf_buildings')
            ->alias('m')
            ->join('yf_hf_video v','v.building_id = m.id','left')
            ->field('m.id,m.name,m.follow_count,sum(case when v.video_type=1 then 1 end) as rent,sum(case when v.video_type=2 or  v.video_type=0 then 1 end) as sell')
            ->group('m.name');
//        dump($query);exit;



        Log::info("============search2==========");
//        if ($phone) {
//            $query = $query->where('m.phone','like',"%$phone%");
//        }
        Log::info("============search3==========");
//        if ($nickname) {
//            $query = $query->where('m.nikename','like',"%$nickname%");
//        }
        Log::info("============search4==========");
        if ($name) {
            $query = $query->where('m.name', 'like', "%$name%");

        }
        Log::info("============search5==========");
//        if ($hiid) {
//            $query = $query->where('m.hiid','like',"%$hiid%");
//        }
        Log::info("============search6==========");
        if ($start_time || $stop_time) {
            $query = $query->where('m.create_time', '>', $start_time)->where('m.create_time', '<', $stop_time + 86400);
        }
        Log::info("============search7==========");
        //更改查询后 每页显示条数
        $info = $query->group('m.id')->paginate(10);

        Log::info("============search8==========");
        $this->assign('name', $name);
//        $this->assign('nickname',$nickname);
//        $this->assign('hiid',$hiid);
        //$this->assign('sell',$sell);
        $this->assign('start_time', $req->param('start'));
        $this->assign('stop_time', $req->param('stop'));
//        $this->assign('phone',$phone);
        $this->assign('info', $info);
        return view('detailtongji');
    }
}