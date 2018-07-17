<?php
/**
 * Created by PhpStorm.
 * User: zfc
 * Date: 2018/4/16
 * Time: 17:09
 */

namespace app\common\model;


use think\Db;
use think\Model;

class ImageUpload extends Model
{
    protected $table = 'yf_hf_imgs';
    protected $createTime = 'create_time';
    protected $updateTime = 'update_time';

    /**
     * 判断该用户账户下是否有垃圾图片
     * by songjian
     */
    public function checkOldImg($user_id){
        $img = Db::table('yf_hf_imgs')
            ->where(['session_id'=>$user_id,'video_id'=>0])
            ->select();
        return $img;
    }

    /**
     * 删除垃圾图片
     * by songjian
     */
    public function deleteOldImg($user_id){
        $res = Db::table('yf_hf_imgs')
            ->where('session_id',$user_id)
            ->delete();
        return $res;
    }

    /**
     * 手动删除图片接口
     * by songjian
     */
    public function deleteImg($img_id){
        $res = Db::table('yf_hf_imgs')
                ->where('id',$img_id)
                ->delete();
        return $res;
    }

    /**
     * 取到图片上传的时间日期[年月日]
     * by songjian
     */
    public function getCreateTime($img_id){
        $res = Db::table('yf_hf_imgs')
                ->field(['create_time'])
                ->where('id',$img_id)
                ->find()['create_time'];
        return $res;
    }
}