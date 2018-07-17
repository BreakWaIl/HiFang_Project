/**
 * Created by zw on 2017/12/15.
 */
define(['doT', 'text!temp/version_template_tpl.html', 'ckfinder', 'ckfinderStart', 'css!style/home.css'],
    function (doT, template) {
    var Version = {

        init: function () {
            //初始化dot
            $("body").append(template);
            Version.getVersion();
            Version.getVersionList();
            Version.event();
        },
        event: function () {
            /*上传图片控件*/
            /*     $ (".banner_img").click (function () {
                     BrowseServer ('cover_image');
                 });*/


            $("#save").click(function () {
                var params = {};

                params.type = $("input[name = optionsRadios]:checked").val();
                params.version_no = $("#version_no").val();
                params.app_path = $("#cover_image").val();
                params.intro = $("#intro").val();

                if (!params.type || params.type == null) {
                    alert("类型不能为空");
                    return false;
                }
                if (!params.version_no || params.version_no == null) {
                    alert("版本号不能为空");
                    return false;
                }
                if (params.type === 0 || params.type === 2 && params.app_path == null || !params.version_no) {
                    alert("下载地址不能为空");
                    return false;
                }
                Version.addVersion(params);
            });

            $("input[name=optionsRadios]").click(function () {
                var val = $("input[name = optionsRadios]:checked").val();
                if (val == 1 || val == 3) {
                    $(".show_select_page").hide();
                } else {
                    $(".show_select_page").show();
                }
                Version.getVersion();
            });

        },
        getVersion: function () {
            var param = {};
            param.type = $("input[name = optionsRadios]:checked").val();
            $.ajax({
                url: '/admin.php/admin/version/getVersionNo',
                type: 'POST',
                async: true,
                data: param,
                dataType: 'json',
                success: function (data) {
                    console.log(data);
                    if (data.data) {
                        $("#now_version").html(data.data['version_no']);
                    } else {
                        $("#now_version").html("暂未获取到最新版本号");
                    }
                }

            });

        },
        getVersionList: function (pageNo) {

            $.ajax({
                url: '/admin.php/admin/version/getVersionList',
                type: 'POST',
                async: true,
                data: {},
                dataType: 'json',
                success: function (data) {
                     console.log(data.data);
                    var objj=JSON.parse(data);
                    var temp = document.getElementById('version_list_tpl').innerHTML;
                    var doTtmpl = doT.template(temp);
                    $("#sublet_list").html(doTtmpl(objj.data));
                }

            });
        },
        addVersion: function (params) {
            $.ajax({
                url: '/admin.php/admin/version/addVersion',
                type: 'POST',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    if (data.code == "101") {
                        alert(data.msg);
                        return false;
                    } else {
                        window.location.reload(true);
                    }

                }

            });

        },
        /*deleteBanner: function (params) {
            $.ajax({
                url: '/admin.php/index/upIsShow',
                type: 'POST',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    $("#modal-delete").modal('hide');
                    if (data.code == "101") {
                        alert(data.msg);
                        return false;
                    }
                    banner.getBannerList(banner.pageNo);
                }

            });
        }*/
    };
    return Version;
});
