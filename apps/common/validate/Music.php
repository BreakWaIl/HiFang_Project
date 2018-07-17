<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/27
 * Time: 9:36
 */
namespace app\common\validate;

use think\Validate;

class Music extends Validate
{
    // 验证规则
    protected $rule = [
        'title'      => 'require',
        'music_url'  => 'require',
        'image_url'  => 'require',
        'time'       => 'require',
    ];

    protected $message = [
        'title.require'     => '音乐标题不能为空',
        'music_url.require' => '音乐链接不能为空',
        'image_url.require' => '请上传音乐封面图',
        'time.require'      => '请输入时长',
    ];

    protected $scene=[
        'add'  => ['title','music_url','image_url','time'],
        'edit' => ['title','music_url','image_url','time','update_time'],
    ];
}