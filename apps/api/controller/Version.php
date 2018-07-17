<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/5/4
 * Time: 10:34
 */
namespace app\api\controller;

use app\common\model\AppVersion;
use think\Db;
use think\Log;
use think\Request;

class Version
{
    public function __construct()
    {
        $this->appVersion = new AppVersion();
    }
    /**
     * 获取最近版本号
     * @return \think\Response
     */
    public function getVersionNo(Request $req)
    {
        header("Access-Control-Allow-Origin: *");
        $type = $req->get("type");
        $version = $req->get("version");
        if ($type == 1) { //安卓
            $versionResult = $this->appVersion->getVersion($type);
            if ($versionResult) {
                $versionResult['intro'] = explode(';',$versionResult['intro']);
                $result['code'] = 200;
                $result['msg'] = '查询成功';
                $result['data'] = $versionResult;
            } else {
                $result['code'] = 200;
                $result['msg'] = '查询数据为空';
            }
        } elseif ($type == 2) {//ios
            if ($version) {
                $versionResult = $this->appVersion->getVersion($type);
                if ($versionResult) {
                    $versionResult['intro'] = explode(';',$versionResult['intro']);
                    if ($version == $versionResult['version_no']) {
                        $result['code'] = 200;
                        $result['msg'] = '已经是最新版本了,不需要更新哦';
                        $versionResult['code'] = 0;
                        $result['data'] = $versionResult;
                    } else {
                        $result['code'] = 200;
                        $result['msg'] = '查询成功';
                        $versionResult['code'] = 1;
                        $result['data'] = $versionResult;
                    }
                } else {
                    $result['code'] = 200;
                    $result['msg'] = '查询数据为空';
                }
            } else {
                $versionResult = $this->appVersion->getVersion($type);
                if ($versionResult) {
                    $versionResult['intro'] = explode(';',$versionResult['intro']);
                    $result['code'] = 200;
                    $result['msg'] = '查询成功';
                    $result['data'] = $versionResult;
                } else {
                    $result['code'] = 200;
                    $result['msg'] = '查询数据为空';
                }
            }
        }
        return json_encode($result,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 首页接口 ios专用
     * @param Request $req
     * @return string
     * @auther zyt
     */
    public function homePage (Request $req)
    {
        $result['code']    = 101;
        $result['message'] = '';
        $version = $req->get('version');
        //获取 ios 最新版本号
        $versions = Db::table('yf_hf_version')->where('type',2)->order('update_time desc')->select()[0];

        //qin 2018-06-09
        Log::info("=======homePage=========");
        Log::info($versions);
        Log::info($version);
        if($version){
            Log::info("=======homePage1=========");
            if ($version != $versions['version_no']) {
                Log::info("=======homePage3=========");
                $code = 2;//通过
            }else{
                Log::info("=======homePage4=========");
                if($versions['status'] == 1){
                    Log::info("=======homePage5=========");
                    $code = 2;//通过
                }else{
                    Log::info("=======homePage6=========");
                    $code = 1;//审核
                }
            }
        }else{
            Log::info("=======homePage2=========");
            $code = 2;//通过
        }
        /*
        if ($version != $versions['version_no']) {
            $code = 2;
        } elseif ($version == $versions['version_no'] && $versions['status'] == 1) {
            $code = 2;
        } else {
            $code = 1;
        }
        */
        
        //审核中1  2审核通过
        $data = [
            'code'      => $code,
            'img'       => 'https://yftest.fujuhaofang.com/uploads/picture/2018-05-22/5b03780844e04.png',
            'text'      => "福居嗨房是一个原创短视频社区平台,致力于打破现有房地产信息平台上虚假房源,虚假宣传的乱象,为经纪人和消费者提供真实的房源信息,同时帮助经纪人打造个人品牌。\r\n\r\n福居嗨房采用时下最流行的基于区块链的token经济模型,对用户进行多次优于物质的激励,使经纪人和消费者的角色发生变化,在不同的时间轴上贡献出自己的权重。\r\n\r\n福居嗨房的目标是服务百万经纪人和千万消费者!\r\n\r\n ",
            'button'    => [
                'button_text' => '进入',
                'button_key'  => 'publish'
            ],
        ];

        /*$data1 = [
            'code'      => 2,
            'img'       => 'https://yftest.fujuhaofang.com/uploads/picture/2018-05-22/5b03780844e04.png',
            'text'      =>[
                ['title'=>'xxx1','content'=>'conent1'],
                ['title'=>'xxx2','content'=>'conent2'],
                ['title'=>'xxx3','content'=>'conent3'],
                ['title'=>'xxx4','content'=>'conent4'],
            ],
            'button'    => [
                'button_text' => '进入',
                'button_key'  => 'publish'
            ],
        ];*/

        $result['code'] = 200;
        $result['message'] = '操作成功';
        $result['data'] = $data;
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     * 登录控制手机验证码登录--ios专用
     * @param Request $req
     * @return string
     * @auther zyt
     */
    public function iosBeforeLogin (Request $req)
    {
        $result['code']    = 101;
        $result['message'] = '';
        $version = $req->get('version');
        //获取 ios 最新版本号
        $versions = Db::table('yf_hf_version')->where('type',2)->order('update_time desc')->select()[0];

        if($version){
            if ($version != $versions['version_no']) {//1.1.0
                $code = 1;//不显示
            } else{
                //status 0审核中 1审核通过
                if ($versions['status'] == 1) {
                    $code = 1;//不显示
                } else {
                    $code = 2;//显示
                }
            }
        }else{
            //无版本号
            $code = 1;//不显示
        }



        //1手机号登录不可用  2手机号登录可用
        $data = [
            'code'      => $code,
            'text'      => "手机号登录 ",
        ];

        $result['code'] = 200;
        $result['message'] = '操作成功';
        $result['data'] = $data;
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }
}