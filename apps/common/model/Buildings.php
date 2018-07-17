<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/12
 * Time: 19:02
 */

namespace app\common\model;

use app\api\controller\Tool;
use think\Log;
use think\Model;
use think\Db;

class Buildings extends Base
{
    // 设置当前模型对应的完整数据表名称
    protected $table = 'yf_hf_buildings';

    /**
     * 获取小区列表(详情)
     * @param $longtitude 经度
     * @param $latitude 纬度
     * @param $status 0 出租 1 出售
     * @author zyt
     */
    public function getBuildingsList ($longitude,$latitude,$maxlongitude, $minlongitude, $maxlatitude, $minlatitude, $status, $pageNo=1, $pageSize=10)
    {
        /*Log::info("======getBuildingsList1======");
        //查询发布视频的小区id array
        $video = Db::table('yf_hf_video')->field('id,building_id')->where(['is_delete'=>0,'status'=>1])->order('id','desc')->select();
        $building_ids = [];
        if ($video) {
            for ($i=0;$i<count($video);$i++) {
                $building_ids[] = $video[$i]['building_id'];
            }
        }
        Log::info("======getBuildingsList-$building_ids======");
        Log::info($building_ids);*/
        $field = 'id,name,average_price,architectural_age,architectural_type,property_cost,property_company,longitude,latitude,developers,num_building,num_room';
        $where = 'longitude between ' . $minlongitude .' and ' . $maxlongitude . ' and latitude between ' . $minlatitude . ' and '. $maxlatitude;
        $building = $this->field($field)->where($where)->select();
//        $count = $this->field($field)->where($where)->count();
//        $total = ceil($count/$pageSize);
        Log::info("======getBuildingsList-$building======");
        Log::info($building);
        for ($i=0; $i<count($building); $i++) {
            $building[$i]['distance'] = Tool::getdistance($longitude, $latitude, $building[$i]['longitude'], $building[$i]['latitude']);
        }

        foreach($building as $key=>$val){
            $dos[$key] = $val['distance'];
        }
        array_multisort($dos,SORT_ASC,$building);
        $data = [];
        if ($building) {
            for ($i=0;$i<count($building);$i++) {
                $data[$i] = $building[$i];
            }
        }
        return ['list'=>$data,'total'=>1];
    }

    /**
     * 获取小区列表(个别信息)
     * @param $longtitude 经度
     * @param $latitude 纬度
     * @param $status 0 出租 1 出售
     * @author zyt
     */
    public function getBuildingsListLittle ($maxlongitude, $minlongitude, $maxlatitude, $minlatitude,$pageNo=1,$pageSize=10,$longitudes='',$latitudes='')
    {
        $field = 'id,name,longitude,latitude,follow_count';
        $where = 'longitude between ' . $minlongitude .' and ' . $maxlongitude . ' and latitude between ' . $minlatitude . ' and '. $maxlatitude;
        $datas['build'] = $this->field($field)
                                ->where($where)
                                //->page($pageNo,$pageSize)
                                ->select();
        /**
         * 返回此小区相对用户地区距离
         * by songjian
         */
        foreach ($datas['build'] as $value){
            $longitude = $value['longitude'];
            $latitude  = $value['latitude'];
            $distance = Tool::getdistance($longitude, $latitude, $longitudes, $latitudes);
            $value['distance'] = $distance;
        }
        array_multisort(array_column($datas['build'],'distance'),SORT_ASC,$datas['build']);
        //得到房源总页码
        //$counts = $this->field($field)->where($where)->select();
        //$count = count($counts);
        //$page = ceil($count/$pageSize);


        for($i=0;$i<count($datas['build']);$i++){
            $info = Db::table('yf_hf_video')
                        ->field('title')
                        ->where('building_id',$datas['build'][$i]['id'])
                        //->page($pageNo,$pageSize)
                        ->select();
            $datas['build'][$i]['video_count'] = count($info);
        }
        //$datas['page'] = $page;
        return $datas;
    }


    /**
     * 获取小区列表(手动输入获取)
     * @param $longtitude 经度
     * @param $latitude 纬度
     * @param $status 0 出租 1 出售
     * @author songjian
     */
    public function getFindBuildingsListLittle ($keyword,$maxlongitude, $minlongitude, $maxlatitude, $minlatitude,$pageNo=1,$pageSize=10,$longitudes='',$latitudes='')
    {
        $field = 'id,name,longitude,latitude,follow_count';
        $where = "longitude between " . $minlongitude ." and " . $maxlongitude . " and latitude between " . $minlatitude . " and ". $maxlatitude . " and (name like '%{$keyword}%' or address like '%{$keyword}%')";
        $datas['build'] = $this->field($field)
            ->where($where)
            //->page($pageNo,$pageSize)
            ->select();
        /**
         * 返回此小区相对用户地区距离
         * by songjian
         */
        foreach ($datas['build'] as $value){
            $longitude = $value['longitude'];
            $latitude  = $value['latitude'];
            $distance = Tool::getdistance($longitude, $latitude, $longitudes, $latitudes);
            $value['distance'] = $distance;
        }
        array_multisort(array_column($datas['build'],'distance'),SORT_ASC,$datas['build']);
        //得到房源总页码
        //$counts = $this->field($field)->where($where)->select();
        //$count = count($counts);
        //$page = ceil($count/$pageSize);


        for($i=0;$i<count($datas['build']);$i++){
            $info = Db::table('yf_hf_video')
                ->field('title')
                ->where('building_id',$datas['build'][$i]['id'])
                //->page($pageNo,$pageSize)
                ->select();
            $datas['build'][$i]['video_count'] = count($info);
        }
        //$datas['page'] = $page;
        return $datas;
    }




    /**查找小区信息详情
     * @param $building_id
     * @author zyt
     */
    public function getDetailByBuildingId ($userId,$building_id)
    {
        $where = 'id = ' . $building_id;
        $find = $this->field('address,0 as traffic,0 as describption,id,name,average_price,architectural_age,architectural_type,property_cost,property_company,longitude,latitude,developers,num_building,num_room,follow_count')->where($where)->find();
        //查询该用户是否关注小区
        $find['building_followed'] = 0;
        $building_follow = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$building_id,'type'=>1])->find();
        if ($building_follow && ($building_follow['is_followed'] == 1)) {
            $find['building_followed'] = 1;
        }
        return $find;
    }

    /**
     * 通过经纬度获取小区
     * by songjian
     */
    public function getXiaoquByXY($longitude,$latitude){
        $sql = "select * from yf_hf_buildings order by ($longitude-`longitude`)*($longitude-`longitude`)+($latitude-`latitude`)*($latitude-`latitude`) asc LIMIT 1";
        $res = $this->query($sql)[0];
        return $res;
    }

}
