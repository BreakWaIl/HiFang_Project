<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/17
 * Time: 11:16
 */
namespace app\api\controller;

use app\admin\controller\Tools;
use app\api\extend\QiniuTools;
use app\common\model\Music;
use think\Db;
use think\Log;
use think\Request;
use app\common\model\Buildings as BuildingsModel;
use app\common\model\Video as VideoModel;
use think\Session;
use app\api\controller\Mail;

/**
 * Class Video
 * @package app\api\controller
 */
class Video extends Basic
{
    public $buildingsModel;
    public $videoModel;
    public $musicModel;
    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->buildingsModel = new BuildingsModel();
        $this->videoModel = new VideoModel();
        $this->musicModel = new Music();
        //define('RADIUS',1.2);
    }
    /**
     * 检验该用户是否有发布视频的权限
     * by songjian
     * @return json
     */
    public function checkPower(){
        //查出全局权限
        $data['code'] = 200;
        $res = Tool::getConfigInfo(62);
        //$userId = $this->userId;
        //如果全局不让发视频，则不发视频
        if ($res ==0){
            $data['status'] = false;
            $data['message'] = '管理员不允许全局发视频';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }else{
            //判断用户能否达到一条发视频最大数
            /*$datas = date('Y-m-d',time());
            $data_timestamp_start = strtotime($datas);
            $data_timestamp_stop  = intval($data_timestamp_start+86400);
            $today_video_num = Db::table('yf_hf_video')
                ->where('member_id',$userId)
                ->where('create_time','>',$data_timestamp_start)
                ->where('create_time','<',$data_timestamp_stop)
                ->count();
            $max_video_num = intval(Tool::getConfigInfo(63));
            if ($today_video_num > $max_video_num){
                $data['status'] = false;
                $data['message'] = '今日已达发布视频最大数';
            }else{*/
                $data['status'] = true;
                $data['message'] = '管理员允许发布视频';
            //}
            return json_encode($data,JSON_UNESCAPED_UNICODE);
            /* //如果全局允许发视频
             if (!empty($this->userId)){
                 $data['code'] = 102;
                 $data['message'] = '用户没有登录，必须先去登录';
                 return json_encode($data,JSON_UNESCAPED_UNICODE);
             }else{
                 //如果用户已经登录成功
                 $info = Db::table('yf_hf_member')->where('id',$this->userId)->find();
                 if (!empty($info)){
                     //查询用户的手机号有没有
                     if (empty($info['phone'])){
                         $data['code'] = 103;
                         $data['message'] = '该用户没有手机号纪录，请提醒去绑定手机号';
                         return json_encode($data,JSON_UNESCAPED_UNICODE);
                     }
                     if ($info['is_power'] == 0){
                         $data['code'] = 104;
                         $data['message'] = '该用户没有邀请码，请提醒获取邀请码';
                         return json_encode($data,JSON_UNESCAPED_UNICODE);
                     }
                     $data['code'] = 200;
                     $data['message'] = '验证成功，可以进行视频拍摄';
                     return json_encode($data,JSON_UNESCAPED_UNICODE);
                 }else{
                     $data['code'] = 105;
                     $data['message'] = '用户不存在';
                     return json_encode($data,JSON_UNESCAPED_UNICODE);
                 }
             }*/
        }
    }

    /**
     * 推荐视频房源列表 post
     * @params   导航页传参
     * @params status 0 出租 1 出售
     * @params pageNo 页码
     * @return json
     * @author zyt
     */
    public function getVideoList ()
    {
        $status = $this->params['status'];
        $result['code']    = 101;
        $result['message'] = '';

        if (empty($status)) {
            $status = 0;
        }
        if (isset($this->params['params'])) {
            $params = $this->params['params'];
        }
//        if (!isset($status)) {
//            $result['message'] = '请求状态不能为空';
//            return json_encode($result, JSON_UNESCAPED_UNICODE);
//        } elseif ($status != 0 && $status != 1) {
//            $result['message'] = '请求状态未知状态:' . $status;
//            return json_encode($result, JSON_UNESCAPED_UNICODE);
//        }
        $pageNo = empty($this->params['pageNo']) ? 1 : $this->params['pageNo'];

        if ($this->userId) {
            $video = $this->videoModel->getVideoList($this->userId, $status, $pageNo, $pageSize=10);
        } else {
            $video = $this->videoModel->getVideoLists($status, $pageNo, $pageSize=10);
        }

        if (count($video['list']) > 0) {
            $result['code'] = 200;
            $result['message'] = '查询成功';
            $result['data'] = $video;
        } else {
            $result['code'] = 200;
            $result['message'] = '此条件没有找到数据';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     * 推荐视频列表刷新关注小区,作者,点赞关注视频的状态
     * @param video_id
     * @auther zyt
     * @return string
     */
    public function getStatusByVideoId ()
    {
        $video_id = $this->params['video_id'];

        $result['code']       = 200;
        $result['message']    = '查询关注小区作者状态成功';
        //查询视频信息
        $video = Db::table('yf_hf_video')->where('id', $video_id)->find();
        if (!$video) {
            $result['code']       = 101;
            $result['message'] = '该视频不存在';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //是否关注点赞视频
        $video_follow    = Db::table('yf_hf_follow')->where(['member_id'=>$this->userId,'followed_id'=>$video['id'],'type'=>2])->find();
        //是否关注他人
        $member_follow   = Db::table('yf_hf_follow')->where(['member_id'=>$this->userId,'followed_id'=>$video['member_id'],'type'=>0])->find();
        //是否关注小区
        $building_follow = Db::table('yf_hf_follow')->where(['member_id'=>$this->userId,'followed_id'=>$video['building_id'],'type'=>1])->find();
        //返回该视频信息
        $fields = 'v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.headimgurl,m.hiid,m.unionid,m.is_robot,b.average_price,b.name as building_name,b.address area_name';
        $videos = Db::table('yf_hf_video')->alias('v')
            ->join('yf_hf_member m', 'm.id = v.member_id', 'left')
            ->join('yf_hf_buildings b', 'b.id = v.building_id', 'left')
            ->field($fields)
            ->where('v.id',$video_id)->find();
        $videos['building_name'] = Tool::getBuildingName($videos['area_name'], $videos['building_name']);
        $result['data']       = [
            'video_id'        => $video_id,
            'video_followed'   => 0,
            'member_followed'   => 0,
            'building_followed' => 0,
            'num_visits'      => $video['num_visits'],//浏览量
            'num_comment'     => $video['num_comment'],//评论总数
            'num_favorite'    => $video['num_favorite'],//收藏总数
            'video'           => $videos
        ];
        if ($video_follow && ($video_follow['is_followed'] == 1)) {
            $result['data']['video_followed'] = 1;
        }
        if ($member_follow && ($member_follow['is_followed'] == 1)) {
            $result['data']['member_followed'] = 1;
        }
        if ($building_follow && ($building_follow['is_followed'] == 1)) {
            $result['data']['building_followed'] = 1;
        }

        //浏览量加1
        $videos = Db::table('yf_hf_video')->where('id', $video_id)->setInc('num_visits');
        //浏览数据存入浏览表
        $data['id'] = 0;
        $data['member_id']  = $this->userId;  //用户id
        $data['video_id']   = $video_id;  //视频id
        $data['real_time']  = time();  //
        $data['create_time'] = time();
        $data['update_time'] = time();
        Db::table('yf_hf_lookthrough')->insert($data);

        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     *附近 获取出售（出租）小区列表和视频
     * @params   导航页传参
     * @params status 0 出租 1 出售
     * @params maxlongitude 最大经度
     * @params minlongitude 最小经度
     * @params maxlatitude 最大纬度
     * @params minlatitude 最小纬度
     * @params pageNo 页码
     * @return json
     * @author zyt
     */
    public function getVideoLists ()
    {
        $status    = $this->params['status'];
        $longitude = $this->params['longitude']; //经度
        $latitude  = $this->params['latitude'];  //纬度
        $pageNo = empty($this->params['pageNo']) ? 1 : $this->params['pageNo'];

        $result['code']    = 101;
        $result['message'] = '';
        if (empty($status)) {
            $status = 0;
        }
//        if (!isset($status)) {
//            $result['message'] = '请求状态不能为空';
//            return json_encode($result, JSON_UNESCAPED_UNICODE);
//        } elseif ($status != 0 && $status != 1) {
//            $result['message'] = '请求状态未知状态:' . $status;
//            return json_encode($result, JSON_UNESCAPED_UNICODE);
//        }
        //确定经纬度有没有传过来
        if ($longitude==''||$latitude==''){
            $result['message'] = '没有设置经纬度';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        } elseif ($longitude>135.2 || $longitude<43.4){//判断经度是否符合规范
            $result['message'] = '经度定位错误，定义范围须在43.4-135.2之间';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        } elseif ($latitude>53.33 || $latitude<3.52){//判断纬度是否符合规范
            $result['message'] = '纬度定位错误，定义范围须在53.33-3.52之间';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //获取范围
        $params = Tool::getRang($longitude, $latitude);
        //获取小区和视频列表
        $data = $this->buildingsModel->getBuildingsList($longitude,$latitude,$params['maxlongitude'], $params['minlongitude'], $params['maxlatitude'], $params['minlatitude'], $status, $pageNo, $pageSize = 10);
        if (count($data['list']) > 0 ) {
            $result['code'] = 200;
            $result['message'] = '查询成功';
            $result['data'] = $data;
        } else {
            $result['code'] = 200;
            $result['message'] = '此条件没有找到数据';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     *附近 获取出售（出租）视频(通过小区id查询) 待修改
     * @params   导航页传参
     * @params status 0 出租 1 出售
     * @params maxlongitude 最大经度
     * @params minlongitude 最小经度
     * @params maxlatitude 最大纬度
     * @params minlatitude 最小纬度
     * @params pageNo 页码
     * @return json
     * @author zyt
     */
    public function getVideoListById ()
    {
        $longitude = $this->params['longitude']; //经度
        $latitude  = $this->params['latitude'];  //纬度
        $pageNo = empty($this->params['pageNo']) ? 1 : $this->params['pageNo'];

        $result['code']    = 101;
        $result['message'] = '';
        if (empty($this->params['status'])) {
            $status = 0;
        } else {
            $status = $this->params['status'];
        }
//        if (!isset($status)) {
//            $result['message'] = '请求状态不能为空';
//            return json_encode($result, JSON_UNESCAPED_UNICODE);
//        } elseif ($status != 0 && $status != 1) {
//            $result['message'] = '请求状态未知状态:' . $status;
//            return json_encode($result, JSON_UNESCAPED_UNICODE);
//        }
        //确定经纬度有没有传过来
        if ($longitude==''||$latitude==''){
            $result['message'] = '没有设置经纬度';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        } elseif ($longitude>135.2 || $longitude<43.4){//判断经度是否符合规范
            $result['message'] = '经度定位错误，定义范围须在43.4-135.2之间';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        } elseif ($latitude>53.33 || $latitude<3.52){//判断纬度是否符合规范
            $result['message'] = '纬度定位错误，定义范围须在53.33-3.52之间';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //获取范围
        $params = Tool::getRang($longitude, $latitude);
        if (empty($this->userId)) {
            $this->userId = '';
        }
        //获取小区和视频列表
        $data = $this->videoModel->getVideoByBuildingId($this->userId,$params['maxlongitude'], $params['minlongitude'], $params['maxlatitude'], $params['minlatitude'], $pageNo, $pageSize = 10);
        if (count($data['list']) > 0 ) {
            $result['code'] = 200;
            $result['message'] = '查询成功';
            $result['data'] = $data;
        } else {
            $result['code'] = 200;
            $result['message'] = '此条件没有找到数据';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }


    /**
     * 获取上传视频前的音乐列表
     * by songjian
     * @param pageNo当前页码
     * @return json
     */
    public function musicList(Request $request){
        $data['code'] = 101;
        $data['message'] = "";

        //获取当前的页码
        //$pageNo = empty($request->get('pageNo')) ? 1 : $request->get('pageNo');
        //$pageSize = 10;
        $total = Db::table("yf_hf_music")->count();
        //计算总页数
        //$page = ceil($total/$pageSize);
        //获取当前页的音乐列表
        $info = $this->musicModel->getMusicList();
        if (empty($info)){
            $data['message'] = '查询数据不存在';
        }else{
            $data['code'] = 200;
            $data['message'] = '音乐列表查询成功';
            $data['data']['music_info'] = $info;
            //$data['data']['page'] = $page;
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }


    /**
     *  上传视频信息
     *  by songjian
     * @param title 标题
     * @param video_link 视频链接
     * @param video_type 视频类型
     * @param video_cover 视频封面
     * @param num_room 几室
     * @param num_hall 几厅
     * @param num_toilet 几卫
     * @param area 面积
     * @param price 房价
     * @param longitude 经度
     * @param latitude 纬度
     * @param remarks 个人备注，其它人看不到
     * @return json
     **/
    public function addvideo(Request $request){
        $video_links = $request->post('video_link');
        $res = Db::table('yf_hf_video')->where('video_link',$video_links)->find();
        if ($res){
            $data['code'] = 101;
            $data['message'] = "请勿重复操作";
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        //Log::write('=========addVideo=======');
        //确定上传内容是否满足需求
        if ($request->post('title') ==''){
            $data = array(
                'code'=>101,
                'message' =>'未设置小区名称',
            );
        }elseif ($request->post('video_link') ==''){
            $data = array(
                'code'=>101,
                'message' =>'未传入视频链接',
            );
        }elseif (($request->post('video_type') != 1 && (int)$request->post('video_type') !== 0 && $request->post('video_type') != 2)|| $request->post('video_type') == null){
            $data = array(
                'code'=>101,
                'message' =>'未传入正确的视频类型',
            );
        }elseif ($request->post('video_cover') ==''){
            $data = array(
                'code'=>101,
                'message' =>'未传入视频封面',
            );
        }elseif ($request->post('num_room') =='' || $request->post('num_hall') =='' || $request->post('num_toilet') ==''){
            $data = array(
                'code'=>101,
                'message' =>'未传入全部房型',
            );
        }elseif ($request->post('price') ==''){
            $data = array(
                'code'=>101,
                'message' =>'未传入价格',
            );
        }/*elseif (($request->post('join_rent') != 1 && (int)$request->post('join_rent') !== 0 && $request->post('join_rent') != 2)|| $request->post('join_rent') == null ){
            $data = array(
                'code'=>101,
                'message' =>'未传入正确租售类型',
            );
        }*/elseif ($request->post('area') == ''){
            $data = array(
                'code'=>101,
                'message' =>'未传入面积',
            );
        }elseif ($request->post('longitude') =='' || $request->post('latitude') ==''){
            $data = array(
                'code'=>101,
                'message' =>'未传入经纬度',
            );
        }elseif ($request->post('member_id') == ''){
            $data = array(
                'code'=>101,
                'message' =>'未传入用户id',
            );
        }elseif ($request->post('building_id') ==''){
            $data = array(
                'code'=>101,
                'message' =>'未传入小区id',
            );
        }else{
            //通过上传的building_id获取area_id;
            $area_id = $this->getAreaIdByBuildingId($request->post('building_id'));
            //若上传内容满足，则新增视频操作
            $data['id'] = 0;
            $data['title'] = $request->post('title');  //标题
            $data['video_link'] = $request->post('video_link');  //视频链接
            $data['video_type'] = $request->post('video_type');  //视频类型
            $data['video_cover'] = $request->post('video_cover');  //视频封面
            $data['num_room'] = $request->post('num_room');  //几室
            $data['num_hall'] = $request->post('num_hall');  //几厅
            $data['num_toilet'] = $request->post('num_toilet');  //几卫
            $data['area'] = $request->post('area');  //面积
            $data['price'] = $request->post('price');  //房价
            $data['join_rent'] = $request->post('join_rent'); //是否合租 0 不合租、1 合租
            $data['area_id'] = $area_id;
            $data['longitude'] = $request->post('longitude');  //经度
            $data['latitude'] = $request->post('latitude');  //纬度
            $data['remarks'] = $request->post('remarks');  //个人备注，其它人看不到
            $data['app_version'] = $this->getVersion();  //用户当前版本
            $data['member_id'] = $this->userId;  //用户id
            $data['building_id'] = $request->post('building_id');  //小区id
            $data['create_time'] = time();
            $data['update_time'] = time();

            //将视频数据插入视频表
            $res1 = Db::table('yf_hf_video')->insert($data);
            $video_id = Db::table('yf_hf_video')->getLastInsID();
            if ($res1){
                //将户型图信息更新
                $res2= Imageupload::realmove($video_id,$this->userId);
                if (!$res2){
                    $data = array(
                        'code'=>101,
                        'message' =>'发布失败，图片更新失败',
                    );
                }else{
                    //若发布成功，则将用户表内的视频数量信息更新
                    //并且插入一条数据在账单详情表
                    $res3 = $this->videoModel->updateMemberAndDetailCount($this->userId,$video_id);
                    if ($res3){
                        /**
                         * 此处增加机器人，用于发布后对视频评论和关注改发布者+关注小区+点赞视频
                         * by songjian
                         */
                        Log::write('=========addVideo--robotRules=======');
                        Tool::robotRules(1,$request->post('building_id'),$this->userId,$video_id,$data['video_type']);//评论
                        //发送邮箱存入临时表yf_hf_phpmailer
                        //$re = Mail::addData($this->userId,$video_id);
                        if ($request->post('video_type') == 0 || $request->post('video_type') == 2){
                            Behavior::insertBackBehavior($this->userId,23,$video_id);
                        }elseif($request->post('video_type') == 1){
                            Behavior::insertBackBehavior($this->userId,24,$video_id);
                        }
                        $data = array(
                            'code'=>200,
                            'message' =>'发布成功',
                        );
                    }else{
                        $data = array(
                            'code'=>103,
                            'message' =>'更新用户信息发布数失败',
                        );
                    }
                }
            }else{
                $data = array(
                    'code'=>102,
                    'message' =>'发布失败',
                );
            }
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }


    /**
     *  修改视频信息
     *  by songjian
     * @param title 标题
     * @param video_type 视频类型
     * @param video_cover 视频封面
     * @param num_room 几室
     * @param num_hall 几厅
     * @param num_toilet 几卫
     * @param area 面积
     * @param price 房价
     * @param longitude 经度
     * @param latitude 纬度
     * @param remarks 个人备注，其它人看不到
     * @return json
     **/
    public function editVideo(Request $request){
        //当进行修改环节，更新视频数据
        if (!empty($_POST)){
            //确定至少上传了小区名称
            if ($request->post('title') !='' && $request->post('num_room') !='' && $request->post('num_hall') !='' && $request->post('num_toilet') !='' && $request->post('area') !='' && $request->post('price') !='' && $request->post('building_id') !=''){
                $data['title'] = $request->post('title');  //标题
                $data['video_link'] = $request->post('video_link');  //视频链接
                $data['video_type'] = $request->post('video_type');  //视频类型
                $data['video_cover'] = $request->post('video_cover');  //视频封面
                $data['num_room'] = $request->post('num_room');  //几室
                $data['num_hall'] = $request->post('num_hall');  //几厅
                $data['num_toilet'] = $request->post('num_toilet');  //几卫
                $data['area'] = $request->post('area');  //面积
                $data['price'] = $request->post('price');  //房价
                $data['join_rent'] = $request->post('join_rent'); //是否合租 0 不合租、1 合租
                $data['remarks'] = $request->post('remarks');  //个人备注，其它人看不到
                $data['app_version'] = $this->getVersion();  //用户当前版本
                $data['update_time'] = time();

                $video_id = $request->post('video_id');
                $res = $this->videoModel->editVideo($video_id,$data);
                if ($res){
                    $res= Imageupload::realmove($video_id,$this->userId);
                    if (!$res){
                        $data = array(
                            'code'=>101, 'message' =>'发布失败，图片更新失败',
                        );
                    }else{
                        $data = array(
                            'code'=>200, 'message' =>'发布成功',
                        );
                    }
                }else{
                    $data = array(
                        'code'=>102, 'message' =>'发布失败',
                    );
                }
                //暂时没有做编辑信息编辑图片的功能
                if ($res){
                    $data = array(
                        'code'=>200, 'message' =>'修改成功',
                    );
                }else{
                    $data = array(
                        'code'=>101, 'message' =>'修改失败',
                    );
                }
            }else{
                $data = array(
                    'code'=>101, 'message' =>'请把表单填写完全',
                );
            }
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }else{
            $data['code'] = 101;
            $data['message'] = '';
            //查询本视频的信息显示到前端页面
            $video_id = $request->get('video_id');
            $info = Db::table('yf_hf_video')->where('id',$video_id)->find();
            if (empty($info)){
                $data['message'] = '未查询到视频消息';
            }else{
                $data['code'] = 200;
                $data['message'] = '视频查询成功';

                $build_name = Db::table('yf_hf_buildings')->field(['name'])->where('id',$info['building_id'])->find()['name'];
                //获取房子类型（几室几厅）
                $build_type = '';
                switch ($info['num_room']){
                    case 1 :
                        $build_type .= "一室";break;
                    case 2 :
                        $build_type .= "二室";break;
                    case 3 :
                        $build_type .= "三室";break;
                    default :
                        $build_type .= "";
                }
                switch ($info['num_hall']){
                    case 1 :
                        $build_type .= "一厅";break;
                    case 2 :
                        $build_type .= "二厅";break;
                    case 3 :
                        $build_type .= "三厅";break;
                    default :
                        $build_type .= "";
                }
                //查询出本视频的户型图
                $imgs = Db::table('yf_hf_imgs')->field(['id','image_name','create_time'])->where('video_id',$info['id'])->select();
                $count = count($imgs);
                $image = [];
                for ($i=0;$i<$count;$i++){
                    //取到时间日期[年月日]
                    $timearr = explode(" ",$imgs[$i]['create_time']);
                    $time = str_replace('-','',$timearr[0]);
                    //$image[$i]['id']  = base64_encode($imgs[$i]['id']);
                    //image_id改参数名
                    $image[$i]['img_id']  = base64_encode($imgs[$i]['id']);
                    $image[$i]['url'] = Tool::getImageUrl($time,$imgs[$i]['image_name']);
                }


                $data['data'] = array(
                    'id'    => $info['id'],
                    'title' => $info['title'],
                    'video_link' => $info['video_link'],
                    'video_type' => $info['video_type'],
                    'video_cover'=> $info['video_cover'],
                    'num_room'   => (string)$info['num_room'],
                    'num_hall'   => (string)$info['num_hall'],
                    'num_toilet' => (string)$info['num_toilet'],
                    'build_type' => $build_type,
                    'price'      => (string)$info['price'],
                    'join_rent'  => $info['join_rent'],
                    'area'       => (string)$info['area'],
                    'longitude'  => $info['longitude'],
                    'latitude'   => $info['latitude'],
                    'remarks'    => $info['remarks'],
                    'member_id'  => $info['member_id'],
                    'building_id'=> $info['building_id'],
                    'building_name' => $build_name,
                    'img_info'    => $image
                );
            }
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
    }

    /**修改我发布的视频的状态  上架/下架
     * @params video_id   视频id
     * @return json
     * @author zyt
     */
    public function upOrDownVideo ()
    {
        $video_id = $this->params['video_id'];

        $result['code']    = 101;
        $result['message'] = '';
        if (!isset($video_id)) {
            $result['message'] = '请传入视频id';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //查询该视频是否存在
        $video = $this->videoModel->find($video_id);
        if (count($video) == 0) {
            $result['message'] = '该视频信息不存在';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //修改视频状态
        $data = $this->videoModel->upOrDownVideo($video_id, $video['status']);
        $res = $this->videoModel->where('id',$video_id)->find();
        if ($data) {
            $result['code']    = 200;
            $result['message'] = '更新视频状态成功';
            $result['data']    = $res['status'];
        } else {
            $result['message'] = '更新视频状态失败';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**删除我发布的视频
     * @params video_id   视频id
     * @return json
     * @author zyt
     */
    public function deleteVideo ()
    {
        $video_id = $this->params['video_id'];

        $result['code']    = 101;
        $result['message'] = '';
        if (!isset($video_id)) {
            $result['message'] = '请传入视频id';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //查询该视频是否存在
        $video = $this->videoModel->find($video_id);
        if (count($video) == 0) {
            $result['message'] = '该视频信息不存在';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //删除七牛云视频和封面图
        $video_url = $video['video_link'];
        $img_url   = $video['video_cover'];
        $videoUrl  = explode('/', $video_url);
        $imgUrl    = explode('/', $img_url);
        //视频key
        $videoKey  = $videoUrl[count($videoUrl)-1];
        //封面图key
        $imgKey    = $imgUrl[count($imgUrl)-1];

        if ($videoKey) {
            $videoData = QiniuTools::delete($videoKey);
        }
        if ($imgKey) {
            $imgData   = QiniuTools::delete($imgKey);
        }
        //删除数据库数据
        $data = $this->videoModel->where('id',$video_id)->update(['is_delete'=>1]);
        //更新发布数setDec
        $update_member = Db::table('yf_hf_member')->where('id',$this->userId)->setDec('num_publish');
        //删除账单详情表记录
        $account_detail = Db::table('yf_hf_account_details')->where('video_id',$video_id)->update(['status'=>2]);

        if ($data) {
            $result['code'] = 200;
            $result['message'] = '删除成功';
        } else {
            $result['message'] = '删除失败';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     * 添加视频时-通过building_id去返回此小区的area_id
     * by songjian
     */
    public function getAreaIdByBuildingId($building_id){
        $address = Db::table('yf_hf_buildings')
            ->field(['address'])
            ->where('id',$building_id)
            ->find()['address'];
        $building_address = substr($address,1,6);
        if ($building_address == "上海"){
            //上海周边的area_id
            $area_id = 716;
        }else{
            $building_address .= '区';
            $area_id = Db::table('yf_hf_area')
                ->field(['id'])
                ->where('dic_value',$building_address)
                ->find()['id'];
        }
        return $area_id;
    }


    /**
     * 作者主页 作者发布的出租出售视频列表get
     * @params type  0出租 1出售
     * @params member_id  发布人id
     * @params member_id  发布人id
     * @params pageNo 页码
     * @params pageSize 每页显示条数
     * @return json
     * @author zyt
     */
    public function getVideoByMemberId (Request $req)
    {
        header("Access-Control-Allow-Origin: *");
        $type        = $req->get('type');
        $member_id   = $req->get('member_id');

        $result['code']    = 101;
        $result['message'] = '';
        if (!isset($type)) {
            $result['message']    = '请求状态不能为空';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        if ($type != 0 && $type!= 1) {
            $result['message']    = '请求状态异常:' . $type;
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        if (empty($member_id)) {
            $result['message']    = '请求用户id不能为空';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        $pageNo      = empty($req->get('pageNo')) ? 1 : $req->get('pageNo');

        //查询租出售房源视频列表
        $data= $this->videoModel->getVideoByMemberId($this->userId,$member_id, $type, $pageNo, $pageSize=10);
        if (count($data['list']) > 0) {
            $result['code']    = 200;
            $result['data']    = $data;
            $result['message'] = '查询成功';
        } else {
            $result['code']    = 200;
            $result['message'] = '没有符合该条件的信息';
        }
        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**获取单视频房源信息详情get(暂时不用此接口)
     * @params video_id 视频id
     * @return json
     * @author zyt
     */
    public function getVideoDetail (Request $req)
    {
        $video_id = $req->get('video_id');

        $result['code']    = 101;
        $result['message'] = '';

        if (empty($video_id)) {
            $result['message'] = '请传入视频id';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        //查询视频信息
        $video = $this->videoModel->getVideoDetail($this->userId,$video_id);
        $num_visits = $video['num_visits'];
        $num_visits = $num_visits + 1;
        //添加浏览量
        $res = $this->videoModel->where(['id'=>$video_id])->update(['num_visits'=>$num_visits]);
        if (count($video) > 0) {
            $result['code']    = 200;
            $result['message'] = '查询成功';
            $result['data']['list'][]    = $video;
            $result['data']['total']   = 1;
        } else {
            $result['code']    = 200;
            $result['message'] = '未查询到该视频信息';
        }
        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 根据x、y范围查找一系列的小区
     * by songjian
     * @return json
     */
    public function findCommunity(Request $req){
        $data['code'] = 101;
        $longitude = $req->post('longitude'); //经度
        $latitude  = $req->post('latitude');  //纬度
        //$radius  = RADIUS;                          //半径（km）
        //分页数据产生
        $pageNo = empty($req->post('pageNo')) ? 1 : $req->post('pageNo');

        //确定经纬度有没有传过来
        if ($longitude==''||$latitude==''){
            $data['code'] = 101;
            $data['message'] = '没有设置经纬度';
        }
        /*elseif ($radius ==''){
            $data['code'] = 101;
            $data['message'] = '没有设置半径';
        }*/
        //判断经度是否符合规范
        elseif ($longitude>135.2 || $longitude<43.4){
            $data['code'] = 102;
            $data['message'] = '经度定位错误，定义范围须在43.4-135.2之间';
        }
        //判断纬度是否符合规范
        elseif ($latitude>53.33 || $latitude<3.52){
            $data['code'] = 103;
            $data['message'] = '纬度定位错误，定义范围须在53.33-3.52之间';
        }else{
            /*$range = 180 / pi() * $radius / 6371;     //里面的 $radius 就代表搜索 $radius Km 之内，单位km
            $lngR = $range / cos($latitude * pi() / 180);
            $maxlatitude = $latitude + $range;//最大纬度
            $minlatitude = $latitude - $range;//最小纬度
            $maxlongitude = $longitude + $lngR;//最大经度
            $minlongitude = $longitude - $lngR;//最小经度*/
            $params = Tool::getRang($longitude, $latitude);
            //获取小区列表
            $buildingsList = $this->buildingsModel->getBuildingsListLittle($params['maxlongitude'], $params['minlongitude'], $params['maxlatitude'], $params['minlatitude'],$pageNo,$pageSize=10,$longitude,$latitude);
            if ($buildingsList){
                $data['code'] = 200;
                $data['message'] = '查询成功';
                $data['data']['building_data'] = $buildingsList['build'];
                $data['data']['page'] = $buildingsList['page'];
            } else {
                $data['code'] = 200;
                $data['message'] = '此条件没有找到数据';
            }
        }
        return json_encode($data, JSON_UNESCAPED_UNICODE);
    }

    /**
     * 根据“x、y”“范围”和“搜索框”查找一系列的小区
     * by songjian
     * @return json
     */
    public function handFindCommunity(Request $req){
        $data['code'] = 101;
        $longitude = $req->post('longitude'); //经度
        $latitude  = $req->post('latitude');  //纬度
        $keyword   = $req->post('keyword');   //搜索关键词
        //$radius  = RADIUS;                  //半径（km）
        //分页数据产生
        $pageNo = empty($req->post('pageNo')) ? 1 : $req->post('pageNo');

        if ($keyword==''){
            $data['code'] = 101;
            $data['message'] = '请传入关键字';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }

        //确定经纬度有没有传过来
        if ($longitude==''||$latitude==''){
            $data['code'] = 101;
            $data['message'] = '没有设置经纬度';
        }
        /*elseif ($radius ==''){
            $data['code'] = 101;
            $data['message'] = '没有设置半径';
        }*/
        //判断经度是否符合规范
        elseif ($longitude>135.2 || $longitude<43.4){
            $data['code'] = 102;
            $data['message'] = '经度定位错误，定义范围须在43.4-135.2之间';
        }
        //判断纬度是否符合规范
        elseif ($latitude>53.33 || $latitude<3.52){
            $data['code'] = 103;
            $data['message'] = '纬度定位错误，定义范围须在53.33-3.52之间';
        }else{
            /*$range = 180 / pi() * $radius / 6371;     //里面的 $radius 就代表搜索 $radius Km 之内，单位km
            $lngR = $range / cos($latitude * pi() / 180);
            $maxlatitude = $latitude + $range;//最大纬度
            $minlatitude = $latitude - $range;//最小纬度
            $maxlongitude = $longitude + $lngR;//最大经度
            $minlongitude = $longitude - $lngR;//最小经度*/
            $params = Tool::getFindRang($longitude, $latitude);
            //获取小区列表
            $buildingsList = $this->buildingsModel->getFindBuildingsListLittle($keyword,$params['maxlongitude'], $params['minlongitude'], $params['maxlatitude'], $params['minlatitude'],$pageNo,$pageSize=10,$longitude,$latitude);
            if ($buildingsList){
                $data['code'] = 200;
                $data['message'] = '查询成功';
                $data['data']['building_data'] = $buildingsList['build'];
                $data['data']['page'] = $buildingsList['page'];
            } else {
                $data['code'] = 200;
                $data['message'] = '此条件没有找到数据';
            }
        }
        return json_encode($data, JSON_UNESCAPED_UNICODE);
    }

    /**
     * 分享视频得红包-拼接转发信息
     * by songjian
     * @return json
     */
    public function shareVideo(Request $request){
        $data['code'] = 101;
        $data['message'] = '未知错误';

        $video_ids = $request->get('video_id');  //eg video_id=65
        if (empty($video_ids)){
            $data['message'] = '请传入video_id';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        //查询本视频的基本信息
        $info = Db::table('yf_hf_video')->where('id',$video_ids)->find();
        //$member_id = base64_encode($info['member_id']);
        $member_id = base64_encode($this->userId);
        $video_id = base64_encode($video_ids);
        if ($info){
            //将分享信息插入到分享表中
            $share_info = array(
                'id'        => 0,
                'member_id' => $this->userId,
                'video_id'  => $video_ids,
                'shared_user_id' => $info['member_id'],
                'create_time' => time(),
                'update_time' => time(),
            );
            $res = Db::table('yf_hf_share')->insert($share_info);
            if ($res){
                //若插入成功，则提示转发信息流程成功
                $data['code'] = 200;
                $data['message'] = '转发信息拼接成功';
                $data['data'] = array(
                    'web' => "{$info['video_link']}?member_id={$member_id}&id={$video_id}",
                    'video_cover' => $info['video_cover']
                );
            }else{
                $data['code'] = 101;
                $data['message'] = '分享视频插入分享表失败';
            }
        }else{
            $data['message'] = '视频未查询到，拼接失败';
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 分享视频得红包-判断观看的视频是否是分享观看的数据
     * by songjian
     * @param website 视频网址[video_id+user_id]
     */
    //public function shareWatch(Request $request){
    public static function shareWatch($unionid,$website){
        Log::info("============1==============");
        //header("Access-Control-Allow-Origin: *"); // 允许任意域名发起的跨域请求
        $data['code'] = 101;
        $data['message'] = '';
        if (empty($website) || $website == "STATE"){
            Log::info("============2==============");
            $data['message'] = "请传入website";
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        /**
         * 首先要判断这个用户是否在我们的用户表的数据库中【调用这个接口之前要去调用授权接口，将用户信息插入到表中】
         * 第一次是加金额的，但是以后就不加金额【通过账户明细表去判断】
         */
        if (empty($unionid)){
            Log::info("============3==============");
            $data['code'] = 101;
            $data['message'] = 'unionid不能为空';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        $begin = strtotime(date('Y-m-d',time()));
        $end   = (int)($begin + 86400);

        $counts = Db::table('yf_hf_account_details')
                    ->where('Recommend_member_id',$unionid)
                    ->where('create_time','>',$begin)
                    ->where('create_time','<',$end)
                    ->where('type',2)
                    ->count();
        Log::info("============".$counts."==============");
        if ($counts == 0){
            //得出转发阅读奖励金额
            $money = Tool::getConfigInfo(66);

            //将user_id 和 video_id 解析出来并判断
            $res = str_replace('?','',strrchr($website,'?'));
            $info = explode('&',$res);
            $counts = count($info);
            Log::info("============4==============");
            for ($i=0;$i<$counts;$i++){
                //$info[$i] = str_replace('=','',strrchr($info[$i],'='));
                //$info[$i] = ltrim(strrchr($info[$i],'='),'=');
                //$info[$i] = substr(strrchr($info[$i],'='),1);
                $info[$i] = substr(strchr($info[$i],'='),1);
            }
            //当存在user_id和video_id的时候
            if ($counts==2){
                Log::info("============5==============");
                $member_id = base64_decode($info[0]);
                $video_id = base64_decode($info[1]);
                //首要判断若本视频发布时间超过七天，则不再进行奖励机制
                $strtotime = strtotime(date('Y-m-d H:i:s'));
                //$video_create_time = Db::table('yf_hf_video')->field(['create_time'])->where('id',$video_id)->find()['create_time'];
                $video_create_time = Db::table('yf_hf_account_details')->field(['create_time'])->where('type',2)->where('video_id',$video_id)->where('member_id',$member_id)->order('create_time asc')->find()['create_time'];
                $result_time = (int)($strtotime - $video_create_time);
                /**
                 * 视频自分享那天算起，七天内不进行奖励
                 * update by songjian
                 */
                if ($result_time > 60*60*24*7 && $video_create_time != null){
                    $data['code'] = 200;
                    $data['message'] = "该视频超出七天，不再进行奖励";
                    Log::info("============6==============");
                    return json_encode($data,JSON_UNESCAPED_UNICODE);
                }else{
                    //判断拥有视频用户的一天奖励金额是否达到上限
                    $sum_money = Db::table('yf_hf_account_details')
                        ->where('member_id',$member_id)
                        ->where('create_time','>',$begin)
                        ->where('create_time','<',$end)
                        ->where('type',2)
                        ->sum('money');
                    $video_total_reward = Tool::getConfigInfo(73);
                    Log::info("============".$video_total_reward."==============");
                    Log::info("============".$sum_money."==============");
                    if ($sum_money >= $video_total_reward){
                        $data['code'] = 200;
                        $data['message'] = "此用户的一天奖励金额已达到上限";
                        Log::info("============7==============");
                        return json_encode($data,JSON_UNESCAPED_UNICODE);
                    }else{
                        //更新该用户的钱包余额
                        $res1 =Db::table('yf_hf_member')->where('id',$member_id)->setInc('balance',$money);
                        //更新账单详情纪录
                        $datas = array(
                            'id'        => 0,
                            'member_id' => $member_id,
                            'video_id'  => $video_id,
                            'Recommend_member_id' => $unionid,
                            'money'     => $money,
                            'type'      => 2,
                            'create_time'=> time(),
                            'update_time'=> time(),
                        );
                        $res2 =Db::table('yf_hf_account_details')->insert($datas);
                        if ($res1 && $res2){
                            $data['code'] = 200;
                            Log::info("============8==============");
                            $data['message'] = '观看分享视频成功（奖励积分）';
                        }else{
                            Log::info("============9==============");
                            $data['message'] = '观看分享视频失败';
                        }
                    }

                    /*
                    //判断当本视频的奖励嗨币未达到上限时才可以奖励
                    $total = Tool::getConfigInfo(73);
                    $today_money = Db::table('yf_hf_account_details')
                        ->where('video_id',$video_id)
                        ->where('create_time','>',$begin)
                        ->where('create_time','<',$end)
                        ->sum('money');
                    //若每日的单视频奖励超过50嗨币
                    if ($today_money > 50){
                        $data['message'] = '每日奖励已达到上限';
                    }else{
                        $nowmoney = Db::table('yf_hf_account_details')->where('video_id',$video_id)->sum('money');
                        if($nowmoney < $total){
                            //更新该用户的钱包余额
                            $res1 =Db::table('yf_hf_member')->where('id',$member_id)->setInc('balance',$money);
                            //更新账单详情纪录
                            $datas = array(
                                'id'        => 0,
                                'member_id' => $member_id,
                                'video_id'  => $video_id,
                                'Recommend_member_id' => $unionid,
                                'money'     => $money,
                                'type'      => 2,
                                'create_time'=> time(),
                                'update_time'=> time(),
                            );
                            $res2 =Db::table('yf_hf_account_details')->insert($datas);
                            if ($res1 && $res2){
                                $data['code'] = 200;
                                $data['message'] = '观看分享视频成功（奖励积分）';
                            }else{
                                $data['message'] = '观看分享视频失败';
                            }
                        }else{
                            $data['message'] = '分享视频奖励金额达到上限';
                        }
                    }*/
                }

            }else{
                $data['message'] = '用户自己访问，不属于分享入口';
            }
        }else{
            $data['code'] = 200;
            $data['message'] = '用户非首次观看，观看分享视频成功（不奖励积分）';
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 获取微信端视频详情
     * @param video_id
     * @auther zyt
     */
    public function getWXVideoDetail (Request $req)
    {
        header("Access-Control-Allow-Origin: *");
        $video_id = $req->get('video_id');
        $member_id = $req->get('member_id');
        $result['code']    = 101;
        $result['message'] = '';
        if (empty($video_id)) {
            $result['message'] = '该传入视频id';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        if (empty($member_id)) {
            $result['message'] = '该传入用户id';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //查询分享用户的信息
        $member = Db::table('yf_hf_member')->where('id',$member_id)->field('id,nickname,headimgurl,unionid')->find();
        //获取头像地址
        if ($member['unionid']){
            $member['headimgurl'] = $member['headimgurl'];
        }else{
            $member['headimgurl'] = Tool::getDomain().$member['headimgurl'];
        }
        //查询视频是否存在
        $video = Db::table('yf_hf_video')->alias('v')
            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
            ->field('v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,b.name,b.average_price,b.address as area_name,m.nickname,m.headimgurl,m.hiid,m.unionid')
            ->where('v.id', $video_id)->find();
        if ($video) {
            $video['name']= Tool::getBuildingName($video['area_name'],$video['name']);
            //获取头像地址
            if ($video['unionid']){
                $video['headimgurl'] = $video['headimgurl'];
            }else{
                $video['headimgurl'] = Tool::getDomain().$video['headimgurl'];
            }

            $result['code']          = 200;
            $result['message']       = '查询成功';
            $result['data']['member']= $member;
            $result['data']['video'] = $video;

            //查询该用户发布的其他视频 若没有则随机显示
            $videoList = Db::table('yf_hf_video')->alias('v')
                ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
                ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
                ->field('v.*,b.name,b.average_price,m.nickname')
                ->where(['v.member_id'=>$video['member_id'],'v.is_delete'=>0])->limit(10)->select();
            if (count($videoList) == 0) {
                $videoList = Db::table('yf_hf_video')->alias('v')
                    ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
                    ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
                    ->field('v.*,b.name,b.average_price,m.nickname')
                    ->where('v.is_delete',0)
                    ->limit(10)->select();
            }
            $result['data']['list']  = $videoList;

            //更新该视频的浏览量
            $videos = Db::table('yf_hf_video')->where('id',$video_id)->setInc('num_visits');
        } else {
            $result['code']    = 200;
            $result['message'] = '该条件查询为空';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     * 不感兴趣操作
     * @param Request $request
     * @return string
     */
    public function Uninterested(Request $request){
        $data['code'] = 101;
        $data['message'] = '';
        $member_id  = $this->userId;
        $video_id   = (int)$request->post('video_id');
        $video_type = (int)$request->post('video_type');
        $num_room   = (int)$request->post('num_room');
        $num_hall   = (int)$request->post('num_hall');
        if (empty($member_id)){
            $data['message'] = "请先登录再进行该操作";
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }else{
            if ((empty($video_id)&&$video_id!=0)||(empty($video_type)&&$video_type!=0)||(empty($num_room)&&$num_room!=0)||(empty($num_hall)&&$num_hall!=0)){
                $data['message'] = "请完整传入不感兴趣的参数";
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }else{
                $res = Db::table('yf_hf_uninterested')->where('video_id',$video_id)->where('member_id',$member_id)->find();
                if ($res){
                    $data['code'] = 200;
                    $data['message'] = "已重复点击，新增失败";
                    return json_encode($data,JSON_UNESCAPED_UNICODE);
                }
                $datas = array(
                    'id'         => 0,
                    'member_id'  => $member_id,
                    'video_id'   => $video_id,
                    'video_type' => $video_type,
                    'num_room'   => $num_room,
                    'num_hall'   => $num_hall,
                    'create_time'=> time(),
                    'update_time'=> time(),
                );
                $res = Db::table('yf_hf_uninterested')->insert($datas);
                if ($res){
                    $data['code'] = 200;
                    $data['message'] = "我们尽量不为您显示此类视频";
                }else{
                    $data['message'] = "插入不感兴趣表失败";
                }
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
        }
    }

    /**
     * 进入视频列表页再次筛选[弃用]
     * by songjian
     */
    public function findAgain(Request $request){
        $data['code'] = 101;
        $data['message'] = '';
        //1 出售 2 出租
        $type = $request->post('type');
        $areaid = $request->post('area_id');
        $minprice = $request->post('minprice');
        $maxprice = $request->post('maxprice');
        $minarea  = $request->post('minarea');
        $maxarea  = $request->post('maxarea');
        $num_room = $request->post('num_room');
        $video_type = $request->post('video_type');
        if ($type ==1 || $type ==2){
            if ($type == 1 ){
                //出售搜索
                $sql = "select v.id as id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.unionid,m.headimgurl,b.name as building_name,b.average_price,b.address as area_name from ((yf_hf_video as v INNER join yf_hf_member as m on v.member_id=m.id) left join `yf_hf_buildings` as b ON  v.building_id = b.id) where v.video_type=1 and v.area_id= $areaid ";
                if (!empty($minprice) && empty($maxprice) && $maxprice !== 0){
                    $sql .= " and v.price > $minprice ";
                }else{
                    $sql .= " and v.price BETWEEN  $minprice and $maxprice ";
                }
                if (!empty($minarea) && empty($maxarea) && $maxarea != 0){
                    $sql .= " AND v.area > $minarea ";
                }else{
                    $sql .= " AND v.area BETWEEN $minarea AND $maxarea ";
                }
                if ($num_room!=''){
                    $sql .= " and v.num_room = $num_room";
                }else{
                    $sql .= " and (v.num_room != 1 and v.num_room != 2 and v.num_room != 3)";
                }
                $res = Db::query($sql);
            }elseif ($type == 2 ){
                //出租搜索
                $sql = "select v.id as id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.unionid,m.headimgurl,b.name as building_name,b.average_price,b.address as area_name from ((yf_hf_video as v INNER join yf_hf_member as m on v.member_id=m.id) left join `yf_hf_buildings` as b ON  v.building_id = b.id)  where v.video_type = $video_type and v.area_id= $areaid ";
                if (!empty($minprice) && empty($maxprice) && $maxprice !== 0){
                    $sql .= " and v.price > $minprice ";
                }else{
                    $sql .= " and v.price BETWEEN  $minprice and $maxprice ";
                }
                if ($num_room!=''){
                    $sql .= " and v.num_room = $num_room";
                }else{
                    $sql .= " and (v.num_room != 1 and v.num_room != 2 and v.num_room != 3)";
                }
                $res = Db::query($sql);
            }
            $member_id = $this->userId;
            for ($i=0;$i<count($res);$i++) {
                $rem = array();
                $address = preg_match_all("/(?:\()(.*)(?:\))/i", $res[$i]['area_name'], $rem);
                $res[$i]['area_name'] = $rem[1][0];
                $res[$i]['address'] = $rem[1][0] . '/' . $res[$i]['building_name'];
                $video1 = mb_substr($res[$i]['area_name'], 0, 2);
                $video2 = mb_substr($res[$i]['area_name'], 2);
                $res[$i]['building_name'] = $video1 . '/' . $video2 . '/' . $res[$i]['building_name'];

                //查询该用户是否关注小区,关注发布人,关注点赞视频
                $res[$i]['member_followed'] = 0;
                $res[$i]['building_followed'] = 0;
                $res[$i]['video_followed'] = 0;
                $member_follow = Db::table('yf_hf_follow')->where(['member_id' => $member_id, 'followed_id' => $res[$i]['member_id'], 'type' => 0])->find();
                $building_follow = Db::table('yf_hf_follow')->where(['member_id' => $member_id, 'followed_id' => $res[$i]['building_id'], 'type' => 1])->find();
                $video_follow = Db::table('yf_hf_follow')->where(['member_id' => $member_id, 'followed_id' => $res[$i]['id'], 'type' => 2])->find();
                if ($member_follow && ($member_follow['is_followed'] == 1)) {
                    $res[$i]['member_followed'] = 1;
                }
                if ($building_follow && ($building_follow['is_followed'] == 1)) {
                    $res[$i]['building_followed'] = 1;
                }
                if ($video_follow && ($video_follow['is_followed'] == 1)) {
                    $res[$i]['video_followed'] = 1;
                }
                //手机/微信头像适配
                if ($res[$i]['unionid']) {
                } else {
                    $res[$i]['headimgurl'] = Tool::getDomain() . $res[$i]['headimgurl'];
                }
            }
            $data['code'] = 200;
            $data['message'] = '查询成功';
            $data['list']['data'] = $res;
            $data['list']['total'] = count($res);
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }else{
            $data['message'] = '传入type有误，请重新输入';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
    }

    /**
     * 首页的搜索[通过输入的小区名和地址搜索本小区视频][弃用]
     * by songjian
     */
    public function search(Request $request){
        $keyword = $request->get('keyword');
        $building_id = "";
        $res = Db::table('yf_hf_buildings')->field(['id'])->where('name','like',"%{$keyword}%")->whereOr('address','like',"%{$keyword}%")->select();
        foreach ($res as $item){
            $building_id .= "'{$item['id']}',";
        }
        $building_id = substr($building_id,0,strlen($building_id)-1);
        $sql = "select v.id as id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.unionid,m.headimgurl,b.name as building_name,b.average_price,b.address as area_name from ((yf_hf_video as v INNER join yf_hf_member as m on v.member_id=m.id) left join `yf_hf_buildings` as b ON  v.building_id = b.id) WHERE v.building_id in($building_id)";
        $res = Db::query($sql);
        $member_id = $this->userId;
        for ($i=0;$i<count($res);$i++) {
            $res[$i]['building_name'] = Tool::getBuildingName($res[$i]['area_name'],$res[$i]['building_name']);
            //查询该用户是否关注小区,关注发布人,关注点赞视频
            $res[$i]['member_followed'] = 0;
            $res[$i]['building_followed'] = 0;
            $res[$i]['video_followed'] = 0;
            $member_follow = Db::table('yf_hf_follow')->where(['member_id' => $member_id, 'followed_id' => $res[$i]['member_id'], 'type' => 0])->find();
            $building_follow = Db::table('yf_hf_follow')->where(['member_id' => $member_id, 'followed_id' => $res[$i]['building_id'], 'type' => 1])->find();
            $video_follow = Db::table('yf_hf_follow')->where(['member_id' => $member_id, 'followed_id' => $res[$i]['id'], 'type' => 2])->find();
            if ($member_follow && ($member_follow['is_followed'] == 1)) {
                $res[$i]['member_followed'] = 1;
            }
            if ($building_follow && ($building_follow['is_followed'] == 1)) {
                $res[$i]['building_followed'] = 1;
            }
            if ($video_follow && ($video_follow['is_followed'] == 1)) {
                $res[$i]['video_followed'] = 1;
            }
            //手机/微信头像适配
            if ($res[$i]['unionid']) {
            } else {
                $res[$i]['headimgurl'] = Tool::getDomain() . $res[$i]['headimgurl'];
            }
        }
        $data['code'] = 200;
        $data['message'] = '查询成功';
        $data['list']['data'] = $res;
        $data['list']['total'] = count($res);
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }
}