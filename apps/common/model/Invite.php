<?php
/**
 * Created by PhpStorm.
 * User: ASUS
 * Date: 2018/5/8
 * Time: 18:39
 */

namespace app\common\model;


use think\Db;
use think\Exception;

class Invite extends Base
{
    /**
     * 获取邀请好友页面的推荐用户列表
     * by songjian
     */
    public function getInviteUser($num){
        $res = Db::table('yf_hf_member')
                ->field(['id','unionid','headimgurl','nickname','phone','sign','label'])
                ->where('is_robot',0)
                ->order('balance desc')
                ->limit($num)
                ->select();
        return $res;
    }

    /**
     * 获取我的邀请码
     * by songjian
     */
    public function getInviteCode($user_id){
        $code = Db::table('yf_hf_member')
            ->field('invite_code')
            ->where('id',$user_id)
            ->select()[0]['invite_code'];
        return $code;
    }

    /**
     * 通过is_power判断用户是否已经存在权限
     * by songjian
     */
    public function checkIsPower($user_id){
        $is_power= Db::table('yf_hf_member')
                    ->field('is_power')
                    ->group('is_power')
                    ->where('id',$user_id)
                    ->find()['is_power'];
        return $is_power;
    }

    /**
     * 获取所有的邀请码
     * by songjian
     */
    public function getAllInviteCode(){
        $invite_codes = Db::table('yf_hf_member')
                        ->field('invite_code')
                        ->select();
        return $invite_codes;
    }

    /**
     * 当邀请码验证成功时，将此用户记录表中is_power状态修改
     * by songjian
     */
    public function updateIsPower($user_id,$invite_code){
        Db::startTrans();
        try{
            //将此用户is_power、invite_from_id更新
            $userinfo = Db::table('yf_hf_member')->where('invite_code',$invite_code)->find();
            /**
             * 同时将两者转为互相关注关系
             * update by songjian
             */
            $arr = [
                [   'id'                => 0,
                    'member_id'         => $user_id,
                    'followed_id'       => $userinfo['id'],
                    'type'              => 0,
                    'black'             => 0,
                    'is_followed'       => 1,
                    'create_time'       => time(),
                    'update_time'       => time(),
                ],
                [   'id'                => 0,
                    'member_id'         => $userinfo['id'],
                    'followed_id'       => $user_id,
                    'type'              => 0,
                    'black'             => 0,
                    'is_followed'       => 1,
                    'create_time'       => time(),
                    'update_time'       => time()
                ]
            ];
            Db::table('yf_hf_follow')->insertAll($arr);
            Db::table('yf_hf_member')->where('id',$userinfo['id'])->setInc('num_follow');
            Db::table('yf_hf_member')->where('id',$userinfo['id'])->setInc('num_member');
            Db::table('yf_hf_member')->where('id',$user_id)->setInc('num_follow');
            Db::table('yf_hf_member')->where('id',$user_id)->setInc('num_member');

            $res = Db::table('yf_hf_member')
                ->where('id',$user_id)
                ->update(['is_power'=>1,'invite_from_id'=>$userinfo['id'],'update_time'=>time()]);
            Db::commit();
            return $res;
        }catch (Exception $exception){
            Db::rollback();
            return false;
        }
    }
}