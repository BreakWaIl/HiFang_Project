<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/13
 * Time: 10:30
 */
namespace app\admin\controller;

use app\admin\controller\Admin;
use app\common\model\Follow as followModel;
use think\Db;

/**
 * Class Follow
 * @package app\admin\controller
 */
class Follow extends Admin{
    function _initialize()
    {
        parent::_initialize();

        $this->followModel = model('common/Follow');
    }
    /**
     * 关注列表
     * @return [type] [description]
     * @date   2018-04-13
     * @author zyt
     */
    public function index(){
        // 获取关注列表
        /*$map = [];
        //list($data_list,$total) = $this->followModel->search('id|member_id|type|black|followed_id')->getListByPage($map,true,'create_time desc');
        list($data_list,$total) = $this->followModel->search('nickname|type|black|followed_id')->getFollowListByPage($map,true,'create_time desc');

        return builder('list')
            ->setMetaTitle('关注列表') // 设置页面标题
            ->addTopButton('delete')  // 添加删除按钮
            ->keyListItem('id', 'id')
            ->keyListItem('nickname', '关注人昵称','nickname')
            ->keyListItem('followed_id', '被关注对象id', 'followed_id')
            ->keyListItem('type', '关注类型', 'array', [0=>'关注人',1=>'关注小区',2=>'关注点赞视频',3=>'点赞别人的评论'])
            ->keyListItem('black', '是否拉黑', 'array',[0=>'否',1=>'是'])
            ->keyListItem('create_time', '关注时间','create_time')
            ->keyListItem('right_button', '操作', 'btn')
            ->setListPrimaryKey('id')
            ->setListData($data_list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            ->addRightButton('edit')
            ->addRightButton('delete')  // 添加编辑按钮
            ->fetch();*/

        $fields = 'f.id,f.member_id,f.followed_id,f.type,f.black,f.update_time,m.nickname,m.headimgurl';
        $info      = Db::table('yf_hf_follow')->alias('f')
            ->join('yf_hf_member m', 'm.id = f.member_id', 'left')
            ->join('yf_hf_video v', 'v.id = f.followed_id', 'left')
            ->join('yf_hf_buildings b', 'b.id = f.followed_id', 'left')
            ->field($fields)->select();

        $this->assign('info',$info);
        return view('index');
    }
    public function search(){
        $nickname = $_POST['nickname'];
        $type = $_POST['type'];

        $fields = 'f.id,f.member_id,f.followed_id,f.type,f.black,f.update_time,m.nickname,m.headimgurl';
        $query = Db::table('yf_hf_follow')->alias('f')
            ->join('yf_hf_member m', 'm.id = f.member_id', 'left')
            ->join('yf_hf_video v', 'v.id = f.followed_id', 'left')
            ->join('yf_hf_buildings b', 'b.id = f.followed_id', 'left')
            ->field($fields);
        if ($nickname) {
            $query = $query->where('m.nickname','like',"%$nickname%");
        }
        if ($type ==0 || $type ==1 || $type ==2 || $type ==3) {
            $query = $query->where('f.type',$type);
        }

        $info = $query->select();
        $this->assign('nickname',$nickname);
        $this->assign('info',$info);
        return view('index');
    }

    /**
     * 编辑关注
     * * @return [type] [description]
     * @date   2018-04-13
     * @author zyt
     */
    public function edit($id = 0) {
        $title = $id ? "编辑" : "新增";
        if (IS_POST) {
            $data = input('param.');

            $id  = isset($data['id']) && $data['id']>0 ? intval($data['id']) : false;
            if ($id>0) {
                $this->validateData($data,'Follow.edit');
            } else{
                $this->validateData($data,'Follow.add');
            }


            // 提交数据
            //$data里包含主键id，则editData就会更新数据，否则是新增数据
            $result = $this->followModel->editData($data);

            if ($result) {
                if ($id==is_login()) {//如果是编辑状态下
                    logic('common/Follow')->updateLoginSession($id);
                }
                $this->success($title.'成功', url('index'));
            } else {
                $this->error($this->followModel->getError());
            }

        } else {
            $info=[];
            // 获取账号信息
            if ($id!=0) {
                $info = $this->followModel->get($id);
                //unset($info['member_id']);
            }

            $builder = builder('Form');
            $builder->setMetaTitle($title.'关注')  // 设置页面标题
                ->addFormItem('id', 'hidden', 'ID', '')
                ->addFormItem('member_id', 'text', '关注人', '填写一个关注人id吧','','require')
                ->addFormItem('followed_id', 'text', '被关注对象', '填写一个被关注的对象id吧','','require')
                ->addFormItem('type', 'select', '类型', '选择被关注的类型',[0=>'关注人',1=>'关注小区',2=>'关注点赞视频',3=>'点赞别人的评论']);
            return $builder
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('submit')->addButton('back')    // 设置表单按钮
                ->fetch();
        }
    }


}