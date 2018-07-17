define (['doT', 'text!temp/auth_rule_index_template_tpl.html', 'css!style/home.css','pagination','bootstrapJs'], function (doT, template) {
authRule={
    pageNo:1,
    pageSize:15,
    init:function () {
       //初始化dot
       $("body").append(template);
       authRule.getList();
       authRule.event();
    },
    event:function () {
        $ (document).delegate ("#search", "click", function () {//点击编辑
            authRule.getList(1);
        });
        $ (document).delegate (".edit", "click", function () {//点击编辑
            authRule.house_id = $ (this).attr ("data-id");
            authRule.Edid_add();
            authRule.Edit();
        });
        $ (document).delegate (".submit_edit", "click", function () {//提交编辑
            authRule.Submit_edit();
            authRule.getList();
        });
        $ (document).delegate (".edit_add", "click", function () {//新增
            document.getElementById("form-horizontal").reset();
            authRule.Edid_add();
        });
        $ (document).delegate (".is_show", "click", function () {//点击禁用
            if (!confirm('是否继续？')) {
                return ;
            }
            authRule.id = $ (this).attr ("data-id");
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
                'url' : '/index/updateRoleStatus',
                data: {"ids":authRule.id,"status":params.type},
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
    Edid_add:function(){
        $.ajax({
            url: '/index/classList/type/1',//获取后台菜单
            type: 'GET',
            async: true,
            cache:false,
            dataType: 'json',
            success: function (data) {
                var temp=document.getElementById('auth_class_tpl').innerHTML;
                var doTempl=doT.template(temp);
                $("#pid").html(doTempl(data.data));//赋值
            }
        });
    },
    Edit:function(){//获取
        $.ajax({
            'type': 'GET',
            'url' : '/index/updateAuthRule',//获取编辑数据
            data: {"id":authRule.house_id},
            cache:false,
            dataType: "json",
            success: function (data) {
                $("input[name = id]").val(data.data.id);
                $("input[name = title]").val(data.data.title);
                $("input[name = name]").val(data.data.name);
                $("input[name = sort]").val(data.data.sort);
                $("#pid").val(data.data.pid);
                if(data.data.is_menu==0){
                    $("#is_menu2").attr('checked',true);
                }else{
                    $("#is_menu1").attr('checked',true);
                }
            }
        });
    },
    Submit_edit:function(){//提交编辑的信息
        var par={}
        par.id= authRule.house_id;
        par.title= $("input[name = title]").val();
        par.name= $("input[name = name]").val();
        par.sort= $("input[name = sort]").val();
        par.pid=$("#pid").val();
        par.is_menu=$("input[name =is_menu]:checked").val();
        par.search = $("input[name='search']").val();
        $.ajax({
            'type': 'POST',
            'url' : '/index/updateAuthRule',
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
    getList:function(pageNo){
        authRule.pageNo =pageNo;
        var params ={};
        params.pageNo =authRule.pageNo;
        params.pageSize=authRule.pageSize;
        params.search = $("input[name='search']").val();
        $.ajax({
            url: '/index/AuthRulelist.html',
            type: 'GET',
            async: true,
            data: params,
            dataType: 'json',
            success: function (data) {
            var temp=document.getElementById('auth_rule_index_tpl').innerHTML;
            var doTempl=doT.template(temp);
            $("#auth_rule_list").html(doTempl(data.data.list));
                /*分页代码*/
                $ ("#pagediv").pagination ({
                    length: data.data.total,
                    current: pageNo,
                    every: authRule.pageSize,
                    onClick: function (el) {
                        authRule.getList (el.num.current);
                    }
                });
            }
        })
    }

}
    return authRule;
});