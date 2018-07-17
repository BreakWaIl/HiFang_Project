<?php
/**
 * Created by PhpStorm.
 * User: ASUS
 * Date: 2018/5/2
 * Time: 10:25
 */

namespace app\api\controller;


use alipay\aop\request\AlipayUserInfoAuthRequest;
use alipay\aop\AopClient;
use alipay\aop\request\AlipayFundTransToaccountTransferRequest;
use alipay\aop\request\AlipaySystemOauthTokenRequest;
use alipay\aop\request\AlipayUserInfoShareRequest;
use app\admin\controller\Member;
use think\Db;
use think\Exception;
use think\Log;
use think\Request;

class Alipay extends Basic
{
    public $member;
    public function __construct($request = null)
    {
        parent::__construct($request);
        $mix_money = Tool::getConfigInfo(69);
        //一块钱兑换嗨币
        $exchange_icon = Tool::getConfigInfo(75);
        //满足多少钱可提现到支付宝
        $put_forword_alipay = Tool::getConfigInfo(72);
        define('MIXMONEY',$mix_money);
        define('EXCHANGEICON',$exchange_icon);
        define('PUTFORWORDALIPAY',$put_forword_alipay);
        define('APPID', '2018050960120163'); //应用唯一标识，在平台提交应用审核通过后获得
        define('PRIVATEKEY', 'MIIEpAIBAAKCAQEAxeY3hqS6rVDnxaWns+ZFrXkl9ffHq7fK0MA32/yGwd1SKmOQdm/z8bzw80xLsWB0PUPXn5Pl/BN+02Y5jJRGjAlvgPsG/rNPMLxvwbFAVuRQW7OHz0e+wvXrWBKgdO3UxJAccgG9qtLRttWktPUKXoE8PyQ8ZeldyyQJaKV1ku7JxBKF122a5aQrIJ/6EWQDZ70z9nY5PN5EuVkEeL/fSOTJvlMYzcSoGvGUDADHhqwC7ae38LiVZ1XT2piQ3kwnEHvOLjISFooAKpzMpl2e2uDtmb/YRjQAuq+1eoIiN+uBpdLxTglZesnMBlbtSwgsDuw25CcbrxjC5henqfTuIwIDAQABAoIBACGrT1sa/5+pGiWoT2XuEYC4EdtNMq1mcZ0eduJ4jjzBeM85bUSZO3mvWZcrLd2ZuW0K8850jTZb4sH4rGXcfDwrBst86e2/eAOkq6baj0W5RmqzmrGLVUs6J7YuRRpftElU82H6JdjAUWm343PeFMuLVUKw2Y3FLG35TZh+PginRoRlLDIPMXLElAsxFqCCPDfwQlaOhAU9qx22D/sm57uZiB0btXhsZw5bohEQ/n2CZ16LW3fMC91H8oVLU/OjlsIjALiYbeXoDpl0VxnPkmT4fedGjlyWiKCGiCpyCBQpt6JWQeVIfbyiIXUSR17PIu0wW50wXSet0JSC0Bdoy3ECgYEA/qIr0PKTDCnMm5fnzqWCtCpc77ni7UgHLvYOSuJQD3mgNHRHkvAKxYjUgJdCkUcMsuzmx+EzuoSWgD8Ai6j7ImcjewioVUVlCm2jcv48ZirF8TjjAYK9/Uzk59TuR5krOFVAopW/jPQPl91Ucw0z4+7uddLDatbyD0rlXbXUsX0CgYEAxvYZ8GCHRXKN4zRLNRLeZmELWv5tTuacwmM/Y9QWBO05YqvnL/54L75dK2jq2wqQpOLMMAusQvRK+MA9qyNrIxy+44atRIvx7pYDTU0Ob4yLJYcC0o8AKBgUiKdRZZFBaoNcWNUpocunvft2vCgZB2rPZzbcLNNOsPs6Q9dcMB8CgYAUMC9hJZpbAIVkYKrUS3MNbb5ok0hWn7tSEdgYP9ExKOd2wTFbiQSRnMOcXmG8uvFazkWN22EKjLCSAmy8pe0jUSITAyC1ggb8yKyI1Xdcck+3TFdTK1Z82rfbWZp6ur4efUPeoBjLyB3kYHvtk0Jl8++cD9XGhrwyUjHVODFg0QKBgQCsOj8r+LNAJ7CxXAQ6VjIU1663vwSqRzCtiLJH3UCOVTfWtU30Gsi5M4V9XV3n7NZXFUiB0qj0cHoxqF/5tDg69dg8Jsn4S1hLGqqTEMANSdDt1FhaIpWVH3su6/+m9z10UW/wKd3XA+8ZowMeT2uTIx+UjkW7u9MjmuXN8jAIKwKBgQCsYK48N9o2NcaSCJcmMQP0mguLH3VnBhW4tMXFsUqAvkCHc+GWGp4WXU7cWGsmkwTh9/78TaW06oV5uc3zdz9dVpn8QgjDWHzf7Gkn4q9ATlI/+TiQKOrQ62C2Fdfs759Ru6DXrSxAoD8gG84d86Zw729Yz62OB+np74JNxKPDig==');  //应用私钥
        define('PUBLICKEY','MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAgF0FETte7MwoxktJyYzkRARnWjzKYPqJtnhqkzuNsKoptox/Y/tysd71/q2w4aMM6mjJ9h+unYbGJgKeULd69M5VCrU/GMP2N9rubmXZwCVEORqnBglBDkscNtl8OFmAl4A2iOju+d6c5n2iJxvKzmDzX0tKa4C5Yem8ndUOxMbkPlpYwEy90t0VAUk8J4pMSW+ODSxTgLR1OYQTysPhjFv1Ad/YFZfPpmlcX2kYTGImOxB/mr/hJ8XpIw53udUFQlIdf7SGzLX7o9R+eOrdq7eIuNjQPL3T/xmg9We4mIqKp98vh6ty7wjGkIMCalPxSr8E1NNzeRClxu8beVud4wIDAQAB');  //公钥

        $this->member = new Member();
    }
    /**
     * 回调地址
     * by songjian
     */
    public function redirects_(){

    }

    /**
     * 获取支付宝最小提现额及本用户现金
     * by songjian
     */
    public function getMixMoney(){
        $data['code'] = 101;
        $data['message'] = '';
        $userid = $this->userId;
        $balance = Db::table("yf_hf_member")->field(['balance'])->where('id',$userid)->find()['balance'];
        //一块钱兑换嗨币
        $exchange_icon = Tool::getConfigInfo(75);
        $user_icon = (string)($balance/$exchange_icon);
        $res = Tool::getConfigInfo(72);
        if (!$res){
            $data['message'] = '查询支付宝提现额及本用户现金失败';
        }else{
            $put_forward_money = Tool::getConfigInfo(78);
            $put_forward       = explode('，',$put_forward_money);
            $data['code'] = 200;
            $data['message'] = '查询支付宝最小提现额及本用户现金成功';
            $data['data']['put_forward_money'] = $put_forward;
            $data['data']['exchange_icon'] = $exchange_icon;
            $data['data']['user_icon'] = $user_icon;
            $data['data']['mix_money'] = $res;
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 在做支付宝提现之前要先通过短信验证一下[发送验证码]
     * by songjian
     * @return json
     */
    public function sendSmsGetReadyMoney(){
        $res = $this->member->getReadyMoney(Request::instance());
        return $res;
    }

    /**
     * 提现之前进行短信验证，若成功后进行授权、提现等规则
     * by songjian
     * @return json
     */
    public function checkGetReadyMoenyCode(Request $request){
        $data['code'] = 101;
        $data['message'] = '';
        $code = $request->post('code');
        $phone = $request->post('phone');
        if (empty($code)){
            $data['code'] = 100;
            $data['message'] = '验证码为空，请输入邀请码';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        $res = $this->member->check_code($phone,$code);
        if ($res == 200){
            $data['code'] = 200;
            $data['message']  = '验证码正确，验证成功';
        }elseif($res == 101){
            $data['code'] = 101;
            $data['message']  = '验证码已经过期';
        }elseif ($res==102){
            $data['code'] = 102;
            $data['message']  = '验证码错误';
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 用户支付宝授权成功后将用户id和支付宝唯一id放入关联表
     * by songjian
     * @return json
     */
    public function updateUserAndAlipay(Request $request){
        $data['code'] = 101;
        $data['message'] = '';
        $member_id = $this->userId;
        $alipay_id = $request->post('payee_account');
        $count = Db::table('yf_hf_alipay_users')->where('member_id',$member_id)->count();
        if ($count == 0){
            $info = array(
                'id' => 0,
                'member_id' => $member_id,
                'alipay_id' => $alipay_id,
                'create_time'=>time(),
                'update_time'=>time()
            );
            $res = Db::table('yf_hf_alipay_users')->insert($info);
            if ($res){
                $data['code'] = 200;
                $data['message'] = '插入支付宝-用户关联表成功';
            }else{
                $data['code'] = 101;
                $data['message'] = '插入支付宝-用户关联表失败';
            }
        }else{
            $res = Db::table('yf_hf_alipay_users')
                    ->where('member_id',$member_id)
                    ->update(['alipay_id'=>$alipay_id,'update_time'=>time()]);
            if ($res){
                $data['code'] = 200;
                $data['message'] = '更新支付宝-用户关联表成功';
            }else{
                $data['code'] = 101;
                $data['message'] = '更新支付宝-用户关联表失败';
            }
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 用户进行假提现操作[实际情况下并不会真的提现转账，而是在详单表中加了一条记录，状态为审核中，后台修改后才能进行提现]
     * 但当提现金额小于"200"时不需要进行审核操作
     * by songjian
     * @return json
     */
    public function getMoneyStatus(Request $request){
        Log::info(input('post.'));
        $datas['code'] = 101;
        $datas['message'] = '';
        $user_id = $this->userId;                               //本人id
        $withdrawals_id = $this->userId;                        //提现id
        $money = $request->post('amount');                      //实际金额
        $type = 5;                                              //现金类型
        $status = 0;                                            //交易进行状态
        $pay_status = 0;                                        //支付状态
        $payee_account = $request->post('payee_account');       //支付宝用户唯一id
        $payer_show_name = '嗨房提现操作';                      //转账名称
        //$payee_real_name = $request->post('payee_real_name');   //账号真实名称
        $remarks = '备注';                                      //备注
        $order_id = Tool::getOrder();                           //支付宝交易码
        //$nickname = $request->post('nickname');                 //支付宝昵称
        //$avatar = $request->post('avatar');                     //支付宝头像
        $app_version = $this->getVersion();
        $create_time = time();
        $update_time = time();
        //支付宝【转账日期】【实际转账金额】【交易进行状态】【支付状态】是等到真正转账状态完成之后再去修改纪录
        $data = array(
            'id'        => 0,
            'member_id' => $user_id,
            'withdrawals_id' => $withdrawals_id,
            'money' => $money*EXCHANGEICON,
            'type' => $type,
            'status' => $status,
            'pay_status' => $pay_status,
            'payee_account' => $payee_account,
            'payer_show_name' => $payer_show_name,
            //'payee_real_name' => $payee_real_name,
            'remarks' => $remarks,
            'order_id' => $order_id,
            //'nickname' => $nickname,
            //'avatar' => $avatar,
            'app_version' => $app_version,
            'create_time' => $create_time,
            'update_time' => $update_time
        );
        $user_balance = Db::table('yf_hf_member')->field(['balance'])->where('id',$user_id)->find()['balance'];
        if ($money > $user_balance/EXCHANGEICON ){
            $datas['code'] = 101;
            $datas['message'] = "用户现金不足";
            return json_encode($datas,JSON_UNESCAPED_UNICODE);
        }
       /* //当提现金额不满足最小体现额时
        if ($money < PUTFORWORDALIPAY){
            $thimoney = PUTFORWORDALIPAY;
            $data['code'] = 101;
            $data['message'] = '请提现至少'.$thimoney.'元';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }*/
        //但当提现金额小于?时不需要进行审核操作
        if ($money <= MIXMONEY){
            Db::startTrans();
            //开始事务
            try{
                $user_balance = Db::table('yf_hf_member')->field(['balance'])->where('id',$user_id)->find()['balance'];
                if ($money > $user_balance/EXCHANGEICON ){
                    $datas['code'] = 101;
                    $datas['message'] = "用户现金不足";
                    return json_encode($datas,JSON_UNESCAPED_UNICODE);
                }
                $res1 = $this->getMoney($order_id,$money,$payee_account,$payer_show_name,$payee_real_name='',$remarks);
                $result = json_decode($res1);
                if ($result->code == 200){
                    $data['status'] = 1;
                }else{
                    $data['status'] = 2;
                }
                $res2= Db::table('yf_hf_account_details')->insert($data);
                if ($data['status'] == 1){
                    //若插入数据成功了，则对用户表中的现金余额做更新
                    $balance = Db::table('yf_hf_member')->field(['balance'])->where('id',$this->userId)->find()['balance'];
                    if ($balance >= ($money*EXCHANGEICON)){
                        $real_balance = ($balance-($money*EXCHANGEICON));
                        Db::table('yf_hf_member')->where('id',$this->userId)->update(['balance'=>$real_balance]);
                    }else{
                        $datas['message'] = "用户现金不足";
                        return json_encode($datas,JSON_UNESCAPED_UNICODE);
                    }
                }
                Db::commit();
                return $res1;
            }catch (Exception $e){
                //回滚事务
                Db::rollback();
                $datas['message'] = "操作失败！请联系管理员";
                return json_encode($datas,JSON_UNESCAPED_UNICODE);
            }
        }else{
            //将纪录插入账单详情表
            $res = Db::table('yf_hf_account_details')->insert($data);
            if ($res != 1 ){
                $datas['message'] = '提现信息请求有误，请重试';
            }else{
                //若插入数据成功了，则对用户表中的现金余额做更新
                $balance = Db::table('yf_hf_member')->field(['balance'])->where('id',$this->userId)->find()['balance'];
                if ($balance >= ($money*EXCHANGEICON)) {
                    $real_balance = ($balance - ($money * EXCHANGEICON));
                    Db::table('yf_hf_member')->where('id', $this->userId)->update(['balance' => $real_balance]);
                }
                $datas['code'] = 200;
                $datas['message'] = '审核中';
            }
        }
        return json_encode($datas,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 管理员进行真提现操作[管理员修改了本记录的状态后，将提现继续进行]
     * by songjian
     * @return json
     */
    public function getMoney($order,$amount,$payee_account,$payer_show_name,$payee_real_name='',$remark){
        $data['code'] = 101;
        $data['message'] = '';
        $res = $this->getReadyMoney($order,$amount,$payee_account,$payer_show_name,$payee_real_name='',$remark);
        if (!$res){
            $data['code'] = 101;
            $data['message'] = '提现失败，请致电管理员：'.$res;
        }else{
            $data['code'] = 200;
            $data['message'] = '提现成功';
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 支付宝提现功能
     * by songjian
     * @return bool
     */
    public function getReadyMoney($order,$amount,$payee_account,$payer_show_name,$payee_real_name='',$remark){
        $aop = new AopClient();
        $aop->gatewayUrl = 'https://openapi.alipay.com/gateway.do';
        $aop->appId = APPID;                        //appid
        $aop->rsaPrivateKey = PRIVATEKEY;           //私钥
        $aop->alipayrsaPublicKey= PUBLICKEY;        //公钥
        $aop->apiVersion = '1.0';
        $aop->signType = 'RSA2';
        $aop->postCharset='UTF-8';
        $aop->format='json';
        $request = new AlipayFundTransToaccountTransferRequest();
        $request->setBizContent("{" .
            "\"out_biz_no\":\"$order\"," .
            "\"payee_type\":\"ALIPAY_USERID\"," .
            "\"payee_account\":\"$payee_account\"," .             //支付宝[唯一id]
            "\"amount\":\"$amount\"," .                           //金额
            "\"payer_show_name\":\"$payer_show_name\"," .         //转账名称
            "\"payee_real_name\":\"$payee_real_name\"," .         //账号真实名称
            "\"remark\":\"$remark\"" .                            //备注
            "}");
        $result = $aop->execute ($request);
        $responseNode = str_replace(".", "_", $request->getApiMethodName()) . "_response";
        $resultCode = $result->$responseNode->code;
        if(!empty($resultCode)&&$resultCode == 10000){
            return true;
        } else {
            return $resultCode;
        }
    }


    /**
     * 使用auth_code换取接口access_token及用户userId,并且调用接口获取用户信息
     * by songjian
     * @return json
     */
    public function getTokenAndUserId(Request $request){
        try {
            $code = trim($request->post('auth_code'));
            if (empty($code)) {
                throw new Exception('缺少参数', 101);
            }

            //获取access_token
            $aop = new AopClient ();
            $aop->gatewayUrl = 'https://openapi.alipay.com/gateway.do';
            $aop->appId = APPID;
            $aop->rsaPrivateKey = PRIVATEKEY;
            $aop->format = 'json';
            $aop->charset = 'UTF-8';
            $aop->signType = 'RSA2';
            $aop->alipayrsaPublicKey = PUBLICKEY;
            $aop->apiVersion = '1.0';
            $request = new AlipaySystemOauthTokenRequest();
            $request->setGrantType("authorization_code");
            $request->setCode($code);

            $result = $aop->execute($request);
            $responseNode = str_replace(".", "_", $request->getApiMethodName()) . "_response";
            $resultData = (array) $result->$responseNode;
            if (empty($resultData['access_token'])) {
                throw new Exception('获取access_token失败', 102);
            }
            //获取用户信息
            $request = new AlipayUserInfoShareRequest ();
            $result = $aop->execute ( $request , $resultData['access_token'] );
            $responseNode = str_replace(".", "_", $request->getApiMethodName()) . "_response";
            $userData = (array) $result->$responseNode;
            if (empty($userData['code']) || $userData['code'] != 10000) {
                throw new Exception('获取用户信息失败', 103);
            }
            /**
             * user_id  支付宝用户的userId
             * avatar   用户头像地址
             * province 省份名称
             * city 市名称。
             * nick_name    用户昵称
             * is_student_certified 是否是学生
             * user_type    用户类型（1/2）  1代表公司账户2代表个人账户
             * user_status  用户状态（Q/T/B/W）。 Q代表快速注册用户 T代表已认证用户 B代表被冻结账户 W代表已注册，未激活的账户
             * is_certified 是否通过实名认证。T是通过 F是没有实名认证。
             * gender   性别（F：女性；M：男性）。
             *
             */
            //业务逻辑
            return json_encode(['code' => 200, 'message' => '登录成功','data'=>$userData],JSON_UNESCAPED_UNICODE);
        } catch (Exception  $exception) {
            return  json_encode(['code' => $exception->getCode(), 'message' => $exception->getMessage()],JSON_UNESCAPED_UNICODE);
        }
    }

    /**
     * 加签方法[已废除]
     * by songjian
     */
    public function test(Request $request){

        $content = array();
        $content['subject'] = "商品的标题/交易标题/订单标题/订单关键字等";
        $content['out_trade_no'] = "商户网站唯一订单号";
        $content['timeout_express'] = "该笔订单允许的最晚付款时间";
        $content['total_amount'] = "订单总金额(必须定义成浮点型)";
        $content['product_code'] = "QUICK_MSECURITY_PAY";
        $con = json_encode($content);//$content是biz_content的值,将之转化成json字符串
        $aop = new AopClient ();

        $param['apiname'] = "com.alipay.account.auth";
        $param['product_id'] = "APP_FAST_LOGIN";
        $param['scope'] = "kuaijie";
        $param['pid'] = "2088721416601112";
        $param['auth_type'] = "AUTHACCOUNT";
        $param['biz_type'] = "openservice";
        $param['app_id'] = APPID;
        $param['target_id'] = "fujuhaifang1527218308694";
        $param['app_name'] = "mc";
       // $param['method'] = 'alipay.trade.app.pay';//接口名称，固定值
       // $param['charset'] = 'utf-8';//请求使用的编码格式
        $param['sign_type'] = 'RSA';//商户生成签名字符串所使用的签名算法类型      1
       // $param['timestamp'] = date("Y-m-d Hi:i:s");//发送请求的时间
       // $param['version'] = '1.0';//调用的接口版本，固定为：1.0
       // $param['notify_url'] = 'www.baidu.com';
        //$param['biz_content'] = $con;//业务请求参数的集合,长度不限,json格式，即前面一步得到的

        $paramStr = $aop->getSignContent($param);//组装请求签名参数
        $sign = $aop->alonersaSign($paramStr, "../extend/alipay/rsa_private_key.pem", 'RSA', true);//生成签名
        $param['sign'] = $sign;
        $str = $aop->getSignContentUrlencode($param);//最终请求参数
        return $str;
    }
}