/**
 * Created by zw on 2017/12/15.
 */
define (['doT', 'text!temp/setting_template_tpl.html', 'css!style/home.css'], function (doT, template) {
    var Setting = {

        init: function () {
            //初始化dot
            $ ("body").append (template);
            Setting.event ();
            Setting.getInfo();
        },
        event: function () {
            $("#save").click(function () {
                Setting.saveSetting();
            });
        },
        getInfo: function () {
            var param = {};
            $.ajax ({
                url: '/admin.php/index/getSetting',
                type: 'GET',
                async: true,
                data: param,
                dataType: 'json',
                success: function (data) {
                    console.log (data.data);
                    var temp = document.getElementById ('setting_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#info").html (doTtmpl (data.data));
                }
            });
        },
        saveSetting : function () {
            var param = {};
            param.is_privacy= $("input[type='radio']:checked").val();
            param.day_num= $("input[name='day_num']").val();
            $.ajax ({
                url: '/admin.php/index/getSetting',
                type: 'POST',
                async: true,
                data: param,
                dataType: 'json',
                success: function (data) {
                    if (data.code == 200) {
                        Setting.getInfo();
                        alert('添加成功');
                    } else {
                        alert('操作失败');
                    }
                }
            });
        }
    };
    return Setting;
});
