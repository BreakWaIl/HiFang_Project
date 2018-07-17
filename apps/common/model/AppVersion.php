<?php

namespace app\common\model;

use think\Model;
use think\Db;

class AppVersion extends Base
{
    protected $table = 'yf_hf_version';

    /**
     * 获取最近版本号
     *
     * @param string $type
     * @return mixed
     */

    public function getVersion($type)
    {
        $param["type"] = $type;
        $param["is_del"] = 0;
     //   return $this->field("id,version_no,type,create_time,intro,CONCAT('".CK_IMG_URL."' , app_path) as app_path")
       return $this->field("id,version_no,type,create_time,intro,app_path,status")
            ->where($param)
            ->order("id desc")
            ->limit(1)
            ->select()[0];
    }

    /**
     * 获取版本历史
     * @return false|\PDOStatement|string|\think\Collection
     */
    public function getVersionList()
    {
        $param["is_del"] = 0;
        return $this->field("id,version_no,IF(type = 1,'ios','android') as type ,create_time,intro,app_path")
            ->where($param)
            ->order("id desc")
            ->select();
    }

    /**
     * 添加版本号
     * @param $param
     * @return array
     */
    public function addVersion($param)
    {
        Db::startTrans();
        try {
            $id = $this->save([
                'version_no'  => $param['version_no'],
                'intro'       => $param['intro'],
                'type'        => $param['type'],
                'app_path'    => $param['app_path'],
                'is_del'      => 0,
                'create_time' => $param['create_time'],
                'update_time' => $param['update_time'],
            ]);
            Db::commit();
            return [ "code" => "200", "msg" => $id ];
        } catch (\Exception $e) {
            Db::rollback();
            return [ "code" => "101", "msg" => "失败，数据异常" ];
        }
    }

    public function getVersionListByPage($map,$field=true,$order='create_time desc',$page_size=null)
{
    $paged     = input('param.paged',1);//分页值
    if (!$page_size) {
        $page_size = config('admin_page_size');
    }
    $page_size = input('param.page_size',$page_size);//每页数量
    $order     = input('param.order',$order);
    $list      = $this->where($map)->field($field)->order($order)->page($paged,$page_size)->select();
    $total     = $this->where($map)->count();
    return [$list,$total];
}


}
