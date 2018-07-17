<?php
/**
 * Created by PhpStorm.
 * User: zfc
 * Date: 2018/4/16
 * Time: 17:08
 */

namespace app\api\controller;

use app\api\extend\Fileupload;
use think\Db;
use think\Request;
use app\common\model\ImageUpload as imageModel;

class Imageupload extends Basic
{
    public $imageModel;
    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->imageModel = new imageModel();
        $this->fileupload = new Fileupload();
    }

    /**
     * 在上传之后清除垃圾图片的文件
     * by songjian
     * @return json
     */
    public function clearImg(){
        $data['code'] = 101;
        $data['message'] = '';
        //查询是否有已保存的图片
        $img = $this->imageModel->checkOldImg($this->userId);
        //若count($img) > 0 删除再上传图片  否则直接上传图片
        if (count($img) > 0) {
            //删除垃圾图片
            $res = $this->imageModel->deleteOldImg($this->userId);
            if ($res){
                $data['code'] = 200;
                $data['message'] = '清除垃圾图片成功';
            }else{
                $data['message'] = '清除垃圾图片失败';
            }
        }else{
            $data['code'] = 200;
            $data['message'] = '没有垃圾图片';
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 单文件上传
     * by songjian
     * @param file 文件信息
     * @return json
     */
    public function move(Request $request){
        // 获取表单上传文件
        $file = $request->file('files');
        if (empty($file)){
            $data['code'] = 101;
            $data['message'] = '文件信息为空，请传入文件信息';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        // 移动到框架应用根目录/public/uploads/ 目录下
        $info = $file->validate(['size'=>298720,'ext'=>'jpg,png,gif'])->move(ROOT_PATH . 'public' . DS . 'uploads' . DS . 'img');
        if($info){
            // 成功上传后 获取上传信息
            // 输出 jpg  echo $info->getExtension();
            // 当type=1时，为头像上传，将video_id设为-1
            if ($request->post('type')==1){
                $data['video_id'] = -1;
            }
            // 当type=2时，为上传视频时户型图上传，将video_id设为0
            else{
                $data['video_id'] = 0;
            }
            $data['id'] = 0;
            $data['user_id'] = $this->userId;
            $data['image_name'] = $info->getFilename();
            $data['tmp_name'] = $info->getFilename();   // eg 42a79759f284b767dfcb2a0197904287.jpg
            $data['session_id'] = $this->userId;
            $data['img_type'] = $request->post('type');
            $data['create_time'] = date('Y-m-d H:i:s',time());
            $data['update_time'] = date('Y-m-d H:i:s',time());

            //将本图片信息插入图片表中
            $res = Db::table('yf_hf_imgs')->insert($data);
            //此处获取一条同时上传时的id就可以，之后查相同上传的时间，一并修改
            $img_id = Db::table('yf_hf_imgs')->getLastInsID();
            //取到时间日期[年月日]
            $create_time = $this->imageModel->getCreateTime($img_id);
            $timearr = explode(" ",$create_time);
            $time = str_replace('-','',$timearr[0]);
            if (!$res){
                $datas = array('code'=> 101, 'message' => '上传图片数据库失败',);
                return json_encode($datas);
            }
        }else{
            //上传失败获取错误信息
            $datas = array('code' => 102, 'message'  => $file->getError());
            return json_encode($datas,JSON_UNESCAPED_UNICODE);
        }
        $data = array(
                'code' => 200,
                'message'  => '上传图片成功',
                'data'  => array(
                    'img_id' => base64_encode($img_id),
                    'url' => Tool::getImageUrl($time,$info->getFilename()),
                )
            );
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * [此接口暂时不用]上传更新户型图
     * by songjian
     * @return json
     */
    public function updatemove(Request $request){
        //获取图片id用户更新
        $id = $request->post('id');
        // 获取表单上传文件
        $file = $request->file('files');
        if (empty($file)){
            $data['code'] = 101;
            $data['message'] = '文件信息为空，请传入文件信息';
            return json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        // 移动到框架应用根目录/public/uploads/ 目录下
        $info = $file->validate(['size'=>298720,'ext'=>'jpg,png,gif'])->move(ROOT_PATH . 'public' . DS . 'uploads' . DS . 'img');
        if($info){
            // 成功上传后 获取上传信息
            // 输出 jpg  echo $info->getExtension();
            // 当type=1时，为头像上传，将video_id设为-1
            if ($request->post('type')==1){
                $data['video_id'] = -1;
            }
            // 当type=2时，为上传视频时户型图上传，将video_id设为0
            else{
                $data['video_id'] = 0;
            }
            $data['image_name'] = $info->getFilename();
            $data['tmp_name'] = $info->getFilename();   // eg 42a79759f284b767dfcb2a0197904287.jpg
            $data['img_type'] = $request->post('type');
            //$data['create_time'] = date('Y-m-d H:i:s',time());
            $data['update_time'] = date('Y-m-d H:i:s',time());

            $res = Db::table('yf_hf_imgs')->where('id',$id)->update($data);
            if (!$res){
                $datas = array('code'=> 101, 'message' => '更新图片数据库失败',);
                return json_encode($datas);
            }
        }else{
            //上传失败获取错误信息
            $datas = array('code' => 102, 'message'  => $file->getError());
            return json_encode($datas,JSON_UNESCAPED_UNICODE);
        }

        //取到时间日期[年月日]
        $create_time = $this->imageModel->getCreateTime($id);
        $timearr = explode(" ",$create_time);
        $time = str_replace('-','',$timearr[0]);

        $data = array(
            'code' => 200,
            'message'  => '更新图片成功',
            'data'  => array(
                'img_id' => base64_encode($id),
                'url' => Tool::getImageUrl($time,$info->getFilename()),
            )
        );
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 删除图片
     * by songjian
     * @return json
     */
    public function remove(Request $request){
        $data['code'] = 101;
        $data['message'] = '';

        $img_id = base64_decode($request->get('img_id'));
        $res = $this->imageModel->deleteImg($img_id);
        if ($res == 1){
            $data['code'] = 200;
            $data['message'] = '删除图片成功';
        }else{
            $data['message'] = '删除图片失败';
        }
        return json_encode($data,JSON_UNESCAPED_UNICODE);
    }

    /**
     * 发布视频成功后将图片更新，并将户型图更新
     * by songjian
     * @return json
     */
    public static function realmove($video_id,$user_id){
        $time = date('Y-m-d H:i:s',time());
        //将图片表中的video_id更新
        $sql = "update `yf_hf_imgs` set `video_id`='$video_id', `session_id`=0, `update_time`= '$time' WHERE `session_id`='{$user_id}'";
        $res = Db::query($sql);
        if ($res == 0) {
            return false;
        }else{
            return true;
        }
    }
}