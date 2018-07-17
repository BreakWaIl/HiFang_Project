define(['doT', 'jquery'], function (doT, $) {
    var init = {
        doTinit: function () {
            doT.templateSettings = {
                evaluate: /\[\%([\s\S]+?)\%\]/g,
                interpolate: /\[\%=([\s\S]+?)\%\]/g,
                encode: /\[\%!([\s\S]+?)\%\]/g,
                use: /\[\%#([\s\S]+?)\%\]/g,
                define: /\[\%##\s*([\w\.$]+)\s*(\:|=)([\s\S]+?)#\%\]/g,
                conditional: /\[\%\?(\?)?\s*([\s\S]*?)\s*\%\]/g,
                iterate: /\[\%~\s*(?:\%\]|([\s\S]+?)\s*\:\s*([\w$]+)\s*(?:\:\s*([\w$]+))?\s*\%\])/g,
                varname: 'it',
                strip: true,
                append: true,
                selfcontained: false
            };
        }
    };
    init.doTinit();
    var pageId = $('.page-load').attr('id');
    loadJSFile(pageId);
    function loadJSFile(pageId) {
        require(['app/' + pageId], function (dataObj) {
            dataObj.init();
        });
    }

});
function getUrlParam(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = decodeURI(window.location.search).substr(1).match(reg);
    if(r != null) return unescape(r[2]);
    return null;
}

//字符串格式化
String.prototype.stringFormat = function(){
    var formatted = this;
    for(var i = 0;i < arguments.length;i++){
        formatted = formatted.replace(new RegExp('\\{'+ i + '\\}','gi'), arguments[i]);
    };
    return formatted;
}

//字符串格式化,参数为对象的形式 by xishifeng 2017-07-14
String.prototype.stringFormatObj = function(){
    var formatted = this;
    for(var i in arguments[0]){
        formatted = formatted.replace(new RegExp('\\{'+ i + '\\}','gi'), arguments[0][i]);
    };
    return formatted;
};