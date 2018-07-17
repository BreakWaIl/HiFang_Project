<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/27
 * Time: 19:18
 */
namespace app\common\validate;

use think\Validate;

class Label extends Validate
{
    // 验证规则
    protected $rule = [
        'label_name'      => 'require',
    ];

    protected $message = [
        'label_name.require'     => '标签名称不能为空',
    ];

    protected $scene=[
        'add'  => ['label_name'],
        'edit' => ['label_name','update_time'],
    ];
}