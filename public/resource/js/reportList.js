/**
 * Created by 刘丹 on 2017/12/11.
 */

define (['doT', 'text!temp/reportList_template_tpl.html', 'css!style/home.css','ckfinder','ckfinderStart','pagination','bootstrapJs'], function (doT, template) {
    reportList = {
        pageNo: 1, /*第几页*/
        pageSize: 10, /*每页显示多少条*/
        id : '',
        house_id:'',
        type:'',
        valueCurrent:'',
        ajaxObj:'',
        stopstatus:true,
        ldHtml: $('.phone_list'),
        boxphoto:'',
        init: function () {
            //初始化dot
            $ ("body").append (template);
            reportList.getList ();
            reportList.event ();
        },
        event: function () {

        },

        getList: function (pageNo) {
            reportList.pageNo   = pageNo;
            var params    = {};
            params.pageNo   = reportList.pageNo;
            params.pageSize = reportList.pageSize;
            $.ajax ({
                url: '/index/reportListAttache/0',//获取列表
                type: 'GET',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('reportList_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#reportList_list").html (doTtmpl (data.data.list));

                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: reportList.pageSize,
                        onClick: function (el) {
                            reportList.getList (el.num.current);
                        }
                    });
                }
            });
        }

    };
    return reportList;
});