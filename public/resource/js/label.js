define (['doT', 'text!temp/label_template_tpl.html', 'css!style/home.css','pagination','bootstrapJs'], function (doT, template) {
    label = {
        pageNo: 1, /*第几页*/
        pageSize: 10, /*每页显示多少条*/
        pageNum:10,
        init: function () {
            //初始化dot
            $ ("body").append (template);
            label.getList ();
            label.event ();
        },
        event: function () {
            $ (document).delegate (".edit", "click", function () {//点击编辑
                label.house_id = $ (this).attr ("data-id");
                label.Edit();
            });
            $ (document).delegate (".submit_edit", "click", function () {//提交编辑
                label.Submit_edit();
                label.getList();
            });

        },
        Edit:function(){//获取
            $.ajax({
                'type': 'GET',
                'url' : '/index/labelEdit',//获取编辑数据
                data: {"id":label.house_id},
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
            par.id= label.house_id;
            par.name=$("input[name =title]").val();
            par.type="0";
            $.ajax({
                'type': 'POST',
                'url' : '/index/labelEdit',
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
            label.pageNo   = pageNo;
            var params    = {};
            params.pageNo   = label.pageNo;
            params.pageSize = label.pageSize;
            $.ajax ({
                url: '/index/getLabelsList',//列表数据
                type: 'GET',
                async: true, 
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('label_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#label_list").html (doTtmpl (data.data.list));
                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: label.pageSize,
                        onClick: function (el) {
                            label.getList (el.num.current);
                        }
                    });
                }
            });
        }
    };
    return label;
});