<?php
/**
 * Created by PhpStorm.
 * User: zfc
 * Date: 2018/4/13
 * Time: 14:43
 */

namespace app\api\model;

use app\common\model\Base;
use think\Db;

class Wxauth extends Base
{
    protected $table = 'yf_hf_member';

    /**
     * 将微信网页授权的用户信息入库
     * by songjian
     */
    public function insertUserInfo($info,$hiid){
        $data['id'] = 0;
        $data['nickname'] = $info['nickname'];
        $data['sex'] = $info['sex'];
        $data['province'] = $info['province'];
        $data['city'] = $info['city'];
        $data['country'] = $info['country'];
        $data['headimgurl'] = $info['headimgurl'];
        $data['privilege'] = $info['privilege'];
        $data['unionid'] = $info['unionid'];
        $data['hiid'] = $hiid;
        $data['create_time'] = time();
        $data['update_time'] = time();
        $res = Db::table('yf_hf_member')->insert($data);
        return $res;
    }
}