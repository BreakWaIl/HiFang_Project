/* auth 2018/01/23 by dafei
 */
define (['doT', 'css!style/home.css','pagination','bootstrapJs'], function (doT, template) {
    var Role = {
            init: function () {
            //初始化dot
            $ ("body").append (template);
            Role.getList ();
            Role.event ();

        },
        event: function () {
            $("#submit").click(function(){
                var par={}
                par.id= $("input[name = id]").val();
                par.title=$("input[name =title]").val();
                par.description=$("input[name =description]").val();
                $.ajax({
                    url: '/index/addAuth',
                    data:par,
                    type: 'post',
                    async: true,
                    dataType: 'json',
                    success: function (data) {
                        alert(data.msg);
                        console.log(data);
                    }

                });

            });
        },
        getList: function(){
            //ajax
          var id=  getUrlParam('id');
            //判断是否有id参数
            if(!id){
                $("#li2").hide();
                $("#li3").hide();
                return false;
            }
            $.ajax({
                url: '/index/addAuth/'+id,
                type: 'post',
                async: true,
                dataType: 'json',
                success: function (data) {
                    $("input[name = id]").val(data.data.id);
                    $("input[name = title]").val(data.data.title);
                    $("#description").val(data.data.description);
                }
            })
            
        }
    }
    return Role;
});




