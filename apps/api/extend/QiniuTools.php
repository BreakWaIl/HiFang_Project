<?php
namespace app\api\extend;
// 引入鉴权类
use Qiniu\Auth;
use think\Config;

require_once EXTEND_PATH. '/qiniuSdk/autoload.php';
class QiniuTools{
    public static function genToken($covertime,$covername){
        // 构建鉴权对象
        $auth = new Auth(Config::get('accessKey'), Config::get('secretKey'));
        // 生成上传 Token

        //封面图名称
        $key=base64_encode("hifang:".$covername);
        # 要进行转码的转码操作。
        $fops = 'vframe/jpg/offset/'.$covertime.'/w/480/h/360|saveas/'.$key;
        $policy=array(
            'persistentOps'=>$fops
        );
        $token = $auth->uploadToken(Config::get('bucket'),null,3600,$policy);
        return $token;
    }

    public static function delete($key)
    {

        $accessKey =Config::get('accessKey');
        $secretKey = Config::get('secretKey');
        $bucket = Config::get('bucket');

        $auth = new Auth($accessKey, $secretKey);
        $config = new \Qiniu\Config();
        $bucketManager = new \Qiniu\Storage\BucketManager($auth, $config);
        $err = $bucketManager->delete($bucket, $key);
        
        if ($err!==null) {
            return "error";
        }else{
            return "success";
        }
    }
}
?>