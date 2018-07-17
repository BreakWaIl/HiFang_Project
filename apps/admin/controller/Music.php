<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/27
 * Time: 9:23
 */
namespace app\admin\controller;

use app\admin\controller\Admin;
use app\api\controller\Tool;
use think\Db;

/**
 * Class Music
 * @package app\admin\controller
 */
class Music extends Admin{
    function _initialize()
    {
        parent::_initialize();

        $this->musicModel = model('common/Music');
    }
    /**
     * 音乐列表
     * @return [type] [description]
     * @date   2018-04-27
     * @author zyt
     */
    public function index(){
        // 获取音乐列表
        $map = [];
        list($data_list,$total) = $this->musicModel->search('id|title')->getListByPage($map,true,'create_time desc');
        return builder('list')
            ->setMetaTitle('音乐列表') // 设置页面标题
            ->addTopButton('addnew')  // 添加新增按钮
            ->addTopButton('delete')  // 添加删除按钮
            ->keyListItem('id', 'id')
            ->keyListItem('title', '音乐标题','title')
            ->keyListItem('image_url', '音乐封面图', 'image')
            ->keyListItem('time', '时长', '')
            ->keyListItem('create_time', '创建时间','create_time')
            ->keyListItem('right_button', '操作', 'btn')
            ->setListPrimaryKey('id')
            ->setListData($data_list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            ->addRightButton('self', ['href'=>url('showMusic',['id'=>'__data_id__']),'title'=>'试听音乐','icon'=>'fa fa-music'])
            ->addRightButton('edit')
            ->addRightButton('self', ['href'=>url('delete',['id'=>'__data_id__']),'title'=>'删除音乐','icon'=>'fa fa-trash'])  // 添加编辑按钮
            ->fetch();
    }

    /**
     * 编辑音乐
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
                $this->validateData($data,'Music.edit');
            } else{
                $data['id'] = 0;
                $this->validateData($data,'Music.add');
            }
            // 提交数据
            //$data里包含主键id，则editData就会更新数据，否则是新增数据
            $result = $this->musicModel->editMusic($data);

            if ($result) {
                if ($id==is_login()) {//如果是编辑状态下
                    logic('common/Music')->updateLoginSession($id);
                }
                $this->success($title.'成功', url('index'));
            } else {
                $this->error($this->musicModel->getError());
            }

        } else {
            $info=[];
            // 获取账号信息
            if ($id!=0) {
                $info = $this->musicModel->get($id);
                /*$website = Tool::getDomain();
                $timearr = explode(" ",$info['create_time']);
                $time = str_replace('-','',$timearr[0]);
                $info['image_url'] = $website . $info['image_url'];*/
            }
            
            $builder = builder('Form');
            $builder->setMetaTitle($title.'音乐')  // 设置页面标题
                ->addFormItem('id', 'hidden', 'ID', '')
                ->addFormItem('title', 'text', '音乐标题', '填写音乐标题','','require')
                ->addFormItem('music_url', 'text', '音乐链接', '填写音乐链接','','require')
                ->addFormItem('image_url', 'image', '音乐封面图', '请设置封面')
                ->addFormItem('time', 'text', '时长', '请输入时长','','require');
            return $builder
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('submit')->addButton('back')    // 设置表单按钮
                ->fetch();
        }
    }

    public function imgDetail($id = 0) {
        $this->assign('meta_title','查看户型图');
        if (empty($id)) {
            $this->error('参数错误！');
        }
        $file_list = Db::table('yf_hf_imgs')->where('video_id',$id)->select();
        $imgs = [];
        $website = Tool::getDomain();
        foreach ($file_list as $list) {
            $create_time = Db::table('yf_hf_imgs')->field('create_time')->where('id',$list['id'])->select()[0]['create_time'];
            $timearr = explode(" ",$create_time);
            $time = str_replace('-','',$timearr[0]);
            $imgs[] = [
                'id'         => $list['id'],
                'image_name' => $website . '/uploads/img/'. $time . '/' . ($list['image_name']),
            ];
        }
        $this->assign('image_list_data',$imgs);//列表数据
        return $this->fetch();
    }


    /**
     * 试听音乐
     */
    public function showMusic ($id=0)
    {
        $this->assign('meta_title','试听音乐');

        if (empty($id)) {
            $this->error('参数错误！');
        }
        $info = model('Music')->field('music_url')->where('id',$id)->find();
        //$this->assign('info',$info);
        return view('showMusic', ['info'=>$info]);
    }

    /**
     * 删除音乐
     */
    public function delete ($id=0)
    {
        if (empty($id)) {
            $this->error('参数错误！');
        }

        $result = model('music')->where('id',$id)->delete();
        if($result){
            return $this->success('操作成功', url('index'));
        } else {
            return $this->error('操作失败', url('index'));
        }
    }

}