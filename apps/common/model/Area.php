<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/27
 * Time: 17:12
 */
namespace app\common\model;

use think\Model;
use think\Db;

class Area extends Base
{
    // 设置当前模型对应的完整数据表名称
    protected $table = 'yf_hf_area';

    /**获取上海市市区
     * @auther zyt
     */
    public function getAreaById()
    {
        return $this->where('fa_value','上海市')->whereOr('dic_value','上海市')->field('id,dic_value')->select();
    }
}