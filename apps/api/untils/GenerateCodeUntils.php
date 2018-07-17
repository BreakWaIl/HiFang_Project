<?php
namespace app\api\untils;
use Endroid\QrCode\QrCode;
/**
 * Description of Qrcode
 *
 * @author fuju
 */
class GenerateCodeUntils   {
    /**
     * 生成二维码
     * 
     * @param type $param
     */
    public function getCode($param, $file_name) {
        $path = 'static'.DS.'qrcode'.DS.date(Ymd);

        if (!file_exists($path)) {
            mkdir($path, 0777);
        }

        $qrCode = new QrCode($param);
        $qrCode->setSize(300);
        $qrCode->setWriterByName('png');
        $qrCode->setMargin(10);
        $qrCode->setEncoding('UTF-8');
        $qrCode->setForegroundColor(['r' => 0, 'g' => 0, 'b' => 0]);
        $qrCode->setBackgroundColor(['r' => 255, 'g' => 255, 'b' => 255]);
        $qrCode->setValidateResult(false);
        $path = $path.DS.$file_name.'.png';
        $qrCode->writeFile($path);
        return $path;
    }
}
