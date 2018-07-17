<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/28
 * Time: 15:16
 */
namespace app\admin\controller;

use app\admin\controller\Question as QuestionModel;
use think\Db;

/*
 * 视频管理
 */
class Question extends Admin
{
    function _initialize()
    {
        parent::_initialize();

        $this->questionModel = model('common/Question');
    }
    /**
     * 常见问题列表
     * @return [type] [description]
     * @date   2018-04-28
     * @author zyt
     */
    public function index(){
        // 获取列表
        $map = ['type'=>1];
        list($list,$total) = $this->questionModel->search('id|title')->getListByPage($map,true,'create_time desc');

        return builder('list')
            ->setMetaTitle('常见问题列表') // 设置页面标题
            ->addTopButton('addnew')  // 添加新增按钮
            ->addTopButton('delete')  // 添加删除按钮
            ->keyListItem('id','问题id','id')
            ->keyListItem('title','问题标题','title')
            ->keyListItem('content','问题内容','content')
            ->keyListItem('create_time','创建时间','create_time')
            ->keyListItem('update_time','更新时间','update_time')
            ->keyListItem('right_button', '操作', 'btn')
            ->setListPrimaryKey('id')
            ->setListData($list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            ->addRightButton('edit')
            ->addRightButton('delete')  // 添加编辑按钮
            ->fetch();
    }

    /**
     * 添加或编辑问题
     * @return [type] [description]
     * @date   2018-04-28
     * @author zyt
     */
    public function edit($id = 0) {
        $title = $id ? "编辑" : "新增";
        if (IS_POST) {
            $data = input('param.');
            $data['type'] = 1;
            $id  = isset($data['id']) && $data['id']>0 ? intval($data['id']) : false;
            if ($id>0) {
                $this->validateData($data,'Question.edit');
            } else{
                $data['id'] = 0;
                $this->validateData($data,'Question.add');
            }


            // 提交数据
            //$data里包含主键id，则editData就会更新数据，否则是新增数据
            $result = $this->questionModel->editData($data);

            if ($result) {
                if ($id==is_login()) {//如果是编辑状态下
                    logic('common/Question')->updateLoginSession($id);
                }
                $this->success($title.'成功', url('index'));
            } else {
                $this->error($this->questionModel->getError());
            }

        } else {
            $info=[];
            // 获取账号信息
            if ($id!=0) {
                $info = $this->questionModel->get($id);
            }

            $builder = builder('Form');
            $builder->setMetaTitle($title.'常见问题')  // 设置页面标题
                ->addFormItem('id', 'hidden', 'ID', '')
                ->addFormItem('title', 'text', '', '填写问题标题','','require')
                ->addFormItem('content', 'ueditor', '邮箱激活模板', '请用http://#link#代替激活链接，#username#代替用户名',array('width'=>'100%','height'=>'260px','config'=>''));
            return $builder
                ->setFormData($info)
                ->addButton('submit')->addButton('back')    // 设置表单按钮
                ->fetch();
        }
    }

}