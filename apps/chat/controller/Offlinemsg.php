<?php

namespace app\chat\controller;

use think\Controller;
use app\common\model\Member;
use think\Db;
use think\Log;

header('Access-Control-Allow-Origin:*');

Class Offlinemsg extends Controller
{
    /**
     * 登录显示未读消息
     * @return string
     */
    /*public function index()
    {
        $post = $this->request->post();

        $app_key = $post["app_key"];

        $app = Member::table("yf_hf_chat_app")->where("app_key", $app_key)->find();

        if ($app) {

            // 自己的id,群id
            $mine = $post["id"];
            $user = Member::table('yf_hf_member')->where('id', $mine)->find();

            $arr=[];
            $chatdata = [];

            if ($user) {
                $logtime = $user['logout_timestamp'];

                $re = Member::table('yf_hf_member')->where('id', $mine)->update(['status' => 'online', 'logout_timestamp' => time()]);
            } else {
                $logtime = 0;
                $arr = [
                    "app_key" => $app_key,
                    "id" => $mine,
                    "logout_timestamp" => time(),
                    "status" => 'online'
                ];
                $re = Member::table("yf_hf_member")->insert($arr);
            }


            $data =Member::table('yf_hf_chat_message')->where(['to'=>$mine,'type'=>'friend','app_key'=>$app_key])->where('timestamp','>',$logtime)->order('mid desc')->limit(20)->select();
            
            if ($data) {
                $result = array_reverse($data);
                
                foreach ($result as $value) {
                    $chatdata[] = $value['data'];
                }
                
            }

            if(isset($post['group']) && $post['group'] != 'false' &&  $post['group'] != ''){
                  $group = $post['group'];
              }else{
                  $group =false;
              }
            
            if ($group) {
                  $gid= [];
                foreach ($group as $v) {
                    $gid[] = $v['id'];
                }

                $gdata =Member::table('yf_hf_chat_message')->where('to','in',$gid)->where(['type'=>'group','app_key'=>$app_key])->where('timestamp','>',$logtime)->order('mid desc')->limit(20)->select();
                $gdata =Member::table('yf_hf_chat_message')->where('to','in',$gid)->where(['type'=>'group','app_key'=>$app_key])->where('timestamp','>',$logtime)->order('mid desc')->limit(20)->update(['isread'=>1]);
                if($gdata){
                     $result = array_reverse($gdata);
                     foreach ($result as $value) {
                        $chatdata[] = $value['data'];
                     }
            
                }
               
            }

             $arr['code'] = 0;
             $arr['data'] =$chatdata;
             return json_encode($arr);

        } else {
            header("Status: 401 Not authenticated");
        }
    }*/

    public function index()
    {
        $post = $this->request->post();

        $app_key = $post["app_key"];
        $app = Member::table("yf_hf_member")->where("app_key", $app_key)->find();

        if ($app) {
            // 自己的id
            $mine = $post["id"];
            $user = Member::table('yf_hf_member')->where('id', $mine)->find();

            $arr=[];
            $chatdata = [];

            $logtime = $user['logout_timestamp'];
            $re = Member::table('yf_hf_member')->where('id', $mine)->update(['status' => 'online', 'logout_timestamp' => time()]);
            Log::info("=======Offlinemsg-online========");
            Log::info($mine);
            Log::info($re);

            //查询离线信息
            //$data =Member::table('yf_hf_chat_message')->where(['to'=>$mine,'type'=>'friend','app_key'=>$app_key])->where('timestamp','>',$logtime)->where('isread',0)->order('id desc')->limit(20)->select();
            $data =Member::table('yf_hf_chat_message')->where(['to'=>$mine,'type'=>'friend','app_key'=>$app_key])->where('isread',0)->order('id desc')->limit(20)->select();
            if ($data) {
                $result = array_reverse($data);
                foreach ($result as $value) {
                    $chatdata[] = $value['data'];
                }
            }

            //将信息改为已读
            //$res =Member::table('yf_hf_chat_message')->where(['to'=>$mine,'type'=>'friend','app_key'=>$app_key])->where('timestamp','>',$logtime)->where('isread',0)->update(['isread'=>1,'timestamp'=>time()]);
            $res = Member::table('yf_hf_chat_message')->where(['to'=>$mine,'type'=>'friend','app_key'=>$app_key])->where('isread',0)->update(['isread'=>1,'timestamp'=>time()]);
            $task = Member::table('yf_hf_task')->where(['member_id'=>$mine,'type'=>10,'is_show'=>1])->update(['is_show'=>1]);

            $arr['code'] = 0;
            $arr['data'] =$chatdata;
            return json_encode($arr, JSON_UNESCAPED_UNICODE);

        } else {
            header("Status: 401 Not authenticated");
        }
    }

    /**
     * 客服消息添加离线消息
     * @auther zyt
     * @time 2018/6/26
     */
    public function offlinemsg () {
        $post = $this->request->post();

        $app_key = $post["app_key"];
        $app = Member::table("yf_hf_member")->where("app_key", $app_key)->find();

        if ($app) {
            $mine = $post["id"];
            $user = Member::table('yf_hf_member')->where('id', $mine)->find();

            //查询是否有客服回复信息 ,若有 则显示,若没有显示客服固定消息
            //客服id
            $kefu_member_id = Db::table('yf_config')->where('name','kefu_member_id')->value('value');
            $data =Member::table('yf_hf_chat_message')->where(['from'=>$kefu_member_id,'to'=>$mine,'app_key'=>$app_key])->where('isread',0)->order('id desc')->limit(20)->select();
            $chatdata = [];
            if ($data) {
                $result = array_reverse($data);
                foreach ($result as $value) {
                    $chatdata[] = $value['data'];
                }
                //将信息改为已读
                $res = Member::table('yf_hf_chat_message')->where(['to'=>$mine,'type'=>'friend','app_key'=>$app_key])->where('isread',0)->update(['isread'=>1,'timestamp'=>time()]);
                //$res = Member::table('yf_hf_chat_message')->where(['to'=>$kefu_member_id,'from'=>$mine,'app_key'=>$app_key])->where('isread',0)->update(['isread'=>1,'timestamp'=>time()]);
                $task = Member::table('yf_hf_task')->where(['member_id'=>$mine,'type'=>10,'is_show'=>1])->update(['is_show'=>1]);
            } else {
                $data1 =Member::table('yf_config')->where('name','kefu_info')->order('id','desc')->select();
                if ($data1) {
                    $result = array_reverse($data1);
                    foreach ($result as $value) {
                        $chatdata[] = $value['value'];
                    }
                }
            }

            $arr['code'] = 0;
            $arr['data'] =$chatdata;
            return json_encode($arr, JSON_UNESCAPED_UNICODE);

        } else {
            header("Status: 401 Not authenticated");
        }
    }
}
