define (['doT', 'text!temp/user_template_tpl.html','ckfinder','ckfinderStart', 'css!style/home.css',"datetimepicker",'pagination','bootstrapJs'], function (doT, template) {
    var user = {
        pageNo: 1, /*第几页*/
        pageSize: 15, /*每页显示多少条*/
        user_id : 0,
        urls: '',
        agent_id2 : 0,
        init: function () {
            //初始化dot
            $ ("body").append (template);
            user.getList ();
            user.event ();
            //时间控件初始化
         /*   $('#datetimepicker').datetimepicker({
                format: 'yyyy-MM-dd',
                language: 'zh-CN',
                pickTime: false
            }).on('changeDate',function(){
                $(this).datetimepicker('hide');
            });*/
        },
        event: function () {
            $ (".Bannertu").click (function () {
                BrowseServer ('cover_image');
            });
            $("#search").click(function(){
                user.getList(1);
            });

            $("#reset").click(function () {
                document.getElementById("form_search").reset();
            });


            $("#close").click(function () {
                document.getElementById("add_user_form").reset();
            });

            $("#confirm_delete").click(function(){
                var params = {};
                params.id     = $ ("#delete_id").val ();
                params.status = 1;
                if(!params.id || params.id == null){
                    alert ("要删除的id不能为空");
                    return false;
                }
                user.delete_user(params);
            });
            $ (document).delegate (".genj_ure", "click", function () {
                user.user_id = $ (this).attr ("data-id");
            });
            $ (document).delegate ("#add_user", "click", function () {//新增客户
                user.user_id = $ (this).attr ("data-id");
                user.add_user();
            });
            $ (document).delegate ("#edit_add", "click", function () {
                user.edit_add();
            });
            $ (document).delegate (".caozuo", "click", function () {//点击操作跟进详情
                user.user_id = $ (this).attr ("data-id");
                user.Caozuo();
            });
            $ (document).on ("input","#set_father_id3", function () {//手机号搜索客方
                if($("#set_father_id3").val()==''){
                    $(".user-ul").html('');
                }else{
                    user.search_phone();
                }
            });
            $ (document).on ("input","#cus_fang", function () {//手机号搜索客方2
                if($("#cus_fang").val()==''){
                    $(".user-ul2").html('');
                }else{
                    user.search_phone2();
                }
            });
            $ (document).delegate (".addphone", "click", function () {//list消失
                user.addphone(this);
            });
            $ (document).delegate (".addphone2", "click", function () {//list2消失
                user.addphone2(this);
            });
            $ (document).delegate (".submit_edit", "click", function () {//提交
                user.Submit_follow();
            });

        },
        addphone:function(obj){
            var user_ht=$(obj).html();
            $("#set_father_id3").val(user_ht);
            $(".user-ul").html('');
            user.agent_id = $ (obj).attr ("data-id");

        },
        addphone2:function(obj){
            var user_ht=$(obj).html();
            $("#cus_fang").val(user_ht);
            $(".user-ul2").html('');
            user.agent_id2 = $ (obj).attr ("data-id");
        },
        search_phone:function(){//手机号
            $.ajax ({
                url: '/index/select_by_phone',
                type: 'POST',
                async: true,
                data: {
                    "phone":$("#set_father_id3").val()
                },
                dataType: 'json',
                success: function (data) {
                    if (data.code == 200) {
                        var user_ul = "";
                        $.each(data.data, function(i,item) {
                            user_ul+='<li class="addphone" data-id="'+item.id+'">'+item.id+'-'+item.realname+'-'+item.phone+'</li>';
                        });
                        $(".user-ul").html(user_ul);

                    } else {
                        alert(data.msg);
                    }

                }
            });
        },
        search_phone2:function(){//手机号
            $.ajax ({
                url: '/index/getBroker_new',
                type: 'GET',
                async: true,
                data: {
                    "phone":$("#cus_fang").val()
                },
                dataType: 'json',
                success: function (data) {
                    if (data.code == 200) {
                        var user_ul2 = "";
                        $.each(data.data, function(i,item) {
                            user_ul2+='<li class="addphone2" data-id="'+item.id+'">'+item.id+'-'+item.name+'-'+item.phone+'</li>';
                        });
                        $(".user-ul2").html(user_ul2);
                    } else {
                        alert(data.msg);
                    }

                }
            });
        },
        Submit_follow: function() { //提交
            var params = {};
            params.id = user.user_id;
            params.user_nick = $("#cus_name").val();
            params.user_phone = $("#cus_phone").html()
            params.agents_id = user.agent_id2;
            params.sex = $("#sex").val();

            $.ajax({
                'type': 'POST',
                'url': '/index/pcEditClient',
                data: params,
                dataType: "json",
                success: function(data) {
                    if(data.code == 200) {
                        user.getList(1);
                    } else {
                        alert(data.msg)
                    }
                }
            });
        },
        edit_add : function () {//提交跟进
            $.ajax ({
                url: '/index/pcAddFollow',
                type: 'POST',
                async: true,
                data: {
                    "user_id":user.user_id,
                    "content":$("#genj_text").val()
                },
                dataType: 'json',
                success: function (data) {
                    if (data.code == 200) {
                    } else {
                        alert(data.msg);
                    }

                }
            });
        },
        Caozuo:function(){//获取跟进详情的数据
            $.ajax({
                'type': 'GET',
                'url' : '/index/useraction_search',
                data: {"user_id":user.user_id},
                dataType: "json",
                success: function(data){
                    if(data.code == 200){
                        if (data.data) {
                            $("#cus_id").html(data.data.user_info.user_id);//客户编号
                            $("#cus_name").val(data.data.user_info.user_nick);//姓名
                            $("#sex").val(data.data.user_info.sex);//性别
                            $("#cus_phone").html(data.data.user_info.user_phone);//电话
                            $("#cus_date").html(data.data.user_info.create_time);//上传时间
                            $("#cus_fang").val(data.data.user_info.agentinfo);//客方
                            var caozuo_table="";
                            $.each(data['data']['user_date'], function(i, item) {
                                caozuo_table +='<tr><td>'+item.content+'</td><td>'+item.agentinfo+'</td><td>'+item.create_time+'</td></tr>';
                            });
                            $("#caozuo_table").html(caozuo_table);
                        }
                    } else {
                        alert('获取失败！');
                    }
                }
            });
        },
        getList: function (pageNo) {
            user.pageNo   = pageNo;
            var params    = {};
            params.phone  = $("input[name='phone']").val();
            params.invite_phone  = $("input[name='invite_phone']").val();
            params.invite = $("input[name='invite']").val();
            params.start_date = $("#start_date").val();
            params.end_date = $("#end_date").val();
            params.follow_start = $("#follow_start").val();
            params.follow_end = $("#follow_end").val();
            params.login_status = $("select[name=login_status]").val();
            params.activate = $("select[name=activate]").val();
            params.pageNo = user.pageNo;
            params.pageSize = user.pageSize;

            $.ajax ({
                url: '/index/usersList',
                type: 'GET',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('user_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#users_list").html (doTtmpl (data.data.list));

                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: user.pageSize,
                        onClick: function (el) {
                            user.getList (el.num.current);
                        }
                    });
                }
            });
        },
        add_user : function () {
            var params = {};
            params.user_nick    = $("#add_user_form input[name='user_nick']").val();
            params.user_phone  = $("#add_user_form input[name='user_phone']").val();
            params.agent_id  = $("#add_user_form input[name='agent_id']").val();//客方
            params.sex = $("#user_sex option:selected").val();
            params.type = 'add';

            if (params.realname == '') {
                alert('姓名不能为空');
                $("input[name='realname']").focus();
                return ;
            }
            if (params.user_phone == '') {
                alert('手机号不能为空');
                $("input[name='user_phone']").focus();
                return ;
            }
            if (params.pwd == '') {
                alert('密码不能为空');
                $("input[name='pwd']").focus();
                return ;
            }

            $.ajax ({
                url: '/index/pcEditClient',
                type: 'POST',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    if (data.code == 200) {
                        user.getList(1);
                        document.getElementById("add_user_form").reset();
                    } else {
                        alert(data.msg);
                    }
                }
            });
        },
        delete_user : function(params) {
            $.ajax ({
                url: '/index/del_user',
                type: 'POST',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    $ ("#modal-delete").modal ('hide');
                    if (data.code == "101") {
                        alert (data.msg);
                        return false;
                    }
                    user.getList (user.pageNo);
                }
            });
        }
    }
    return user;
});

function delete_user (obj) {
    $ ("#delete_id").val ($ (obj).attr ("data-id"));
}

function edit(obj) {
    var params = {}
    params.id = $(obj).attr ("data-id")
    $.ajax ({
        url: '/index/usersList',
        type: 'get',
        async: true,
        data: params,
        dataType: 'json',
        success: function (data) {
            $("#edit_user_form input[name='phone']").val(data.data.list[0].user_phone);
            $("#edit_user_form input[name='password']").val(data.data.list[0].user_pswd);
            $("#invite_name").html(data.data.list[0].realname);
            $("#invite_phone").html(data.data.list[0].phone);
        }
    });

    $ ("#edit_id").val ($ (obj).attr ("data-id"));
}