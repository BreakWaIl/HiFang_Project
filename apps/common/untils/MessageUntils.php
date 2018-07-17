<?php
/**
 * Created by NetBeans.
 * User : hj
 * Date : 2017.12.6
 * Time : 16:14
 * Intro: 
 */

namespace app\common\untils;

use app\common\model\NoteLog;
use think\controller;
class MessageUntils {
    
    public function __construct() {
        
    }
    
    /**
     * 短信验证码
     * 容云通讯
     *
     * @param $to
     * @param $datas
     * @param string $tempId
     * @return SimpleXMLElement[]
     */
    public function sendCCPSMS($to, $datas, $tempId = '252612') {
        import('CCPRestSDK', EXTEND_PATH, '.php');
        $accountSid   = '8a48b55153eae51101540e763d3b3888';
        $accountToken = '26b220de299d4a56a6f54dd5792a30e4';
        $appId        = '8a216da863aa05670163af9b1caf03c2';    //嗨房appid
        $serverIP     = 'app.cloopen.com';
        $serverPort   = '8883';
        $softVersion  = '2013-12-26';

        // 初始化REST SDK
        //global $accountSid, $accountToken, $appId, $serverIP, $serverPort, $softVersion;
        $rest = new \REST($serverIP, $serverPort, $softVersion);
        $rest->setAccount($accountSid, $accountToken);
        $rest->setAppId($appId);

        $result['statusCode']    = '';
        $result['statusMsg']     = '';
        $result['TemplateSMS']   = '';
        $result['dateCreated']   = '';
        $result['smsMessageSid'] = '';
        $result['statusMsg']     = '';
        $result = (array)$rest->sendTemplateSMS($to, $datas, $tempId);
        if($result == NULL ) {
            $data['statusMsg']  = '短信接口无返回';
            $data['statusCode'] = -1;
        }

        if($result['statusCode'] != 0) {
            $data['statusCode'] = $result['statusCode'];
            $data['statusMsg']  = $result['statusMsg'];
        }else{
            $data['statusCode']    = $result['statusCode'];
            $data['TemplateSMS']   = $result['TemplateSMS'];
        }

        return $data;
    }

    /**
     * 发送常规验证短信
     * by songjian
     * @param $phone
     * @return SimpleXMLElement[]
     */
    public function sendCheckCode($phone) {
        $result_data['msg']    = '';
        $result_data['status'] = true;

        $noteLog = new NoteLog();
        $send_time  = $noteLog->field('send_time')->where('phone', $phone)
            ->where('is_success',1)
            ->where('send_time','between time',[date('Y-m-d').' 00:00:00',date('Y-m-d').' 23:59:59'])
            ->select();
        $num = count($send_time); //发送数量

        if (!empty($send_time[$num-1]) && (time() - strtotime($send_time[$num-1]->send_time) < 58) && $num != 0) {
            $result_data['msg']    = '1分钟内不能再次获取验证码';
            $result_data['status'] = false;
            return $result_data;
        }

        if ($num > 7){
            $result_data['msg']    = '短信发送超过上限';
            $result_data['status'] = false;
            return $result_data;
        }

        $message = new MessageUntils();
        $_code   = mt_rand(1000, 9999) . '';
        $result  = $message->sendCCPSMS($phone, array($_code, '5分钟'), 252612);

        //添加本次输入数据
        $noteLog->id = 0;
        $noteLog->phone        = $phone;
        $noteLog->template_msg = '【嗨房短视频】验证码'.$_code.'，打死都不要告诉别人哦！';
        $noteLog->code         = $_code;
        $noteLog->send_time    = date('Y-m-d H:i:s');
        $noteLog->ip           = request()->ip();
        $noteLog->app_version  = '1.0.0';
        $result['statusCode'] = 0;

        //加密操作
        if ($result['statusCode'] == "000000") {
            $jwt = new JwtUntils();
            $noteLog->is_success = 1;
            $jwt_data['phone']   = $phone;
            $jwt_data['code']    = $_code;

            $result_data['sms_code']   = $_code;
            //生成token
            $result_data['token']  = $jwt->createToken($jwt_data);
            $result_data['status'] = true;
        } else {
            $noteLog->is_success = 2;
            $result_data['status'] = false;
        }
        //将数据保存到库中
        $noteLog->save();
        return $result_data;
    }

    /**
     * 发送邀请验证短信
     * by songjian
     * @param $phone
     * @return SimpleXMLElement[]
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function sendInviteCode($phone,$code,$nickname,$userid) {
        $result_data['msg']    = '';
        $result_data['status'] = true;

        $noteLog = new NoteLog();
        $send_time  = $noteLog->field('send_time')->where('phone', $phone)
            ->where('is_success',1)
            ->where('send_time','between time',[date('Y-m-d').' 00:00:00',date('Y-m-d').' 23:59:59'])
            ->select();
        $num = count($send_time); //发送数量

        if (!empty($send_time[$num-1]) && (time() - strtotime($send_time[$num-1]->send_time) < 58) && $num != 0) {
            $result_data['msg']    = '1分钟内不能再次获取验证码';
            $result_data['status'] = false;
            return $result_data;
        }

        if ($num > 7){
            $result_data['msg']    = '短信发送超过上限';
            $result_data['status'] = false;
            return $result_data;
        }

        $message = new MessageUntils();
        $_code   = $code . '';
        $web = "www.haifang.com/xxx/xxx/xxx?userid=".$userid;
        $result  = $message->sendCCPSMS($phone, array($_code, '5分钟'), 214759);

        //添加本次输入数据
        $noteLog->phone        = $phone;
        $noteLog->template_msg = '【同联商业】你的朋友'.$nickname.'邀请你来使用嗨房啦，点击此页面进行注册：'.$web.'，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。';
        $noteLog->code         = $_code;
        $noteLog->send_time    = date('Y-m-d H:i:s');
        $noteLog->ip           = request()->ip();
        $noteLog->app_version  = '1.0.0';
        $result['statusCode'] = 0;

        //加密操作
        if ($result['statusCode'] == "000000") {
            $jwt = new JwtUntils();
            $noteLog->id = 0;
            $noteLog->is_success = 1;
            $jwt_data['phone']   = $phone;
            $jwt_data['code']    = $_code;

            $result_data['sms_code']   = $_code;
            $result_data['message'] = $noteLog->template_msg;
            //生成token
            $result_data['token']  = $jwt->createToken($jwt_data);
            $result_data['status'] = true;
        } else {
            $noteLog->is_success = 2;
            $result_data['status'] = false;
        }
        //将数据保存到库中
        $noteLog->save();
        return $result_data;
    }



    /**
     * 发送提现之前的验证短信
     * by songjian
     * @param $phone
     * @return SimpleXMLElement[]
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function sendGetReadyMoneyCode($phone) {
        $result_data['msg']    = '';
        $result_data['status'] = true;

        $noteLog = new NoteLog();
        $send_time  = $noteLog->field('send_time')->where('phone', $phone)
            ->where('is_success',1)
            ->where('send_time','between time',[date('Y-m-d').' 00:00:00',date('Y-m-d').' 23:59:59'])
            ->select();
        $num = count($send_time); //发送数量

        if (!empty($send_time[$num-1]) && (time() - strtotime($send_time[$num-1]->send_time) < 58) && $num != 0) {
            $result_data['msg']    = '1分钟内不能再次获取验证码';
            $result_data['status'] = false;
            return $result_data;
        }

        if ($num > 7){
            $result_data['msg']    = '短信发送超过上限';
            $result_data['status'] = false;
            return $result_data;
        }

        $message = new MessageUntils();
        $_code   = mt_rand(1000, 9999) . '';;
        $result  = $message->sendCCPSMS($phone, array($_code, '5分钟'), 252612);

        //添加本次输入数据
        $noteLog->id           = 0;
        $noteLog->phone        = $phone;
        $noteLog->template_msg = '【同联商业】您本次的验证码为：'.$_code.'，请于5分钟内正确输入，如非本人操作，请忽略此短信。';
        $noteLog->code         = $_code;
        $noteLog->send_time    = date('Y-m-d H:i:s');
        $noteLog->ip           = request()->ip();
        $noteLog->app_version  = '1.0.0';
        $result['statusCode'] = 0;

        //加密操作
        if ($result['statusCode'] == "000000") {
            $jwt = new JwtUntils();
            $noteLog->is_success = 1;
            $jwt_data['phone']   = $phone;
            $jwt_data['code']    = $_code;

            $result_data['sms_code']   = $_code;
            //生成token
            $result_data['token']  = $jwt->createToken($jwt_data);
            $result_data['status'] = true;
        } else {
            $noteLog->is_success = 2;
            $result_data['status'] = false;
        }
        //将数据保存到库中
        $noteLog->save();
        return $result_data;
    }
}
