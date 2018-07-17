<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/19
 * Time: 13:34
 */

namespace app\common\model;

use app\api\controller\Tool;
use think\Model;
use think\Db;

class Comment extends Base
{
    // 设置当前模型对应的完整数据表名称
    protected $table = 'yf_hf_comment';

    /**
     * 添加评论
     * @param $userId
     * @param $content
     * @param $video_id
     * @param $parent_id
     * @auther zyt
     */
    public function addComment($userId, $content, $video_id, $parent_id)
    {
        DB::startTrans();
        $data = array();
        try {
            //查询发布视频是否存在
            $video = Db::table('yf_hf_video')->where('id',$video_id)->find();
            $comment = $this->save([
                'id'          => 0,
                'member_id'     => $userId,
                'content'       => $content,
                'video_id'      => $video_id,
                'user_id'       => $video['member_id'],
                'parent_id'     => $parent_id,
                'create_time'   => time(),
                'update_time'   => time(),
            ]);
            if (!$comment) {
                Db::rollback();
                return ["code" => "101", 'message'=>'评论失败，请重试', "data"=>$data];
            }
            //修改视频表评论数
            $num_comment = $video['num_comment'] + 1;
            $update = Db::table('yf_hf_video')->where('id',$video_id)->update(['num_comment'=>$num_comment]);
            if (!$update) {
                Db::rollback();
                return ["code" => "101", 'message'=>'数据异常,更新视频评论数失败', "data"=>$data];
            }
            DB::commit();
            return ["code" => "200", 'message'=>'添加评论成功', "data"=>$update];
        } catch (\Exception $e) {
            DB::rollback();
            return [ "code" => "101", "message" => "失败，数据异常", "data"=>$data ];
        }

    }

    /**删除评论
     * @param $userId
     * @param $comment_id
     * @return array
     * @auther zyt
     */
    public function deleteComment($userId,$comment_id)
    {
        DB::startTrans();
        $data = array();
        $comment = $this->where(['id'=>$comment_id,'member_id'=>$userId])->find();
        if (!$comment) {
            return ['code'=>101, 'message'=>'该条评论信息不存在,请重试', 'data'=>$data];
            exit;
        }
        try {
            //删除主评论,可删除(用户只能删除自己的评论,别人的评论删除不了)
            $deleteComment = $this->where(['id'=>$comment_id,'member_id'=>$userId])->delete();
            if (!$deleteComment) {
                DB::rollback();
                return ['code'=>101, 'message'=>'删除失败,请重试', 'data'=>$data];
            }
            //修改视频表评论数量
            $num_comment = Db::table('yf_hf_video')->where('id',$comment['video_id'])->value('num_comment');
            $num_comment = ($num_comment - 1) < 0 ? 0 : ($num_comment - 1);
            $updateNum = Db::table('yf_hf_video')->where('id',$comment['video_id'])->update(['num_comment'=>$num_comment,'update_time'=>time()]);
            if (!$updateNum) {
                DB::rollback();
                return ['code'=>101, 'message'=>'评论数量更新失败,请重试', 'data'=>$data];
            }
            //判断comment_id是否有分评论,若有,也删除分评论,可删除(用户只能删除自己的评论,别人的评论删除不了)
            $comments = $this->where('parent_id',$comment_id)->select();
            if ($comments) {
                $delete = $this->where('parent_id',$comment_id)->delete();
                if (!$delete) {
                    DB::rollback();
                    return ['code'=>101, 'message'=>'操作失败,数据异常', 'data'=>$data];
                }
                //修改视频表评论数量
                $num_comment = ($num_comment - count($comments)) < 0 ? 0 : ($num_comment - count($comments));
                $update = Db::table('yf_hf_video')->where('id',$comment['video_id'])->update(['num_comment'=>$num_comment]);
                if (!$update) {
                    DB::rollback();
                    return ['code'=>101, 'message'=>'评论数量更新失败,请重试', 'data'=>$data];
                }
            }
            DB::commit();
            return ['code'=>200, 'message'=>'删除视频成功', 'data'=>1];
        } catch (\Exception $e) {
            DB::rollback();
            return ['code'=>101, 'message'=>'操作失败,数据异常', 'data'=>$data];
        }

    }



    /**
     *  后台获取评论列表
     * @param array $map
     * @param bool|true $field
     * @param string $order
     * @param null $page_size
     * @return array
     * @author zyt
     */
    public function getCommentListByPage($fields='title',$map,$field=true,$order='create_time desc',$page_size=null)
    {
        $paged     = input('param.paged',1);//分页值
        if (!$page_size) {
            $page_size = config('admin_page_size');
        }
        $page_size = input('param.page_size',$page_size);//每页数量
        $order     = input('param.order',$order);
        $field = 'c.*,m.nickname,m.phone';
        $query = $this->alias('c')
                ->join('yf_hf_member m', 'm.id = c.member_id', 'left')
                ->field($field);
        $rule = '%[KEYWORD]%';
        if (strpos($rule, '[KEYWORD]')!==false) {
            $keyword     = input('param.keyword',false);//关键字
            if (!empty($keyword)) {
                $rule = str_replace('[KEYWORD]', $keyword, $rule);
                $query = $query->where($fields,'like',$rule);
            }
        }
        $list = $query->where($map)->order('c.'.$order)->page($paged,$page_size)->select();
        $total     = $this->where($map)->count();
        return [$list,$total];
    }

    /**接口获取评论列表
     * @param $video_id
     * @param $pageNo
     * @param int $pageSize
     */
    public function getCommentList($userId,$video_id,$pageNo = 1,$pageSize = 10)
    {
        $where = ['video_id'=>$video_id];
        $order= 'c.create_time desc';
        $fields = 'c.*, m.nickname, m.headimgurl,m.unionid,m.is_robot, v.title, v.video_link, v.video_cover,v.num_comment';
        $comment = $this->alias('c')
            ->join('yf_hf_member m', 'm.id=c.member_id', 'left')
            ->join('yf_hf_video v', 'v.id=c.video_id', 'left')
            ->field($fields)
            ->where($where)->order($order)->page($pageNo,$pageSize)->select();
        $count = $this->where($where)->count();
        $total = ceil($count/$pageSize);

        $list = [];
        for ($i=0;$i<count($comment);$i++) {
            $other_id = '';
            $other_name = '';
            if ($comment[$i]['parent_id'] != 0) {
                $otherMember = $this->alias('c')->join('yf_hf_member m', 'm.id=c.member_id', 'left')->field('c.member_id,m.nickname')->where('c.id',$comment[$i]['parent_id'])->find();
                $other_id =  $otherMember['member_id'];
                $other_name = $otherMember['nickname'];
            }
            //获取头像地址
            if ($comment[$i]['unionid'] || $comment[$i]['is_robot']!=0){
                $headimgurl = $comment[$i]['headimgurl'];
            }else{
                $headimgurl = Tool::getDomain().$comment[$i]['headimgurl'];
            }
            $list[$i] = [
                'id'          => $comment[$i]['id'],
                'content'     => $comment[$i]['content'],
                'parent_id'   => $comment[$i]['parent_id'],
                'comment_num' => $comment[$i]['comment_num'],
                'create_time' => $comment[$i]['create_time'],
                'member_id'   => $comment[$i]['member_id'],
                'nickname'    => $comment[$i]['nickname'],
                'headimgurl'  => $headimgurl,
                'other_id'    => $other_id, //回复用户id
                'other_name'  => $other_name, //回复用户nickname
                'user_id'     => $userId, //本人用户id
            ];

        }
        return ['list'=>$list,'total'=>$total,'count'=>$comment[0]['num_comment']];
    }

    /**
     * 消息-评论
     * @param $ids
     * @param $pageNo
     *
     * @auther zyt
     */
    public function getCommentLists ($userId, $pageNo=1, $pageSize=10)
    {
        //别人评论我发布的视频和回复我的视频
        /*$field = 'c.id,c.content,c.member_id,c.video_id,c.user_id,c.parent_id,c.create_time,v.title,v.video_link,v.video_cover,m.nickname,m.headimgurl';
        $whereOr = 'c.id in (select id from yf_hf_comment where member_id='.$userId.' and user_id != '.$userId.')';
        $comment = $this->alias('c')
                ->join('yf_hf_member m', 'm.id=c.member_id', 'left')
                ->join('yf_hf_video v', 'v.id=c.video_id', 'left')
                ->field($field)
                ->where('c.member_id !='.$userId.' and c.user_id='.$userId)
                ->whereOr($whereOr)
                ->order('c.create_time desc')->page($pageNo,$pageSize)->select();
        $count = $this->where('user_id',$userId)->whereOr('member_id',$userId)->count();
        $total = ceil($count/$pageSize);*/
        $limit = " ORDER BY create_time desc LIMIT ".($pageNo-1)*$pageSize.",".$pageSize;
        $query1 = "SELECT `c`.`id`,`c`.`content`,`c`.`member_id`,`c`.`video_id`,`c`.`user_id`,`c`.`parent_id`,`c`.`create_time`,`v`.`title`,`v`.`video_link`,`v`.`video_cover`,`v`.`is_delete`,`m`.`nickname`,`m`.`headimgurl`,`m`.`unionid`,`m`.`is_robot` FROM `yf_hf_comment` `c` LEFT JOIN `yf_hf_member` `m` ON `m`.`id`=`c`.`member_id` LEFT JOIN `yf_hf_video` `v` ON `v`.`id`=`c`.`video_id` WHERE c.user_id=".$userId." and c.member_id != ".$userId."
                union all
                SELECT `c`.`id`,`c`.`content`,`c`.`member_id`,`c`.`video_id`,`c`.`user_id`,`c`.`parent_id`,`c`.`create_time`,`v`.`title`,`v`.`video_link`,`v`.`video_cover`,`v`.`is_delete`,`m`.`nickname`,`m`.`headimgurl`,`m`.`unionid`,`m`.`is_robot` FROM `yf_hf_comment` `c` LEFT JOIN `yf_hf_member` `m` ON `m`.`id`=`c`.`member_id` LEFT JOIN `yf_hf_video` `v` ON `v`.`id`=`c`.`video_id` WHERE c.user_id != ".$userId." and c.member_id = ".$userId."
                union all
                SELECT `c`.`id`,`c`.`content`,`c`.`member_id`,`c`.`video_id`,`c`.`user_id`,`c`.`parent_id`,`c`.`create_time`,`v`.`title`,`v`.`video_link`,`v`.`video_cover`,`v`.`is_delete`,`m`.`nickname`,`m`.`headimgurl`,`m`.`unionid`,`m`.`is_robot` FROM `yf_hf_comment` `c` LEFT JOIN `yf_hf_member` `m` ON `m`.`id`=`c`.`member_id` LEFT JOIN `yf_hf_video` `v` ON `v`.`id`=`c`.`video_id` WHERE c.parent_id in (select id from yf_hf_comment where user_id=".$userId." and member_id != ".$userId." union all select id from yf_hf_comment where user_id !=".$userId." and member_id = ".$userId.")
                ";
        $query2 = $query1.$limit;
        $list = $this->query($query1);
        $total = ceil(count($list)/$pageSize);
        $comment = $this->query($query2);
        $list = [];
        //添加status=1 表示别人对我视频的主评论 status=2表示A对我视频的评论之后,B对A的回复 status=3别人回复我对别人视频的评论
        for ($i=0;$i<count($comment);$i++) {
            //获取头像地址
            if ($comment[$i]['unionid'] || $comment[$i]['is_robot']!=0){
                $comment[$i]['headimgurl'] = $comment[$i]['headimgurl'];
            }else{
                $comment[$i]['headimgurl'] = Tool::getDomain().$comment[$i]['headimgurl'];
            }

            $list[$comment[$i]['id']] = $comment[$i];
            if ($comment[$i]['user_id'] == $userId && $comment[$i]['parent_id'] == 0) {
                $list[$comment[$i]['id']]['status'] = 1;
                $list[$comment[$i]['id']]['comment_nickname'] = '';
            }
            elseif ($comment[$i]['user_id'] == $userId && $comment[$i]['parent_id'] != 0) {
                $nickname = $this->alias('c')->join('yf_hf_member m', 'm.id=c.member_id', 'left')->field('m.nickname')->where('c.id',$comment[$i]['parent_id'])->find();
                $list[$comment[$i]['id']]['status'] = 2;
                $list[$comment[$i]['id']]['comment_nickname'] = $nickname['nickname'];
            } else {
                $list[$comment[$i]['id']]['status'] = 3;
                $list[$comment[$i]['id']]['comment_nickname'] = '你';
            }
        }
        return ['list'=>array_values($list), 'total'=>$total];
    }
}
