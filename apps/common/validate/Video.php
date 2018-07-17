<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/16
 * Time: 10:55
 */

namespace app\common\validate;

use think\Validate;

class Video extends Validate
{
    //protected $regex = [ 'username'=>'^(?!_)(?!\d)(?!.*?_$)[\w]+$','mobile' => '/^1[3|4|5|7|8][0-9]\d{4,8}$/u'];
    // 验证规则
    protected $rule = [
        'title'        => 'require',
        'video_link'   => 'require',
        'video_type'   => 'require',
        'video_cover'  => 'require',
        'status'       => 'require',
        'sort'         => 'require',
        'num_room'     => 'require',
        'num_hall'     => 'require',
        'area'         => 'require',
        'price'        => 'require',
        'member_id'    => 'require',
        'app_version'  => 'require',
    ];

    protected $message = [
        'title.require'        => '视频标题不能为空',
        'video_link.require'   => '视频链接不能为空',
        'video_type.require'   => '视频类型不能为空',
        'video_cover.require'  => '视频封面不能为空',
        'status.require'       => '选择是否上架下架',
        'sort.require'         => '排序不能为空',
        'num_room.require'     => '几室不能为空',
        'num_hall.require'     => '几厅不能为空',
        'area.require'         => '面积不能为空',
        'price.require'        => '房价不能为空',
        'member_id.require'    => '用户id不能为空',
        'app_version.require'  => '用户当前版本不能为空',
    ];

    protected $scene=[
        'add' => ['title', 'video_link', 'video_type', 'video_cover', 'status', 'sort', 'num_room', 'num_hall', 'area', 'price', 'member_id', 'app_version'],
        'edit' => ['title', 'video_link', 'video_type', 'video_cover', 'status', 'sort', 'num_room', 'num_hall', 'area', 'price', 'member_id', 'app_version','update_time'
        ],
    ];
}