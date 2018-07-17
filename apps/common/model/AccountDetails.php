<?php
/**
 * Created by PhpStorm.
 * User: zfc
 * Date: 2018/4/15
 * Time: 17:53
 */

namespace app\common\model;


use app\api\controller\Tool;
use think\Db;
use think\Exception;
use think\Log;
use think\Model;

class AccountDetails extends Base
{
    protected $table = 'yf_hf_account_details';

    /**
     * 审核将status结果插入数据库
     * by songjian
     * @param $id
     * @param $type
     * @return bool
     */
    public function verify($id,$type,$order='',$amount='',$payee_account='',$member_id='',$balance=0){

        //一块钱兑换嗨币
        $iexchange_icon = Tool::getConfigInfo(75);
        if ($type == 0){
            //审核不通过
            //将原纪录的状态修改，并修改时间
            Db::startTrans();
            try{
                $time = time();
                $res = Db::table('yf_hf_account_details')->where('id',$id)->update(['status'=>2,'update_time'=>$time]);
                $new_money = $amount*$iexchange_icon;
                //并且添加一条返账的纪录
                $data = array(
                    'id'       => 0,
                    'member_id' => $member_id,
                    'withdrawals_id' => $member_id,
                    'money' => $new_money,
                    'type' => 6,
                    'status' => 1,
                    'pay_status' => 0,
                    'payee_account' => $payee_account,
                    'order_id' => $order,
                    'create_time' => $time,
                    'update_time' => $time
                );
                Db::table('yf_hf_account_details')->insert($data);
                //并且让用户表的余额更新一下
                //$oldmoney = Db::table('yf_hf_member')->field(['balance'])->where('id',$member_id)->find()['balance'];
                $money = $new_money+$balance;
                Db::table('yf_hf_member')->where('id',$member_id)->update(['balance'=>$money]);
                Db::commit();
            }catch (Exception $e){
                //回滚事务
                Db::rollback();
                echo "错误";exit;
            }
        }elseif ($type == 1){
            //审核通过
            $time = time();
            $res = Db::table('yf_hf_account_details')->where('id',$id)->update(['status'=>1,'update_time'=>$time]);
        }
        return $res ? true : false;
    }

    /**
     * 计算发放金额和未提现金额
     * by songjian
     */
    public function count(){
        //计算总发放金额
        $money['totalmoney'] = Db::table('yf_hf_account_details')->field('sum(money) money')->where('type',['=',1],['=',2],['=',3],['=',7],['=',8],'or')->find()['money'];
        //计算总提现金额
        $money['totalready'] = Db::table('yf_hf_account_details')->field('sum(money) money')->where('type',['=',4],['=',5],'or')->where('status',1)->find()['money'];
        return $money;
    }

    /**
     * 返回给前台当前创作视频账单的视频连接
     * by songjian
     * @return string
     */
    public function createUrl($account_id){
        $video_id = Db::table('yf_hf_account_details')->field(['video_id'])->where('id',$account_id)->find()['video_id'];
        $video_link = Db::table('yf_hf_video')->field(['video_link'])->where('id',$video_id)->find()['video_link'];
        return $video_link;
    }

    /**
     * 审核创作视频成功与否，更新账单详情表
     * by songjian
     */
    public function updateCreateVideo($id,$data){
        Db::startTrans();
        try{
            $user_info = Db::table('yf_hf_account_details')->where('id',$id)->find();
            $user_status = true;
            //$user_id = Db::table('yf_hf_video')->field(['member_id'])->where('id',$user_info['member_id'])->find()['member_id'];
            //Log::info('=======================user_id:'.$user_id.'=============================');
            if ($data['status']==1){
                /**
                 * 判断此审核的视频是否为今日审核成功的视频
                 * 若是则奖励，若不是则不奖励
                 * update songjian
                 */
                $release_video_num = Tool::getConfigInfo(63);
                $times = Db::table('yf_hf_account_details')
                    ->field(['create_time'])
                    ->where('id',$id)
                    ->find()['create_time'];
                $begin = strtotime(date('Y-m-d',$times));
                $end   = (int)($begin + 86400);
                Log::info('=======================addvideo=============================');
                Log::info('=======================begin:'.$begin.'=============================');
                Log::info('=======================end:'.$end.'=============================');
                //获取此发布视频的时间戳
                $video_count = Db::table('yf_hf_account_details')
                    ->where('member_id',$user_info['member_id'])
                    ->where('create_time','>',$begin)
                    ->where('create_time','<',$end)
                    ->where('type',1)
                    ->where('status',1)
                    ->count();
                Log::info('======================='.$video_count.'=============================');
                Log::info('======================='.$release_video_num.'=============================');
                //先判断此用户【本日】发布有奖励视频是否超过？
                if ($video_count >= (int)$release_video_num){
                    $user_status = false;
                    Log::info('=======================change=============================');
                    Db::table('yf_hf_account_details')->where('id',$id)->update(['money'=>0]);
                }

                $info = Db::table('yf_hf_account_details')->field(['money','member_id'])->where('id',$id)->find();
                $res2 = Db::table('yf_hf_member')->where('id',$info['member_id'])->setInc('balance',$info['money']);
                
                if ($res2 == false)  return false;
            }
            $res1 = Db::table('yf_hf_account_details')->where('id',$id)->update($data);
            $status = $data['status'];
            Db::commit();
              if ($res1 && $user_status==true){
                  if ($status == 1){
                      return 1;
                  }else{
                      return 2;
                  }
              }elseif ($res1 && $user_status==false){
                  return 3;
              }else{
                  return 0;
              }
        }catch (Exception $exception){
            Db::rollback();
            Log::info('=======================error=============================');
            Log::info($exception->getMessage());
        }
    }

    /**
     * 获取用户收支明细列表
     * By songjian
     */
    public function getDetailInfo($member_id){
        $info = Db::table('yf_hf_account_details')
                ->field(['video_id','remarks','type','status','money','member_id','recommend_member_id','update_time'])
                ->where('member_id',$member_id)
                ->order('update_time desc')
                ->select();
        return $info;
    }
}