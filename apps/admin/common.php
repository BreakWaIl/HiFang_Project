<?php
// +----------------------------------------------------------------------
// | Copyright (c) 2016-2017 http://www.eacoo123.com, All rights reserved.         
// +----------------------------------------------------------------------
// | [EacooPHP] 并不是自由软件,可免费使用,未经许可不能去掉EacooPHP相关版权。
// | 禁止在EacooPHP整体或任何部分基础上发展任何派生、修改或第三方版本用于重新分发
// +----------------------------------------------------------------------
// | Author:  心云间、凝听 <981248356@qq.com>
// +----------------------------------------------------------------------
//添加或更新多媒体附件分类
function update_media_term($media_id,$term_id){
    update_object_term($media_id,$term_id,'attachment');
}
//删除多媒体附件分类
function delete_media_term($media_id,$term_id){
    delete_object_term($media_id,$term_id,'attachment');
}

/**
 * 检查手机号码
 *
 * @param $phone
 * @return bool
 */
function check_phone($phone){
    $preg_phone = '/^1[3456789]{1}\d{9}$/';

    if (preg_match($preg_phone, $phone)) {
        $result = true;
    } else {
        $result = false;
    }

    return $result;
}