<?php

namespace app\common\untils;
use think\Config;
use think\helper\Time;
use think\Session;
use Firebase\JWT\JWT;
/**
 * Created by songjian
 * User : hj
 * Date : 2017-12-8
 * Time : 16:34:07
 * Intro:
 */
class JwtUntils {

    /**
     * 生成authToken
     * @param type $data
     * @return boolean
     */
    public function createToken($data){
        if ($data) {
            $jwt_data['data']       = $data;
            $jwt_data['timeStamp_'] = time();
            $jwt = new JWT();
            $result = $jwt->encode($jwt_data,'123456');
            Session::set('authToken', $result);
        } else {
            $result = false;
        }
        return $result;
    }

    /**
     * 解码token
     *
     * @param type $token
     * @return int
     */
    public function getDecode($token) {

        if ($token) {
            $result = \Firebase\JWT\JWT::decode($token,'123456', array( 'HS256' ));

            $today = Time::today();

            //注册和忘记密码
            if ($result->timeStamp_ < 2592000) {
                $data['status'] = 101;
                $data['msg']    = 'jwt_token time expire';
            } else {
                $data['data'] = (array)$result->data;
            }
        } else{
            $data['status'] = 101;
        }

        return $data;
    }
}
