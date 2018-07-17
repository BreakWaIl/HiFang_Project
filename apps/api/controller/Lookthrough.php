<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/5/31
 * Time: 11:32
 */
namespace app\api\controller;

use think\Db;
use app\common\model\LookThrough as LookThroughModel;


class Lookthrough extends Basic
{
    public function __construct($request = null)
    {
        parent::__construct($request);
        $this->lookthroughModel = new LookThroughModel();
    }
    /**浏览人列表 post
     * @return json
     * @author zyt
     */
    public function getList ()
    {
        header("Access-Control-Allow-Origin: *");
        $result['code']    = 101;
        $result['message'] = '';
        $video_id = $this->params['video_id'];
        $pageNo = $this->params['pageNo'];

        if (empty($video_id)) {
            $result['code']    = 101;
            $result['message'] = '请传入视频id';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }

        $lookthrough = $this->lookthroughModel->getLookThroughList($video_id, $pageNo, $pageSize=10);
        if (count($lookthrough['list']) > 0) {
            $result['code']    = 200;
            $result['message'] = '查询成功';
            $result['data']    = $lookthrough;
        } else {
            $result['code']    = 200;
            $result['message'] = '查询数据为空';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

}