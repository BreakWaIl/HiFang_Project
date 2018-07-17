define (['doT', 'text!temp/watch_template_tpl.html', 'css!style/home.css','pagination','bootstrapJs'], function (doT, template) {
    user = {
        pageNo: 1, /*第几页*/
        pageSize: 10, /*每页显示多少条*/
        store_id : '',
        agents_id : '',
        watch_id  : '',
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

            $ (document).delegate (".phone_jia", "click", function () {
                /*手机检索姓名*/
                var ldHtml = $('.phone_list');
                var stopstatus = true;
                var valueCurrent = '';
                var ajaxObj;
                $(function() {
                    $(document).on('input','.phone_jia', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        var _this = $(this);
                        _this.next().css("display","block");
                        valueCurrent = _this.val();
                        if(valueCurrent != ''){
                            resetLoad();
                            loadMain(valueCurrent,_this.next());
                        }else{
                            ldHtml.html('');
                            return false;
                        }

                    });

                });

                function resetLoad(){
                    if(ajaxObj){
                        ajaxObj.abort();
                    }
                    ldHtml.html('');
                    stopstatus = true;
                }
                function loadMain(phone, obj) {
                    ajaxObj=$.ajax({
                        type: "GET",
                        url: '/index/getBroker' ,
                        data: {
                            'phone': phone
                        },
                        timeout: 10000,
                        dataType: "json",
                        beforeSend: function() {
                        },
                        success: function(data) {

                            if(data.code === 200){
                                $("#agents_list").show();
                                var _html = '';
                                $.each(data.data, function(i,data) {
                                    _html += '<li class="addphone"><span class="id">'+data['id']
                                    +'-</span><span class="phone_name">'+data['name']
                                    +'</span><span class="phone_span">-</span><span class="phone-phone">'
                                    +data['phone']+'</span><span class="hidden store_id">'
                                    +data['store_id']+'</span></li>';
                                });
                                $("#agents_list").html(_html);
                            }
                        },
                        error: function() {

                        },
                        complete: function(xhr, textStatus) {
                            if(textStatus === "timeout") {
                                /*处理超时的逻辑*/
                                alert("请求超时");
                            }
                        }
                    });
                }
            });

            /*选择经纪人*/
            $ (document).delegate (".addphone", "click", function () {
                user.addphone($(this));
            });

            $ (document).delegate (".add_applies", "click", function () {
                user.watch_id =  $(this).attr ("data-id");
                $("input[name='phone']").val('');
            });   

            $ (document).delegate ("#submit_applies", "click", function () {
                if ($('input[name="phone"]').val() == '') {
                    alert('报备人信息不能为空');
                    return ;
                }

                $.ajax ({
                    url: '/index/add_applies',
                    type: 'POST',
                    async: true,
                    data: {"watch_id":user.watch_id},
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == 200) {
                            alert(data.msg);
                            $("#modal-watch").modal ('hide');
                            user.getList(1);
                        } else {
                            alert(data.msg);
                        }
                    }
                });
            });

        },
        getList: function (pageNo) {
            user.pageNo   = pageNo;
            var params    = {};
            params.start_date   = $("#start_date").val();
            params.end_date     = $("#end_date").val();
            params.name   = $("#name").val();
            params.phone  = $("#phone").val();
            params.house_title   = $("#house_title").val();
            params.pageNo   = user.pageNo;
            params.pageSize = user.pageSize;

            $.ajax ({
                url: '/index/get_watch',
                type: 'GET',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('watch_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#sublet_list").html (doTtmpl (data.data.list));

                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: user.pageSize,
                        onClick: function (el) {
                            user.getList (el.num.current);
                        }
                    });
                }
            });
        },
        addFollow : function () {
            var params = {};
            params.type = 2;
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
        },
        addphone : function(obj) {
            var phone_name= $(obj).find(".phone_name").html();
            var phone_phone= $(obj).find(".phone-phone").html();
            var phone_span= $(obj).find(".phone_span").html();
            var id= $(obj).find(".id").html();
            var val = id+phone_name+phone_span+phone_phone;
            user.store_id = $(obj).find(".store_id").html();
            user.agents_id = id.substring(0,id.length-1)
            $("input[name='phone']").val(val);
            $(obj).parent().hide();
            $("#agents_list").html('');
            return ;
        }
    };
    return user;
});

var id;

function alertFollow(obj){
    id = $(obj).attr ("data-id");
    $("#content").val('');
    $.ajax ({
        url: '/index/followList',
        type: 'GET',
        async: true,
        data: {"id":id,"type":2},
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

