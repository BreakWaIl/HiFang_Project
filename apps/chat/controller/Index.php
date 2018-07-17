<?php

namespace app\chat\controller;

use app\api\untils\GeTuiUntils;
use app\common\untils\JwtUntils;
use think\Controller;
use app\common\model\Member;
use think\Db;
use think\Log;

header('Access-Control-Allow-Origin:*');
define('Api_Host', 'https://talk.fujuhaofang.com');
define('Api_port', '2080');
class Index extends Controller
{
   
    /**
     * 发送消息
     * @return string
     */
    public function sendmessage()
    {
        $post = $this->request->post();

        $post["avatar"] =htmlspecialchars($post['avatar']);
        $post["username"] =htmlspecialchars($post['username']);
        $post['content'] =htmlspecialchars($post['content']);

        $app_key = $post['appkey'];
        $app = Member::table("yf_hf_chat_app")->where("app_key", $app_key)->find();

        if ($app) {
            $gagword =Member::table("yf_hf_chat_gagwords")->where("app_id",$app['id'])->select();

           if($gagword){
               
               $search =[];
               foreach ($gagword as $vd) {
                  $search[]=$vd['data'];
               }
 
                $word =$post['content']; 
            
                $newword = str_replace($search,"***",$word);
            
                $post['content'] = $newword;
            }

            $option = array('host' => Api_Host, "port" => Api_port);

            $woker = new WokerAPI($app_key, $app['app_secret'], $app['id'], $option);

            $post["mine"] = false;
            //$post["mine"] = $post['toid'];

            $appkey = $post['appkey'];
            unset($post["appkey"]);
            $post['timestamp']=microtime(true)* 1000;

            if($post['type'] == 'group'){
              $post['id'] =$post['toid'];
            }else{
              $post['id'] =$post['fromid'];
            }
            $data = json_encode($post);
            $data=str_replace("\\",'\\\\',$data);
            //修改  @auther zyt @time 2018/5/21/13:20
            //查询对方是否在线  在线isread=1  不在线isread=0
            /*$tomember = Member::table('yf_hf_member')->where('id',$post["toid"])->find();
            if ($tomember['status'] == 'online') {
                $arr = [
                    'id'          => 0,
                    "app_key" => $appkey,
                    "from" => $post["fromid"],
                    "to" => $post["toid"],
                    "data" => $data,
                    "type" => $post["type"],
                    "isread"=> 1,
                    "timestamp" => time()
                ];
            } else {
                $arr = [
                    'id'          => 0,
                    "app_key" => $appkey,
                    "from" => $post["fromid"],
                    "to" => $post["toid"],
                    "data" => $data,
                    "type" => $post["type"],
                    "isread"=> 0,
                    "timestamp" => time()
                ];
            }*/
            // 组合数据
            $arr = [
                'id'          => 0,
                "app_key" => $appkey,
                "from" => $post["fromid"],
                "to" => $post["toid"],
                "data" => $data,
                "type" => $post["type"],
                "timestamp" => time()
            ];

            $white =Member::table('yf_hf_chat_white_list')->where(['app_id'=>$app['id'],'userid'=>$post["fromid"]])->find();

            if(!$white){
                if ($app["state"] == 'forbidden_all_chat') {
                    $arr["code"] = -1;
                   $arr['msg'] = "禁止私聊和群聊";
                    return json_encode($arr);
                }

            }


            $toid = $post['toid'];

            if ($post["type"] == "group") {

                if(!$white){
                    if ($app["state"] == 'forbidden_group_chat') {
                        $arr["code"] = -1;
                       $arr['msg'] = "禁止群聊";
                        return json_encode($arr);
                    }
            

              $gaglist =Member::table("yf_hf_chat_gaglist")->where('gid',['=',0],['=',$post['toid']],'or')->where(['app_id'=>$app['id'],'userid'=>$post['fromid']])->find();
          

                if($gaglist){
                             $arr["code"] = -1;
                             $arr["msg"] = "已经被禁言！";
                             return json_encode($arr);
                          
                    }else{

                        unset($post["toid"]);
                        $woker->emit('group'.$toid, 'getmessage', array('message' => $post));
                    }

                }else{
                    unset($post["toid"]);
                    $woker->emit('group'.$toid, 'getmessage', array('message' => $post));

                }


            } else {

                if(!$white){

                    if ($app["state"] == 'forbidden_private_chat') {
                        $arr["code"] = -1;
                       $arr['msg'] = "禁止私聊";
                        return json_encode($arr);
                    }

                    $gag =Member::table("yf_hf_chat_gaglist")->where(['app_id'=>$app['id'],'userid'=>$post["fromid"]])->find();

                    if($gag && $gag['gid'] == 0){
                        $arr["code"] = -1;
                       $arr['msg'] = "已经被禁言！";
                        return json_encode($arr);
                    }
                }

                $woker->emit('user'.$toid, 'getmessage', array('message' => $post));

            }
            //判断接收消息的用户是否在线,不在线推送消息
            $is_online = Db::table('yf_hf_member')->where('id',$post['toid'])->value('status');
            if ($is_online != 'offline') {
                //在线
                $arr['isread']=1;
            }

            $message = Member::table("yf_hf_chat_message")->insert($arr);
            Log::info("=====sendmessage=======");
            Log::info($message);
            Log::info($arr);
            /**
             * 消息推送
             * @auther zyt
             * @time 2018/6/5 14:43
             */

            //查询接收消息的用户device_id
            $device_id = Db::table('yf_hf_device')->where('member_id',$post['toid'])->value('device_id');
            $nickname = Db::table('yf_hf_member')->where('id',$post['fromid'])->value('nickname');
            if ($is_online == 'offline') {
                $ge_tui = new GeTuiUntils();
                $content = $nickname.'给你发了消息:'.$post['content'];
                $jwt = new JwtUntils();
                $jwt_data['id'] = $post['fromid'];
                $token = $jwt->createToken($jwt_data);
                $rem = $ge_tui->public_push_message_for_one($post['fromid'],$device_id,'消息',$content,$type=10,$token,$nickname);
                //推送记录存入task表
                $arr = [
                    'id'           => 0,
                    'member_id'    => $post["toid"],
                    'content'      => $content,
                    'type'         => 10,
                    'is_show'      => 0,
                    'create_time'  => time(),
                    'update_time'  => time()
                ];
                Db::table('yf_hf_task')->insert($arr);
            }

        } else {

            $arr["code"] = -1;
           $arr['msg'] = "非发消息！";

            return json_encode($arr);
        }
    }

    /*public function sendmessage()
    {
        $post = $this->request->post();

        $post["avatar"] =htmlspecialchars($post['avatar']);
        $post["username"] =htmlspecialchars($post['username']);
        $post['content'] =htmlspecialchars($post['content']);

        $app_key = $post['appkey'];
        $app = Member::table("yf_hf_chat_app")->where("app_key", $app_key)->find();

        if ($app) {
            $option = array('host' => Api_Host, "port" => Api_port);

            $woker = new WokerAPI($app_key, $app['app_secret'], $app['id'], $option);

            $post["mine"] = false;
            //$post["mine"] = $post['toid'];

            $appkey = $post['appkey'];
            unset($post["appkey"]);
            $post['timestamp']=microtime(true)* 1000;

            if($post['type'] == 'group'){
                $post['id'] =$post['toid'];
            }else{
                $post['id'] =$post['fromid'];
            }
            $data = json_encode($post);
            //修改  @auther zyt @time 2018/5/21/13:20
            //查询自己是否在线,修改为在线状态
            //$members = Member::table('yf_hf_member')->where('id',$post['fromid'])->update(['status'=>'online','logout_timestamp'=>time()]);
            //查询对方是否在线  在线isread=1  不在线isread=0
            $tomember = Member::table('yf_hf_member')->where('id',$post["toid"])->find();
            if ($tomember['status'] == 'online') {
                $arr = [
                    'id'          => 0,
                    "app_key"     => $appkey,
                    "from"        => $post["fromid"],
                    "to"          => $post["toid"],
                    "data"        => $data,
                    "type"        => $post["type"],
                    "isread"      => 1,
                    "timestamp"   => time()
                ];
            } else {
                $arr = [
                    'id'          => 0,
                    "app_key"     => $appkey,
                    "from"        => $post["fromid"],
                    "to"          => $post["toid"],
                    "data"        => $data,
                    "type"        => $post["type"],
                    "isread"      => 0,
                    "timestamp"   => time()
                ];
            }
            
            $toid = $post['toid'];

            $message = Member::table("yf_hf_chat_message")->insert($arr);
        } else {

            $arr["code"] = -1;
            $arr['msg'] = "非发消息！";

            return json_encode($arr);
        }
    }*/


    /**
     * 添加好友
     * @return string
     */
    public function add_friend()
    {

        $post = $this->request->post();
        $app_key = $post['appkey'];
        $app = Member::table("yf_hf_chat_app")->where("app_key", $app_key)->find();

        if ($app) {
            $option = array('host' => Api_Host, "port" => Api_port);
            $woker = new WokerAPI($app_key, $app['app_secret'], $app['id'], $option);
            $post["mine"]["type"] = "friend";

            $woker->emit('user'.$post['addfriend']['id'], "addfriend", array('message' => $post['mine']));
        } else {
            $arr["code"] = -1;
            $arr["msg"] = "非法消息！";

             return json_encode($arr);
        }

    }

    /**
     * 删除好友
     * @return string
     */
    public function remove_friend()
    {
        $post = $this->request->post();
        $app_key = $post['appkey'];
        $app = Member::table("yf_hf_chat_app")->where("app_key", $app_key)->find();

        if ($app) {
          

            $option = array('host' => Api_Host, "port" => Api_port);

            $woker = new WokerAPI($app_key, $app['app_secret'], $app['id'], $option);
            $post["mine"]["type"] = "friend";
            $woker->emit("user".$post['removefriend']["id"], "removefriend", array("message" => $post['mine']));
        } else {
            $arr["code"] = -1;
            $arr["msg"] = "非法消息！";

             return json_encode($arr);
        }
    }

    /**
     * 添加群
     * @return string
     */
    public function join_group()
    {
        $post = $this->request->post();
        $app_key = $post['appkey'];
        $app = Member::table("yf_hf_chat_app")->where("app_key", $app_key)->find();
        if ($app) {
        
            $option = array('host' => Api_Host, "port" => Api_port);

            $woker = new WokerAPI($app_key, $app['app_secret'], $app['id'], $option);
            unset($post["addgroup"]["type"]);
            $woker->emit("user".$post["mine"]['id'], "addgroup", array("message" => $post["addgroup"]));
        } else {
            $arr["code"] = -1;
            $arr["msg"] = "非法消息！";
             return json_encode($arr);
        }
    }

    /**
     * 删除群
     * @return string
     */
    public function leave_group()
    {
        $post = $this->request->post();
        $app_key = $post['appkey'];
        $app = Member::table("yf_hf_chat_app")->where("app_key", $app_key)->find();
        if ($app) {
        
            $option = array('host' => Api_Host, "port" => Api_port);
            $woker = new WokerAPI($app_key, $app['app_secret'], $app['id'], $option);
            $woker->emit("user" . $post["mine"]['id'], "leavegroup", array("message" => $post["removegroup"]));
        } else {
            $arr["code"] = -1;
            $arr["msg"] = "非法消息！";
           return json_encode($arr);
        }
    }


    /**
     * 上传图片
     * @return string
     */
    public function upload_image()
    {
        Log::write("======upload_image-write=====");
        Log::info("======upload_image-info=====");
        $http_type = ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') || (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')) ? 'https://' : 'http://';
       
        $file = $this->request->file("file");

        $size = ($_FILES["file"]["size"]) /1024;
        Log::write($size);
        if($size > 10240){
            Log::write("======upload_image1=====");
            $code = 1;
            $error ="文件太大！";
            $imgpath = "";

            $data = [
            "code" => $code,
            "msg" => $error,
            "data" => [
                  "src" => $imgpath
             ]
          ];

          return json_encode($data);
        }
        $newpaths = ROOT_PATH . "/public/assets/upload/images/";
        $info = $file->validate(['ext'=>'jpg,png,gif,jpeg,JPG,JPEG,PNG,GIF'])->move($newpaths, bin2hex(pack('N', time()) . pack('n', rand(1, 65535))));
     
        if ($info) {

            Log::write("======upload_image2=====");
            $code = 0;
            $imgname = $info->getFilename();
            $imgpath = $http_type.$_SERVER['HTTP_HOST'] . "/assets/upload/images/" . $imgname;
            $error = "";
        } else {
            Log::write("======upload_image3=====");
            $code = 1;
            $error = $file->getError();
            $imgpath = "";
        }

        $data = [
            "code" => $code,
            "msg" => $error,
            "data" => [
                "src" => $imgpath
            ]
        ];
        Log::write("======upload_image4=====");
        return json_encode($data);
        // 返回数据格式
    }

    /**
     * 上传文件
     * @return string
     */
    public function upload_file()
    {
       
        $http_type = ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') || (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')) ? 'https://' : 'http://';
        $file = $this->request->file("file");

        $newpaths = ROOT_PATH . "/public/assets/upload/files/";
        $name = $_FILES["file"]["name"];
        $arr = explode(".",$name);
        $ext =$arr[1];
        if($ext == 'html' || $ext == 'htm'|| $ext == 'jsp' || $ext == 'php' || $ext == 'js'){
            $code = 1;
            $error ="不支持该文件格式！";
            $imgpath = "";

           $data = [
            "code" => $code,
            "msg" => $error,
            "data" => [
                "src" => $imgpath
                , "name" => $name
             ]
          ];

          return json_encode($data);
        }

        $size = ($_FILES["file"]["size"]) /1024;
        if($size > 10240){
            $code = 1;
            $error ="文件太大！";
            $imgpath = "";

           $data = [
            "code" => $code,
            "msg" => $error,
            "data" => [
                "src" => $imgpath
                , "name" => $name
             ]
          ];

          return json_encode($data);
        }

        $info = $file->move($newpaths, bin2hex(pack('N', time()) . pack('n', rand(1, 65535))));
        if ($info) {
            $code = 0;
            $imgname = $info->getFilename();
            $imgpath = $http_type.$_SERVER['HTTP_HOST'] . "/assets/upload/files/" . $imgname;
            $error = "";
        } else {
            $code = 1;
            $error = $file->getError();
            $imgpath = "";
        }

        $data = [
            "code" => $code,
            "msg" => $error,
            "data" => [
                "src" => $imgpath
                , "name" => $name
            ]
        ];

        return json_encode($data);

    }

    /**
     * 查看群成员接口
     * @return string
     */
    public function members()
    {
        $data = [
             "code"=>0
            ,"msg"=>""
            ,"data"=>[
                  "list"=>[]
             ]
        ];
        return json_encode($data);
    }

    /**
     * 视频申请
     * @return string
     */
    public function apply(){
       $post = $this->request->post();
       $app_key = $post['appkey'];
       $app = Member::table("yf_hf_chat_app")->where("app_key", $app_key)->find();
       if($app){
          $option = array('host' => Api_Host, "port" => Api_port);
          $user =Member::table('yf_hf_member')->where(['id'=>$post['id'],'app_key'=>$post['appkey']])->find();
          $type =$user['status'];

          if($type == 'offline'){
              return "对方不在线！";
          }

          $woker = new WokerAPI($app_key, $app['app_secret'], $app['id'], $option);

          $woker->emit("user" . $post['id'], "video", array("message" => "申请视频连接", "channel" => $post['channel'],"avatar"=>$post['avatar'],'username'=>$post['name'],"mine"=>$post['mine']));
       }else{
          header("Status: 401 Not authenticated");
       }
      
    }

    /**
     * 储存音频文件
     * @return bool|string
     */
    public function saveVoice(){

     $http_type = ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') || (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')) ? 'https://' : 'http://';
      $file =$this->request->file('file');

      if ($file) {
            $newpath = ROOT_PATH . "/public/assets/upload/voices/";
            $info = $file->move($newpath,time().".wav");

            if ($info) {
                $imgname = $info->getFilename();
                
                $imgpath = $http_type . $_SERVER['HTTP_HOST']."/assets/upload/voices/" . $imgname;
                $arr=[
                  'data'=>[
                      'src'=>$imgpath
                   ]
                ];
                return json_encode($arr);
            } else {
                return false;
            }
        }
    }

    /**
     * 
     * [refuse description]
     * @return [type] [description]
     */
    public function refuse(){
      $post =$this->request->post();
      $appkey =$post['appkey'];
      $app = Member::table("yf_hf_chat_app")->where("app_key", $appkey)->find();
      if($app){
          $option = array('host' => Api_Host, "port" => Api_port);
          $woker = new WokerAPI($appkey, $app['app_secret'], $app['id'], $option);

          $woker->emit('user'.$post['id'],'video-refuse',array("message"=>'对方拒绝视频连接！'));

      }else{
          header("Status: 401 Not authenticated");
      }
    }

    /**
     * 用户下线记录
     * qin2018-05-05
     */
    public function offline()
    {
        Log::write("======offline=====");
        Log::write(input('post.token'));
        $token=input('post.token');
        $jwt = new JwtUntils();
        $data = $jwt->getDecode($token);
        $app = Member::table("yf_hf_member")->where('id',$data['data']['id'])->find();
        if($app){
            /*$option = array('host' => Api_Host, "port" => Api_port);

            $woker = new WokerAPI($app['app_key'], $app['app_secret'], $app['id'], $option);
            //$post["mine"]["type"] = "friend";
            $woker->emit("user".$app['id'], "offline", array("message" => ''));*/

            $result = Member::table("yf_hf_member")->where('id',$data['data']['id'])->update(['status'=>'offline']);
dump($result);exit;
        }else{
            header("Status: 401 Not authenticated");
        }
    }
}
