/**
 * Created by 刘丹 on 2017/12/11.
 */

define(['doT', 'text!temp/store_template_tpl.html', 'css!style/home.css', 'ckfinder', 'ckfinderStart', 'pagination', 'bootstrapJs'], function(doT, template) {
	store = {
		pageNo: 1,
		/*第几页*/
		pageSize: 15,
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
			$("body").append(template);
			store.getList();
			store.event();
			store.getRegionsDisc();
			// store.getDistrict();
		},
		event: function() {
			$("#search").click(function() {
				store.getList(1);
			});

			$("#reset").click(function() { //重置
				document.getElementById("form_search").reset();
			});

			$(document).delegate(".del_modal", "click", function() {
				store.id = $(this).attr("data-id");

			});
			$ (document).delegate (".edit", "click", function () {//点击编辑

				store.house_id = $ (this).attr ("data-id");
				$("#modal-title").html("编辑门店信息");
				store.Edit();

			});
			$ (document).delegate (".submit_edit", "click", function () {//提交编辑
				store.Submit_edit();
				store.getList();
			});
			$ (document).delegate (".mend", "click", function () {//点击业务员列表
				store.house_id = $ (this).attr ("data-id");
				store.Mend();
			});
            $ (document).on ("input","#cus_fang", function () {//手机号搜索客方2
                if($("#cus_fang").val()==''){
                    $(".user-ul2").html('');
                }else{
                    store.search_phone2();
                }
            });
            $ (document).on ("input","#set_father_id3", function () {//手机号搜索客方
                if($("#set_father_id3").val()==''){
                    $(".user-ul").html('');
                }else{
                    store.search_phone();
                }
            });
            $ (document).delegate (".addphone", "click", function () {//list消失
                store.addphone(this);
            });
            $ (document).delegate (".addphone2", "click", function () {//list2消失
                store.addphone2(this);
            });

            $ (document).delegate (".add", "click", function () {//list2消失
                document.getElementById('form_id').reset();
                store.getDistrict();
            });

			/************************************************百度地址定位相关*************************************************************/
			var _doc = $(document),
				_provinceInternalObj = $('#province_internal'),
				_cityInternalObj = $('#city_internal'),
				_discInternalObj = $('#disc_internal'),
				_addressInternalObj = $('#address'),
				_longitudeObj = $('#longitude'),
				_latitudeObj = $('#latitude'),
				ulHtml = $('#main_ul>ul'),
				loadItem = $("#loading_pic"),
				noMoreItem = $("#no_more"),
				_inputObj = $('#search_input'),
				valueCurrent = '';
			//初始化,百度地图相关对象
			var LocalSearch = new BMap.LocalSearch(),
				myGeo = new BMap.Geocoder();

			//搜索地址的回调
			LocalSearch.setSearchCompleteCallback(function(data) {
				if(LocalSearch.getStatus() == BMAP_STATUS_SUCCESS) {
					var _html = "";
					for(var i = 0; i < data.getCurrentNumPois(); i++) {
						_html += '<li data-city="{2}" data-lat="{3}" data-lng="{4}" data-dismiss="modal"><p>{0}</p><p>{1}</p></li>'.stringFormatObj({
							'0': data.getPoi(i)["title"],
							'1': data.getPoi(i)["address"],
							'2': data.getPoi(i)["city"],
							'3': data.getPoi(i)["point"]["lat"],
							'4': data.getPoi(i)["point"]["lng"]
						});
					};
					ulHtml.html(_html);
					loadItem.hide();
					noMoreItem.show();
				};
			});

			_inputObj.on('input', function(e) {
				e.preventDefault();
				e.stopPropagation();
				valueCurrent = $(this).val();
				if(valueCurrent != '') {
					addressResetLoad();
					addressLoadMain(valueCurrent);
				} else {
					ulHtml.html('');
					loadItem.hide();
					noMoreItem.show();
					return false;
				}
			});

			//输入框的取消图标点击事件
			$('.cancel-pic').click(function(e) {
				e.preventDefault();
				e.stopPropagation();
				_inputObj.val('').focus();
				addressResetLoad();
			});

			_doc.on('click', '#main_ul>ul>li', function(e) {
				e.preventDefault();
				e.stopPropagation();
				var _this = $(this),
					_city = _this.data('city'),
					_lng = Number(_this.data('lng')), //经度
					_lat = Number(_this.data('lat')); //纬度

				getDistrict(_lng, _lat, function(data) {
					if(data['city']) {
						_provinceInternalObj.val(data['province']);
						_cityInternalObj.val(data['city']);
						_discInternalObj.val(data['district']);
						var _htmlOri = _this.find('p:nth-of-type(2)').html(),
							_htmlDeal = '',
							_index1 = _htmlOri.indexOf('市'),
							_index2 = _htmlOri.indexOf('区');
						if((_index1 > 0) && (_index2 > 2) && (_index2 > _index1)) {
							_htmlDeal = _htmlOri.slice(_index2 + 1);
						} else {
							_htmlDeal = _htmlOri;
						}
						_addressInternalObj.val(_htmlDeal);
						_longitudeObj.val(_lng);
						_latitudeObj.val(_lat);
						//						$('#position_box').hide();
					} else {
						alert('请重新选择地址');
						return false;
					}
				}); //根据经纬度获取城市区域名
			});

			function addressResetLoad() {
				ulHtml.html('');
				loadItem.hide();
				noMoreItem.show();
			};

			function addressLoadMain(keyword) {
				loadItem.show();
				noMoreItem.hide();
				LocalSearch.setLocation('上海市');
				LocalSearch.search(keyword);
			};

			function getDistrict(str1, str2, fn) {
				myGeo.getLocation(new BMap.Point(str1, str2), function(result) {
					if(result) {
						fn(result['addressComponents']);
					}
				});
			};
			/************************************************百度地址定位相关****结束*************************************************************/

		},

		getRegionsDisc: function(name) {
			var params = {};
			params.parent_code = 310100;
			$.ajax({
				url: '/index/regions',
				type: 'GET',
				async: true,
				data: params,
				dataType: 'json',
				success: function(data) {
					if(data.code == 200) {
						var _html = '';
						$.each(data.data, function(i, n) {
							_html += '<option value="' + n.fullName + '">' + n.fullName + '</option>';
						});
						$("#area").append(_html);
					} else {
						alert('请求省市区错误');
					}
				}
			});
		},
		Edit:function(){//获取编辑的数据
			$.ajax({
				'type': 'GET',
				'url' : '/index/getStoreById',//获取编辑数据
				data: {"id":store.house_id},
				dataType: "json",
				success: function(data){
					if (data.data) {
                        document.getElementById('form_id').reset();
						$("input[name = address]").val(data.data.address);//公司的详细地址
						$("input[name = name]").val(data.data.store_name);//门店名
						$("#pid-select").val(data.data.scale)//规模
						$("input[name=store-name]").val(data.data.agents_name);//店长
						// $("input[name=ss-store]").val(data.data.district_name);//所属部门
						$("#province_internal").val(data.data.province)//地址1
						$("#city_internal").val(data.data.city)//地址1
						$("#disc_internal").val(data.data.district)//地址1
						$("#longitude").val(data.data.longitude)//经纬度
						$("#latitude").val(data.data.latitude)//经纬度
						store.agents_id=data.data.agents_id;//经纪人id
						store.district_id=data.data.district_id;//部门id
                        store.getDistrict(data.data.district_name);
					}
					else {
						alert('获取失败！');
					}
				}
			});
		},
		Submit_edit:function(){//提交编辑的信息
			var par = {};
			par.id = store.house_id;//门店id
			par.agents_id = $("#shop_id").val();//经纪人id
			par.province = $("#province_internal").val();//省
			par.city = $("#city_internal").val();//城市
			par.district = $("#disc_internal").val();//区
			par.address = $("input[name =address]").val();//详细地址
			par.longitude = $("input[name =longitude]").val();//经度
			par.latitude  = $("input[name =latitude]").val();//纬度
			par.store_name = $("input[name =name]").val();//门店名
			par.scale = $("#pid-select option:selected").val();//规模
			par.district_id= $("#ss-store option:selected").val();//部门id
			console.log(par);
			$.ajax({
				'type': 'POST',
				'url' : '/index/addStore',
				data:par,
				dataType: "json",
				success: function(data){
					if(data.code==200){

					}else{
						alert(data.msg);
					}
				}
			});
		},
		Mend:function(){//获取门店的信息
			var mend_table="";
			$.ajax({
				'type': 'GET',
				'url' : '/index/getBrokerList',//门店
				data: {"store_id":store.house_id},
				dataType: "json",
				success: function(data){
					if(data.code == 200){
						if (data.data) {
							$.each(data.data,function(i,item){
								mend_table+='<tr><td>'+item.create_time+'</td> <td>'+item.id+'</td> <td>'+item.name+'</td><td>'+item.phone+'</td> </tr>'
							});
							$("#mend_table").html(mend_table);
						}
					} else {
						alert('获取失败！');
					}
				}
			});
		},
		getList: function(pageNo) {
			store.pageNo = pageNo;
			var params = {};
			params.pageNo = store.pageNo;
			params.pageSize = store.pageSize;
			params.district = $('#area option:selected').val();; //城市区
			params.store_name = $('#mend_name').val(); //门店名
			params.agents_name = $('#name').val(); //店长名
			params.agents_phone = $('#phone').val(); //手机号

			$.ajax({
				url: '/index/storeList', //获取列表
				type: 'GET',
				async: true,
				data: params,
				dataType: 'json',
				success: function(data) {
					var temp = document.getElementById('store_list_tpl').innerHTML;
					var doTtmpl = doT.template(temp);
					$("#store_list").html(doTtmpl(data.data.list));

					/*分页代码*/
					$("#pagediv").pagination({
						length: data.data.total,
						current: pageNo,
						every: store.pageSize,
						onClick: function(el) {
							store.getList(el.num.current);
						}
					});
				}
			});
		},
		addphone:function(obj){
            var user_ht=$(obj).html();
            $("#set_father_id3").val(user_ht);
            $(".user-ul").html('');
            $("#shop_id").val($ (obj).attr ("data-id"));
        },
        search_phone:function(){//手机号
            $.ajax ({
                url: '/index/getBroker_new',
                type: 'GET',
                async: true,
                data: {
                    "phone":$("#set_father_id3").val(),
					"level": 10
                },
                dataType: 'json',
                success: function (data) {
                    if (data.code == 200) {
                        var user_ul = "";
                        $.each(data.data, function(i,item) {
                            user_ul+='<li class="addphone" data-id="'+item.id+'">'+item.id+'-'+item.name+'-'+item.phone+'</li>';
                        });
                        $(".user-ul").html(user_ul);

                    } else {
                        alert(data.msg);
                    }

                }
            });
        },
        search_phone2:function(){//手机号
            $.ajax ({
                url: '/index/getBroker_new',
                type: 'GET',
                async: true,
                data: {
                    "phone":$("#cus_fang").val(),
                    "level": 10
                },
                dataType: 'json',
                success: function (data) {
                    if (data.code == 200) {
                        var user_ul2 = "";
                        $.each(data.data, function(i,item) {
                            user_ul2+='<li class="addphone2" data-id="'+item.id+'">'+item.id+'-'+item.name+'-'+item.phone+'</li>';
                        });
                        $(".user-ul2").html(user_ul2);

                    } else {
                        alert(data.msg);
                    }

                }
            });
        },
        getDistrict: function(name) {
            $.ajax({
                url: '/index/getDistrictListByName',
                type: 'GET',
                async: true,
                data: {"pageSize":50},
                dataType: 'json',
                success: function(data) {
                    if(data.code == 200) {
                        var _html = '';
                        $.each(data.data, function(i, n) {
                            if (n.district_name == name && (typeof name != undefined)) {
                                _html += '<option selected="selected" value="' + n.id + '">' + n.district_name + '</option>';
							} else {
                                _html += '<option value="' + n.id + '">' + n.district_name + '</option>';
							}
                        });
                        $("#ss-store").html(_html);
                    } else {
                        alert('获取部门信息失败');
                    }
                }
            });
        }
	};
	return store;
});