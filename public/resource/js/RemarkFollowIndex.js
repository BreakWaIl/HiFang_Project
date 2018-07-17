define(['doT', 'text!temp/remark_follow_template_tpl.html', 'css!style/home.css', 'ckfinder', 'ckfinderStart', 'pagination', 'bootstrapJs'], function(doT, template) {
	follow = {
		pageNo: 1,
		/*第几页*/
		pageSize: 10,
		/*每页显示多少条*/
		id: '',
		house_id: '',
		type: '',
		valueCurrent: '',
		ajaxObj: '',
		stopstatus: true,
		boxphoto: '',
		init: function() {
			//初始化dot
			$(document.body).append(template);
			follow.getList(0);
			follow.event();
		},
		event: function() {
			$("#search").click(function() {
				follow.getList(1);
			});

			$("#reset").click(function() { //重置
				document.getElementById("form_search").reset();
			});
			$ (document).delegate (".caozuo", "click", function () {//点击操作跟进详情
				follow.house_id = $ (this).attr ("data-id");
				follow.Caozuo();
			});
			$ (document).delegate (".submit_edit", "click", function () {//提交
				follow.house_id = $ (this).attr ("data-id");
				follow.Submit_follow();
			});
			$ (document).on ("input","#cus_fang", function () {//手机号搜索客方2
				if($("#cus_fang").val()==''){
					$(".user-ul2").html('');
				}else{
					follow.search_phone2();
				}
			});
			$ (document).delegate (".addphone2", "click", function () {//list2消失
				follow.addphone2(this);
			});

		},
		addphone2:function(obj){
			var user_ht=$(obj).html();
			$("#cus_fang").val(user_ht);
			$(".user-ul2").html('');
			follow.agent_id = $ (obj).attr ("data-id");

		},
		search_phone2:function(){//手机号
			$.ajax ({
				url: '/index/select_by_phone',
				type: 'POST',
				async: true,
				data: {
					"phone":$("#cus_fang").val()
				},
				dataType: 'json',
				success: function (data) {
					if (data.code == 200) {
						var user_ul2 = "";
						$.each(data.data, function(i,item) {
							user_ul2+='<li class="addphone2" data-id="'+item.id+'">'+item.id+'-'+item.realname+'-'+item.phone+'</li>';
						});
						$(".user-ul2").html(user_ul2);

					} else {
						alert(data.msg);
					}

				}
			});
		},
		Caozuo:function(){//获取跟进详情的数据
			$.ajax({
				'type': 'GET',
				'url' : '/index/useraction_search',
				data: {"user_id":follow.house_id},
				dataType: "json",
				success: function(data){
					if(data.code == 200){
						if (data.data) {
							$("#cus_id").html(data.data.user_info.user_id);//客户编号
							$("#cus_name").val(data.data.user_info.user_nick);//姓名
							$("#sex").val(data.data.user_info.sex);//性别
							$("#cus_phone").html(data.data.user_info.user_phone);//电话
							$("#cus_date").html(data.data.user_info.create_time);//上传时间
							$("#cus_fang").val(data.data.user_info.agentinfo);//客方
							var caozuo_table="";
							$.each(data['data']['user_date'], function(i, item) {
								console.log(item)
								caozuo_table +='<tr><td>'+item.content+'</td><td>'+item.agentinfo+'</td><td>'+item.create_time+'</td></tr>';
							});
							$("#caozuo_table").html(caozuo_table);
						}
					} else {
						alert('获取失败！');
					}
				}
			});
		},

		Submit_follow: function() { //提交
			$.ajax({
				'type': 'POST',
				'url': '/index/pcEditClient',
				data: {
					"id": follow.house_id,
					"user_nick": $("#cus_name").val(),
					"user_phone": $("#cus_phone").html(),
					"agent_id":follow.agent_id,//客方
					"sex": $("#sex").val()
				},
				dataType: "json",
				success: function(data) {
					if(data.code == 200) {
						if(data.data) {
						}
					} else {
					}
				}
			});
		},
		getList: function(pageNo) {
			follow.pageNo = pageNo;
			var _startDateObj = $('#start_date'),
				_endDateObj = $('#end_date'),
				_customerNameObj = $('#customer_name'),
				_customerPhoneObj = $('#customer_phone'),
				_followContentObj = $('#follow_content');
			var params = {
				'pageNo': follow.pageNo,
				'pageSize': follow.pageSize
			};
			_startDateObj.val() != '' && (params.end_date = _startDateObj.val());
			_endDateObj.val() != '' && (params.start_date = _endDateObj.val());
			$.trim(_customerNameObj.val()) != '' && (params.customer = $.trim(_customerNameObj.val()));
			$.trim(_customerPhoneObj.val()) != '' && (params.phone = $.trim(_customerPhoneObj.val()));
			$.trim(_followContentObj.val()) != '' && (params.content = $.trim(_followContentObj.val()));
			
			$.ajax({
			    type: 'GET',
			    url: '/index/RemarkFollowList',
			    data: params,
			    timeout: 30000,
			    dataType: 'json',
			    beforeSend: function() {},
			    success: function(data) {
			        if(typeof data === 'object') {
			            if (data.code == 200) {
							var doTtmpl = doT.template(document.getElementById('remark_follow_tpl').innerHTML);
							$("#follow_list").html(doTtmpl(data.data.list));
							/*分页代码*/
							$("#pagediv").pagination({
								length: data.data.total,
								current: pageNo,
								every: follow.pageSize,
								onClick: function(el) {
									follow.getList(el.num.current);
								}
							});
			            }else {
			                alert(data['msg']);
			            };
			        }else{
			            alert('数据错误');
			        };
			    },
			    error: function() {
			        alert('error');
			    },
			    complete: function(xhr, textStatus){
			        if(textStatus === 'timeout'){
			            alert('请求超时');
			        };
			    }
			});
		}
	};
	return follow;
});