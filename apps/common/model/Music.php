<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/27
 * Time: 9:32
 */
namespace app\common\model;

use app\api\controller\Tool;
use think\Model;
use think\Db;

class Music extends Base
{
    // 设置当前模型对应的完整数据表名称
    protected $table = 'yf_hf_music';

    public function getMusicList(){
        $info = Db::table("yf_hf_music")
            ->field(['id','music_url','image_url','title','time'])
            ->select();
        $url = Tool::getDomain();
        for ($i=0;$i<count($info);$i++) {
            $info[$i]['image_url'] = $url.$info[$i]['image_url'];
        }
        return $info;
    }
}
