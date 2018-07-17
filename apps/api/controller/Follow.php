<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/12
 * Time: 16:20
 */

namespace app\api\controller;

use app\api\untils\GeTuiUntils;
use app\common\model\Member;
use app\common\model\Video;
use app\common\untils\JwtUntils;
use app\common\model\Follow as FollowModel;
use Firebase\JWT\JWT;
use think\Db;
use think\Log;
use think\Request;
use app\api\controller\Basic;

/**
 * Class Follow
 * @package app\api\controller
 */
class Follow extends Basic
{
    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->followModel = new FollowModel();
        $this->videoModel = new Video();
        $this->memberModel = new Member();
    }

    /**
     * 加关注和取消关注post
     * @params followed_id 被关注id
     * @params type 关注类型 0关注人 1关注小区 2关注视频,点赞视频 3点赞别人的评论
     * @author zyt
     */
    public function addOrUpdateFollow (Request $req)
    {
        header("Access-Control-Allow-Origin: *");
        $followed_id = $this->params['followed_id'];
        $type = $this->params['type'];
        $userId = $this->userId;
        //Log::write("=======addOrUpdateFollow========");
        $result['code']    = 101;
        $result['message'] = '';
        if (empty($followed_id)) {
            //Log::write("=======addOrUpdateFollow11========");
            $result['message'] = '请传入需要关注的id';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        if (!isset($type)) {
            //Log::write("=======addOrUpdateFollow12========");
            $result['message'] = '请传入关注类型';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        if ($type != 0 && $type != 1 && $type != 2 && $type != 3) {
            //Log::write("=======addOrUpdateFollow13========");
            $result['message'] = '传入的关注类型状态异常:' . $type;
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        if ($followed_id == $userId) {
            //Log::write("=======addOrUpdateFollow14========");
            $result['message'] = '自己不可以关注自己';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        
        $data = $this->followModel->addOrUpdateFollow($userId, $followed_id, $type);
        //Log::write("=======addOrUpdateFollow2========");
        Log::write($data);
        $is_followed = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>$type])->value('is_followed');
        //Log::write("=======addOrUpdateFollow3========");
        Log::write($is_followed);
        if (count($data['data']) > 0) {
            //Log::write("=======addOrUpdateFollow4========");
            $result['code']     = 200;
            $result['message']  = '操作成功';
            $result['data']  = $is_followed;
        } else {
            //Log::write("=======addOrUpdateFollow5========");
            $result['code'] = $data['code'];
            $result['message']  = $data['msg'];
        }
        //推送消息
        if ($type == 0) { //关注或者取消关注人
            //Log::write("=======addOrUpdateFollow6========");
            if ($is_followed == 1) {
                //Log::write("=======addOrUpdateFollow7========");
                $getui = new Getui();
                $res = $getui->pushMessage($type=8,$this->userId,$followed_id);
            }
        } elseif ($type == 2) { //关注并点赞视频
            //Log::write("=======addOrUpdateFollow8========");
            if ($is_followed == 1) {
                //Log::write("=======addOrUpdateFollow9========");
                $getui = new Getui();
                //发布视频的用户id
                $id = Db::table('yf_hf_video')->where('id',$followed_id)->value('member_id');
                $res = $getui->pushMessage($type=7,$this->userId,$id);
            }
        }

        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 我/他关注的小区或人列表get
     * @params pageNo 页码
     * @params pageSize 每页显示条数
     * @params type 关注类型 0关注人 1关注小区
     * @author zyt
     */
    public function getFollowList(Request $req)
    {
        header("Access-Control-Allow-Origin: *");
        $result['code']    = 101;
        $result['message'] = '';

        $type = $req->get('type');
        if (!isset($type)) {
            $result['message'] = '请传入关注类型';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        if ($type != 0 && $type != 1) {
            $result['message'] = '传入关注类型状态异常:' . $type;
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        $member_id = $req->get('member_id');
        if (empty($member_id)) {
            $member_id = $this->userId;
        }

        $pageNo = empty($req->get('pageNo')) ? 1 : $req->get('pageNo');
        //查询我的小区或者人列表
        $data = $this->followModel->getFollowList($member_id, $type, $pageNo);
        if ($type == 0) {
            for ($i=0;$i<count($data['list']);$i++) {
                $phone = Db::table('yf_hf_member')->where('id',$data['list'][$i]['followed_id'])->value('phone');
                $jwt = new JwtUntils();
                $jwt_data['phone'] = $phone;
                $jwt_data['id'] = $data['list'][$i]['followed_id'];
                //$jwt_data['timeStamp_'] = time();
                $data['list'][$i]['token']  = $jwt->createToken($jwt_data);
            }
        }
        if (count($data['list']) > 0) {
            $result['data']    = $data;
            $result['code']    = 200;
            $result['message'] = '查询成功';
        } else {
            $result['code']    = 200;
            $result['message'] = '未查询到信息';
        }
        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 关注该小区的人列表get
     * @params building_id 小区id
     * @params pageNo 页码
     * @params authToken
     * @author zyt
     */
    public function getListByBuildingId()
    {
        header("Access-Control-Allow-Origin: *");
        $result['code']    = 101;
        $result['message'] = '';

        $building_id = $this->params['building_id'];
        if (empty($building_id)) {
            $result['message'] = '请传入小区id';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        $pageNo = empty($this->params['pageNo']) ? 1 : $this->params['pageNo'];
        //关注该小区的人列表
        $data = $this->followModel->getListByBuildingId($this->userId,$building_id,$pageNo);
        if (count($data['list']) > 0) {
            $result['data']    = $data;
            $result['code']    = 200;
            $result['message'] = '查询成功';
        } else {
            $result['code']    = 200;
            $result['message'] = '未查询到信息';
        }
        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 他的/我的粉丝列表get
     * @params member_id 用户id
     * @params type 类型 (查询他的粉丝或关注的人时用到,用于区别粉丝和关注的人 0 关注的人 1粉丝)
     * @params pageNo 页码
     * @params pageSize 每页显示条数
     * @author zyt
     */
    public function getMyFens (Request $req)
    {
        header("Access-Control-Allow-Origin: *");
        $result['code']    = 101;
        $result['message'] = '';

        $pageNo = empty($req->get('pageNo')) ? 1 : $req->get('pageNo');
        if (!empty($this->params['member_id'])) {
            $member_id = $this->params['member_id'];
        } else {
            $member_id = '';
        }
        if (empty($member_id)) {
            $member_id = $this->userId;
            //查询我的粉丝列表
            //$data = $this->followModel->getMyFens($member_id, $this->userId, $pageNo, $pageSize = 10);
            $pageSize = 10;
            $limit = " LIMIT ".($pageNo-1)*$pageSize.",".$pageSize;
            $sql = "SELECT `f`.`id`,`f`.`member_id`,`f`.`followed_id`,`f`.`type`,`f`.`black`,`f`.`is_followed`,`f`.`update_time`,`m`.`nickname`,`m`.`headimgurl`,`m`.`unionid`,`m`.`is_robot`,`m`.`hiid`,`m`.`label`,`m`.`sign`,`l`.`label_name` FROM `yf_hf_follow` `f` LEFT JOIN `yf_hf_member` `m` ON `m`.`id`=`f`.`member_id` LEFT JOIN `yf_hf_label` `l` ON `l`.`id`=`m`.`label` WHERE `followed_id` = ".$member_id." AND `type` = 0 AND `is_followed` = 1 ORDER BY f.update_time desc";
            $sql1 = $sql . $limit;
            $data1 = Db::query($sql);
            $list = Db::query($sql1);
            $count = count($data1);
            $data['total'] = ceil($count/$pageSize);
            //查询我关注的人
            $res = Db::table('yf_hf_follow')->where(['member_id'=>$member_id, 'type'=>0, 'is_followed'=>1])->select();
            // 添加status 0 未关注 1 已关注
            $lists = [];
            if (count($list) > 0) {
                for ($i=0;$i<count($list);$i++) {
                    //获取头像地址
                    if ($list[$i]['unionid'] || $list[$i]['is_robot']!=0){
                        $headimgurl = $list[$i]['headimgurl'];
                        $list[$i]['headimgurl'] = str_replace('http://','https://',$headimgurl);
                    }else{
                        $list[$i]['headimgurl'] = Tool::getDomain().$list[$i]['headimgurl'];
                    }
                    $list[$i]['status'] = 0;
                    if (count($res) > 0) {
                        for ($j=0;$j<count($res);$j++) {
                            if ($list[$i]['member_id'] == $res[$j]['followed_id']) {
                                $list[$i]['status'] = 1;
                            }
                        }
                    }
                }
            }
            $data['list'] = $list;
            //更新task表中未读改为已读
            Db::table('yf_hf_task')->where(['member_id'=>$member_id,'type'=>8,'is_show'=>0])->update(['is_show'=>1]);
        } else {
            if ($this->params['type'] == 0) {
                //查询他关注的人列表
                $data = $this->followModel->getOtherFollowList($member_id, $this->userId, $pageNo, $pageSize = 10);
            } elseif ($this->params['type'] == 1) {
                //查询他的粉丝列表
                $data = $this->followModel->getMyFens($member_id, $this->userId, $pageNo, $pageSize = 10);
            }
        }
        if (count($data['list']) > 0) {
            $result['data']     = $data;
            $result['code']     = 200;
            $result['message']  = '查询成功';
        } else {
            $result['code']     = 200;
            $result['message']  = '未查询到信息';
        }

        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 作者主页点赞视频列表 + 点赞列表(我赞过的)get
     * @params member_id 用户id
     * @params pageNo 页码
     * @author zyt
     */
    public function getFollowListByMemberId ()
    {
        header("Access-Control-Allow-Origin: *");
        $result['code']    = 101;
        $result['message'] = '';

        $pageNo = empty($this->params['pageNo']) ? 1 : $this->params['pageNo'];
        $member_id = $this->params['member_id'];
        if (empty($member_id)) {
            $member_id = $this->userId;
        }

        $data = $this->followModel->getFollowListByMemberId($member_id, $pageNo, $pageSize = 10);
        if (count($data) > 0) {
            $result['code']    = 200;
            $result['message'] = '查询成功';
            $result['data']    = $data;
        } else {
            $result['code']    = 200;
            $result['message'] = '未查询出数据';
        }
        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 拉黑post
     * @param followed_id 被拉黑对象id
     * @param user_id  token传userId
     * @author zyt
     */
    public function addBlack ()
    {
        $result['code']    = 101;
        $result['message'] = '';

        $followed_id = $this->params['followed_id'];
        $userId = $this->userId;
        if ($userId == $followed_id) {
            $result['message'] = '自己不能拉黑自己';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //查询是否已经拉黑该用户
        $res = $this->followModel->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>0])->find();
        if ($res) {
            if ($res['black'] == 1) {  //取消拉黑,修改black状态为0
                $black = $this->followModel->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>0])->update(['black'=>0,'update_time'=>time()]);
            } else {  //判断是否关注 若关注则取消关注 //拉黑,修改black状态为1
                if ($res['is_followed'] == 1) {
                    $black = $this->followModel->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>0])->update(['is_followed'=>0,'black'=>1,'update_time'=>time()]);
                } else {
                    $black = $this->followModel->where(['member_id' => $userId, 'followed_id' => $followed_id, 'type' => 0])->update(['black'=>1, 'update_time'=>time()]);
                }
            }
        } else {
            $data             = [
                'id'          => 0,
                'member_id'   => $userId,
                'followed_id' => $followed_id,
                'type'        => 0,
                'black'       => 1,
                'create_time' => time(),
                'update_time' => time()
            ];
            $black = $this->followModel->save($data);
        }
        $ret = $this->followModel->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>0])->find();

        if ($black) {
            $result['code']    = 200;
            $result['message'] = '操作成功';
            $result['data']    = $ret['black'];
        } else {
            $result['message'] = '操作失败';
        }
        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 消息--获赞
     * @param pageNo 页码
     * @auther zyt
     */
    public function getUpvodeList ()
    {
        $result['code']    = 101;
        $result['message'] = '';
        $pageNo = $this->params['pageNo'];
        //查询是否发布过视频
        $video = $this->videoModel->where('member_id',$this->userId)->select();
        if ($video) {
            //查询是否有人点赞过我的视频
            $ids = [];
            for ($i=0;$i<count($video);$i++) {
                $ids[] = $video[$i]['id'];
            }
            //$follow = $this->followModel->getUpvodeList($ids, $pageNo);
            $where = ['type'=>2,'is_followed'=>1];
            $field = 'f.id,f.member_id,f.followed_id as video_id,f.type,f.is_followed,f.update_time,v.title,v.video_link,v.video_cover,v.is_delete,m.nickname,m.headimgurl,m.unionid,m.is_robot';
            $follow = Db::table('yf_hf_follow')->alias('f')
                ->join('yf_hf_member m', 'm.id=f.member_id', 'left')
                ->join('yf_hf_video v', 'v.id=f.followed_id', 'left')
                ->field($field)
                ->where($where)->whereIn('followed_id',$ids)->order('f.create_time desc')->page($pageNo,10)->select();
            $count = Db::table('yf_hf_follow')->where($where)->whereIn('followed_id',$ids)->count();
            $total = ceil($count/10);
            if ($follow) {
                for ($i=0;$i<count($follow);$i++) {
                    if ($follow[$i]['unionid'] || $follow[$i]['is_robot']!=0) {
                        $follow[$i]['headimgurl'] = $follow[$i]['headimgurl'];
                    } else {
                        $follow[$i]['headimgurl'] = Tool::getDomain() . $follow[$i]['headimgurl'];
                    }
                }
            }
            $data['list'] = $follow;
            $data['total'] = $total;

            //更新task表中未读改为已读
            Db::table('yf_hf_task')->where(['member_id'=>$this->userId,'type'=>7,'is_show'=>0])->update(['is_show'=>1]);
            if (count($data['list']) > 0) {
                $result['code']    = 200;
                $result['message'] = '查询数据成功';
                $result['data']    = $data;
            } else {
                $result['code']    = 200;
                $result['message'] = '查询数据为空';
            }
        } else {
            $result['code']    = 200;
            $result['message'] = '您暂时还未发布过视频,没有获赞数据';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }
}