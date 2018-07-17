var server_host='https://hifang.fujuhaofang.com';
server_host=document.location.protocol+"//"+document.location.hostname;
layui.config({
    base: server_host+'/assets/libs/'
}).extend({
    'woker.min': 'woker/woker.min',
    'swfobject': 'websocket/swfobject',
    'web_socket': 'websocket/web_socket',
    'recorder': 'webrtc/recorder'

});

if(typeof $ != 'function') {
    layui.use(['jquery'], function () {
        laychat.jquery = layui.jquery;
    });
}

//一个数组（元素为对象的格式）去重方法
function arrayUnique2(arr, name) {
    var hash = {};
    return arr.reduce(function (item, next) {
        hash[next[name]] ? '' : hash[next[name]] = true && item.push(next);
        return item;
    }, []);
};

layui.link(server_host+'/assets/libs/layui/css/modules/demo.css');
var laychat = {
    appName: 'Hi房在线聊天',
    websocketAddress: 'wss://talk.fujuhaofang.com:4431',
    membersUrl: server_host+'/chat/members',
    sendMessageUrl: server_host+'/chat/sendmessage',
    uploadImageUrl: server_host+'/chat/upload_image',
    uploadFileUrl: server_host+'/chat/upload_file',
    addFriendUrl: server_host+'/chat/add_friend',
    removeFriendUrl: server_host+'/chat/remove_friend',
    addGroupUrl: server_host+'/chat/join_group',
    leaveGroupUrl: server_host+'/chat/leave_group',
    chatlog: server_host+'/chat/chatlog/mine/',
    noreadMsg: server_host+'/chat/Offlinemsg',
    uploadVoiceUrl: server_host+'/chat/saveVoice',
    initUrl: null,
    brief: false,
    setmin: false,
    right: '0px',
    minRight: null,
    initSkin: '',
    isAudio: false,
    isVideo: false,
    notice: false,
    maxLength: 3000,
    skin: null,
    copyright: false,
    isMobile: false,
    setMin: false,
    enableNewFriend:false,
    enableAudio: false,
    enableVideo: true,
    enableGroup: true,
    enableFriend: true,
    friendList:'',
    groupList:'',
    voice: 'default.mp3',
    inited: 0,
    socket: null,
    open: function () {

        laychat.Listenpaste();

        if(typeof laychat.getCookie('laychat_vocie') != 'undefined'){
            if(laychat.getCookie('laychat_vocie') == 'false'){
                laychat.voice =false;
            }else{
                laychat.voice =laychat.getCookie('laychat_vocie');
            }
        }


        if (this.inited) return;
        if (this.isIE6or7()) return;

        if (laychat.isMobile) {
            layui.link(server_host+'/assets/libs/layui/css/layui.mobile.css');
        } else {
            layui.link(server_host+'/assets/libs/layui/css/layui.css');

        }

        if (typeof WebSocket != 'function') {

            layui.use(['jquery', 'swfobject', 'web_socket', 'woker.min'], function () {
                WEB_SOCKET_SWF_LOCATION = server_host+'/assets/libs/swf/WebSocketMain.swf';
                WEB_SOCKET_DEBUG = true;
                WEB_SOCKET_SUPPRESS_CROSS_DOMAIN_SWF_ERROR = true;


                laychat.jquery = layui.jquery;
                if (laychat.initUrl != null) {
                    laychat.jquery = layui.jquery;
                    laychat.jquery.ajax({
                        url: laychat.initUrl,
                        type: 'get',
                        dataType: 'json',
                        success: function (res) {

                            if (res.code == 0) {
                                var data = res.data;
                                laychat.mine =data.mine;
                                laychat.friendList =data.friend;
                                laychat.groupList  =data.group;

                                laychat.initIM(data);
                                laychat.connect(data);

                            }
                        }
                    });
                } else {

                    var data = {
                        'mine': laychat.mine,
                        'friend': laychat.friendList,
                        'group': laychat.groupList
                    };
                    laychat.initIM(data);
                    laychat.connect(data);
                }


            });
        } else {
            layui.use(['jquery', 'woker.min'], function () {
                laychat.jquery = layui.jquery;


                if (laychat.initUrl != null) {
                    laychat.jquery = layui.jquery;
                    laychat.jquery.ajax({
                        url: laychat.initUrl,
                        type: 'get',
                        dataType: 'json',
                        success: function (res) {

                            if (res.code == 0) {
                                var data = res.data;
                                laychat.mine=data.mine;
                                laychat.friendList=data.friend;
                                laychat.groupList=data.group;


                                laychat.initIM(data);
                                laychat.connect(data);

                            }
                        }
                    });
                } else {

                    var data = {
                        'mine': laychat.mine,
                        'friend': laychat.friendList,
                        'group': laychat.groupList
                    };
                    laychat.initIM(data);
                    laychat.connect(data);
                }

            });
        }

    },
    isIE6or7: function () {
        var b = document.createElement('b');
        b.innerHTML = '<!--[if IE 5]><i></i><![endif]--><!--[if IE 6]><i></i><![endif]--><!--[if IE 7]><i></i><![endif]-->';
        return b.getElementsByTagName('i').length === 1;
    },
    connect: function (res) {

        var falgstr = this.websocketAddress;
        var arr = falgstr.split(':');
        var host = arr[1].replace('//', '');
        if (arr[0] == 'wss') {
            type = 'wss';
            var woker = new Woker(laychat.app_key, {
                encrypted: true
                , enabledTransports: ['wss']
                , wsHost: host
                , wssPort: arr[2]
            });

        } else {
            var woker = new Woker(laychat.app_key, {
                encrypted: false
                , enabledTransports: ['ws']
                , wsHost: host
                , wsPort: arr[2]
            });
        }

        var channel = woker.subscribe('user' + res.mine.id);

        channel.on('woker:subscription_succeeded', function () {
            console.count('woker_subscription_succeeded');
            var mine =res.mine.id;

            layui.use(['jquery','layim'], function () {
                console.count('layim');
                laychat.jquery = layui.jquery;
                laychat.jquery.ajax({
                    url: laychat.noreadMsg,
                    type: 'post',
                    //data: {id: res.mine.id, group: res.group, app_key: laychat.app_key},
                    data: {id: res.mine.id, app_key: laychat.app_key},
                    dataType:'json',
                    success: function (res) {
                        var json=JSON.parse(res);
                        console.log(res);
                        if (json.code ==  0) {
                            console.log(json.data.length);
                            json.data.forEach(function(v, k, array){
                                var obj = laychat.jquery.parseJSON(v);
                                console.count('res_each');
                                if(obj['type'] == 'friend'){
                                    console.log(obj);
                                    layui.layim.getMessage(obj);
                                }else{

                                    if(obj['fromid'] != mine){
                                        layui.layim.getMessage(obj);
                                    }
                                };
                            });

//                          layui.each(json.data,function(k,v){
//                              var obj = laychat.jquery.parseJSON(v);
//                              console.info('======5');
//                              console.info(k);console.info(v);
//                              console.info('======6');
//                              console.info(obj);
//                              console.info('======7');
//                              console.info(obj.type);
//
//                              if(obj['type'] == 'friend'){
//                                  console.info('======8');
//                                  console.info(layui.layim.getMessage(obj));
//
//                                  layui.layim.getMessage(obj);
//                              }else{
//                                  console.info('======10');
//                                  console.info(obj.fromid);
//
//                                  if(obj['fromid'] != mine){
//                                      layui.layim.getMessage(obj);
//                                  }
//                              }
//                          });
                        }
                        /*if (res.code ==  0) {
                         layui.each(res.data,function(k,v){
                         var obj = laychat.jquery.parseJSON(v);
                         if(obj.type == 'friend'){
                         layui.layim.getMessage(obj);
                         }else{
                         if(obj.fromid != mine){
                         layui.layim.getMessage(obj);
                         }
                         }
                         });
                         }*/
                    }
                });
            });

        });

        // 接受消息
        channel.on('getmessage', function (data) {

            layui.layim.getMessage(data.message);
        });

        channel.on('addfriend', function (data) {
            data.message.groupid =res.friend[0].id;
            layui.layim.addList(data.message);
        });

        channel.on('removefriend', function (data) {
            layui.layim.removeList(data.message);
        });

        channel.on('video', function (data) {

            layui.use('layer', function () {

                var msg = data.message;
                var cha = data.channel;
                var avatar =data.avatar;
                var username =data.username;
                var userid =data.mine;

                var layer = layui.layer;
                layer.open({
                    type: 1,
                    title: '申请框',
                    area: ['260px', '180px'],
                    shade: 0.01,
                    fixed: true,
                    btn: ['接受', '拒绝'],
                    content: "<div style='position: absolute;left:20px;top:15px;'><img src='"+avatar+"' width='40px' height='40px' style='border-radius:40px;position:absolute;left:5px;top:5px;'><span style='width:100px;position:absolute;left:70px;top:5px;font-size:13px;overflow-x: hidden;'>"+username+"</span><div style='width:90px;height:20px;position:absolute;left:70px;top:26px;'>"+msg+"</div></div>",
                    yes: function () {
                        layer.close(layer.index);

                        var iWidth = 400;  // 窗口宽度
                        var iHeight = 300; // 窗口高度
                        var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
                        var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;

                        win = window.open("https://rtc.laychat.net/call/" + cha, "_blank", "toolbar=no,directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft + ",alwaysRaised=yes");


                    },
                    btn2: function () {

                        laychat.jquery.ajax({
                            url:server_host+'/chat/index/refuse',
                            type:'post',
                            data:{appkey:laychat.app_key,id:userid}
                        });

                        layer.close(layer.index);
                    }
                });
            });

        });

        channel.on('video-refuse',function (data) {

            layui.use('layer',function () {
                layer =layui.layer;
                layer.alert(data.message);
            });
        });


        var groups = res.group;


        channel.on('addgroup', function (data) {

            var channels = woker.subscribe('group' + data.message.id);
            channels.on('getmessage', function (data) {
                if (data.message.fromid != res.mine.id) {
                    layui.layim.getMessage(data.message);
                }
            });
        });


        channel.on('leavegroup', function (data) {

            woker.unsubscribe('group' + res.message.id);
            layui.each(groups, function (k, v) {
                if (v.id == data.message) {
                    groups[k] = '';
                }
            });
        });


        // 接受群消息

        if (groups.length >= 1) {
            layui.each(groups, function (k, v) {
                var channels = woker.subscribe('group' + v.id);
                channels.on('getmessage', function (data) {

                    if (data.message.fromid != res.mine.id) {
                        layui.layim.getMessage(data.message);
                    }
                });

            });
        }

        // 重连接
        woker.connection.on('state_change', function (states) {
            // states = {previous: 'oldState', current: 'newState'}
            if (states.current == 'unavailable' || states.current == 'disconnected' || states.current == 'failed') {

                woker.unsubscribe('user' +res.mine.id);
                if (groups.length >= 1) {

                    layui.each(groups, function (k, v) {
                        woker.unsubscribe('group' + v.id);
                    });

                }
                if (typeof woker.isdisconnect == 'undefined') {
                    woker.isdisconnect = true;
                    woker.disconnect();
                    delete woker;
                    window.setTimeout(function(){
                        laychat.connect(res);
                    },1000);
                }

            }

        });
    },
    addfriend: function (data) {

        laychat.jquery.ajax({
            url: laychat.addFriendUrl,
            type: 'post',
            data: data,
            success: function (res) {
                if (res) {
                    var res1 = laychat.jquery.parseJSON(res);
                    if (res1.code != 0) {
                        layui.layer.msg(res1.msg);
                    }
                }
            }
        });

        layui.layim.addList(data.addfriend);

    },
    removefriend: function (data) {

        laychat.jquery.ajax({
            url: laychat.removeFriendUrl,
            type: 'post',
            data: data,
            success: function (res) {
                if (res) {
                    var res1 = laychat.jquery.parseJSON(res);
                    if (res1.code != 0) {
                        layui.layer.msg(res1.msg);
                    }
                }
            }
        });
        layui.layim.removeList(data.removefriend);
    },
    addgroup: function (data) {

        laychat.jquery.ajax({
            url: laychat.addGroupUrl,
            type: 'post',
            data: data,
            success: function (res) {
                if (res) {
                    var res1 = laychat.jquery.parseJSON(res);
                    if (res1.code != '-1') {
                        layui.layer.msg(res1.msg);
                    }
                }
            }
        });

        layui.layim.addList(data.addgroup);

    },
    removegroup: function (data) {

        laychat.jquery.ajax({
            url: laychat.leaveGroupUrl,
            type: 'post',
            data: data,
            success: function (res) {
                if (res) {
                    var res1 = laychat.jquery.parseJSON(res);
                    if (res1.code != 0) {
                        layui.layer.msg(res1.msg);
                    }
                }
            }
        });
        layui.layim.removeList(data.removegroup);

    },

    focusInsert : function(str){

        if(laychat.jquery('.layim-chat-list .layim-this').index() < 0){
            console.log('没有聊天框的存在');
        }else{
            var obj =laychat.jquery('.layim-chat-textarea textarea')[laychat.jquery('.layim-chat-list .layim-this').index()];

            var result, val = obj.value;
            obj.focus();
            if(document.selection){
                result = document.selection.createRange();
                document.selection.empty();
                result.text = str;
            } else {
                result = [val.substring(0, obj.selectionStart), str, val.substr(obj.selectionEnd)];
                obj.focus();
                obj.value = result.join('');
            }

        }

    },

    imgReader:function(item){

        var blob = item.getAsFile(),
            reader = new FileReader();
        reader.onload = function( e ){
            imgSrc = e.target.result;


            layui.layer.msg('正在上传截图',{end:function(){

                laychat.jquery.post(server_host+'/chat/set/uploadimg',{imageContent:imgSrc},function(result){
                    if(result.code == 0){

                        laychat.focusInsert('img['+result.data.src+']');

                    }else{
                        layui.layer.msg(result.msg);
                    }
                },'json');

            }});
        };

        reader.readAsDataURL( blob );

    },

    Listenpaste:function(){

        layui.use(['jquery'], function () {
            laychat.jquery = layui.jquery;

            laychat.jquery('body').unbind('paste','.layim-chat-textarea textarea').bind('paste','.layim-chat-textarea textarea',function(e){
                var clipboardData = event.clipboardData || window.clipboardData || event.originalEvent.clipboardData;
                var   i = 0, items, item, types;
                if( clipboardData ){
                    items = clipboardData.items;
                    if( !items ){
                        return;
                    }
                    item = items[0];
                    types = clipboardData.types || [];
                    for(var i = 0; i < types.length; i++ ){
                        if( types[i] === 'Files' ){
                            item = items[i];
                            break;
                        }
                    }
                    if( item && item.kind === 'file' && item.type.match(/^image\//i) ){
                        laychat.imgReader( item );
                    }
                }
            });

        });


    },
    getCookie: function(name){
        var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
        if(arr=document.cookie.match(reg))
            return unescape(arr[2]);
        else
            return null;
    },

    getchange:function(){
        var val =laychat.jquery("#lay_voice").attr('title');

        if(val == 'off'){
            laychat.jquery("#laychat_type").toggleClass("layui-form-onswitch");
            laychat.jquery("#lay_voice").attr("title","on");
            laychat.jquery("#laychat_type").children('em').text('ON');
        }else{
            laychat.jquery("#laychat_type").toggleClass("layui-form-onswitch");
            laychat.jquery("#lay_voice").attr("title","off");
            laychat.jquery("#laychat_type").children('em').text('OFF');
        }

    },

    set:function(){
        var  str ="";
        str+='<div class="layui-form" style="margin-top:20px;">';
        str+='<div class="layui-form-item">';
        str+='<label class="layui-form-label">提示音</label>';
        str+='<div class="layui-input-block">';
        if(layui.layim.cache().base.voice == false){
            str+='<input type="checkbox" id="lay_voice"  lay-skin="switch"  title="off">';
            str+='<div id="laychat_type" class="layui-unselect layui-form-switch" style="width:32%;" lay-skin="_switch"><em>OFF</em><i onclick="laychat.getchange()"></i></div>';
        }else{
            str+='<input type="checkbox" id="lay_voice"  lay-skin="switch"  title="on" checked>';
            str+='<div id="laychat_type" class="layui-unselect layui-form-switch layui-form-onswitch" style="width:32%;" lay-skin="_switch"><em>ON</em><i onclick="laychat.getchange()"></i></div>';
        }
        str+=' </div></div>';
        str+='</div>';


        var set= layui.layer.open({
            type:1,
            title:"设置",
            area:['280px','180px'],
            content:str,

            btn:'确认' ,
            yes:function(){
                var obj = document.getElementById("lay_voice");

                if(obj.getAttribute('title') == 'on'){
                    layui.layim.cache().base.voice = 'default.mp3';
                    document.cookie='laychat_vocie=default.mp3';
                }else{
                    layui.layim.cache().base.voice = false;
                    document.cookie='laychat_vocie='+false;
                }

                layui.layer.close(set);
            }
        });

    },

    initIM: function (res) {

        var module = laychat.isMobile ? 'mobile' : 'layim';


        layui.use([module, 'recorder'], function (layim) {


            if (laychat.isMobile) {
                var mobile = layui.mobile,
                    layim = mobile.layim,
                    layer = mobile.layer;
                layui.layim = layim;
                layui.layer = layer;
            }

            // 初始化消息
            layim.on('ready', function (options) {

                //本地存储layim-mobile去重操作
                /*
                var _toId = laychat.to.id;
                var _meId = laychat.mine.id;
                console.log(_toId);
                var _llmStr = localStorage.getItem('layim-mobile');
                if(_llmStr){
                    var _llm = JSON.parse(_llmStr);
                    if(_llm && _llm[_meId] && _llm[_meId].chatlog['friend'+_toId]){
                        var _arrTemp = _llm[_meId].chatlog['friend'+_toId];
                        if(_arrTemp && _arrTemp.length){
                            var _len = _arrTemp.length;
                            console.log('new arr');
                            console.log(_arrTemp);
                            _llm[_meId].chatlog['friend'+_toId] = arrayUnique2(_arrTemp, 'timestamp');
                        };
                    };
                    localStorage.setItem('layim-mobile',JSON.stringify(_llm));
                };
                */
                //本地存储layim-mobile去重操作结束



                var str ='';
                str+="<li class='layui-icon' onclick='laychat.set()'>&#xe620;</li>";

                laychat.jquery("#layui-layim .layui-layim-main .layui-layim-tool").append(str);
                //laychat.jquery("#layui-layim .layui-layim-main .layui-layim-tool").html(str);

            });


            // 监听查看群员
            layim.on('members', function (data) {
                console.log(data);
            });
            // 监听发送消息
            layim.on('sendMessage', function (res) {

                if (res.to.type == 'friend') {


                    var newdata = {
                        username: res.mine.username //消息来源用户名
                        , avatar: res.mine.avatar //消息来源用户头像
                        , fromid: res.mine.id
                        , type: res.to.type //聊天窗口来源类型，从发送消息传递的to里面获取
                        , content: res.mine.content //消息内容
                        , toid: res.to.id
                        , appkey: laychat.app_key
                    };

                } else {


                    var newdata = {
                        username: res.mine.username //消息来源用户名
                        , avatar: res.mine.avatar //消息来源用户头像
                        , fromid: res.mine.id
                        , type: res.to.type //聊天窗口来源类型，从发送消息传递的to里面获取
                        , content: res.mine.content //消息内容
                        , toid: res.to.id
                        , appkey: laychat.app_key

                    };

                }


                laychat.jquery.ajax({
                    url: laychat.sendMessageUrl,
                    type: 'post',
                    data: newdata,
                    success: function (res) {

                        if (res) {
                            var res1 = laychat.jquery.parseJSON(res);
                            if (res1.code != 0) {
                                layui.layer.msg(res1.msg);
                            }
                        }
                    }
                });
            });

            var data = res;



            layim.on('tool(video)', function (insert, send, obj) {

                //console.log(data.mine.id);

                if (obj.data.type == 'friend') {

                    var times = (new Date()).valueOf();

                    laychat.jquery.ajax({
                        url: server_host+'/chat/index/apply',
                        type: 'post',
                        data: {
                            id: obj.data.id,
                            appkey: laychat.app_key,
                            channel: times,
                            name: laychat.mine.username,
                            avatar: laychat.mine.avatar,
                            mine: laychat.mine.id
                        },
                        success: function (res) {
                            if (res) {
                                layui.use('layer', function () {
                                    layer = layui.layer;
                                    layer.msg(res, {icon: 2});
                                });
                            }
                        }
                    });

                    var falg = window.location.protocol;

                    var iWidth = 400;  // 窗口宽度
                    var iHeight = 300; // 窗口高度
                    var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
                    var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;

                    win = window.open("https://rtc.laychat.net/call/" + times, "_blank", "toolbar=no,directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft + ",alwaysRaised=yes");

                } else {
                    layui.use('layer', function () {
                        layer = layui.layer;
                        layer.msg('群聊暂时不支持视频通话！');
                    });

                }

            });


            //监听自定义工具栏点击，以添加代码为例
            layim.on('tool(voice)', function (insert, send, obj) {

                //音频先加载
                var audio_context;
                var recorder;
                var wavBlob;
                //创建音频
                try {
                    // webkit shim
                    window.AudioContext = window.AudioContext || window.webkitAudioContext;
                    navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia || navigator.mediaDevices.getUserMedia;
                    window.URL = window.URL || window.webkitURL;

                    audio_context = new AudioContext;

                    if (!navigator.getUserMedia) {
                        console.log('语音创建失败');
                    }
                    ;
                } catch (e) {
                    console.log(e);
                    return;
                }
                navigator.getUserMedia({audio: true}, function (stream) {
                    var input = audio_context.createMediaStreamSource(stream);
                    recorder = new Recorder(input);

                    var falg = window.location.protocol;
                    if (falg == 'https:') {
                        recorder && recorder.record();

                        //示范一个公告层
                        layui.use(['jquery', 'layer'], function () {
                            var layer = layui.layer;

                            layer.msg('录音中...', {
                                icon: 16
                                , shade: 0.01
                                , skin: 'layui-layer-lan demo-class'
                                , time: 0 //20s后自动关闭
                                , btn: ['发送', '取消']
                                , yes: function (index, layero) {
                                    //按钮【按钮一】的回调
                                    recorder && recorder.stop();
                                    recorder && recorder.exportWAV(function (blob) {
                                        wavBlob = blob;
                                        var fd = new FormData();
                                        var wavName = encodeURIComponent('audio_recording_' + new Date().getTime() + '.wav');
                                        fd.append('wavName', wavName);
                                        fd.append('file', wavBlob);

                                        var xhr = new XMLHttpRequest();
                                        xhr.onreadystatechange = function () {
                                            if (xhr.readyState == 4 && xhr.status == 200) {
                                                jsonObject = JSON.parse(xhr.responseText);
                                                voicemessage = "audio[" + jsonObject.data.src + "]";
                                                insert(voicemessage);
                                                send();
                                            }
                                        };
                                        xhr.open('POST', laychat.uploadVoiceUrl);
                                        xhr.send(fd);
                                    });
                                    recorder.clear();
                                    layer.close(index);
                                }
                                , btn2: function (index, layero) {
                                    //按钮【按钮二】的回调
                                    recorder && recorder.stop();
                                    recorder.clear();
                                    audio_context.close();
                                    layer.close(index);
                                }
                            });

                        });
                    } else {
                        layui.use('layer', function () {
                            var layer = layui.layer;
                            layer.msg('音频输入只支持https协议！');
                        });
                    }


                }, function (e) {
                    layui.use('layer', function () {
                        var layer = layui.layer;
                        layer.msg('音频输入只支持https协议！');
                    });
                });


            });

            if (laychat.friendList === false ) {
                laychat.enableFriend = false;
            }

            if (laychat.groupList === false ) {
                laychat.enableGroup = false;
            }

            if (laychat.enableAudio == false && laychat.enableVideo == false) {
                var tooldata = '';
            }

            if (laychat.enableAudio == true && laychat.enableVideo == false) {
                var tooldata = [{alias: 'voice', title: '音频', icon: '&#xe688;'}];
            }

            if (laychat.enableAudio == false && laychat.enableVideo == true) {
                var tooldata = [{alias: 'video', title: '视频', icon: '&#xe6ed;'}];
            }

            if (laychat.enableAudio == true && laychat.enableVideo == true) {
                var tooldata = [{alias: 'video', title: '视频', icon: '&#xe6ed;'}, {
                    alias: 'voice',
                    title: '音频',
                    icon: '&#xe688;'
                }];
            }

            if(laychat.uploadImageUrl == false){
                var imgdata = false;
            }else{
                var imgdata ={
                    url:laychat.uploadImageUrl
                }
            }

            if(laychat.uploadFileUrl == false){
                var filedata =false;
            }else{
                var filedata =false;
                /*
                 隐藏文件上传入口
                 var filedata={
                 url:laychat.uploadFileUrl
                 }
                 */
            }

            layui.layim.config({

                //初始化接口
                init: data
                , tool: tooldata
                // 上传图片
                , uploadImage: imgdata
                // 上传文件
                , uploadFile: filedata
                , isgroup: laychat.enableGroup
                , isfriend: laychat.enableFriend
                , isNewFriend:  laychat.enableNewFriend
                //聊天记录地址
                , chatLog: laychat.chatlog + data.mine.id + '/'+ laychat.app_key
                , copyright: true //是否授权
                , title: laychat.appName
                , min: laychat.setMin
                , brief: laychat.brief
                , right: laychat.right
                , isAudio:laychat.isAudio
                , isVideo:laychat.isVideo
                , minRight: laychat.minRight
                , initSkin: laychat.initSkin
                , voice:laychat.voice
                , notice: laychat.notice
                , maxLength: laychat.maxLength
                , skin: laychat.skin
                , members: {
                    url: laychat.membersUrl
                }
            });
            layui.layim.chat(laychat.to);
        });
    }
}