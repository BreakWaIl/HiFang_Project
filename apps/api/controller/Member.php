<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/18
 * Time: 13:21
 */
namespace app\api\controller;

use app\common\model\Member as MemberModel;
use app\common\untils\JwtUntils;
use think\Db;
use think\Request;
use app\api\controller\Basic;
use app\common\model\Video;

class Member extends Basic
{
    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->memberModel = new MemberModel();
        $this->videoModel = new Video();
    }
    /**
     *获取用户个人信息--作者主页get
     * @params member_id  用户id
     * @return json
     * @author zyt
     */
    public function getMemberDetail (Request $req)
    {
        header("Access-Control-Allow-Origin: *");
        $result['code']    = 101;
        $result['message'] = '';

        $member_id = $req->get('member_id');
        if (!isset($member_id)) {
            $result['message']  = '请传入作者id';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        $res = $this->memberModel->find($member_id);
        if (!$res) {
            $result['message']  = '查询该用户不存在';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        $member = $this->memberModel->getMemberDetail($this->userId,$member_id);
        $member['type'] = 0;
        //查询该用户是否有视频数据 出租数据$data['type']=1 出售数据$data['type']=2
        $data1 = Db::table('yf_hf_video')->where(['member_id'=>$member_id,'is_delete'=>0])->whereIn('video_type',[0,2])->count();//出租
        $data2 = Db::table('yf_hf_video')->where(['video_type'=>1,'member_id'=>$member_id,'is_delete'=>0])->count();//出售
        $data3 = Db::table('yf_hf_follow')->where(['member_id'=>$member_id,'type'=>2,'is_followed'=>1])->count();//他赞过的

        if ($data2 > 0) {
            $member['type'] = 0;
        } else {
            if ($data1 > 0) {
                $member['type'] = 1;
            } else {
                if ($data3 > 0) {
                    $member['type'] = 2;
                } else {
                    $member['type'] = 0;
                }
            }
        }

        //返回用户token
        if (count($member) > 0) {
            $phone = $member['phone'];
            $jwt = new JwtUntils();
            $jwt_data['phone'] = $phone;
            $jwt_data['id'] = $member['id'];
            //$jwt_data['timeStamp_'] = time();
            $member['token']  = $jwt->createToken($jwt_data);
            
            $result['code'] = 200;
            $result['data'] = $member;
            $result['message'] = '查询成功';
        } else {
            $result['code'] = 200;
            $result['message'] = '该条件未查询到信息';
        }
        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**获取我发布的小区列表
     * @params type  0出租 1出售
     * @params pageNo   页码
     * @params pageSize  每页显示条数
     * @return json
     * @author zyt
     */
    public function getMyBuildingsList ()
    {
        $status = $this->params['type'];

        $result['code']     = 101;
        $result['message']  = '';
        if (!$this->userId) {
            $result['message']  = '请传入authToken';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        if (!isset($status)) {
            $result['message']  = '请求状态不能为空';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        if ($status != 0 && $status != 1) {
            $result['message']  = '请求状态异常' . $status;
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        $pageNo = empty($this->params['pageNo']) ? 1 : $this->params['pageNo'];

        $building = $this->videoModel->getBuildingByStatus($this->userId, $status, $pageNo, $pageSize=10);
        if (count($building) > 0) {
            $result['code']     = 200;
            $result['message']  = '查询列表成功';
            $result['data']     = $building;
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        } else {
            $result['code']     = 200;
            $result['message']  = '此条件查询无结果';;
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
    }

    /**
     * 获取通过我发布的小区获取视频列表(上架或下架列表)
     * @params building_id  小区id
     * @params video_type  视频类型  0,2出租 1出售
     * @params type  0下架 1上架
     * @params pageNo   页码
     * @params pageSize  每页显示条数
     * @return json
     * @author zyt
     */
    public function getBuildingsByType()
    {
        $building_id = $this->params['building_id'];
        $type = $this->params['type'];
        $video_type = $this->params['video_type'];

        $result['code']     = 101;
        $result['message']  = '';
        if (!$this->userId) {
            $result['message']  = '请传入authToken';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        if (!isset($building_id)) {
            $result['message']  = '请传入小区id';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        if (!isset($type)) {
            $result['message']  = '请求状态不能为空';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        if ($type != 0 && $type != 1) {
            $result['message']  = '请求状态异常' . $type;
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        $pageNo = empty($this->params['pageNo']) ? 1 : $this->params['pageNo'];

        $video = $this->videoModel->getBuildingsByType($this->userId, $type, $video_type, $building_id, $pageNo, $pageSize = 10);
        if (count($video) > 0) {
            $result['code']     = 200;
            $result['message']  = '查询列表成功';
            $result['data']     = $video;
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        } else {
            $result['code']     = 200;
            $result['message']  = '此条件查询无结果';;
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
    }


}