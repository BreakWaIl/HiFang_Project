<?php
/**
 * Created by PhpStorm.
 * User: zfc
 * Date: 2018/4/15
 * Time: 17:51
 */

namespace app\api\controller;

use app\common\model\Buildings as BuildingsModel;
use app\common\model\Video;
use think\Db;
use think\Request;

class Buildings extends Basic
{
    public $buildModel;
    public $videoModel;
    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->buildModel = new BuildingsModel();
        $this->videoModel = new Video();
    }

    /**
     * 通过经纬度查取小区
     * by songjian
     * @param longitude 小区经度
     * @param latitude 小区纬度
     * @return json
     */
    public function find(Request $request)
    {
        $longitude=$request->get('longitude');
        $latitude=$request->get('latitude');
        $data = array();
        //确定经纬度有没有传过来
        if ($longitude==''||$latitude==''){
            $data['code'] = 101;
            $data['message'] = '没有设置经纬度';
        }
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
            //通过经纬度查询小区
            $data['code'] = 200;
            $info = $this->buildModel->getXiaoquByXY($longitude,$latitude);
            if ($info){
                $data['data'] = $info;
                $data['message'] = '经纬度查询小区成功';
            }else{
                $data['message'] = '此经纬度查无小区';
            }
        }
        //返回规则
        $info = json_encode($data,JSON_UNESCAPED_UNICODE);
        return $info;
    }

    /**小区主页--小区信息详情
     * @params pageNo 页码
     * @params pageSize 每页显示条数
     * @params building_id  小区id
     * @return json
     * @author zyt
     */
    public function getBuildingDetail()
    {
        $building_id      = $this->params['building_id'];

        $result['code']   = 101;
        $result['message']= '';
        if (empty($building_id)) {
            $result['message']  = '请传入小区id';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        //查询building_id对应的小区信息数据
        $build = $this->buildModel->find($building_id);
        if (!$build) {
            $result['message']  = '查询小区不存在';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        $data = $this->buildModel->getDetailByBuildingId($this->userId,$building_id);
        $data['type'] = 2;
        //查询该小区是否有视频数据 出租数据$data['type']=1 出售数据$data['type']=2
        $data1 = Db::table('yf_hf_video')->where(['building_id'=>$building_id,'is_delete'=>0])->whereIn('video_type',[0,2])->count();//出租
        $data2 = Db::table('yf_hf_video')->where(['video_type'=>1,'building_id'=>$building_id,'is_delete'=>0])->count();//出售

        if ($data2 > 0) {
            $data['type'] = 0;
        } else {
            if ($data1 > 0) {
                $data['type'] = 1;
            } else {
                $data['type'] = 2;
            }
        }

        if (count($data) > 0) {
            $result['code']    = 200;
            $result['data']    = $data;
            $result['message'] = '查询成功';
        } else {
            $result['code']    = 200;
            $result['message'] = '没有符合该条件的信息';
        }
        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**获取小区主页--小区出租出售房源视频列表
     * @params type  0出租 1出售
     * @params building_id  小区id
     * @params pageNo 页码
     * @params pageSize 每页显示条数
     * @return json
     * @author zyt
     */
    public function getVideosByBuildingId(Request $req)
    {
        $type        = $req->get('type');
        $building_id = $req->get('building_id');

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
        if (empty($building_id)) {
            $result['message']    = '请求小区id不能为空';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        $pageNo      = empty($req->get('pageNo')) ? 1 : $req->get('pageNo');
        //查询租出售房源视频列表
        $data= $this->videoModel->getVideosByBuildingId($this->userId,$building_id, $type, $pageNo, $pageSize=10);
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

    /**
     * 通过关键字搜索小区信息(小区名、id、视频数量)
     * by songjian
     * @param build 小区名
     * @return json
     */
    public function findBuildByName(Request $request){
        //通过输入关键字去获取小区信息
        $build = $request->get('text');
        $pageNo = empty($request->get('page')) ? 1 : $request->get('page');
        if ($build ==''){
            //当没有填写关键字的时候
            $data = array('code' =>101, 'message'  => '请您输入要查询的小区',);
            $data = json_encode($data,JSON_UNESCAPED_UNICODE);
            return $data;
        }
        $count = Db::table('yf_hf_buildings')->field(['id','name'])->where('name','like',"%$build%")->count();
        $pagecount = ceil($count/10);
        //查前十条用户
        $infos = Db::table('yf_hf_buildings')->field(['id','name'])->where('name','like',"%$build%")->page($pageNo,10)->select();
        if (!$infos){
            //搜索纪录为空
            $data = array('code' =>102, 'message'  => '您搜索的小区不存在',);
            $data = json_encode($data,JSON_UNESCAPED_UNICODE);
            return $data;
        }
        //添加本小区的视频个数
        $len = count($infos);
        for ($i=0;$i<$len;$i++){
            $res = Db::table('yf_hf_video')->where('building_id',$infos[$i]['id'])->where('is_delete',0)->select();
            $count = count($res);
            $infos[$i]['video'] = $count;
        }
        $data = array('code' =>200, 'message'  => '搜索成功', 'data' => $infos,'page' => $pagecount);
        $data = json_encode($data,JSON_UNESCAPED_UNICODE);
        return $data;
    }

    /**
     * 通过关键字搜索关注的小区信息(小区名、id、视频数量)
     * by songjian
     * @param build 关注的小区名
     * @return json
     */
    public function findClearBuildByName(Request $request){
        //每页显示条数
        $pageSize=10;
        //分页数据产生
        $pageNo = empty($request->get('page')) ? 1 : $request->get('page');
        //通过输入关键字去获取小区信息
        $build = $request->get('text');
        if ($build ==''){
            //当没有填写关键字的时候
            $data = array('code' =>101, 'message'  => '请您输入要查询的小区',);
            $data = json_encode($data,JSON_UNESCAPED_UNICODE);
            return $data;
        }
        $beginSize = ($pageNo-1)*$pageSize;
        $addlimit = "limit {$beginSize},$pageSize ";
        //查询搜索的关注小区
        $sql = "select `id`,`name` from `yf_hf_buildings` where `id` IN(select f.followed_id from `yf_hf_member` as m,`yf_hf_follow` as f where m.id = f.member_id and f.is_followed=1 and f.type=1 and m.id='{$this->userId}') and `name` like '%{$build}%' {$addlimit}";
        $infos = Db::query($sql);
        //待定是否加分页
        if (!$infos){
            //搜索纪录为空
            $data = array('code' =>102, 'message'  => '您搜索的小区不存在');
            $data = json_encode($data,JSON_UNESCAPED_UNICODE);
            return $data;
        }
        //添加本小区的视频个数
        $len = count($infos);
        for ($i=0;$i<$len;$i++){
            $res = Db::table('yf_hf_video')->where('building_id',$infos[$i]['id'])->select();
            $count = count($res);
            $infos[$i]['video'] = $count;
        }
        $page = ceil($len/$pageSize);
        $data = array('code' =>200, 'message'  => '搜索成功', 'data' => $infos, 'page'=>$page);
        $data = json_encode($data,JSON_UNESCAPED_UNICODE);
        return $data;
    }

    /**
     * 通过多选框搜索视频信息(小区名、id、视频数量) [get]
     * by songjian
     * @param video_type 视频类型
     * @param area_id 地区id
     * @param num_room  户型查询 1一室 2二室 3三室
     * @param area 面积查询 1[<20] 2[20-50] 3[50-80] 4[80>]
     * @param price 租金/房价查询 1[<2k|<40k] 2[2k-4k|40k-60k] 3[4k-6k|60k-80k] 4[6k-8k|80k-100k] 5[8k>|100k>]
     * @return json
     */
    public function findBuildByCheck(Request $request){
        $status = $request->param('status');
        if ($status == 1){
            //搜索进入第一个接口
            $page = empty($request->get('pageNo')) ? 1 : $request->get('pageNo');
            $param = array();
            $param['type'] = $request->get('video_type');  // 视频类型：买卖1 合租0 整租2
            $param['area_id'] = $request->get('area_id');    //地区id
            $param['num_room'] = empty($request->get('num_room')) ? '' : $request->get('num_room'); //通过户型查询 1一室 2二室 3三室
            //$param['area'] = empty($request->get('area')) ? '' : $request->get('area'); //通过面积查询  1[<20] 2[20-50] 3[50-80] 4[80>]
            //$param['price'] = empty($request->get('price')) ? '' : $request->get('price'); //通过租金/房价查询  1[<2k/<40k] 2[2k-4k/40k-60k] 3[4k-6k/60k-80k] 4[6k-8k/80k-100k] 5[8k>/100k>]
            //户型查询确定
            if ($param['num_room'] ==1 ){
                $whereroom = " and v.num_room = 1";
            }elseif($param['num_room'] ==2){
                $whereroom = " and v.num_room = 2";
            }elseif ($param['num_room'] ==3){
                $whereroom = " and v.num_room = 3";
            }elseif ($param['num_room'] == ''){
                $whereroom = " ";
            }else{
                $whereroom = " and (v.num_room != 1 and v.num_room != 2 and v.num_room != 3)";
            }
            //地区id确定
            if ($param['area_id'] == 0 || $param['area_id'] == null || $param['area_id'] == 234){
                $wherearea =  "";
            }else{
                $wherearea =  " and v.area_id = {$param['area_id']}";
            }
            //面积条件确定
            /*if ($param['area'] == 1){
                $wherearea = " and `area` < 20";
            }elseif($param['area'] == 2){
                $wherearea = " and (`area` > 20 and `area` <50)";
            }elseif($param['area'] == 3){
                $wherearea = " and (`area` > 50 and `area` <80)";
            }elseif($param['area'] == 4){
                $wherearea = " and (`area` > 80)";
            }*/
            //租金条件确定
            /*if ($param['type'] ==0){
                if ($param['price'] == 1){
                    $whereprice = " and `price` < 2000";
                }elseif($param['price'] == 2){
                    $whereprice = " and (`price` > 2000 and `price` < 4000)";
                }elseif($param['price'] == 3){
                    $whereprice = " and (`price` > 4000 and `price` < 6000)";
                }elseif($param['price'] == 4){
                    $whereprice = " and (`price` > 6000 and `price` < 8000)";
                }elseif ($param['price'] == 5){
                    $whereprice = " and `price` > 8000";
                }
            }
            //房价条件确定
            elseif ($param['type'] ==1){
                if ($param['price'] == 1){
                    $whereprice = " and `price` < 40000";
                }elseif($param['price'] == 2){
                    $whereprice = " and (`price` > 40000 and `price` < 60000)";
                }elseif($param['price'] == 3){
                    $whereprice = " and (`price` > 60000 and `price` < 80000)";
                }elseif($param['price'] == 4){
                    $whereprice = " and (`price` > 80000 and `price` < 100000)";
                }elseif ($param['price'] == 5){
                    $whereprice = " and `price` > 100000";
                }
            }*/
            //视频类型
            $type = $param['type'];
            //拼凑sql
            //$sql_count = "select * from yf_hf_video WHERE `video_type`=$type";
            $sql = "select v.id as id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.unionid,m.headimgurl,b.name as building_name,b.average_price,b.address as area_name,v.update_time from (((`yf_hf_video` as v left join `yf_hf_member` as m ON  v.member_id = m.id) left join `yf_hf_buildings` as b ON  v.building_id = b.id) LEFT JOIN `yf_hf_follow` AS f ON v.id = f.followed_id) WHERE v.video_type=$type and v.is_delete=0 and v.examine = 1 ";
            $sql .= $whereroom;
            $sql .= $wherearea;
            //$sql .= " and v.status = 1 ";
            $sql .= " group by v.id";
            $count = count(Db::query($sql));
            $pageno = ($page-1) * 10;
            $sql .= " LIMIT $pageno,10";
            $res = Db::query($sql);
            $pages = ceil($count/10);
            /**
             * 更新接口
             * by songjian
             */
            $member_id = $this->userId;
            for ($i=0;$i<count($res);$i++) {
                $res[$i]['building_name']= Tool::getBuildingName($res[$i]['area_name'],$res[$i]['building_name']);
                $res[$i]['default_video_cover']= Tool::getDefaultCover();

                //查询该用户是否关注小区,关注发布人,关注点赞视频
                $res[$i]['member_followed'] = 0;
                $res[$i]['building_followed'] = 0;
                $res[$i]['video_followed'] = 0;
                $member_follow   = Db::table('yf_hf_follow')->where(['member_id'=>$member_id,'followed_id'=>$res[$i]['member_id'],'type'=>0])->find();
                $building_follow = Db::table('yf_hf_follow')->where(['member_id'=>$member_id,'followed_id'=>$res[$i]['building_id'],'type'=>1])->find();
                $video_follow    = Db::table('yf_hf_follow')->where(['member_id'=>$member_id,'followed_id'=>$res[$i]['id'],'type'=>2])->find();
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
                if ($res[$i]['unionid']){
                }else{
                    $res[$i]['headimgurl'] = Tool::getDomain().$res[$i]['headimgurl'];
                }
            }
            if ($res){
                $data['code'] = 200;
                $data['message'] = '视频查询成功';
                $data['data']['list'] = $res;
                $data['data']['total'] = $pages;
            }else{
                $data['code'] = 200;
                $data['message'] = '视频查询为空';
            }
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }elseif ($status == 2){
            //进入后进一步筛选
            $data['code'] = 101;
            $data['message'] = '';
            //1 出售 2 出租
            $page = empty($request->param('pageNo')) ? 1 : $request->param('pageNo');
            //通过关键字筛选
            $keyword = $request->param('keyword');
            $type = $request->param('type');
            $areaid = $request->param('area_id');
            $minprice = $request->param('minprice');
            $maxprice = $request->param('maxprice');
            $minarea  = $request->param('minarea');
            $maxarea  = $request->param('maxarea');
            $num_room = $request->param('num_room');
            $video_type = $request->param('video_type');
            /**
             * 通过关键字筛选
             * update by songjian
             **/
            /*$keyword = $request->param('keyword');
            if ($keyword != ""){
                $building_id = "";
                $res = Db::table('yf_hf_buildings')->field(['id'])->where('name','like',"%{$keyword}%")->whereOr('address','like',"%{$keyword}%")->select();
                if (count($res) == 0){
                    $data['code'] = 101;
                    $data['message'] = "您搜索的条件不存在";
                    return json_encode($data,JSON_UNESCAPED_UNICODE);
                }
                foreach ($res as $item){
                    $building_id .= "'{$item['id']}',";
                }
                $building_id = substr($building_id,0,strlen($building_id)-1);
            }*/
            if ($type == 1 || $type == 2){
                if ($type == 1 ){
                    //出售搜索
                    //$sql = "select v.id as id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.unionid,m.headimgurl,b.name as building_name,b.average_price,b.address as area_name from ((yf_hf_video as v INNER join yf_hf_member as m on v.member_id=m.id) left join `yf_hf_buildings` as b ON  v.building_id = b.id) where v.video_type=1 ";
                    $sql = "select v.id as id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.unionid,m.headimgurl,b.name as building_name,b.average_price,b.address as area_name,v.update_time from yf_hf_video v inner join yf_hf_buildings  b on v.building_id=b.id left join yf_hf_member m on v.member_id=m.id where (b.`name` LIKE '%{$keyword}%' OR b.`address` LIKE '%{$keyword}%') and v.video_type=1 and v.is_delete=0 and v.examine = 1 ";
                    //上海市不加area_id条件
                    if ($areaid != 234){
                        $sql .= " and v.area_id= $areaid ";
                    }
                    //if (!empty($minprice) && empty($maxprice) && $maxprice !== 0){
                    if (empty($maxprice) && $maxprice !== 0){
                        $sql .= " and v.price > $minprice ";
                    }else{
                        $sql .= " and v.price BETWEEN  $minprice and $maxprice ";
                    }
                    if (empty($maxarea) && $maxarea !== 0){
                        $sql .= " AND v.area > $minarea ";
                    }else{
                        $sql .= " AND v.area BETWEEN $minarea AND $maxarea ";
                    }
                    if ($num_room==4){
                        $sql .= " and (v.num_room != 1 and v.num_room != 2 and v.num_room != 3)";
                    }elseif($num_room == ''){
                    }else{
                        $sql .= " and v.num_room = $num_room";
                    }
                    $sql .= " order by v.status desc";
                    /*if ($keyword != ""){
                        $sql .= " and v.building_id in($building_id)";
                    }*/
                    $count = count(Db::query($sql));
                    $pageno = ($page-1) * 10;
                    $sql .= " LIMIT $pageno,10";
                    $pages = ceil($count/10);
                    $res = Db::query($sql);
                }elseif ($type == 2 ){
                    //出租搜索
                    //$sql = "select v.id as id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.unionid,m.headimgurl,b.name as building_name,b.average_price,b.address as area_name from ((yf_hf_video as v INNER join yf_hf_member as m on v.member_id=m.id) left join `yf_hf_buildings` as b ON  v.building_id = b.id)  where v.video_type =$video_type ";
                    $sql = "select v.id as id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.unionid,m.headimgurl,b.name as building_name,b.average_price,b.address as area_name,v.update_time  from yf_hf_video v inner join   yf_hf_buildings  b on v.building_id=b.id left join yf_hf_member m on v.member_id=m.id where  ( b.`name` LIKE '%{$keyword}%' OR b.`address` LIKE '%{$keyword}%') and v.video_type = $video_type and v.is_delete=0 and v.examine = 1 ";
                    //上海市不加area_id条件
                    if ($areaid != 234){
                        $sql .= " and v.area_id= $areaid ";
                    }
                    //if (!empty($minprice) && empty($maxprice) && $maxprice !== 0){
                    if (empty($maxprice) && $maxprice !== 0){
                        $sql .= " and v.price > $minprice ";
                    }else{
                        $sql .= " and v.price BETWEEN  $minprice and $maxprice ";
                    }
                    if ($num_room==4){
                        $sql .= " and (v.num_room != 1 and v.num_room != 2 and v.num_room != 3)";
                    }elseif($num_room == ''){
                    }else{
                        $sql .= " and v.num_room = $num_room";
                    }
                    $sql .= " order by v.status desc";
                    /*if ($keyword != ""){
                        $sql .= " and v.building_id in($building_id)";
                    }*/
                    $count = count(Db::query($sql));
                    $pageno = ($page-1) * 10;
                    $sql .= " LIMIT $pageno,10";
                    $pages = ceil($count/10);
                    $res = Db::query($sql);
                }
                $member_id = $this->userId;
                for ($i=0;$i<count($res);$i++) {
                    $res[$i]['building_name']= Tool::getBuildingName($res[$i]['area_name'],$res[$i]['building_name']);
                    $res[$i]['default_video_cover']= Tool::getDefaultCover();

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
                $data['data']['list'] = $res;
                $data['data']['total'] = $pages;
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }else{
                $data['message'] = '传入type有误，请重新输入';
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
        }elseif ($status == 3){
            //通过关键字筛选
            $keyword = $request->get('keyword');
            $building_id = "";
            $res = Db::table('yf_hf_buildings')->field(['id'])->where('name','like',"%{$keyword}%")->whereOr('address','like',"%{$keyword}%")->select();
            foreach ($res as $item){
                $building_id .= "'{$item['id']}',";
            }
            $building_id = substr($building_id,0,strlen($building_id)-1);
            $sql = "select v.id as id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.unionid,m.headimgurl,b.name as building_name,b.average_price,b.address as area_name,v.update_time from ((yf_hf_video as v INNER join yf_hf_member as m on v.member_id=m.id) left join `yf_hf_buildings` as b ON  v.building_id = b.id) WHERE v.building_id in($building_id)";
            $res = Db::query($sql);
            $member_id = $this->userId;
            for ($i=0;$i<count($res);$i++) {
                $res[$i]['building_name']= Tool::getBuildingName($res[$i]['area_name'],$res[$i]['building_name']);
                $res[$i]['default_video_cover']= Tool::getDefaultCover();

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
            $data['data']['list'] = $res;
            $data['data']['total'] = count($res);
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
    }

    /**
     * 针对查询视频结果二维数组去重
     * By songjian
     */
    public function remove_duplicate($array)
    {
        $result=array();
        foreach ($array as $key => $value) {
            $has = false;
            foreach($result as $val){
                if($val['id']==$value['id']){
                    $has = true;
                    break;
                }
            }
            if(!$has)
                $result[]=$value;
        }
        return $result;
    }

    /**
     * 发布时增加小区
     * @auther zyt
     * @time 2018/7/3
     */
    public function addBuilding(){
        $result['code'] = 101;
        $result['message'] = '';

        $name      = $this->params['name'];
        $area_id   = $this->params['area_id'];
        $circle    = $this->params['circle'];
        $address   = $this->params['address'];
        $longitude = $this->params['longitude'];
        $latitude  = $this->params['latitude'];

        if (!$area_id) {
            $result['message'] = '请选择区域';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        if (empty($name) || empty($circle) || empty($address)) {
            $result['message'] = '请输入小区名,商圈或地址';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        if (empty($longitude) || empty($latitude)) {
            $result['message'] = '请输入经纬度';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //查找区域是否存在
        $area = Db::table('yf_hf_area')->where('id',$area_id)->find();
        if (!$area) {
            $result['message'] = '所选区域不存在';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        $area_dic_value = mb_substr($area['dic_value'],0,2);

        $address =  '('.$area_dic_value. $circle .')'. $address;

        $data['id']           = 0;
        $data['name']         = $name;
        $data['address']      = $address; //待处理 截取
        $data['area_id']      = $area_id;
        $data['longitude']    = $longitude;
        $data['latitude']     = $latitude;
        $data['remarks']     = $this->params['remarks'];
        $data['is_user_add']  = 1;
        $data['user_type']    = 2;
        $data['user_id']      = $this->userId;
        $data['is_confirm']   = 0;
        $data['create_time']  = time();
        $data['update_time']  = time();
        

        $res = Db::table('yf_hf_buildings')->insert($data);
        $building_id = Db::table('yf_hf_buildings')->getLastInsID();
        $buildings = [
            'building_id'=> $building_id,
            'name'       => $name,
        ];
        if($res){
            $result['code'] = 200;
            $result['message'] = '新增小区成功';
            $result['data'] = $buildings;
        } else {
            $result['message'] = '新增小区失败';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }
}

