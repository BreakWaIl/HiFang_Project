<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/28
 * Time: 17:33
 */
namespace app\api\controller;

use app\common\model\Report as ReportModel;
use think\Db;
use think\Request;
use app\common\model\AccountDetails;

class Report extends Basic
{
    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->reportModel = new ReportModel();
        $this->accountModel = new AccountDetails();
    }
    /**举报列表 post
     * @return json
     * @author zyt
     */
    public function getList ()
    {
        header("Access-Control-Allow-Origin: *");
        $result['code']    = 101;
        $result['message'] = '';

        $report = Db::table('yf_hf_question')->where('type',0)->select();
        $data = [];
        if (count($report) > 0) {
            for($i=0;$i<count($report);$i++){
                $data[]        = [
                    'id'       => $report[$i]['id'],
                    'content'  => $report[$i]['title']
                ];
            }
            $result['code']    = 200;
            $result['message'] = '查询成功';
            $result['data']    = $data;
        } else {
            $result['code']    = 200;
            $result['message'] = '数据为空';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**举报视频 post
     * @param video_id array  被举报视频id
     * @param content_id  内容id
     * @return json
     * @author zyt
     */
    public function addReport ()
    {
        header("Access-Control-Allow-Origin: *");
        $result['code']    = 101;
        $result['message'] = '';

        $video_id  = $this->params['video_id'];
        $content_id   = $this->params['content_id'];
        //$content_id = [4,5];
        if (empty($video_id) || empty($content_id)) {
            $result['message'] = '传入参数不能为空';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        //查询是否举报过该视频
        $report = $this->reportModel->where(['member_id'=>$this->userId,'video_id'=>$video_id])->find();
        if ($report) {
            $result['message'] = '您已举报过一次,请勿再次举报';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }

        if (is_array($content_id)) {
            $content_ids = implode(',',$content_id);
            $data  = [
                'id'          => 0,
                'member_id'   => $this->userId,
                'video_id'    => $video_id,
                'content_id'  => $content_ids,
                'status'      => 0,
                'create_time' => time(),
                'update_time' => time()
            ];
            $res   =  $this->reportModel->save($data);
        }
        //获取举报奖励金
        $report_icon = Tool::getConfigInfo(68);
        $contentList = Db::table('yf_hf_question')->whereIn('id',$content_id)->select();
        $content = '';
        for ($i=0;$i<count($contentList);$i++) {
            $content .= $contentList[$i]['id'] . '.' . $contentList[$i]['title'];
        }
        $data1 = $this->accountModel->save([
            'id'            => 0,
            'member_id'   => $this->userId,
            'video_id'    => $video_id,
            'money'       => $report_icon,
            'type'        => 7,
            'status'      => 0,
            'remarks'     => $content,
            'create_time' => time(),
            'update_time' => time()
        ]);

        if (count($res) > 0 && count($data1) > 0) {
            $result['code']    = 200;
            $result['message'] = '举报成功';
        } else {
            $result['message'] = '举报失败';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }
}