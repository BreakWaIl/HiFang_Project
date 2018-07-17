define (['doT', 'text!temp/business_district_template_tpl.html', 'css!style/home.css','pagination','bootstrapJs'], function (doT, template) {
    business = {
        pageNo: 1, /*第几页*/
        pageSize: 10, /*每页显示多少条*/
        id : '',
        init: function () {
            //初始化dot
            $ ("body").append (template);
            business.getList ();
            business.event ();
        },
        event: function () {
            $("#search").click(function () {
                business.getList(1);
            });

            $("#reset").click(function () {
                document.getElementById("form_search").reset();
            });

            $("#modal_add").click(function () {
                $("#title").html('新增商圈');
                business.getRegionsProvince(310000, 310100, 310101);    //默认上海，上海，黄浦
            });

            $("#province").change(function () {
                business.getRegionsCity();
            });

            $("#city").change(function () {
                business.getRegionsDisc();
            });

            $("#add_business").click(function () {
                var params = {};
                params.province = $("#province").find("option:selected").text();
                params.city = $("#city").find("option:selected").text();
                params.disc = $("#disc").find("option:selected").text();
                params.province_code = $("#province").val();
                params.city_code = $("#city").val();
                params.disc_code = $("#disc").val();
                params.business = $("#business").val();
                params.id = business.id;
                $.ajax({
                    url : '/index/editBusinessDistrict.html',
                    type : 'POST',
                    async: true,
                    data : params,
                    dataType : 'json',
                    success : function (data) {
                        if (data.code == 200 ) {
                            if (business.id) {
                                alert('编辑成功');
                            } else {
                                alert('添加成功');
                            }
                            business.getList(1);
                            $("#modal_business").modal ('hide');
                        } else {
                            alert('添加失败');
                        }
                    }
                });
            });

            $ (document).delegate (".edit_modal", "click", function () {
                $("#title").html('编辑商圈');
                business.id = $ (this).attr ("data-id");
                $.ajax({
                    url : '/index/editBusinessDistrict.html',
                    type : 'GET',
                    async: true,
                    data: {"id":business.id},
                    dataType: 'json',
                    success : function (data) {
                        if (data.code == 200) {
                            $("#business").val(data.data.name);
                            business.getRegionsProvince(data.data.province_code,data.data.city_code,data.data.disc_code);
                        } else {
                            alert(data.msg);
                        }
                    }
                });
            });

            $ (document).delegate (".del_modal", "click", function () {
                business.id = $ (this).attr ("data-id");
            });

            $ (document).delegate ("#confirm_delete", "click", function () {
                business.delBusiness();
            });

            $ (document).delegate (".is_show", "click", function () {
                if (!confirm('是否继续？')) {
                    return ;
                }
                business.id = $ (this).attr ("data-id");
                var params ={};
                params.id = $ (this).attr ("data-id");
                var str = $.trim($(this).html());
                if (str === "不显示") {
                    params.type = 1;
                    $(this).html('显示');
                } else {
                    params.type = 0;
                    $(this).html('不显示');
                }
                $.ajax ({
                    url: '/index/editBusinessDistrict.html',
                    type: 'POST',
                    async: true,
                    data: params,
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == 200) {
                            business.getList (1);
                        } else {
                            alert('修改显示失败');
                        }
                    }
                });
            });
        },
        getList: function (pageNo) {
            business.pageNo   = pageNo;
            var params    = {};
            params.pageNo   = business.pageNo;
            params.pageSize = business.pageSize;
            params.name     = $("#name").val();

            $.ajax ({
                url: '/index/BusinessList.html',
                type: 'GET',
                async: true, 
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('business_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#business_list").html (doTtmpl (data.data.list));

                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: business.pageSize,
                        onClick: function (el) {
                            business.getList (el.num.current);
                        }
                    });
                }
            });
        },
        getRegionsProvince : function (code_province, code_city, code_disc) {
            $.ajax ({
                url: '/index/regions.html',
                type: 'GET',
                async: true,
                dataType: 'json',
                success: function (data) {
                    if (data.code == 200) {
                        var _html = '';
                        $.each(data.data, function (i,n) {
                            if (n.code == code_province) {
                                _html += '<option selected="selected" value="'+n.code+'">'+n.name+'</option>';
                            } else {
                                _html += '<option value="'+n.code+'">'+n.name+'</option>';
                            }
                        });
                        $("#province").html(_html);
                        business.getRegionsCity(code_city,code_disc);
                    } else {
                        alert('请求省市区错误');
                    }
                }
            });
        },
        getRegionsCity : function (code_city, code_disc) {
            var params  = {};
            params.parent_code = $("#province").val();
            if (params.parent_code == '请选择') {
                params.parent_code = 310000;
            }

            $.ajax ({
                url: '/index/regions.html',
                type: 'GET',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    if (data.code == 200) {
                        var _html = '';
                        $.each(data.data, function (i,n) {
                            if (n.code == code_city) {
                                _html += '<option selected="selected" value="'+n.code+'">'+n.name+'</option>';
                            } else {
                                _html += '<option value="'+n.code+'">'+n.name+'</option>';
                            }
                        });
                        $("#city").html(_html);
                        business.getRegionsDisc(code_disc);
                    } else {
                        alert('请求省市区错误');
                    }
                }
            });
        },
        getRegionsDisc : function (code) {
            var params  = {};
            params.parent_code = $("#city").val();
            if (params.parent_code == '请选择') {
                params.parent_code = 310100;
            }
            $.ajax ({
                url: '/index/regions.html',
                type: 'GET',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    if (data.code == 200) {
                        var _html = '';
                        $.each(data.data, function (i,n) {
                            if (n.code == code) {
                                _html += '<option selected="selected" value="'+n.code+'">'+n.name+'</option>';
                            } else {
                                _html += '<option value="'+n.code+'">'+n.name+'</option>';
                            }
                        });
                        $("#disc").html(_html);
                    } else {
                        alert('请求省市区错误');
                    }
                }
            });
        },
        delBusiness : function () {
            $.ajax({
                url : '/index/delBusinessDistrict.html',
                type : 'POST',
                async: true,
                data: {"id":business.id},
                dataType: 'json',
                success : function (data) {
                    if (data.code == 200) {
                        business.getList(1);
                        $("#modal-delete").modal ('hide');
                    } else {
                        $("#del_msg").html('<span style="color: red">删除失败!</span>');
                    }
                }
            });
        }
    };
    return business;
});