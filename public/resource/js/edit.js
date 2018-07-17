define (['ckfinder','ckfinderStart', 'bootstrapJs'], function () {
    var user = {
        init: function () {
            //初始化dot
            user.event ();
        },
        event: function () {
        	var _id = getUrlParam('id'),//地址栏获取的商铺或者街铺id
        		_doc = $(document),
        		_urlCut = location.origin + '/resource/lib/Attachments/images/',//要截取的部分url
        		_loadMainItem = $('#main_loading_pic'),//整个页面的加载图标
    			_shangpuTypeObj = $('#shangpuType'),//商铺类型
    			_showCdObj = $('#showCd'),//显示给C端用户看
    			_exclusiveTypeObj = $('#exclusiveType'),//是否独家
    			_yetaiObj = $('.yetai'),//业态
        		_roomTagObj = $('.roomTag'),//商铺标签
        		_landlordPhoneObj = $('#landlordPhone'),//房东手机号
        		_internalNameObj = $('#internalName'),//对内商铺名称
        		_foreignNameObj = $('#foreignName'),//对外商铺名称
        		_landlordPhoneObj = $('#landlordPhone'),//房东手机号
        		_zujinTypeObj = $('#zujinType'),//租金模式
        		_moonPriceObj = $('#moonPrice'),//月租均价
        		_wuyePriceObj = $('#wuyePrice'),//物业管理费
        		_jinchangPriceObj = $('#jinchangPrice'),//进场费
        		_roomShengyuNumObj = $('#roomShengyuNum'),//剩余铺数
        		_roomAllNumObj = $('#roomAllNum'),//总铺数
        		_roomArea1Obj = $('#roomArea1'),//商铺面积起始值
        		_roomArea2Obj = $('#roomArea2'),//商铺面积结束值
        		_businessAreaObj = $('#businessArea'),//商业面积
        		_provinceInternalObj = $('#province_internal'),//对内地址省
        		_cityInternalObj = $('#city_internal'),//对内地址市
        		_discInternalObj = $('#disc_internal'),//对内地址区
        		_addressInternalObj = $('#address_internal'),//对内地址详细地址
        		_longitudeObj = $('#longitude'),//经度
        		_latitudeObj = $('#latitude'),//纬度
        		_provinceExternalObj = $('#province_external'),//对外地址省
        		_cityExternalObj = $('#city_external'),//对外地址市
        		_discExternalObj = $('#disc_external'),//对外地址区
        		_addressExternalObj = $('#address_external'),//对外地址详细地址
        		_trafficObj = $('#traffic'),//交通
        		_hasMovedObj = $('#hasMoved'),//已入住
        		_yingyeTimeObj = $('#yingyeTime'),//营业时间
        		_kaipanTimeObj = $('#kaipanTime'),//开盘时间
        		_kaiyeTimeObj = $('#kaiyeTime'),//开业时间
        		_hasGasObj = $('#hasGas'),//是否有燃气
        		_yongjinRuleObj = $('#yongjinRule'),//佣金规则
        		_internalYoushiObj = $('#internalYoushi'),//对内项目优势
        		_foreignYoushiObj = $('#foreignYoushi'),//对外项目优势
        		_qianyueRuleObj = $('#qianyueRule'),//签约规则
        		_imgUploadLiebiao = $('#liebiao_pic_ul'),//列表页封面图ul
        		_imgUploadLunbo = $('#xiangqing_pic_ul'),//详情页轮播图ul
        		_imgUploadLouceng = $('#louceng_pic_ul'),//楼层平面图ul
        		_pdfUploadFujian = $('#fujian_ul'),//附件ul
        		_weilouLinkObj = $('#weilouLink'),//微楼书
        		_dajiangtangObj = $('#dajiangtang'),//大讲堂
        		_exclusiveDate1Obj = $('#exclusiveDate1'),//独家代理有效期开始时间
    			_exclusiveDate2Obj = $('#exclusiveDate2'),//独家代理有效期结束时间
    			_exclusiveTelObj = $('#exclusiveTel'),//独家方电话
    			_imgUploadDujia = $('#dujia_pic_ul'),//独家合同ul
    			_imgMaskObj = $('#img_mask_area');//预览大图的mask
    		
    		//处理文件名，长度过长时处理
    		function dealFileName(str){
    			//如果文件超过30的长度，则用*代替
    			if(str.length > 26){
    				return str.slice(0,23)+'***'+str.slice(-4);
    			}else{
    				return str;
    			};
    		};
    	
			if(_id != null){
				$.ajax({
				    type: 'GET',
				    url: '/index/houseEdit',
				    data: {
				    	'id': _id
				    },
				    timeout: 30000,
				    dataType: 'json',
				    beforeSend: function() {
				    	_loadMainItem.show();
				    },
				    success: function(data) {
				        if(typeof data === 'object') {
				        	var _data = data['data'];
				            if (data.code == 200) {
				                _shangpuTypeObj.val(_data['shop_type']).change().attr({
				                	'disabled': 'disabled',
				                	'title': '商铺类型暂不支持修改'
				                });
				                _showCdObj.val(_data['is_show']).change();
				                _exclusiveTypeObj.val(_data['is_exclusive_type']).change();
				                if(_data['shop_type'] == '0'){
				                	//如果是商场
				                	_roomArea2Obj.val(_data['shop_area_end']);//商铺面积范围上限值
				                };
				                if(_data['is_show'] == '0'){
				                	//如果是显示给C端用户看（对商户公开）
				                	_foreignNameObj.val(_data['external_title']);//对外商铺名称
				                	_addressExternalObj.val(_data['external_address']);//对外详细地址
				                	_foreignYoushiObj.val(_data['external_item_advantage']);//对外项目优势
				                };
				                if(_data['is_exclusive_type'] == '1'){
				                	//如果是独家
				                	_exclusiveDate1Obj.val(_data['agent_start_time'].split(' ')[0]);
				                	_exclusiveDate2Obj.val(_data['agent_end_time'].split(' ')[0]);
				                	//独家方
				                	for(var i in _data['exclusive_name']){
				                		_exclusiveTelObj.val(_data['exclusive_name'][i]).attr('data-id',_data['exclusive_name'][i].split('-')[0]);
				                	};
				                	//独家合同
									var exclusive_img_str = '';
				                	for(var i in _data['exclusive_img']){
                                        exclusive_img_str += '<li><img title="点击查看大图" src="{0}" /><a href="javascript:;" class="delet-pic-btn">删除</a></li>'.stringFormatObj({
						    		        '0': _urlCut + _data['exclusive_img'][i]
						    	        });
				                	};
                                    _imgUploadDujia.html(exclusive_img_str);
				                };
				                
				                //案场人电话
				                var _phoneNum = 0;
				                for(var i in _data['phone']){
				                	if(_phoneNum == 0){
				                		$('#acr_tel_jia').prev().find('input').val(_data['phone'][i]['name']+'-'+_data['phone'][i]['phone']).attr('data-id',_data['phone'][i]['id']);
				                	}else{
				                		$('#acr_tel_jia').before('<div class="form-group phone-list-container"><input type="tel" class="form-control phone_jia" placeholder="请输入" value="{0}" data-id="{1}"><ul></ul><img src="/resource/image/search_gb.png" class="input-cancel-pic"></div>'.stringFormatObj({
				                			'0': _data['phone'][i]['name']+'-'+_data['phone'][i]['phone'],
				                			'1': _data['phone'][i]['id']
				                		}));
				                	};
				                	_phoneNum++;
				                };
				                
				                //盘方
				                var _panfangNum = 0;
				                for(var i in _data['dish_name']){
				                	if(_panfangNum == 0){
				                		$('#pf_tel_jia').prev().find('input').val(_data['dish_name'][i]).attr('data-id',_data['dish_name'][i].split('-')[0]);
				                	}else{
				                		$('#pf_tel_jia').before('<div class="form-group phone-list-container"><input type="tel" class="form-control phone_jia" placeholder="请输入" value="{0}" data-id="{1}"><ul></ul><img src="/resource/image/search_gb.png" class="input-cancel-pic"></div>'.stringFormatObj({
				                			'0': _data['dish_name'][i],
				                			'1': _data['dish_name'][i].split('-')[0]
				                		}));
				                	};
				                	_panfangNum++;
				                };
				                
				                //案场权限人
				                var _acqxNum = 0;
				                for(var i in _data['agents_name']){
				                	if(_acqxNum == 0){
				                		$('#acqx_tel_jia').prev().find('input').val(_data['agents_name'][i]).attr('data-id',_data['agents_name'][i].split('-')[0]);
				                	}else{
				                		$('#acqx_tel_jia').before('<div class="form-group phone-list-container"><input type="tel" class="form-control phone_jia" placeholder="请输入" value="{0}" data-id="{1}"><ul></ul><img src="/resource/image/search_gb.png" class="input-cancel-pic"></div>'.stringFormatObj({
				                			'0': _data['agents_name'][i],
				                			'1': _data['agents_name'][i].split('-')[0]
				                		}));
				                	};
				                	_acqxNum++;
				                };
				                
				                $.each(_yetaiObj, function(i, item) {
				                	~_data['industry_type'].indexOf(item.value) && (item.checked = 'checked');
				                });
				                $.each(_roomTagObj, function(i, item) {
				                	~_data['shop_sign'].indexOf(item.value) && (item.checked = 'checked');
				                });
				                
				                _landlordPhoneObj.val(_data['landlord_phone']);//房东手机号
				                _internalNameObj.val(_data['internal_title']);//对内商铺名称
				                _zujinTypeObj.val(_data['rent_type']);//租金模式
				                _moonPriceObj.val(_data['rent_price']);//月租均价
				                _wuyePriceObj.val(_data['management_fee']);//物业管理费
				                _jinchangPriceObj.val(_data['slotting_fee']);//进场费（转让费）
				                _roomShengyuNumObj.val(_data['residue_num']);//剩余铺数
				                _roomAllNumObj.val(_data['total']);//总铺数
				                _roomArea1Obj.val(_data['shop_area_start']);//商铺面积起始值
				                _businessAreaObj.val(_data['market_area']);//商业面积
        						_provinceInternalObj.val(_data['province']);//对内省
        						_provinceExternalObj.val(_data['province']);//对外省
        						_cityInternalObj.val(_data['city']);//对内市
        						_cityExternalObj.val(_data['city']);//对外市
        						_discInternalObj.val(_data['disc']);//对内区
        						_discExternalObj.val(_data['disc']);//对外区
        						_addressInternalObj.val(_data['internal_address']);//对内详细地址
        						_longitudeObj.val(_data['longitude']),//经度
        						_latitudeObj.val(_data['latitude']),//纬度
				                _trafficObj.val(_data['traffic']);//交通
				                _hasMovedObj.val(_data['enter_num']);//已入住
				                _yingyeTimeObj.val(_data['do_business_date']);//营业时间
				                _kaipanTimeObj.val(_data['opening_date'].split(' ')[0]);//开盘时间
				                _kaiyeTimeObj.val(_data['start_business_date'].split(' ')[0]);//开业时间
				                _hasGasObj.val(_data['is_has_gas']);//是否有燃气
				                _yongjinRuleObj.val(_data['fee_rule']);//佣金规则
				                _internalYoushiObj.val(_data['internal_item_advantage']);//对内项目优势
				                _qianyueRuleObj.val(_data['sign_rule']);//签约规则
				                _weilouLinkObj.val(_data['tiny_brochure_url']);//微楼书
				                _dajiangtangObj.find('iframe').contents().find('body').html(_data['auditorium']);//大讲堂
						    	
								//列表页封面图
        						_imgUploadLiebiao.html('<li><img title="点击查看大图" src="{0}" /><a href="javascript:;" class="delet-pic-btn">删除</a></li>'.stringFormatObj({
						    		'0': _urlCut + _data['cover']
						    	}));
						    	
						    	//详情页轮播图
						    	for(var i in _data['slide_show']){
						    		_imgUploadLunbo.append('<li><img title="点击查看大图" src="{0}" /><a href="javascript:;" class="delet-pic-btn">删除</a></li>'.stringFormatObj({
						    		    '0': _urlCut + _data['slide_show'][i]
						    	    }));
						    	};
						    	
						    	//楼层平面图
						    	for(var i in _data['plan']){
						    		_imgUploadLouceng.append('<li><img title="点击查看大图" src="{0}" /><a href="javascript:;" class="delet-pic-btn">删除</a></li>'.stringFormatObj({
						    		    '0': _urlCut + _data['plan'][i]
						    	    }));
						    	};
						    	
						    	//附件
        						_pdfUploadFujian.html('<li class="pdf-pre-li"><a class="pdf-pre-a" href="{0}" target="_blank" title="点击查看">{1}</a><a href="javascript:;" class="delet-pic-btn">删除</a></li>'.stringFormatObj({
						    		'0': _urlCut + _data['file_path'],
						    		'1': dealFileName(decodeURI(_data['file_path'].slice(_data['file_path'].lastIndexOf('/')+1)))
						    	}));
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
				    	_loadMainItem.hide();
				        if(textStatus === 'timeout'){
				            alert('请求超时');
				        };
				    }
				});
			}else{
				//fn();
			};
			
        	
            
            //图片上传，附件上传处理事件
            $(".upload-image-btn").click(function(){
        		var _this = $(this),
        			_spFile = _this.data('spfile'),
        			_limitTop = _this.data('limittop'),
        			_fileNum = _this.parent().next().find('.delet-pic-btn').length;//根据删除按钮的个数，确定文件的个数
        		
        		if(_limitTop && (_fileNum < _limitTop)){
        			BrowseServer (_this.prev().attr('id'), function(url){
				    	console.log(url);
				    	if(_spFile == 'pdf'){
				    		if(/(\.pdf)$/i.test(url)){
				    			_this.parent().next().prepend('<li class="pdf-pre-li"><a class="pdf-pre-a" href="{0}" target="_blank" title="点击查看">{1}</a><a href="javascript:;" class="delet-pic-btn">删除</a></li>'.stringFormatObj({
						    		'0': url,
						    		'1': dealFileName(decodeURI(url.slice(url.lastIndexOf('/')+1)))
						    	}));
				    		}else{
				    			alert('所选择的格式不是pdf,请重新选择');
				    			return false;
				    		}
				    	}else{
				    		if(/(\.jpg|\.jpeg|\.png|\.gif|\.bmp)$/i.test(url)){
					    		_this.parent().next().prepend('<li><img title="点击查看大图" src="{0}" /><a href="javascript:;" class="delet-pic-btn">删除</a></li>'.stringFormatObj({
						    		'0': url
						    	}));
					    	}else{
					    		alert('所选择的格式不正确,请重新选择');
				    			return false;
					    	}
				    	};
				    });
        		}else{
        			alert('上传上限为  '+_limitTop);
        			return false;
        		};
			});
			
			//图片上传删除键事件
			_doc.on('click','.delet-pic-btn',function(e){
				e.preventDefault();
				e.stopPropagation();
				confirm('确定删除该文件吗？') && $(this).parent().remove();
			});
            
            //图片预览点击放大事件
            _doc.on('click','.img-pre-ul>li>img',function(e){
            	_imgMaskObj.show().find('img').attr('src',this.src);
            });
            _imgMaskObj.click(function(e){
            	this.style.display = 'none';
            });
			/************************************************百度地址定位相关*************************************************************/
			var ulHtml = $('#main_ul>ul'),
				loadItem = $("#loading_pic"),
				noMoreItem = $("#no_more"),
				_inputObj = $('#search_input'),
				valueCurrent = '';
			//初始化,百度地图相关对象
			var LocalSearch = new BMap.LocalSearch(),
				myGeo = new BMap.Geocoder();
			
			$('#position_btn').click(function(){

			});
			
			//搜索地址的回调
			LocalSearch.setSearchCompleteCallback(function(data) {
				if(LocalSearch.getStatus() == BMAP_STATUS_SUCCESS) {
					console.log(data);
					var _html = "";
					for (var i = 0; i < data.getCurrentNumPois(); i ++){
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
					console.log(data);
					if(data['city']){
						_provinceInternalObj.val(data['province']);
						_provinceExternalObj.val(data['province']);
						_cityInternalObj.val(data['city']);
						_cityExternalObj.val(data['city']);
						_discInternalObj.val(data['district']);
						_discExternalObj.val(data['district']);
						var _htmlOri = _this.find('p:nth-of-type(2)').html(),
							_htmlDeal = '',
							_index1 = _htmlOri.indexOf('市'),
							_index2 = _htmlOri.indexOf('区');
						if((_index1 > 0) && (_index2 > 2) && (_index2 > _index1)){
							_htmlDeal = _htmlOri.slice(_index2+1);
						}else{
							_htmlDeal = _htmlOri;
						}
						_addressInternalObj.val(_htmlDeal);
						_longitudeObj.val(_lng);
						_latitudeObj.val(_lat);
//						$('#position_box').hide();
					}else{
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
						console.log(result);
						fn(result['addressComponents']);
					}
				});
			};
			/************************************************百度地址定位相关****结束*************************************************************/
			
			/************省市区选择处理**************/
			//自动获取省列表，并追加后面的市和区
//			getCityDisc({
//				'getType': 'province'
//			},function(_data){
//				var _htmlTemp = '';
//				$.each(_data, function(i, item) {
//              	_htmlTemp += '<option value="{0}">{1}</option>'.stringFormatObj({
//              		'0': item['code'],
//              		'1': item['name']
//              	});
//              });
//          	_provinceInternalObj.html(_htmlTemp).val('310000');
//          	getCityDisc({
//          		'dom': _provinceInternalObj,
//          		'getType': 'city'
//          	}, function(){
//					getCityDisc({
//						'dom': _provinceInternalObj.next(),
//						'getType': 'disc'
//					});
//				});
//			});
//			
//			//获取省市区输入时的真实值和所见值的对应
//			function getText(_domObj, fn){
//				var _arrTemp = _domObj.find('option');
//  			if(_arrTemp.length > 0){
//  				$.each(_arrTemp, function(i, item) {
//      				var _item = $(item);
//						if(_item.val() == _domObj.val()){
//							fn(_item.html());
//							return false;//jq跳出当前循环
//						};
//      			});
//  			}else{
//  				fn('');
//  			};
//  		};
//  		
//  		//对内地址省市区映射到对外地址
//  		function mapInput(){
//  			getText(_provinceInternalObj, function(_text){
//      			_provinceExternalObj.val(_text);
//      		});
//      		getText(_cityInternalObj, function(_text){
//      			_cityExternalObj.val(_text);
//      		});
//      		getText(_discInternalObj, function(_text){
//      			_discExternalObj.val(_text);
//      		});
//      		return false;
//  		};
//			
//			//获取省市区事件封装
//			function getCityDisc(_obj, fn){
//				var _data = {};
//				if(_obj['getType'] != 'province'){
//					if(!!_obj['dom'].val()){
//						_data['parent_code'] = Number(_obj['dom'].val())
//					}else{
//						//处理没有市选项，区选项的内容
//						_obj['dom'].next().html('');
//						fn && fn();
//						return false;
//					};
//				};
//				$.ajax({
//				    type: 'GET',
//				    url: '/index/regions.html',
//				    timeout: 30000,
//				    data: _data,
//				    dataType: 'json',
//				    beforeSend: function() {},
//				    success: function(data) {
//				        if(typeof data === 'object') {
//				            if (data.code == 200) {
//				            	//如果是获取的省列表，直接直接返回数组
//				            	if(_obj['getType'] == 'province'){
//				            		fn(data['data']);
//									return false;
//				            	};
//				                var _htmlTemp = '';
//				                $.each(data['data'], function(i, item) {
//				                	_htmlTemp += '<option value="{0}">{1}</option>'.stringFormatObj({
//				                		'0': item['code'],
//				                		'1': item['name']
//				                	});
//				                });
//				                _obj['dom'].next().html(_htmlTemp);
//				                _obj['getType'] == 'disc' && mapInput();//对内地址省市区映射到对外地址
//				                fn && fn();
//				            }else {
//				                alert(data['msg']);
//				            };
//				        }else{
//				            alert('数据错误');
//				        };
//				    },
//				    error: function() {
//				        alert('error');
//				    },
//				    complete: function(xhr, textStatus){
//				        if(textStatus === 'timeout'){
//				            alert('请求超时');
//				        };
//				    }
//				});
//			};
//			
//			//省选择框事件添加
//			_provinceInternalObj.change(function(){
//				var _this = $(this);
//				getCityDisc({
//					'dom': _this,
//					'getType': 'city'
//				}, function(){
//					getCityDisc({
//						'dom': _this.next(),
//						'getType': 'disc'
//					});
//				});
//			});
//			
//			//市选择框事件添加
//			_cityInternalObj.change(function(){
//				var _this = $(this);
//				getCityDisc({
//					'dom': _this,
//					'getType': 'disc'
//				});
//			});
//			_discInternalObj.change(function(){
//				mapInput();//对内地址省市区映射到对外地址
//			});
			
			/***************************************************省市区选择处理结束************************************************************/
			
			//输入框联系人模糊搜索相关事件添加
			$('.input-add-tel').click(function(){
				var _this = $(this);
				if(_this.parent().find('.phone_jia').length < 5){
					_this.before('<div class="form-group phone-list-container"><input type="tel" class="form-control phone_jia" placeholder="请输入"><ul></ul><img src="/resource/image/search_gb.png" class="input-cancel-pic" /></div>');
				}else{
					alert('最多添加5个');
					return false;
				};
			});
			
			_doc.on('click', '.input-cancel-pic', function(){
				$(this).parent().remove();
			});
			
			_doc.on('click', '.phone-list-container>ul>li', function(){
				var _this = $(this);
				_this.parent().prev().val(_this.html()).attr('data-id',_this.attr('data-id'));
				_this.parent().html('');
			});
			
			var _ajaxObjTel = null;
			_doc.on('input', '.phone_jia' ,function(){
				var _this = $(this),
					_thisVal = $.trim(_this.val());
				_this.removeAttr('data-id');//移除之前携带的信息
				if(_thisVal != ''){
					_ajaxObjTel && _ajaxObjTel.abort();
					_ajaxObjTel = $.ajax({
					    type: 'GET',
					    url: '/index/getBroker_new',
					    data: {
					    	'phone': $.trim(_this.val())
					    },
					    timeout: 30000,
					    dataType: 'json',
					    beforeSend: function() {},
					    success: function(data) {
					        if(typeof data === 'object') {
					            if (data.code == 200) {
					            	if(data['data'].length > 0){
					            		var _htmlTemp = '';
					            		$.each(data['data'], function(i, item) {
						                	_htmlTemp += '<li data-id="{3}">{2}{0}-{1}<li>'.stringFormatObj({
						                		'0': item['name'],
						                		'1': item['phone'],
						                		'2': _this.parent().nextAll('.input-add-tel').data('hideid')?'':(item['id']+'-'),
						                		'3': item['id']
						                	});
						                });
						                _this.next().html(_htmlTemp);
					            	}else{
					            		_this.next().html('');
					            	};
					            }else {
					                alert(data['msg']);
					            };
					        }else{
					            alert('数据错误');
					        };
					    },
					    error: function() {
					        //alert('error');
					    },
					    complete: function(xhr, textStatus){
					        if(textStatus === 'timeout'){
					            alert('请求超时');
					        };
					    }
					});
				};
			});
			
			/***************************************************电话号码输入相关交互处理***************************************************/
			
			/*********************************************是否独家************************************************************/
			//是否独家选择变化事件
			_exclusiveTypeObj.change(function(){
				if($(this).val() == '1'){
					$('.li_dujia_area').css('display','block');
				}else{
					$('.li_dujia_area').hide();
				}
			});
			
			//商铺类型选择变化事件
			_shangpuTypeObj.change(function(){
				if($(this).val() == '1'){
					//街铺
					_jinchangPriceObj.parent().prev().html('转让费');
					$('.shangchang-show-part').hide();
					$.trim(_roomAllNumObj.val()) == '' && _roomAllNumObj.val(1);
					$.trim(_roomShengyuNumObj.val()) == '' && _roomShengyuNumObj.val(1);
				}else{
					//商场
					_jinchangPriceObj.parent().prev().html('进场费');
					$('.shangchang-show-part').show();
				};
			});
			
			//是否显示给C端用户看变化事件
			_showCdObj.change(function(){
				if($(this).val() == '1'){
					//不显示给C端
					$('.show-c-part').hide();
				}else{
					//显示给C端
					$('.show-c-part').show();
				};
			});
			
			//月租均价文件变化事件
			_zujinTypeObj.change(function(){
				var _this = $(this);
				if(_this.val() == '1'){
					_moonPriceObj.prev().hide();
					_moonPriceObj.next().html('元/月');
				}else if(_this.val() == '2'){
					_moonPriceObj.prev().show();
					_moonPriceObj.next().html('%');
				}else if(_this.val() == '3'){
					_moonPriceObj.prev().hide();
					_moonPriceObj.next().html('元/天/㎡');
				}else{
					console.log('other value租金模式');
				};
			});
			
			//保存按钮点击事件
			$('#saveBtn').click(function(e){
				e.preventDefault();
				e.stopPropagation();
				
				//多个input输入框验证标记
				var _isBreakFlag = false;
				//是否给商户公开，是否独家验证是否选择
				$.each([
					_showCdObj,//显示给C端用户看
    				_exclusiveTypeObj,//是否独家
				], function(i,item) {
					if($.trim(item.val()) == ''){
						alert(item.data('alert'));
						_isBreakFlag = true;
						return false;
					};
				});
				if(_isBreakFlag){
					return false;
				};
				
				//验证案场联系人是否填写
				var _acrPhoneArr = [];
				$.each($('#li_acr_phone input'), function(i,item) {
					var _id = item.getAttribute('data-id');
					if(_id !== undefined && _id !== null){
						_acrPhoneArr.push(item.value);
					};
				});
				console.log(_acrPhoneArr);
				if(_acrPhoneArr.length<1){
					alert('案场人电话至少需要选择一个!');
					return false;
				};
				
				//验证盘方是否填写
				var _pfPhoneArr = [];
				$.each($('#li_pf_phone input'), function(i,item) {
					var _id = item.getAttribute('data-id');
					if(_id !== undefined && _id !== null){
						_pfPhoneArr.push(_id);
					};
				});
				if(_pfPhoneArr.length<1){
					alert('盘方至少需要选择一个!');
					return false;
				};
				
				//验证案场权限人是否填写
				var _acqxPhoneArr = [];
				$.each($('#li_acqx_phone input'), function(i,item) {
					var _id = item.getAttribute('data-id');
					if(_id !== undefined && _id !== null){
						_acqxPhoneArr.push(_id);
					};
				});
				if(_acqxPhoneArr.length<1){
					alert('案场权限人至少需要选择一个!');
					return false;
				};
				
				//业态验证
				var _yetaiArr = [];
				$.each($('.yetai'), function(i, item) {
					item.checked && _yetaiArr.push(item.value);
				});
				if(_yetaiArr.length<1){
					alert('业态至少需要填写一个!');
					return false;
				};
				
				//商铺标签验证
				var _roomTagArr = [];
				$.each($('.roomTag'), function(i, item) {
					item.checked && _roomTagArr.push(item.value);
				});
				if(_roomTagArr.length<1){
					alert('商铺标签至少需要填写一个!');
					return false;
				};
				
				var _landlordPhoneVal = $.trim(_landlordPhoneObj.val());
				if(_landlordPhoneVal == ''){
					alert('请输入房东手机号码');
					return false;
				}else if(!/^[1][0-9]{10}$/.test(_landlordPhoneVal)){
					alert('输入的房东手机号格式有误');
					return false;
				}
				
				//多个input输入框验证
				$.each([
					_internalNameObj,//对内商铺名称
					_foreignNameObj,//对外商铺名称
					_moonPriceObj,//月租均价
					_wuyePriceObj,//物业管理费
					_jinchangPriceObj,//进场费
					_roomShengyuNumObj,//剩余铺数
					_roomAllNumObj,//总铺数
					_roomArea1Obj,//商铺面积起始值
					_roomArea2Obj,//商铺面积结束值
					_businessAreaObj,//商业面积
					_addressInternalObj,//对内地址详细地址
					_longitudeObj,//经度
					_latitudeObj,//纬度
					_addressExternalObj,//对外地址详细地址
					_trafficObj,//交通
					_hasMovedObj,//已入住
					_yingyeTimeObj,//营业时间
					_kaipanTimeObj,//开盘时间
					_kaiyeTimeObj,//开业时间
					_yongjinRuleObj,//佣金规则
					_internalYoushiObj,//对内项目优势
					_foreignYoushiObj,//对外项目优势
					_qianyueRuleObj//签约规则
					//_weilouLinkObj//微楼书不是必填项,
				], function(i,item) {
					if((item === _foreignNameObj || item === _addressExternalObj || item === _foreignYoushiObj) && (_showCdObj.val() == '1')){
						console.log('不显示给商户C端看的时候，对外名称，对外地址，对外项目优势  不需要填写');
					}else if(item === _roomArea2Obj){
						if(_shangpuTypeObj.val() == '0'){
							if(_roomArea2Obj.val() == ''){
								alert(item.data('alert'));
								_isBreakFlag = true;
								return false;
							}else if(Number(_roomArea1Obj.val()) > Number(_roomArea2Obj.val())){
								alert('商铺面积范围下限不能大于上限');
								_isBreakFlag = true;
								return false;
							};
						}else{
							console.log('所选为街铺时，商铺面积上限值不需要验证');
						}
					}else{
						if($.trim(item.val()) == ''){
							alert(item.data('alert'));
							_isBreakFlag = true;
							return false;
						};
					}
				});
				if(_isBreakFlag){
					return false;
				};
				
				//列表页封面图验证是否上传
				var _liebiaoPicObj = _imgUploadLiebiao.find('li>img');
				if(_liebiaoPicObj.length < 1){
					alert('列表页封面图需要上传');
					return false;
				};
				//详情页轮播图验证是否上传
				var _xiangqingPicObj = _imgUploadLunbo.find('li>img');
				if(_xiangqingPicObj.length < 6){
					alert('详情页轮播图至少需要6张');
					return false;
				};
				var _loucengPicObj = _imgUploadLouceng.find('li>img');
				var _fujianObj = _pdfUploadFujian.find('li>a.pdf-pre-a');//附件看的是删除按钮的个数
				var _dujiaPicObj = _imgUploadDujia.find('li>img');
				
				//大讲堂验证
				var _dajiangtangVal = _dajiangtangObj.find('iframe').contents().find('body').html();
				//大讲堂不是必填项
//				if(_dajiangtangVal == '' || _dajiangtangVal == '<p><br></p>' || _dajiangtangVal == '<p><br /></p>' || _dajiangtangVal == '<p></p>'){
//					alert('请填写大讲堂内容！');
//					return false;
//				};
				
				//如果选择了独家，验证独家代理有效期，独家方是否填写,独家合同是否上传
				if(_exclusiveTypeObj.val() == '1'){
					if(_exclusiveDate1Obj.val() == '' || _exclusiveDate2Obj.val() == ''){
						alert('请填写独家代理有效期！');
						return false;
					}else if((new Date(_exclusiveDate1Obj.val()).getTime()) > (new Date(_exclusiveDate2Obj.val()).getTime())){
						alert('独家代理有效期开始时间不能大于结束时间！');
						return false;
					}
					if(_exclusiveTelObj.attr('data-id') == undefined || _exclusiveTelObj.attr('data-id') == null){
						alert('请填写独家方!');
						return false;
					};
					if(_dujiaPicObj.length < 1){
						alert('独家合同需要上传');
						return false;
					};
				};
				
				var _data = {
					'shop_type': _shangpuTypeObj.val(),
					'is_show': _showCdObj.val(),
					'is_exclusive_type': _exclusiveTypeObj.val(),
					'agent_dish': _pfPhoneArr.join(','),
					'agent_data': _acqxPhoneArr.join(','),
					'internal_title': $.trim(_internalNameObj.val()),
					'landlord_phone': _landlordPhoneVal,
					'rent_type': _zujinTypeObj.val(),
					'rent_price': _moonPriceObj.val(),
					'management_fee': _wuyePriceObj.val(),
					'slotting_fee': _jinchangPriceObj.val(),
					'residue_num': _roomShengyuNumObj.val(),
					'total': _roomAllNumObj.val(),
					'shop_area_start': _roomArea1Obj.val(),
					'market_area': _businessAreaObj.val(),
					'province': _provinceInternalObj.val(),
					'city': _cityInternalObj.val(),
					'disc': _discInternalObj.val(),
					'internal_address': $.trim(_addressInternalObj.val()),
					'longitude': _longitudeObj.val(),
					'latitude': _latitudeObj.val(),
					'traffic': $.trim(_trafficObj.val()),
					'enter_num': $.trim(_hasMovedObj.val()),
					'do_business_date': $.trim(_yingyeTimeObj.val()),
					'opening_date': _kaipanTimeObj.val(),
					'start_business_date': _kaiyeTimeObj.val(),
					'is_has_gas': _hasGasObj.val(),
					'fee_rule': $.trim(_yongjinRuleObj.val()),
					'internal_item_advantage': $.trim(_internalYoushiObj.val()),
					'sign_rule': $.trim(_qianyueRuleObj.val()),
					'tiny_brochure_url': $.trim(_weilouLinkObj.val()),
					'auditorium': _dajiangtangVal,
					'industry_type': _yetaiArr.join(','),
					'shop_sign': _roomTagArr.join(',')
				};
				if(_shangpuTypeObj.val() == '0'){
					_data['shop_area_end'] = _roomArea2Obj.val();
				};
				if(_showCdObj.val() == '0'){
					_data['external_title'] = $.trim(_foreignNameObj.val());
					_data['external_address'] = $.trim(_addressExternalObj.val());
					_data['external_item_advantage'] = $.trim(_foreignYoushiObj.val());
				};
				if(_showCdObj.val() == '0'){
					_data['external_title'] = $.trim(_foreignNameObj.val());
					_data['external_address'] = $.trim(_addressExternalObj.val());
					_data['external_item_advantage'] = $.trim(_foreignYoushiObj.val());
				};
				if(_exclusiveTypeObj.val() == '1'){
					_data['agent_start_time'] = _exclusiveDate1Obj.val();
					_data['agent_end_time'] = _exclusiveDate2Obj.val();
					_data['exclusive_ids'] = _exclusiveTelObj.attr('data-id');
					$.each(_dujiaPicObj, function(i, item) {
						_data['exclusive_img['+i+']'] = item.src.replace(_urlCut ,'');
					});
				};
				
				$.each(_acrPhoneArr, function(i, item) {
					_data['phone['+i+']'] = item;
				});
				$.each(_liebiaoPicObj, function(i, item) {
					_data['cover['+i+']'] = item.src.replace(_urlCut ,'');
				});
				$.each(_xiangqingPicObj, function(i, item) {
					_data['slide_show['+i+']'] = item.src.replace(_urlCut ,'');
				});
				$.each(_loucengPicObj, function(i, item) {
					_data['plan['+i+']'] = item.src.replace(_urlCut ,'');
				});
				if(_fujianObj.length === 1){
					_data['file_path'] = _fujianObj[0].href.replace(_urlCut ,'');//附件取得是herf值
				};
				_id != null && (_data['id'] = _id);//当为编辑时，要传入id
				$.ajax({
				    type: 'POST',
				    url: '/index/houseEdit',
				    data: _data,
				    timeout: 30000,
				    traditional: true,
				    dataType: 'json',
				    beforeSend: function() {
				    	_loadMainItem.show();
				    },
				    success: function(data) {
				        if(typeof data === 'object') {
				            if (data.code == 200) {
				                alert('添加成功!');
				                location.replace('/admin.php/index/houseList.html');
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
				    	_loadMainItem.hide();
				        if(textStatus === 'timeout'){
				            alert('请求超时');
				        };
				    }
				});
			});
        }
    };
    return user;
});