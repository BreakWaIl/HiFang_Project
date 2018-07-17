<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/28
 * Time: 15:30
 */
namespace app\common\validate;

use think\Validate;

class Question extends Validate
{
    // 验证规则
    protected $rule = [
        'title'      => 'require',
    ];

    protected $message = [
        'title.require'     => '问题标题不能为空',
    ];

    protected $scene=[
        'add'  => ['title','content','create_time','update_time'],
        'edit' => ['title','content','update_time'],
    ];
}