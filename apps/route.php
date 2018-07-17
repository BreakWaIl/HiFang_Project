<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
use think\Route;

//防止路由冲突了后台
if (MODULE_MARK!=='admin') {
	//微信接口
	Route::rule('WxInterface/:wxid', 'wechat/WxInterface/index');
	Route::rule('wechat/Oauth/:wxid', 'wechat/home/wechatOauth');
	//前台插件执行入口
	Route::rule('plugin_execute', 'home/plugin/execute');
	//前台上传入口
	Route::rule('upload', 'home/Upload/upload');
}

//member控制器
Route::get('admin/member/sendsms/:phone','admin/member/sendSms');  //发送短信
Route::get('admin/member/sendSms','admin/member/sendSms');  //发送短信
Route::rule('admin/member/login','admin/member/login');  //登录接口
Route::rule('admin/member/logout','admin/member/logout');  //安全登出接口
Route::rule('admin/member/invite','admin/member/invite');  //通过发短信邀请用户接口
Route::rule('admin/member/bandPhone','admin/member/bandPhone');  //微信用户绑定手机号
Route::rule('admin/member/checkInvite','admin/member/checkInvite');  //微信端H5用户邀请注册页面判断

//账单验证管理
Route::rule('admin/account/index','admin/account/index'); //账单验证管理列表页
Route::rule('admin/account/verify','admin/account/verify'); //账单审核验证

//他人主页(分享到微信)
Route::rule('api/video/getVideoByMemberId','api/video/getVideoByMemberId'); //他人主页出租出售房源视频列表
Route::rule('api/member/getMemberDetail','api/member/getMemberDetail'); //他人主页信息详情
Route::rule('api/follow/getFollowListByMemberId','api/follow/getFollowListByMemberId'); //他人主页点赞视频列表


//chat模块路由
Route::rule('chat/sendmessage','chat/index/sendmessage');
Route::rule('chat/upload_file','chat/index/upload_file');
Route::rule('chat/upload_image','chat/index/upload_image');
Route::rule('chat/add_friend','chat/index/add_friend');
Route::rule('chat/remove_friend','chat/index/remove_friend');
Route::rule('chat/join_group','chat/index/join_group');
Route::rule('chat/leave_group','chat/index/leave_group');
Route::rule('chat/members','chat/index/members');
Route::rule('chat/saveVoice','chat/index/saveVoice');
Route::rule('chat/offline','chat/index/offline');

//api 模块路由
Route::rule('api/video/shareWatch','api/video/shareWatch');  //分享视频得红包-判断是否是分享观看的数据
Route::rule('api/video/getVideoList','api/video/getVideoList');
Route::rule('api/video/getVideoLists','api/video/getVideoLists');
Route::rule('api/video/getVideoListById','api/video/getVideoListById');
Route::rule('api/video/getWXVideoDetail','api/video/getWXVideoDetail');

Route::rule('api/report/getList','api/report/getList');

//Route::rule('api/buildings/findBuildByCheck','api/buildings/findBuildByCheck');   //通过多选框搜索视频
Route::rule('api/buildings/findBuildByName','api/buildings/findBuildByName');   //通过 关键字 搜索小区信息(小区名、id、视频数量)

Route::rule('api/user/finduser','api/user/finduser');   //通过 关键字 搜索全局用户

Route::rule('api/video/checkPower','api/video/checkPower');   //
Route::rule('api/behavior/insertBackBehavior','api/behavior/insertBackBehavior');   //后台行为接口自动插入
Route::rule('api/behavior/insertBehavior','api/behavior/insertBehavior');   //后台行为接口