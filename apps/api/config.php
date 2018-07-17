<?php
//配置文件
error_reporting(E_ERROR | E_PARSE);

return [
    // 应用模式状态
    'app_status'             => 'dev-config',
    'session_out_time' => false,  //是否开启session过期时间
    'jwt_key' => '123456',
    //图片上传文件目录
    'img_upload'            => ROOT_PATH . 'public' . DS . 'uploads' . DS . 'img',
    
    'array_rent' =>[
        '房子还在么？','怎么联系你？','舍友怎么样？','整租可以么？','是否办理租赁备案？','要最小的多少钱？','想过来看看','何时可看房？ ', '物业水电？', '具体位置是哪？','能办公？地址可以注册么？', '还有附近差不多的房子么？', '房子带阳台吗？', '房子整租多少钱？', '我想租有窗，室内采光好，最重要押一付一。', '有没有一室或者3室整租那种？', '这个价格是一间，还是整套？', '请问这是2室吗？没有看到另一个卧室。', '有空调吗？', '电怎么算？', '请问大概多少平方？', '有电梯么？', '你好，还有其他单间吗？', '可以烧饭么？', '有客厅？', '实拍？', '联系方式多少？', '这是几房？', '这是几楼？', '还有不？实拍实价嘛？', '房子跟视频一样嘛？', '这是哪一站啊？', '商业用电？', '请问距离地铁站多远？', '押金多少？', '房子包括哪些？', '让带孩子么？', '可以养狗吗？', '还有么？我男生。', '房子还有么？我女生，一个人住。', '附近有地铁站么？', '有地方停车么？', '你好，你是中介么？', '你好，除租房以外有管理费么？', '你好，这是公寓么？', '能做饭么？有中介费或者服务费么？', '请问可以短租几个月吗？', '你好，是和那个单位签合同？', '电话方便给我吗？', '带卫生间？', '长租可以便宜么？',
    ],
    'array_sell' => [
        '户型好吗？','赠送面积多吗？','请问这里大概是什么年代建造的？','出行方便吗？','物业费多少？','产权多少年？','房子在几楼？','几楼？','哪一年的房子？','哪一年的房子啊？','房子还在么?','税费怎么算？','满五唯一？','朝南？','朝北？','南北通？','请问这里大概是什么年代建造的?',
    ],
    'array_music' => [
        'http://p9qck5myp.bkt.clouddn.com/%E6%88%91%E7%9A%84%E5%AE%9D%E8%B4%9D-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E5%A4%B1%E6%81%8B%E8%80%85%E8%81%94%E7%9B%9F-LD.mp3',
        'http://p9qck5myp.bkt.clouddn.com/%E5%A4%9A%E5%B9%B8%E8%BF%90-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E6%88%91%E7%88%B1%E4%BD%A0%E4%BA%B2%E7%88%B1%E7%9A%84-LD.mp3',
        'http://p9qck5myp.bkt.clouddn.com/trip-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E5%8F%91%E7%8E%B0-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E6%97%A7%E6%97%B6%E5%85%89-LD.mp3',
        'http://p9qck5myp.bkt.clouddn.com/%E8%AE%A4%E7%9C%9F%E7%9A%84%E9%9B%AA-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E5%92%96%E5%96%B1%E5%92%96%E5%96%B1-LD.mp3',
        'http://p9qck5myp.bkt.clouddn.com/%E9%97%B7-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E5%8F%AF%E7%88%B1%E9%A2%82-LD.mp3',
        'http://p9qck5myp.bkt.clouddn.com/%E7%BB%93%E5%A9%9A%E5%90%A7-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E9%86%89-LD.mp3',
        'http://p9qck5myp.bkt.clouddn.com/%E6%9C%89%E4%BD%95%E4%B8%8D%E5%8F%AF-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E5%8D%88%E9%A4%90-LD.mp3',
        'http://p9qck5myp.bkt.clouddn.com/%E7%AE%97%E4%BD%A0%E7%8B%A0-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E6%9C%89%E7%82%B9%E7%94%9C-LD.mp3',
        'http://p9qck5myp.bkt.clouddn.com/%E5%A5%87%E5%A6%99%E8%83%BD%E5%8A%9B%E6%AD%8C-LD.mp3','http://p9qck5myp.bkt.clouddn.com/%E8%BF%9C%E8%B5%B0%E9%AB%98%E9%A3%9E-LD.mp3',
        'http://p9qck5myp.bkt.clouddn.com/GQ-LD.mp3'
    ],
    //需要屏蔽行为接口的用户
    'miss_user' => [
        '566','598','2233','568','473','570','578','2277','2231','577','573','579','2216','2257'
    ]
];