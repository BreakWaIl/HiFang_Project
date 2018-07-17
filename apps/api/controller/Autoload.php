<?php
/**
 * Created by PhpStorm.
 * User: zyt
 * Date: 2018/4/13
 * Time: 13:36
 */
namespace app\api\controller;

/**
 * Class Autoload
 * @package app\api\controller
 */
class Autoload{

    /**
     * 读取文件并生成文件
     * @author zyt
     * @time 2018/4/13
     */
    public function autoload($class, $table){
        //模板文件地址
        $dir =  __DIR__;
        $dir = substr($dir,0,strrpos($dir,'yuefang'));
        $pathname = substr($dir, 0);
        $url = $pathname . 'yuefang\apps\common\model\attr.php';
        //打开模板文件内容attention.php
        $myfile = fopen($url, "r") or die("Unable to open file!");
        //读取模板文件内容
        $files = fread($myfile,filesize($url));
        //修改模板文件内容
        $files = str_replace('Attr', ucfirst(strtolower($class)), $files);
        $files = str_replace('yf_attr', 'yf_'.strtolower($table), $files);
        $url1 = str_replace('attr', strtolower($class), $url);



        //创建新文件名
        $new_file = fopen($url1, 'w') or die("Unable to open file!");

        //写入新文件
        fwrite($new_file, $files);

        fclose($new_file);
        fclose($myfile);

    }

}