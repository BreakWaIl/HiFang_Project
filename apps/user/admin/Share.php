<?php
/**
 * Created by PhpStorm.
 * User: ASUS
 * Date: 2018/5/17
 * Time: 17:00
 */

namespace app\user\admin;


use app\admin\controller\Admin;
use think\Db;

class Share extends Admin
{
    function _initialize()
    {
        parent::_initialize();
        $this->adminModel = model('common/Users');
        $this->chatmessageModel = model('common/ChatMessage');
    }

    /**
     * 个人主页分享页面统计
     * by songjian
     */
    public function tongji(){
        $timegap = input('timegap');
        if($timegap){
            $gap = explode('—', $timegap);
            $begin = $gap[0];
            $end = $gap[1];
        } else {
            $lastweek = date('Y-m-d',strtotime("-1 month"));//30天前
            $begin = input('begin',$lastweek);
            $end =  input('end',date('Y-m-d'));
        }
        $begin = strtotime($begin);
        $end = strtotime($end)+86399;
        $this->assign('timegap',date('Y-m-d',$begin).'—'.date('Y-m-d',$end));
        $this->assign('meta_title','个人主页统计');

        $today = strtotime(date('Y-m-d'));
        $month = strtotime(date('Y-m-01'));

        $user = [
            'today'      => Db::table('yf_hf_behavior')->where('type',20)->where("create_time>$today")->count(),//今日分享个人主页
            'month'      => Db::table('yf_hf_behavior')->where('type',20)->where("create_time>$month")->count(),//本月分享个人主页
            'total'      => Db::table('yf_hf_behavior')->where('type',20)->count(),//分享个人主页总数
        ];
        $this->assign('user',$user);

        //分享个人主页、进入被转个人主页、点击视频
        $share_page = Db::table('yf_hf_behavior')->where('type',20)->where('create_time','>',$begin)->where('create_time','<',$end)->count(); //用户分享个人主页总数
        $enter_page = Db::table('yf_hf_behavior')->where('type',21)->where('create_time','>',$begin)->where('create_time','<',$end)->count(); //进入被转页面总数
        $click_video = Db::table('yf_hf_behavior')->where('type',22)->where('create_time','>',$begin)->where('create_time','<',$end)->count(); //点击视频总数
        $brr[0] = $share_page;
        $brr[1] = $enter_page;
        $brr[2] = $click_video;
        $result = array('data'=>$brr);
        $this->assign('result',json_encode($result));
        return $this->fetch();
    }

    /**
     * 单个用户邀请好友统计
     * by songjian
     */
    public function sharetongji($time){
        $times = $time;
        $time = explode('—',$time);
        $start_time = $time[0];
        $stop_time = $time[1];
        $sql = "select userid,count(case when type=20 then type end) sharepage, count(case when type=21 then type end) enterpage, count(case when type=22 then type end) clickvideo from yf_hf_behavior WHERE create_time BETWEEN '{$start_time}' AND '{$stop_time}' GROUP BY userid";
        $list = Db::query($sql);
        $total = count($list);

        return builder('list')
            ->setMetaTitle('单个用户个人分享主页统计') // 设置页面标题
            ->addTopButton('self',['title'=>"查询日期{$times}"])  // 添加新增按钮
            ->keyListItem('userid','用户ID','userid')
            ->keyListItem('sharepage','分享个人主页','sharepage')
            ->keyListItem('enterpage','微信端进入主页','enterpage')
            ->keyListItem('clickvideo','点击视频','clickvideo')
            ->setListPrimaryKey('id')
            ->setListData($list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            ->fetch();
    }
}