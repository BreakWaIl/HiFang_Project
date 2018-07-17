<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/16
 * Time: 10:08
 */
namespace app\common\validate;

use think\Validate;

class Follow extends Validate
{
    // 验证规则
    protected $rule = [
        'member_id'     => 'require|chsAlphaNum',
        'followed_id'   => 'require|chsAlphaNum',
        'type'          => 'require|chsAlphaNum',
    ];

    protected $message = [
        'member_id.require'   => '关注人不能为空',
        'followed_id.require' => '被关注对象不能为空',
        'type.require'        => '请选择类型',
    ];

    protected $scene=[
        'add'  => ['member_id','followed_id','type','is_followed','create_time','update_time'],
        'edit' => ['member_id','followed_id','type','is_followed','create_time','update_time'],
    ];
}