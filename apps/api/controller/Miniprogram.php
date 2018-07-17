<?php

namespace app\api\controller;

use think\Controller;
use think\Log;
use think\Request;

class Miniprogram extends Controller
{
    /**
     * 显示资源列表
     *
     * @return \think\Response
     */
    public function index()
    {
        echo "index";
    }

    /**
     * 获取小程序unionid(根据unionid检查记录添加或修改)
     * 小程序的openid,unionid,session_key
     * @author qin 2018-07-04
     */
    public function getUnionId()
    {
        $code = input("code", '', 'htmlspecialchars_decode');
        Log::info("=====getUnionId======");
        Log::info(input("post."));

        //请求微信接口
        $params = [
            'appid' => 'wxd97d71e139c34cf7',
            'secret' => '4c2f121bc96de2c4bc042fd13ec1dd40',
            'js_code' => $code,
            'grant_type' => 'authorization_code'
        ];
        $res = file_get_contents("https://api.weixin.qq.com/sns/jscode2session?appid={$params['appid']}&secret={$params['secret']}&js_code={$params['js_code']}&grant_type=authorization_code");
        Log::info("=====getUnionId1======");
        Log::info($res);

        $wx_data=json_decode($res,true);
        Log::info($wx_data);
        Log::info("session_key:".$wx_data['session_key']);
        Log::info("openid:".$wx_data['openid']);
        Log::info("unionid:".$wx_data['unionid']);

        //cache($session3rd, $data['unionId'] . $sessionKey);
    }

    /**
     * 显示创建资源表单页.
     *
     * @return \think\Response
     */
    public function create()
    {
        //
    }

    /**
     * 保存新建的资源
     *
     * @param  \think\Request  $request
     * @return \think\Response
     */
    public function save(Request $request)
    {
        //
    }

    /**
     * 显示指定的资源
     *
     * @param  int  $id
     * @return \think\Response
     */
    public function read($id)
    {
        //
    }

    /**
     * 显示编辑资源表单页.
     *
     * @param  int  $id
     * @return \think\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * 保存更新的资源
     *
     * @param  \think\Request  $request
     * @param  int  $id
     * @return \think\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * 删除指定资源
     *
     * @param  int  $id
     * @return \think\Response
     */
    public function delete($id)
    {
        //
    }
}
