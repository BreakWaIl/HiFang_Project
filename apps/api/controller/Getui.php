<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/5/2
 * Time: 10:21
 */


namespace app\api\controller;

use app\api\untils\GeTuiUntils;
use app\common\model\Device;

use app\api\controller\Basic;
use app\common\model\Member;
use app\common\model\Video;
use think\Db;

class Getui extends Basic
{
    /*public function __construct($request = null)
    {
        parent::__construct($request);
        $this->memberModel = new Member();
        $this->videoModel = new Video();
    }*/
    public function __construct()
    {
        $this->memberModel = new Member();
        $this->videoModel = new Video();
    }

    /**
     * @param $type
     * @param $userId
     * @param $param_id  接收人
     * @param string $data 接受内容
     * @return bool
     */
    public function pushMessage($type,$userId,$param_id,$data='')
    {
        //推送信息
        $ge_tui = new GeTuiUntils();
        //查询执行方信息
        $nickname = $this->memberModel->where('id',$userId)->value('nickname');
// 1 发布视频获得奖励,已审核到账 2发布视频审核被拒绝 3邀请好友成功得奖励
// 4举报视频 50提现成功 51提现退回 52提现被拒绝 6评论 7点赞视频 8关注 9分享
        $device_id = DB::table('yf_hf_device')->where('member_id',$param_id)->value('device_id');
        if ($type == 1 || $type == 2) { //推送发布,详细内容在admin/video中(后台审核,不用此方法)
            $content = $data;
            $ge_tui->public_push_message_for_one($userId,$device_id,'发布',$content,$type);
        }
        elseif ($type == 3) { //推送发布,详细内容在admin中(后台审核,不用此方法)
            $content = $data;
            $ge_tui->public_push_message_for_one($userId,$device_id,'邀请',$content,$type);
        }
        elseif ($type == 4) { //(后台审核,不用此方法)
            $content = '您的举报已被核实,请查看';
            $ge_tui->public_push_message_for_one($userId,$device_id,'举报',$data,$type);
        }
        elseif ($type == 50 || $type == 51 || $type == 52) { //(后台审核,不用此方法)
            $content = $data;
            $ge_tui->public_push_message_for_one($userId,$device_id,'提现',$content,$type);
        }
        elseif ($type == 7) {
            $content = $nickname.'点赞了您的视频,快去看看';
            $ge_tui->public_push_message_for_one($userId,$device_id,'点赞',$content,$type);
        }
        elseif ($type == 8) {
            $content = $nickname.'关注了您,快去看看';
            $ge_tui->public_push_message_for_one($userId,$device_id,'关注',$content,$type);
        }
        elseif ($type == 9) {
            $content = $nickname.'分享了您的视频,快去看看';
            $ge_tui->public_push_message_for_one($userId,$device_id,'分享',$content,$type);
        }

        //推送记录存入task表
        $data = [
            'id'           => 0,
            'member_id'    => $param_id,
            'content'      => $content,
            'type'         => $type,
            'is_show'      => 0,
            'create_time'  => time(),
            'update_time'  => time()
        ];
        $res = Db::table('yf_hf_task')->insert($data);
        return true;
    }
    
}