function BrowseServer(input_image,fun )
{

    var finder = new CKFinder();
    finder.basePath = '../';
    finder.selectActionFunction = SetFileField;

    finder.selectActionData = input_image;
    if($.isFunction(fun)){
        window.browseServerBackFun = fun;
    }

    finder.popup();
}
function getCKeditorValue(id){
    return CKEDITOR.instances[id].getData();
}
function setCKeditorValue(id,content){
    return CKEDITOR.instances[id].setData(content);
}
function SetFileField( fileUrl , data )
{
    split = '\/Attachments\/';
    pic = fileUrl.split(split);
    if(!!pic[1]){
        document.getElementById( (data["selectActionData"] )).value = pic[1];
    }

    if($.isFunction(window.browseServerBackFun)){
    	if(~location.protocol.indexOf(fileUrl)){
    		//一致
    	}else{
    		fileUrl = fileUrl.replace(/(http|https):\/\//g,location.protocol+'//');
    	}
        window.browseServerBackFun(fileUrl);
    }
}

function get_vid_val () {
    var vid = $ ('input.vid:checked');
    if (vid.length) {
        var ids = '';
        $.each (vid, function (index) {
            ids += ',' + vid[index].value;
        });
        return ids.substr (1);
    } else {
        return false;
    }
}

function get_url () {
    var $protocol = location.protocol + '//';
    var $path = location.pathname;
    var $hostname = location.hostname;
    return $protocol + $hostname + $path;
}


