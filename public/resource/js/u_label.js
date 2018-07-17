define (['doT', 'text!temp/u_label_template_tpl.html', 'css!style/home.css','pagination','bootstrapJs'], function (doT, template) {
    u_label = {
        pageNo: 1, /*第几页*/
        pageSize: 10, /*每页显示多少条*/
        pageNum:10,
        init: function () {
            //初始化dot
            $ ("body").append (template);
            u_label.getList ();
            u_label.event ();
        },
        event: function () {
            $ (document).delegate (".edit", "click", function () {//点击编辑
                u_label.house_id = $ (this).attr ("data-id");
                u_label.Edit();
            });
            $ (document).delegate (".submit_edit", "click", function () {//提交编辑
                u_label.Submit_edit();
                u_label.getList();
            });

        },
        Edit:function(){//获取
            $.ajax({
                'type': 'GET',
                'url' : '/index/updateULabel',//获取编辑数据
                data: {"id":u_label.house_id},
                dataType: "json",
                success: function(data){
                    if (data.data) {
                        $("input[name = title]").val(data.data.name);
                    }
                    else {
                        alert('获取失败！');
                    }
                }
            });
        },
        Submit_edit:function(){//提交编辑的信息
            var par={};
            par.id= u_label.house_id;
            par.name=$("input[name =title]").val();
            $.ajax({
                'type': 'POST',
                'url' : '/index/updateULabel',
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

        getList: function (pageNo) {
            u_label.pageNo   = pageNo;
            var params    = {};
            params.pageNo   = u_label.pageNo;
            params.pageSize = u_label.pageSize;
            $.ajax ({
                url: '/index/getULabelsList',//列表数据
                type: 'GET',
                async: true, 
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('label_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#u_label_list").html (doTtmpl (data.data.list));
                    if(data.data.cz){
                        $.each(data.data.cz, function(i, item) {
                            var savetype=item.bt;
                            switch (savetype)
                            {
                                case "add":
                                    $(".edit_add").show();
                                    $(".edit").hide();
                                    break;
                                case "save":
                                    $(".edit").show();
                                    $(".edit_add").hide();
                                    break;

                            }
                        });
                    }else{
                        $(".edit_add").hide();
                        $(".edit").hide();

                    }


                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: u_label.pageSize,
                        onClick: function (el) {
                            u_label.getList (el.num.current);
                        }
                    });
                }
            });
        }
    };
    return u_label;
});