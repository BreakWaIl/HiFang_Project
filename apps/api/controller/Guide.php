<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/27
 * Time: 17:02
 */
namespace app\api\controller;

use app\common\model\Area;
use think\Request;
use think\Db;

class Guide
{
    public function __construct()
    {
        $this->areaModel = new Area();
    }

    /**获取标签表
     * @return json
     * @author zyt
     */
    public function getLabel ()
    {
        $result['code']    = 101;
        $result['message'] = '';
        $label = DB::table('yf_hf_label')->select();
        $data = [];
        for ($i=0;$i<count($label);$i++) {
            $data[$i] = [
                'id'          => $label[$i]['id'],
                'label_name'  => $label[$i]['label_name'],
                'sort'        => $label[$i]['sort'],
                'create_time' => $label[$i]['create_time'],
            ];
        }
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

    /**
     * 买房者和租房者选择区域
     * @param type 选择类型 1业主 2经纪人 3买房者 4租房者
     * @return json
     * @author zyt
     */
    public function getList (Request $req)
    {
        $result['code']    = 101;
        $result['message'] = '';
        $type = $req->get('type');
        if (!isset($type)) {
            $result['message'] = '请求状态不能为空';
            return json_encode($result, JSON_UNESCAPED_UNICODE);
        }
        $area = $this->areaModel->getAreaById();
        $result['message'] = '查询成功';
        $house = [[
            'house_id'     => 1,
            'house_type'   => '一室'
        ],[
            'house_id'     => 2,
            'house_type'   => '二室'
        ],[
            'house_id'     => 3,
            'house_type'   => '三室'
        ],[
            'house_id'     => 4,
            'house_type'   => '其他'
        ]];
        $sell = [[
            'sell_id'     => 0,
            'sell_type'   => '合租',
        ],[
            'sell_id'     => 1,
            'sell_type'   => '出售',
        ],[
            'sell_id'     => 2,
            'sell_type'   => '整租',
        ]];
        switch($type){
            case 1: //1业主
                $result['code']    = 200;
                $result['message'] = '查询成功';
                $result['data']    = [
                    'sell'         => $sell,
                    'area'         => $area,
                    'house'        => $house
                ];
                break;
            case 2: //2经纪人
                $result['code']    = 200;
                $result['message'] = '查询成功';
                $result['data'] =  [
                    'area'      => $area
                ];
                break;
            case 3: //3 买房者
                $result['code']    = 200;
                $result['message'] = '查询成功';
                $result['data'] = [
                    'area'      => $area,
                    'house'     => $house
                ];
                break;
            case 4: //4 租房者
                $result['code']    = 200;
                $result['message'] = '查询成功';
                $result['data'] = [
                    'area'      => $area,
                    'house'     => $house
                ];
                break;
            default:
                $result['message'] = '请求状态异常' . $type;
        }
        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     * by liyang
     * 20180716
     */
    //首页活动接口
//    public function getActivity()
//    {
//        //1.图片
//        //2.点进去的链接
//    }

}