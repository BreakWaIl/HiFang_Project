<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/19
 * Time: 13:07
 */
namespace app\api\controller;

use app\common\model\Comment as CommentModel;
use app\common\model\Follow;
use app\common\model\Member;
use app\common\model\Video;
use app\api\untils\GeTuiUntils;
use think\Db;
use think\Request;
use app\api\controller\Basic;

class Comment extends Basic
{
    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->commentModel = new CommentModel();
        $this->followModel = new Follow();
        $this->videoModel = new Video();
    }
    /**添加评论 post
     * @param content 评论内容
     * @param video_id 视频id
     * @param parent_id  上个评论id
     * @author zyt
     */
    public function addComment ()
    {
        $content = $this->params['content'];
        $video_id = $this->params['video_id'];
        $parent_id = $this->params['parent_id'];
        if (empty($parent_id)) {
            $parent_id = 0;
        }
        $result['code']    = 101;
        $result['message'] = '';
        if (empty($content)) {
            $result['message'] = '请输入内容';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        if (!isset($video_id)) {
            $result['message'] = '请传入需要评论的视频id';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        //查询发布视频是否存在
        $video = Db::table('yf_hf_video')->where('id',$video_id)->find();
        if (!$video) {
            $result['message'] = '您评论的视频信息不存在';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        if ($video['is_delete']==1) {
            $result['message'] = '您评论的视频已被删除,无法评论';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }
        //查询是否有评论权限(被拉黑不可以评论)
        $black = $this->followModel->where(['member_id'=>$video['member_id'],'followed_id'=>$this->userId,'type'=>0])->value('black');
        if ($black == 1) {
            $result['message'] = '您已被该视频作者拉黑,无法评论该视频';
            return json_encode($result,JSON_UNESCAPED_UNICODE);
        }

        $data = $this->commentModel->addComment($this->userId, $content, $video_id, $parent_id);
        if ($data['data']) {
            $result['code'] = 200;
            $result['message'] = $data['message'];
            //推送信息
            $ge_tui = new GeTuiUntils();
            //查询评论人信息
            $member = new Member();
            $nickname = $member->where('id',$this->userId)->value('nickname');

            //获取device_id content
            if ($parent_id != 0) {
                //$content = $nickname.'回复了您的视频:'.$content;
                if ($this->userId == $video['member_id']) {
                    $content = $nickname.'回复了您的评论:'.$content;
                    //发布视频者回复A
                    $comment = Db::table('yf_hf_comment')->where('id',$parent_id)->find();
                    if ($comment) {
                        $device_id = DB::table('yf_hf_device')->where('member_id',$comment['member_id'])->value('device_id');
                        $ge_tui->public_push_message_for_one($this->userId,$device_id,'评论',$content,$type=6);
                        //推送记录存入task表
                        $data = [
                            'id'           => 0,
                            'member_id'    => $comment['member_id'],
                            'content'      => $content,
                            'type'         => 6,
                            'is_show'      => 0,
                            'create_time'  => time(),
                            'update_time'  => time()
                        ];
                        $res = Db::table('yf_hf_task')->insert($data);
                    }
                } else {
                    //B回复A
                    //给A推送
                    $comment = Db::table('yf_hf_comment')->where('id',$parent_id)->find();
                    if ($comment) {
                        $device_id = DB::table('yf_hf_device')->where('member_id',$comment['member_id'])->value('device_id');
                        if (count($comment) > 1) {
                            $content1 = $nickname.'回复了您:'.$content;
                        } else {
                            $content1 = $nickname.'评论了您:'.$content;
                        }
                        $ge_tui->public_push_message_for_one($this->userId,$device_id,'评论',$content1,$type=6);
                        //推送记录存入task表
                        $data = [
                            'id'           => 0,
                            'member_id'    => $comment['member_id'],
                            'content'      => $content1,
                            'type'         => 6,
                            'is_show'      => 0,
                            'create_time'  => time(),
                            'update_time'  => time()
                        ];
                        $res = Db::table('yf_hf_task')->insert($data);
                    }
                    //给视频者推送
                    $video = $this->videoModel->where('id',$video_id)->find();
                    $a_device_id = Db::table('yf_hf_device')->where('member_id',$video['member_id'])->value('device_id');
                    $a_nickname = Db::table('yf_hf_member')->where('id',$comment['member_id'])->value('nickname');
                    $content2 = $nickname.'回复了'.$a_nickname.'的评论:'.$content;
                    $ge_tui->public_push_message_for_one($this->userId,$a_device_id,'评论',$content2,$type=6);
                    //推送记录存入task表
                    $data = [
                        'id'           => 0,
                        'member_id'    => $comment['member_id'],
                        'content'      => $content2,
                        'type'         => 6,
                        'is_show'      => 0,
                        'create_time'  => time(),
                        'update_time'  => time()
                    ];
                    $res = Db::table('yf_hf_task')->insert($data);
                }
            } else {
                if ($this->userId != $video['member_id']) {
                    //A评论作者视频
                    $content = $nickname.'评论了您的视频:'.$content;
                    //被评论人的device_id
                    $video = $this->videoModel->where('id',$video_id)->find();
                    $device_id = DB::table('yf_hf_device')->where('member_id',$video['member_id'])->value('device_id');
                    $ge_tui->public_push_message_for_one($this->userId,$device_id,'评论',$content,$type=6);
                    //推送记录存入task表
                    $data = [
                        'id'           => 0,
                        'member_id'    => $video['member_id'],
                        'content'      => $content,
                        'type'         => 6,
                        'is_show'      => 0,
                        'create_time'  => time(),
                        'update_time'  => time()
                    ];
                    $res = Db::table('yf_hf_task')->insert($data);
                }
            }
        } else {
            $result['message'] = $data['message'];
        }

        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**删除评论post
     * @param comment_id 评论id
     * @author zyt
     */
    public function deleteComment ()
    {
        $comment_id = $this->params['comment_id'];

        $result['code'] = 101;
        $result['message'] = '';
        if (empty($comment_id)) {
            $result['message'] = '请传入要删除的id';
            return json_encode($result,JSONU_NESCAPED_UNICODE);
        }
        $data = $this->commentModel->deleteComment($this->userId,$comment_id);
        if ($data['data']) {
            $result['code']    = 200;
            $result['message'] = $data['message'];
        } else {
            $result['message'] = $data['message'];
        }
        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**视频的评论列表
     * @param video_id 视频id
     * @param pageNo 页码
     * @param pageSize 每页显示条数
     * @author zyt
     */
    public function getCommentList ()
    {
        $video_id = $this->params['video_id'];

        $pageNo = empty($this->params['pageNo']) ? 1 : $this->params['pageNo'];
        $result['code'] = 101;
        $result['message'] = '';
        if (empty($video_id)) {
            $result['message'] = '请求视频id为空';
            return json_encode($result,JSONU_NESCAPED_UNICODE);
        }
        $comment = $this->commentModel->getCommentList($this->userId,$video_id,$pageNo,$pageSize=10);

        if (count($comment['list']) > 0) {
            for ($i=0;$i<count($comment['list']);$i++) {
                $comment['list'][$i]['status'] = 0;
                $follow = Db::table('yf_hf_follow')->where(['member_id'=>$this->userId,'type'=>3,'is_followed'=>1,'followed_id'=>$comment['list'][$i]['id']])->select();
                if (count($follow) > 0) {
                    $comment['list'][$i]['status'] = 1;
                }
            }

            $result['code'] = 200;
            $result['message'] = '查询成功';
            $result['data'] = $comment;
        } else {
            $result['code'] = 200;
            $result['message'] = '未查询到评论信息';
        }
        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 消息--评论列表
     * @param pageNo 页码
     * @auther zyt
     */
    public function getCommentLists ()
    {
        $result['code']    = 101;
        $result['message'] = '';
        $pageNo = $this->params['pageNo'];
        
        //查询是否发布过视频
        //查询是否有人评论过我发布的视频以及别人回复我的评论
        $comment = $this->commentModel->getCommentLists($this->userId,$pageNo);
        //更新task表中未读改为已读
        Db::table('yf_hf_task')->where(['member_id'=>$this->userId,'type'=>6,'is_show'=>0])->update(['is_show'=>1]);
        if (count($comment['list']) > 0) {
            $result['code']    = 200;
            $result['message'] = '查询数据成功';
            $result['data']    = $comment;
        } else {
            $result['code']    = 200;
            $result['message'] = '查询数据为空';
        }
        //$video = $this->videoModel->where('member_id',$this->userId)->select();
        /*if ($video) {
            //查询是否有人评论过我发布的视频以及别人回复我的评论
            $comment = $this->commentModel->getCommentLists($this->userId,$pageNo);
            if (count($comment['list']) > 0) {
                $result['code']    = 200;
                $result['message'] = '查询数据成功';
                $result['data']    = $comment;
            } else {
                $result['code']    = 200;
                $result['message'] = '查询数据为空';
            }
        } else {
            $result['code']    = 200;
            $result['message'] = '您还未发布过视频,没有评论数据';
        }*/
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }
}