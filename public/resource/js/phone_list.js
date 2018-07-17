/**
 * Created by 刘丹 on 2018/3/1.
 */

define (['doT', 'text!temp/phonelist_template_tpl.html', 'css!style/home.css','ckfinder','ckfinderStart','pagination','bootstrapJs'], function (doT, template) {
    phonelist = {
        pageNo: 1, /*第几页*/
        pageSize: 10, /*每页显示多少条*/
        id : '',
        house_id:'',
        type:'',
        valueCurrent:'',
        ajaxObj:'',
        stopstatus:true,
        boxphoto:'',
        init: function () {
            //初始化dot
            $ ("body").append (template);
            phonelist.getList ();
            phonelist.event ();
        },
        event: function () {
            $("#search").click(function () {
                phonelist.getList(1);
            });

            $("#reset").click(function () {//重置
                document.getElementById("form_search").reset();
            });
            $ (document).delegate (".is_show", "click", function () {//绑定
                if (!confirm('是否继续？')) {
                    return ;
                }
                business.id = $ (this).attr ("data-id");
                var params ={

                };
                params.id = $ (this).attr ("data-id");
                var str = $.trim($(this).html());
                if (str === "绑定") {
                    params.type = 1;
                    $(this).html('已绑定');
                } else {
                    params.type = 0;
                    $(this).html('解绑');
                }
                $.ajax({//推荐至首页
                    'type': 'POST',
                    'url' : '/index/carefullyChosen',
                    data: {"houses_id":business.id},
                    dataType: "json",
                    success: function(data){
                        if(data.code == 200){
                            if (data.data) {
                            }
                        } else {
                            alert("推荐失败!")
                        }
                    }
                });

            });

    },
        getList: function (pageNo) {
            phonelist.pageNo   = pageNo;
            var params    = {};
            params.pageNo   = phonelist.pageNo;
            params.pageSize = phonelist.pageSize;
            params.phone_a  = $('#industry_type') .val();
            params.phone_b  = $('#dish') .val();

            $.ajax ({
                url: '/index/bindPhoneList',//获取列表
                type: 'GET',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('phonelist_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#phonelist_list").html (doTtmpl (data.data.list));

                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: phonelist.pageSize,
                        onClick: function (el) {
                            phonelist.getList (el.num.current);
                        }
                    });
                }
            });
        }
    };
    return phonelist;
});