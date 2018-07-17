<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/20
 * Time: 15:59
 */

namespace app\admin\validate;

use think\Validate;

class Version extends Validate
{
    // 验证规则
    protected $rule = [
        'version_no'   => 'require',
        'intro'        => 'require',
        'app_path'     => 'require',
        'type'         => 'require'
    ];

    protected $message = [
        'version_no.require' => '版本编号不能为空',
        'intro.require'      => '版本简述不能为空',
        'app_path.require'   => '地址不能为空',
        'type.require'       => '选择版本类型',
    ];

    protected $scene=[
        'add' => ['version','intro','type','app_path','status','create_time','update_time'],
        'edit' => ['version','intro','type','app_path','status','update_time'],
    ];
}