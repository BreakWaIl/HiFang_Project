<?php

namespace app\common\model;

use app\api\controller\Tool;
use think\Db;
use think\Model;

class Users extends Base
{
    // 设置当前模型对应的完整数据表名称
    protected $table = 'yf_hf_member';

    public function getSexTextAttr($value,$data)
    {
        $sex = [ 0 => '保密', 1 => '男', 2 => '女'];
        return isset($sex[$data['sex']]) ? $sex[$data['sex']] : '未知';
    }

    /**
     * 设置一条或者多条数据的状态
     * @param $script 严格模式要求处理的纪录的uid等于当前登陆用户UID
     */
    public function setStatus($model = CONTROLLER_NAME, $script = false) {
        $ids = $this->request->param('ids/a');
        $status = $this->request->param('status');
        if (empty($ids)) {
            $this->error('请选择要操作的数据');
        }
        $model_primary_key = model($model)->getPk();
        $map[$model_primary_key] = ['in',$ids];
        if ($script) {
            $map['uid'] = ['eq', is_login()];
        }
        switch ($status) {
            case 'forbid' :  // 禁用条目
                $data = ['status' => 0];
                $this->editRow(
                    $model,
                    $data,
                    $map,
                    ['success'=>'禁用成功','error'=>'禁用失败']
                );
                break;
            case 'resume' :  // 启用条目
                $data = ['status' => 1];
                $map  = array_merge(['status' => 0], $map);
                $this->editRow(
                    $model,
                    $data,
                    $map,
                    array('success'=>'启用成功','error'=>'启用失败')
                );
                break;
            case 'hide' :  // 隐藏条目
                $data = array('status' => 1);
                $map  = array_merge(array('status' => 2), $map);
                $this->editRow(
                    $model,
                    $data,
                    $map,
                    array('success'=>'隐藏成功','error'=>'隐藏失败')
                );
                break;
            case 'show' :  // 显示条目
                $data = array('status' => 2);
                $map  = array_merge(array('status' => 1), $map);
                $this->editRow(
                    $model,
                    $data,
                    $map,
                    array('success'=>'显示成功','error'=>'显示失败')
                );
                break;
            case 'recycle' :  // 移动至回收站
                $data['status'] = -1;
                $this->editRow(
                    $model,
                    $data,
                    $map,
                    array('success'=>'成功移至回收站','error'=>'删除失败')
                );
                break;
            case 'restore' :  // 从回收站还原
                $data = ['status' => 1];
                $map  = array_merge(['status' => -1], $map);
                $this->editRow(
                    $model,
                    $data,
                    $map,
                    array('success'=>'恢复成功','error'=>'恢复失败')
                );
                break;
            case 'delete'  :  // 删除条目
                //action_log(0, is_login(), ['param'=>$this->request->param()],'删除操作');
                $result = model($model)->where($map)->delete();
                if ($result) {
                    $this->success('删除成功，不可恢复！');
                } else {
                    $this->error('删除失败');
                }
                break;
            default :
                $this->error('参数错误');
                break;
        }
    }

    /**
     * 根据用户的昵称或者用户id去搜索用户
     * by songjian
     */
    public function selectMember($nickname,$pageNo,$pageSize){
        if (is_numeric($nickname)){
            $addwhere = " and `hiid`='{$nickname}'";
            $nickname = "";
        }else{
            $addwhere = "";
        }
        $beginSize = ($pageNo-1)*$pageSize;
        $addlimit = "limit {$beginSize},$pageSize ";
        //查用户
        $infos = Db::query("select `id`,`unionid`,`headimgurl`,`nickname`,`sign`,`is_robot`,`label` from `yf_hf_member` where `nickname` like '%{$nickname}%' {$addwhere} {$addlimit}");
        if (count($infos) > 0) {
            for ($i=0;$i<count($infos);$i++) {
                //手机/微信头像适配
                if ($infos[$i]['unionid'] || $infos[$i]['is_robot'] == 1){
                }else{
                    $infos[$i]['headimgurl'] = Tool::getDomain().$infos[$i]['headimgurl'];
                }
            }
        }
        return $infos;
    }

    /**
     * 根据用户的昵称或者用户id去搜索关注人
     * by songjian
     */
    public function selectClearMember($nickname,$userid,$pageNo,$pageSize){
        if (is_numeric($nickname)){
            $addwhere = " and hiid='{$nickname}'";
            $nickname = "";
        }else{
            $addwhere = "";
        }
        $beginSize = ($pageNo-1)*$pageSize;
        $addlimit = "limit {$beginSize},$pageSize ";
        //查用户
        $sql = "select `id`,`headimgurl`,`nickname`,`sign`,`label` from `yf_hf_member` where `id` IN(select f.followed_id from `yf_hf_member` as m,`yf_hf_follow` as f where m.id = f.member_id and f.is_followed=1 and f.type=0 and m.id={$userid}) and `nickname` like '%{$nickname}%' {$addwhere} {$addlimit}";
        $infos = Db::query($sql);
        return $infos;
    }
}
