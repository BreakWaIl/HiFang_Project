<?php
/**
 * Created by PhpStorm.
 * User: ASUS
 * Date: 2018/5/18
 * Time: 14:10
 */
namespace app\api\controller;

use think\Db;
use think\Request;

class Share extends Basic
{
    public function __construct($request = null)
    {
        parent::__construct($request);
    }

    /**
     * 分享推送
     * @auther zyt
     */
    public function shareTui ()
    {
        $result['code']    = 101;
        $result['message'] = '';
        $param_id = $this->params['member_id'];
        $getui = new Getui();
        $res  = $getui->pushMessage($type=9,$this->userId,$param_id,$data='');

        if ($res) {
            $result['code']    = 200;
            $result['message'] = '信息推送成功';
        } else {
            $result['message'] = '信息推送失败';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     * 获取分享列表
     * by songjian
     * @return json
     */
    public function getShareList(Request $request){
        $data['code'] = 101;
        $data['message'] = '';
        $nowpage = empty($request->get('page')) ? 1 : $request->get('page');
        $shared_user_id = $this->userId;
        $pagesize = 10;
        $nowsize = ($nowpage -1 )* $pagesize;
        $count = Db::table('yf_hf_share')->where('shared_user_id',$shared_user_id)->count();
        $sql = "select s.video_id,m.id as member_id,m.headimgurl,m.nickname,m.unionid,m.is_robot,v.video_cover,v.is_delete,v.title,s.create_time from `yf_hf_member` m,`yf_hf_share` s , `yf_hf_video` v where s.video_id=v.id and m.id= s.member_id and s.shared_user_id='{$shared_user_id}'ORDER BY s.create_time DESC limit $nowsize,$pagesize";
        $res = Db::query($sql);
        $page = ceil($count/$pagesize);
        if ($res){
            for ($i=0;$i<count($res);$i++) {
                //获取头像地址
                if ($res[$i]['unionid'] || $res[$i]['is_robot']!=0){
                    $res[$i]['headimgurl'] = $res[$i]['headimgurl'];
                }else{
                    $res[$i]['headimgurl'] = Tool::getDomain().$res[$i]['headimgurl'];
                }
            }

            $data['code']  = 200;
            $data['message'] = '分享列表查询成功';
            $data['data'] = $res;
            $data['page'] = $page;
        }else{
            $data['code']  = 200;
            $data['message'] = '暂无数据';
        }
        //更新task表中未读改为已读
        Db::table('yf_hf_task')->where(['member_id'=>$this->userId,'type'=>9,'is_show'=>0])->update(['is_show'=>1]);

        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 分享生成二维码
     * @auther zyt
     * @time 2018/7/3
     */
    public function shareImageCode()
    {
        $result['code'] = 101;
        $result['message'] = '';

        $member_id = $this->params['member_id'];
        if(empty($member_id)){
            $member_id = $this->userId;
        }
        $member = Db::table('yf_hf_member')->where('id',$member_id)->find();

        if (!$member) {
            $result['message'] = '没有该用户';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }

        //判断是否已经生成用户名片
        /*$filename = 'uploads/qrcode/qrcode-'.$member['hiid'].'.png';
        if (file_exists($filename)) {
            $url['qrcode'] = Tool::getDomain() .'/'.$filename;
        } else {
            $qrCode = Tool::getQrCode($member_id);
            $url['qrcode'] = Tool::getDomain() .$qrCode;
        }*/
        $qrCode = Tool::getQrCode($member_id);
        $url['qrcode'] = Tool::getDomain() .$qrCode;
        if ($url) {
            $result['code'] = 200;
            $result['message'] = '操作成功';
            $result['data'] = $url;
            //$result['data'] = Tool::getDomain() .DS.'uploads'.DS.'qrcode'.DS.'qrcode-'.$member['hiid'].'.png';
        } else {
            $result['message'] = '操作失败';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }
}