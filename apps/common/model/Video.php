<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/12
 * Time: 19:02
 */

namespace app\common\model;

use think\Exception;
use think\Model;
use think\Db;
use app\api\controller\Tool;

class Video extends Base
{
    // 设置当前模型对应的完整数据表名称
    protected $table = 'yf_hf_video';

    /**通过小区id(多个或单个)获取视频列表(附近)
     * @param $buildingId
     * @param $status 0 出租 1 出售
     * @param $pageNo
     * @param $pageSize
     * @author zyt
     */
    public function getVideoByBuildingId($userId,$maxlongitude, $minlongitude, $maxlatitude, $minlatitude, $pageNo = 1, $pageSize = 10)
    {
        /*if ($status == 0) {
            $video_type = [0,2];
            $video_type = implode(',',$video_type);
        } elseif ($status == 1){
            $video_type = 1;
        }*/
        //获取小区ids
        $field1 = 'id,name,average_price,architectural_age,architectural_type,property_cost,property_company,longitude,latitude,developers,num_building,num_room';
        $where1 = 'longitude between ' . $minlongitude .' and ' . $maxlongitude . ' and latitude between ' . $minlatitude . ' and '. $maxlatitude;
        $building = Db::table('yf_hf_buildings')->field($field1)->where($where1)->select();
        $building_ids = [];
        if ($building) {
            for ($i=0;$i<count($building);$i++) {
                $building_ids[] = $building[$i]['id'];
            }
        }
        //$where = 'is_delete=0 and longitude between ' . $minlongitude .' and ' . $maxlongitude . ' and latitude between ' . $minlatitude . ' and '. $maxlatitude;
        $order='v.create_time desc';
        $fields = 'v.id,v.building_id,v.member_id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.create_time,v.update_time,v.remarks,m.nickname,m.headimgurl,m.hiid,m.unionid,m.is_robot';

        $list = $this->alias('v')
            ->join('yf_hf_member m', 'm.id = v.member_id', 'left')
            ->field($fields)
            ->where('v.status',1)->where('v.is_delete',0)->whereIn('building_id',$building_ids)->order($order)->page($pageNo,$pageSize)->select();

        for ($i=0;$i<count($list);$i++) {
            $building = Db::table('yf_hf_buildings')->where('id',$list[$i]['building_id'])->find();
            $list[$i]['building_name'] = $building['name'];
            $list[$i]['average_price'] = $building['average_price'];
            $list[$i]['building_name'] = Tool::getBuildingName($building['address'], $list[$i]['building_name']);
            $list[$i]['default_video_cover']= Tool::getDefaultCover();

            //获取头像地址
            if ($list[$i]['unionid'] || $list[$i]['is_robot']!=0){
                $list[$i]['headimgurl'] = $list[$i]['headimgurl'];
            }else{
                $list[$i]['headimgurl'] = Tool::getDomain().$list[$i]['headimgurl'];
            }
            //查询该用户是否关注小区,关注发布人,关注点赞视频
            $list[$i]['member_followed']   = 0;
            $list[$i]['building_followed'] = 0;
            $list[$i]['video_followed']    = 0;
            $video_follow    = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['id'],'type'=>2])->find();
            $member_follow   = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['member_id'],'type'=>0])->find();
            $building_follow = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['building_id'],'type'=>1])->find();
            if ($member_follow && ($member_follow['is_followed'] == 1)) {
                $list[$i]['member_followed'] = 1;
            }
            if ($building_follow && ($building_follow['is_followed'] == 1)) {
                $list[$i]['building_followed'] = 1;
            }
            if ($video_follow && ($video_follow['is_followed'] == 1)) {
                $list[$i]['video_followed'] = 1;
            }
        }

        $count = $this->where(['status'=>1,'is_delete'=>0])->whereIn('building_id',$building_ids)->count();
        $total = ceil($count/$pageSize);
        return ['list' => $list,'total' => $total];
    }

    /**获取小区主页--小区出租出售房源视频列表
     * @param $buildingId
     * @param $status 0 出租 1 出售
     * @param $pageNo
     * @param $pageSize
     * @author zyt
     */
    public function getVideosByBuildingId($userId,$buildingId, $type, $pageNo=1, $pageSize=10)
    {
        if ($type == 0) {
            $video_type = [0,2];
            $video_type = implode(',',$video_type);
        } elseif($type == 1){
            $video_type = 1;
        }
        $where = 'building_id =' . $buildingId .' and video_type in (' . $video_type . ') and is_delete=0';
        $order='v.create_time and v.status desc';
        $fields = 'v.id,v.building_id,v.member_id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.create_time,v.update_time,v.remarks,m.nickname,m.headimgurl,m.hiid,b.name as building_name,b.average_price,b.address area_name';
        $list = self::alias('v')
            ->join('yf_hf_member m', 'm.id = v.member_id', 'left')
            ->join('yf_hf_buildings b', 'b.id = v.building_id', 'left')
            ->field($fields)
            ->where($where)->order('v.status desc')->order($order)->page($pageNo,$pageSize)->select();
        for ($i=0;$i<count($list);$i++) {

            $list[$i]['building_name']= Tool::getBuildingName($list[$i]['area_name'],$list[$i]['building_name']);
            $list[$i]['default_video_cover']= Tool::getDefaultCover();

            //查询该用户是否关注小区,关注发布人,关注点赞视频
            $list[$i]['member_followed']   = 0;
            $list[$i]['building_followed'] = 0;
            $list[$i]['video_followed']    = 0;
            $member_follow   = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['member_id'],'type'=>0])->find();
            $building_follow = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['building_id'],'type'=>1])->find();
            $video_follow    = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['id'],'type'=>2])->find();
            if ($member_follow && ($member_follow['is_followed'] == 1)) {
                $list[$i]['member_followed'] = 1;
            }
            if ($building_follow && ($building_follow['is_followed'] == 1)) {
                $list[$i]['building_followed'] = 1;
            }
            if ($video_follow && ($video_follow['is_followed'] == 1)) {
                $list[$i]['video_followed'] = 1;
            }
        }
        //获取总页码
        $count = self::where($where)->count();
        $total = ceil($count/$pageSize);
        return ['list' => $list,'total' => $total];
    }

    /**通过发布人id获取视频列表
     * @param $member_id
     * @param $status 0 出租 1 出售
     * @param $pageNo
     * @param $pageSize
     * @author zyt
     */
    public function getVideoByMemberId($userId,$member_id, $type, $pageNo = 1, $pageSize = 10)
    {
        if ($type == 0) {
            $video_type = [0,2];
            $video_type = implode(',',$video_type);
        } elseif($type == 1){
            $video_type = 1;
        }
        $where = 'member_id = ' . $member_id .' and video_type in (' . $video_type . ') and is_delete=0';
        $order='v.create_time and v.status desc';
        $fields = 'v.id,v.building_id,v.member_id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.create_time,v.update_time,v.remarks,m.nickname,m.headimgurl,m.unionid,m.hiid,m.is_robot,b.name as building_name,b.average_price,b.address area_name';
        $list = $this->alias('v')
            ->join('yf_hf_member m', 'm.id = v.member_id', 'left')
            ->join('yf_hf_buildings b', 'b.id = v.building_id', 'left')
            ->field($fields)
            ->where($where)->order($order)->page($pageNo,$pageSize)->select();
        for ($i=0;$i<count($list);$i++) {

            $list[$i]['building_name']= Tool::getBuildingName($list[$i]['area_name'],$list[$i]['building_name']);
            $list[$i]['default_video_cover']= Tool::getDefaultCover();
            //获取头像地址
            if ($list[$i]['unionid'] || $list[$i]['is_robot']!=0){
                $list[$i]['headimgurl'] = $list[$i]['headimgurl'];
            }else{
                $list[$i]['headimgurl'] = Tool::getDomain().$list[$i]['headimgurl'];
            }
            //查询该用户是否关注小区,关注发布人,关注点赞视频
            $list[$i]['member_followed'] = 0;
            $list[$i]['building_followed'] = 0;
            $list[$i]['video_followed'] = 0;
            $member_follow   = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['member_id'],'type'=>0])->find();
            $building_follow = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['building_id'],'type'=>1])->find();
            $video_follow    = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['id'],'type'=>2])->find();
            if ($member_follow && ($member_follow['is_followed'] == 1)) {
                $list[$i]['member_followed'] = 1;
            }
            if ($building_follow && ($building_follow['is_followed'] == 1)) {
                $list[$i]['building_followed'] = 1;
            }
            if ($video_follow && ($video_follow['is_followed'] == 1)) {
                $list[$i]['video_followed'] = 1;
            }
        }
        //获取总页码
        $count = $this->where($where)->count();
        $total = ceil($count/$pageSize);
        return ['list' => $list,'total' => $total];
    }

    /**获取单视频房源信息详情
     * @param $video_id
     * @author zyt
     */
    public function getVideoDetail($userId,$video_id)
    {
        $fields = 'v.id,v.building_id,v.member_id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.create_time,v.update_time,v.remarks,m.nickname,m.headimgurl,m.hiid,m.unionid,b.name as building_name,b.average_price,b.address area_name';
        $find = $this->alias('v')
            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
            ->field($fields)
            ->where('v.id', $video_id)->find();
        $find['building_name']= Tool::getBuildingName($find['area_name'],$find['building_name']);
        $find['default_video_cover']= Tool::getDefaultCover();

        //获取头像地址
        if ($find['unionid']){
            $find['headimgurl'] = $find['headimgurl'];
        }else{
            $find['headimgurl'] = Tool::getDomain().$find['headimgurl'];
        }
        //查询该用户是否关注小区,关注发布人,关注点赞视频
        $find['member_followed'] = 0;
        $find['building_followed'] = 0;
        $find['video_followed'] = 0;
        $member_follow   = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$find['member_id'],'type'=>0])->find();
        $building_follow = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$find['building_id'],'type'=>1])->find();
        $video_follow    = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$find['id'],'type'=>2])->find();
        if ($member_follow && ($member_follow['is_followed'] == 1)) {
            $find['member_followed'] = 1;
        }
        if ($building_follow && ($building_follow['is_followed'] == 1)) {
            $find['building_followed'] = 1;
        }
        if ($video_follow && ($video_follow['is_followed'] == 1)) {
            $find['video_followed'] = 1;
        }
        return $find;
    }


    /**获取我发布的小区列表
     * @param $userId  用户id
     * @param $status  0 出租 1出售
     * @param $pageNo
     * @param $pageSize
     */
    public function getBuildingByStatus($userId, $status, $pageNo = 1, $pageSize = 10)
    {
        if ($status == 0) {
            $video_type = [0,2];
        } elseif ($status == 1) {
            $video_type = [1];
        }
        $field = 'count(v.id) as count,b.id as building_id, b.name as building_name';
        $list = $this->alias('v')
            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
            ->field($field)
            ->where(['v.member_id'=>$userId,'v.is_delete'=>0])->whereIn('v.video_type',$video_type)->group('v.building_id')->page($pageNo, $pageSize)->select();
        $count = $this->where(['member_id'=>$userId])->whereIn('video_type',$video_type)->count();
        $total = ceil($count/$pageSize);
        return ['list'=>$list, 'total'=>$total];
    }

    /**获取通过我发布的小区获取视频列表(上架或下架)
     * @param $userId
     * @param $video_type 视频类型 0,2出租  1出售
     * @param $type 0下1上架
     * @param $pageNo
     * @param $pageSize
     */
    public function getBuildingsByType($userId, $type, $video_type, $building_id, $pageNo = 1, $pageSize = 10)
    {
        if ($video_type == 0) {
            $video_type = [0,2];
        } elseif ($video_type == 1) {
            $video_type = [1];
        }

        $field = 'v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.create_time,v.update_time,v.remarks,b.name as building_name,b.average_price,b.address area_name';

        $list = $this->alias('v')
            ->join('yf_hf_buildings b','b.id=v.building_id','left')
            ->where(['v.status'=>$type, 'v.is_delete'=>0, 'v.building_id'=>$building_id, 'v.member_id'=>$userId])
            ->whereIn('v.video_type',$video_type)
            ->field($field)
            ->page($pageNo, $pageSize)->select();
        if ($list) {
            for ($i=0;$i<count($list);$i++) {
                $list[$i]['building_name']= Tool::getBuildingName($list[$i]['area_name'],$list[$i]['building_name']);
                $list[$i]['default_video_cover']= Tool::getDefaultCover();
            }
        }

        $count = $this->where(['status'=>$type, 'building_id'=>$building_id, 'member_id'=>$userId])->whereIn('video_type',$video_type)->count();
        $total = ceil($count/$pageSize);
        return ['list'=>$list, 'total'=>$total];
    }

    /**推荐视频房源列表
     * @param $userId
     * @param $status
     * @param $pageNo
     * @param $pageSize
     *
     */
    public function getVideoList($userId, $status, $pageNo = 1, $pageSize = 10)
    {
        $where = ['yf_hf_video.status'=>1,'yf_hf_video.is_delete'=>0,'yf_hf_video.video_type'=>$status];

        $order='v.create_time desc';
        $fields = 'v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.headimgurl,m.unionid,m.hiid,m.is_robot,b.average_price,b.name as building_name,b.address area_name';
        $list = $this->alias('v')
            ->join('yf_hf_member m', 'm.id = v.member_id', 'left')
            ->join('yf_hf_buildings b', 'b.id = v.building_id', 'left')
            ->field($fields)
            ->where($where)->order($order)->page($pageNo,$pageSize)->select();
        for ($i=0;$i<count($list);$i++) {
            $list[$i]['building_name'] = Tool::getBuildingName($list[$i]['area_name'], $list[$i]['building_name']);
            $list[$i]['default_video_cover']= Tool::getDefaultCover();

            //获取头像地址
            if ($list[$i]['unionid'] || $list[$i]['is_robot']!=0){
                $list[$i]['headimgurl'] = $list[$i]['headimgurl'];
            }else{
                $list[$i]['headimgurl'] = Tool::getDomain().$list[$i]['headimgurl'];
            }
            //查询该用户是否关注小区,关注发布人,关注点赞视频
            $list[$i]['member_followed'] = 0;
            $list[$i]['building_followed'] = 0;
            $list[$i]['video_followed'] = 0;
            $member_follow   = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['member_id'],'type'=>0])->find();
            $building_follow = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['building_id'],'type'=>1])->find();
            $video_follow    = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$list[$i]['id'],'type'=>2])->find();
            if ($member_follow && ($member_follow['is_followed'] == 1)) {
                $list[$i]['member_followed'] = 1;
            }
            if ($building_follow && ($building_follow['is_followed'] == 1)) {
                $list[$i]['building_followed'] = 1;
            }
            if ($video_follow && ($video_follow['is_followed'] == 1)) {
                $list[$i]['video_followed'] = 1;
            }
        }
        //获取总页码
        $count = $this->where($where)->count();
        $total = ceil($count/$pageSize);
        return ['list' => $list,'total' => $total];
    }

    /**推荐视频房源列表
     * @param $status
     * @param $pageNo
     * @param $pageSize
     */
    public function getVideoLists($status, $pageNo = 1, $pageSize = 10)
    {
        //查询已审核成功的视频
        /*$shenheVideo = Db::table('yf_hf_account_details')->where(['type'=>1,'status'=>1])->field('id,video_id')->select();
        $video_ids = [];
        for ($i=0;$i<count($shenheVideo);$i++) {
            $video_ids[$i] = $shenheVideo[$i]['video_id'];
        }*/

        $where = ['yf_hf_video.status'=>1,'yf_hf_video.is_delete'=>0,'yf_hf_video.video_type'=>$status];

        $order='v.create_time desc';
        $fields = 'v.id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.member_id,v.building_id,v.remarks,m.nickname,m.headimgurl,m.hiid,m.unionid,m.is_robot,b.average_price,b.name as building_name,b.address area_name';
        $list = $this->alias('v')
            ->join('yf_hf_member m', 'm.id = v.member_id', 'left')
            ->join('yf_hf_buildings b', 'b.id = v.building_id', 'left')
            ->field($fields)
            ->where($where)->order($order)->page($pageNo,$pageSize)->select();
        for ($i=0;$i<count($list);$i++) {
            $list[$i]['building_name'] = Tool::getBuildingName($list[$i]['area_name'], $list[$i]['building_name']);
            $list[$i]['default_video_cover']= Tool::getDefaultCover();

            //获取头像地址
            if ($list[$i]['unionid'] || $list[$i]['is_robot']!=0){
                $list[$i]['headimgurl'] = $list[$i]['headimgurl'];
            }else{
                $list[$i]['headimgurl'] = Tool::getDomain().$list[$i]['headimgurl'];
            }
            //查询该用户是否关注小区,关注发布人,关注点赞视频
            $list[$i]['member_followed'] = 0;
            $list[$i]['building_followed'] = 0;
            $list[$i]['video_followed'] = 0;
        }
        //获取总页码
        $count = $this->where($where)->count();
        $total = ceil($count/$pageSize);
        return ['list' => $list,'total' => $total];
    }

    /**修改我发布的视频的状态  上架/下架
     * @param $video_id
     */
    public function upOrDownVideo($video_id, $status)
    {
        if ($status == 0) {
            $result = $this->where('id', $video_id)->update(['status'=>1]);
        } else {
            $result = $this->where('id', $video_id)->update(['status'=>0]);
        }
        return $result;
    }

    /**删除我发布的视频
     * @param $video_id
     */
    public function deleteVideo($video_id)
    {
        return $this->where('id', $video_id)->update(['is_delete'=>1]);
    }

    /**后台视频管理列表视频户型图
     *
     */
    public function getImagesByVideoId($video_id)
    {

        $imgs = $this->alias('v')
            ->join('yf_hf_imgs i', 'i.video_id=v.id', 'right')
            ->field('i.id as img_id, i.img_type, i.image_name')->where(['i.img_type'=>2,'i.video_id'=>$video_id])->select();
        $result = [];
        foreach ($imgs as $r) {
            $result[] = $r['image_name'];
        }
        return $result;
    }

    /**
     * 将编辑视频后的新数据更新
     * by songjian
     */
    public function editVideo($video_id,$data){
        $res = Db::table('yf_hf_video')
            ->where('id',$video_id)
            ->update($data);
        return $res;
    }

    /**
     * 发布视频成功后更新用户表和账单详情表
     * by songjian
     * @return bool
     */
    public function updateMemberAndDetailCount($user_id,$video_id){
        Db::startTrans();
        try{
            $money = Tool::getRandMoney();
            $data = array(
                'id'        => 0,
                'member_id' => $user_id,
                'video_id'  => $video_id,
                'money'     => $money,
                'type'      => 1,
                'status'    => 0,
                'create_time' => time(),
                'update_time' => time()
            );
            $res1 = Db::table('yf_hf_account_details')->insert($data);
            $res2 = Db::table('yf_hf_member')->where('id',$user_id)->setInc('num_publish');
            Db::commit();
            if ($res1 && $res2){
                return true;
            }else{
                return false;
            }
        }catch (Exception $exception){
            Db::rollback();
        }
    }
}
