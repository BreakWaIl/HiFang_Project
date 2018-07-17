<?php

namespace app\common\model;

use think\Model;

class NoteLog extends Model
{
    // 用户手机登录后的信息记录表
    // 设置当前模型对应的完整数据表名称
    protected $table = 'yf_hf_note_log';
    protected $updateTime = false;
    protected $createTime = false;
    //protected $auto_timestamp = false;
}
