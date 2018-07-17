<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/6/20
 * Time: 15:53
 */
namespace app\common\model;

use think\Model;
use think\Db;

class LookThrough extends Base
{
    // 设置当前模型对应的完整数据表名称
    protected $table = 'yf_hf_lookthrough';

    /**
     * 获取浏览列表
     * @param $video_id
     * @param $pageNo
     * @param int $pageSize
     */
    public function getLookThroughList($video_id, $pageNo=1, $pageSize=10)
    {
        $limit = " LIMIT ".($pageNo-1)*$pageSize.",".$pageSize;
        $sql = "select * from (SELECT `l`.`id`,`l`.`member_id`,`l`.`video_id`,`l`.`real_time`,`l`.`create_time`,`l`.`update_time`,`m`.`nickname`,`m`.`headimgurl` FROM `yf_hf_lookthrough` `l` LEFT JOIN `yf_hf_member` `m` ON `m`.`id`=`l`.`member_id` WHERE `video_id`=".$video_id." ORDER BY `l`.`real_time` desc) as t2 group by `member_id` order by  `real_time` desc";
        $sql1 = $sql . $limit;
        $lookthrough = Db::query($sql);
        $total = ceil(count($lookthrough)/$pageSize);
        $list = Db::query($sql1);
        return ['list'=>$list, 'total'=>$total];
    }

}