<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/5/8
 * Time: 9:43
 */
namespace app\common\model;

use app\api\controller\Tool;
use think\Model;
use think\Db;

class ChatMessage extends Base
{
    // 设置当前模型对应的完整数据表名称
    protected $table = 'yf_hf_chat_message';

    public function getChatFriendList($userId, $kefu_member_id, $pageNo=1, $pageSize=10)
    {
        $limit = "LIMIT ".($pageNo-1)*$pageSize.",".$pageSize;
        $query = "select chat.*,m.nickname,m.headimgurl,m.phone from (
                select id,gid,`from`,`to`,data,isread,type,`timestamp` from
                (
                    select id,gid,`from`,`to`,data,isread,type,`timestamp` from
                    (
                        select id,gid, `from`,`to`,data,isread,type,`timestamp` from
                            (select id,`from` as gid, `from`,`to`,data,isread,type,`timestamp` from yf_hf_chat_message  where `to`=".$userId." and `from`!=".$kefu_member_id." order by `timestamp` desc) as t1
                        group by `from`
                        union  all
                        select id,gid, `from`,`to`,data,isread,type,`timestamp` from
                            (select id,`to` as gid, `from`,`to`,data,isread,type,`timestamp` from yf_hf_chat_message  where `from`=".$userId." and `to`!=".$kefu_member_id." order by `timestamp` desc) as t2
                        group by `to`
                    )as t3 order by `timestamp` desc
                 )as t4
                 group by gid  order by `timestamp` desc
                )chat
                left join yf_hf_member m on m.id=chat.gid";

        $query1 = "select chat.*,m.nickname,m.headimgurl,m.unionid,m.is_robot,m.phone from (
                select id,gid,`from`,`to`,data,isread,type,`timestamp` from
                (
                    select id,gid,`from`,`to`,data,isread,type,`timestamp` from
                    (
                        select id,gid, `from`,`to`,data,isread,type,`timestamp` from
                            (select id,`from` as gid, `from`,`to`,data,isread,type,`timestamp` from yf_hf_chat_message  where `to`=".$userId." and `from`!=".$kefu_member_id." order by `timestamp` desc) as t1
                        group by `from`
                        union  all
                        select id,gid, `from`,`to`,data,isread,type,`timestamp` from
                            (select id,`to` as gid, `from`,`to`,data,isread,type,`timestamp` from yf_hf_chat_message  where `from`=".$userId." and `to`!=".$kefu_member_id." order by `timestamp` desc) as t2
                        group by `to`
                    )as t3 order by `timestamp` desc
                 )as t4
                 group by gid  order by `timestamp` desc
                $limit
                )chat
                left join yf_hf_member m on m.id=chat.gid";
        $list = $this->query($query);
        $total = ceil(count($list)/$pageSize);
        $result = $this->query($query1);
        if ($result) {
            for ($i=0;$i<count($result);$i++) {
                if ($result[$i]['from'] == $userId) {
                    $result[$i]['isread'] = 1;
                }
                //获取头像地址
                if ($result[$i]['unionid'] || $result[$i]['is_robot']!=0){
                    $result[$i]['headimgurl'] = $result[$i]['headimgurl'];
                }else{
                    $result[$i]['headimgurl'] = Tool::getDomain().$result[$i]['headimgurl'];
                }
            }
        }

        return ['list'=>$result,'total'=>$total];
    }
}