<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/5/2
 */

namespace app\api\untils;


use think\Loader;

define ('TL_GETUI_APPID','UxO33Kczag58ntwp8OunO3');
define ('TL_GETUI_APPSECRET','brh7xQfUskAjeevTOx33r');
define ('TL_GETUI_APPKEY','Po2cPI5dfu54JcPoT4rvO4');
define ('TL_GETUI_MASTERSECRET','HP0wN3hHVm9LbxW3lkqUo4');
define ('TL_GETUI_HOST','http://sdk.open.api.igexin.com/apiex.htm');

class GeTuiUntils {

    public function __construct()
    {
        include_once(EXTEND_PATH.'getuiSdk'.DS.'IGt.Push.php');
    }

    /**
     * 个推
     * @param $touchuan
     * @param $black_title
     * @param $content
     * @return array
     */
    public function push_message_for_one($data)
    {
        $cid = $data['device_id'];

        $igt = new \IGeTui(TL_GETUI_HOST, TL_GETUI_APPKEY, TL_GETUI_MASTERSECRET);
        //模板
        $template = $this->onli_all_template($data['touchuan'], $data['black_title'],$data['content']);

        //个推信息体
        $message = new \IGtSingleMessage();
        $message->set_isOffline(true); //是否离线
        $message->set_offlineExpireTime(3600 * 12 * 1000); //离线时间
        $message->set_data($template); //设置推送消息类型
        $message->set_PushNetWorkType(0);//设置是否根据WIFI推送消息，1为wifi推送，0为不限制推送
        //接收方
        $target = new \IGtTarget();
        $target->set_appId(TL_GETUI_APPID);
        $target->set_clientId($cid);
        try {
            $rep = $igt->pushMessageToSingle($message, $target);
        } catch (RequestException $e) {
            $requstId = $e . getRequestId();
            $rep = $igt->pushMessageToSingle($message, $target, $requstId);
        }

        return $rep;
    }


    /**
     * 群推
     */
    function push_message_for_all($data)
    {
        $igt = new \IGeTui(TL_GETUI_HOST, TL_GETUI_APPKEY, TL_GETUI_MASTERSECRET);

        $template = $this->onli_all_template($data['touchuan'], $data['black_title'], $data['content']);
        //个推信息体
        //基于应用消息体
        $message = new \IGtAppMessage();
        $message->set_isOffline(true);
        $message->set_offlineExpireTime(3600 * 12 * 1000);//离线时间单位为毫秒，例，两个小时离线为3600*1000*2
        $message->set_data($template);
        $message->set_PushNetWorkType(0);//设置是否根据WIFI推送消息，1为wifi推送，0为不限制推送
        //$message->set_speed(1);// 设置群推接口的推送速度，单位为条/秒，例如填写100，则为100条/秒。仅对指定应用群推接口有效。
        $appIdList = array(TL_GETUI_APPID);
        $message->set_appIdList($appIdList);
        $rep = $igt->pushMessageToApp($message);
        return $rep;
    }

    /**
     * 推送模板
     */
    function onli_all_template($touchuan, $black_title, $content)
    {

        $template = new \IGtTransmissionTemplate();
        $template->set_appId(TL_GETUI_APPID);//应用appid
        $template->set_appkey(TL_GETUI_APPKEY);//应用appkey
        $template->set_transmissionType(2);//透传消息类型
        $template->set_transmissionContent($touchuan);   //透传内容

        //APN高级推送
        $apn = new \IGtAPNPayload();
        $alertmsg = new \DictionaryAlertMsg();
        $alertmsg->body = $content;//对应的是在线透传的content
        $alertmsg->actionLocKey = "打开嗨房";//滑动打开app
        $alertmsg->locKey = $content;//锁屏提示下框
        $alertmsg->title = $black_title;//标题 锁屏标题
        $alertmsg->titleLocKey = $black_title;//下拉通知上部框框
        $alertmsg->titleLocArgs = array("TitleLocArg");

        $apn->alertMsg = $alertmsg;
        $apn->badge = 1;//应用icon上显示的数字
        $apn->sound = "";
        $template->set_apnInfo($apn);
        return $template;
    }

    /**
     * 对某个人推送消息-公共
     *
     * @param $id
     * @param $device_id
     * @param $title
     * @param $content
     * @return array|void
     */
    function public_push_message_for_one($id, $device_id, $title, $content, $type, $token='',$nickname='')
    {
        $home_url = $this->http_host();
        $data['agent_id']    = $id;
        $data['black_title'] = $title;
        $data['content']     = $content;
        $data['device_id'] = $device_id;
        $data['touchuan'] = json_encode(array(
            'title'    => $title,
            'content'  => $content,
            'type'     => $type,
            'url'      => '',
            'name'     => $title,
            'id'       => '69',
            'token'    => $token,
            'nickname' => $nickname,
            'imageUrl' => $home_url .'/notice_android_logo.png'));
        return $this->push_message_for_one($data);
    }

    public function http_host()
    {
        $http_type =
            ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') || (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) &&
                    $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')) ? 'https://' : 'http://';
        $host = $http_type . $_SERVER['HTTP_HOST'];
        return $host;
    }


    //https请求(支持GET和POST)
    function http_request($url, $data = null)
    {
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
        curl_setopt($curl, CURLOPT_POST, 1);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        $result = curl_exec($curl);
        if (curl_errno($curl)) {
            return 'Errno' . curl_error($curl);
        }
        curl_close($curl);
        return $result;
    }
}