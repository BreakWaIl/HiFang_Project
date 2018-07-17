<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/16
 * Time: 10:55
 */

namespace app\common\validate;

use think\Validate;

class Buildings extends Validate
{
    //protected $regex = [ 'username'=>'^(?!_)(?!\d)(?!.*?_$)[\w]+$','mobile' => '/^1[3|4|5|7|8][0-9]\d{4,8}$/u'];
    // 验证规则
    protected $rule = [
        'name'                => 'require',
        'average_price'       => 'require',
        'architectural_age'   => 'require',
        'architectural_type'  => 'require',
        'property_cost'       => 'require',
        'property_company'    => 'require',
        'longitude'           => 'require',
        'latitude'            => 'require',
        'developers'          => 'require',
        'num_building'        => 'require',
        'num_room'            => 'require',
    ];

    protected $message = [
        'name.require'                => '小区名称不能为空',
        'average_price.require'       => '均价不能为空',
        'architectural_age.require'   => '建筑年代不能为空',
        'architectural_type.require'  => '建筑类型不能为空',
        'property_cost.require'       => '物业费用不能为空',
        'property_company.require'    => '物业公司不能为空',
        'longitude.require'           => '小区经度不能为空',
        'latitude.require'            => '小区纬度不能为空',
        'developers.require'          => '开发商不能为空',
        'num_building.require'        => '楼栋总数不能为空',
        'num_room.require'            => '房屋总数不能为空',
    ];

    protected $scene=[
        'add' => ['name', 'average_price', 'architectural_age', 'architectural_type', 'property_cost', 'property_company', 'longitude', 'latitude', 'developers', 'num_building', 'num_room'],
        'edit' => ['name', 'average_price', 'architectural_age', 'architectural_type', 'property_cost', 'property_company', 'longitude', 'latitude', 'developers', 'num_building', 'num_room','update_time'],
    ];
}