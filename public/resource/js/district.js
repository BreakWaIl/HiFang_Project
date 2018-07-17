define (['doT', 'text!temp/district_template_tpl.html', 'css!style/home.css','pagination','bootstrapJs'], function (doT, template) {
    district = {
        pageNo: 1, /*第几页*/
        pageSize: 10, /*每页显示多少条*/
        pageNum:10,
        district : 0,
        agent_id : 0,
        init: function () {
            //初始化dot
            $ ("body").append (template);
            district.getList ();
            district.event ();
        },
        event: function () {
            $ (document).delegate ("#search", "click", function () {//点击搜索
                district.getList(1);
            });
            $ (document).delegate (".edit", "click", function () {//点击编辑
                district.district_id = $ (this).attr ("data-id");
                district.Edit();
            });
            $ (document).delegate (".submit_edit", "click", function () {//提交编辑
                district.Submit_edit();
            });
            $ (document).delegate (".mend", "click", function () {//点击门店列表
                district.district_id = $ (this).attr ("data-id");
                district.Mend();
            });
            $(document).on('input','.phone_mend', function(e) {//搜索手机号码
                e.preventDefault();
                e.stopPropagation();
                var _this = $(this);
                var ldHtml=$(".mend_list");
                valueCurrent = _this.val();

                if(valueCurrent != ''){
                    district.loadMain(valueCurrent);
                    _this.parent().next().show();
                }else{
                    district.ldHtml.html('');
                    return false;
                }

            });
            $ (document).delegate (".mend_list li", "click", function () {//点击列表
                var phone_name=$(this).find(".phone_name").html();
                var phone_id=$(this).find(".phone_id").html();
                var phone_phone=$(this).find(".phone-phone").html();
                var phone_span=$(this).find(".phone_span").html();
                $(".phone_mend").val(phone_name+phone_span+phone_phone);
                $(this).parent().empty();
                district.agent_id = phone_id;
                // district.ldHtml.html('');
                return false;
            });

        },
        Edit:function(){//获取
            $.ajax({
                'type': 'GET',
                'url' : '/index/adddistrict',//获取编辑数据
                data: {"id":district.district_id},
                dataType: "json",
                success: function(data){
                    if (data.data) {
                        $("input[name = agents_id]").val(data.data.name);
                        $("input[name = title]").val(data.data.district_name);
                    }
                    else {
                        alert('获取失败！');
                    }
                }
            });
        },
        Submit_edit:function(){//提交编辑的信息
            var par ={};
            par.id = district.district_id;
            par.department_name = $("input[name =title]").val();
            par.agents_id = district.agent_id;
            $.ajax({
                'type': 'POST',
                'url' : '/index/adddistrict',
                data:par,
                dataType: "json",
                success: function(data){
                    if(data.code == 200){
                        district.getList(1);
                    } else {
                        alert(data.msg);
                    }
                }
            });
        },
        Mend:function(){//获取门店的信息
            var mend_table="";
            $.ajax({
                'type': 'GET',
                'url' : '/index/getDistrictStoreList',//门店
                data: {"id":district.district_id},
                dataType: "json",
                success: function(data){
                    if(data.code == 200){
                        if (data.data) {
                            $.each(data.data,function(i,item){
                                mend_table+='<tr><td>'+item.create_time+'</td> <td>'+item.id+'</td> <td>'+item.store_name+'</td><td>'+item.agents_name+'</td> <td>'+item.agents_total+'</td></tr>'
                            })
                            $("#mend_table").html(mend_table);
                        }
                    } else {
                        alert('获取失败！');
                    }
                }
            });
        },
        loadMain:function(phone) {//手机号
            district.ajaxObj=$.ajax({
                type: "GET",
                url: '/index/getBroker_new' ,
                data: {
                    'phone': phone,
                    "level":"10,20"
                },
                timeout: 10000,
                dataType: "json",
                beforeSend: function() {
                },
                success: function(data) {
                    if(data.code === 200){
                        var _html = '';
                        $.each(data.data, function(i,data) {
                            _html += '<li><span class="phone_id">'+data['id']+'</span><span class="phone_name">'+data['name']+'</span><span class="phone_span">-</span><span class="phone-phone">'+data['phone']+'</span> </li>';
                        });
                        $(".mend_list").html(_html);
                    }
                },
                error: function() {

                },
                complete: function(xhr, textStatus) {
                    if(textStatus === "timeout") {
                        //处理超时的逻辑
                        alert("请求超时");
                    }
                }
            });
        },

        getList: function (pageNo) {
            district.pageNo   = pageNo;
            var params    = {};
            params.pageNo   = district.pageNo;
            params.pageSize = district.pageSize;
            params.search = $("input[name='search']").val();
            $.ajax ({
                url: '/index/getDistrictList',//列表数据
                type: 'GET',
                async: true, 
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('district_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#district_list").html (doTtmpl (data.data.list));
                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: district.pageSize,
                        onClick: function (el) {
                            district.getList (el.num.current);
                        }
                    });
                }
            });
        }
    };
    return district;
});