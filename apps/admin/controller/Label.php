<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/27
 * Time: 18:59
 */
namespace app\admin\controller;

use app\admin\controller\Admin;
use think\Db;

/**
 * Class Label
 * @package app\admin\controller
 */
class Label extends Admin{
    function _initialize()
    {
        parent::_initialize();

        $this->labelModel = model('common/Label');
    }
    /**
     * 标签列表
     * @return [type] [description]
     * @date   2018-04-27
     * @author zyt
     */
    public function index(){
        // 获取标签列表
        $map = [];
        list($data_list,$total) = $this->labelModel->search('id')->getListByPage($map,true,'create_time desc');
        return builder('list')
            ->setMetaTitle('标签列表') // 设置页面标题
            ->addTopButton('addnew')  // 添加新增按钮
            ->addTopButton('delete')  // 添加删除按钮
            ->keyListItem('id', 'id')
            ->keyListItem('label_name', '标签名称','label_name')
            ->keyListItem('create_time', '创建时间','create_time')
            ->keyListItem('update_time', '更新时间','update_time')
            ->keyListItem('right_button', '操作', 'btn')
            ->setListPrimaryKey('id')
            ->setListData($data_list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            ->addRightButton('edit')
            ->addRightButton('delete')  // 添加编辑按钮
            ->fetch();
    }

    /**
     * 编辑标签
     * * @return [type] [description]
     * @date   2018-04-27
     * @author zyt
     */
    public function edit($id = 0) {
        $title = $id ? "编辑" : "新增";
        if (IS_POST) {
            $data = input('param.');

            $id  = isset($data['id']) && $data['id']>0 ? intval($data['id']) : false;
            if ($id>0) {
                $this->validateData($data,'Label.edit');
            } else{
                $data['id'] = 0;
                $this->validateData($data,'Label.add');
            }


            // 提交数据
            //$data里包含主键id，则editData就会更新数据，否则是新增数据
            $result = $this->labelModel->editData($data);

            if ($result) {
                if ($id==is_login()) {//如果是编辑状态下
                    logic('common/Label')->updateLoginSession($id);
                }
                $this->success($title.'成功', url('index'));
            } else {
                $this->error($this->labelModel->getError());
            }

        } else {
            $info=[];
            // 获取账号信息
            if ($id!=0) {
                $info = $this->labelModel->get($id);
                //unset($info['member_id']);
            }

            $builder = builder('Form');
            $builder->setMetaTitle($title.'标签')  // 设置页面标题
                ->addFormItem('id', 'hidden', 'ID', '')
                ->addFormItem('label_name', 'text', '标签名称', '填写标签名称','','require');
            return $builder
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('submit')->addButton('back')    // 设置表单按钮
                ->fetch();
        }
    }


}