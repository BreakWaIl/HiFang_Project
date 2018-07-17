/**
 * Created by zw on 2017/12/15.
 */
define (['doT', 'text!temp/banner_template_tpl.html', 'ckfinder', 'ckfinderStart', 'css!style/home.css', 'blow-up'], function (doT, template) {
    var banner = {
        pageNo: 1, /*第几页*/
        pageSize: 15, /*每页显示多少条*/
        datas: "",
        init: function () {
            //初始化dot
            $ ("body").append (template);
            banner.event ();
            banner.getBannerList (1);
        },
        event: function () {
            /*上传图片控件*/
            $ (".banner_img").click (function () {
                BrowseServer ('cover_image');
            });

            $ ("#add_banner").on ("click", function () {
                $ ("#editor_modal_title").html ("添加广告");
                $ ("#id").val ("");
                $ ("#title").val ("");
                $ ("#url").val ("");
                $ ("#cover_image").val ("");
                $ ("#sort").val ("");
            })

            $ ("#save_banner").click (function () {
                var params = {};

                params.title = $ ("#title").val ();
                params.url = $ ("#url").val ();
                params.cover_image = $ ("#cover_image").val ();
                params.sort = $ ("#sort").val ();

                var banner_type = $("input[name=banner_type]:checked").val();
                var page_type = $("#type").val();
                if(page_type == 0 && banner_type == 0 ){
                    params.type = 0;
                }else if(page_type == 0 && banner_type == 1 ){
                    params.type = 2;
                }else if(page_type == 1 && banner_type == 0 ){
                    params.type = 1;
                }else if(page_type == 1 && banner_type == 1 ){
                    params.type = 3;
                }

                if (!params.title || params.title == null) {
                    alert ("banner名称不能为空");
                    return false;
                }
                if (!params.url || params.url == null) {
                    alert ("url不能为空");
                    return false;
                }
                if (!params.cover_image || params.cover_image == null) {
                    alert ("banner图片不能为空");
                    return false;
                }
                if (!params.sort || params.sort == null) {
                    alert ("banner排序不能为空");
                    return false;
                }
                if ($ ("#id").val ()) {
                    params.id = $ ("#id").val ();
                }

                banner.addOrUpdateBanner (params);
            });
            $ ("#confirm_delete").click (function () {
                var params = {};
                params.id = $ ("#delete_id").val ();
                params.is_show = 1;
                if (!params.id || params.id == null) {
                    alert ("要删除的id不能为空");
                    return false;
                }
                banner.deleteBanner (params);
            });

            $ (document).delegate (".editor_banner", "click", function () {
                $ ("#editor_modal_title").html ("编辑广告");
                var item = $ (this).parents ("tr").find ("td");
                $ ("#id").val ($ (this).attr ("data-id"));
                $ ("#title").val (item.eq (0).html ());
                $ ("#url").val (item.eq (2).html ());
                $ ("#cover_image").val (item.eq (1).find ("input").val ());
                $ ("#sort").val (item.eq (3).html ());
            });

            $ (document).delegate (".delete_banner", "click", function () {
                $ ("#delete_id").val ($ (this).attr ("data-id"));
            });
        },
        /*获取banner list*/
        getBannerList: function (pageNo) {
            banner.pageNo = pageNo;

            var params = {};
            params.pageNo = banner.pageNo;
            params.pageSize = banner.pageSize;
            var url = '';
            var requestPath = window.location.pathname;
            if(requestPath.indexOf("advertising") > 0  ){
                url = '/admin.php/index/getPopList';
            }else{
                url = '/admin.php/index/bannerList';
            }
            $.ajax ({
                url: url,
                type: 'POST',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    var temp = document.getElementById ('banner_list_tpl').innerHTML;
                    var doTtmpl = doT.template (temp);
                    $ ("#banner_list").html (doTtmpl (data.data.list));
                    /*分页代码*/
                    $ ("#pagediv").pagination ({
                        length: data.data.total,
                        current: pageNo,
                        every: banner.pageSize,
                        onClick: function (el) {
                            banner.getBannerList (el.num.current);
                        }
                    });
                    $ ('.J_preview').preview ();
                }

            });
        },
        addOrUpdateBanner: function (params) {
            $.ajax ({
                url: '/admin.php/index/addOrSave',
                type: 'POST',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    $ ("#modal-add-do").modal ('hide');
                    if (data.code == "101") {
                        alert (data.msg);
                        return false;
                    }
                    banner.getBannerList (banner.pageNo);
                }

            });

        },
        deleteBanner: function (params) {
            $.ajax ({
                url: '/admin.php/index/upIsShow',
                type: 'POST',
                async: true,
                data: params,
                dataType: 'json',
                success: function (data) {
                    $ ("#modal-delete").modal ('hide');
                    if (data.code == "101") {
                        alert (data.msg);
                        return false;
                    }
                    banner.getBannerList (banner.pageNo);
                }

            });
        }
    };
    return banner
});
