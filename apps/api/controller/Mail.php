<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/6/25
 * Time: 10:29
 */
namespace app\api\controller;

use phpmailer\phpmailer;
use think\Db;
use think\Log;

class Mail
{
    public static function addData($member_id, $video_id){
        $data['id']        = 0;
        $data['member_id'] = $member_id;
        $data['video_id']  = $video_id;
        $data['type']      = 1;
        $data['create_time'] = time();
        $data['update_time'] = time();
        //存入yf_hf_phpmailer
        $res = Db::table('yf_hf_phpmailer')->insert($data);
        if ($res) {
            return true;
        } else {
            return false;
        }
    }
    //qq
    public function index(){
        $phpmailer = Db::table('yf_hf_phpmailer')->order('id','desc')->select()[0];
        Log::info("=======mail/phpmailer=========");
        Log::info($phpmailer);
        if ($phpmailer) {
            Log::info("=======mail/index=========");
            $sendmail = '1849551489@qq.com'; //发件人邮箱
            $sendmailpswd = "xmyoockqpyipegch"; //客户端授权密码,而不是邮箱的登录密码！
            $send_name = 'nothing';// 设置发件人信息，如邮件格式说明中的发件人，
            $toemail = '1695477218@qq.com';//定义收件人的邮箱
            $to_name = '11';//设置收件人信息，如邮件格式说明中的收件人
            Log::info("=======toemail=========".$toemail);
            $mail = new PHPMailer();
            $mail->isSMTP();// 使用SMTP服务
            $mail->CharSet = "utf8";// 编码格式为utf8，不设置编码的话，中文会出现乱码
            $mail->Host = "smtp.qq.com";// 发送方的SMTP服务器地址smtp.exmail.qq.com
            $mail->SMTPAuth = true;// 是否使用身份验证
            $mail->Username = $sendmail;//// 发送方的
            $mail->Password = $sendmailpswd;//客户端授权密码,而不是邮箱的登录密码！
            $mail->SMTPSecure = "ssl";// 使用ssl协议方式
            $mail->Port = 465;//  qq端口465或587）
            $mail->setFrom($sendmail,$send_name);// 设置发件人信息，如邮件格式说明中的发件人，
            $mail->addAddress($toemail,$to_name);// 设置收件人信息，如邮件格式说明中的收件人，
            $mail->addReplyTo($sendmail,$send_name);// 设置回复人信息，指的是收件人收到邮件后，如果要回复，回复邮件将发送到的邮箱地址
            //$mail->addCC("xxx@qq.com");// 设置邮件抄送人，可以只写地址，上述的设置也可以只写地址(这个人也能收到邮件)
            //$mail->addBCC("xxx@qq.com");// 设置秘密抄送人(这个人也能收到邮件)
            //$mail->addAttachment("bug0.jpg");// 添加附件
            $mail->Subject = "您有待审核的视频,请及时审核";// 邮件标题
            $mail->Body = "您有待审核的视频,请及时审核,点击进入: https://hifang.fujuhaofang.com/ ";// 邮件正文
            //$mail->AltBody = "This is the plain text纯文本";// 这个是设置纯文本方式显示的正文内容，如果不支持Html方式，就会用到这个，基本无用
            Log::info("=======mail->send=========".$mail->send());
            if(!$mail->send()){// 发送邮件
                echo "Message could not be sent.";
                echo "Mailer Error: ".$mail->ErrorInfo;// 输出错误信息
            }else{
                Db::table('yf_hf_phpmailer')->where('id',$phpmailer['id'])->delete();
                echo '发送成功';
            }
        }

    }

}