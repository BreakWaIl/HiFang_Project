define (['doT', 'text!temp/auth_template_tpl.html', 'css!style/home.css','pagination','bootstrapJs'], function (doT, template) {
    auth = {
        pageNo: 1, /*第几页*/
        pageSize: 10, /*每页显示多少条*/
        init: function () {
            //初始化dot
            $ ("body").append (template);
            auth.getList ();
            auth.event ();
        },
        event: function () {
            $ (document).delegate ("#search", "click", function () {//点击编辑
                auth.getList(1);
            });
            $ (document).delegate (".edit", "click", function () {//点击编辑
                auth.house_id = $ (this).attr ("data-id");
                auth.Edit();
            });
            $ (document).delegate (".submit_edit", "click", function () {//提交编辑
                auth.Submit_edit();
                auth.getList();
            });
            $ (document).delegate (".power", "click", function () {//点击权限分配
                auth.id = $ (this).attr ("data-id");
                auth.Power();
            });
            $ (document).delegate (".submit_power", "click", function () {//点击提交权限
                auth.Submit_power();
            });
            $ (document).delegate (".is_show", "click", function () {//点击禁用
                if (!confirm('是否继续？')) {
                    return ;
                }
                auth.id = $ (this).attr ("data-id");
                var params ={

                };
                params.id = $ (this).attr ("data-id");
                var str = $.trim($(this).html());
                if (str === "正常") {
                    params.type = 1;
                    $(this).html('冻结');
                } else if (str === "冻结"){
                    params.type = 0;
                    $(this).html('正常');
                }else{
                    params.type = 2;
                }
                $.ajax({//禁用
                    'type': 'POST',
                    'url' : '/index/updateGroup',
                    data: {"ids":auth.id,"status":params.type},
                    dataType: "json",
                    success: function(data){
                        if(data.code == 200){
                            if (data.data) {
                            }
                        } else {
                            alert("禁用失败!")
                        }
                    }
                });

            });

        },
        Edit:function(){//获取
            $.ajax({
                'type': 'GET',
                'url' : '/index/addAuth',//获取编辑数据
                data: {"id":auth.house_id},
                dataType: "json",
                success: function(data){
                        if (data.data) {
                            $("input[name = id]").val(data.data.id);
                            $("input[name = title]").val(data.data.title);
                            $("#description").val(data.data.description);
                        }
                     else {
                        alert('获取失败！');
                    }
                }
            });
        },
        Submit_edit:function(){//提交编辑的信息
            var par={};
            par.id= auth.house_id;
            par.title=$("input[name =title]").val();
            par.description=$("textarea[name =description]").val();
            $.ajax({
                'type': 'POST',
                'url' : '/index/addAuth',
                data:par,
                dataType: "json",
                success: function(data){
                    if(data.code==200){

                    }else{
                        alert(data.msg);
                    }
                }
            });
        },
        Power:function(){//获取的信息
            $.ajax({
                'type': 'GET',
                'url' : '/index/accessLook',
                data:{
                    id:auth.id
                },
                dataType: "json",
                success: function(data){
                    var temp=document.getElementById('access_tpl').innerHTML;
                    var doTempl=doT.template(temp);
                    $("#access_box").html(doTempl(data.data.class));
                }
            });
        },
        Submit_power:function(){//提交权限的信息
            var v='';
            $("input[name=rules]:checked").each(function (i) {
                v+= $(this).val()+',';
            })
            $.ajax({
                'type': 'POST',
                'url' : '/index/updateAccess',
                data:{'rules':v,'id':auth.id},
                dataType: "json",
                success: function(data){
                    if(data.code==200){
                    }else{
                        alert(data.msg);
                    }
                }
            });
        },

        getList: function (pageNo) {
            auth.pageNo   = pageNo;
            var params    = {};
            params.pageNo   = auth.pageNo;
            params.pageSize = auth.pageSize;
            params.search = $("input[name='search']").val();
            $.ajax ({
                url: '/index/getAuth.html',//列表数据
                type: 'GET',
                async: true, 
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('auth_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#auth_list").html (doTtmpl (data.data.list));
                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: auth.pageSize,
                        onClick: function (el) {
                            auth.getList (el.num.current);
                        }
                    });
                }
            });
        }
    };
    return auth;
});