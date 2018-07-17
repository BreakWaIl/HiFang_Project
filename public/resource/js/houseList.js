/**
 * Created by 刘丹 on 2017/12/11.
 */

define (['doT', 'text!temp/house_template_tpl.html', 'css!style/home.css','ckfinder','ckfinderStart','pagination','bootstrapJs'], function (doT, template) {
    business = {
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
        exclusive_id : 0,
        init: function () {
            //初始化dot
            $ ("body").append (template);
            business.getList ();
            business.event ();
            business.resetLoad();
        },
        event: function () {
            $("#search").click(function () {
                business.getList(1);
            });

            $("#reset").click(function () {//重置
                document.getElementById("form_search").reset();
            });

            $ (document).delegate (".del_modal", "click", function () {
                business.id = $ (this).attr ("data-id");

            });
            $ (document).delegate (".anch", "click", function () {//点击设置案场权限人
                business.house_id = $ (this).attr ("data-id");
                business.type="1";
                business.Anch();//获取手机号名字的
            });
            $ (document).delegate (".add_applies", "click", function () {//点击设置案场权限人
                business.house_id = $ (this).attr ("data-id");
                business.type="2";
                business.Anch();
            });
            $ (document).delegate (".dujia", "click", function () {//点击独家
                business.house_id = $ (this).attr ("data-id");
                business.type="3";
                business.Dujia();
            });
            $ (document).delegate (".caozuo", "click", function () {//点击操作记录
                business.house_id = $ (this).attr ("data-id");
                business.Caozuo();
            });
            $ (document).delegate (".submit_follow2", "click", function () {//提交独家
                business.Dujianew();
            });
            $ (document).delegate (".submit_follow", "click", function () {//提交按钮设置案场权限人
                business.Submit_follow();
            });

            $ (document).delegate ("#confirm_delete", "click", function () {
                business.delBusiness();
            });
            $ (document).delegate (".jia", "click", function () {//加号
                business.jiabox();
            });
            $ (document).delegate (".addphone", "click", function () {//加号
               business.addphone(this);
            });
            $ (document).delegate (".jian", "click", function () {//叉号
                business.jianbox();
            });


            $(document).on('input','.phone_jia,.phone_add', function(e) {//搜索手机号码/加号搜索
                e.preventDefault();
                e.stopPropagation();
                var _this = $(this);
                _this.next().css("display","block");
                valueCurrent = _this.val();

                if(valueCurrent != ''){
                    business.resetLoad(1);
                    business.loadMain(valueCurrent,_this.next());
                    console.log(_this.next());
                }else{
                    business.ldHtml.html('');
                    return false;
                }

            });
            $ (document).delegate (".is_show", "click", function () {//推荐至首页
                if (!confirm('是否继续？')) {
                    return ;
                }
                business.id = $ (this).attr ("data-id");
                var params ={

                };
                params.id = $ (this).attr ("data-id");
                var str = $.trim($(this).html());
                if (str === "推荐至首页") {
                    params.type = 1;
                    $(this).html('已推荐');
                } else {
                    params.type = 0;
                    $(this).html('推荐至首页');
                }
                $.ajax({//推荐至首页
                    'type': 'POST',
                    'url' : '/index/carefullyChosen',
                    data: {"houses_id":business.id,"is_carefully_chosen":params.type},
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
            $ (document).delegate ("#liudan_pic_btn", "click", function () {//上传图片
                var img_url="";
                BrowseServer ('liudan_pic_btn',function(url){
                    var alt_img=$("#liudan_pic_btn").val();
                    alt_img = alt_img.replace('images/','');
                    img_url+=' <img src="'+url+'" class="jai_dujia" data-img="'+alt_img+'">';
                    $("#liudan_pic_pre").append(img_url);
                });
            });

        },
        Anch:function(){//获取手机号名字的
            $.ajax({
                'type': 'GET',
                'url' : '/index/getAgentsTohouses',
                data: {"houses_id":business.house_id,"type":business.type},
                dataType: "json",
                success: function(data){
                    if(data.code == 200){
                        if (data.data) {
                            $(".jian_class").html('');//写入
                            $.each(data.data, function(i,data) {
                                business.jiabox_data(data['id'],data['name'],data['phone']);
                            });
                            business.jiabox();
                        }
                    } else {
                        alert('请登录！');
                    }
                }
            });
        },
        Dujia:function(){//获取独家的信息
            $.ajax({
                'type': 'GET',
                'url' : '/index/getExclusive',
                data: {"houses_id":business.house_id},
                dataType: "json",
                success: function(data){
                    if(data.code == 200){
                        if (data.data) {
                            $("#sel_dujia").val(data.data.is_exclusive_type);//是否独家
                            $("#start_date_dujia").val(data.data.agent_start_time);//上传时间
                            $("#end_date_dujia").val(data.data.agent_end_time);
                            $("#exclusive").val(data.data.name);
                            business.exclusive_id=data.data.id;
                            var img_url="";
                            $.each(data['data']['exclusive_img'], function(i, item) {
                                var local_img=location.origin+'/resource/lib/Attachments/images/'+item.img_name;
                                img_url +='<img src="'+local_img+'" class="jai_dujia" data-img="'+item.img_name+'" >';
                            });
                            $("#liudan_pic_pre").html(img_url);
                        }
                    } else {
                        alert('获取失败！');
                    }
                }
            });
        },
        Dujianew:function(){//提交独家的信息
            var images=[];//图片
            var imgs =$(".jai_dujia");
            for(var j=0;j<imgs.length;j++){
                    images.push(imgs[j].getAttribute("data-img"))
            }
            $.ajax({
                'type': 'POST',
                'url' : '/index/editExclusive',
                data: {"houses_id":business.house_id,//楼盘Id
                    "is_exclusive_type":$("#sel_dujia").val(),//是否独家
                    "exclusive_id":business.exclusive_id,//经纪人id
                    "agent_start_time":$("#start_date_dujia").val(),//开始时间
                    "agent_end_time":$("#end_date_dujia").val(),//结束时间
                    "exclusive_img":images//图片
                },
                dataType: "json",
                success: function(data){
                    if(data.code == 200){

                    } else {
                        alert('获取失败！');
                    }
                }
            });
        },
        Caozuo:function(){//获取独家的信息
            var caozuo_table="";
            $.ajax({
                'type': 'GET',
                'url' : '/index/getRecords',//获取操作记录
                data: {"houses_id":business.house_id},
                dataType: "json",
                success: function(data){
                    if(data.code == 200){
                        if (data.data) {
                            $.each(data.data,function(i,item){
                                caozuo_table+='<tr><td>'+item.remark+'</td> <td>'+item.name+'</td> <td>'+item.create_time+'</td></tr>'
                            });
                            $("#caozuo_table").html(caozuo_table);
                            }
                    } else {
                        alert('获取失败！');
                    }
                }
            });
        },
        Submit_follow:function(){//提交案场权限人数据
            var agents_id="";
            var _agents_id="";
            $("input[name='ues_id']").each(function() {//拼接经纪人id
                var s =$(this).val();
                var m = s.match(/[^-]+(?=[-])/g);
                if(m === null){
                    return false;
                }else{
                    agents_id += ","+ m[0];
                    _agents_id=agents_id.substring(1);
                }
            });
            $.ajax({
                'type': 'POST',
                'url' : '/index/addHousesAgents',
                data: {"houses_id":business.house_id,"type":business.type,"agents_id":_agents_id},
                dataType: "json",
                success: function(data){
                    if(data.code == 200){
                        if (data.data) {
                            $("#modal-anch").hide;
                        }
                    } else {
                        $("#modal-anch").hide;
                    }
                }
            });
        },
        resetLoad:function (){//手机号
        if(business.ajaxObj){
            business.ajaxObj.abort();
        }
            business.ldHtml.html('');
            business.stopstatus = true;
    },
        loadMain:function(phone, obj) {//手机号
            business.ajaxObj=$.ajax({
            type: "GET",
            url: '/index/getBroker_new' ,
            data: {
                'phone': phone
            },
            timeout: 10000,
            dataType: "json",
            beforeSend: function() {
            },
            success: function(data) {

                if(data.code === 200){
                    var _html = '';
                    $.each(data.data, function(i,data) {
                        _html += '<li class="addphone"><span class="id">'+data['id']+'-</span><span class="phone_name">'+data['name']+'</span><span class="phone_span">-</span><span class="phone-phone">'+data['phone']+'</span> </li>';
                    });
                    obj.html(_html);
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
    addphone:function (obj){//list消失
        var phone_name=$(obj).find(".phone_name").html();
        var phone_phone=$(obj).find(".phone-phone").html();
        var phone_span=$(obj).find(".phone_span").html();
        var id= $(obj).find(".id").html();
        business.exclusive_id = id.substr(0, id.length - 1);
        $(obj).parent().prev().val(id+phone_name+phone_span+phone_phone);
        $(obj).parent().hide();
        business.ldHtml.html('');
        return ;
    },
        jiabox:function () {//加输入框
            business.boxphoto = '<input name="ues_id" placeholder="请输入" type="tel" style="margin-left: 10px;float: left" class="phone_add">' +
        '<ul class="phone_list1"></ul>'+
        '<img src="/resource/image/qdao-sha.png" class="jian">';
        $(".jian_class").append(business.boxphoto);//写入

            business.jianbox();
    },

        jiabox_data:function (id,name,phone) {//显示已经获取的数据
         business.boxphoto = '<input name="ues_id" placeholder="请输入" value='+id+'-'+name+'-'+phone+' type="tel" style="margin-left: 10px;float: left" class="phone_add">' +
        '<ul class="phone_list1"></ul>'+
        '<img src="/resource/image/qdao-sha.png" class="jian"><input type="hidden" value="'+id+'">';
        $(".jian_class").append(business.boxphoto);//写入
    },


        jianbox: function () {
        $(".jian").click(function () {//删除经纪人数据
            var ss =$(this).prev().prev().val();
            var mm = ss.match(/[^-]+(?=[-])/g);
            if(mm === null){
                $(this).prev().prev().remove();
                $(this).prev().remove();
                $(this).remove();
                return false;
            }else{
                var mm_id=mm[0];
            }

            var r=confirm("确定删除吗!");
            if (r==true)
            {
                $(this).prev().prev().remove();
                $(this).prev().remove();
                $(this).remove();
                $.ajax({
                    'type': 'POST',
                    'url' : '/index/delTohouses',
                    data: {"id":mm_id,"houses_id":business.house_id},
                    dataType: "json",
                    success: function(data){
                        if(data.code == 200){

                        } else {
                            alert("删除失败");
                        }
                    }
                });


            }
            else
            {

            }


        });
    },
        getList: function (pageNo) {
            business.pageNo   = pageNo;
            var params    = {};
            params.pageNo   = business.pageNo;
            params.pageSize = business.pageSize;
            params.is_carefully_chosen  = $('#is_carefully_chosen option:selected') .val();//首页显示
            params.is_show  = $('#is_show option:selected') .val();//c端显示
            params.shop_type  = $('#shop_type option:selected') .val();//商铺类型
            params.leased  = $('#leased option:selected') .val();//商铺状态
            params.rent_price  = $('#rent_price option:selected') .val();//月租金
            params.is_exclusive_type  = $('#is_exclusive_type option:selected') .val();//是否独家
            params.internal_title  = $('#internal_title') .val();//商铺名称
            params.industry_type  = $('#industry_type') .val();//业态
            params.dish  = $('#dish') .val();//盘方
            params.id  = $('#id') .val();//店铺编号
            params.start_date  = $('#start_date') .val();//时间1
            params.end_date  = $('#end_date') .val();//时间2

            $.ajax ({
                url: '/index/getHouseList.html',//获取列表
                type: 'GET',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('house_list_tpl').innerHTML;
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
        delBusiness : function () {
            $.ajax({
                url : '/index/houseDel',
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