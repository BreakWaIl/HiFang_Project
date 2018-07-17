$(function(){
	var _loginBtn = $('#btn_login'),
		_loginTempBtn = $('#btn_login_temp');
    $('.input-area>input').focus(function(){
    	$(this).parent().addClass('input-area-active');
    }).blur(function(){
    	$(this).parent().removeClass('input-area-active');
    });

    //回车按键
    $(document).keypress(function(event){
        var keynum = (event.keyCode ? event.keyCode : event.which);
        if(keynum == '13'){
            _loginBtn.click();
        }
    });

    _loginBtn.click(function(e){
    	e.preventDefault();
    	e.stopPropagation();
    	var _userName = $.trim($('#username').val()),
    		_passWord = $.trim($('#passwd').val());
    		
    	if(_userName == ''){
    		alert('请输入用户名');
    		return false;
    	};
    	if(_passWord == ''){
    		alert('请输入登录密码');
    		return false;
    	};
    	$.ajax({
    	    type: 'POST',
    	    url: '/admin.php/index/loginVerify',
    	    data: {
    	    	'username': _userName,
    	    	'passwd': _passWord
    	    },
    	    timeout: 30000,
    	    dataType: 'json',
    	    beforeSend: function() {
    	    	_loginBtn.hide();
    	    	_loginTempBtn.show();
    	    },
    	    success: function(data) {
    	        if(typeof data === 'object') {
    	            if (data.code == 200) {
                        localStorage.setItem('user_info', JSON.stringify(data.data));
    	                location.href = '/admin.php/index/banner';
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
    	    	_loginTempBtn.hide();
    	    	_loginBtn.show();
    	        if(textStatus === 'timeout'){
    	            alert('请求超时');
    	        };
    	    }
    	});
    })
});