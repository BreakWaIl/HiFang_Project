/* auth 2018/01/23 by dafei
 */
define (['doT', 'css!style/home.css','pagination','bootstrapJs'], function (doT, template) {
    var navbar = {
        init: function () {
            //初始化dot
            $ ("body").append (template);
            navbar.getList ();
            navbar.event ();

        },
        event: function () {

        },
        getList: function(){



        }
    }
    return navbar;
});