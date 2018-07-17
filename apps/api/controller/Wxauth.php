<?php
/**
 * 适用于微信开放平台
 * User: zfc
 * Date: 2018/4/12
 * Time: 10:19
 */

namespace app\api\controller;


use app\common\untils\JwtUntils;
use think\Db;
use think\Request;

class Wxauth
{
    public function __construct(Request $request = null)
    {
        define('APPID', 'wxc3e6d6a646d78786'); //应用唯一标识，在微信开放平台提交应用审核通过后获得
        define('APPKEY', '831cf1ec178269e2cdd13832defb5a16');  //应用密钥AppSecret，在微信开放平台提交应用审核通过后获得
        //判断用户的token值是否正确
        //$this->checkAccessToken();
        $this->invite_title = Tool::getConfigInfo(70);
        $this->invite_info = Tool::getConfigInfo(71);

    }

    /**
     * 获取用户access_token和openid
     * by songjian
     * @return array
     */
    public function getToken($code,$grant_type='authorization_code')
    {
        //设置获取token和openid所需的参数
        $apiData = array(
            'appid'=> APPID,
            'secret'=> APPKEY,
            'code' => $code,    //	填写第一步获取的code参数
            'grant_type' => $grant_type
        );
        /*
         * https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
         *返回过来unionid/access_token/expires_in/ openid/scope/refreash_token
         */
        $api = "https://api.weixin.qq.com/sns/oauth2/access_token?".http_build_query($apiData);
        $data = Tool::httpRequest($api);
        return $data;
    }

    /**
     * 刷新过期时间[通过过期时间去刷新access_token过期时间]
     * 一般access_token的过期时间为两个小时
     * by songjian
     * @return array
     */
    public function refreshToken($grant_type='refresh_token',$refresh_token){
        //设置刷新更新时间所需的参数
        $apiData = array(
            'appid'=> APPID,
            'grant_type' => $grant_type,
            'refresh_token' => $refresh_token
        );
        /*
         * https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=APPID&grant_type=refresh_token&refresh_token=REFRESH_TOKEN
         *返回过来 access_token/expires_in/ openid/scope/refreash_token
         */
        $api = "https://api.weixin.qq.com/sns/oauth2/refresh_token?".http_build_query($apiData);
        $data = Tool::httpRequest($api);
        return $data;
    }

    /**
     * 检验授权凭证（access_token）是否有效
     * by songjian
     * @return array
     */
    public function checkAccessToken($access_token,$openid){
        //设置刷新更新时间所需的参数
        $apiData = array(
            'access_token'=> $access_token,
            'openid' => $openid
        );
        /*
         *https://api.weixin.qq.com/sns/auth?access_token=ACCESS_TOKEN&openid=OPENID
         *当错误时："errcode":40003,"errmsg":"invalid openid"
         */
        $api = "https://api.weixin.qq.com/sns/auth?".http_build_query($apiData);
        $data = Tool::httpRequest($api);
        return $data;
    }


    /**
     * 微信用户信息添加到数据库中
     * by songjian
     * @return json
     */
    public function addUserInfo($info='',$label='',$version='',$area_id='',$device_id='',$os=''){
        if (empty($info)){
            $data = array(
                'code' => 101,
                'msg'  => '没有传入微信授权信息'
            );
            return $data;
        }
        $res = Db::table('yf_hf_member')->where('unionid',$info['unionid'])->select();

        //如果没有则将用户信息添加到库中
        if (empty($res)){
            //将用户信息添加到库中
            $hiid = Tool::createRand();//创建嗨房id
            $userinfo = new \app\api\model\Wxauth();
            $userinfo->id = 0;
            $userinfo->label = $label;
            $userinfo->openid = $info['openid'];
            $userinfo->nickname = $info['nickname'];
            $userinfo->sex = $info['sex'];
            $userinfo->province = $info['province'];
            $userinfo->city = $info['city'];
            $userinfo->country = $info['country'];
            $userinfo->headimgurl = $info['headimgurl'];
            $userinfo->privilege = $info['privilege'];
            $userinfo->unionid = $info['unionid'];
            $userinfo->app_version = $version;
            $userinfo->hiid = $hiid;
            $userinfo->create_time = time();
            $userinfo->update_time = time();
            //后期添加地方区域
            $userinfo->area_id = $area_id;
            $userinfo->save();
            $id = $userinfo->getLastInsID();
            $res = Db::table('yf_hf_member')->where('id',$id)->find();  //用户信息
            //创建本人邀请码，更新到表中
            $invite_code = Tool::createCode($id);
            Db::table('yf_hf_member')->where('id',$id)->update(['invite_code'=>$invite_code]);
            //在device表中加入本用户手机的纪录，且一个用户只有一条记录
            $this->insertDevice($id,$device_id,$os);
        }else{
            //若属于微信网页授权登录的用户信息，登录app时将其补充
            if ($res[0]['openid'] == ''){
                $this->insertDevice($res[0]['id'],$device_id,$os);
                $invite_code = Tool::createCode($res[0]['id']);
                Db::table('yf_hf_member')->where('id',$res[0]['id'])->update(['openid'=>$info['openid'],'app_version'=>$version,'invite_code'=>$invite_code,'update_time'=>time()]);
            }
            $id = $res[0]['id'];
            //更新用户信息
            Db::table('yf_hf_member')->where('id',$id)->update(['app_version'=>$version,'update_time'=>time()]);
            $res = $res[0];   //用户信息

            //判断device_id是否与上一次相同，若不相同则更新纪录
            $old_info = Db::table('yf_hf_device')->field(['device_id','os'])->where('member_id',$id)->find();
            $tmp['version'] = $version;
            if ($device_id != $old_info['device_id'] && $os != $old_info['os']){
                $device_res = Db::table('yf_hf_device')
                    ->where('member_id',$id)
                    ->update(['device_id'=>$device_id,'os'=>$os,'update_time'=>time(),'version'=>$version]);
                if (!$device_res){
                    $data['code'] = 108;
                    $data['message'] = '插入device表失败，请联系后台管理员';
                    return $data;
                }
            }elseif ($device_id != $old_info['device_id'] && $os == $old_info['os']){
                $device_res = Db::table('yf_hf_device')
                    ->where('member_id',$id)
                    ->update(['device_id'=>$device_id,'update_time'=>time(),'version'=>$version]);
                if (!$device_res){
                    $data['code'] = 108;
                    $data['message'] = '插入device表失败，请联系后台管理员';
                    return $data;
                }
            }elseif ($device_id == $old_info['device_id'] && $os != $old_info['os']){
                $device_res = Db::table('yf_hf_device')
                    ->where('member_id',$id)
                    ->update(['os'=>$os,'update_time'=>time(),'version'=>$version]);
                if (!$device_res){
                    $data['code'] = 108;
                    $data['message'] = '插入device表失败，请联系后台管理员';
                    return $data;
                }
            }
        }

        //通过计算得出年龄
        $age = Tool::countAge($res['birthday']);

        //如果有则验证库内数据，返回data
        $jwt = new JwtUntils();
        //在这里修改token里面存放信息的多少
        $jwt_data['id'] = $id;
        $jwt_data['phone'] = $res['phone'];
        //$jwt_data['headimgurl'] = $userinfo['headimgurl'];
        $token  = $jwt->createToken($jwt_data);

        //查出该用户所在地区名
        $area = Db::table('yf_hf_area')->field(['dic_value'])->where('id',$res['area_id'])->find()['dic_value'];
        $data = array(
            'code' => 200,
            'message'  => '登陆成功',
            'data' => array(
                'phone'=> $res['phone'],
                'id' => (string)$id,
                'hiid' => (string)$res['hiid'],
                'nickname' => $res['nickname'],
                'is_power' => $res['is_power'],
                'headimgurl' => $res['headimgurl'],
                'invite_code' => $res['invite_code'],
                'age' => $age,
                'balance' => $res['balance'],
                'property'=> number_format($res['balance']/10 , 2), //资产 10个嗨币=1元
                'birthday' => $res['birthday'],
                'sex' => $res['sex'],
                'label' => $res['label'],
                'num_publish' =>$res['num_publish'],  //发布数
                'num_good_video' =>$res['num_good_video'],  //点赞数
                'num_follow' =>$res['num_follow'],  //粉丝数
                'sign' => $res['sign'],   //个性签名
                'area' => $area,          //该用户地区
                'invite_title' => $this->invite_title,  //邀请栏标题
                'invite_info' => $this->invite_info,   //邀请栏详情
                'app_version' => $res['app_version'],
                'authToken' => $token,
            )
        );
        return $data;
    }

    /**
     * 校对用户信息并获取用户个人信息
     * by songjian
     * @return array
     */
    public function checkUserInfo(Request $request)
    {
        $info['code'] = 101;
        $info['message'] = '';
        //获取身份标签
        $label = $request->post('label');
        //需要获取app返回来的code
        $code = $request->post('code');
        //获取此app的版本
        $version = $request->post('version');
        //获取所选地区area_id
        $area_id = $request->post('area_id');
        //获取手机唯一device_id
        $device_id = $request->post('device_id');
        //获取操作系统
        $os = $request->post('os');

        if (empty($version) || (empty($area_id)&&$area_id!=0) || empty($device_id) || empty($os)){
            $data['message'] = "请把参数填写完整";
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        //获取access_token/openid
        $data = $this->getToken($code);
        //设置获取个人信息所需的参数
        $apiData = array(
            'access_token'=> $data['access_token'],
            'openid'=> $data['openid'],
        );
        /**返回过来openid/nickname/sex/province/city/country/headimgurl/privilege/unionid*/
        $api = "https://api.weixin.qq.com/sns/userinfo?".http_build_query($apiData);
        //$data = $this->httpRequest($api);
        $data = Tool::httpRequest($api);
        //将数据添加到数据库里
        $res = $this->addUserInfo($data,$label,$version,$area_id,$device_id,$os);
        return json_encode($res,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 将信息插入device表
     * by songjian
     */
    public function insertDevice($id,$device_id,$os){
        $tmp = array(
            'id'        => 0,
            'member_id' => $id,
            'device_id' => $device_id,
            'os'        => $os,
            'create_time' => time(),
            'update_time' => time()
        );
        Db::table('yf_hf_device')->insert($tmp);
    }
}



