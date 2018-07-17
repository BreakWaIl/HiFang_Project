<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/18
 * Time: 13:43
 */
namespace app\common\model;

use app\api\controller\Tool;
use think\Model;
use think\Db;

class Member extends Base
{
    // 设置当前模型对应的完整数据表名称
    protected $table = 'yf_hf_member';

    /**
     * 获取用户信息
     * @param member_id  用户id
     * @author zyt
     */
    public function getMemberDetail($userId,$member_id)
    {
        $find = $this->alias('m')
            ->join('yf_hf_label l','l.id=m.label','left')
            ->field('m.id,m.nickname,m.sex,m.birthday,m.unionid,m.phone,m.hiid,m.label,m.headimgurl,m.is_robot,m.sign,m.num_buildings,m.num_prise,m.num_member,m.num_follow,l.label_name')
            ->where(['m.id'=>$member_id])->find();
        //获取头像地址
        if ($find['unionid'] || $find['is_robot']!=0){
            $find['headimgurl'] = $find['headimgurl'];
        }else{
            $find['headimgurl'] = Tool::getDomain().$find['headimgurl'];
        }
        $find['birthday'] = Tool::countAge($find['birthday']);
        //查询该用户是否关注发布人
        $find['member_followed'] = 0;
        $find['black'] = 0; //是否拉黑
        $member_follow   = Db::table('yf_hf_follow')->where(['member_id'=>$userId,'followed_id'=>$member_id,'type'=>0])->find();
        if ($member_follow && ($member_follow['is_followed'] == 1)) {
            $find['member_followed'] = 1;
        }
        if ($member_follow && ($member_follow['black'] == 1)) {
            $find['black'] = 1;
        }
        return $find;
    }

    /**
     * 判断此用户是否填写过他人邀请码
     * by songjian
     */
    public function isWrite($id){
        $res = Db::table('yf_hf_member')
                ->field(['is_power'])
                ->where('id',$id)
                ->find()['is_power'];
        return $res;
    }
}