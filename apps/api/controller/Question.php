<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/28
 * Time: 15:33
 */
namespace app\api\controller;

use app\common\model\Question as QuestionModel;
use think\Request;
use think\Db;

class Question
{
    public function __construct()
    {
        $this->questionModel = new QuestionModel();
    }

    /**获取常见问题
     * @return json
     * @author zyt
     */
    public function getList ()
    {
        header("Access-Control-Allow-Origin: *");
        $result['code']    = 101;
        $result['message'] = '';
        $data = DB::table('yf_hf_question')->where('type',1)->select();
        if (count($result) > 0) {
            $result['code']    = 200;
            $result['message'] = '查询成功';
            $result['data']    = $data;
        } else {
            $result['code'] = 200;
            $result['message'] = '该条件未查询到信息';
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

}