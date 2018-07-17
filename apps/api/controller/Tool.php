<?php
/**
 * 工具类
 * User: ASUS
 * Date: 2018/4/26
 * Time: 9:52
 */

namespace app\api\controller;


use app\common\model\Config;
use Qiniu\Auth;
use Qiniu\Processing\PersistentFop;
use think\Db;
use think\Log;
use think\Request;
use think\Loader;
use app\api\controller\QiniuYun;
use app\api\extend\QiniuTools;
use app\api\untils\GeTuiUntils;
use phpDocumentor\Reflection\DocBlock\Tags\Var_;
use Qiniu\Storage\UploadManager;
use think\Exception;

class Tool
{
    /**
     * 获取默认用户
     */
    /*
     public function getNickNameFace()
    {
        $urls = array(
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408814972826780250",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408831280125543848",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408825501655105045",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408819451270231181",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408853154051258936",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408872304919151031",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408849184192163935",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408816195206969560",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408817484523437250",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408830571313886007",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408809435420481303",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408859133568479490",
            "http://coral.qq.com/article/2722227967/comment/v2?callback=_article2722227967commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408821415857092673",
            "http://coral.qq.com/article/2724023586/comment/v2?callback=_article2724023586commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408867704783304258",
            "http://coral.qq.com/article/2724023586/comment/v2?callback=_article2724023586commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408880500787981299",
            "http://coral.qq.com/article/2724023586/comment/v2?callback=_article2724023586commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408875311276545761",
            "http://coral.qq.com/article/2724023586/comment/v2?callback=_article2724023586commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408887604465629731",
            "http://coral.qq.com/article/2724023586/comment/v2?callback=_article2724023586commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408885274573953489",
            "http://coral.qq.com/article/2723116573/comment/v2?callback=_article2723116573commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408838260632288651",
            "http://coral.qq.com/article/2723116573/comment/v2?callback=_article2723116573commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408850418144508073",
            "http://coral.qq.com/article/2678723500/comment/v2?callback=_article2678723500commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6404161747478181253",
            "http://coral.qq.com/article/2678723500/comment/v2?callback=_article2678723500commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6404119702475242270",
            "http://coral.qq.com/article/2678723500/comment/v2?callback=_article2678723500commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6404214697458104900",
            "http://coral.qq.com/article/2678723500/comment/v2?callback=_article2678723500commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6404343973034907705",
            "http://coral.qq.com/article/2678723500/comment/v2?callback=_article2678723500commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6404197962864653238",
            "http://coral.qq.com/article/2678723500/comment/v2?callback=_article2678723500commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6404136190129074756",
            "http://coral.qq.com/article/2678723500/comment/v2?callback=_article2678723500commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6404130046039945532",
            "http://coral.qq.com/article/2678723500/comment/v2?callback=_article2678723500commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6404161323385020263",
            "http://coral.qq.com/article/2678723500/comment/v2?callback=_article2678723500commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6404116497929859325",
            "http://coral.qq.com/article/2723514839/comment/v2?callback=_article2723514839commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408820728187815096",
            "http://coral.qq.com/article/2723514839/comment/v2?callback=_article2723514839commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408848432463870112",
            "http://coral.qq.com/article/2723514839/comment/v2?callback=_article2723514839commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408848003157251640",
            "http://coral.qq.com/article/2723514839/comment/v2?callback=_article2723514839commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408834048932936067",
            "http://coral.qq.com/article/2723514839/comment/v2?callback=_article2723514839commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408834246381197063",
            "http://coral.qq.com/article/2723514839/comment/v2?callback=_article2723514839commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408856459335490288",
            "http://coral.qq.com/article/2723514839/comment/v2?callback=_article2723514839commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408835428252179863",
            "http://coral.qq.com/article/2723514839/comment/v2?callback=_article2723514839commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408838117898583145",
            "http://coral.qq.com/article/2723514839/comment/v2?callback=_article2723514839commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408837207172023814",
            "http://coral.qq.com/article/2723514839/comment/v2?callback=_article2723514839commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408845133472463081",
            "http://coral.qq.com/article/2722501209/comment/v2?callback=_article2722501209commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408874001188519196",
            "http://coral.qq.com/article/2722501209/comment/v2?callback=_article2722501209commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408892729498923442",
            "http://coral.qq.com/article/2723763956/comment/v2?callback=_article2723763956commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408854841227530421",
            "http://coral.qq.com/article/2724252310/comment/v2?callback=_article2724252310commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408896682311089124",
            "http://coral.qq.com/article/2723629317/comment/v2?callback=_article2723629317commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408848362397989740",
            "http://coral.qq.com/article/2723629317/comment/v2?callback=_article2723629317commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408863052873410383",
            "http://coral.qq.com/article/2723629317/comment/v2?callback=_article2723629317commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408884195461232064",
            "http://coral.qq.com/article/2723629317/comment/v2?callback=_article2723629317commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408856623261473783",
            "http://coral.qq.com/article/2723629317/comment/v2?callback=_article2723629317commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408878074616937317",
            "http://coral.qq.com/article/2723629317/comment/v2?callback=_article2723629317commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408886090828844701",
            "http://coral.qq.com/article/2723629317/comment/v2?callback=_article2723629317commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408855383008671319",
            "http://coral.qq.com/article/2723629317/comment/v2?callback=_article2723629317commentv2&orinum=100&oriorder=o&pageflag=1&cursor=6408852115649950306",
        );
        $count = 0;
        $users = array();
        foreach ($urls as $uk => $uv) {

            $result_str = file_get_contents($uv);
            $result = array();
            preg_match_all("/(?:\()(.*)(?:\))/i", $result_str, $result);
            $result_arr = json_decode($result[1][0], true);
            $user_list = $result_arr['data']['userList'];

            //echo count($user_list)."\n";

            foreach ($user_list as $k => $v) {
                if (strlen($v['head']) == 0) {
                    //没有头像的,不保存
                    continue;
                }
                $count++;
                //todo 保存到数据库
                //echo '昵称:'.$v['nick'].'-头像:'.$v['head'].'-['.strlen($v['head']).']-性别:'.$v['gender']."\n";

                array_push($users, ['nickname' => $v['nick'], 'headimgurl' => $v['head'], 'sex' => $v['gender'] == 0 ? 1 : 2, 'is_robot' => 1]);
            }
        }
        echo "totle{$count}\n";
        echo "totle" . count($users) . "\n";
        //$result_num=Db::table("yf_hf_member")->insertAll($users);
        //echo "totle{$result_num}\n";
        //var_dump($users);
        //file_put_contents('is_robot.json',json_encode($users));
    }
    */
    /**
     * 自动获取本站域名
     * by songjian
     * @return string
     */
    public static function getDomain(){
        $http_type = ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') || (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')) ? 'https://' : 'http://';
        $host=$http_type.$_SERVER['HTTP_HOST'];
        return $host;
    }

    /**
     * 通过cinfig配置表拉取配置信息
     * by songjian
     */
    public static function getConfigInfo($id){
        $config = new Config();
        $value = $config->getConfig($id);
        return $value;
    }

    /**
     * 生成六位的随机数[用于生成嗨房号]
     * by songjian
     * @return string
     */
    public static function createRand(){
        //生成规则：（时间戳后六位+两位随机数）反转
        $code1 = substr((string)time(),4);
        $code2 = mt_rand(10,99);
        $rand = $code1.$code2;
        $realrand = strrev($rand);
        $res = Db::table('yf_hf_member')->where('hiid',$realrand)->find();
        if ($res){
            self::createRand();
        }else{
            return $realrand;
        }
        //return $realrand;
    }

    /**
     * 临时给机器人加随机数
     * by songjian
     */
    public function tmp(){
        $data=Db::table('yf_hf_member')->where('is_robot',1)->where('hiid',0)->select();
        //for ($i=605;$i<650;$i++){
        foreach($data as $k=>$v){
            //var_dump($v['id']);
            //exit;
            $array = array(
                'hiid' => mt_rand(10000000,99999999)
            );
            $res = Db::table('yf_hf_member')->where('id',$v['id'])->update($array);
            if (!$res){
                echo "error".$v['id'];
                break;
            }else{
                echo "assign id->{$v['id']}hiid{$array['hiid']}\n";
            }
        }
    }

    /**
     * 通过 “2018-04-20”计算年龄
     * by songjian
     * return int
     */
    public static function countAge($birthday=''){
        if ($birthday=='' || $birthday == 0 ){
            $age =  0;
        }else{
            $nowtime = time();
            $birthday = strtotime($birthday);
            $agetime = $nowtime-$birthday;
            $age = floor($agetime/60/60/24/365);
        }
        return $age;
    }

    /**通过经纬度和半径获取范围
     * @auther zyt
     */
    public static function getRang($longitude, $latitude,$nothing='')
    {
        /*$range = 180 / pi() * $radius / 6371;     //里面的 $radius 就代表搜索 $radius Km 之内，单位km
        $lngR = $range / cos($latitude * pi() / 180);
        $params['maxlatitude']  = $latitude + $range;//最大纬度
        $params['minlatitude']  = $latitude - $range;//最小纬度
        $params['maxlongitude'] = $longitude + $lngR;//最大经度
        $params['minlongitude'] = $longitude - $lngR;//最小经度*/
        //获得参数半径
        $radius = Tool::getConfigInfo(85);

        $radius = $radius * 1000;
        $degree = (24901*1609)/360.0;
        $dpmLat = 1/$degree;

        $radiusLat = $dpmLat*$radius;
        $params['minlatitude'] = $latitude - $radiusLat;
        $params['maxlatitude'] = $latitude + $radiusLat;

        $mpdLng = $degree*cos($latitude * (pi()/180));
        $dpmLng = 1 / $mpdLng;
        $radiusLng = $dpmLng*$radius;
        $params['minlongitude'] = $longitude - $radiusLng;
        $params['maxlongitude'] = $longitude + $radiusLng;

        return $params;
    }


    /**(手动搜索)通过经纬度和半径获取范围
     * @auther songjian
     */
    public static function getFindRang($longitude, $latitude,$nothing='')
    {
        //获得参数半径
        $radius = Tool::getConfigInfo(86);

        $radius = $radius * 1000;
        $degree = (24901*1609)/360.0;
        $dpmLat = 1/$degree;

        $radiusLat = $dpmLat*$radius;
        $params['minlatitude'] = $latitude - $radiusLat;
        $params['maxlatitude'] = $latitude + $radiusLat;

        $mpdLng = $degree*cos($latitude * (pi()/180));
        $dpmLng = 1 / $mpdLng;
        $radiusLng = $dpmLng*$radius;
        $params['minlongitude'] = $longitude - $radiusLng;
        $params['maxlongitude'] = $longitude + $radiusLng;

        return $params;
    }


    /**
     * 求两个已知经纬度之间的距离,单位为米
     * by songjian
     * @param lng1 $ ,lng2 经度
     * @param lat1 $ ,lat2 纬度
     * @return float 距离，单位米
     */
    public static function getdistance($lng1, $lat1, $lng2, $lat2) {
        $EARTH_RADIUS = 6371; // 地球半径系数
        $PI = 3.1415926;

        $radLat1 = $lat1 * $PI / 180.0;
        $radLat2 = $lat2 * $PI / 180.0;

        $radLng1 = $lng1 * $PI / 180.0;
        $radLng2 = $lng2 * $PI /180.0;

        $a = $radLat1 - $radLat2;
        $b = $radLng1 - $radLng2;

        $distance = 2 * asin(sqrt(pow(sin($a/2),2) + cos($radLat1) * cos($radLat2) * pow(sin($b/2),2)));
        $distance = $distance * $EARTH_RADIUS * 1000;
        return round($distance,2);
    }

    /**
     * 拿到邀请好友注册随机得到的奖励金[已修改]
     * 发布视频奖励金额
     * by songjian
     * return int
     */
    public static function getRandMoney(){
        $money = Db::table('yf_config')->field('value')->where('id',79)->find()['value'];
        $test = explode('-',$money);
        $randMoney = rand($test[0],$test[1]);
        return $randMoney;
    }

    /**
     * 生成订单号（本年年份+时间戳）
     * by songjian
     * @return int
     */
    public static function getOrder(){
        $order0 = 'hifang';
        $order1 = date('Y');
        $order2 = time();
        $order = $order0.$order1.$order2;
        return $order;
    }


    /**
     * 获取户型图图片路径
     * by songjian
     */
    public static function getImageUrl($time,$filename){
        $website = Tool::getDomain();
        $url =  "{$website}/uploads/img/{$time}/".$filename;
        return $url;
    }

    /**
     * 测试随机昵称
     * by songjian
     */
    public static function getRandName(){
        $tou=array('快乐','冷静','醉熏','潇洒','糊涂','积极','冷酷','深情','粗暴','温柔','可爱','愉快','义气','认真','威武','帅气','传统','潇洒','漂亮','自然','专一','听话','昏睡','狂野','等待','搞怪','幽默','魁梧','活泼','开心','高兴','超帅','留胡子','坦率','直率','轻松','痴情','完美','精明','无聊','有魅力','丰富','繁荣','饱满','炙热','暴躁','碧蓝','俊逸','英勇','健忘','故意','无心','土豪','朴实','兴奋','幸福','淡定','不安','阔达','孤独','独特','疯狂','时尚','落后','风趣','忧伤','大胆','爱笑','矮小','健康','合适','玩命','沉默','斯文','香蕉','苹果','鲤鱼','鳗鱼','任性','细心','粗心','大意','甜甜','酷酷','健壮','英俊','霸气','阳光','默默','大力','孝顺','忧虑','着急','紧张','善良','凶狠','害怕','重要','危机','欢喜','欣慰','满意','跳跃','诚心','称心','如意','怡然','娇气','无奈','无语','激动','愤怒','美好','感动','激情','激昂','震动','虚拟','超级','寒冷','精明','明理','犹豫','忧郁','寂寞','奋斗','勤奋','现代','过时','稳重','热情','含蓄','开放','无辜','多情','纯真','拉长','热心','从容','体贴','风中','曾经','追寻','儒雅','优雅','开朗','外向','内向','清爽','文艺','长情','平常','单身','伶俐','高大','懦弱','柔弱','爱笑','乐观','耍酷','酷炫','神勇','年轻','唠叨','瘦瘦','无情','包容','顺心','畅快','舒适','靓丽','负责','背后','简单','谦让','彩色','缥缈','欢呼','生动','复杂','慈祥','仁爱','魔幻','虚幻','淡然','受伤','雪白','高高','糟糕','顺利','闪闪','羞涩','缓慢','迅速','优秀','聪明','含糊','俏皮','淡淡','坚强','平淡','欣喜','能干','灵巧','友好','机智','机灵','正直','谨慎','俭朴','殷勤','虚心','辛勤','自觉','无私','无限','踏实','老实','现实','可靠','务实','拼搏','个性','粗犷','活力','成就','勤劳','单纯','落寞','朴素','悲凉','忧心','洁净','清秀','自由','小巧','单薄','贪玩','刻苦','干净','壮观','和谐','文静','调皮','害羞','安详','自信','端庄','坚定','美满','舒心','温暖','专注','勤恳','美丽','腼腆','优美','甜美','甜蜜','整齐','动人','典雅','尊敬','舒服','妩媚','秀丽','喜悦','甜美','彪壮','强健','大方','俊秀','聪慧','迷人','陶醉','悦耳','动听','明亮','结实','魁梧','标致','清脆','敏感','光亮','大气','老迟到','知性','冷傲','呆萌','野性','隐形','笑点低','微笑','笨笨','难过','沉静','火星上','失眠','安静','纯情','要减肥','迷路','烂漫','哭泣','贤惠','苗条','温婉','发嗲','会撒娇','贪玩','执着','眯眯眼','花痴','想人陪','眼睛大','高贵','傲娇','心灵美','爱撒娇','细腻','天真','怕黑','感性','飘逸','怕孤独','忐忑','高挑','傻傻','冷艳','爱听歌','还单身','怕孤单','懵懂');
        $do = array("的","爱","","与","给","扯","和","用","方","打","迎","向","踢","笑","闻","有","等于","保卫","演变");
        $wei=array('嚓茶','凉面','便当','毛豆','花生','可乐','灯泡','哈密瓜','野狼','背包','眼神','缘分','雪碧','人生','牛排','蚂蚁','飞鸟','灰狼','斑马','汉堡','悟空','巨人','绿茶','自行车','保温杯','大碗','墨镜','魔镜','煎饼','月饼','月亮','星星','芝麻','啤酒','玫瑰','大叔','小伙','哈密瓜，数据线','太阳','树叶','芹菜','黄蜂','蜜粉','蜜蜂','信封','西装','外套','裙子','大象','猫咪','母鸡','路灯','蓝天','白云','星月','彩虹','微笑','摩托','板栗','高山','大地','大树','电灯胆','砖头','楼房','水池','鸡翅','蜻蜓','红牛','咖啡','机器猫','枕头','大船','诺言','钢笔','刺猬','天空','飞机','大炮','冬天','洋葱','春天','夏天','秋天','冬日','航空','毛衣','豌豆','黑米','玉米','眼睛','老鼠','白羊','帅哥','美女','季节','鲜花','服饰','裙子','白开水','秀发','大山','火车','汽车','歌曲','舞蹈','老师','导师','方盒','大米','麦片','水杯','水壶','手套','鞋子','自行车','鼠标','手机','电脑','书本','奇迹','身影','香烟','夕阳','台灯','宝贝','未来','皮带','钥匙','心锁','故事','花瓣','滑板','画笔','画板','学姐','店员','电源','饼干','宝马','过客','大白','时光','石头','钻石','河马','犀牛','西牛','绿草','抽屉','柜子','往事','寒风','路人','橘子','耳机','鸵鸟','朋友','苗条','铅笔','钢笔','硬币','热狗','大侠','御姐','萝莉','毛巾','期待','盼望','白昼','黑夜','大门','黑裤','钢铁侠','哑铃','板凳','枫叶','荷花','乌龟','仙人掌','衬衫','大神','草丛','早晨','心情','茉莉','流沙','蜗牛','战斗机','冥王星','猎豹','棒球','篮球','乐曲','电话','网络','世界','中心','鱼','鸡','狗','老虎','鸭子','雨','羽毛','翅膀','外套','火','丝袜','书包','钢笔','冷风','八宝粥','烤鸡','大雁','音响','招牌','胡萝卜','冰棍','帽子','菠萝','蛋挞','香水','泥猴桃','吐司','溪流','黄豆','樱桃','小鸽子','小蝴蝶','爆米花','花卷','小鸭子','小海豚','日记本','小熊猫','小懒猪','小懒虫','荔枝','镜子','曲奇','金针菇','小松鼠','小虾米','酒窝','紫菜','金鱼','柚子','果汁','百褶裙','项链','帆布鞋','火龙果','奇异果','煎蛋','唇彩','小土豆','高跟鞋','戒指','雪糕','睫毛','铃铛','手链','香氛','红酒','月光','酸奶','银耳汤','咖啡豆','小蜜蜂','小蚂蚁','蜡烛','棉花糖','向日葵','水蜜桃','小蝴蝶','小刺猬','小丸子','指甲油','康乃馨','糖豆','薯片','口红','超短裙','乌冬面','冰淇淋','棒棒糖','长颈鹿','豆芽','发箍','发卡','发夹','发带','铃铛','小馒头','小笼包','小甜瓜','冬瓜','香菇','小兔子','含羞草','短靴','睫毛膏','小蘑菇','跳跳糖','小白菜','草莓','柠檬','月饼','百合','纸鹤','小天鹅','云朵','芒果','面包','海燕','小猫咪','龙猫','唇膏','鞋垫','羊','黑猫','白猫','万宝路','金毛','山水','音响','尊云','西安');
        $tou_num=rand(0,331);
        $do_num=rand(0,19);
        $wei_num=rand(0,327);
        $type = rand(0,1);
        if($type==0){
            $username=$tou[$tou_num].$do[$do_num].$wei[$wei_num];
        }else{
            $username=$wei[$wei_num].$tou[$tou_num];
        }
        return  $username; //输出生成昵称
    }

    /**
     * 根据user_id生成邀请码
     * by qin
     * @param $user_id
     * @return string
     */
    public static function createCode($user_id) {
        static $source_string = 'E5FCDG3HQA4B1NOPIJ2RSTUV67MWX89KLYZ';
        $num = $user_id;
        $code = '';
        while ( $num > 0) {
            $mod = $num % 35;
            $num = ($num - $mod) / 35;
            $code = $source_string[$mod].$code;
        }
        if(empty($code[3]))
            $code = str_pad($code,6,'0',STR_PAD_LEFT);
        return $code;
    }


    /**
     * 根据邀请码还原user_id
     * by qin 2018-04-25
     * @param $code
     * @return string
     */
    public static function decodeUserId($code) {
        static $source_string = 'E5FCDG3HQA4B1NOPIJ2RSTUV67MWX89KLYZ';
        if (strrpos($code, '0') !== false)
            $code = substr($code, strrpos($code, '0')+1);
        $len = strlen($code);
        $code = strrev($code);
        $num = 0;
        for ($i=0; $i < $len; $i++) {
            $num += strpos($source_string, $code[$i]) * pow(35, $i);
        }
        return $num;
    }

    /**
     * 二维数组去重[只针对获取订单详情列表]
     * by songjian
     */
    public static function remove_duplicate($array){
        $result=array();
        foreach ($array as $key => $value) {
            $has = false;
            foreach($result as $val){
                if($val['money']==$value['money'] && $val['title']==$value['title'] && $val['time'] = $value['time']){
                    $has = true;
                    break;
                }
            }
            if(!$has)
                $result[]=$value;
        }
        return $result;
    }

    /**
     * PHP发送跨域请求
     * by songjian
     * @return array
     */
    public static function httpRequest($api, $postData = array())
    {
        //1.初始化
        $ch = curl_init();
        //2.配置
        //2.1设置请求地址
        curl_setopt($ch, CURLOPT_URL, $api);
        //2.2数据流不直接输出
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        //2.3POST请求
        if ($postData) {
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
        }
        //curl注意事项，如果发送的请求是https，必须要禁止服务器端校检SSL证书
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        //3.发送请求
        $data = curl_exec($ch);
        //4.释放资源
        curl_close($ch);
        return json_decode($data, true);
    }

    /**
     * 添加机器人规则
     * By songjian
     */
    public static function robotRules($type,$building_id='',$user_id='',$video_id='',$video_type=''){
        //执行机器人评论功能
        $sql = "SELECT * FROM `yf_hf_member` where is_robot=1";
        $res = Db::query($sql);
        $array_robot = [];
        if ($res) {
            for($i=0;$i<count($res);$i++){
                $array_robot[] = $res[$i]['id'];
            }
        }
        /*
         * 机器人第一次3小时评论一次评论功能
         */
        if ($video_type == 1 ){
            $array = config('array_sell');
        }elseif ($video_type == 0 || $video_type == 2){
            $array = config('array_rent');
        }
        $content = $array[mt_rand(0,count($array)-1)];
        $robot_data = Db::table('yf_hf_robot_data')->insert([
            'id'                => 0,
            'robot_id'          => $array_robot[mt_rand(0,count($array_robot)-1)],
            'operated_id'       => $video_id,
            'data'              => $content,
            'status'            => 1,
            'create_time'       => strtotime(date('Y-m-d H:i:s',strtotime('+3 hours'))),
            'update_time'       => strtotime(date('Y-m-d H:i:s',strtotime('+3 hours')))
        ]);
        /*
         * 10小时后随机(关注人+评论+赞)
         */
        //获取随即自行的操作 1评论功能 2关注用户功能 3关注小区功能 4点赞视频功能 //5浏览视频功能
        $arr = [1,2,3,4];
        $type1 = $arr[mt_rand(0,count($arr)-1)];
        $time1 = strtotime(date('Y-m-d H:i:s',strtotime('+10 hours')));
        $res = Tool::robot_rule($array_robot[mt_rand(0,count($array_robot)-1)],$type1,$building_id,$user_id,$video_id,$video_type,$time1);
        /*
         * 30小时后随机(关注人+评论+赞)
         */
        //获取随即自行的操作 1评论功能 2关注用户功能 3关注小区功能 4点赞视频功能 //5浏览视频功能
        $type2 = $arr[mt_rand(0,count($arr)-1)];
        $time2 = strtotime(date('Y-m-d H:i:s',strtotime('+30 hours')));
        $res = Tool::robot_rule($array_robot[mt_rand(0,count($array_robot)-1)],$type2,$building_id,$user_id,$video_id,$video_type,$time2);

        /*
         * 机器人浏览 随机
         */
        $robot_lookthrough = Tool::robot_lookthrough($video_id);
    }
    public static function robot_rule($robot_id,$type,$building_id='',$user_id='',$video_id='',$video_type='',$time){
        if ( $type ==1 ){
            if ($video_type == 1 ){
                $array = config('array_sell');
            }elseif ($video_type == 0 || $video_type == 2){
                $array = config('array_rent');
            }
            $content = $array[mt_rand(0,count($array)-1)];
            $robot_data = Db::table('yf_hf_robot_data')->insert([
                'id'                => 0,
                'robot_id'          => $robot_id,
                'operated_id'       => $video_id,
                'data'              => $content,
                'status'            => 1,
                'create_time'       => $time,
                'update_time'       => $time
            ]);
        }
        elseif ( $type == 2 ){
            //执行机器人关注用户功能
            $member_count = mt_rand(1,10);
            $sql = "SELECT * FROM `yf_hf_member` where is_robot=1 ORDER BY RAND() LIMIT {$member_count}";
            $res = Db::query($sql);
            //关注用户功能  需要发布视频的用户id
            //判断此人是否是第一次发布视频 ,若是 机器人加关注,若不是机器人跳过关注
            $res = Db::table('yf_hf_video')->where('member_id',$user_id)->select();
            if (count($res) < 2) {
                $robot_data = Db::table('yf_hf_robot_data')->insert([
                    'id'                => 0,
                    'robot_id'          => $robot_id,
                    'operated_id'       => $user_id,
                    'data'              => '',
                    'status'            => 2,
                    'create_time'       => $time,
                    'update_time'       => $time
                ]);
            }
        }
        elseif ( $type == 3 ){
            //执行机器人关注小区功能
            $robot_data = Db::table('yf_hf_robot_data')->insert([
                'id'                => 0,
                'robot_id'          => $robot_id,
                'operated_id'       => $building_id,
                'data'              => '',
                'status'            => 3,
                'create_time'       => $time,
                'update_time'       => $time
            ]);
        }
        elseif ( $type == 4){
            //执行机器人点赞视频操作
            $robot_data = Db::table('yf_hf_robot_data')->insert([
                'id'                => 0,
                'robot_id'          => $robot_id,
                'operated_id'       => $video_id,
                'data'              => '',
                'status'            => 4,
                'create_time'       => $time,
                'update_time'       => $time
            ]);
        }
    }
    //机器人浏览 待测试
    public static function robot_lookthrough($video_id){
        Log::info("=======robot_lookthrough-begin========");
        //添加浏览功能 让一定量的机器人在一定自然时间内自然的浏览
        //执行机器人评论功能
        $sql = "SELECT * FROM `yf_hf_member` where is_robot=1";
        $res = Db::query($sql);
        $array_robot = [];
        if ($res) {
            for($i=0;$i<count($res);$i++){
                $array_robot[] = $res[$i]['id'];
            }
        }
        $rand = mt_rand(0,5);
        Log::info("=======robot_lookthrough-rand========");
        Log::info($rand);
        for($i=0;$i<$rand;$i++){
            $robot_liulan[] = $array_robot[mt_rand(0,count($array_robot)-1)];
        }
        //机器人浏览 存入临时表
        for ($i=0;$i<count($robot_liulan);$i++) {
            //执行机器人浏览视频操作
            $time_liulan = time()+mt_rand(60,600);
            $robot_data = Db::table('yf_hf_robot_data')->insert([
                'id'                => 0,
                'robot_id'          => $robot_liulan[$i],
                'operated_id'       => $video_id,
                'data'              => '',
                'status'            => 5,
                'create_time'       => $time_liulan,
                'update_time'       => $time_liulan
            ]);
        }
        Log::info("=======robot_lookthrough-end========");
    }

    /**
     * 定时任务 临时表数据存入指定表
     * @param Request $request
     * @auther zyt
     */
    public function robotDataToTable () {
        //查询$time之前的数据
        $robotData = Db::table('yf_hf_robot_data')->where('create_time','<=',time())->select();
        $robot_ids = [];
        if ($robotData) {
            for ($i=0;$i<count($robotData);$i++) {
                if ($robotData[$i]['status'] == 1) {
                    //将评论数据 存入评论表
                    $res = $this->pinglun($robotData[$i]['robot_id'],$robotData[$i]['operated_id'],$robotData[$i]['data']);
                }
                elseif ($robotData[$i]['status'] == 2) {
                    $res = $this->gzr($robotData[$i]['robot_id'],$robotData[$i]['operated_id']);
                }
                elseif ($robotData[$i]['status'] == 3) {
                    $res = $this->gzxq($robotData[$i]['robot_id'],$robotData[$i]['operated_id']);
                }
                elseif ($robotData[$i]['status'] == 4) {
                    $res = $this->dianzan($robotData[$i]['robot_id'],$robotData[$i]['operated_id']);
                }
                elseif ($robotData[$i]['status'] == 5) {
                    $res = $this->lookthrough($robotData[$i]['robot_id'],$robotData[$i]['operated_id']);
                }
                $robot_ids[] = $robotData[$i]['id'];
            }
            //删除临时表数据
            $delete_robot = Db::table('yf_hf_robot_data')->whereIn('id',$robot_ids)->delete();
            dump($delete_robot);
        }
    }
    //机器人评论功能
    public function pinglun($robot_id,$operated_id,$content)
    {
        //将评论数据 存入评论表
        //查询发布该视频的用户id
        $userId = Db::table('yf_hf_video')->where('id',$operated_id)->value('member_id');
        $data['id']           = 0;
        $data['content']      = $content;
        $data['member_id']    = $robot_id;
        $data['video_id']     = $operated_id;
        $data['user_id']      = $userId;
        $data['parent_id']    = 0;
        $data['comment_num']  = 0;
        $data['create_time']  = time();
        $data['update_time']  = time();

        $comment = Db::table('yf_hf_comment')->insert($data);
        //修改视频表中的评论数
        $num_comment = Db::table('yf_hf_video')->where('id',$operated_id)->setInc('num_comment');

    }
    //机器人关注人功能
    public function gzr($robot_id,$operated_id)
    {
        //将关注用户数据 存入关注表
        //判断该用户是否关注过,关注过则不在关注,否则去关注
        //关注follow表添加数据,状态is_followed=1为关注
        $follow = Db::table('yf_hf_follow')->where(['member_id'=>$robot_id,'followed_id'=>$operated_id,'type'=>0])->find();
        if (!$follow) {
            $data1['id']          = 0;
            $data1['member_id']   = $robot_id;
            $data1['followed_id'] = $operated_id;
            $data1['type']        = 0;//0关注用户
            $data1['black']       = 0;
            $data1['is_followed'] = 1;
            $data1['create_time'] = time();
            $data1['update_time'] = time();
            $res = Db::table('yf_hf_follow')->insert($data1);
            //修改被关注人的粉丝数
            $num_follow = Db::table('yf_hf_member')->where('id', $operated_id)->setInc('num_follow');
            //修改关注人数
            $num_member = Db::table('yf_hf_member')->where('id', $robot_id)->setInc('num_member');
        }
    }
    //机器人关注小区功能
    public function gzxq($robot_id,$operated_id)
    {
        //将关注小区数据 存入关注表
        //判断该用户是否关注过,关注过则不在关注,否则去关注
        //关注follow表添加数据,状态is_followed=1为关注
        $follow = Db::table('yf_hf_follow')->where(['member_id'=>$robot_id,'followed_id'=>$operated_id,'type'=>1])->find();
        if (!$follow) {
            $data1['id']          = 0;
            $data1['member_id']   = $robot_id;
            $data1['followed_id'] = $operated_id;
            $data1['type']        = 1;//1关注小区
            $data1['black']       = 0;
            $data1['is_followed'] = 1;
            $data1['create_time'] = time();
            $data1['update_time'] = time();
            $res = Db::table('yf_hf_follow')->insert($data1);
            //修改机器人用户表中关注小区数
            $data2 = Db::table('yf_hf_member')->where('id',$robot_id)->setInc('num_buildings');
            //修改被关注小区的关注数
            $follow_count = Db::table('yf_hf_buildings')->where('id', $operated_id)->setInc('follow_count');
        }
    }
    //机器人点赞功能
    public function dianzan($robot_id,$operated_id)
    {
        //将点赞数据 存入关注表
        //关注follow表添加数据,状态is_followed=1为关注
        $data1['id']          = 0;
        $data1['member_id']   = $robot_id;
        $data1['followed_id'] = $operated_id;
        $data1['type']        = 2;//2点赞视频
        $data1['black']       = 0;
        $data1['is_followed'] = 1;
        $data1['create_time'] = time();
        $data1['update_time'] = time();
        $res = Db::table('yf_hf_follow')->insert($data1);
        //修改视频表中被关注视频的收藏数,点赞数
        //查询发布该视频的人
        $member_id = Db::table('yf_hf_video')->where('id',$operated_id)->value('member_id');
        DB::table('yf_hf_video')->where('id',$operated_id)->setInc('num_favorite');
        DB::table('yf_hf_member')->where('id',$robot_id)->setInc('num_good_video');
        DB::table('yf_hf_member')->where('id',$member_id)->setInc('num_prise');
    }
    //机器人浏览功能
    public function lookthrough($robot_id,$operated_id)
    {
        //浏览数据存入浏览表
        $data1['id'] = 0;
        $data1['member_id']  = $robot_id;  //用户id
        $data1['video_id']   = $operated_id;  //视频id
        $data1['real_time']  = time();  //
        $data1['create_time'] = time();
        $data1['update_time'] = time();
        $res = Db::table('yf_hf_lookthrough')->insert($data1);
        //修改视频表中被关注视频的收藏数,点赞数
        //浏览量加1
        DB::table('yf_hf_video')->where('id',$operated_id)->setInc('num_visits');
    }


    /**
     * 定时任务删除七牛云水印视频
     * @param Request $request
     */
    public function delQiniuyunVideo () {
        //删除七牛云视频
        $watermark_video = Db::table('yf_hf_watermark_video')->where('create_time','<=',time())->select();
        if ($watermark_video) {
            for ($i=0;$i<count($watermark_video);$i++) {
                $video_url = $watermark_video[$i]['video_link'];
                $videoUrl  = explode('/', $video_url);
                //视频key
                $videoKey  = $videoUrl[count($videoUrl)-1];
                QiniuTools::delete($videoKey);
            }
            dump('ok');
        }
    }

    /**
     *
     * @param Request $request
     * @auther zyt
     */
    public function getFiles () {
        $arr = [];
        //打开要操作的目录
        /*$handler = opendir('Y:\hi-fang\haifang');
        while( ($filename = readdir($handler)) !== false )
        {
            //过滤掉目录名字为’.'和‘..’目录
            if($filename != "." && $filename != "..")
            {
                $arr[] = $filename;
            }
        }
        //关闭目录
        closedir($handler);
        $ids = [];
        for ($i=0;$i<count($arr);$i++) {
            $id = Db::table('yf_hf_video_58_changning')->where('videoname',$arr[$i])->value('id');
            if ($id) {
                $ids[] = $id;
            }
        }
        //dump($ids);exit;
        $deleteVideo = Db::table('yf_hf_video_58_changning')->whereNotIn('id',$ids)->delete();
        dump($deleteVideo);exit;*/

        //查询上海周边的数据名
        /*$videoname = [];
        $video = Db::table('yf_hf_video_58')->where('address','like','上海周边')->select();dump($video);exit;
        for($i=0;$i<count($video);$i++){
            $videoname[] = $video[$i]['videoname'];
        }

        dump($videoname);exit;*/

        /*$handler = opendir('Y:\hi-fang\haifang');
        while( ($filename = readdir($handler)) !== false )
        {
            //过滤掉目录名字为’.'和‘..’目录
            if($filename != "." && $filename != "..")
            {
                if (in_array($filename, $videoname)) {
                    $res=unlink('Y:\\hi-fang\\haifang\\'.$filename);
                }
            }
        }
        //关闭目录
        closedir($handler);*/
//        $res = Db::table('yf_hf_video_58')->where('address','上海周边')->delete();
//        dump($res);


    }

    public function test(Request $request){
        $data = array(
            'id' => 0,
            'title' => $request->param('title'),
            'video_link' => $request->param('video_link'),
            'video_type' => intval($request->param('video_type')),
            'video_cover' => $request->param('video_cover'),
            'num_room'    => $request->param('num_room'),
            'num_hall'    => $request->param('num_hall'),
            'num_toilet'    => $request->param('num_toilet'),
            'area'    => $request->param('area'),
            'price'    => $request->param('price'),
            'member_id'    => $request->param('member_id'),
            'building_id'    => $request->param('building_id'),
            'longitude'    => $request->param('longitude'),
            'latitude'    => $request->param('latitude'),
            'app_version'    => '1.0.0',
            'remarks'    => $request->param('remarks'),
            'create_time'    => time(),
            'update_time'    => time(),
        );
        $res = Db::table('yf_hf_video')->insert($data);
        if ($res){
            echo "添加成功";
        }else{
            echo "添加失败";
        }
    }

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
        //$randMusic = array_rand(config('array_music'),1);
        $array_music = [
            'http://p9qck5myp.bkt.clouddn.com/%E6%88%91%E7%9A%84%E5%AE%9D%E8%B4%9D-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E5%A4%B1%E6%81%8B%E8%80%85%E8%81%94%E7%9B%9F-LD.mp3',
            'http://p9qck5myp.bkt.clouddn.com/%E5%A4%9A%E5%B9%B8%E8%BF%90-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E6%88%91%E7%88%B1%E4%BD%A0%E4%BA%B2%E7%88%B1%E7%9A%84-LD.mp3',
            'http://p9qck5myp.bkt.clouddn.com/trip-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E5%8F%91%E7%8E%B0-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E6%97%A7%E6%97%B6%E5%85%89-LD.mp3',
            'http://p9qck5myp.bkt.clouddn.com/%E8%AE%A4%E7%9C%9F%E7%9A%84%E9%9B%AA-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E5%92%96%E5%96%B1%E5%92%96%E5%96%B1-LD.mp3',
            'http://p9qck5myp.bkt.clouddn.com/%E9%97%B7-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E5%8F%AF%E7%88%B1%E9%A2%82-LD.mp3',
            'http://p9qck5myp.bkt.clouddn.com/%E7%BB%93%E5%A9%9A%E5%90%A7-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E9%86%89-LD.mp3',
            'http://p9qck5myp.bkt.clouddn.com/%E6%9C%89%E4%BD%95%E4%B8%8D%E5%8F%AF-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E5%8D%88%E9%A4%90-LD.mp3',
            'http://p9qck5myp.bkt.clouddn.com/%E7%AE%97%E4%BD%A0%E7%8B%A0-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E6%9C%89%E7%82%B9%E7%94%9C-LD.mp3',
            'http://p9qck5myp.bkt.clouddn.com/%E5%A5%87%E5%A6%99%E8%83%BD%E5%8A%9B%E6%AD%8C-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E8%BF%9C%E8%B5%B0%E9%AB%98%E9%A3%9E-LD.mp3',
            'http://p9qck5myp.bkt.clouddn.com/GQ-LD.mp3'
        ];
        //$randMusic = array_rand($array_music,1);
        $randMusic=$array_music[mt_rand(0,count($array_music)-1)];
        $music = \Qiniu\base64_urlSafeEncode($randMusic);
        //要进行转码的转码操作。 http://developer.qiniu.com/docs/v6/api/reference/fop/av/avthumb.html
        $fops = "avthumb/mp4/multiArep/".$music."|saveas/" . \Qiniu\base64_urlSafeEncode($bucket . ":$key");
        list($id, $err) = $pfop->execute($bucket, $key, $fops, $pipeline, $notifyUrl, true);
        //echo "\n====> pfop avthumb result: \n";
        /*if ($err !== null) {
            var_dump($err);
        } else {
            echo "PersistentFop Id: $id\n";
        }*/
        //查询转码的进度和状态
        list($ret, $err) = $pfop->status($id);
        //echo "\n====> pfop avthumb status: \n";
        if ($err !== null) {
            return false;
        } else {
            return true;
        }
    }

    /**
     * 自动判断出售出租房源自动下架时间
     * by songjian
     */
    public function automaticDowm(){
        //出租房源自动下架时间
        $rent_down_time = self::getConfigInfo(80);
        $rent_time  = $rent_down_time * 24 * 60 * 60;
        //出售房源自动下架时间
        $sell_down_time = self::getConfigInfo(81);
        $sell_time  = $sell_down_time * 24 * 60 * 60;

        $video_info = Db::table('yf_hf_video')->where('create_time','<=',time())->select();

        foreach ($video_info as $item){
            $times = time() - (int)$item['create_time'];
            //出售
            if ($item['video_type'] == 1){
                if ($times >= $sell_time){
                    Db::table('yf_hf_video')->where('id',$item['id'])->update(['status'=>0]);
                    continue;
                }
            }elseif ($item['video_type'] == 0 || $item['video_type'] == 2){
                //出租
                if ($times >= $rent_time){
                    Db::table('yf_hf_video')->where('id',$item['id'])->update(['status'=>0]);
                    continue;
                }
            }
        }
    }
    public function tests(){
        $res = Behavior::insertBackBehavior(666,19,'');
        return $res;
    }

    /**
     * 转发分享 生成水印二维码
     * @auther zyt
     * @time 2018/7/3
     */
    public function getQrCode($member_id){
        Loader::import('eacoo.phpqrcode');
        $path = PUBLIC_PATH .'uploads'.DS.'qrcode'. DS;
        $filename = $path .$member_id . '.png';
        $bigImgPath = $path.'39881845781562322.png';

        //===================二维码与背景图合并
        //生成二维码图片
        $errorCorrectionLevel = 'L';	//容错级别
        $matrixPointSize = 4.6;			//生成图片大小
        $value = Tool::getDomain().'/web/index.html#/weixinDownload';
        \QRcode::png($value,$filename , $errorCorrectionLevel, $matrixPointSize, 2);

        /*list($qWidth, $qHight) = getimagesize($filename);
        dump($qWidth);dump($qHight);exit;*/
        /*if (!file_exists($filename)) {
            \QRcode::png($value,$filename , $errorCorrectionLevel, $matrixPointSize, 2);
        }*/
        $qCodePath = $filename;				//已经生成的原始二维码图片文件
        $bigImg = imagecreatefromstring(file_get_contents($bigImgPath));
        $qCodeImg = imagecreatefromstring(file_get_contents($qCodePath));
        list($qCodeWidth, $qCodeHight, $qCodeType) = getimagesize($qCodePath);
        // imagecopymerge使用注解  图片二维码水印
        //imagecopymerge($bigImg, $qCodeImg, 541, 554, 0, 0, $qCodeWidth, $qCodeHight, 100); 标准
        imagecopymerge($bigImg, $qCodeImg, 554, 548, 0, 0, $qCodeWidth, $qCodeHight, 100);
        //===================二维码与背景图合并

        //获取用户信息
        $member = Db::table('yf_hf_member')->where('id',$member_id)->find();
        $hiid = $member['hiid'];
        if ($member['unionid'] || $member['is_robot']!=0){
            $headimgurl = $member['headimgurl'];
        }else{
            $headimgurl = Tool::getDomain().$member['headimgurl'];
        }

        //==================水印内容
        $font = PUBLIC_PATH.'static'.DS.'assets'.DS.'fonts'.DS.'PingFang Medium_downcc.otf';//字体
        $black1 = imagecolorallocate($bigImg, 102, 102, 102);//字体颜色 RGB
        $black2 = imagecolorallocate($bigImg, 153, 153, 153);//字体颜色 RGB
        //imagefttext($bigImg, 17, 0, 150, 575, $black1, $font, $member['nickname']);
        imagefttext($bigImg, 26, 0, 150, 610, $black1, $font, $member['nickname']);
        //imagefttext($bigImg, 12, 0, 150, 630, $black2, $font, '我在嗨房等你来!');
        imagefttext($bigImg, 18, 0, 150, 656, $black2, $font, '我在嗨房等你来!');
        //==================水印内容

        //===========头像与背景图合并
        $imgPath1 = $path .'qrcode-'.$hiid.'.png';
        $imgs['src'] = Tool::getRoundImg($headimgurl);
        $imgs['dst'] = $bigImg;
        //$desc = Tool::mergerImg($imgs,46,577,$imgPath1);
        $desc = Tool::mergerImg($imgs,46,577,$imgPath1);

        list($bigWidth, $bigHight, $bigType) = getimagesize($bigImgPath);
        switch ($bigType) {
            case 1: //gif
                header('Content-Type:image/gif');
                $re = imagegif($bigImg,$path .'qrcode-'.$hiid.'.gif');
                break;
            case 2: //jpg
                header('Content-Type:image/jpeg');
                $re = imagejpeg($bigImg,$path .'qrcode-'.$hiid.'.jpg');
                break;
            case 3: //png
                header('Content-Type:image/png');
                $re = imagepng($bigImg,$path .'qrcode-'.$hiid.'.png');
                break;
            default:
                # code...
                break;
        }
        imagedestroy($bigImg);
        imagedestroy($qCodeImg);
        if ($re) {
            return '/uploads/qrcode/qrcode-'.$hiid.'.png';
        } else {
            return false;
        }

    }
    /**
     *生成圆角图片
     * @param $url图片路径
     * @return string
     */
    public function getRoundImg($url){
        $w = 88;  $h=88; // original size
        $dest_path = uniqid().'.png';

        $ch = curl_init();
        $timeout = 5;
        curl_setopt ($ch, CURLOPT_URL, $url);
        curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
        $img_str = curl_exec($ch);
        curl_close($ch);


        $src = imagecreatefromstring($img_str);
        $newpic = imagecreatetruecolor($w,$h);
        imagealphablending($newpic,false);
        $transparent = imagecolorallocatealpha($newpic, 254, 254, 254, 127);
        $r=$w/2;
        for($x=0;$x<$w;$x++)
            for($y=0;$y<$h;$y++){
                $c = imagecolorat($src,$x,$y);
                $_x = $x - $w/2;
                $_y = $y - $h/2;
                if((($_x*$_x) + ($_y*$_y)) < ($r*$r)){
                    imagesetpixel($newpic,$x,$y,$c);
                }else{
                    imagesetpixel($newpic,$x,$y,$transparent);
                }
            }
        imagesavealpha($newpic, true);
        // header('Content-Type: image/png');
        imagepng($newpic, $dest_path);
        imagedestroy($newpic);
        imagedestroy($src);
        return $dest_path;
    }
    /**
     * 合并图片
     * @param $imgs 数组：src合成图，dst背景
     * @param $dst_x 合成的x
     * @param $dst_y 合成的y
     * @param $saveName 保存别名
     * @return mixed
     */
    public function mergerImg($imgs,$dst_x,$dst_y,$saveName) {
        $src_im = imagecreatefrompng($imgs['src']);
        $src_info = getimagesize($imgs['src']);
        imagecopy($imgs['dst'],$src_im,$dst_x,$dst_y,0,0,$src_info[0],$src_info[1]);
        imagedestroy($src_im);

        imagejpeg($imgs['dst'],$saveName);
        unlink($imgs['src']);
        return $saveName;
    }
    /**
     * 合并文字
     * @param $imgs 数组：src合成图，dst背景
     * @param $dst_x 合成的x
     * @param $dst_y 合成的y
     * @param $saveName 保存别名
     * @return mixed
     */
    public function mergerWord($imgs,$dst_x,$dst_y,$saveName) {

        list($max_width, $max_height) = getimagesize($imgs['dst']);
        $dests = imagecreatetruecolor($max_width, $max_height);
        $dst_im = imagecreatefrompng($imgs['dst']);
        imagecopy($dests,$dst_im,0,0,0,0,$max_width,$max_height);
        imagedestroy($dst_im);

        $src_im = imagecreatefrompng($imgs['src']);
        $src_info = getimagesize($imgs['src']);
        imagecopy($dests,$src_im,$dst_x,$dst_y,0,0,$src_info[0],$src_info[1]);
        imagedestroy($src_im);

        imagejpeg($dests,$saveName);
        unlink($imgs['src']);
        return $saveName;
    }

    /*
     * 将图片切成圆角
     * @auther zyt
     * test
     */
    public function yuanjiao(){
        $imgpath = 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLX8ole5k6gIf7hlliaGb3ZzFBD4TPkc98SnGRR9kfd5d7Aj1mtlHhsFg2EWA6tNrc8PrYxXZbnhPA/132';

        $src_img = imagecreatefromstring(file_get_contents($imgpath));
        $w = imagesx($src_img);
        $h = imagesy($src_img);
        $w   = min($w, $h);
        $h   = $w;
        $img = imagecreatetruecolor($w, $h);
        //这一句一定要有
        imagesavealpha($img, true);

        //拾取一个完全透明的颜色,最后一个参数127为全透明
        $bg = imagecolorallocatealpha($img, 255, 255, 255, 127);
        imagefill($img, 0, 0, $bg);

        $r   = $w / 2; //圆半径
        $y_x = $r; //圆心X坐标
        $y_y = $r; //圆心Y坐标
        for ($x = 0; $x < $w; $x++) {
            for ($y = 0; $y < $h; $y++) {
                $rgbColor = imagecolorat($src_img, $x, $y);
                if (((($x - $r) * ($x - $r) + ($y - $r) * ($y - $r)) < ($r * $r))) {
                    imagesetpixel($img, $x, $y, $rgbColor);
                }
            }
        }
        header('Content-Type: image/png');
        imagepng($img);exit;

    }

    /**
     * 获取商圈
     * @param $area_name
     * @param $name
     * @return string
     */
    public static function getBuildingName($area_name,$name){
        $result = array();
        $address = preg_match_all("/(?:\()(.*)(?:\))/i",$area_name, $result);
        $area = $result[1][0];
        $video1 = mb_substr($area,0,2);
        $video2 = mb_substr($area,2);
        $array = ['雨花台'];
        foreach($array as $value){
            if (strpos($area,$value) !== false) {
                $video1 = mb_substr($area,0,3);
                $video2 = mb_substr($area,3);
            }
        }

        return  $video1 .'/'. $video2 . '/' . $name;
    }

    /**
     * 分享自微信获取默认封面
     * @auther  zyt
     * @time 2018/7/12 11:15
     */
    public static function getDefaultCover(){
        $cover = [
            'http://p79qapu16.bkt.clouddn.com/%E5%88%86%E4%BA%AB%E9%BB%98%E8%AE%A41.png',
            'http://p79qapu16.bkt.clouddn.com/%E5%88%86%E4%BA%AB%E9%BB%98%E8%AE%A42.png',
            'http://p79qapu16.bkt.clouddn.com/%E5%88%86%E4%BA%AB%E9%BB%98%E8%AE%A43.png',
            'http://p79qapu16.bkt.clouddn.com/%E5%88%86%E4%BA%AB%E9%BB%98%E8%AE%A45.png',
            'http://p79qapu16.bkt.clouddn.com/%E5%88%86%E4%BA%AB%E9%BB%98%E8%AE%A44.png'
        ];
        return  $cover[rand(0,4)];
    }

    /**
     * 视频批量上传七牛云
     */
    public function uploadQiniuyun(){
        $data['code'] = 101;
        $data['message'] = '';

        Log::info("========uploadQiniuyun1=======");
        $query = "select v.id from yf_hf_video_58 v join yf_hf_buildings b on b.name=v.building where status=1";
        $arr = Db::query($query);
        Log::info($arr);
        for ($i=0;$i<count($arr);$i++) {
            $id = $arr[$i]['id'];
            Log::info($id);
            $arr = Db::table('yf_hf_buildings')->alias('b')
                ->join('yf_hf_area a', 'b.area_id=a.id')
                ->join('yf_hf_video_58 v', 'b.name=v.building')
                ->field('v.building as name,v.id,b.id as building_id')
                ->where('v.id', $id)
                ->find();
            $video_id = $arr['id'];
            $building_id = $arr['building_id'];

            $info = Db::table('yf_hf_video_58')->where('id', $video_id)->find();
            $filename = $info['videoname'];
            /*
             * 1.上传视频
             */
            Log::info("========1.上传视频=======");
            $video_filePath = PUBLIC_PATH . "uploads/download/haifang/{$filename}";
            // 需要填写你的 Access Key 和 Secret Key
            $accessKey = "2HzSOxN30PJk8km94quVwVtmKvrA0_NyqFVcZQaW";
            $secretKey = "yxjfFeYNDKPhOq2sQd1b2OrGkgjqkVz_BXs_WMNq";
            $bucket = "hifang";
            // 构建鉴权对象
            $auth = new Auth($accessKey, $secretKey);
            // 生成上传 Token
            $token = $auth->uploadToken($bucket);
            // 上传到七牛后保存的文件名
            $video_key = $filename;        //视频的文件名
            //初始化 UploadManager 对象并进行文件的上传。
            $uploadMgr = new UploadManager();
            // 调用 UploadManager 的 putFile 方法进行文件的上传。
            //第一步，上传视频
            list($ret1, $err1) = $uploadMgr->putFile($token, $video_key, $video_filePath);
            if ($err1 === null) {
                //合成音乐结果
                $res = Tool::createMusic($video_key);
                if ($res == true) {
                    //下载此视频的封面图
                    $url = 'http://p79qkwz6c.bkt.clouddn.com/' . $video_key . '?vframe/jpg/offset/5';
                    $filenames = $video_key . "_img.jpg";
                    $res = $this->GrabImage($url, $dir = './uploads/download/img', $filenames);
                    $video_path = 'http://p79qkwz6c.bkt.clouddn.com/' . $video_key;
                }
            }
            /*
             * 2.上传封面图
             */
            Log::info("========2.上传封面图=======");
            // 要上传文件的本地路径
            // 上传到七牛后保存的文件名
            $img_key = $filenames;    //封面图的文件名
            //初始化 UploadManager 对象并进行文件的上传。
            $uploadMgr = new UploadManager();
            // 调用 UploadManager 的 putFile 方法进行文件的上传。
            //上传图片
            list($ret1, $err1) = $uploadMgr->putFile($token, $img_key, $res);
            $img_path = 'http://p79qkwz6c.bkt.clouddn.com/' . $img_key;
            /*
             * 3.将新整合的信息放到video表中
             */
            Log::info("========3.将新整合的信息放到video表中=======");
            $video_info = Db::table('yf_hf_video_58')->where('id', $video_id)->find();
            $area_id = Db::table('yf_hf_buildings')->field(['area_id'])->where('id', $building_id)->find()['area_id'];
            $data = array(
                'id' => 0,
                'title' => $video_info['title'],
                'video_link' => $video_path,
                'video_type' => 1,
                'video_cover' => $img_path,
                'status' => 1,
                'sort' => 1,
                'num_room' => $video_info['num_room'],
                'num_hall' => $video_info['num_hall'],
                'num_toilet' => $video_info['num_toilet'],
                'area' => $video_info['area'],
                'price' => $video_info['price'],
                'area_id' => $area_id,
                'member_id' => rand(650, 2000),
                'building_id' => $building_id,
                'longitude' => $video_info['longitude'],
                'latitude' => $video_info['latitude'],
                'app_version' => '1.0.0',
                'remarks' => '',
                'examine' => 1,
                'create_time' => time(),
                'update_time' => time()
            );
            $res = Db::table('yf_hf_video')->insert($data);
            Log::info($res);
            if ($res) {
                $result = Db::table('yf_hf_video_58')->where('id', $video_id)->update(['status' => 0]);
                if ($result) {
                    $data['code'] = 200;
                    $data['message'] = '操作成功';
                } else {
                    $data['message'] = '操作失败';
                }
            } else {
                $data['code'] = 200;
                $data['message'] = '操作成功';
            }

            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
    }
    /**
     * 将网络资源封面图下载到本地文件夹
     * by songjian
     */
    public function GrabImage($url='', $dir='./uploads/download/img', $filename=''){
        if(empty($url)){
            return false;
        }
        $ext = strrchr($url, '.');
        //为空就当前目录
        if(empty($dir))$dir = './';
        $dir = realpath($dir);
        //目录+文件
        $filename = $dir . (empty($filename) ? '/'.time().$ext : '/'.$filename);
        //开始捕捉
        ob_start();
        readfile($url);
        $img = ob_get_contents();
        ob_end_clean();
        $size = strlen($img);
        $fp2 = fopen($filename , "a");
        fwrite($fp2, $img);
        fclose($fp2);
        return $filename;
    }

}