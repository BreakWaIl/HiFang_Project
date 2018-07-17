/**
 * Created by 刘丹 on 2017/12/11.
 */
define (['css!style/home.css','bootstrapJs'], function () {
    var home = {
        init: function () {
            //初始化dot
            home.ldClick=sessionStorage.getItem("navclick");
            home.event ();

        },
        event: function () {

            if(home.ldClick!==null){
                $('#sidebar-wrapper ul li:nth-child('+(Number(home.ldClick)+1)+') a').addClass("clickbg");
                $('#sidebar-wrapper ul li:nth-child('+(Number(home.ldClick)+1)+')').siblings().find("a").removeClass("clickbg");
            }else{
                $('#sidebar-wrapper ul li:nth-child(1) a').addClass("clickbg");
                $('#sidebar-wrapper ul li:nth-child(1)').siblings().find("a").removeClass("clickbg");
            }



            $('#sidebar-wrapper ul li').click(function () {
                sessionStorage.setItem("navclick",$(this).index());
            });
        }
    }
    return home;
});
