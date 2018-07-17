<?php

namespace app\admin\controller;

use app\admin\controller\Admin;
use app\common\model\AppVersion;
use Qiniu\Http\Request;
use think\Db;
use think\Session;

/**
 * Created by PhpStorm.
 * User : zyt
 * Date : 2018/4/20
 */
class Version extends Admin
{
    protected $appVersion;

    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->appVersion = new AppVersion();
    }
    /**获取版本列表
     * @return mixed
     */
    public function index(){
        // 获取版本列表
        $map = [];
        list($data_list,$total) = $this->appVersion->search('id|version_no|type|is_del')->getVersionListByPage($map,true,'create_time desc');

        return builder('list')
            ->setMetaTitle('发布历史') // 设置页面标题
            ->addTopButton('addnew')  // 添加新增按钮
            ->addTopButton('delete')  // 添加删除按钮
            ->keyListItem('id', 'id')
            ->keyListItem('version_no', '版本编号','version_no')
            ->keyListItem('intro', '发布简述', 'intro')
            ->keyListItem('type', '类型', 'array', [1=>'安卓',2=>'苹果'])
            ->keyListItem('status', '审核状态(ios专用)', 'array', [0=>'审核中',1=>'审核通过'])
            ->keyListItem('app_path', '地址', 'app_path')
            ->keyListItem('is_del', '是否删除', 'array', [0=>'否',1=>'是'])
            ->keyListItem('create_time', '发布时间','create_time')
            ->keyListItem('right_button', '操作', 'btn')
            ->setListPrimaryKey('id')
            ->setListData($data_list)    // 数据列表
            ->setListPage($total) // 数据列表分页
            ->addRightButton('edit')
            ->addRightButton('self', ['href'=>url('delete',['id'=>'__data_id__']),'title'=>'删除版本','icon'=>'fa fa-trash'])  // 添加编辑按钮
            ->fetch();
    }
    /**
     * 删除
     */
    public function delete ($id=0)
    {
        if (empty($id)) {
            $this->error('参数错误！');
        }

        $result = Db::table('yf_hf_version')->where('id',$id)->delete();
        if($result){
            return $this->success('操作成功', url('index'));
        } else {
            return $this->error('操作失败', url('index'));
        }
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
                $this->validateData($data,'Version.edit');
            } else{
                $this->validateData($data,'Version.add');
            }
            // 提交数据
            //$data里包含主键id，则editData就会更新数据，否则是新增数据
            $result = $this->appVersion->editData($data);
            if ($result) {
                if ($id==is_login()) {//如果是编辑状态下
                    logic('common/Version')->updateLoginSession($id);
                }
                $this->success($title.'成功', url('index'));
            } else {
                $this->error($this->appVersion->getError());
            }
        } else {
            $info=[];
            // 获取账号信息
            if ($id!=0) {
                $info = $this->appVersion->get($id);
            }
            $builder = builder('Form');
            $builder->setMetaTitle('添加版本')  // 设置页面标题
                ->addFormItem('id', 'hidden', 'ID', '')
                ->addFormItem('version_no', 'text', '版本编号', '请填写版本编号','','require')
                ->addFormItem('intro', 'text', '发布简述', '请填写发布简述','','require')
                ->addFormItem('app_path', 'text', '地址', '请填写地址','','require')
                ->addFormItem('type', 'radio', '类型', '选择被关注的类型(1安卓 2苹果 )', [1=>'Android',2=>'iOS'])
                ->addFormItem('status', 'radio', '版本状态', '选择审核状态(0审核中 1审核通过 ios专用)', [0=>'审核中',1=>'审核通过']);

            return $builder
                ->setFormData($info)//->setAjaxSubmit(false)
                ->addButton('submit','确认')->addButton('back')    // 设置表单按钮
                ->fetch();
        }
    }
    /**上传版本index1
     *
     */
    public function index1()
    {
        return view('version/index');
    }

    /**
     * 获取最近版本号
     * @return \think\Response
     */
    public function getVersionNo(\think\Request $req)
    {
        $type = $req->get("type");
        $versionResult = $this->appVersion->getVersion($type);

        $result['code'] = 200;
        $result['msg'] = 'request success';
        $result['data'] = $versionResult;
        return json_encode($result);
    }

    /**
     * 获取版本历史记录
     * @return \think\Response
     */
    public function getVersionList()
    {
        $result['code'] = 200;
        $result['msg'] = 'request success';
        $result['data'] = $this->appVersion->getVersionList();
        return json_encode($result);
    }

    public function addVersion()
    {
        $param["version_no"] = $_POST["version_no"];
        $param["intro"] = $_POST["intro"];
        $param["type"] = $_POST["type"];
        $param["app_path"] = $_POST["app_path"];
        $result['code'] = 101;
        $result['msg'] = '';
        $result['data'] = array();
        if (!isset($param["version_no"]) || !isset($param["type"])) {
            $result['msg'] = '版本号或app类型不能为空';
            return json_encode($result);
        }
        if ($param["type"] == 1 && isset($param["app_path"])) {
            $result['msg'] = '安卓请上传安装包';
            return json_encode($result);
        }
        $param["create_time"] = time();
        $param["update_time"] = time();
        $result = $this->appVersion->addVersion($param);
        if ($result['code'] == 200) {
            $result['msg'] = '上传成功';
            return json_encode($result);
        } else {
            $result['msg'] = '上传失败';
            return json_encode($result);
        }
    }


    public function getMenu() {
        $menu_data = Session::get('user_info');
        $result['code'] = 200;
        $result['msg'] = '';
        $result['data'] = $_SESSION;
        return json_encode($result);
    }

}