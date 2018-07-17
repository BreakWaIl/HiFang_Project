<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/12
 * Time: 19:02
 */

namespace app\common\model;

use app\api\controller\Behavior;
use app\api\controller\Tool;
use think\Exception;
use think\Model;
use think\Db;
use app\common\model\Member;

class Follow extends Base
{
    // 设置当前模型对应的完整数据表名称
    protected $table = 'yf_hf_follow';

    /**添加关注  取消关注
     * @param $followed_id
     * @param $type
     * @author zyt
     */
    public function addOrUpdateFollow($userId, $followed_id, $type)
    {
        DB::startTrans();
        try {
            //若type=0(关注或者取消关注人) 1.需查询关注表是否有数据,若有数据,修改加状态;若没有数据,添加数据,状态为关注
            // 2.需查询用户表中的被关注人并修改用户表中被关注人的粉丝数,关注人数
            //查询关注表是否有数据
            $result = $this->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>$type])->find();
            $is_followed = $result['is_followed'];
            $data = array();
            if ($type == 0) {
                //查询被关注人的粉丝数
                $member = DB::table('yf_hf_member')->where('id', $followed_id)->find();
                if (count($member) == 0) {
                    return ["code" => "101", 'msg'=>'被关注人不存在', "data"=>$data];
                }
                $num_follow = $member['num_follow'];
                $num_member = DB::table('yf_hf_member')->where('id', $userId)->value('num_member'); //关注人数
                //若有数据,修改该状态;若没有数据,添加数据,状态为关注并修改用户表中被关注人的粉丝数
                if (count($result) > 0) {
                    //如果$is_followed=1,需将$is_followed改为0,用户表中被关注人的粉丝数减1
                    //如果$is_followed=0,需将$is_followed改为1,用户表中被关注人的粉丝数加1
                    if ($is_followed == 1) {
                        $follow = $this->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>$type])->update(['is_followed'=>0,'update_time'=>time()]);
                        $num_follow = ($num_follow - 1) < 0 ? 0 : ($num_follow - 1);
                        $num_member = ($num_member - 1) < 0 ? 0 : ($num_member - 1);
                    } else {
                        $follow = $this->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>$type])->update(['is_followed'=>1,'update_time'=>time()]);
                        $num_follow = $num_follow + 1;
                        $num_member = $num_member + 1;
                    }
                } else {
                    //添加数据,状态is_followed=1为关注
                    $follow = $this->save([
                        'id'              => 0,
                        'member_id'         => $userId,
                        'followed_id'       => $followed_id,
                        'type'              => $type,
                        'black'             => 0,
                        'is_followed'       => 1,
                        'create_time'       => time(),
                        'update_time'       => time(),
                    ]);
                    $num_follow = $num_follow + 1;
                    $num_member = $num_member + 1;
                }
                if (!$follow) {
                    Db::rollback();
                    return ["code" => "101", 'msg'=>'失败，数据异常', "data"=>$data];
                }
                //修改用户表中被关注人的粉丝数 关注人数
                $data = DB::table('yf_hf_member')->where('id',$followed_id)->update(['num_follow'=>$num_follow,'update_time'=>time()]);
                $data1 = DB::table('yf_hf_member')->where('id', $userId)->update(['num_member'=>$num_member,'update_time'=>time()]);
                if (!$data) {
                    Db::rollback();
                    return ["code" => "101", 'msg'=>'数据异常,操作失败', "data"=>$data];
                }
            }
            elseif ($type == 1) { //若type=1(关注小区) 需查询被关注小区并修改该小区的关注数
                //查询被关注小区的关注数
                $buildings = DB::table('yf_hf_buildings')->where('id', $followed_id)->find();
                if (count($buildings) == 0) {
                    return ["code" => "101", 'msg'=>'被关注小区不存在', "data"=>$data];
                }
                $follow_count = $buildings['follow_count'];
                //用户关注小区数
                $num_buildings = Db::table('yf_hf_member')->where('id',$userId)->value('num_buildings');
                //若有数据,修改该状态;若没有数据,添加数据,状态为关注并修改小区表中被关注小区的关注数
                if (count($result) > 0) {
                    //如果$is_followed=1,需将$is_followed改为0,小区表中被关注小区id的关注数减1
                    //如果$is_followed=0,需将$is_followed改为1,小区表中被关注小区id的关注数加1
                    if ($is_followed == 1) {
                        $follow = $this->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>$type])->update(['is_followed'=>0,'update_time'=>time()]);
                        $follow_count  = ($follow_count - 1) < 0 ? 0 : ($follow_count - 1);
                        $num_buildings = ($num_buildings - 1) < 0 ? 0 : ($num_buildings - 1);
                    } else {
                        $follow = $this->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>$type])->update(['is_followed'=>1,'update_time'=>time()]);
                        $follow_count  = $follow_count + 1;
                        $num_buildings = $num_buildings + 1;
                    }
                } else {
                    //添加数据,状态is_followed=1为关注
                    $follow = $this->save([
                        'id'          => 0,
                        'member_id'         => $userId,
                        'followed_id'       => $followed_id,
                        'type'              => $type,
                        'black'             => 0,
                        'is_followed'       => 1,
                        'create_time'       => time(),
                        'update_time'       => time(),
                    ]);
                    $follow_count = $follow_count + 1;
                    $num_buildings = $num_buildings + 1;
                }
                if (!$follow) {
                    Db::rollback();
                    return ["code" => "101", 'msg'=>'失败，数据异常', "data"=>$data];
                }
                //修改小区表中被关注小区的关注数
                $data = DB::table('yf_hf_buildings')->where('id',$followed_id)->update(['follow_count'=>$follow_count,'update_time'=>time()]);
                //修改用户表中关注小区数
                $data2 = DB::table('yf_hf_member')->where('id',$userId)->update(['num_buildings'=>$num_buildings,'update_time'=>time()]);
                if (!$data || !$data2) {
                    Db::rollback();
                    return ["code" => "101", 'msg'=>'数据异常,操作失败', "data"=>$data];
                }
                $behavior = new Behavior();
                $behavior->insertBackBehavior($userId,22);
            }
            elseif ($type == 2) { //若type=2(关注并点赞视频) 需查询被关注视频并修改该视频的收藏数,点赞数,发布视频用户的获赞数
                //查询被关注视频的关注数和点赞数
                $videos = DB::table('yf_hf_video')->where('id', $followed_id)->find();
                if (count($videos) == 0) {
                    return ["code" => "101", 'msg'=>'被关注视频不存在', "data"=>$data];
                }
                $num_favorite = $videos['num_favorite'];
                $num_good_video = DB::table('yf_hf_member')->where('id', $userId)->value('num_good_video');
                $num_prise = DB::table('yf_hf_member')->where('id', $videos['member_id'])->value('num_prise');//发布视频用户的获赞数
                //若有数据,修改该状态;若没有数据,添加数据,状态为关注并修改视频表中被关注视频的收藏数,点赞数
                if (count($result) > 0) {
                    //如果$is_followed=1,需将$is_followed改为0,小区表中被关注视频id的收藏数,点赞数减1
                    //如果$is_followed=0,需将$is_followed改为1,小区表中被关注视频id的收藏数,点赞数加1
                    if ($is_followed == 1) {
                        $follow = $this->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>$type])->update(['is_followed'=>0,'update_time'=>time()]);
                        $num_favorite = ($num_favorite - 1) < 0 ? 0 : ($num_favorite - 1);
                        $num_good_video = ($num_good_video - 1) < 0 ? 0 : ($num_good_video - 1);
                        $num_prise = ($num_prise - 1) < 0 ? 0 : ($num_prise - 1);
                    } else {
                        $follow = $this->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>$type])->update(['is_followed'=>1,'update_time'=>time()]);
                        $num_favorite = $num_favorite + 1;
                        $num_good_video = $num_good_video + 1;
                        $num_prise = $num_prise + 1;
                    }
                } else {
                    //添加数据,状态is_followed=1为关注
                    $follow = $this->save([
                        'id'          => 0,
                        'member_id'         => $userId,
                        'followed_id'       => $followed_id,
                        'type'              => $type,
                        'black'             => 0,
                        'is_followed'       => 1,
                        'create_time'       => time(),
                        'update_time'       => time(),
                    ]);
                    $num_favorite = $num_favorite + 1;
                    $num_good_video = $num_good_video + 1;
                    $num_prise = $num_prise + 1;
                }
                if (!$follow) {
                    Db::rollback();
                    return ["code" => "101", 'msg'=>'失败，数据异常', "data"=>$data];
                }
                //修改视频表中被关注视频的收藏数,点赞数
                $data = DB::table('yf_hf_video')->where('id',$followed_id)->update(['num_favorite'=>$num_favorite,'update_time'=>time()]);
                $data2 = DB::table('yf_hf_member')->where('id',$userId)->update(['num_good_video'=>$num_good_video,'update_time'=>time()]);
                $data3 = DB::table('yf_hf_member')->where('id',$videos['member_id'])->update(['num_prise'=>$num_prise,'update_time'=>time()]);

                if (!$data && !$data2) {
                    Db::rollback();
                    return ["code" => "101", 'msg'=>'数据异常,操作失败', "data"=>$data];
                }
            }
            elseif ($type == 3) { //点赞别人的评论

                //查询被点赞评论的点赞数
                $comment = DB::table('yf_hf_comment')->where('id', $followed_id)->find();
                if (count($comment) == 0) {
                    return ["code" => "101", 'msg'=>'被点赞评论不存在', "data"=>$data];
                }
                $comment_num = $comment['comment_num'];
                //若有数据,修改该状态;若没有数据,添加数据,状态为已点赞并修改评论表中被评论id的点赞数
                if (count($result) > 0) {
                    //如果$is_followed=1,需将$is_followed改为0,评论表中被点赞评论id的点赞数减1
                    //如果$is_followed=0,需将$is_followed改为1,评论表中被点赞评论id的点赞数加1
                    if ($is_followed == 1) {
                        $follow = $this->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>$type])->update(['is_followed'=>0,'update_time'=>time()]);
                        $comment_num = ($comment_num - 1) < 0 ? 0 : ($comment_num - 1);
                    } else {
                        $follow = $this->where(['member_id'=>$userId,'followed_id'=>$followed_id,'type'=>$type])->update(['is_followed'=>1,'update_time'=>time()]);
                        $comment_num = $comment_num + 1;
                    }
                } else {
                    //添加数据,状态is_followed=1为点赞
                    $follow = $this->save([
                        'id'          => 0,
                        'member_id'         => $userId,
                        'followed_id'       => $followed_id,
                        'type'              => $type,
                        'is_followed'       => 1,
                        'create_time'       => time(),
                        'update_time'       => time(),
                    ]);
                    $comment_num = $comment_num + 1;
                }

                if (!$follow) {
                    Db::rollback();
                    return ["code" => "101", 'msg'=>'失败，数据异常', "data"=>$data];
                }
                //修改评论表中被点赞评论id的评论数
                $data = DB::table('yf_hf_comment')->where('id',$followed_id)->update(['comment_num'=>$comment_num,'update_time'=>time()]);
                if (!$data) {
                    Db::rollback();
                    return ["code" => "101", 'msg'=>'数据异常,操作失败', "data"=>$data];
                }
            }

            DB::commit();
            return [ "code" => "200", "message" => "操作成功", "data"=>$data];
        } catch (\Exception $e) {
            DB::rollback();
            return [ "code" => "101", "message" => "失败，数据异常", "data"=>$data ];
        }
    }

    /**
     *  获取关注列表
     * @param array $map
     * @param bool|true $field
     * @param string $order
     * @param null $page_size
     * @return array
     * @author zyt
     */
    public function getFollowListByPage($map,$fields=true,$order='create_time desc',$page_size=null)
    {
        $paged     = input('param.paged',1);//分页值
        if (!$page_size) {
            $page_size = config('admin_page_size');
        }
        $page_size = input('param.page_size',$page_size);//每页数量
        $order     = input('param.order',$order);
        $fields = 'f.id,f.member_id,f.followed_id,f.type,f.black,m.nickname,m.headimgurl';
        $list      = $this->alias('f')
            ->join('yf_hf_member m', 'm.id = f.member_id', 'left')
            ->join('yf_hf_video v', 'v.id = f.followed_id', 'left')
            ->join('yf_hf_buildings b', 'b.id = f.followed_id', 'left')
            ->field($fields)
            ->where($map)->order('f.'.$order)->page($paged,$page_size)->select();
        $total     = $this->where($map)->count();
        return [$list,$total];
    }

    /**
     * 查询我的关注小区或人列表
     * @param $userId
     * @param $pageNo
     * @param $page_size
     * @param $type
     * @author zyt
     */
    public function getFollowList($userId, $type, $pageNo = 1, $pageSize = 10)
    {
        $map = ['f.member_id'=>$userId, 'f.type'=>$type, 'f.is_followed'=>1];
        $order='f.create_time desc';
        if($type == 0){
            $query = $this->alias('f')
                ->join('yf_hf_member m', 'm.id=f.followed_id', 'left')
                ->join('yf_hf_label l', 'l.id=m.label', 'left')
                ->field('f.id,f.member_id,f.followed_id,m.nickname,m.headimgurl,m.unionid,m.is_robot,m.label,m.sign,m.hiid,l.label_name')
                ->where($map);
        } else {
            $query = $this->alias('f')
                ->join('yf_hf_buildings b', 'b.id=f.followed_id', 'left')
                ->field('f.id,f.member_id,f.followed_id,b.name,b.average_price, 0 as num_percent')
                ->where($map);
        }

        $list = $query->order($order)->page($pageNo,$pageSize)->select();
        if ($type == 0) {
            for ($i=0;$i<count($list);$i++) {
                //获取头像地址
                if ($list[$i]['unionid'] || $list[$i]['is_robot']!=0){
                    $list[$i]['headimgurl'] = $list[$i]['headimgurl'];
                }else{
                    $list[$i]['headimgurl'] = Tool::getDomain().$list[$i]['headimgurl'];
                }
            }
        }
        $count = $this->where(['member_id'=>$userId,'type'=>$type, 'is_followed'=>1])->count();
        $total = ceil($count/$pageSize);
        return ['list'=>$list, 'total'=>$total];
    }
    /*public function getFollowList($userId, $type,$pageNo = 1, $pageSize = 10)
    {
        $map = ['f.member_id'=>$userId, 'f.type'=>$type];
        $order='f.create_time desc';
        if($type == 0){
            $list = $this->alias('f')
                ->join('yf_hf_member m', 'm.id=f.followed_id', 'left')
                ->join('yf_hf_label l', 'l.id=m.label', 'left')
                ->field('f.id,f.member_id,f.followed_id,m.nickname,m.headimgurl,m.label,m.sign,m.hiid,l.label_name')
                ->where($map)->order($order)->page($pageNo,$pageSize)->select();
        } else {
            $list = $this->alias('f')
                ->join('yf_hf_buildings b', 'b.id=f.followed_id', 'left')
                ->field('f.id,f.member_id,f.followed_id,b.name,b.average_price')
                ->where($map)->order($order)->page($pageNo,$pageSize)->select();
        }
        return $list;
    }*/

    /**
     *关注该小区的人列表get
     * @params userId
     * @params building_id 小区id
     * @params pageNo 页码
     * @author zyt
     */
    public function getListByBuildingId($userId, $building_id, $pageNo, $pageSize=10)
    {
        $map = ['followed_id'=>$building_id, 'type'=>1, 'is_followed'=>1];
        $order = 'f.create_time desc';
        $field = 'f.id,f.member_id,f.followed_id,f.type,f.black,f.is_followed,f.update_time, m.nickname, m.headimgurl,m.unionid,m.is_robot,m.hiid,m.label,m.sign,l.label_name';
        $list = $this->alias('f')
            ->join('yf_hf_member m', 'm.id=f.member_id', 'left')
            ->join('yf_hf_label l', 'l.id=m.label', 'left')
            ->field($field)
            ->where($map)->order($order)->page($pageNo,$pageSize)->select();
        $count = $this->where($map)->count();
        $total = ceil($count/$pageSize);
        //查询我关注的人
        $res = $this->where(['member_id'=>$userId, 'type'=>0, 'is_followed'=>1])->select();
        // 添加status 0 未关注 1 已关注
        if (count($list) > 0) {
            for ($i=0;$i<count($list);$i++) {
                //获取头像地址
                if ($list[$i]['unionid'] || $list[$i]['is_robot']!=0){
                    $list[$i]['headimgurl'] = $list[$i]['headimgurl'];
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
        return ['list'=>$list, 'total'=>$total];
    }

    /**
     * 查询他的/我的粉丝列表
     * @param $params
     * @return array
     * @author zyt
     */
    public function getMyFens($member_id,$userId, $pageNo = 1, $pageSize = 10){
        $map = ['followed_id'=>$member_id, 'type'=>0, 'is_followed'=>1];
        $order = 'f.update_time desc';
        $field = 'f.id,f.member_id,f.followed_id,f.type,f.black,f.is_followed,f.update_time, m.nickname, m.headimgurl,m.unionid,m.is_robot,m.hiid,m.label,m.sign,l.label_name';
        $list = $this->alias('f')
            ->join('yf_hf_member m', 'm.id=f.member_id', 'left')
            ->join('yf_hf_label l', 'l.id=m.label', 'left')
            ->field($field)
            ->where($map)->order($order)->page($pageNo,$pageSize)->select();
        $count = $this->where($map)->count();
        $total = ceil($count/$pageSize);
        //查询我关注的人
        $res = $this->where(['member_id'=>$userId, 'type'=>0, 'is_followed'=>1])->select();
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
        return ['list'=>$list, 'total'=>$total];
    }

    /**
     * 查询他的关注人列表
     * @param $params
     * @return array
     * @author zyt
     */
    public function getOtherFollowList($member_id, $userId, $pageNo = 1, $pageSize = 10){
        $map = ['member_id'=>$member_id, 'type'=>0, 'is_followed'=>1];
        $order = 'f.create_time desc';
        $field = 'f.id,f.member_id,f.followed_id,f.type,f.black,f.is_followed,f.update_time, m.nickname, m.headimgurl,m.unionid,m.is_robot,m.hiid,m.label,m.sign,l.label_name';
        $list = $this->alias('f')
            ->join('yf_hf_member m', 'm.id=f.followed_id', 'left')
            ->join('yf_hf_label l', 'l.id=m.label', 'left')
            ->field($field)
            ->where($map)->order($order)->page($pageNo,$pageSize)->select();
        $count = $this->where($map)->count();
        $total = ceil($count/$pageSize);
        //查询我关注的人
        $res = $this->where(['member_id'=>$userId, 'type'=>0, 'is_followed'=>1])->select();
        // 添加status 0 未关注 1 已关注
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
                        if ($list[$i]['followed_id'] == $res[$j]['followed_id']) {
                            $list[$i]['status'] = 1;
                        }
                    }
                }
            }
        }
        return ['list'=>$list, 'total'=>$total];
    }

    /**查询我的点赞视频列表
     * @param $member_id
     * @param $pageNo
     * @param $pageSize
     * @author zyt
     */
    public function getFollowListByMemberId($member_id, $pageNo = 1, $pageSize = 10)
    {
        $where = ['f.is_followed'=>1,'f.member_id'=>$member_id,'f.type'=>2];
        $where_ = ['is_followed'=>1,'member_id'=>$member_id,'type'=>2];
        $order='f.create_time desc';
        $fields = 'f.followed_id as id,f.create_time,f.update_time,v.building_id,v.member_id,v.title,v.video_link,v.video_type,v.video_cover,v.status,v.num_visits,v.num_favorite,v.num_comment,v.num_room,v.num_hall,v.num_toilet,v.area,v.price,v.join_rent,v.is_delete,v.remarks,m.nickname,m.headimgurl,m.hiid,m.unionid,m.is_robot,b.name as building_name,b.average_price,b.address as area_name';
        $list = $this->alias('f')
            ->join('yf_hf_video v', 'v.id=f.followed_id', 'left')
            ->join('yf_hf_member m', 'm.id=v.member_id', 'left')
            ->join('yf_hf_buildings b', 'b.id=v.building_id', 'left')
            ->field($fields)
            ->where($where)->order($order)->page($pageNo,$pageSize)->select();
        for ($i=0;$i<count($list);$i++) {
            $list[$i]['building_name']= Tool::getBuildingName($list[$i]['area_name'],$list[$i]['building_name']);
            $list[$i]['default_video_cover']= Tool::getDefaultCover();

            if ($list[$i]['unionid'] || $list[$i]['is_robot']!=0){
                $list[$i]['headimgurl'] = $list[$i]['headimgurl'];
            }else{
                $list[$i]['headimgurl'] = Tool::getDomain().$list[$i]['headimgurl'];
            }
            //查询该用户是否关注小区,关注发布人,关注点赞视频
            $list[$i]['member_followed'] = 0;
            $list[$i]['building_followed'] = 0;
            $list[$i]['video_followed'] = 0;
            $member_follow   = Db::table('yf_hf_follow')->where(['member_id'=>$member_id,'followed_id'=>$list[$i]['member_id'],'type'=>0])->find();
            $building_follow = Db::table('yf_hf_follow')->where(['member_id'=>$member_id,'followed_id'=>$list[$i]['building_id'],'type'=>1])->find();
            $video_follow    = Db::table('yf_hf_follow')->where(['member_id'=>$member_id,'followed_id'=>$list[$i]['id'],'type'=>2])->find();
            if ($member_follow && ($member_follow['is_followed'] == 1)) {
                $list[$i]['member_followed'] = 1;
            }
            if ($building_follow && ($building_follow['is_followed'] == 1)) {
                $list[$i]['building_followed'] = 1;
            }
            if ($video_follow && ($video_follow['is_followed'] == 1)) {
                $list[$i]['video_followed'] = 1;
            }
        }

        $count = $this->where($where_)->count();
        $total = ceil($count/$pageSize);
        return ['list'=>$list,'total'=>$total];
    }

    /**获取点赞评论列表
     * @param $userId
     * @param array $ids
     * @return false|\PDOStatement|string|\think\Collection
     * @auther zyt
     */
    public function getListByCommentId ($userId, $ids=[])
    {
        return $this->where(['member_id'=>$userId,'type'=>3,'is_followed'=>1])->whereIn('followed_id',$ids)->select();
    }

    /**
     * 消息--获赞
     * @param $ids
     * @param $pageNo
     * @auther zyt
     */
    public function getUpvodeList ($ids, $pageNo, $pageSize=10)
    {
        $where = ['type'=>2,'is_followed'=>1];
        $field = 'f.id,f.member_id,f.followed_id as video_id,f.type,f.is_followed,f.update_time,v.title,v.video_link,v.video_cover,v.is_delete,m.nickname,m.headimgurl,m.unionid,m.is_robot';
        $follow = $this->alias('f')
            ->join('yf_hf_member m', 'm.id=f.member_id', 'left')
            ->join('yf_hf_video v', 'v.id=f.followed_id', 'left')
            ->field($field)
            ->where($where)->whereIn('followed_id',$ids)->order('f.create_time desc')->page($pageNo,$pageSize)->select();
        $count = $this->where($where)->whereIn('followed_id',$ids)->count();
        $total = ceil($count/$pageSize);
        if ($follow) {
            for ($i=0;$i<count($follow);$i++) {
                if ($follow[$i]['unionid'] || $follow[$i]['is_robot']!=0) {
                    $follow[$i]['headimgurl'] = $follow[$i]['headimgurl'];
                } else {
                    $follow[$i]['headimgurl'] = Tool::getDomain() . $follow[$i]['headimgurl'];
                }
            }
        }
        return ['list'=>$follow, 'total'=>$total];
    }
}
