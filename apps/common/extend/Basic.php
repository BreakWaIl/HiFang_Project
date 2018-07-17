<?php

namespace app\common\extend;

/**
 * Created by PhpStorm.
 * User: zw
 * Date: 2017/12/4
 * Time: 9:35
 * 基类
 */
use app\common\model\Users;
use think\Controller;
use think\Request;
use think\Response;
use Qiniu;

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
        "api/shopDetail",
        "admin/member",
        "api/logout",
        "api/login",
        "api/register",
        "api/shopList",
        "api/filtrateCondition",
        "api/shopDetail",
        "api/bannerList",
        "api/averagePriceAndTurnover",
        "api/getBroker",
        "api/brokerDetail",
        "api/commentAndDeal",
        "api/check_code",
        "api/convertOrderByTime",
        "api/convertCollectingBill",
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
        if (isset($this->params['AuthToken']) && $this->params['AuthToken'] != 'null' && !empty($this->params['AuthToken'])) {
            $jwt = new \Firebase\JWT\JWT();
            $this->authToken = $this->params['AuthToken'];return true;exit;
            $result = $jwt->decode($this->authToken, '123456', array( 'HS256' ));  //解码token
            $this->userId = $result->data->id;
            $this->phone = $result->data->phone;
            $this->userNick = $result->data->userNick;
            $this->timeStamp_ = $result->timeStamp_;
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
        if (!isset($this->params['AuthToken'])) {
            echo json_encode(array( "code" => "300", "msg" => "AuthToken不能为空！", "data" => [], "type" => "json" ));
            exit;
        }
        $this->verifyUserInfo();
        $this->verifyTime();
    }


    public function verifyTime()
    {
        //authToken有效期为30天
        if ((time() - $this->timeStamp_) > 2592000) {
            echo json_encode(array( "code" => "300", "msg" => "AuthToken失效，请重新登录！", "data" => [], "type" => "json" ));
            exit;
        }
    }

    public function verifyUserInfo()
    {
        $userModel = new Users();
        $userArr = $userModel->selectUser($this->userId);
        if (count($userArr) > 0 && ($userArr["id"] != $this->userId || $userArr["user_phone"] != $this->phone)) {
            echo json_encode(array( "code" => "300", "msg" => "用户验证失败，重新登录！", "data" => [], "type" => "json" ));
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
        $result = [ 'code' => $code, 'msg' => $msg, 'data' => $data, 'type' => strtolower($type) ];
        return Response::create($result, $type);
    }

    /**
     * 一维数据数组生成数据树
     * @param array $list 数据列表
     * @param string $id 父ID Key
     * @param string $pid ID Key
     * @param string $son 定义子数据Key
     * @return array
     */
    public static function arr2tree($list, $id = 'id', $pid = 'pid', $son = 'sub')
    {
        list($tree, $map) = [ [], [] ];
        foreach ($list as $item) {
            $map[$item[$id]] = $item;
        }
        foreach ($list as $item) {
            if (isset($item[$pid]) && isset($map[$item[$pid]])) {
                $map[$item[$pid]][$son][] = &$map[$item[$id]];
            } else {
                $tree[] = &$map[$item[$id]];
            }
        }
        unset($map);
        return $tree;
    }

    /**
     * 一维数据数组生成数据树
     * @param array $list 数据列表
     * @param string $id ID Key
     * @param string $pid 父ID Key
     * @param string $path
     * @param string $ppath
     * @return array
     */
    public static function arr2table(array $list, $id = 'id', $pid = 'pid', $path = 'path', $ppath = '')
    {
        $tree = [];
        foreach (self::arr2tree($list, $id, $pid) as $attr) {
            $attr[$path] = "{$ppath}-{$attr[$id]}";
            $attr['sub'] = isset($attr['sub']) ? $attr['sub'] : [];
            $attr['spl'] = str_repeat("&nbsp;&nbsp;&nbsp;├&nbsp;&nbsp;", substr_count($ppath, '-'));
            $sub = $attr['sub'];
            unset($attr['sub']);
            $tree[] = $attr;
            if (!empty($sub)) {
                $tree = array_merge($tree, (array)self::arr2table($sub, $id, $pid, $path, $attr[$path]));
            }
        }
        return $tree;
    }

    /**
     * 获取数据树子ID
     * @param array $list 数据列表
     * @param int $id 起始ID
     * @param string $key 子Key
     * @param string $pkey 父Key
     * @return array
     */
    public static function getArrSubIds($list, $id = 0, $key = 'id', $pkey = 'pid')
    {
        $ids = [ intval($id) ];
        foreach ($list as $vo) {
            if (intval($vo[$pkey]) > 0 && intval($vo[$pkey]) === intval($id)) {
                $ids = array_merge($ids, self::getArrSubIds($list, intval($vo[$key]), $key, $pkey));
            }
        }
        return $ids;
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
     * Cors Request Header信息
     * @return array
     */
    public static function corsRequestHander()
    {
        return [
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Credentials' => true,
            'Access-Control-Allow-Methods' => 'GET,POST,OPTIONS',
            'Access-Defined-X-Support' => 'service@cuci.cc',
            'Access-Defined-X-Servers' => 'Guangzhou Cuci Technology Co. Ltd',
        ];
    }


}


