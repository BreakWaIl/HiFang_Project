define (['doT', 'text!temp/transfer_template_tpl.html', 'css!style/home.css','paginationStart'], function (doT, template) {
     user = {
        pageNo: 1, /*第几页*/
        pageSize: 10, /*每页显示多少条*/

        urls: '',
        init: function () {

            ;(function($){
                    $.fn.datetimepicker.dates['zh-CN'] = {
                    days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
                    daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
                    daysMin:  ["日", "一", "二", "三", "四", "五", "六", "日"],
                    months: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"],
                    monthsShort: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"],
                    today: "今日",
                    suffix: [],
                    meridiem: ["am", "pm"],
                    weekStart: 1,

                };
            }(jQuery));

            $('.form_datetime').datetimepicker({
                //language:  'fr',
                weekStart: 1,
                todayBtn:  1,
                autoclose: 1,
                todayHighlight: 1,
                startView: 2,
                forceParse: 0,
                showMeridian: 1
            });
            $('.form_date').datetimepicker({
                language:  'zh-CN',
                weekStart: 1,
                todayBtn:  1,
                autoclose: 1,
                todayHighlight: 1,
                startView: 2,
                minView: 2,
                forceParse: 0
            });
            $('.form_time').datetimepicker({
                language:  'zh-CN',
                weekStart: 1,
                todayBtn:  1,
                autoclose: 1,
                todayHighlight: 1,
                startView: 1,
                minView: 0,
                maxView: 1,
                forceParse: 0
            });

            //初始化dot
            $ ("body").append (template);
            user.getList ();
            user.event ();
        },
        event: function () {
            $("#form_search_reset").click(function () {
                document.getElementById("form_search").reset();
            });
            $("#search").click(function () {
                user.getList(1);
            });

            $("#submit_follow").click(function () {
                user.addFollow();
            });
            $('#datetimepicker').datetimepicker({
                format: 'yyyy-MM-dd',
                language: 'zh-CN',
                pickTime: false
            }).on('changeDate',function(){
                $(this).datetimepicker('hide');
            });

        },
        getList: function (pageNo) {
            user.pageNo   = pageNo;
            var params    = {};
            params.start_date   = $("#start_date").val();
            params.end_date     = $("#end_date").val();
            params.name   = $("#name").val();
            params.phone  = $("#phone").val();
            params.shop_name   = $("#shop_name").val();
            params.pageNo   = user.pageNo;
            params.pageSize = user.pageSize;

            $.ajax ({
                url: '/index/get_transfer',
                type: 'GET',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('transfer_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#sublet_list").html (doTtmpl (data.data.list));

                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        coping:true,
                        every: user.pageSize,
                        onClick: function (el) {
                            user.getList (el.num.current);
                        }
                    });
                /*    pagination_pages = Math.ceil(data.data.total/user.pageSize);
                    pagination_totals = data.data.total;
                    addpage(user.getList);*/
                }
            });
        },
         addFollow : function () {
             var params = {};
             params.type = 1;
             params.id   = id;
             params.content = $("#content").val();

             $.ajax ({
                 url: '/index/addFollow',
                 type: 'POST',
                 async: true,
                 data: params,
                 dataType: 'json',
                 success: function (data) {
                     if (data.code == 200) {
                         $ ("#modal-process").modal ('hide');
                     } else {
                         alert(data.msg);
                     }
                 }
             });
         }
    };
    return user;
});

/**
 * 编辑上架商铺
 * @param obj
 */
function edit(obj) {
    if (!confirm('是否继续')) {
        return ;
    }
    var params = {};
    var arr = $(obj).attr ("data-id").split(',');
    params.id = arr[0];
    params.status = arr[1];
    if (params.status == 0) {
        params.status = 1;
    } else {
        params.status = 0;
    }

    $.ajax ({
        url: '/index/putAway',
        type: 'POST',
        async: true,
        data: params,
        dataType: 'json',
        success: function (data) {
            if (data.code == 200) {
                alert(data.msg);
                if (data.data.status == 0) {
                    $(obj).html('转为上架商铺');
                    $(obj).attr('class','btn1 btn-danger');
                    $(obj).attr('data-id',arr[0] +','+0);
                } else {
                    $(obj).removeAttr("onclick");
                    $(obj).html('已转为上架商铺');
                    $(obj).attr('class','btn1 btn-info');
                    $(obj).attr('data-id',arr[0] +','+data.data.status);
                }
            } else {
                alert(data.msg);
            }
        }
    });
}

var id;

function alertFollow(obj){
    id = $(obj).attr ("data-id");
    $("#content").val('');
    $.ajax ({
        url: '/index/followList',
        type: 'GET',
        async: true,
        data: {"id":id,"type":1},
        dataType: 'json',
        success: function (data) {
            if (data.code == 200) {
                var str = '';
                $.each(data.data, function (i,item) {
                    str += "<tr><td>"+item['content']+"</td><td>"+item['admin_name']+"</td><td>"+item['create_time']+"</td></tr>";
                    $("#list_follow").html(str);
                });
            } else {
                alert(data.msg);
            }
        }
    });

}