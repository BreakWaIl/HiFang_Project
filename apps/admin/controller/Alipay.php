<?php
/**
 * Created by PhpStorm.
 * User: ASUS
 * Date: 2018/5/3
 * Time: 11:08
 */

namespace app\admin\controller;

use alipay\aop\AopClient;
use alipay\aop\request\AlipayFundTransToaccountTransferRequest;
use app\api\controller\Tool;
use think\Db;

class Alipay
{
    public function __construct()
    {
        //一块钱兑换嗨币
        $exchange_icon = Tool::getConfigInfo(75);
        define('EXCHANGEICON',$exchange_icon);
        define('APPID', '2017070407641437'); //应用唯一标识，在平台提交应用审核通过后获得
        define('PRIVATEKEY', 'MIIEogIBAAKCAQEAudnIHgOB3p5gJgaJjBcqjT/njS4a2fj+DwAwDJpANgWm1k0na3HrsVkDaxw7VIgHF5gGNSdnkQiDWmHSXqYmNqIlpaixVaPuGl18ld9P+8LifR2wmAU9M1dLQoLhZ6X/BR8k13R+WfSl/Jc1tVe0x0cmCuhZN4SbGoxSI2EIfosmVym0aGVwCFdA7Cw4pMdu7cJZG2Z6/yL06u1gi4/IWjtvtUb5338swZ4bSL+J1ZuaNSq9t6wKANUbm/nH8Nm8oatnner2iu/nz9wm3Ix41OtnwXNeIIxGmfbGvYxu5ZT5KcF3Gd5hbeKOgFWsJZ5Tz324wIoQ744wmprbhMrs7QIDAQABAoIBADyXw4X9kL77Fc/v+7Jf7zCkMCM4b+q3ImXTotbJB7xVNWLTPtHqD3T/13x5dOKHgwBvQT7dPQftJZ43HHZdZ0IStYGAMWkBjGSuLCtU5mfnzx4JqwS1WJG/mTrzHvhDB5Us5T8VrQg5GlDzH8Ci+r6p9L5DqKrQIh2SuEjunu1adIMraYncKBK1LSnJ0qVO/x0cX1kzoAmQX9DccAFMYOH41WB5PBT5VASvq+gwgHeUfVqvUyvnyQRIIMxfH0qsfBei7oQkQz9nBXNOZX37wo+R65ZW6qfMgg+lsHR3msTp/BKsSk7fr8dU8gtLMkuNGKd26zJNHbJpxjss8D+hqSUCgYEA3XYwwIft/uNPEMNFGP+xL8cBl6Zv4rkxjaBXhXiITfpu/qFxyGqnkDB0jv6yLYZoCqjUpxImnZim/g3UdKHfxAprKf9rWQpxFulIdq98hDWEzOE3fclIM+Zisx+y4Sk0U2pxMFgG3UzL54bb3vgrsWqcBY2KGn4Ai8T/+LdPWmcCgYEA1tXUua5v6yx4IQcwLdpVzSNVH8DQ3Q3tK2tESkMUrdQsojtyahaqepm4c4zLQMaeEsyI6fpxlW3t6GaxaZJifzV8JPL95zzSrGcBCsKw8GCdNoHXP0hPwZyQ1BpbS0hR07X86YSz0Q9DkJpa4hl7i7spoGXzoleJZRVm/aIsEYsCgYAB4rW7jey61NihfegitFqf24Pp9KLTPVxspkbYfhQ7BbzYMiuz1ySiF6eGaCjANnrATHuzCHaHtPsHArsiWxZ6ptQOwXv6gBpCZa4WRJw8y+/bhrdgPMx+lKGWgNiXDjDB3RAlpzo3vCWoTP+mQFqu4gd+DJx2aUg76Gt9hKIKVQKBgHw7hxog/2NVgdpHl9rMKVXJGs6T57QM+5tiGkl/ZRPoYC8ohU9H8CmZfwqC3n6E3KAuWvZC9y/cM/lyeSF9nyvEuBd91MnFaGZ94iJg14UJuZ/tkZVssYJakX22CBkOpxLwaGJ5dKpuUznpqKia59Cz2KyCiFLWoAMuTzJYd3dlAoGASItEdnGIGFf7YAmxrQphzmANkmiNwQloxWycSXbPVaeWHsBnu4RRg/Du+xY5wU63w0qOCGK7wk5SIziLZ2fXkA6jJSqgzOwthKQk9ro82LSdty42vFkPwKs07aIyvnGRYLxjaPEuto/gMBzJsk3GS4zqMvihJIfIr6rlQu+0zj4=');  //应用私钥
        define('PUBLICKEY','MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAgF0FETte7MwoxktJyYzkRARnWjzKYPqJtnhqkzuNsKoptox/Y/tysd71/q2w4aMM6mjJ9h+unYbGJgKeULd69M5VCrU/GMP2N9rubmXZwCVEORqnBglBDkscNtl8OFmAl4A2iOju+d6c5n2iJxvKzmDzX0tKa4C5Yem8ndUOxMbkPlpYwEy90t0VAUk8J4pMSW+ODSxTgLR1OYQTysPhjFv1Ad/YFZfPpmlcX2kYTGImOxB/mr/hJ8XpIw53udUFQlIdf7SGzLX7o9R+eOrdq7eIuNjQPL3T/xmg9We4mIqKp98vh6ty7wjGkIMCalPxSr8E1NNzeRClxu8beVud4wIDAQAB');  //公钥
    }

    /**
     * 管理员进行真提现操作[管理员修改了本记录的状态后，将提现继续进行]
     * by songjian
     * @return json
     */
    public function getMoney($id,$order,$amount,$payee_account,$payer_show_name,$payee_real_name='',$remark){
        $data['code'] = 101;
        $data['message'] = '';
        $res = $this->getReadyMoney($order,$amount,$payee_account,$payer_show_name,$payee_real_name,$remark);
        if ($res !== true){
            $data['code'] = 101;
            $data['message'] = $res;
        }else{
            //若提现成功了，则判断是否余额不足
            //连表查询
            //$result = Db::query("select m.id,m.balance from `yf_hf_member` as m INNER JOIN `yf_hf_account_details` as a on a.member_id = m.id where a.id={$id}");
            //if ($result[0]['balance']<($amount*EXCHANGEICON)){
            //    $data['code'] = 101;
            //    $data['message'] = '余额不足，提现失败';
            //}else{
                //若余额充足，则对用户表中的现金余额做更新
                //Db::table('yf_hf_member')->where('id',$result[0]['id'])->setDec('balance',$amount);
                //$real_balance = ($result[0]['balance']-($amount*EXCHANGEICON));
                //Db::table('yf_hf_member')->where('id',$result[0]['id'])->update(['balance'=>$real_balance]);
            $array = [
                'order:'=>$order,
                'amount:'=>$amount,
                'payee_account:'=>$payee_account,
                'payer_show_name:'=>$payer_show_name,
                'payee_real_name:'=>$payee_real_name,
                'remark:'=>$remark,
            ];
            //打印支付log日志
            $array = json_encode($array,JSON_UNESCAPED_UNICODE);
            file_put_contents("../paylog/pay.log", $array.PHP_EOL, FILE_APPEND);
            $data['code'] = 200;
            $data['message'] = '提现成功';
            //}
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
            "\"payee_account\":\"$payee_account\"," .             //支付宝账号
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
            return $responseNode;
        }
    }
}