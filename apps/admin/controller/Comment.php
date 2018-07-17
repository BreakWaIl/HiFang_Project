<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/20
 * Time: 11:32
 */
namespace app\admin\controller;

use app\admin\controller\Admin;
use app\common\model\Comment as CommentModel;
use think\Db;

/**
 * Class Comment
 * @package app\admin\controller
 */
class Comment extends Admin{
    function _initialize()
    {
        parent::_initialize();

        $this->commentModel = model('common/Comment');
    }

    /**
     * 评论列表
     * @return [type] [description]
     * @date   2018-04-20
     * @author zyt
     */
    public function index(){
        // 获取所有用户
        $info = Db::table('yf_hf_comment')->alias('c')
            ->join('yf_hf_member m', 'm.id=c.member_id', 'left')
            ->field('c.id,c.member_id,c.video_id,c.parent_id,c.content,c.create_time,c.update_time,m.nickname,m.phone')->select();
        $this->assign('info',$info);
        return view('index');
    }

    /**
     * 筛选评论列表
     * by zyt
     */
    public function search(){
        $nickname = $_POST['nickname'];
        $phone = $_POST['phone'];
        $id = $_POST['id'];
        $video_id = $_POST['video_id'];
        $start_time = strtotime($_POST['start']);
        $stop_time = strtotime($_POST['stop']) + 86400;
        $query = Db::table('yf_hf_comment')->alias('c')
            ->join('yf_hf_member m', 'm.id=c.member_id', 'left')
            ->field('c.id,c.member_id,c.video_id,c.parent_id,c.content,c.create_time,c.update_time,m.nickname,m.phone');

        if ($nickname) {
            $query = $query->where('m.nickname','like',"%$nickname%");
        }
        if ($phone) {
            $query = $query->where('m.phone','like',"%$phone%");
        }
        if ($start_time && $stop_time) {
            $query = $query->where('c.create_time','>',$start_time)->where('c.create_time','<',$stop_time);
        }
        if ($id) {
            $query = $query->where('c.id','like',"%$id%");
        }
        if ($video_id) {
            $query = $query->where('c.video_id','like',"%$video_id%");
        }
        $info = $query->select();

        $this->assign('id',$id);
        $this->assign('start_time',$_POST['start']);
        $this->assign('stop_time',$_POST['stop']);
        $this->assign('nickname',$_POST['nickname']);
        $this->assign('id',$_POST['id']);
        $this->assign('video_id',$_POST['video_id']);
        $this->assign('phone',$phone);
        $this->assign('info',$info);
        return view('index');
    }

    /**删除评论
     * @param string $id
     * @return mixed
     * @auther zyt
     */
    public function delete($id=0){
        if (empty($id)) {
            $this->error("非法操作!", '');
        }

        $comment = model('comment')->where('id',$id)->find();
        if ($comment) {
            $result = model('comment')->where('id',$id)->delete();
            $res = model('video')->where('id',$comment['video_id'])->setDec('num_comment');
            if($result){
                $this->success('删除成功',url('index'));
            } else {
                $this->error('删除失败',url('index'));
            }
        } else {
            $this->error('该数据不存在,请重试');
        }
    }

}