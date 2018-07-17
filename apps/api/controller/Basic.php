<?php

namespace app\api\controller;

use app\common\model\Member;
use think\Config;
use think\Controller;
use think\Db;
use think\Request;
use think\Response;
use app\common\untils\JwtUntils;
use think\Session;

class Basic extends Controller
{
    /**
     * 访问请求对象
     * @var Request
     */
    public $request;

    public $params;

    protected $authToken;
    /**
     * @var int userId
     */
    protected $userId;
    protected $userNick;
    protected $phone;
    protected $timeStamp_;
    protected $filterVerify = array(
        "admin/member",
        "api/sendSms",
        "api/logout",
        "api/login",
        "api/video",
        "api/report",
        "api/buildings",
        "api/user",
        "api/video",
        "api/member",
        "api/follow",
        "api/behavior"
    );

    /**
     * 基础接口SDK
     * @param Request|null $request
     */
    public function __construct(Request $request = null)
    {
        // CORS 跨域 Options 检测响应
        $this->corsOptionsHandler();
        // 输入对象
        $this->request = is_null($request) ? Request::instance() : $request;

        if (strtoupper($this->request->method()) === "GET") {
            $this->params = $this->request->param();
        } elseif (strtoupper($this->request->method()) === "POST") {
            $this->params = $this->request->param() != null ? $this->request->param() : null;
        }
        if (isset($this->params['authToken']) && $this->params['authToken'] != 'null' && !empty($this->params['authToken'])) {
            $res = new JwtUntils();
            //获取APP传来的token
            $user = $res->getDecode($this->params['authToken']);
            $this->userId   = $user['data']['id'];
            $this->phone    = $user['data']['phone'];
            //$this->userNick = $user['data']['nickname'];
        }
        $requestPath = $this->request->routeInfo()["rule"][0] . "/" . $this->request->routeInfo()["rule"][1];
        //过滤掉不需要验证token的接口
        if (!in_array(trim($requestPath), $this->filterVerify)) {
            $this->tokenVerify();
        }
    }

    /**
     * token 验证
     */
    public function tokenVerify()
    {
        /**
         * 测试[安全退出登录]
         * by songjian
         */
        //$invite_code = Db::table('yf_hf_member')->field(['invite_code'])->where('id',$this->userId)->find()['invite_code'];
        //$token = Session::get("$invite_code");
        /*if (empty($token)){
            echo json_encode(array( "code" => "300", "message" => "您已安全退出登录！"),JSON_UNESCAPED_UNICODE);
            exit;
        }*/
        if (!isset($this->params['authToken']) || empty($this->params['authToken'])) {
            echo json_encode(array( "code" => "300", "message" => "authToken不能为空！"),JSON_UNESCAPED_UNICODE);
            exit;
        }
        /*$token = Session::get('authToken');
        if ($this->params['authToken'] != $token) {
            echo json_encode(array( "code" => "300", "message" => "authToken验证失败,请重新登录！"),JSON_UNESCAPED_UNICODE);
            exit;
        }*/
        //$this->verifyUserInfo();
        //判断时间是否过期
        /*if (Config::get('session_out_time') == true){
            $this->verifyTime();
        }*/
    }


    /**
     * 判断过期时间
     * by songjian
     */
    public function verifyTime()
    {
        //authToken有效期为30天
        if ((time() - $this->timeStamp_) > 2592000) {
            echo json_encode(array( "code" => "300", "message" => "AuthToken失效，请重新登录！"),JSON_UNESCAPED_UNICODE);
            exit;
        }
    }

    public function verifyUserInfo()
    {
        $userModel = new Member();
        $userArr = $userModel->where('id',$this->userId);
        if (count($userArr) > 1 && ($userArr->id != $this->userId )) {
            echo json_encode(array( "code" => "300", "message" => "用户验证失败，重新登录！"),JSON_UNESCAPED_UNICODE);
            exit;
        }
        return true;
    }

    /**
     * 输出返回数据
     * @param string $msg 提示消息内容
     * @param string $code 业务状态码
     * @param mixed $data 要返回的数据
     * @param string $type 返回类型 JSON XML
     * @return Response
     */
    public function response($code = 'SUCCESS', $msg, $data = [], $type = 'json')
    {
        $result = [ 'code' => $code, 'message' => $msg, 'data' => $data, 'type' => strtolower($type) ];
        return Response::create($result, $type);
    }

    /**
     * Cors Options 授权处理
     */
    public static function corsOptionsHandler()
    {
        if (request()->isOptions()) {
            header('Access-Control-Allow-Origin:*');
            header('Access-Control-Allow-Headers:Accept,Referer,Host,Keep-Alive,User-Agent,X-Requested-With,Cache-Control,Content-Type,Cookie,token');
            header('Access-Control-Allow-Credentials:true');
            header('Access-Control-Allow-Methods:GET,POST,OPTIONS');
            header('Access-Control-Max-Age:1728000');
            header('Content-Type:text/plain charset=UTF-8');
            header('Content-Length: 0', true);
            header('status: 204');
            header('HTTP/1.0 204 No Content');
            exit;
        }
    }

    /**
     * 获取当前用户app版本
     * by songjian
     * @return string
     */
    public function getVersion(){
        $version = Db::table('yf_hf_member')->field('app_version')->where('id',$this->userId)->find()['app_version'];
        return $version;
    }
}
