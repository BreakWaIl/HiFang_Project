/**
 * Created by 刘丹 on 2018/3/1.
 */

define (['doT', 'text!temp/agentIndex_template_tpl.html', 'css!style/home.css','ckfinder','ckfinderStart','pagination','bootstrapJs'], function (doT, template) {
    agentIndex = {
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
            agentIndex.getList ();
            agentIndex.event ();
        },
        event: function () {
            $("#search").click(function () {
                agentIndex.getList(1);
            });

            $("#reset").click(function () {//重置
                document.getElementById("form_search").reset();
            });

        },
        getList: function (pageNo) {
            agentIndex.pageNo   = pageNo;
            var params    = {};
            params.pageNo   = agentIndex.pageNo;
            params.pageSize = agentIndex.pageSize;
            params.agents_name  = $('#industry_type') .val();//经纪人姓名
            params.phone  = $('#dish') .val();//经纪人手机号
            params.start_date  = $('#start_date') .val();//时间1
            params.end_date  = $('#end_date') .val();//时间2

            $.ajax ({
                url: '/index/callCollectList',//获取列表
                type: 'GET',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('agentIndex_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#agentIndex_list").html (doTtmpl (data.data.list));

                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: agentIndex.pageSize,
                        onClick: function (el) {
                            agentIndex.getList (el.num.current);
                        }
                    });
                }
            });
        }
    };
    return agentIndex;
});