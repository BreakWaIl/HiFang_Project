define (['doT', 'text!temp/auth_rule_box_template_tpl.html', 'css!style/home.css','bootstrapJs'], function (doT, template) {
    authRule={
        init:function () {
            //初始化dot
            $("body").append(template);
            authRule.getList();
            authRule.event();
        },
        event:function () {

            $ ("#submit").click(function () {
               var par={}
               par.id= $("input[name = id]").val();
               par.title= $("input[name = title]").val();
               par.name= $("input[name = name]").val();
               par.sort= $("input[name = sort]").val();
               par.pid=$("#pid").val();
               par.is_menu=$("input[name =is_menu]:checked").val();
                $.ajax({
                    url: '/index/updateAuthRule',
                    data:par,
                    type: 'post',
                    async: true,
                    dataType: 'json',
                    success: function (data) {
                        alert(data.msg);
                        console.log(data);
                    }

                });

            })


        },
        getList:function(){
            $.ajax({
                url: '/index/classList/type/1',
                type: 'GET',
                async: true,
                dataType: 'json',
                success: function (data) {
                    var temp=document.getElementById('auth_class_tpl').innerHTML;
                    var doTempl=doT.template(temp);
                    $("#pid").html(doTempl(data.data));//赋值
                }
            });
            var id=  getUrlParam('id');
            $.ajax({
                url: '/index/updateAuthRule/'+id,
                type: 'post',
                async: true,
                dataType: 'json',
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
            var id=  getUrlParam('id');
            $.ajax({
                url: '/index/updateAuthRule/group_id/'+id,
                type: 'post',
                async: true,
                dataType: 'json',
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
            })

        }

    }
    return authRule;
});
