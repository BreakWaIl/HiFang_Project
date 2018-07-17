<?php

namespace app\api\controller;


use app\api\extend\QiniuTools;
use Qiniu\Auth;
use Qiniu\Processing\PersistentFop;
use think\Db;
use think\Request;

/**
 * qin 2018-04-17
 * Class QiniuYun
 * @package app\api\controller
 */
class QiniuYun
{
    /**
     * qin2018-04-17
     * 获取上传token
     */
    public function genToken()
    {
        $covertime=input("post.covertime");
        $covername=input("post.covername");
        $return['code']=200;
        $return['message']='success';
        $data['token']=QiniuTools::genToken($covertime,$covername);
        $return['data']=$data;
        echo json_encode($return);
    }

    /**
     * qin 2018-04-17
     * 获取视频封面图
     */
    public function getVideoCover()
    {
        $return['status']=0;
        $return['cover']=QiniuTools::genToken();
        echo json_encode($return);
    }

    /**
     * qin 2018-04-17
     * 删除文件
     */
    public function delete()
    {
        $key = input("post.delete_key");
        QiniuTools::delete($key);
        $return['code']=200;
        $return['message']='success';
        $data['msg']=QiniuTools::delete($key);
        $return['data']=$data;
        echo json_encode($return);
    }


    /**
     * 生成视频水印(app保存到本地时)
     * by songjian
     * return json
     */
    public function createWaterVideo(Request $request){
        $video_id = $request->param('video_name');
        $member_id = $request->param('hiid');

        $video = Db::table('yf_hf_video')->where('video_link','like','%'.$video_id.'%')->find();
        /*if (!$video) {
            $data['code'] = 101;
            $data['message'] = '该视频不存在';
            return json_encode($data, JSON_UNESCAPED_UNICODE);
        }*/

        //对已经上传到七牛的视频发起异步转码操作
        $accessKey = '2HzSOxN30PJk8km94quVwVtmKvrA0_NyqFVcZQaW';
        $secretKey = 'yxjfFeYNDKPhOq2sQd1b2OrGkgjqkVz_BXs_WMNq';
        $bucket = 'hifang';
        $auth = new Auth($accessKey, $secretKey);
        //要转码的文件所在的空间和文件名。
        $key = $video_id;
        //转码是使用的队列名称。 https://portal.qiniu.com/mps/pipeline
        $pipeline = 'hifang';
        //转码完成后通知到你的业务服务器。
        $notifyUrl = 'https://hifang.fujuhaofang.com/admin.php/api/qiniuyun/redirect';
        $force = false;
        $config = new \Qiniu\Config();
        //$config->useHTTPS=true;
        $pfop = new PersistentFop($auth, $config);
        //需要添加水印的图片UrlSafeBase64
        //可以参考http://developer.qiniu.com/code/v6/api/dora-api/av/video-watermark.html
        $base64URL = \Qiniu\base64_urlSafeEncode('http://p79qkwz6c.bkt.clouddn.com/hifang_2x.png');
        $phone = Db::table('yf_hf_member')->where('hiid',$member_id)->value('phone');
        $font = "TEL:".$phone;
        $base64FONT = \Qiniu\base64_urlSafeEncode($font);
        $base64FONT1 = \Qiniu\base64_urlSafeEncode('三室两厅');
        $base64FONT2 = \Qiniu\base64_urlSafeEncode('杨泰公寓');
        $base64FONT3 = \Qiniu\base64_urlSafeEncode('房东直租');

        $base64COLOR = \Qiniu\base64_urlSafeEncode("#FFFFFF");
        $video_name = \Qiniu\base64_urlSafeEncode($bucket.":new{$video_id}");
        //水印参数
        //$fops = "avthumb/mp4/wmImage/".$base64URL."/wmText/".$base64FONT."/wmFontColor/".$base64COLOR."/wmFontSize/30/wmGravityText/SouthEast";
        //$fops = "avthumb/mp4/wmImage/".$base64URL."/wmGravity/SouthEast/wmOffsetY/-20/wmText/".$base64FONT."/wmFontColor/".$base64COLOR."/wmFontSize/15/wmGravityText/NorthEast|saveas/".$video_name;
//        $fops = "avthumb/mp4/wmImage/".$base64URL."/wmGravity/SouthEast/wmOffsetY/-20|" . "avthumb/mp4/wmText/". $base64FONT ."/wmFontColor/".$base64COLOR."/wmFontSize/20/wmGravityText/SouthEast/wmOffsetY/6|saveas/".$video_name;
          $fops = "avthumb/mp4/wmImage/".$base64URL
            ."/wmGravity/SouthEast/wmOffsetY/-20|" . "avthumb/mp4/wmText/". $base64FONT
            ."/wmFontColor/".$base64COLOR
            ."/wmFontSize/20/wmGravityText/SouthEast/wmOffsetY/6|saveas/".$video_name;


        /*$fops = "avthumb/mp4/wmImage/".$base64URL
            ."/wmGravity/SouthEast/wmOffsetY/-20|" . "avthumb/mp4/wmText/". $base64FONT
            ."/wmFontColor/".$base64COLOR
            ."/wmGravityText/Center/wmOffsetX/20/wmOffsetY/200|" . "avthumb/mp4/wmText/". $base64FONT1
            ."/wmFontColor/".$base64COLOR
            ."/wmGravityText/Center/wmOffsetX/150/wmOffsetY/150|" . "avthumb/mp4/wmText/". $base64FONT2
            ."/wmFontColor/".$base64COLOR
            ."/wmGravityText/SouthEast/wmOffsetX/+10/wmOffsetY/+10|" . "avthumb/mp4/wmText/". $base64FONT3
            ."/wmFontColor/".$base64COLOR
            ."/wmFontSize/20/wmGravityText/SouthEast/wmOffsetY/6|saveas/".$video_name;*/


        list($id, $err) = $pfop->execute($bucket, $key, $fops, $pipeline, $notifyUrl, $force);
        //echo "\n====> pfop avthumb result: \n";
        if ($err != null) {
            var_dump($err);
        } else {
            //echo "PersistentFop Id: $id\n";
        }
        //查询转码的进度和状态
        list($ret, $err) = $pfop->status($id);

        /*if ($err != null) {
            var_dump($err);
            $data['code'] = 101;
            $data['message'] = "加入水印失败";
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        } else {
            $data['code'] = 200;
            $data['message'] = "加入水印成功";
            $data['data'] = array(
                'address' => "http://p79qkwz6c.bkt.clouddn.com/new{$video_id}"
            );
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        exit;*/

        //echo "\n====> pfop avthumb status: \n";
        if ($err != null) {
            var_dump($err);
            $data['code'] = 101;
            $data['message'] = "加入水印失败";
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        } else {
            //将水印视频插入到数据库
            $array = array(
                'id' => 0,
                'member_hiid' => $member_id,
                'video_id'    => $video_id,
                'video_link'  => "http://p79qkwz6c.bkt.clouddn.com/new{$video_id}",
                'create_time' => time(),
                'update_time' => time()
            );
            $res = Db::table('yf_hf_watermark_video')->insert($array);
            if ($res){
                $data['code'] = 200;
                $data['message'] = "加入水印成功";
                $data['data'] = array(
                    'address' => "http://p79qkwz6c.bkt.clouddn.com/new{$video_id}"
                );
                return json_encode($data,JSON_UNESCAPED_UNICODE);
            }
        }
    }

    /**
     * 回调服务器地址(无)
     * by songjian
     */
    public function redirect(){
        echo true;
    }

    /**
     * 合成音乐操作
     * songjian
     */
    public static function createMusic($filename){
        $accessKey = '2HzSOxN30PJk8km94quVwVtmKvrA0_NyqFVcZQaW';
        $secretKey = 'yxjfFeYNDKPhOq2sQd1b2OrGkgjqkVz_BXs_WMNq';
        $bucket = 'hifang';
        $auth = new Auth($accessKey, $secretKey);
        //要转码的文件所在的空间和文件名。
        $key = $filename;
        //转码是使用的队列名称。 https://portal.qiniu.com/mps/pipeline
        $pipeline = 'hifang';
        $force = true;
        //转码完成后通知到你的业务服务器。
        $notifyUrl = 'https://hifang.fujuhaofang.com/admin.php/api/qiniuyun/redirect';
        $config = new \Qiniu\Config();
        //$config->useHTTPS=true;
        $pfop = new PersistentFop($auth, $config);
        $randMusic = array_rand(config('array_music'),1);
        $music = \Qiniu\base64_urlSafeEncode($randMusic);
        //要进行转码的转码操作。 http://developer.qiniu.com/docs/v6/api/reference/fop/av/avthumb.html
        $fops = "avthumb/mp4/multiArep/".$music."|saveas/" . \Qiniu\base64_urlSafeEncode($bucket . ":$key");
        list($id, $err) = $pfop->execute($bucket, $key, $fops, $pipeline, $notifyUrl, true);
        //echo "\n====> pfop avthumb result: \n";
        if ($err != null) {
            var_dump($err);
        } else {
            echo "PersistentFop Id: $id\n";
        }
        //查询转码的进度和状态
        list($ret, $err) = $pfop->status($id);
        //echo "\n====> pfop avthumb status: \n";
        if ($err != null) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 七牛云cnd刷新
     * by songjian
     */
    public function refresh($url = "http://p79qkwz6c.bkt.clouddn.com/1000215075195224064_3_22.mp4.f30.mp4"){
        // 需要填写你的 Access Key 和 Secret Key
        $accessKey ="2HzSOxN30PJk8km94quVwVtmKvrA0_NyqFVcZQaW";
        $secretKey = "yxjfFeYNDKPhOq2sQd1b2OrGkgjqkVz_BXs_WMNq";
        $bucket = "hifang";
        // 构建鉴权对象
        $auth = new Auth($accessKey, $secretKey);
        // 生成上传 Token
        $token = $auth->uploadToken($bucket);

        $api = "fusion.qiniuapi.com/v2/tune/refresh";
        $postData = array(
            'Authorization' => $token,
            'urlN'=> array($url)
        );
        $result = Tool::httpRequest($api, $postData);
        var_dump($result);
    }
}