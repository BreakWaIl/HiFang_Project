<?php
/**
 * Created by PhpStorm.
 * User: fu ju
 * Date: 2018/1/20
 * Time: 17:52
 */

namespace app\common\model;

use think\Db;

class AAgents extends BaseModel
{

    protected $table = 'a_agents';

    /**
     * 返回经纪人和部门信息
     *
     * @param $phone
     * @param string $pwd
     * @param bool $department
     * @param string $field
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getInfo($phone, $pwd = '', $department = true, $field = '*')
    {
        $where['status'] = 0;
        $where['phone']  = $phone;

        if ($pwd != '') {
            $where['password'] = md5($pwd);
        }

        $agents_data = $this->field($field)->where($where)->find();

        if (!$department) {
            return $agents_data;
        }

        if (!empty($agents_data->store_id)) {
            $store_name                = Db::table('a_store')->where('id', $agents_data['store_id'])->value('store_name');
            $agents_data['department'] = $store_name;
        }

        if (!empty($agents_data->auth_group_id)) {
            $district_name             = Db::table('a_district')->where('id', $agents_data['district_id'])->value('district_name');
            $agents_data['department'] = $district_name ? $district_name . '-' . $store_name : $district_name;
        }

        $agents_data['commission'] = 500;

        switch ($agents_data['level']) {
            case 10 :
                $agents_data['level_name'] = '业务员';
                break;
            case 20 :
                $agents_data['level_name'] = '店长';
                break;
            case 30 :
                $agents_data['level_name'] = '总监';
                break;
            case 40 :
                $agents_data['level_name'] = '总监';
                break;
        }

        return $agents_data;
    }

    /**分页列表
     * @param int $p
     * @param int $pageSize
     * @param string $order_
     * @param string $field
     * @param string $join
     * @param string $where
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getListJoin($p = 1, $pageSize = 15, $order_ = 'id desc', $field = '', $join = '', $where = '')
    {
        $data = $this->field($field)
            ->alias('a')
            ->join($join)
            ->where($where)
            ->order($order_)
            ->limit($pageSize)
            ->page($p)
            ->select();
        //echo $this->getLastSql();
        return $data;
    }


    /**检查重复
     * @param $name
     * @param $key
     * @return bool
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function repetition($name, $key)
    {
        $r = $this->field($name)
            ->where($name, '=', $key)
            ->select();
        //$this->getLastSql();
        if ($r) {
            return true;
        } else {
            return false;
        }
    }

    //更新数据
    public function saveStatus($name, $key, $ids)
    {
        $r = $this->where("id", 'in', $ids)->update([ $name => $key ]);
        return $r;
    }

//删除数据
    public function delUid($name, $ids)
    {
        $this->where($name, 'in', $ids)->delete();
    }


    /**通过ids批量添加数据
     * @param $ids
     * @param $data
     * @return array|false|int
     * @throws \Exception
     */
    public function addAllAccess($ids, $data)
    {
        $idarr = explode($ids);
        if (is_array($idarr)) {
            $arr = array();
            foreach ($idarr as $v) {
                $data['uid'] = $v;
                $arr[]       = $data;
            }
            $r = $this->saveAll($arr);
        } else {
            $data['uid'] = $ids;
            $r           = $this->save($data);
        }
        return $r;
    }

    /**
     * 记录总数
     *
     * @param $params
     * @return int|string
     */
    public function getTotal2($join, $params)
    {
        return $this->alias('a')
            ->join($join)
            ->where($params)->count();
    }

    /**
     * 操作盘方记录
     *
     * @param int $pageNo
     * @param int $pageSize
     * @param string $order_
     * @param string $field
     * @param string $params
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getRecords($pageNo = 1, $pageSize = 15, $order_ = 'id desc', $field = '', $params = '')
    {
        $data = Db::table('g_operating_records')
            ->field($field)
            ->where($params)
            ->limit($pageSize)
            ->order($order_)
            ->page($pageNo)
            ->select();
        return $data;
    }

    /**
     * @param $field
     * @param $join
     * @param $params
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function verifyUser($field, $join, $params)
    {

        $r = $this->field($field)
            ->alias('a')
            ->join($join)
            ->where($params)
            ->find();
        //echo $this->getLastSql();
        return $r;
    }

    /**
     * 总监列表
     *
     * @param int $pageNo
     * @param int $pageSize
     * @param string $order_
     * @param string $field
     * @param string $params
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getListDistrict($pageNo = 1, $pageSize = 15, $order_ = 'id desc', $field = '', $params = '')
    {
        $data = $this->field($field)
            ->where($params)
            ->order($order_)
            ->limit($pageSize)
            ->page($pageNo)
            ->select();

        $district_where['status'] = 0;
        $store_where['status']    = 0;
        $result                   = array();
        foreach ($data as $k => $v) {
            $result[$k] = $v;
            if (isset($v->district_id)) {
                $district_where['id']        = $v->district_id;
                $result[$k]['district_name'] = Db::table('a_district')->where($district_where)->value('district_name');
                if ($result[$k]['district_name']) {
                    $store_where['district_id'] = $v->district_id;
                    $result[$k]['store_num']    = Db::table('a_store')->where($store_where)->count('store_name');
                } else {
                    $result[$k]['store_num'] = '';
                }
            }
        }
        return $result;
    }

    /**
     * 总监列表总数
     *
     * @param $params
     * @return int|string
     */
    public function getListDistrictTotal($params)
    {
        return $this->where($params)
            ->count();
    }

    /**
     * 获取经纪人
     *
     * @param string $field
     * @param $params
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getAgentById($field = "id", $params)
    {
        $where_ = [];
        if (isset($params["agent_id"])) {
            $where_["id"] = $params["agent_id"];
        }

        $result = $this->field($field)
            ->where($where_)
            ->select();
        // echo $this->getLastSql();
        return $result;
    }

    /**
     * 修改密码
     *
     * @param $id
     * @param $pwd
     * @param $old_pwd
     * @return bool|false|int
     */
    public function editPwd($id, $pwd, $old_pwd)
    {
        $field_pwd = $this->where('id', $id)->value('password');
        if ($field_pwd == md5($old_pwd)) {
            $result = $this->save([ 'password' => md5($pwd) ], [ 'id' => $id ]);
        } else {
            $result = false;
        }
        return $result;
    }

    /**
     * 忘记密码
     *
     * @param $id
     * @param $pwd
     * @return false|int
     */
    public function forgetPwd($id, $pwd)
    {
        return $this->save([ 'password' => md5($pwd) ], [ 'id' => $id ]);
    }

    public function saveList()
    {

    }

    /**
     * 分页列表
     * @param int $p
     * @param int $pageSize
     * @param string $order_
     * @param string $field
     * @param string $join
     * @param string $where
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getList($p = 1, $pageSize = 15, $order_ = 'id desc', $field = '', $join = '', $where = '')
    {
        $data = $this->field($field)
            ->alias('a')
            ->join($join)
            ->where($where)
            ->order($order_)
            ->limit($pageSize)
            ->page($p)
            ->select();
        return $data;
    }


    /**
     * 统计任务获取经纪人列表
     * @param int $pageNo
     * @param int $pageSize
     * @param string $field
     * @return false|\PDOStatement|string|\think\Collection
     */
    public function getAgentsListByTask($pageNo = 1, $pageSize = 15, $field = "id")
    {
        return Db::table($this->table)
            ->field($field)
            ->select();

    }

    /**
     * 获取经纪人总数
     * @return int|string
     */
    public function getAgentsCountByTask()
    {
        return Db::table($this->table)
            ->count();
    }

    /**
     * 批量获取经纪人
     * @param $params
     * @return false|\PDOStatement|string|\think\Collection
     */
    public function getAgentsByStoreId($params)
    {
        $result = Db::table($this->table)
            ->field("id,name")
            ->where($params)
            ->select();
        //echo Db::table($this->table)->getLastSql();
        return $result;
    }


    public function countAgentNum($params)
    {
        $where_ = $whereOr_ = [];
        if (isset($params["quit_time"])) {
            $whereOr_["a.quit_time"] = $params["quit_time"];
            $whereOr_["a.status"]    = 3;
        }
        if (isset($params["district_id"])) {
            $where_["a.district_id"] = $params["district_id"];
            $where_["a.status"]      = 0;
        }
        $result = Db::table($this->table)
            ->field("a.id,a.store_id ,b.store_name,count(a.id) as agent_num")
            ->alias("a")
            ->join("a_store b", "a.store_id = b.id", "left")
            ->where($where_)
            ->whereOr(function ($query) use ($whereOr_) {
                $query->where($whereOr_);
            })
            ->group("a.store_id")
            ->select();
        //echo Db::table($this->table)->getLastSql();
        return $result;

    }


    public function getAgentsInfoByAgentId($field, $params)
    {
        $where_ = [];
        if (isset($params["agent_id"])) {
            $where_["a.id"] = $params["agent_id"];
        }
        if (isset($params["phone"])) {
            $where_["a.phone"] = $params["phone"];
        }
        if (isset($params["store_id"])) {
            $where_["b.id"]    = $params["store_id"];
            $where_["a.level"] = array( "in", "20,40" );
        }
        if (isset($params["district_id"])) {
            $where_["c.id"]    = $params["district_id"];
            $where_["a.level"] = array( "in", "30,40" );
        }
        $where_["a.status"] = 0;

        $result = Db::table($this->table)
            ->field($field)
            ->alias("a")
            ->join("a_store b", "a.store_id = b.id", "left")
            ->join("a_district c", "a.district_id = c.id", "left")
            ->where($where_)
            ->select();
        return $result;

    }

    public function searchAgentsByKeyword($field, $params)
    {

        $params["status"] = 0;

        $result = Db::table($this->table)
            ->field($field)
            ->where($params)
            ->select();
        return $result;
    }

    /**
     * 检查是否有权限
     *
     * @param $id
     * @param $agents_id
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function agentsAuth($id, $agents_id)
    {
        return $this->alias('a')
            ->field('b.id')
            ->join('auth_group b', 'a.auth_group_id=b.id', 'left')
            ->where("FIND_IN_SET({$id},b.rules)")
            ->where('a.id', $agents_id)
            ->where('b.status', 0)
            ->find();
    }

    /**
     * 根据id检查是否有权限
     *
     * @param $agents_id
     * @param $rule
     * @return mixed
     */
    public function agentsAuthId($agents_id, $rule)
    {
        $rules = $this->alias('a')
            ->field('b.id')
            ->join('auth_group b', 'a.auth_group_id=b.id', 'left')
            ->where('b.status', 0)
            ->where('a.id', $agents_id)
            ->value('rules');

        $rule_model = new AuthRule();
        return $rule_model->where('id', 'in', $rules)
            ->where('name', $rule)
            ->value('id');
    }


    /**
     * 根据id检查是否有权限
     *
     * @param $agents_id
     * @param $rule
     * @return mixed
     */
    public function agentsAuthIds($agents_id, $rule)
    {
        $rules = $this->alias('a')
            ->field('b.id')
            ->join('auth_group b', 'a.auth_group_id=b.id', 'left')
            ->where('b.status', 0)
            ->where('a.id', $agents_id)
            ->value('rules');

        $rule_model = new AuthRule();
        $result     = $rule_model
            ->field("id,name")
            ->where('id', 'in', $rules)
            ->where($rule)
            ->select();
        return $result;
    }

    /**
     * 根据id获取单个字段值
     *
     * @param $id
     * @param $fields
     * @return mixed
     */
    public function getAgentsById($id, $fields)
    {
        return $this->where('id', $id)->value($fields);
    }

    /**
     * @param $where
     * @param $fields
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getAgentsStoreById($where, $fields)
    {
        return $this->alias('a')
            ->field($fields)
            ->join('a_store b', 'a.store_id=b.id', 'left')
            ->where($where)
            ->find();
    }

    /**
     * @param $field
     * @param $params
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getStoreOrAgentInfo($field, $params)
    {
        return Db::table($this->table)
            ->field($field)
            ->alias("a")
            ->join("a_store b", "a.store_id = b.id", "left")
            ->where($params)
            ->where('a.level', [ '=', 20 ], [ '=', 40 ], 'or')
            ->select();
    }

    /**
     * 根据id获取经纪人信息
     *
     * @param $field
     * @param $agent_id
     * @param string $where
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getAgentInfo($field, $agent_id = '', $params = '')
    {
        if ($agent_id != '') {
            $where['id'] = $agent_id;
        } else {
            $where = $params;
        }
        return $this->field($field)
            ->where($where)
            ->find();
    }

    /**
     * 验证用户是否存在
     *
     * @param $phone
     * @return int|string
     */
    public function getAgentExist($phone)
    {
        return $this->where([
            'phone'  => $phone,
            'status' => 0
        ])->count();
    }

    /**
     * 根据order_id获得独家和盘方
     *
     * @param $order_id
     * @return array|false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getAgentEelationByOrderId($order_id)
    {
        $order    = new OrderModel();
        $house_id = $order->where('id', $order_id)->value('house_id');
        $data     = [];
        if (!empty($house_id)) {
            $agent_device = $this->alias('a')
                ->field('a.id,a.device_id')
                ->join('g_houses_to_agents b', 'a.id = b.agents_id', 'left')
                ->where('houses_id', $house_id)
                ->where('type', 'in', '2,3')
                ->where('is_del', 0)
                ->select();

            foreach ($agent_device as $k => $v) {
                $data[$k] = $v->getData();
            }
        }

        return $data;
    }

    /**
     * 多个id获取经纪人信息
     *
     * @param array $agent_id
     * @param string $field
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getAgentAllById($agent_id = [], $field = '*')
    {
        return Db::table($this->table)->field($field)
            ->where('id', 'in', implode(',', $agent_id))
            ->where('status', 0)
            ->select();
    }

    /**
     * 店长
     *
     * @param $agent_id
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getStoreAgentId($agent_id)
    {
        $store_id = $this->where('id', $agent_id)->value('store_id');
        return $this->alias('a')
            ->field('b.store_name,a.id,a.device_id')
            ->join('a_store b', 'a.store_id=b.id')
            ->where('b.id', $store_id)
            ->where('level', 'in', '20,30')
            ->find();
    }

    /**
     * @param $agent_id
     * @return mixed
     */
    public function Agents_res($agent_id)
    {
        return db('a_agents')->alias('a')
            ->field('name,phone,img,store_name')
            ->join('a_store b', 'a.store_id=b.id', 'left')
            ->where('a.id', $agent_id)
            ->find();
    }

    /**
     * 查询经纪人
     *
     * @param int $pageNo
     * @param int $pageSize
     * @param string $order_
     * @param $field
     * @param $params
     * @param string $house_id
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getUser($pageNo = 1, $pageSize = 15, $order_ = 'id desc', $field, $params, $house_id = '')
    {
        if ($house_id == '') {
            $data = $this->field($field)->alias('a')
                ->join('u_evaluate b', 'a.id = b.agents_id', 'left')
                ->where($params)
                ->group('a.id')
                ->order($order_)
                ->limit($pageSize)
                ->page($pageNo)
                ->select();
        } else {
            $data = $this->field($field)->alias('a')
                ->join('u_evaluate b', 'a.id = b.agents_id', 'left')
                ->join('g_houses_to_agents c', 'a.id=c.agents_id', 'left')
                ->where('c.houses_id', $house_id)
                ->where('type', 1)
                ->where($params)
                ->group('a.id')
                ->order($order_)
                ->limit($pageSize)
                ->page($pageNo)
                ->select();
        }

        return $data;
    }

    /**
     * @param int $pageNo
     * @param int $pageSize
     * @param string $order_
     * @param string $field
     * @param string $params
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function searchAgentShop($pageNo = 1, $pageSize = 15, $order_ = 'id desc', $field = '', $params = '') {
        return $this->field($field)
            ->alias('a')
            ->join('a_store b', 'a.store_id = b.id', 'left')
            ->where($params)
            ->order($order_)
            ->limit($pageSize)
            ->page($pageNo)
            ->select();
    }
}