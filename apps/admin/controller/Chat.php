<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/6/26
 * Time: 17:24
 */
namespace app\admin\controller;

use app\admin\controller\Admin;
use think\Db;

/**
 * Class Comment
 * @package app\admin\controller
 */
class Chat extends Admin{
    function _initialize()
    {
        parent::_initialize();

    }

    /**
     * 客服聊天列表
     * @return [type] [description]
     * @date   2018-06-26
     * @author zyt
     */
    public function index(){
        $paged     = input('param.paged',1);//分页值
        $page_size = config('admin_page_size');
        //获取参数设置你买了的客服id'name','kefu_member_id'
        $kefu_member_id = Db::table('yf_config')->where('name','kefu_member_id')->value('value');
        // 获取留言的所有用户
        $where = "c.to =".$kefu_member_id ;
        $data_list = Db::table('yf_hf_chat_message')->alias('c')
            ->join('yf_hf_member m', 'm.id=c.from', 'left')
            ->field('c.from,c.to,m.nickname,m.headimgurl,m.phone')
            ->where($where)
            ->distinct(true)
            ->select();
        $total = ceil(count($data_list)/$page_size);

        return builder('list')
            ->setMetaTitle('留言列表') // 设置页面标题
            ->keyListItem('from', '留言者','from')
            ->keyListItem('nickname', '留言人昵称', 'nickname')
            ->keyListItem('headimgurl', '留言者头像', 'image')
            ->keyListItem('phone', '留言人手机号','phone')
            //->keyListItem('right_button', '操作', 'btn')
            //->setListPrimaryKey('id')
            ->setListData($data_list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            //->addRightButton('self', ['href'=>url('',['id'=>'__data_id__']),'title'=>'回复','icon'=>'fa '])
            ->fetch();
        $this->assign('info',$info);
        return view('index');
    }


}