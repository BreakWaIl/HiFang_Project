define (['doT', 'text!temp/agent_template_tpl.html', 'css!style/home.css','pagination','bootstrapJs'], function (doT, template) {
   var agent={
        pageNo:1,
        pageSize:15,
        init:function () {
            //初始化dot
            $("body").append(template);
            agent.getList();
            agent.event();
        },
        event:function () {
            $('#search').click(function (pageNo) {
                 agent.getList(1);
            });
            $("#reset").click(function () {//重置
                document.getElementById("form_search").reset();
            });

            $ (document).delegate (".edit", "click", function () {//点击编辑
                agent.house_id = $ (this).attr ("data-id");
                agent.Edit_add();
                agent.Edit();
            });
            $ (document).delegate (".submit_edit", "click", function () {//提交编辑
                agent.Submit_edit();
                agent.getList();
            });
            $ (document).delegate (".edit_add", "click", function () {//新增
                agent.Edit_add();
            });
            $ (document).delegate (".User_add", "click", function () {//点击变更
                    var vv='';
                    var _idsv='';
                    $("input[name=ids]:checked").each(function (i) {
                        vv+= ','+$(this).val();
                        _idsv= vv.substring(1);
                    });
                    if(_idsv=="0"||_idsv==""){
                        alert("你还没有选择");
                    }else {
                        agent.User_add();
                    }
            });
            $ (document).delegate (".submit_user", "click", function () {//提交变更
                agent.Submit_user();
                agent.getList();
            });
            $ (document).delegate (".is_show", "click", function () {//点击禁用
                if (!confirm('是否继续？')) {
                    return ;
                }
                agent.id = $ (this).attr ("data-id");
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
                    'url' : '/index/updateStatus',
                    data: {"ids":agent.id,"status":params.type},
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
       Submit_user:function(){//提交变更的信息
           var v='';
           var _ids='';
           $("input[name=ids]:checked").each(function (i) {
               v+= ','+$(this).val();
               _ids= v.substring(1);
           })
          var group_id=$("#User_add").val();
           $.ajax({
               'type': 'POST',
               'url' : '/index/updateRole',
               data:{'ids':_ids,'group_id':group_id},
               dataType: "json",
               success: function(data){
                   if(data.code==200){
                   }else{
                       alert("重复提交");
                   }
               }
           });


       },
       User_add:function(){//获取变更角色

               $.ajax({
                   url: '/index/getAuth2',
                   type: 'GET',
                   data:{},
                   async: true,
                   dataType: 'json',
                   success: function (data) {
                       var User_add="";
                       $.each(data.data.list,function(i,item){
                           User_add+='<option value="'+item.id+'">'+item.title+'</option>';
                       });
                       $("#User_add").html(User_add);

                   }
               });

       },

       Edit_add:function(){
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
       },
       Edit:function(){//获取
           $.ajax({
               'type': 'GET',
               'url' : '/index/saveAgent',//获取编辑数据
               data: {"id":agent.house_id},
               dataType: "json",
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
           });
       },
       Submit_edit:function(){//提交编辑的信息
           var par={}
           par.id= agent.house_id;
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
               'type': 'POST',
               'url' : '/index/saveAgent',
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
            agent.pageNo =pageNo;
            var params ={};
            params.pageNo =agent.pageNo;
            params.pageSize=agent.pageSize;
            params.search = $("input[name='search']").val();
            params.groupname = $("input[name='groupname']").val();
            params.store_name = $("input[name='store_name']").val();
            $.ajax({
                url: '/index/AgentList.html',
                type: 'GET',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp=document.getElementById('agent_tpl').innerHTML;
                    var doTempl=doT.template(temp);
                    $("#agentlist").html(doTempl(data.data.list));
                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: agent.pageSize,
                        onClick: function (el) {
                            agent.getList (el.num.current);
                        }
                    });
                }
            })
        }

    }
    return agent;
});