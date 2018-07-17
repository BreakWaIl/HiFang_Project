/* auth 2018/01/23 by dafei
 */
define (['doT', 'text!temp/access_template_tpl.html', 'css!style/home.css','pagination','bootstrapJs'], function (doT, template) {
    var Role = {
        init: function () {
            //初始化dot
            $ ("body").append (template);
            Role.getList ();
            Role.event ();

        },
        event: function () {
            var id=  getUrlParam('id');
            $ ("#submit").click(function () {
                var par={}
                var v='';
                $("input[name=rules]:checked").each(function (i) {
                   v+= $(this).val()+',';

                })

                console.log(v);
                $.ajax({
                    url: '/index/updateAccess',
                    data:{'rules':v,'id':id},
                    type: 'post',
                    async: true,
                    dataType: 'json',
                    success: function (data) {
                        alert(data.msg);
                        console.log(data);
                    }

                });

            })
        },
        getList: function(){
            //ajax
            var id=  getUrlParam('id');
            $.ajax({
                url: '/index/accessLook/group_id/'+id,
                type: 'post',
                async: true,
                dataType: 'json',
                success: function (data) {
                    var temp=document.getElementById('access_tpl').innerHTML;
                    var doTempl=doT.template(temp);
                    $("#access_box").html(doTempl(data.data.class));
                    $("#href2").attr('href','/index/access?id='+id);
                    $("#href1").attr('href','/index/roleedit?id='+id);
                }
            })

        }
    }
    return Role;
});
