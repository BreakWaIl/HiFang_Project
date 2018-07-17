<?php
/**
 * Created by PhpStorm.
 * User: zfc
 * Date: 2018/4/17
 * Time: 16:43
 */

namespace app\api\controller;


use app\common\model\Users as memberModel;
use app\common\untils\JwtUntils;
use think\Db;
use think\Request;
use think\Session;
class User extends Basic
{
    public $memberModel;
    public function __construct(Request $request=null)
    {
        parent::__construct($request);
        $this->memberModel = new memberModel();
    }

    /**
     * 查询用户基本信息
     * by songjian
     * @return json
     */
    public function userinfo(){
        header('Access-Control-Allow-Origin:*');
        $data['code'] = 101;
        $data['message'] = '';
        //修改 by zyt @time 2018/5/5 16:04
        $userinfo = Db::table('yf_hf_member')->alias('m')
                ->join('yf_hf_area a','a.id=m.area_id','left')
                ->join('yf_hf_label l','l.id=m.label','left')
                ->field('m.id,m.hiid,m.unionid,m.is_power,m.headimgurl,m.nickname,m.phone,m.invite_code,m.birthday,m.balance,m.sex,m.label,m.sign,m.area_id,m.num_follow,m.num_publish,m.num_good_video,m.app_version,l.label_name,a.dic_value')
                ->where('m.id',$this->userId)->find();
        $birthday = Tool::countAge($userinfo['birthday']);
        $config = Db::table('yf_config')->whereIn('id',[70,71])->field('value')->select();
        //返回信息
        if ($userinfo) {
            $data['code'] = 200;
            $data['message'] = '信息查询成功';
            if ($userinfo['unionid']){
                $headimgurl = $userinfo['headimgurl'];
            }else{
                $headimgurl = Tool::getDomain().$userinfo['headimgurl'];
            }
            $data['data'] = array(
                'id'           => $userinfo['id'],
                'hiid'         => $userinfo['hiid'],
                'is_power'     => $userinfo['is_power'],
                'headimgurl'   => $headimgurl,
                'nickname'     => $userinfo['nickname'],
                'phone'        => $userinfo['phone'],
                'invite_code'  => $userinfo['invite_code'],
                'sex'          => $userinfo['sex'],
                'age'          => $birthday,
                'balance'      => $userinfo['balance'],
                'property'      => number_format($userinfo['balance']/10 , 2), //资产 10个嗨币=1元
                'birthday'     => $userinfo['birthday'],
                'label'        => $userinfo['label_name'],
                'sign'         => $userinfo['sign'],
                'area'         => $userinfo['dic_value'],
                'num_follow'   => $userinfo['num_follow'],
                'num_publish'  => $userinfo['num_publish'],
                'num_good_video'=> $userinfo['num_good_video'],
                'app_version'  => $userinfo['app_version'],
                'invite_title' => $config[0]['value'],
                'invite_info'  => $config[1]['value'],
                'authToken'    => $this->params['authToken']
            );
        } else {
            $data['code'] = 200;
            $data['message'] = '信息查询为空数据';
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 修改用户的详细信息 [post]
     * by songjian
     * @return json
     */
    public function editinfo(Request $request){
        $data['code'] = 100;
        $data['message'] = '条件填写错误';

        if ($nickname = $request->post('nickname')){
            $res = Db::table('yf_hf_member')->where('nickname',$nickname)->count();
            if ($res){
                $data['code'] = 101;
                $data['message'] = "该昵称已存在";
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
            $res = Db::table('yf_hf_member')->where('id',$this->userId)->update(['nickname'=>$nickname]);
            $data['code'] = $res ? 200 : 101;
            $data['message'] = $res ? '昵称消息更新成功' : '昵称消息更新失败';
        }elseif ($now_phone = $request->post('phone')){
            $res = Db::table('yf_hf_member')->where('phone',$now_phone)->count();
            if ($res){
                $data['code'] = 101;
                $data['message'] = "此手机号已被别人绑定";
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
            if(!preg_match("/^1\d{10}$/", $now_phone)){
                $data['code'] = 101;
                $data['message'] = '手机号填写格式错误，请重新填写';
            }else{
                $res = Db::table('yf_hf_member')->where('id',$this->userId)->update(['phone'=>$now_phone]);
                $data['code'] = $res ? 200 : 101;
                $data['message'] = $res ? '手机信息更新成功' : '手机信息更新失败';
            }
        }elseif ($sex = $request->post('sex')){
            $oldsex = Db::table('yf_hf_member')->field(['sex'])->where('id',$this->userId)->find()['sex'];
            if ($sex == $oldsex){
                $data['code'] = 200;
                $data['message'] = '性别信息更新成功';
            }else{
                $res = Db::table('yf_hf_member')->where('id',$this->userId)->update(['sex'=>$sex]);
                $data['code'] = $res ? 200 : 101;
                $data['message'] = $res ? '性别信息更新成功' : '性别信息更新失败';
            }
        }elseif ($birthday = $request->post('birthday')){
            $res = Db::table('yf_hf_member')->where('id',$this->userId)->update(['birthday'=>$birthday]);
            $data['code'] = $res ? 200 : 101;
            $data['message'] = $res ? '出生年月更新成功' : '出生年月更新失败';
        }elseif ($sign = $request->post('sign')){
            $res = Db::table('yf_hf_member')->where('id',$this->userId)->update(['sign'=>$sign]);
            $data['code'] = $res ? 200 : 101;
            $data['message'] = $res ? '个性签名更新成功' : '个性签名更新失败';
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }


    /**
    * 根据用户的昵称或者用户id去搜索用户
     * by songjian
    * @param text 搜索用户
    * @return json
    */
    public function finduser(Request $request){
        $pageSize=10; //每页条数
        $nickname = $request->get('text');
        //分页数据产生
        $pageNo = empty($request->get('page')) ? 1 : $request->get('page');
        if ($nickname ==''){
            $data = array('code' =>101, 'message'  => '请您输入要查询的用户',);
            $data = json_encode($data,JSON_UNESCAPED_UNICODE);
            return $data;
        }
        //根据条件搜索用户
        $infos = $this->memberModel->selectMember($nickname,$pageNo,$pageSize);
        $count = count($infos);
        $page = ceil($count/$pageSize);
        if (!$infos){
            $data = array('code' =>102, 'message'  => '您搜索的用户不存在',);
            $data = json_encode($data,JSON_UNESCAPED_UNICODE);
            return $data;
        }
        /** 查询是否关注
         * 修改by songjian*/
        //查询我关注的人
        $userid = $this->userId;
        if ($userid == null){
            for ($i=0;$i<$count;$i++) {
                $infos[$i]['status'] = 0;
            }
        }else{
            $ress = Db::table('yf_hf_follow')->where('member_id',$this->userId)->where('type',0)->where('is_followed',1)->select();
            // 添加status 0 未关注 1 已关注
            if ($count > 0) {
                for ($i=0;$i<$count;$i++) {
                    $infos[$i]['status'] = 0;
                    if (count($ress) > 0) {
                        for ($j=0;$j<count($ress);$j++) {
                            if ($infos[$i]['id'] == $ress[$j]['followed_id']) {
                                $infos[$i]['status'] = 1;
                            }
                        }
                    }
                }
            }
        }
        $data = array('code' =>200, 'message'  => '搜索成功', 'data' => $infos, 'page'=>$page);
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 根据用户的昵称或者用户id去搜索关注人
     * by songjian
     * @param text 搜索的关注人
     * @return json
     */
    public function findClearUser(Request $request){
        //每页显示条数
        $pageSize=10;
        $nickname = $request->get('text');
        //分页数据产生
        $pageNo = empty($request->get('page')) ? 1 : $request->get('page');
        if ($nickname ==''){
            $data = array('code' =>101, 'message'  => '请您输入要查询的用户',);
            $data = json_encode($data,JSON_UNESCAPED_UNICODE);
            return $data;
        }
        $infos = $this->memberModel->selectClearMember($nickname,$this->userId,$pageNo,$pageSize);
        $count = count($infos);
        $page = ceil($count/$pageSize);

        /** 查询是否关注
         * 修改by songjian*/
        //查询我关注的人
        $res = Db::table('yf_hf_follow')->where(['member_id'=>$this->userId, 'type'=>0, 'is_followed'=>1])->select();
        // 添加status 0 未关注 1 已关注
            if ($count > 0) {
                for ($i=0;$i<$count;$i++) {
                    $infos[$i]['status'] = 0;
                    if (count($res) > 0) {
                        for ($j=0;$j<count($res);$j++) {
                            if ($infos[$i]['member_id'] == $res[$j]['followed_id']) {
                                $infos[$i]['status'] = 1;
                            }
                        }
                    }
                }
            }
        if (!$infos){
            $data = array('code' =>102, 'message'  => '您搜索的用户不存在',);
            $data = json_encode($data,JSON_UNESCAPED_UNICODE);
            return $data;
        }
        $data = array('code' =>200, 'message'  => '搜索成功', 'data' => $infos, 'page'=>$page);
        $data = json_encode($data,JSON_UNESCAPED_UNICODE);
        return $data;
    }
}