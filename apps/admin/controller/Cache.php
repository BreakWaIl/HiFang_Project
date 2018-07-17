<?php
/**
 * Created by PhpStorm.
 * User: songjian
 * Date: 2018/4/11
 * Time: 23:10
 */

namespace app\admin\controller;


class Cache
{
    /**
     * 删除目录及目录下所有文件或删除指定文件
     * @param str $path   待删除目录路径
     * @param int $delDir 是否删除目录，1或true删除目录，0或false则只删除文件保留目录（包含子目录）
     * @return bool 返回删除状态
     */
    function delDirAndFile($path='../runtime', $delDir = false) {
        $handle = opendir($path);
        if ($handle) {
            while (false !== ( $item = readdir($handle) )) {
                if ($item != "." && $item != ".." && $item != "log")
                    is_dir("$path/$item") ? $this->delDirAndFile("$path/$item", $delDir) : unlink("$path/$item");
            }
            closedir($handle);
            //return '成功';
            if ($delDir)
                return rmdir($path);
            else
                return '缓存清除成功';
        }else {
            if (file_exists($path)) {
                return unlink($path);
            } else {
                //return false
                return '缓存清除失败';
            }
        }
    }
}