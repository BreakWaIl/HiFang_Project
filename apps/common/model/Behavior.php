<?php
/**
 * Created by PhpStorm.
 * User: ASUS
 * Date: 2018/5/8
 * Time: 18:39
 */

namespace app\common\model;


use think\Db;

class Behavior extends Base
{
    /**
     * 将信息插入行为表
     * @param array|mixed $data
     * @return int|string
     */
    public function insert($data){
        $res = Db::table('yf_hf_behavior')->insert($data);
        return $res;
    }
}