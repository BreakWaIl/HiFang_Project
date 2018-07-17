define (['doT', 'text!temp/get_auth_list_template_tpl.html', 'css!style/home.css','bootstrapJs'], function (doT, template) {
    aagent={
        init:function () {
            //初始化dot
            $("body").append(template);
            aagent.getList();
            aagent.event();
        },
        event:function () {

            $ ("#submit").click(function () {
                var par={}
                par.id= $("input[name = id]").val();
                par.name= $("input[name = name]").val();
                par.store_id= $("input[name = store_id]").val();
                par.phone= $("input[name = phone]").val();
                if(par.phone==''){
                    alert('手机号必填！');
                    return false;
                }
                par.admin_off= $("#admin_off").val();
                par.district_id=$('#district_id').val();
                par.sex=$("input[name =sex]:checked").val();
                par.remarks=$("#remarks").val();
                par.auth_group_id=$("#auth_group_id").val();
                par.status=$("#status").val();
                $.ajax({
                    url: '/index/saveAgent',
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
                url: '/index/getAuth2',
                type: 'GET',
                async: true,
                dataType: 'json',
                success: function (data) {
                    var temp=document.getElementById('get_auth_list').innerHTML;
                    var doTempl=doT.template(temp);
                    $("#auth_group_id").html(doTempl(data.data.list));//赋值
                }
            });
            var id=  getUrlParam('id');
            //判断是否有id参数
            if(!id){
                return false;
            }
            $.ajax({
                url: '/index/saveAgent/'+id,
                type: 'post',
                async: true,
                dataType: 'json',
                success: function (data) {
                    $("input[name = id]").val(data.data.id);
                    $("input[name = phone]").val(data.data.phone);
                    $("input[name = name]").val(data.data.name);
                    $("input[name = store_id]").val(data.data.store_id);
                    $("#admin_off").val(data.data.admin_off);
                    $("#remarks").val(data.data.remarks);
                    $("#status").val(data.data.status);
                    $("#auth_group_id").val(data.data.auth_group_id);
                    if(data.data.sex=='0'){
                        $("#sex0").attr('checked',true);
                    }else if(data.data.sex=='1'){
                        $("#sex1").attr('checked',true);
                    }else{
                        $("#sex2").attr('checked',true);

                    }
                }
            })

        }

    }
    return aagent;
});

