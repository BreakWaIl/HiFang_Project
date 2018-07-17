<?php
/**
 * Created by PhpStorm.
 * User: ASUS
 * Date: 2018/5/7
 * Time: 14:31
 */

namespace app\api\controller;


use think\Db;
use think\Request;
use app\common\model\Behavior as behaviorModel;

class Behavior extends Basic
{
    public $behaviorModel;
    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->behaviorModel = new behaviorModel();
    }

    /**
     * 用户行为接口
     * by songjian
     * @param id 用户id
     * @param type 该用户行为type类型
     * @return json
     */
    /*
    * 视频发布流程统计：
    视频发布流程统计：
    1.点击发布按钮
    2.添加音乐
    3.添加封面
    4.房源信息
    5.成功发布
    视频详情页统计：
    6.开始观看
    7.完整观看
    8.点赞视频
    9.评论视频
    10.转发视频
    11.进入小区主页
    12.进入ta个人主页
    视频转发效果统计
    13.视频转发
    14.进入被转视频转发页面
    15.转发视频点击播放
    16.转发视频完整观看
    26.下载过app
    邀请好友页面
    17.邀请好友
    18.进入被转页面
    19.登录
    30.点开红包进入邀请页面
    个人主页分享页面
    20.分享个人主页
    21.进入被转个人主页页面
    22.在分享主页点击视频
    小区
    23.关注小区
    24.上传出租房源
    25.上传出售房源
    */
    public function insertBehavior(Request $request){
        header('Access-Control-Allow-Origin:*');
        $data = [];
        $data['id'] = 0;
        $data['userid'] = $request->post('id');  //该用户id
        if ($data['userid'] == ''){
            $datas['code'] = 101;
            $datas['message'] = '请填写userid';
            return json_encode($datas,JSON_UNESCAPED_UNICODE);
        }
        $user_array = config('miss_user');
        if (in_array($data['userid'],$user_array)){
            $datas['code'] = 200;
            $datas['message'] = '内部人员，无需插入行为表';
            return json_encode($datas,JSON_UNESCAPED_UNICODE);
        }
        $data['type'] = $request->post('type');  //该用户行为type类型
        $data['video_id'] = $request->post('video_id'); //该视频id
        //$data['create_time'] = date('Y-m-d H:i:s',time());
        //$data['update_time'] = date('Y-m-d H:i:s',time());
        $data['create_time'] = time();
        $data['update_time'] = time();
        $res = $this->behaviorModel->insert($data);
        if (!$res){
            $datas['code'] = 101;
            $datas['message'] = '插入用户行为失败';
        }else{
            $datas['code'] = 200;
            $datas['message'] = '插入用户行为成功';
        }
        return json_encode($datas,JSON_UNESCAPED_UNICODE);
    }

    public static function insertBackBehavior($userid,$type,$video_id=''){
        $data = [];
        $data['id'] = 0;
        $data['userid'] = $userid;  //该用户id
        $data['type'] = $type;  //该用户行为type类型
        $data['video_id'] = $video_id;
        //$data['create_time'] = date('Y-m-d H:i:s',time());
        //$data['update_time'] = date('Y-m-d H:i:s',time());
        $data['create_time'] = time();
        $data['update_time'] = time();
        $behaviorModel = new behaviorModel();
        $res = $behaviorModel->insert($data);
        if (!$res){
            $datas['code'] = 101;
            $datas['message'] = '插入用户行为失败';
        }else{
            $datas['code'] = 200;
            $datas['message'] = '插入用户行为成功';
        }
        return json_encode($datas,JSON_UNESCAPED_UNICODE);
    }
}