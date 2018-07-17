<?php
/**
 * 使用于微信网页授权
 * User: ASUS
 * Date: 2018/5/11
 * Time: 16:28
 */

namespace app\api\controller;


use app\api\model\Wxauth;
use think\Db;
use think\Exception;
use think\Log;
use think\Request;

class Wxpublic
{
    public function __construct(Request $request = null)
    {
        $this->wechatModel = new Wxauth();
        //define("TOKEN", "haifang");
        define('APPID', 'wxfb04e0c5fd994aa9'); //应用唯一标识，在微信开放平台提交应用审核通过后获得
        define('APPKEY', 'bd351d778132bdeb916771fae476604b');  //应用密钥AppSecret，在微信开放平台提交应用审核通过后获得
        //判断用户的token值是否正确
        //$this->valid();
    }

    /**
     * 只执行一次验证微信token
     * by wechat
     */
    public function valid()
    {
        $echoStr = $_GET["echostr"];
        //valid signature , option
        if($this->checkSignature()){
            echo $echoStr;
            exit;
        }
    }

    /**
     * 只执行一次验证微信token
     * by wechat
     */
    private function checkSignature()
    {
        // you must define TOKEN by yourself
        if (!defined("TOKEN")) {
            throw new Exception('TOKEN is not defined!');
        }

        $signature = $_GET["signature"];
        $timestamp = $_GET["timestamp"];
        $nonce = $_GET["nonce"];

        $token = TOKEN;
        $tmpArr = array($token, $timestamp, $nonce);
        // use SORT_STRING rule
        sort($tmpArr, SORT_STRING);
        $tmpStr = implode( $tmpArr );
        $tmpStr = sha1( $tmpStr );

        if( $tmpStr == $signature ){
            return true;
        }else{
            return false;
        }
    }

    /**
     * 微信用户同意授权，获取code
     * by songjian
     * https://open.weixin.qq.com/connect/oauth2/authorize?appid=".APPID."&redirect_uri=http%3A%2F%2Fwww.haifang.com&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect
     */

    /**
     * 通过code换取网页授权access_token
     * by songjian
     */
    public function getTokens($code){
        $apidata = array(
            "appid"=> APPID,
            "secret"=> APPKEY,
            "code"=> $code,
            "grant_type"=> 'authorization_code',
        );
        $api = "https://api.weixin.qq.com/sns/oauth2/access_token?".http_build_query($apidata);
        $res = Tool::httpRequest($api);
        return $res;
    }

    /**
     * 检验授权凭证（access_token）是否有效\GET（请使用https协议）
     * by songjian
     */
    public function checkToken(){
        $apidata = array(
            "access_token"=>"ACCESS_TOKEN",
            "openid"=>"OPENID",
        );
        $api = "https://api.weixin.qq.com/sns/auth?".http_build_query($apidata);
        $res = Tool::httpRequest($api);
        return $res;
    }

    /**
     * 刷新access_token（如果需要）
     * by songjian
     */
    public function refreshToken(){
        $apidata = array(
            "appid"=> APPID,
            "grant_type"=> 'refresh_token',
            "refresh_token"=> 'REFRESH_TOKEN',
        );
        $api = "https://api.weixin.qq.com/sns/oauth2/refresh_token?".http_build_query($apidata);
        $res = Tool::httpRequest($api);
        var_dump($res);exit;
    }

    /**
     * 拉取用户信息(需scope为 snsapi_userinfo\GET（请使用https协议）)
     * by songjian
     */
    public function getInfo($access_token,$open_id){
        $apidata = array(
            "access_token"=>$access_token,
            "openid"=>$open_id,
            "lang"=>"zh_CN"
        );
        $api = "https://api.weixin.qq.com/sns/userinfo?".http_build_query($apidata);
        $res = Tool::httpRequest($api);
        return $res;
    }

    /**
     * 真实调用接口，获取用户信息，插入数据库
     * by songjian
     **/
    public function getUserInfo(Request $request){
        $data['code'] = 101;
        $data['message'] = '';
        $code = $request->get('code');
        $type = $request->get('type');
        $web = $request->get('web');
        $ress = $this->getTokens($code);
        $access_token = $ress['access_token'];
        $open_id = $ress['openid'];
        $res = $this->getInfo($access_token,$open_id);
        //判断是否需要插库
        $id = $this->insertUserInfo($res);
        if ($id == 11){
            $data['code'] = 200;
            $data['message'] = '此信息数据库内已存在';
            $data['data'] = $res;
        }else{
            $data['code'] = 200;
            $data['message'] = '此信息数据库内不存在，已添加';
            $data['data'] = $res;
        }
        /**
         * update
         * 返回微信信息屏蔽
         */
        //若type=1 则是分享视频 type=2 则是邀请用户注册
        if ($type == 1){
            if ($web){
                $web = base64_decode($web);
                $website = base64_decode($request->get('state'));
                //分享视频得红包-判断观看的视频是否是分享观看的数据
                Log::info("============================share-weixin============================");
                Log::info($data);
                Video::shareWatch($data['data']['unionid'],$website);
                Log::info("============================share-weixin1============================");
                echo "<script>window.location =\"{$web}\";</script>";
            }
        }elseif ($type == 2){
            //此web页面为邀请注册页面
            $info = Db::table('yf_hf_member')->where('unionid',$data['data']['unionid'])->find();
            if (empty($info['phone'])){
                //跳转邀请注册页面
                //$member_id = Db::table('yf_hf_member')->field(['id'])->where('openid',$open_id)->find()['id'];
                $web = base64_decode($web);
                $web .= "&member_id={$info['id']}";
                echo "<script>window.location =\"{$web}\";</script>";
            }else{
                //跳转下载页面
                echo "<script>window.location = \"https://hifang.fujuhaofang.com/web/index.html#/weixinDownload\"</script>";
            }
        }
    }

    /**
     * 通过微信网页授权返回的用户信息插入到数据库中
     * by songjian
     */
    public function insertUserInfo($info){
        //通过unionid参数来判断库中是否存在
        $unionid = $info['unionid'];
        $res = Db::table('yf_hf_member')->where('unionid',$unionid)->count();
        if ($res == 0){
            //将用户信息添加到库中
            $hiid = Tool::createRand();//创建嗨房id
            $result = $this->wechatModel->insertUserInfo($info,$hiid);
            return $result;
        }else{
            //若该用户存在表内，则进行下一步逻辑
            return 11;
        }
    }
}