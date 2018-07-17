<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/5/7
 * Time: 13:24
 */
namespace app\api\controller;

use app\api\untils\GeTuiUntils;
use app\chat\controller\WokerAPI;
use app\common\model\Follow;
use app\common\model\Member;
use app\common\untils\JwtUntils;
use app\common\model\ChatMessage;
use think\Db;
use think\Log;
use think\Request;

/**
 * Class Chat
 * @package app\api\controller
 */
class Chat extends Basic
{
    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->memberModel = new Member();
        $this->chatmessageModel = new ChatMessage();
        $this->followModel = new Follow();
    }

    /**post
     * @return \think\response\View
     * @auther zyt
     */
    public function index ()
    {
        $result['code']    = 101;
        $result['message'] = '';
        //本人信息
        $authToken = $this->params['authToken'];
        $info = $this->memberModel->where('id',$this->userId)->find();
        if ($info['unionid']) {
            $info['headimgurl'] = $info['headimgurl'];
        } else {
            $info['headimgurl'] = Tool::getDomain().$info['headimgurl'];
        }
        $info['headimgurl'] = str_replace('http://','https://',$info['headimgurl']);
        //联系人信息
        $token = $this->params['token'];
        $jwt = new JwtUntils();
        $data = $jwt->getDecode($token);
        $other = $this->memberModel->where('id',$data['data']['id'])->find();
        $other['headimgurl'] = str_replace('http://','https://',$other['headimgurl']);
        //查询是否拉黑该聊天对象
        $res = $this->followModel->where(['member_id' => $other['id'], 'followed_id'=> $this->userId, 'type'=>0])->find();
        if ($res) {
            if ($res['black'] == 1) {
                $result['message'] = '该用户已经把您拉黑,无法进行聊天';
                return json_encode($result, JSON_UNESCAPED_UNICODE);
            }
        }
        return view('chat1.html',['info'=>$info, 'other'=>$other, 'authToken'=>$authToken]);
    }

    /**
     * 获取聊天对象和任务消息列表  get
     * @param pageNo 页码
     * @param authToken
     * @auther zyt
     * @return
     */
    public function getChatFriendList ()
    {
        $result['code'] = 101;
        $result['message'] = '';
        //查询该用户是否存在
        $member = $this->memberModel->find($this->userId);
        if (!$member) {
            $result['message'] = '该用户不存在';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //获取 参数设置表中的 客服id 和信息
        $kefu_member_id = Db::table('yf_config')->where('name','kefu_member_id')->value('value');
        //$kefu_info = Db::table('yf_config')->where('id',83)->value('value');
        $chatMessage = $this->chatmessageModel->where(['from'=>$this->userId,'to'=>$kefu_member_id])->whereOr(['to'=>$this->userId,'from'=>$kefu_member_id])->order('id','desc')->limit(1)->find();
        $kefu_chatContent = json_decode($chatMessage['data'])->content;
        if (strpos($kefu_chatContent,'img[https:') !==false || strpos($kefu_chatContent,'img[http:') !==false) {
            $kefu_chatContent = '[图片消息]';
        }
        //查询该客服信息
        $kefu_member = Db::table('yf_hf_member')->where('id',$kefu_member_id)->find();
        $jwt = new JwtUntils();
        $jwt_data['id'] = $kefu_member_id;
        $jwt_data['phone'] = $kefu_member['phone'];
        $jwt_data['timeStamp_'] = time();
        if ($chatMessage) {
            $data['kefu'] = [
                'from'         => $chatMessage['from'],
                'to'           => $kefu_member_id,
                'content'      => $kefu_chatContent,
                'content_num'  => '',
                'type'         => 0,
                'isread'       => 1,
                'timestamp'    => $chatMessage['timestamp'],
                'nickname'     => $kefu_member['nickname'],
                'headimgurl'   => $kefu_member['headimgurl'],
                'token'        => $jwt->createToken($jwt_data)
            ];
        } else {
            $data['kefu'] = [
                'from'         => $this->userId,
                'to'           => $kefu_member_id,
                'content'      => '',
                'content_num'  => '',
                'type'         => 0,
                'isread'       => 1,
                'timestamp'    => time(),
                'nickname'     => $kefu_member['nickname'],
                'headimgurl'   => $kefu_member['headimgurl'],
                'token'        => $jwt->createToken($jwt_data)
            ];
        }

        //获取最新任务消息
        $task = Db::table('yf_hf_task')->where('member_id',$this->userId)->whereIn('type',[1,11,2,21,22,3,4,50,51,52])->order('id desc')->select();
        if (count($task) > 0) {
            $data['task'] = [
                'icon'    => '',
                'title'   => '系统消息',
                'content' => $task[0]['content'],
                'is_show' => $task[0]['is_show'],
                'time'    => $task[0]['create_time']
            ];

        } else {
            $data['task'] = [
                'icon'    => '',
                'title'   => '系统消息',
                'content' => '暂无消息',
                'is_show' => 1,
                'time'    => 0
            ];
        }

        //查询10组该用户的聊天对象列表
        $pageNo = empty($this->params['pageNo']) ? 1 : $this->params['pageNo'];
        $chatMessage = $this->chatmessageModel->getChatFriendList($this->userId, $kefu_member_id, $pageNo);
        $message = $chatMessage['list'];
        $chat['list'] = [];
        $chat['total'] = $chatMessage['total'];
        if ($message) {
            for ($i=0;$i<count($message);$i++) {
                    $chatMessage = $this->chatmessageModel->find($message[$i]['id']);
                    $chatContent = json_decode($chatMessage['data'])->content;
                    if (strpos($chatContent,'img[https:') !==false || strpos($chatContent,'img[http:') !==false) {
                        $chatContent = '[图片消息]';
                    }
                    $jwt = new JwtUntils();
                    $jwt_data['phone'] = $message[$i]['phone'];
                    $jwt_data['id'] = $message[$i]['gid'];
                    $jwt_data['timeStamp_'] = time();
                    $chat['list'][] = [
                        'mid'          => $message[$i]['id'],
                        'from'         => $message[$i]['gid'],
                        'to'           => $message[$i]['to'],
                        'content'      => $chatContent,
                        'content_num'  => count($chatMessage),
                        'type'         => $message[$i]['type'],
                        'isread'       => $message[$i]['isread'],
                        'timestamp'    => $message[$i]['timestamp'],
                        'nickname'     => $message[$i]['nickname'],
                        'headimgurl'   => $message[$i]['headimgurl'],
                        'token'        => $jwt->createToken($jwt_data)
                    ];
            }
        }
        $data['chat'] = $chat;

        //查询评论,粉丝,点赞,分享列表是否已经查看
        $data['fens_is_show'] = 1;
        $data['prise_is_show'] = 1;
        $data['share_is_show'] = 1;
        $data['comment_is_show'] = 1;//6评论 7点赞视频 8关注 9分享 
        $fens_is_show = DB::table('yf_hf_task')->where(['member_id'=>$this->userId,'type'=>8,'is_show'=>0])->select();
        $prise_is_show = DB::table('yf_hf_task')->where(['member_id'=>$this->userId,'type'=>7,'is_show'=>0])->select();
        $share_is_show = DB::table('yf_hf_task')->where(['member_id'=>$this->userId,'type'=>9,'is_show'=>0])->select();
        $comment_is_show = DB::table('yf_hf_task')->where(['member_id'=>$this->userId,'type'=>6,'is_show'=>0])->select();
        if ($fens_is_show) {
            $data['fens_is_show'] = 0;
        }
        if ($prise_is_show) {
            $data['prise_is_show'] = 0;
        }
        if ($share_is_show) {
            $data['share_is_show'] = 0;
        }
        if ($comment_is_show) {
            $data['comment_is_show'] = 0;
        }
        
        $result['code']     = 200;
        $result['message']  = '查询成功';
        $result['data']     = $data;
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     * 任务消息列表
     * @param pageNo
     * @auther zyt
     */
    public function getTaskList ()
    {
        //1 发布视频获得奖励,已审核到账 2发布视频审核被拒绝 3邀请好友成功得奖励
// 4举报视频 50提现成功 51提现退回 52提现被拒绝
        $pageNo = empty($this->params['pageNo']) ? 1 : $this->params['pageNo'];
        //修改内容为已读
        $res = Db::table('yf_hf_task')->where('member_id',$this->userId)->whereIn('type',[1,11,2,21,22,3,4,50,51,52])->update(['is_show'=>1,'update_time'=>time()]);
        $data = Db::table('yf_hf_task')->where('member_id',$this->userId)->whereIn('type',[1,11,2,21,22,3,4,50,51,52])->order('create_time desc')->page($pageNo, 10)->select();
        $count = Db::table('yf_hf_task')->where('member_id',$this->userId)->whereIn('type',[1,11,2,21,22,3,4,50,51,52])->count();
        $total = ceil($count/10);
//        dump($account);
        if ($data) {
            for($i=0;$i<count($data);$i++){
                if ($data[$i]['type'] == 1) {
                    $data[$i]['content'] = '';
                }
                $account = Db::table('yf_hf_account_details')->where(['member_id'=>$data[$i]['member_id'],'status'=>1,'update_time'=>$data[$i]['create_time']])->value('money');
                //$money = Db::table('yf_hf_account_details')->where(['member_id'=>$data[$i]['member_id'],'status'=>1,'update_time'=>$data[$i]['create_time']])->value('money');

                switch ($data[$i]['type']) {
                    case 1:
                        $data[$i]['content'] = '你发布的视频已审核通过,恭喜你获得'.ceil($account).'个嗨币,嗨币可提现至支付宝!';
                        break;
                    case 11:
                        $data[$i]['content'] = '你发布的视频已审核通过,快邀好友来发视频,获得嗨币。';
                        break;
                    case 2:
                        $data[$i]['content'] = '你发布的视频审核未通过,请注意查看!';
                        break;
                    case 21:
                        $data[$i]['content'] = '你发布的视频不符合平台要求,已被管理员删除!';
                        break;
                    case 22:
                        $data[$i]['content'] = '你创建的小区,经过核实，已被拒绝通过，相关的视频也会被删除。';
                        break;
                    case 3:
                        $data[$i]['content'] = '你邀请的好友成功输入邀请码,你获得30嗨币奖励';
                        break;
                    case 4:
                        $data[$i]['content'] = '你举报的视频已审核通过';
                        break;
                    case 50:
                        $data[$i]['content'] = '你发起的'.$account.'提现已到账';
                        break;
                    case 51:
                        $data[$i]['content'] = '你发起的'.$account.'提现已退回';
                        break;
                    case 52:
                        $data[$i]['content'] = '你发起的'.$account.'提现申请已被拒绝';
                        break;
                    default:
                        break;
                }

            }
        }
        $result['code']    = 200;
        $result['message'] = '';
        $result['data']    = $data;
        $result['total']   = $total;
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }


    /**
     * 用户下线 post
     * @auther zyt
     * @time 2018/5/7 13:26
     */
    public function offline ()
    {
        $result['code'] = 101;
        $result['message'] = '';
        $member = $this->memberModel->where('id', $this->userId)->find();
        if (!$member) {
            $result['message'] = '该用户不存在';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        //修改该用户的为下线状态
        $data = $this->memberModel->where('id', $this->userId)->update(['status'=>'offline','logout_timestamp'=>time()]);
        if ($data) {
            $result['code'] = 200;
            $result['message'] = '该用户下线';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        } else {
            $result['message'] = '该用户下线失败,请重试';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
    }

    /**
     * 获取离线消息 post(不用)
     *
     *
     * @auther zyt
     * @time 2018/5/18
     */
    public static function offlineMsg ($app_key,$member_id,$userId)
    {
        $app = Db::table("yf_hf_chat_app")->where("app_key", $app_key)->find();
        if ($app) {
            // 自己的id
            $mine = $userId;
            $user = Db::table('yf_hf_member')->where('id', $mine)->find();
            //auther zyt time 218/5/18 11:06
            $logtime = 0;
            if ($user) {
                $logtime = $user['logout_timestamp'];
            }
            //auther zyt time 218/5/18 11:06
            $chatdata = [];
            /*if ($user) {
                $logtime = $user['logout_timestamp'];
                //$re = Db::table('yf_hf_member')->where('id', $mine)->update(['status' => 'online', 'logout_timestamp' => time()]);
            } else {
                $logtime = 0;
                $arr = [
                    "app_key" => $app_key,
                    "id" => $mine,
                    "logout_timestamp" => time(),
                    "status" => 'online'
                ];
                $re = Db::table("yf_hf_member")->insert($arr);
            }*/
            $data = Db::table('yf_hf_chat_message')->where(['from' => $member_id,'to' => $mine, 'type' => 'friend', 'app_key' => $app_key])->where('timestamp', '>', $logtime)->order('mid desc')->limit(20)->select();
            if ($data) {
                $res = array_reverse($data);
                foreach ($res as $value) {
                    $chatdata[] = $value['data'];
                }
            }
            return $chatdata;
        }
    }

    /**
     * 分享的链接私信给用户聊天框
     *
     * @auther zyt
     * @time 2018/6/4 20:29
     */
    public function shareToChat ()
    {
        $result['code']    = 101;
        $result['message'] = '';

        $member_id = $this->params['member_id'];
        $link = $this->params['link'];
        if (empty($member_id) || empty($link)) {
            $result['message'] = '请传入要私信的对象或者视频链接';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        $member = Db::table('yf_hf_member')->where('id',$member_id)->find();
        if (!$member) {
            $result['message'] = '该用户不存在';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }

        $res = Db::table('yf_hf_member')->where('id',$this->userId)->find();

        $post["username"] = htmlspecialchars($res['nickname']);
        $post["avatar"]   = htmlspecialchars($res['headimgurl']);
        $post['content']  = $link;
        $post['fromid']   = $this->userId;
        $post['type']     = 'friend';
        $post['toid']     = $member_id;
        $post["mine"]     = false;
        $post['timestamp']= microtime(true)* 1000;
        $post['id']       = $this->userId;
        $post['appkey']   = 'b054014693241bcd9c20';
        $data = json_encode($post);
        //转码问题 qin 2018-06-24
        $data=str_replace("\\",'\\\\',$data);

        $post1["username"] = htmlspecialchars($res['nickname']);
        $post1["avatar"]   = htmlspecialchars($res['headimgurl']);
        $post1['content']  = $link;
        $post1['fromid']   = $member_id;
        $post1['type']     = 'friend';
        $post1['toid']     = $this->userId;
        $post1["mine"]     = false;
        $post1['timestamp']= microtime(true)* 1000;
        $post1['id']       = $member_id;
        $post1['appkey']   = 'b054014693241bcd9c20';
        $data1 = json_encode($post1);
        //转码问题 qin 2018-06-24
        $data1=str_replace("\\",'\\\\',$data1);
        $arr = [[
            'id'          => 0,
            "app_key"     => $post['appkey'],
            "from"        => $this->userId,
            "to"          => $member_id,
            "data"        => $data,
            "type"        => 'friend',
            "timestamp"   => time()
        ],[
            'id'          => 0,
            "app_key"     => $post['appkey'],
            "from"        => $member_id,
            "to"          => $this->userId,
            "data"        => $data1,
            "type"        => 'friend',
            "timestamp"   => time()
        ]];
        Log::info("===============shareToChat========");
        Log::info($arr);
        $message1 = Member::table("yf_hf_chat_message")->insert($arr[0]);
        $message = Member::table("yf_hf_chat_message")->insert($arr[1]);
        if ($message) {
            //判断接收消息的用户是否在线,不在线推送消息
            $is_online = Db::table('yf_hf_member')->where('id',$member_id)->value('status');
            //查询接收消息的用户device_id
            $device_id = Db::table('yf_hf_device')->where('member_id',$member_id)->value('device_id');
            $nickname = Db::table('yf_hf_member')->where('id',$this->userId)->value('nickname');
            if ($is_online == 'offline') {
                $ge_tui = new GeTuiUntils();
                $content = $nickname.'给你发了私信,请及时查看';
                $rem = $ge_tui->public_push_message_for_one($this->userId,$device_id,'消息',$content,$type=11);
                //推送记录存入task表
                $arr = [
                    'id'           => 0,
                    'member_id'    => $member_id,
                    'content'      => $content,
                    'type'         => 10,
                    'is_show'      => 0,
                    'create_time'  => time(),
                    'update_time'  => time()
                ];
                Db::table('yf_hf_task')->insert($arr);
            }

            $result['code']  = 200;
            $result['message'] = '私信成功';
        } else {
            $result['message'] = '私信失败';
        }

        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     * 消息图标显示小红点
     * @auther zyt
     * @time 2018/6/14
     */
    public function redDot () {
        $result['code']    = '101';
        $result['message'] = '';
        $res = Db::table('yf_hf_task')->where(['member_id'=>$this->userId,'is_show'=>0])->select();
        if ($res) {
            $result['code']    = 200;
            $result['message'] = '操作成功,有未读消息';
            $result['data']    = '0';
        } else {
            $result['code']    = 200;
            $result['message'] = '操作成功,无未读消息';
            $result['data']    = '1';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     * 客服聊天
     * @auther zyt
     * @time 2018/6/26
     */
    public function kefuChat () {
        $result['code']    = 101;
        $result['message'] = '';
        //本人信息
        $authToken = $this->params['authToken'];
        $info = $this->memberModel->where('id',$this->userId)->find();
        if ($info['unionid']) {
            $info['headimgurl'] = $info['headimgurl'];
        } else {
            $info['headimgurl'] = Tool::getDomain().$info['headimgurl'];
        }
        $info['headimgurl'] = str_replace('http://','https://',$info['headimgurl']);
        //客服信息
        $token = $this->params['token'];
        $jwt = new JwtUntils();
        $data = $jwt->getDecode($token);
        $other = $this->memberModel->where('id',$data['data']['id'])->find();
        $other['headimgurl'] = str_replace('http://','https://',$other['headimgurl']);
        
        return view('chat2.html',['info'=>$info, 'other'=>$other, 'authToken'=>$authToken]);
    }

    /**
     * 卸载APP清空聊天记录
     * @auther zyt
     * @time 2018/7/9
     */
    public function trashChatMessage(){
        $result['code']    = 101;
        $result['message'] = '';

        //查询聊天记录
        $chatMessage = Db::table('yf_hf_chat_message')->where('from',$this->userId)->whereOr('to',$this->userId)->select();
        if ($chatMessage) {
            //清空聊天数据
            $deleteChatMessage = Db::table('yf_hf_chat_message')->where('from',$this->userId)->whereOr('to',$this->userId)->delete();
            if($deleteChatMessage){
                $result['code']    = 200;
                $result['message'] = '清空聊天记录成功!';
            } else {
                $result['message'] = '清空聊天记录失败!';
            }
        } else {
            $result['code']    = 200;
            $result['message'] = '暂无数据!';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     * 左滑删除记录
     * @auther zyt
     * @time 2018/7/9
     */
    public function deleteChat(){
        $result['code']    = 101;
        $result['message'] = '';
        $member_id = $this->params['member_id'];
        if (empty($member_id)) {
            $result['message'] = '请传入参数';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //查询聊天记录
        $chatMessage = Db::table('yf_hf_chat_message')->where(['from'=>$this->userId,'to'=>$member_id])->whereOr(['to'=>$this->userId,'from'=>$member_id])->select();
        if ($chatMessage) {
            $delete = Db::table('yf_hf_chat_message')->where(['from'=>$this->userId,'to'=>$member_id])->whereOr(['to'=>$this->userId,'from'=>$member_id])->delete();
            if ($delete) {
                $result['code']    = 200;
                $result['message'] = '删除成功!';
            } else {
                $result['message'] = '删除失败!';
            }
        } else {
            $result['code']    = 200;
            $result['message'] = '暂无数据,无需删除!';
        }

        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

}