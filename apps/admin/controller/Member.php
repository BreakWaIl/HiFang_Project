<?php

namespace app\admin\controller;

use app\api\controller\Basic;
use app\api\controller\Behavior;
use app\api\controller\Tool;
use app\common\untils\GeTuiUntils;
use app\common\model\AAgents;
use think\Db;
use think\Exception;
use think\Request;
use app\common\untils\MessageUntils;
use app\common\model\Users;
use app\common\model\NoteLog;
use think\Session;
use app\common\untils\JwtUntils;

class Member extends Basic
{
    public $user;
    public $invite_title;
    public $invite_info;
    public $register_icon;

    public function __construct(Request $request = null) {
        parent::__construct($request);
        $this->user = new Users();

        $this->invite_title = Tool::getConfigInfo(70);
        $this->invite_info = Tool::getConfigInfo(71);
        $this->register_icon = Tool::getConfigInfo(74);
    }

    /**
     * 用户登陆（手机）
     * by songjian
     * @param  phone 用户手机号
     * @param  code 输入验证码
     * @return json
     */
    public function login(Request $request) {
        /**
         * ↓测试服账号
         * by songjian
         */
        if (request()->param('phone') == '12345678900'){
            $data['code'] = 888;
            $data['message']  = '登录成功,测试账号';
            //查询该用户信息[二维数组]
            $userinfo = Db::table('yf_hf_member')->where('phone',request()->param('phone'))->find();
            //查出该用户所在地区名
            $area = Db::table('yf_hf_area')->field(['dic_value'])->where('id',$userinfo['area_id'])->find()['dic_value'];
            //通过计算得出年龄
            $age = Tool::countAge($userinfo['birthday']);
            $jwt = new JwtUntils();
            //在这里修改token里面存放信息的多少
            $jwt_data['phone'] = request()->param('phone');
            $jwt_data['id'] = $userinfo['id'];

            $data['data']['phone'] = request()->param('phone');
            $data['data']['id'] = (string)$userinfo['id'];
            $data['data']['hiid'] = (string)$userinfo['hiid'];
            $data['data']['nickname'] = $userinfo['nickname'];
            $data['data']['is_power'] = $userinfo['is_power'];
            $data['data']['headimgurl'] = Tool::getDomain().$userinfo['headimgurl'];
            $data['data']['invite_code'] = $userinfo['invite_code'];
            $data['data']['age'] = $age;
            $data['data']['balance'] = $userinfo['balance'];
            $data['data']['property'] = number_format($userinfo['balance']/10 , 2); //资产 10个嗨币=1元
            $data['data']['birthday'] = $userinfo['birthday'];
            $data['data']['sex'] = $userinfo['sex'];
            $data['data']['label'] = $userinfo['label'];
            $data['data']['num_publsh' ] = $userinfo['num_publish'];   //发布数
            $data['data']['num_good_video'] = $userinfo['num_good_video'];  //点赞数
            $data['data']['num_follow'] = $userinfo['num_follow'];   //粉丝数
            $data['data']['sign'] = $userinfo['sign'];              //个性签名
            $data['data']['area'] = $area;                          //区域
            $data['data']['invite_title' ] = $this->invite_title;  //邀请栏标题
            $data['data']['invite_info' ] = $this->invite_info;   //邀请栏详情
            $data['data']['app_version'] = $userinfo['app_version'];
            $data['data']['authToken'] = $jwt->createToken($jwt_data);
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        /**
         * ↑测试服账号
         * by songjian
         */
        $data['code'] = 101;
        $data['message'] = '';
        //获取手机号和验证码
        $phone = $request->post('phone');
        $code = $request->post('code');
        //获取身份标签
        $label = $request->post('label');
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
        if ($phone && $code) {
            //检查验证码
            $res = $this->check_code($phone,$code);
            if ($res == 200){
                $data['code'] = 200;
                $data['message']  = '登录成功,非首次登录';
                //查询该用户信息[二维数组]
                $userinfo = Db::table('yf_hf_member')->where('phone',$phone)->select();
                if (count($userinfo)){
                    $userinfo = $userinfo[0];
                }
                if (!$userinfo){
                    //首次登录添加用户数据
                    Db::startTrans();
                    try{
                        $rand = Tool::createRand();  //获取嗨房id
                        $nick_name = Tool::getRandName(); //获取随机昵称
                        $headimgurl = '/uploads/picture/default/default-logo.png';  //获取默认头像
                        $create_time = time();
                        $update_time = time();
                        $info = ['id'=>0,'phone'=>$phone,'hiid'=>$rand,'nickname'=>$nick_name,'headimgurl'=>$headimgurl,'area_id'=>$area_id,'app_version'=>$version,'label'=>$label,'create_time'=>$create_time,'update_time'=>$update_time];
                        $res = Db::table('yf_hf_member')->insert($info);
                        //在用户纪录中加入邀请码信息
                        $userinfo = Db::table('yf_hf_member')->where('phone',$phone)->find();
                        $invite_code = Tool::createCode($userinfo['id']);
                        Db::table('yf_hf_member')->where('id',$userinfo['id'])->update(['invite_code'=>$invite_code]);
                        //在device表中加入本用户手机的纪录，且一个用户只有一条记录
                        $tmp = array(
                            'id'        => 0,
                            'member_id' => $userinfo['id'],
                            'device_id' => $device_id,
                            'os'        => $os,
                            'create_time' => time(),
                            'update_time' => time()
                        );
                        Db::table('yf_hf_device')->insert($tmp);
                        Db::commit();
                    }catch (Exception $e){
                        Db::rollback();
                        echo '错误';exit;
                    }
                    $data['message']  = '登录成功,首次登录';
                }else{
                    //判断device_id是否与上一次相同，若不相同则更新纪录
                    $old_info = Db::table('yf_hf_device')->field(['device_id','os'])->where('member_id',$userinfo['id'])->find();
                    $tmp['version'] = $version;
                    if ($device_id != $old_info['device_id'] && $os != $old_info['os']){
                        $device_res = Db::table('yf_hf_device')
                            ->where('member_id',$userinfo['id'])
                            ->update(['device_id'=>$device_id,'os'=>$os,'update_time'=>time(),'version'=>$version]);
                        if (!$device_res){
                            $data['code'] = 108;
                            $data['message'] = '插入device表失败，请联系后台管理员';
                            return json_encode($data,JSON_UNESCAPED_UNICODE);
                        }
                    }elseif ($device_id != $old_info['device_id'] && $os == $old_info['os']){
                        $device_res = Db::table('yf_hf_device')
                            ->where('member_id',$userinfo['id'])
                            ->update(['device_id'=>$device_id,'update_time'=>time(),'version'=>$version]);
                        if (!$device_res){
                            $data['code'] = 108;
                            $data['message'] = '插入device表失败，请联系后台管理员';
                            return json_encode($data,JSON_UNESCAPED_UNICODE);
                        }
                    }elseif ($device_id == $old_info['device_id'] && $os != $old_info['os']){
                        $device_res = Db::table('yf_hf_device')
                            ->where('member_id',$userinfo['id'])
                            ->update(['os'=>$os,'update_time'=>time(),'version'=>$version]);
                        if (!$device_res){
                            $data['code'] = 108;
                            $data['message'] = '插入device表失败，请联系后台管理员';
                            return json_encode($data,JSON_UNESCAPED_UNICODE);
                        }
                    }
                    Db::table('yf_hf_member')->where('id',$userinfo['id'])->update(['app_version'=>$version,'update_time'=>time()]);
                    $userinfo = Db::table('yf_hf_member')->where('id',$userinfo['id'])->find();
                }
                //查出该用户所在地区名
                $area = Db::table('yf_hf_area')->field(['dic_value'])->where('id',$res['area_id'])->find()['dic_value'];
                //通过计算得出年龄
                $age = Tool::countAge($userinfo['birthday']);
                if ($userinfo['unionid']){
                    $headimgurl = $userinfo['headimgurl'];
                }else{
                    $headimgurl = Tool::getDomain().$userinfo['headimgurl'];
                }
                $jwt = new JwtUntils();
                //在这里修改token里面存放信息的多少
                $jwt_data['phone'] = $phone;
                $jwt_data['id'] = $userinfo['id'];
                //$jwt_data['headimgurl'] = $userinfo['headimgurl'];
                //$jwt_data['code'] = $code;
                $data['data']['phone'] = $phone;
                $data['data']['id'] = (string)$userinfo['id'];
                $data['data']['hiid'] = (string)$userinfo['hiid'];
                $data['data']['nickname'] = $userinfo['nickname'];
                $data['data']['is_power'] = $userinfo['is_power'];
                $data['data']['headimgurl'] = $headimgurl;
                $data['data']['invite_code'] = $userinfo['invite_code'];
                $data['data']['age'] = $age;
                $data['data']['balance'] = $userinfo['balance'];
                $data['data']['birthday'] = $userinfo['birthday'];
                $data['data']['sex'] = $userinfo['sex'];
                $data['data']['label'] = $userinfo['label'];
                $data['data']['num_publish' ] = $userinfo['num_publish'];   //发布数
                $data['data']['num_good_video'] = $userinfo['num_good_video'];  //点赞数
                $data['data']['num_follow'] = $userinfo['num_follow'];   //粉丝数
                $data['data']['sign'] = $userinfo['sign'];              //个性签名
                $data['data']['area'] = $area;                          //区域
                $data['data']['invite_title' ] = $this->invite_title;  //邀请栏标题
                $data['data']['invite_info' ] = $this->invite_info;   //邀请栏详情
                $data['data']['app_version'] = $userinfo['app_version'];
                $data['data']['authToken'] = $jwt->createToken($jwt_data);
            }elseif($res == 101){
                $data['message']  = '验证码已经过期';
            }elseif ($res==102){
                $data['message']  = '验证码错误';
            }
        } else {
            $data['message']    = '手机号或验证码为空';
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 安全退出登录
     * by songjian
     * @return json
     */
    public function logout(Request $request) {
        $data['code'] = 101;
        $data['message']    = '';
        $authToken = $request->post('authToken');
        if (empty($authToken)){
            $data['message'] = '请传入authToken';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        //if($authToken == Session::get('authToken')){
            $user = Session::get('authToken');
            $jwt = new JwtUntils();
            $info = $jwt->getDecode($authToken);
            if (isset($info['data']['id'])) {
                Session::delete('authToken');
                $data['code'] = 200;
                $data['message']    = '安全退出成功';
                $data['data']['authToken'] = $user;
            } else {
                $data['message'] = '安全退出失败';
                $data['data']['authToken'] = Session::get('authToken');
            }
        //}else{
        //    $data['message'] = '安全退出失败[token不匹配]';
        //    $data['data']['authToken'] = $authToken;
        //}
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }
    /**
     * 通过发送短信的形式-邀请用户
     * by songjian
     * @return json
     */
    public function invite(Request $request){
        $data['code'] = 101;
        $data['message'] = '';
        //准备信息
        $user_id = $this->userId;
        if ($user_id==''){
            $data['code'] = 300;
            $data['message'] = 'userid不能为空，authToken不能为空！';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        $phone = $request->post('phone');
        $res = Db::table('yf_hf_member')->field(['invite_code','nickname'])->where('id',$user_id)->find();
        $code = $res['invite_code'];
        $nickname = $res['nickname'];
        if (empty($phone) || empty($code)){
            $data['message'] = '手机号为空或邀请码为空';
        }else{
            //发送短信（从查短信表信息开始）
            $noteLog = new NoteLog();
            $send_time  = $noteLog->field('send_time')->where('phone', $phone)
                ->where('is_success',1)
                ->where('send_time','between time',[date('Y-m-d').' 00:00:00',date('Y-m-d').' 23:59:59'])
                ->select();
            $num = count($send_time); //发送数量
            if (!empty($send_time[$num-1]) && (time() - strtotime($send_time[$num-1]->send_time) < 58) && $num != 0) {
                $data['message'] = '1分钟内不能再次获取验证码';
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
            //判断是否今日发满了
            if ($num > 7){
                $data['message'] = '短信发送超过上限';
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
            //正式发送短信
            $message = new MessageUntils();
            $result = $message->sendInviteCode($phone,$code,$nickname,$user_id);
            if (empty($result['sms_code'])) {
                $data['message']  = '短信发送失败';
            } else {
                $data['code'] = 200;
                //$data['data']['token'] = $result['token'];
                $data['data']['message']  = $result['message'];
                $data['message'] = '短信发送成功';
            }
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 微信端H5用户邀请注册页面判断[暂时已弃用]
     * by songjian
     * @return json
     */
    public function checkInvite(Request $request){
        header('Access-Control-Allow-Origin:*');
        $data['code'] = 101;
        $data['message'] = '';
        //准备信息
        $user_id = $request->post('userid');
        if ($user_id==''){
            $data['message'] = 'userid不能为空';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        $phone = $request->post('phone');
        $code  = $request->post('code');
        if (empty($phone) || empty($code)){
            $data['message'] = '手机号或验证码不能为空';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        Db::startTrans();
        try{
            //先查是否手机号存在
            $res = Db::table('yf_hf_member')->where('phone',$phone)->find();
            if ($res){
                $data['message'] = "账号已存在,不用再次注册";
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
            //获取此app的版本
            $version = '1.0.0';
            //获取手机唯一device_id
            $device_id = 'xxxxxxxxxxxx';
            //获取操作系统
            $os = 'unknow';
            $res = $this->check_code($phone,$code);
            if ($res == 200){
                if ($res){
                    //当验证码验证成后，将用户信息插入到表中
                    $rand = Tool::createRand();  //获取嗨房id
                    $nick_name = Tool::getRandName(); //获取随机昵称
                    $headimgurl = Tool::getDomain().'/uploads/picture/default/default-logo.png';  //获取默认头像
                    $create_time = time();
                    $update_time = time();
                    $info = [
                        'id'   => 0,
                        'phone'=>$phone,
                        'hiid'=>$rand,
                        'is_power'   =>0,
                        'nickname'   =>$nick_name,
                        'headimgurl' =>$headimgurl,
                        'balance'    =>$this->register_icon,
                        'app_version'=>$version,
                        'create_time'=>$create_time,
                        'update_time'=>$update_time
                    ];
                    $res1 = Db::table('yf_hf_member')->insert($info);
                    if (!$res1){
                        $data['message'] = '新用户插入到表中失败';
                        return json_encode($data,JSON_UNESCAPED_UNICODE);
                    }else{
                        //在用户纪录中加入邀请码信息
                        $userinfo = Db::table('yf_hf_member')->where('phone',$phone)->find();
                        $invite_code = Tool::createCode($userinfo['id']);
                        Db::table('yf_hf_member')->where('id',$userinfo['id'])->update(['invite_code'=>$invite_code]);
                        //在device表中加入本用户手机的纪录，且一个用户只有一条记录
                        $tmp = array(
                            'id'        => 0,
                            'member_id' => $userinfo['id'],
                            'device_id' => $device_id,
                            'os'        => $os,
                            'create_time' => time(),
                            'update_time' => time()
                        );
                        $res2 = Db::table('yf_hf_device')->insert($tmp);
                        if (!$res2){
                            $data['message'] = '新用户插入device表中失败';
                            return json_encode($data,JSON_UNESCAPED_UNICODE);
                        }else{
                            //首先通过userid来判断此用户是否已经邀请够了定义人数，若是则不再给用户余额更新
                            /*$user_total = Tool::getConfigInfo(61);
                            $account = Db::table('yf_hf_account_details')->where('member_id',$user_id)->where('type',3)->count();
                            //var_dump($user_total);
                            if ($user_total > $account){
                                //给邀请人更新账单明细表
                                //$money = Tool::getRandMoney();
                                $money = 30;
                                $datas = [
                                    //邀请人获得奖励插入数据
                                    'id'        => 0,
                                    'member_id' => $user_id,
                                    'Recommend_member_id' => $userinfo['id'],
                                    'money'     => $money,
                                    'type'      => 3,
                                    'status'    => 1,
                                    'create_time' => time(),
                                    'update_time' => time(),
                                ];
                                $res3 = Db::table('yf_hf_account_details')->insert($datas);
                                Db::table('yf_hf_member')->where('id',$user_id)->setInc('balance',$money);
                                $data['code'] = 200;
                                $data['message'] = '微信邀请注册，注册成功,本用户、邀请用户获得奖励';
                            }else{
                                $version = Db::table('yf_hf_member')->field('app_version')->where('id',$user_id)->find()['app_version'];
                                $basicinfo = array(
                                    'id'        => 0,
                                    'member_id' => $userinfo['id'],
                                    'Recommend_member_id' => $user_id,
                                    'money' => 0,
                                    'type' => 3,
                                    'status' => 1,
                                    'remarks' => '被邀请的用户总数量已满',
                                    'nickname' => $info['nickname'],
                                    'app_version' => $version,
                                    'create_time' => time(),
                                    'update_time' => time(),
                                );
                                $res4 = Db::table('yf_hf_account_details')->insert($basicinfo);
                                $data['code'] = 200;
                                $data['message'] = '微信邀请注册，注册成功，用户不获得奖励';
                            }*/
                            $data['code'] = 200;
                            $data['message'] = '微信邀请注册，注册成功';
                        }
                    }
                }else{
                    $data['message'] = '验证码验证失败';
                }
            }elseif($res == 101){
                $data['message']  = '验证码已经过期';
            }elseif ($res==102){
                $data['message']  = '验证码错误';
            }
            Db::commit();
        }catch (Exception $exception){
            Db::rollback();
            $data['message'] = "错误";
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 通过发送短信的形式-提现的时候用来获取验证码
     * by songjian
     * @return json
     */
    public function getReadyMoney(Request $request){
        $data['code'] = 101;
        $data['message'] = '';
        //准备信息
        $user_id = $this->userId;
        if ($user_id==''){
            $data['code'] = 300;
            $data['message'] = 'authToken不能为空！';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        $phone = $request->post('phone');

        if (empty($phone)){
            $data['message'] = '手机号为空';
        }elseif (!preg_match("/^1\d{10}$/", $phone)){
            $data['message'] = '手机号填写格式错误，请重新填写';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }else{
            //发送短信（从查短信表信息开始）
            $noteLog = new NoteLog();
            $send_time  = $noteLog->field('send_time')->where('phone', $phone)
                ->where('is_success',1)
                ->where('send_time','between time',[date('Y-m-d').' 00:00:00',date('Y-m-d').' 23:59:59'])
                ->select();
            $num = count($send_time); //发送数量
            if (!empty($send_time[$num-1]) && (time() - strtotime($send_time[$num-1]->send_time) < 58) && $num != 0) {
                $data['message'] = '1分钟内不能再次获取验证码';
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
            //判断是否今日发满了
            if ($num > 7){
                $data['message'] = '短信发送超过上限';
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
            //正式发送短信
            $message = new MessageUntils();
            $result = $message->sendGetReadyMoneyCode($phone);
            if (empty($result['sms_code'])) {
                $data['message']  = '短信发送失败';
            } else {
                $data['code'] = 200;
                //$data['data']['token'] = $result['token'];
                //$data['data']['sms_code']  = $result['sms_code'];
                $data['message'] = '短信发送成功';
            }
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 微信用户绑定手机号
     * by songjian
     * @return json
     */
    public function bandPhone(Request $request){
        header('Access-Control-Allow-Origin:*');
        $data['code'] = 101;
        $data['message'] = '';
        //若来自web，则是邀请人的id
        $user_id = $request->post('user_id');
        $member_id = $request->post('member_id');
        $phone = $request->post('phone');
        $code = $request->post('code');
        $from = $request->post('from');

        if (empty($member_id)){
            $data['message'] = '请传入用户的id';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        if (empty($phone)){
            $data['message'] = '请传入手机号';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        if (empty($code)){
            $data['message'] = '请传入验证码';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        $res = $this->check_code($phone,$code);
        if ($res == 200){
            //当验证码验证成功，执行绑定手机号
            $result = Db::table('yf_hf_member')->where('phone',$phone)->count();
            if ($result){
                $data['code'] = 101;
                $data['message'] = "此手机号已被绑定";
                $data['data']['status'] = 0;
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
            //如果绑定操作来自h5，则更新余额
            if ($from == 'web'){
                $icon = $this->register_icon;
                $result = Db::table('yf_hf_member')->where('id',$member_id)->update(['phone'=>$phone,'balance'=>$icon,'update_time'=>time()]);
                //注册人获得奖励插入数据
                $user_detail_info = [
                    'id'        => 0,
                    'member_id' => $member_id,
                    'Recommend_member_id' => '',
                    'money'     => $icon,
                    'type'      => 8,
                    'status'    => 1,
                    'create_time' => time(),
                    'update_time' => time(),
                ];
                Db::table('yf_hf_account_details')->insert($user_detail_info);
                /**
                 * 绑定成功后用户加入device表
                 * update by songjian
                 */
                //获取此app的版本
                $version = '1.0.0';
                //获取手机唯一device_id
                $device_id = 'xxxxxxxxxxxx';
                //获取操作系统
                $os = 'unknow';
                //在用户纪录中加入邀请码信息
                $userinfo = Db::table('yf_hf_member')->where('id',$member_id)->find();
                $invite_code = Tool::createCode($userinfo['id']);
                Db::table('yf_hf_member')->where('id',$userinfo['id'])->update(['invite_code'=>$invite_code]);
                //在device表中加入本用户手机的纪录，且一个用户只有一条记录
                $tmp = array(
                    'id'          => 0,
                    'member_id'   => $userinfo['id'],
                    'device_id'   => $device_id,
                    'os'          => $os,
                    'version'     => $version,
                    'create_time' => time(),
                    'update_time' => time()
                );
                $res2 = Db::table('yf_hf_device')->insert($tmp);
                if (!$res2){
                    $data['message'] = '新用户插入device表中失败';
                    return json_encode($data,JSON_UNESCAPED_UNICODE);
                }
                /**
                 * update end
                 */

                //h5注册动作插入行为接口
                //$behavior = new Behavior();
                Behavior::insertBackBehavior($user_id,19,'');
            }else{
                /**
                 * 自行注册也给奖励
                 * update by songjian
                 */
                $icon = $this->register_icon;
                $result = Db::table('yf_hf_member')->where('id',$member_id)->update(['phone'=>$phone,'update_time'=>time()]);
                Db::table('yf_hf_member')->where('id',$member_id)->setInc('balance',$icon);
                //注册人获得奖励插入数据
                $user_detail_info = [
                    'id'        => 0,
                    'member_id' => $member_id,
                    'Recommend_member_id' => '',
                    'money'     => $icon,
                    'type'      => 8,
                    'status'    => 1,
                    'create_time' => time(),
                    'update_time' => time(),
                ];
                Db::table('yf_hf_account_details')->insert($user_detail_info);
                //$behavior = new Behavior();
                //Behavior::insertBackBehavior($user_id,19,'');
            }
            if ($result){
                $icon = Tool::getConfigInfo(74);
                $exchage = Tool::getConfigInfo(75);
                $icons = (int)$icon/$exchage;
                $data['code'] = 200;
                $data['message'] = '验证码验证成功,绑定成功';
                $data['data']['icon'] = $icons;
                $data['data']['status'] = 1;
            }else{
                $data['message'] = '绑定失败';
            }
        }elseif($res == 101){
            $data['message']  = '验证码已经过期';
        }elseif ($res==102){
            $data['message']  = '验证码错误';
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }



    /**
     * 发送短信
     * by songjian
     * @param phone 用户手机号
     * @return json
     */
    public function sendSms() {
        header('Access-Control-Allow-Origin:*');
        $data['code'] = 101;
        $data['message'] = '';
        $phone = request()->param('phone');
        if (empty($phone)) {
            $data['message'] = '手机号码为空';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        if(!preg_match("/^1\d{10}$/", $phone)){
            $data['message'] = '手机号填写格式错误，请重新填写';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }

        if (!check_phone($phone)) {
            $data['message'] = '手机号码错误';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }

        $noteLog = new NoteLog();
        $send_time  = $noteLog->field('send_time')->where('phone', $phone)
            ->where('is_success',1)
            ->where('send_time','between time',[date('Y-m-d').' 00:00:00',date('Y-m-d').' 23:59:59'])
            ->select();
        $num = count($send_time); //发送数量

        if (!empty($send_time[$num-1]) && (time() - strtotime($send_time[$num-1]->send_time) < 58) && $num != 0) {
            $data['message'] = '1分钟内不能再次获取验证码';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }

        if ($num > 7){
            $data['message'] = '短信发送超过上限';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }

        $message = new MessageUntils();
        $result = $message->sendCheckCode($phone);
        if (empty($result['sms_code'])) {
            $data['message']  = '短信发送失败';
        } else {
            $data['code'] = 200;
            //$data['data']['token'] = $result['token'];
            //$data['data']['sms_code']  = $result['sms_code'];
            $data['message'] = '短信发送成功';
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 生成邀请二维码
     *
     * @return \think\Response
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
   /* public function qrCode() {

        $parms = $this->params;
        $data['status'] = 101;
        $data['data']   = array();
        $data['msg']    = '';
   
        if ($parms['id'] && $parms['referrer_source']) {
            $result = $this->user->where('status',0)->where('id',$parms['id'])->find();
           
            if ($result) {
                $code = new \app\api\untils\GenerateCodeUntils();
                $url  = $this->request->domain().'/app.php/app/share_register?referrer_source=10&id='.$result->id;
                $path = $code->getCode($url, $result->id);
                $data['data']   = ['path' => $this->request->domain().'/'.$path];
                $data['status'] = 200;
            } else {
                $data['msg'] = '没有该用户';
            }
        } else {
            $data['msg']    = 'id or referrer_source is null';
        }
        return $this->response($data['status'], $data['msg'], $data['data']);
    }*/

    /**
     * 上传头像
     *
     * @return \think\Response
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
   /* public function uploadHeadImg() {
        $data['status'] = 101;
        $data['msg']    = '';
        $data['data']   = '';

        $file = request()->file('image');
        if($file){
            $path = ROOT_PATH . 'public' . DS . 'static'. DS . 'head_portrait';
            $info = $file->validate(['size'=>512000,'ext'=>'jpg,png'])      //限制500KB
                ->move($path);
            if($info){
                if ($this->userId) {
                    $user = new Users();
                    $user_data = $user->field('user_pic')->where('id',$this->userId)->find();
                    @unlink($path.DS.$user_data->user_pic); //删除原来的图片
                    $img_path    = $info->getSaveName();  //生成的图片路径
                    //更新用户信息
                    $user_data->user_pic = $img_path;
                    $user_data->save();

                    $static_path = $path.DS.$img_path;    //生成图片的绝对路径
                    $image = \think\Image::open($static_path);
                    $image->thumb(500, 500)->save($static_path);   //生成缩略图

                    $data['status'] = 200;
                    $data['msg']    = '上传成功';
                    $data['data']   = ['file_name' => HEADERIMGURL . $img_path];
                }

            }else{
                // 上传失败获取错误信息
                $data['msg'] = $file->getError();
            }
        } else {
            $data['msg'] = '没有该文件';
        }

        return $this->response($data['status'], $data['msg'], $data['data']);
    }*/

    /**
     * 检查验证码
     * by songjian
     * @param  phone 用户手机号
     * @param  code 用户输入验证码
     * @return int
     */
    public function check_code($phone,$code) {
        $note = new NoteLog();
        //查找五分钟内的验证码
        $note_data_now = $note->field('code')
            ->where('phone',$phone)
            ->where('is_success',1)
            ->whereTime('send_time', '>',time()-300)
            ->order('id DESC')->find();
        //查找任意时候的验证码
        $note_data_before = $note->field('code')
            ->where('phone',$phone)
            ->where('is_success',1)
            ->order('id DESC')->find();
        //判断验证码是否匹配
        if ($code == $note_data_now['code']) {
            $res = 200;
        }
        //判断验证码是否过期
        elseif ($code == $note_data_before['code'] && $note_data_now ==''){
            $res = 101;
        }else {
            $res = 102;
        }
        return $res;
    }
}