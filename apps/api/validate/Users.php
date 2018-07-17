<?php

/**
 * Created by fuju
 * User : hj
 * Date : 2017-12-7
 * Time : 15:15:42
 * Intro: 
 */

namespace app\api\validate;

use think\Validate;

class Users extends Validate {

    protected $rule = [
        'user_phone' => '/^1[34578]{1}\d{9}$/',
        'referrer_id'     => 'require|number',
        'referrer_source' => 'require|number',
        'code'            => 'require|number',
        'user_nick'       => 'require',
        'user_pswd'       => 'require|min:6',
        'token'           => 'require'
    ];
    protected $message = [
        'user_phone'         => '手机号码错误',
        'referrer_id.require' => 'referrer_id is null',
        'referrer_id.number'  => 'referrer_id must be numbers',
        'referrer_source.require' => 'referrer_source is null',
        'referrer_source.number'  => 'referrer_source must be numbers',
        'code.require' => 'code is null',
        'code.number'  => 'code is null',
        'user_nick.require'   => '用户名为空',
        'user_pswd.require'   =>  '密码为空',
        'user_pswd.min'       =>  '密码小于6位',
    ];
    protected $scene = [
        'invite'   => 'user_phone,referrer_id,referrer_source',
        'cPost'    => 'user_phone,referrer_id,referrer_source,code',
        'register' =>  'user_phone,user_pswd,token',
        'edit'     => ''
    ];

}