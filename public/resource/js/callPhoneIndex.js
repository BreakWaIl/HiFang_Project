/**
 * Created by 刘丹 on 2018/3/1.
 */

define (['doT', 'text!temp/callPhone_template_tpl.html', 'css!style/home.css','ckfinder','ckfinderStart','pagination','bootstrapJs'], function (doT, template) {
    callphone = {
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
            callphone.getList ();
            callphone.event ();
        },
        event: function () {
            $("#search").click(function () {
                callphone.getList(1);
            });

            $("#reset").click(function () {//重置
                document.getElementById("form_search").reset();
            });

    },
        getList: function (pageNo) {
            callphone.pageNo   = pageNo;
            var params    = {};
            params.pageNo   = callphone.pageNo;
            params.pageSize = callphone.pageSize;
            params.call_name  = $('#industry_type') .val();//拨打人姓名
            params.call_phone  = $('#dish') .val();//拨打人手机号
            params.user_nick  = $('id') .val();//被拨打人姓名
            params.client_phone  = $('#dish-phone') .val();//拨打人手机号
            params.start_date  = $('#start_date') .val();//时间1
            params.end_date  = $('#end_date') .val();//时间2

            $.ajax ({
                url: '/index/callLog.html',//获取列表
                type: 'GET',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('callPhone_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#callPhone_list").html (doTtmpl (data.data.list));

                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: callphone.pageSize,
                        onClick: function (el) {
                            callphone.getList (el.num.current);
                        }
                    });
                }
            });
        }
    };
    return callphone;
});