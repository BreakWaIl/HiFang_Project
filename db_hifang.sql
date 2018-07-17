/*
Navicat MySQL Data Transfer

Source Server         : 47.100.161.243_3309
Source Server Version : 50629
Source Host           : 47.100.161.243:3309
Source Database       : db_hifang

Target Server Type    : MYSQL
Target Server Version : 50629
File Encoding         : 65001

Date: 2018-07-17 19:11:14
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for yf_action
-- ----------------------------
DROP TABLE IF EXISTS `yf_action`;
CREATE TABLE `yf_action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(30) NOT NULL COMMENT '行为唯一标识（组合控制器名+操作名）',
  `depend_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '来源类型。0系统,1module，2plugin，3theme',
  `depend_flag` varchar(16) NOT NULL DEFAULT '' COMMENT '所属模块名',
  `title` varchar(80) NOT NULL DEFAULT '' COMMENT '行为说明',
  `remark` varchar(140) NOT NULL DEFAULT '' COMMENT '行为描述',
  `rule` varchar(255) NOT NULL DEFAULT '' COMMENT '行为规则',
  `log` varchar(255) NOT NULL DEFAULT '' COMMENT '日志规则',
  `action_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '执行类型。1自定义操作，2记录操作',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态。0禁用，1启用',
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统行为表';

-- ----------------------------
-- Records of yf_action
-- ----------------------------
INSERT INTO `yf_action` VALUES ('1', 'index_login', '1', 'admin', '登录后台', '用户登录后台', '', '[user|get_nickname]在[time|time_format]登录了后台', '1', '1383285551', '1383285551', '1');
INSERT INTO `yf_action` VALUES ('2', 'update_config', '1', 'admin', '更新配置', '新增或修改或删除配置', '', '', '2', '1383294988', '1383294988', '1');
INSERT INTO `yf_action` VALUES ('3', 'update_channel', '1', 'admin', '更新导航', '新增或修改或删除导航', '', '', '2', '1383296301', '1383296301', '1');
INSERT INTO `yf_action` VALUES ('4', 'update_category', '1', 'admin', '更新分类', '新增或修改或删除分类', '', '', '2', '1383296765', '1383296765', '1');
INSERT INTO `yf_action` VALUES ('5', 'database_export', '1', 'admin', '数据库备份', '后台进行数据库备份操作', '', '', '1', '0', '0', '1');
INSERT INTO `yf_action` VALUES ('6', 'database_optimize', '1', 'admin', '数据表优化', '数据库管理-》数据表优化', '', '', '1', '0', '0', '1');
INSERT INTO `yf_action` VALUES ('7', 'database_repair', '1', 'admin', '数据表修复', '数据库管理-》数据表修复', '', '', '1', '0', '0', '1');
INSERT INTO `yf_action` VALUES ('8', 'database_delbackup', '1', 'admin', '备份文件删除', '数据库管理-》备份文件删除', '', '', '1', '0', '0', '1');
INSERT INTO `yf_action` VALUES ('9', 'database_import', '1', 'admin', '数据库完成', '数据库管理-》数据还原', '', '', '1', '0', '0', '1');
INSERT INTO `yf_action` VALUES ('10', 'delete_actionlog', '1', 'admin', '删除行为日志', '后台删除用户行为日志', '', '', '1', '0', '0', '1');
INSERT INTO `yf_action` VALUES ('11', 'user_register', '1', 'admin', '注册', '', '', '', '1', '1506262430', '1506262430', '1');
INSERT INTO `yf_action` VALUES ('12', 'action_add', '1', 'admin', '添加行为', '', '', '', '1', '0', '0', '1');
INSERT INTO `yf_action` VALUES ('13', 'action_edit', '1', 'admin', '编辑用户行为', '', '', '', '1', '0', '0', '1');
INSERT INTO `yf_action` VALUES ('14', 'action_dellog', '1', 'admin', '清空日志', '清空所有行为日志', '', '', '1', '0', '1518006312', '1');
INSERT INTO `yf_action` VALUES ('15', 'setstatus', '1', 'admin', '改变数据状态', '通过列表改变了数据的status状态值', '', '', '1', '0', '1518004873', '1');
INSERT INTO `yf_action` VALUES ('16', 'modules_delapp', '1', 'admin', '删除模块', '删除整个模块的时候记录', '', '', '2', '1520222797', '1520225057', '1');

-- ----------------------------
-- Table structure for yf_action_log
-- ----------------------------
DROP TABLE IF EXISTS `yf_action_log`;
CREATE TABLE `yf_action_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `action_id` int(10) unsigned NOT NULL COMMENT '行为ID',
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '执行用户id',
  `nickname` varchar(60) NOT NULL DEFAULT '' COMMENT '用户名',
  `request_method` varchar(20) NOT NULL DEFAULT '' COMMENT '请求类型',
  `url` varchar(120) NOT NULL DEFAULT '' COMMENT '操作页面',
  `data` varchar(300) NOT NULL DEFAULT '0' COMMENT '相关数据,json格式',
  `ip` varchar(18) NOT NULL COMMENT 'IP',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '日志备注',
  `user_agent` varchar(360) NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='行为日志表';

-- ----------------------------
-- Records of yf_action_log
-- ----------------------------
INSERT INTO `yf_action_log` VALUES ('1', '13', '1', 'admin', 'GET', '/admin.php/admin/action/edit/id/16.html', '{\"param\":[]}', '127.0.0.1', '编辑用户行为', 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:48.0) Gecko/20100101 Firefox/48.0', '1523440263');
INSERT INTO `yf_action_log` VALUES ('2', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '172.17.0.1', '登录后台', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523443150');
INSERT INTO `yf_action_log` VALUES ('3', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523520265');
INSERT INTO `yf_action_log` VALUES ('4', '6', '1', 'admin', 'POST', '/admin.php/admin/database/optimize.html', '{\"param\":[]}', '172.17.0.1', '数据表优化', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523520656');
INSERT INTO `yf_action_log` VALUES ('5', '7', '1', 'admin', 'POST', '/admin.php/admin/database/repair.html', '{\"param\":[]}', '172.17.0.1', '数据表修复', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523520659');
INSERT INTO `yf_action_log` VALUES ('6', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521047');
INSERT INTO `yf_action_log` VALUES ('7', '1', '1', 'admin', 'GET', '/admin.php/', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521483');
INSERT INTO `yf_action_log` VALUES ('8', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521488');
INSERT INTO `yf_action_log` VALUES ('9', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521526');
INSERT INTO `yf_action_log` VALUES ('10', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521533');
INSERT INTO `yf_action_log` VALUES ('11', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521550');
INSERT INTO `yf_action_log` VALUES ('12', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521555');
INSERT INTO `yf_action_log` VALUES ('13', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521556');
INSERT INTO `yf_action_log` VALUES ('14', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521556');
INSERT INTO `yf_action_log` VALUES ('15', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521573');
INSERT INTO `yf_action_log` VALUES ('16', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521574');
INSERT INTO `yf_action_log` VALUES ('17', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521910');
INSERT INTO `yf_action_log` VALUES ('18', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521915');
INSERT INTO `yf_action_log` VALUES ('19', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521922');
INSERT INTO `yf_action_log` VALUES ('20', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521924');
INSERT INTO `yf_action_log` VALUES ('21', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521925');
INSERT INTO `yf_action_log` VALUES ('22', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521925');
INSERT INTO `yf_action_log` VALUES ('23', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523521925');
INSERT INTO `yf_action_log` VALUES ('24', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523522010');
INSERT INTO `yf_action_log` VALUES ('25', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523522010');
INSERT INTO `yf_action_log` VALUES ('26', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523522011');
INSERT INTO `yf_action_log` VALUES ('27', '1', '1', 'admin', 'GET', '/admin.php/admin/', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523531489');
INSERT INTO `yf_action_log` VALUES ('28', '1', '1', 'admin', 'GET', '/admin.php/admin/', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523531520');
INSERT INTO `yf_action_log` VALUES ('29', '15', '1', 'admin', 'GET', '/admin.php/admin/menu/setstatus/status/forbid/ids/5.html?model=auth_rule', '{\"param\":{\"model\":\"auth_rule\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523615376');
INSERT INTO `yf_action_log` VALUES ('30', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '172.17.0.1', '登录后台', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523778002');
INSERT INTO `yf_action_log` VALUES ('31', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '172.17.0.1', '登录后台', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523778002');
INSERT INTO `yf_action_log` VALUES ('32', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '172.17.0.1', '登录后台', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523787635');
INSERT INTO `yf_action_log` VALUES ('33', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '172.17.0.1', '登录后台', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523787636');
INSERT INTO `yf_action_log` VALUES ('34', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523788658');
INSERT INTO `yf_action_log` VALUES ('35', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/video/setstatus/status/delete.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523848353');
INSERT INTO `yf_action_log` VALUES ('36', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/follow/setstatus/status/delete.html?model=Follow', '{\"param\":{\"model\":\"Follow\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523848368');
INSERT INTO `yf_action_log` VALUES ('37', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/video/setstatus/status/delete.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523848553');
INSERT INTO `yf_action_log` VALUES ('38', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/follow/setstatus/status/delete.html?model=Follow', '{\"param\":{\"model\":\"Follow\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523848581');
INSERT INTO `yf_action_log` VALUES ('39', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/buildings/setstatus/status/delete.html?model=Buildings', '{\"param\":{\"model\":\"Buildings\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523850162');
INSERT INTO `yf_action_log` VALUES ('40', '15', '6', 'U1472739566', 'GET', '/admin.php/admin/buildings/setstatus/status/delete/ids/1568.html?model=Buildings', '{\"param\":{\"model\":\"Buildings\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523850308');
INSERT INTO `yf_action_log` VALUES ('41', '15', '6', 'U1472739566', 'GET', '/admin.php/admin/buildings/setstatus/status/delete/ids/1569.html?model=Buildings', '{\"param\":{\"model\":\"Buildings\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523853717');
INSERT INTO `yf_action_log` VALUES ('42', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523873813');
INSERT INTO `yf_action_log` VALUES ('43', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523873817');
INSERT INTO `yf_action_log` VALUES ('44', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '117.131.119.2', '登录后台', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1523954897');
INSERT INTO `yf_action_log` VALUES ('45', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0', '1524199880');
INSERT INTO `yf_action_log` VALUES ('46', '1', '1', 'admin', 'GET', '/admin.php/', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0', '1524200022');
INSERT INTO `yf_action_log` VALUES ('47', '6', '1', 'admin', 'GET', '/admin.php/admin/database/optimize/tables/yf_config.html', '{\"param\":[]}', '127.0.0.1', '数据表优化', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36', '1524204674');
INSERT INTO `yf_action_log` VALUES ('48', '15', '1', 'admin', 'GET', '/admin.php/admin/config/setstatus/status/delete/ids/64.html?model=Config', '{\"param\":{\"model\":\"Config\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36', '1524208493');
INSERT INTO `yf_action_log` VALUES ('49', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '172.17.0.1', '登录后台', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524214359');
INSERT INTO `yf_action_log` VALUES ('50', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '172.17.0.1', '登录后台', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524214359');
INSERT INTO `yf_action_log` VALUES ('51', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0', '1524561915');
INSERT INTO `yf_action_log` VALUES ('52', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '127.0.0.1', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0', '1524561919');
INSERT INTO `yf_action_log` VALUES ('53', '1', '1', 'admin', 'GET', '/admin.php', '{\"param\":[]}', '117.131.119.2', '登录后台', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524728166');
INSERT INTO `yf_action_log` VALUES ('54', '15', '6', 'U1472739566', 'GET', '/admin.php/admin/video/setstatus/status/delete/ids/72.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524739893');
INSERT INTO `yf_action_log` VALUES ('55', '15', '6', 'U1472739566', 'GET', '/admin.php/admin/music/setstatus/status/delete/ids/1.html?model=Music', '{\"param\":{\"model\":\"Music\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524793309');
INSERT INTO `yf_action_log` VALUES ('56', '15', '6', 'U1472739566', 'GET', '/admin.php/admin/buildings/setstatus/status/delete/ids/1570.html?model=Buildings', '{\"param\":{\"model\":\"Buildings\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524793379');
INSERT INTO `yf_action_log` VALUES ('57', '15', '6', 'U1472739566', 'GET', '/admin.php/admin/music/setstatus/status/delete/ids/2.html?model=Music', '{\"param\":{\"model\":\"Music\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524793847');
INSERT INTO `yf_action_log` VALUES ('58', '15', '6', 'U1472739566', 'GET', '/admin.php/admin/video/setstatus/status/delete/ids/77.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524795155');
INSERT INTO `yf_action_log` VALUES ('59', '15', '6', 'U1472739566', 'GET', '/admin.php/admin/video/setstatus/status/delete/ids/76.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524795171');
INSERT INTO `yf_action_log` VALUES ('60', '15', '6', 'U1472739566', 'GET', '/admin.php/admin/video/setstatus/status/delete/ids/75.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524796089');
INSERT INTO `yf_action_log` VALUES ('61', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/video/setstatus/status/delete.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524797538');
INSERT INTO `yf_action_log` VALUES ('62', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/video/setstatus/status/delete.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524797621');
INSERT INTO `yf_action_log` VALUES ('63', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/video/setstatus/status/delete.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524797640');
INSERT INTO `yf_action_log` VALUES ('64', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/video/setstatus/status/deleteVideo.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524797730');
INSERT INTO `yf_action_log` VALUES ('65', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/video/setstatus/status/deleteVideo.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524798001');
INSERT INTO `yf_action_log` VALUES ('66', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/video/setstatus/status/deleteVideo.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524798237');
INSERT INTO `yf_action_log` VALUES ('67', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/video/setstatus/status/delete.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524798478');
INSERT INTO `yf_action_log` VALUES ('68', '15', '6', 'U1472739566', 'POST', '/admin.php/admin/video/setstatus/status/deleteVideo/ids/74.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524799072');
INSERT INTO `yf_action_log` VALUES ('69', '13', '6', 'admin1', 'GET', '/admin.php/admin/action/edit/id/16.html', '{\"param\":[]}', '172.17.0.1', '编辑用户行为', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524823875');
INSERT INTO `yf_action_log` VALUES ('70', '15', '6', 'admin1', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/83.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '172.17.0.1', '改变数据状态', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524824120');
INSERT INTO `yf_action_log` VALUES ('71', '15', '6', 'admin1', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/83.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '172.17.0.1', '改变数据状态', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524824194');
INSERT INTO `yf_action_log` VALUES ('72', '15', '6', 'admin1', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/83.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '172.17.0.1', '改变数据状态', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524824229');
INSERT INTO `yf_action_log` VALUES ('73', '15', '6', 'admin1', 'GET', '/admin.php/admin/video/setstatus/status/showvideo/ids/83.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '172.17.0.1', '改变数据状态', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524824266');
INSERT INTO `yf_action_log` VALUES ('74', '15', '6', 'admin1', 'GET', '/admin.php/admin/video/setstatus/status/showvideo/ids/86.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '172.17.0.1', '改变数据状态', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524824289');
INSERT INTO `yf_action_log` VALUES ('75', '15', '6', 'admin1', 'GET', '/admin.php/admin/video/setstatus/status/showvideo/ids/86.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '172.17.0.1', '改变数据状态', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524824308');
INSERT INTO `yf_action_log` VALUES ('76', '15', '6', 'admin1', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/85.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '172.17.0.1', '改变数据状态', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524824341');
INSERT INTO `yf_action_log` VALUES ('77', '15', '6', 'admin1', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/86.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '172.17.0.1', '改变数据状态', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524824345');
INSERT INTO `yf_action_log` VALUES ('78', '15', '6', 'admin1', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/85.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '172.17.0.1', '改变数据状态', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524824346');
INSERT INTO `yf_action_log` VALUES ('79', '15', '6', 'admin1', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/84.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '172.17.0.1', '改变数据状态', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524824347');
INSERT INTO `yf_action_log` VALUES ('80', '15', '6', 'admin1', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/88.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '172.17.0.1', '改变数据状态', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524824411');
INSERT INTO `yf_action_log` VALUES ('81', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/83.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '117.131.119.2', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524828490');
INSERT INTO `yf_action_log` VALUES ('82', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/83.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524836990');
INSERT INTO `yf_action_log` VALUES ('83', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/71.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524837021');
INSERT INTO `yf_action_log` VALUES ('84', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/83.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524837026');
INSERT INTO `yf_action_log` VALUES ('85', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/88.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524837083');
INSERT INTO `yf_action_log` VALUES ('86', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/86.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524837335');
INSERT INTO `yf_action_log` VALUES ('87', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/86.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524837434');
INSERT INTO `yf_action_log` VALUES ('88', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/86.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524837583');
INSERT INTO `yf_action_log` VALUES ('89', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/86.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524837646');
INSERT INTO `yf_action_log` VALUES ('90', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/88.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524837925');
INSERT INTO `yf_action_log` VALUES ('91', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/86.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524838085');
INSERT INTO `yf_action_log` VALUES ('92', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/88.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524838087');
INSERT INTO `yf_action_log` VALUES ('93', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/83.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524838119');
INSERT INTO `yf_action_log` VALUES ('94', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/88.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524838168');
INSERT INTO `yf_action_log` VALUES ('95', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/88.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524838171');
INSERT INTO `yf_action_log` VALUES ('96', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/88.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524838172');
INSERT INTO `yf_action_log` VALUES ('97', '15', '1', 'admin', 'POST', '/admin.php/admin/video/setstatus/status/showvideo/ids/88.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524838173');
INSERT INTO `yf_action_log` VALUES ('98', '15', '1', 'admin', 'GET', '/admin.php/admin/video/setstatus/status/showvideo/ids/88.html?model=Video', '{\"param\":{\"model\":\"Video\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524838187');
INSERT INTO `yf_action_log` VALUES ('99', '15', '1', 'admin', 'GET', '/admin.php/admin/action/setstatus/status/delete/ids/98.html?model=Action', '{\"param\":{\"model\":\"Action\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524838347');
INSERT INTO `yf_action_log` VALUES ('100', '15', '1', 'admin', 'GET', '/admin.php/admin/action/setstatus/status/delete/ids/98.html?model=Action', '{\"param\":{\"model\":\"Action\"}}', '127.0.0.1', '改变数据状态', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36', '1524838374');

-- ----------------------------
-- Table structure for yf_attachment
-- ----------------------------
DROP TABLE IF EXISTS `yf_attachment`;
CREATE TABLE `yf_attachment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'UID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '文件名',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '文件路径',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '文件链接（暂时无用）',
  `location` varchar(15) NOT NULL DEFAULT '' COMMENT '文件存储位置(或驱动)',
  `path_type` varchar(20) DEFAULT 'picture' COMMENT '路径类型，存储在uploads的哪个目录中',
  `ext` char(4) NOT NULL DEFAULT '' COMMENT '文件类型',
  `mime_type` varchar(60) NOT NULL DEFAULT '' COMMENT '文件mime类型',
  `size` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '文件大小',
  `alt` varchar(255) DEFAULT NULL COMMENT '替代文本图像alt',
  `md5` char(32) NOT NULL DEFAULT '' COMMENT '文件md5',
  `sha1` char(40) NOT NULL DEFAULT '' COMMENT '文件sha1编码',
  `download` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '下载次数',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上传时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `sort` mediumint(8) unsigned NOT NULL DEFAULT '99' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `idx_paty_type` (`path_type`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8 COMMENT='附件表';

-- ----------------------------
-- Records of yf_attachment
-- ----------------------------
INSERT INTO `yf_attachment` VALUES ('1', '1', 'preg_match_imgs.jpeg', '/uploads/Editor/Picture/2016-06-12/575d4bd8d0351.jpeg', '', 'local', 'editor', 'jpeg', '', '19513', '', '4cf157e42b44c95d579ee39b0a1a48a4', 'dee76e7b39f1afaad14c1e03cfac5f6031c3c511', '0', '1465732056', '1465732056', '99', '1');
INSERT INTO `yf_attachment` VALUES ('2', '1', 'gerxiangimg200x200.jpg', '/uploads/Editor/Picture/2016-06-12/575d4bfb09961.jpg', '', 'local', 'editor', 'jpg', '', '5291', 'gerxiangimg200x200', '4db879c357c4ab80c77fce8055a0785f', '480eb2e097397856b99b373214fb28c2f717dacf', '0', '1465732090', '1465732090', '99', '1');
INSERT INTO `yf_attachment` VALUES ('3', '1', 'oraclmysqlzjfblhere.jpg', '/uploads/Editor/Picture/2016-06-12/575d4c691e976.jpg', '', 'local', 'editor', 'jpg', '', '23866', 'mysql', '5a3a5a781a6d9b5f0089f6058572f850', 'a17bfe395b29ba06ae5784486bcf288b3b0adfdb', '0', '1465732201', '1465732201', '99', '1');
INSERT INTO `yf_attachment` VALUES ('4', '1', 'logo.png', '/logo.png', '', 'local', 'picture', 'jpg', '', '40000', 'eacoophp-logo', '', '', '0', '1465732201', '1465732201', '99', '1');
INSERT INTO `yf_attachment` VALUES ('6', '1', '功能表格', '/uploads/file/2016-07-13/5785daaa2f2e6.xlsx', '', 'local', 'file', 'xlsx', '', '11399', null, '5fd89f172ca8a95fa13b55ccb24d5971', 'b8706af3fa59ef0fc65675e40131f25e12f94664', '0', '1468390058', '1468390058', '99', '1');
INSERT INTO `yf_attachment` VALUES ('8', '1', '会员数据2016-06-30 18_44_14', '/uploads/file/2016-07-13/5785dce2e15c1.xls', '', 'local', 'file', 'xls', '', '173387', null, '9ff55acddd75366d20dcb931eb1d87ea', 'acf5daf769e6ba06854002104bfb8c2886da97af', '0', '1468390626', '1468390626', '99', '1');
INSERT INTO `yf_attachment` VALUES ('10', '1', '苹果短信-三全音 - 铃声', '/uploads/file/2016-07-27/579857b5aca95.mp3', '', 'local', 'file', 'mp3', '', '19916', null, 'bab00edb8d6a5cf4de5444a2e5c05009', '73cda0fb4f947dcb496153d8b896478af1247935', '0', '1469601717', '1469601717', '99', '1');
INSERT INTO `yf_attachment` VALUES ('12', '1', 'music', '/uploads/file/2016-07-28/57995fe9bf0da.mp3', '', 'local', 'file', 'mp3', '', '160545', 'url', '935cd1b8950f1fdcd23d47cf791831cf', '73c318221faa081544db321bb555148f04b61f00', '0', '1469669353', '1524751665', '99', '1');
INSERT INTO `yf_attachment` VALUES ('13', '1', '7751775467283337', '/uploads/picture/2016-09-26/57e8dc9d29b01.jpg', '', 'local', 'picture', 'jpg', '', '70875', null, '3e3bfc950aa0b6ebb56654c15fe8e392', 'c75e70753eaf36aaee10efb3682fdbd8f766d32d', '0', '1474878621', '1474878621', '99', '1');
INSERT INTO `yf_attachment` VALUES ('14', '1', '4366486814073822', '/uploads/picture/2016-09-26/57e8ddebaafff.jpg', '', 'local', 'picture', 'jpg', '', '302678', null, 'baf2dc5ea7b80a6d73b20a2c762aec1e', 'd73fe63f5c179135b2c2e7f174d6df36e05ab3d8', '0', '1474878955', '1474878955', '99', '1');
INSERT INTO `yf_attachment` VALUES ('15', '1', 'wx1image_14751583274385', '/uploads/picture/2016-09-29/wx1image_14751583274385.jpg', '', 'local', 'picture', 'jpg', '', '311261', null, '', '', '0', '1475158327', '1475158327', '99', '1');
INSERT INTO `yf_attachment` VALUES ('17', '1', 'wx1image_14751583287356', '/uploads/picture/2016-09-29/wx1image_14751583287356.jpg', '', 'local', 'picture', 'jpg', '', '43346', null, '', '', '0', '1475158328', '1475158328', '99', '1');
INSERT INTO `yf_attachment` VALUES ('18', '1', 'wx1image_14751583293547', '/uploads/picture/2016-09-29/wx1image_14751583293547.jpg', '', 'local', 'picture', 'jpg', '', '150688', null, '', '', '0', '1475158329', '1475158329', '99', '1');
INSERT INTO `yf_attachment` VALUES ('19', '1', 'wx1image_14751583298683', '/uploads/picture/2016-09-29/wx1image_14751583298683.jpg', '', 'local', 'picture', 'jpg', '', '79626', null, '', '', '0', '1475158329', '1475158329', '99', '1');
INSERT INTO `yf_attachment` VALUES ('20', '1', 'wx1image_14751583294128', '/uploads/picture/2016-09-29/wx1image_14751583294128.jpg', '', 'local', 'picture', 'jpg', '', '61008', null, '', '', '0', '1475158329', '1475158329', '99', '1');
INSERT INTO `yf_attachment` VALUES ('21', '1', 'wx1image_14751583302886', '/uploads/picture/2016-09-29/wx1image_14751583302886.jpg', '', 'local', 'picture', 'jpg', '', '20849', null, '', '', '0', '1475158330', '1475158330', '99', '1');
INSERT INTO `yf_attachment` VALUES ('22', '1', 'wx1image_1475158330831', '/uploads/picture/2016-09-29/wx1image_1475158330831.jpg', '', 'local', 'picture', 'jpg', '', '56265', null, '', '', '0', '1475158330', '1475158330', '99', '1');
INSERT INTO `yf_attachment` VALUES ('23', '1', 'wx1image_1475158330180', '/uploads/picture/2016-09-29/wx1image_1475158330180.jpg', '', 'local', 'picture', 'jpg', '', '121610', null, '', '', '0', '1475158330', '1475158330', '99', '1');
INSERT INTO `yf_attachment` VALUES ('24', '1', 'wx1image_14751583318180', '/uploads/picture/2016-09-29/wx1image_14751583318180.jpg', '', 'local', 'picture', 'jpg', '', '35555', null, '', '', '0', '1475158331', '1475158331', '99', '1');
INSERT INTO `yf_attachment` VALUES ('25', '1', 'wx1image_1475158332231', '/uploads/picture/2016-09-29/wx1image_1475158332231.jpg', '', 'local', 'picture', 'jpg', '', '32095', null, '', '', '0', '1475158332', '1475158332', '99', '1');
INSERT INTO `yf_attachment` VALUES ('26', '1', 'wx1image_14751583325255', '/uploads/picture/2016-09-29/wx1image_14751583325255.jpg', '', 'local', 'picture', 'jpg', '', '70088', null, '', '', '0', '1475158332', '1475158332', '99', '1');
INSERT INTO `yf_attachment` VALUES ('27', '1', 'wx1image_14751583331037', '/uploads/picture/2016-09-29/wx1image_14751583331037.jpg', '', 'local', 'picture', 'jpg', '', '37085', null, '', '', '0', '1475158333', '1475158333', '99', '1');
INSERT INTO `yf_attachment` VALUES ('28', '1', 'wx1image_14751583343169', '/uploads/picture/2016-09-29/wx1image_14751583343169.jpg', '', 'local', 'picture', 'jpg', '', '65279', null, '', '', '0', '1475158334', '1475158334', '99', '1');
INSERT INTO `yf_attachment` VALUES ('29', '1', 'wx1image_14751583344810', '/uploads/picture/2016-09-29/wx1image_14751583344810.jpg', '', 'local', 'picture', 'jpg', '', '83936', null, '', '', '0', '1475158334', '1475158334', '99', '1');
INSERT INTO `yf_attachment` VALUES ('30', '1', 'wx1image_14751583356369', '/uploads/picture/2016-09-29/wx1image_14751583356369.jpg', '', 'local', 'picture', 'jpg', '', '20032', null, '', '', '0', '1475158335', '1475158335', '99', '1');
INSERT INTO `yf_attachment` VALUES ('31', '1', 'wx1image_14751583359328', '/uploads/picture/2016-09-29/wx1image_14751583359328.jpg', '', 'local', 'picture', 'jpg', '', '53984', null, '', '', '0', '1475158335', '1475158335', '99', '1');
INSERT INTO `yf_attachment` VALUES ('32', '1', 'wx1image_1475158335689', '/uploads/picture/2016-09-29/wx1image_1475158335689.jpg', '', 'local', 'picture', 'jpg', '', '50399', null, '', '', '0', '1475158335', '1475158335', '99', '1');
INSERT INTO `yf_attachment` VALUES ('33', '1', 'wx1image_14751583361694', '/uploads/picture/2016-09-29/wx1image_14751583361694.jpg', '', 'local', 'picture', 'jpg', '', '128125', null, '', '', '0', '1475158336', '1475158336', '99', '1');
INSERT INTO `yf_attachment` VALUES ('34', '1', 'wx1image_14751583371210', '/uploads/picture/2016-09-29/wx1image_14751583371210.jpg', '', 'local', 'picture', 'jpg', '', '35090', null, '', '', '0', '1475158337', '1475158337', '99', '1');
INSERT INTO `yf_attachment` VALUES ('36', '1', 'wx1image_14751583393940', '/uploads/picture/2016-09-29/wx1image_14751583393940.jpg', '', 'local', 'picture', 'jpg', '', '74827', null, '', '', '0', '1475158339', '1475158339', '99', '1');
INSERT INTO `yf_attachment` VALUES ('38', '1', 'wx1image_14751587991531', '/uploads/picture/2016-09-29/wx1image_14751587991531.jpg', '', 'local', 'picture', 'jpg', '', '154175', null, '', '', '0', '1475158799', '1475158799', '99', '1');
INSERT INTO `yf_attachment` VALUES ('39', '1', 'wx1image_14751587997094.png', '/uploads/picture/2016-09-29/wx1image_14751587997094.png', '', 'local', 'picture', 'jpg', '', '26583', null, '', '', '0', '1475158799', '1475158799', '99', '1');
INSERT INTO `yf_attachment` VALUES ('40', '1', 'wx1image_14751587995130', '/uploads/picture/2016-09-29/wx1image_14751587995130.jpg', '', 'local', 'picture', 'jpg', '', '23625', null, '', '', '0', '1475158799', '1475158799', '99', '1');
INSERT INTO `yf_attachment` VALUES ('41', '1', 'wx1image_14751587995676', '/uploads/picture/2016-09-29/wx1image_14751587995676.jpg', '', 'local', 'picture', 'jpg', '', '67232', null, '', '', '0', '1475158799', '1475158799', '99', '1');
INSERT INTO `yf_attachment` VALUES ('43', '1', 'wx1image_14751588004786', '/uploads/picture/2016-09-29/wx1image_14751588004786.jpg', '', 'local', 'picture', 'jpg', '', '26779', null, '', '', '0', '1475158800', '1475158800', '99', '1');
INSERT INTO `yf_attachment` VALUES ('44', '1', 'wx1image_14751588009825', '/uploads/picture/2016-09-29/wx1image_14751588009825.jpg', '', 'local', 'picture', 'jpg', '', '7546', null, '', '', '0', '1475158800', '1475158800', '99', '1');
INSERT INTO `yf_attachment` VALUES ('45', '1', 'wx1image_1475158800631', '/uploads/picture/2016-09-29/wx1image_1475158800631.jpg', '', 'local', 'picture', 'jpg', '', '10713', null, '', '', '0', '1475158800', '1475158800', '99', '1');
INSERT INTO `yf_attachment` VALUES ('46', '1', 'wx1image_14751588008193', '/uploads/picture/2016-09-29/wx1image_14751588008193.jpg', '', 'local', 'picture', 'jpg', '', '94825', null, '', '', '0', '1475158800', '1475158800', '99', '1');
INSERT INTO `yf_attachment` VALUES ('47', '1', 'wx1image_14751588004666', '/uploads/picture/2016-09-29/wx1image_14751588004666.jpg', '', 'local', 'picture', 'jpg', '', '39592', null, '', '', '0', '1475158800', '1475158800', '99', '1');
INSERT INTO `yf_attachment` VALUES ('48', '1', 'wx1image_14751588008768.png', '/uploads/picture/2016-09-29/wx1image_14751588008768.png', '', 'local', 'picture', 'jpg', '', '50732', null, '', '', '0', '1475158800', '1475158800', '99', '1');
INSERT INTO `yf_attachment` VALUES ('49', '1', 'wx1image_1475158800354.png', '/uploads/picture/2016-09-29/wx1image_1475158800354.png', '', 'local', 'picture', 'jpg', '', '21937', null, '', '', '0', '1475158800', '1475158800', '99', '1');
INSERT INTO `yf_attachment` VALUES ('50', '1', 'wx1image_1475158801542.png', '/uploads/picture/2016-09-29/wx1image_1475158801542.png', '', 'local', 'picture', 'jpg', '', '19383', null, '', '', '0', '1475158801', '1475158801', '99', '1');
INSERT INTO `yf_attachment` VALUES ('51', '1', 'wx1image_14751588012312.png', '/uploads/picture/2016-09-29/wx1image_14751588012312.png', '', 'local', 'picture', 'jpg', '', '45798', null, '', '', '0', '1475158801', '1475158801', '99', '1');
INSERT INTO `yf_attachment` VALUES ('52', '1', 'wx1image_14751588058806', '/uploads/picture/2016-09-29/wx1image_14751588058806.jpg', '', 'local', 'picture', 'jpg', '', '24855', null, '', '', '0', '1475158805', '1475158805', '99', '1');
INSERT INTO `yf_attachment` VALUES ('53', '1', 'wx1image_14751588067284', '/uploads/picture/2016-09-29/wx1image_14751588067284.jpg', '', 'local', 'picture', 'jpg', '', '14851', null, '', '', '0', '1475158806', '1475158806', '99', '1');
INSERT INTO `yf_attachment` VALUES ('54', '1', 'wx1image_14751588091783.png', '/uploads/picture/2016-09-29/wx1image_14751588091783.png', '', 'local', 'picture', 'jpg', '', '68781', null, '', '', '0', '1475158809', '1475158809', '99', '1');
INSERT INTO `yf_attachment` VALUES ('55', '1', 'wx1image_14751588108673.png', '/uploads/picture/2016-09-29/wx1image_14751588108673.png', '', 'local', 'picture', 'jpg', '', '13649', null, '', '', '0', '1475158810', '1475158810', '99', '1');
INSERT INTO `yf_attachment` VALUES ('56', '1', 'wx1image_14751588114626.png', '/uploads/picture/2016-09-29/wx1image_14751588114626.png', '', 'local', 'picture', 'jpg', '', '10724', null, '', '', '0', '1475158811', '1475158811', '99', '1');
INSERT INTO `yf_attachment` VALUES ('57', '1', 'wx1image_14751588116216.png', '/uploads/picture/2016-09-29/wx1image_14751588116216.png', '', 'local', 'picture', 'jpg', '', '18955', null, '', '', '0', '1475158811', '1475158811', '99', '1');
INSERT INTO `yf_attachment` VALUES ('58', '1', 'wx1image_14751588117971', '/uploads/picture/2016-09-29/wx1image_14751588117971.jpg', '', 'local', 'picture', 'jpg', '', '34171', null, '', '', '0', '1475158811', '1475158811', '99', '1');
INSERT INTO `yf_attachment` VALUES ('59', '1', 'wx1image_14751588113400', '/uploads/picture/2016-09-29/wx1image_14751588113400.jpg', '', 'local', 'picture', 'jpg', '', '16445', null, '', '', '0', '1475158811', '1475158811', '99', '1');
INSERT INTO `yf_attachment` VALUES ('60', '1', 'wx1image_14751588113547', '/uploads/picture/2016-09-29/wx1image_14751588113547.jpg', '', 'local', 'picture', 'jpg', '', '7062', null, '', '', '0', '1475158811', '1475158811', '99', '1');
INSERT INTO `yf_attachment` VALUES ('61', '1', 'wx1image_14751588111003', '/uploads/picture/2016-09-29/wx1image_14751588111003.jpg', '', 'local', 'picture', 'jpg', '', '7982', null, '', '', '0', '1475158811', '1475158811', '99', '1');
INSERT INTO `yf_attachment` VALUES ('62', '1', 'wx1image_14751588185564.png', '/uploads/picture/2016-09-29/wx1image_14751588185564.png', '', 'local', 'picture', 'jpg', '', '163203', null, '', '', '0', '1475158818', '1475158818', '99', '1');
INSERT INTO `yf_attachment` VALUES ('63', '1', 'wx1image_14751588213497.png', '/uploads/picture/2016-09-29/wx1image_14751588213497.png', '', 'local', 'picture', 'jpg', '', '14153', null, '', '', '0', '1475158821', '1475158821', '99', '1');
INSERT INTO `yf_attachment` VALUES ('64', '1', 'wx1image_14751588212612.png', '/uploads/picture/2016-09-29/wx1image_14751588212612.png', '', 'local', 'picture', 'jpg', '', '15962', null, '', '', '0', '1475158821', '1475158821', '99', '1');
INSERT INTO `yf_attachment` VALUES ('65', '1', 'wx1image_14751588215121.png', '/uploads/picture/2016-09-29/wx1image_14751588215121.png', '', 'local', 'picture', 'jpg', '', '22820', null, '', '', '0', '1475158821', '1475158821', '99', '1');
INSERT INTO `yf_attachment` VALUES ('67', '1', 'wx1image_14751588223870', '/uploads/picture/2016-09-29/wx1image_14751588223870.jpg', '', 'local', 'picture', 'jpg', '', '31690', null, '', '', '0', '1475158822', '1475158822', '99', '1');
INSERT INTO `yf_attachment` VALUES ('68', '1', 'wx1image_14751588235543.png', '/uploads/picture/2016-09-29/wx1image_14751588235543.png', '', 'local', 'picture', 'jpg', '', '32383', null, '', '', '0', '1475158823', '1475158823', '99', '1');
INSERT INTO `yf_attachment` VALUES ('69', '1', 'wx1image_14751588233114.png', '/uploads/picture/2016-09-29/wx1image_14751588233114.png', '', 'local', 'picture', 'jpg', '', '16871', null, '', '', '0', '1475158823', '1475158823', '99', '1');
INSERT INTO `yf_attachment` VALUES ('70', '1', 'wx1image_14751588247501.png', '/uploads/picture/2016-09-29/wx1image_14751588247501.png', '', 'local', 'picture', 'jpg', '', '48306', '', '', '', '0', '1475158824', '1475158824', '99', '1');
INSERT INTO `yf_attachment` VALUES ('73', '1', 'wx1image_1475158835506', '/uploads/picture/2016-09-29/wx1image_1475158835506.jpg', '', 'local', 'picture', 'jpg', '', '12805', null, '', '', '0', '1475158835', '1475158835', '99', '1');
INSERT INTO `yf_attachment` VALUES ('74', '1', 'wx1image_14751588359605.png', '/uploads/picture/2016-09-29/wx1image_14751588359605.png', '', 'local', 'picture', 'jpg', '', '42306', null, '', '', '0', '1475158835', '1475158835', '99', '1');
INSERT INTO `yf_attachment` VALUES ('75', '1', 'wx1image_14751588351768.png', '/uploads/picture/2016-09-29/wx1image_14751588351768.png', '', 'local', 'picture', 'jpg', '', '13828', null, '', '', '0', '1475158835', '1475158835', '99', '1');
INSERT INTO `yf_attachment` VALUES ('76', '1', 'wx1image_14751588383783.png', '/uploads/picture/2016-09-29/wx1image_14751588383783.png', '', 'local', 'picture', 'jpg', '', '39390', null, '', '', '0', '1475158838', '1475158838', '99', '1');
INSERT INTO `yf_attachment` VALUES ('78', '1', 'wx1image_14751588393130.png', '/uploads/picture/2016-09-29/wx1image_14751588393130.png', '', 'local', 'picture', 'jpg', '', '10686', null, '', '', '0', '1475158839', '1475158839', '99', '1');
INSERT INTO `yf_attachment` VALUES ('79', '1', 'wx1image_1475158843730.png', '/uploads/picture/2016-09-29/wx1image_1475158843730.png', '', 'local', 'picture', 'jpg', '', '77934', null, '', '', '0', '1475158843', '1475158843', '99', '1');
INSERT INTO `yf_attachment` VALUES ('80', '1', 'wx1image_14751588431771.png', '/uploads/picture/2016-09-29/wx1image_14751588431771.png', '', 'local', 'picture', 'jpg', '', '38682', null, '', '', '0', '1475158843', '1475158843', '99', '1');
INSERT INTO `yf_attachment` VALUES ('81', '1', 'wx1image_14751588432055.png', '/uploads/picture/2016-09-29/wx1image_14751588432055.png', '', 'local', 'picture', 'jpg', '', '54928', null, '', '', '0', '1475158843', '1475158843', '99', '1');
INSERT INTO `yf_attachment` VALUES ('82', '1', 'wx1image_14751588441630.png', '/uploads/picture/2016-09-29/wx1image_14751588441630.png', '', 'local', 'picture', 'jpg', '', '22413', null, '', '', '0', '1475158844', '1475158844', '99', '1');
INSERT INTO `yf_attachment` VALUES ('83', '1', 'wx1image_14751588456818.png', '/uploads/picture/2016-09-29/wx1image_14751588456818.png', '', 'local', 'picture', 'jpg', '', '12567', null, '', '', '0', '1475158845', '1475158845', '99', '1');
INSERT INTO `yf_attachment` VALUES ('84', '1', 'wx1image_14751588548752.png', '/uploads/picture/2016-09-29/wx1image_14751588548752.png', '', 'local', 'picture', 'jpg', '', '86619', null, '', '', '0', '1475158854', '1475158854', '99', '1');
INSERT INTO `yf_attachment` VALUES ('85', '1', 'wx1image_14751588549711', '/uploads/picture/2016-09-29/wx1image_14751588549711.jpg', '', 'local', 'picture', 'jpg', '', '11863', null, '', '', '0', '1475158854', '1475158854', '99', '1');
INSERT INTO `yf_attachment` VALUES ('87', '1', 'wx1image_14751588668519', '/uploads/picture/2016-09-29/wx1image_14751588668519.jpg', '', 'local', 'picture', 'jpg', '', '27712', null, '', '', '0', '1475158866', '1475158866', '99', '1');
INSERT INTO `yf_attachment` VALUES ('88', '1', 'wx1image_14751588684053', '/uploads/picture/2016-09-29/wx1image_14751588684053.jpg', '', 'local', 'picture', 'jpg', '', '101186', null, '', '', '0', '1475158868', '1475158868', '99', '1');
INSERT INTO `yf_attachment` VALUES ('89', '1', 'wx1image_14751588703441', '/uploads/picture/2016-09-29/wx1image_14751588703441.jpg', '', 'local', 'picture', 'jpg', '', '155125', null, '', '', '0', '1475158870', '1475158870', '99', '1');
INSERT INTO `yf_attachment` VALUES ('90', '1', 'wx1image_14751588708117', '/uploads/picture/2016-09-29/wx1image_14751588708117.jpg', '', 'local', 'picture', 'jpg', '', '24226', null, '', '', '0', '1475158870', '1475158870', '99', '1');
INSERT INTO `yf_attachment` VALUES ('91', '1', 'meinv_admin_avatar', '/uploads/picture/2016-09-30/57edd952ba0e0.jpg', '', 'local', 'picture', 'jpg', '', '7006', null, '89b678fa35106c7a0f7579cb8426bd7a', '7d10ddb80359255e58c04bd30412b00bba6938a5', '0', '1475205458', '1475205458', '99', '1');
INSERT INTO `yf_attachment` VALUES ('92', '1', '57e0a9c03a61b', '/uploads/picture/2016-10-03/57f2076c4e997.jpg', '', 'local', 'picture', 'jpg', '', '110032', '', 'e3694c361707487802476e81709c863f', 'd5381f24235ee72d9fd8dfe2bb2e3d128217c8ce', '0', '1475479404', '1475479404', '99', '1');
INSERT INTO `yf_attachment` VALUES ('93', '1', '9812496129086622', '/uploads/picture/2016-10-06/57f6136b5bd4e.jpg', '', 'local', 'picture', 'jpg', '', '164177', '9812496129086622', '983944832c987b160ae409f71acc7933', 'bce6147f4070989fc0349798acf6383938e5563a', '0', '1475744619', '1475744619', '99', '1');
INSERT INTO `yf_attachment` VALUES ('94', '1', 'eacoophp-watermark-banner-1', 'http://cdn.eacoo123.com/static/demo-eacoophp/eacoophp-watermark-banner-1.jpg', 'http://cdn.eacoo123.com/static/demo-eacoophp/eacoophp-watermark-banner-1.jpg', 'link', 'picture', 'jpg', 'image', '171045', 'eacoophp-watermark-banner-1', '', '', '0', '1506215777', '1506215777', '99', '1');
INSERT INTO `yf_attachment` VALUES ('95', '1', 'eacoophp-banner-3', 'http://cdn.eacoo123.com/static/demo-eacoophp/eacoophp-banner-3.jpg', 'http://cdn.eacoo123.com/static/demo-eacoophp/eacoophp-banner-3.jpg', 'link', 'picture', 'jpg', 'image', '356040', 'eacoophp-banner-3', '', '', '0', '1506215801', '1506215801', '99', '1');
INSERT INTO `yf_attachment` VALUES ('96', '1', 'eacoophp-watermark-banner-2', 'http://cdn.eacoo123.com/static/demo-eacoophp/eacoophp-watermark-banner-2.jpg', 'http://cdn.eacoo123.com/static/demo-eacoophp/eacoophp-watermark-banner-2.jpg', 'link', 'picture', 'jpg', 'image', '356040', 'eacoophp-watermark-banner-2', '', '', '0', '1506215801', '1506215801', '99', '1');
INSERT INTO `yf_attachment` VALUES ('97', '1', 'eacoophp_logo_v12', '/uploads/picture/default/web-logo.png', '/uploads/picture/default/web-logo.png', 'local', 'picture', 'png', 'image', '27737', 'eacoophp_logo_v12', 'a7c3bb8e947304954ee4a2401889a147', '34d88cd035d68bd656c0c166d6e9ed3bac42c46e', '0', '1523520185', '1523520185', '99', '1');
INSERT INTO `yf_attachment` VALUES ('98', '1', '231078222414135003', '/uploads/picture/2018-04-16/5ad47b35c3569.png', '/uploads/picture/2018-04-16/5ad47b35c3569.png', 'local', 'picture', 'png', 'image', '108605', '231078222414135003', 'c3b08e268ee8c11a4376d26fdffd6130', 'd14f5190138dea32c53195fc724b0449487ae96b', '0', '1523874613', '1523874613', '99', '1');
INSERT INTO `yf_attachment` VALUES ('99', '1', 'attachment-3188444493547617056iPhone5.5_U0022_U00281_U0029', '/uploads/picture/2018-05-21/5b027451d84a4.jpg', '/uploads/picture/2018-05-21/5b027451d84a4.jpg', 'local', 'picture', 'jpg', 'image', '57646', 'attachment-3188444493547617056iPhone5.5_U0022_U00281_U0029', 'f959e50ee7ad3254e27aef520b49b1d5', '49f7a97da564316d6d1b3bc819619816c69162d8', '0', '1526887505', '1526887505', '99', '1');
INSERT INTO `yf_attachment` VALUES ('100', '1', 'zhongda', '/uploads/picture/2018-05-21/5b0291675a95f.png', '/uploads/picture/2018-05-21/5b0291675a95f.png', 'local', 'picture', 'png', 'image', '364797', 'zhongda', '6b838317115aae25a01c7fee7e738f9c', 'f05e83776685e555b5d049d2721bcdc47619f36b', '0', '1526894951', '1526894951', '99', '1');
INSERT INTO `yf_attachment` VALUES ('101', '1', '3@2x', '/uploads/picture/2018-06-05/5b164d6e8f87d.png', '/uploads/picture/2018-06-05/5b164d6e8f87d.png', 'local', 'picture', 'png', 'image', '34854', '3@2x', '4eb880ac3d883e37dc472ce96155a30b', '080549cce874fc23a1d785cbd8fc9c458b60c20b', '0', '1528188270', '1528188270', '99', '1');
INSERT INTO `yf_attachment` VALUES ('102', '1', '4@3x', '/uploads/picture/2018-06-05/5b164d95be64a.png', '/uploads/picture/2018-06-05/5b164d95be64a.png', 'local', 'picture', 'png', 'image', '51799', '4@3x', 'acaa6cb7b8aabf0ce6b002e632b2cb8c', '88d74242c0773f42e8be361528bbd918c7c34fce', '0', '1528188309', '1528188309', '99', '1');
INSERT INTO `yf_attachment` VALUES ('103', '1', '20@2x', '/uploads/picture/2018-06-05/5b164dc5048cb.png', '/uploads/picture/2018-06-05/5b164dc5048cb.png', 'local', 'picture', 'png', 'image', '32649', '20@2x', '721bc10cb01b31ba8f05f64f5037fc74', 'a66ee159b4d5ab5d0ad5242c4e06a2f8740a9a91', '0', '1528188357', '1528188357', '99', '1');
INSERT INTO `yf_attachment` VALUES ('104', '1', '12', '/uploads/picture/2018-06-05/5b164e75506bb.png', '/uploads/picture/2018-06-05/5b164e75506bb.png', 'local', 'picture', 'png', 'image', '46992', '12', '63280632fdf01355b4dfc6a637607932', '2549da16a430437547de3f95f0db79fab2368d50', '0', '1528188533', '1528188533', '99', '1');
INSERT INTO `yf_attachment` VALUES ('105', '1', '16', '/uploads/picture/2018-06-05/5b164fdbcef30.png', '/uploads/picture/2018-06-05/5b164fdbcef30.png', 'local', 'picture', 'png', 'image', '65319', '16', '4b5b8befe8052c3266f6a17ccf9c76bb', '9ed8ece41e68cf9580d2809805f3516b474a16fc', '0', '1528188891', '1528188891', '99', '1');
INSERT INTO `yf_attachment` VALUES ('106', '1', '13', '/uploads/picture/2018-06-05/5b1650e22890b.png', '/uploads/picture/2018-06-05/5b1650e22890b.png', 'local', 'picture', 'png', 'image', '61086', '13', '874ca05f9c70a6854b7ee3176e7b7f59', '2608e4a892c4c6326b1b2ba1bb3f35c281a44f68', '0', '1528189154', '1528189154', '99', '1');
INSERT INTO `yf_attachment` VALUES ('107', '4', '微信图片_20180522095300', '/uploads/picture/2018-06-06/5b176930b48b7.png', '/uploads/picture/2018-06-06/5b176930b48b7.png', 'local', 'picture', 'png', 'image', '23155', '微信图片_20180522095300', 'be000d8cde37cbb34a9a4893fcc1e731', '796944b00ab916e23a7828f294586b601bcbaa14', '0', '1528260912', '1528260912', '99', '1');
INSERT INTO `yf_attachment` VALUES ('108', '6', 'logo2', '/uploads/picture/2018-07-09/5b42d81f1cafb.png', '/uploads/picture/2018-07-09/5b42d81f1cafb.png', 'local', 'picture', 'png', 'image', '5750', 'logo2', '98cb3e872cff10d81814bc9f2a4e0c6d', '86a01f66ac82781ebba4ecbd42cf57bbdeb324db', '0', '1531107359', '1531107359', '99', '1');
INSERT INTO `yf_attachment` VALUES ('109', '4', '145104742396572259', '/uploads/picture/2018-07-09/5b42f7d0d79b4.png', '/uploads/picture/2018-07-09/5b42f7d0d79b4.png', 'local', 'picture', 'png', 'image', '129613', '145104742396572259', '7aed4ca8df772d0bb555f9b863da7a7b', '983ca2938f66c5e32f93deac45fc01cfdf2782a4', '0', '1531115472', '1531115472', '99', '1');
INSERT INTO `yf_attachment` VALUES ('110', '4', '5b42d95640a21', '/uploads/picture/2018-07-09/5b42f81bcb06b.jpg', '/uploads/picture/2018-07-09/5b42f81bcb06b.jpg', 'local', 'picture', 'jpg', 'image', '200902', '5b42d95640a21', '442450c49619d56236e3be3694b380cf', 'b2e7cfa222737336f17cf27c1664dad533a400a0', '0', '1531115547', '1531115547', '99', '1');

-- ----------------------------
-- Table structure for yf_auth_group
-- ----------------------------
DROP TABLE IF EXISTS `yf_auth_group`;
CREATE TABLE `yf_auth_group` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `title` char(100) NOT NULL DEFAULT '' COMMENT '用户组中文名称',
  `description` varchar(80) DEFAULT NULL COMMENT '描述信息',
  `rules` varchar(160) NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态。1启用，0禁用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='用户组表';

-- ----------------------------
-- Records of yf_auth_group
-- ----------------------------
INSERT INTO `yf_auth_group` VALUES ('1', '超级管理员', '拥有网站的最高权限', '1,2,6,18,9,12,17,19,25,26,49,3,7,21,43,44,53,71,72,4,37,38,39,40,41,42,5,22,23,30,24,10,11,13,14,20,32,15,8,16,27,28,29,48,50,51,52,54,55,57,58,59,65,47,61,68,4', '1');
INSERT INTO `yf_auth_group` VALUES ('2', '管理员', '授权管理员', '1,6,18,12,19,26,3,7,21,44,4,37,38,39,40,41,42,5,22,23,30,24,10,11,13,14,20,15,8,16,27,28,29', '1');
INSERT INTO `yf_auth_group` VALUES ('3', '普通用户', '这是普通用户的权限', '1,3,8,10,11,94,95,96,97,98,99,41,42,43,44,38,39,40', '1');
INSERT INTO `yf_auth_group` VALUES ('4', '客服', '客服处理订单发货', '1,27,28,29,7,4,52,53,54,55', '1');

-- ----------------------------
-- Table structure for yf_auth_group_access
-- ----------------------------
DROP TABLE IF EXISTS `yf_auth_group_access`;
CREATE TABLE `yf_auth_group_access` (
  `uid` mediumint(8) unsigned NOT NULL,
  `group_id` mediumint(8) unsigned NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否审核  2：未审核，1:启用，0：禁用，-1：删除',
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户组明细表';

-- ----------------------------
-- Records of yf_auth_group_access
-- ----------------------------
INSERT INTO `yf_auth_group_access` VALUES ('1', '1', '1');
INSERT INTO `yf_auth_group_access` VALUES ('3', '3', '1');
INSERT INTO `yf_auth_group_access` VALUES ('4', '3', '1');
INSERT INTO `yf_auth_group_access` VALUES ('5', '3', '1');
INSERT INTO `yf_auth_group_access` VALUES ('6', '3', '1');
INSERT INTO `yf_auth_group_access` VALUES ('2', '1', '1');
INSERT INTO `yf_auth_group_access` VALUES ('7', '2', '1');
INSERT INTO `yf_auth_group_access` VALUES ('7', '3', '1');
INSERT INTO `yf_auth_group_access` VALUES ('7', '4', '1');
INSERT INTO `yf_auth_group_access` VALUES ('15', '2', '1');
INSERT INTO `yf_auth_group_access` VALUES ('14', '3', '1');
INSERT INTO `yf_auth_group_access` VALUES ('3', '4', '1');
INSERT INTO `yf_auth_group_access` VALUES ('5', '4', '1');
INSERT INTO `yf_auth_group_access` VALUES ('6', '4', '1');
INSERT INTO `yf_auth_group_access` VALUES ('6', '1', '1');
INSERT INTO `yf_auth_group_access` VALUES ('4', '1', '1');
INSERT INTO `yf_auth_group_access` VALUES ('5', '1', '1');
INSERT INTO `yf_auth_group_access` VALUES ('7', '1', '1');
INSERT INTO `yf_auth_group_access` VALUES ('8', '1', '1');

-- ----------------------------
-- Table structure for yf_auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `yf_auth_rule`;
CREATE TABLE `yf_auth_rule` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` char(80) NOT NULL DEFAULT '' COMMENT '导航链接',
  `title` char(20) NOT NULL DEFAULT '' COMMENT '导航名字',
  `depend_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '来源类型。1module，2plugin，3theme',
  `depend_flag` varchar(30) NOT NULL DEFAULT '' COMMENT '来源标记。如：模块或插件标识',
  `type` tinyint(1) DEFAULT '1' COMMENT '是否支持规则表达式',
  `pid` smallint(6) unsigned DEFAULT '0' COMMENT '上级id',
  `icon` varchar(50) DEFAULT '' COMMENT '图标',
  `condition` char(200) DEFAULT '',
  `is_menu` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否菜单',
  `position` varchar(20) DEFAULT 'left' COMMENT '菜单显示位置。left:左边，top:头部',
  `developer` tinyint(1) NOT NULL DEFAULT '0' COMMENT '开发者',
  `sort` smallint(6) unsigned DEFAULT '99' COMMENT '排序，值越小越靠前',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否有效(0:无效,1:有效)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8 COMMENT='规则表（后台菜单）';

-- ----------------------------
-- Records of yf_auth_rule
-- ----------------------------
INSERT INTO `yf_auth_rule` VALUES ('1', 'admin/dashboard/index', '仪表盘', '1', 'admin', '1', '0', 'fa fa-tachometer', null, '1', 'left', '0', '1', '1519827783', '1507798445', '1');
INSERT INTO `yf_auth_rule` VALUES ('2', 'admin', '系统设置', '1', 'admin', '1', '0', 'fa fa-cog', null, '1', 'left', '0', '2', '1507604200', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('3', 'user/user/', '用户管理', '1', 'user', '1', '0', 'fa fa-users', null, '1', 'left', '0', '5', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('4', 'admin/attachment/index', '附件空间', '1', 'admin', '1', '0', 'fa fa-picture-o', null, '1', 'left', '0', '7', '1527832160', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('5', 'admin/extend/index', '应用中心', '1', 'admin', '1', '0', 'fa fa-cloud', null, '1', 'left', '0', '11', '1527832357', '1518796830', '0');
INSERT INTO `yf_auth_rule` VALUES ('6', 'admin/navigation/index', '前台导航菜单', '1', 'admin', '1', '2', 'fa fa-leaf', null, '1', 'left', '0', '6', '1516203955', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('7', 'user/user/index', '后台用户列表', '1', 'user', '1', '3', 'fa fa-user', null, '1', 'left', '0', '1', '1524735801', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('8', 'admin/auth/role', '角色组', '1', 'user', '1', '15', '', null, '1', 'left', '0', '1', '1506843587', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('9', 'admin/menu/index', '后台菜单管理', '1', 'admin', '1', '2', 'fa fa-inbox', null, '1', 'left', '1', '11', '1517902690', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('10', 'tools', '工具', '1', 'admin', '1', '0', 'fa fa-gavel', null, '1', 'left', '1', '9', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('11', 'admin/database', '安全', '1', 'admin', '1', '10', 'fa fa-database', null, '0', 'left', '0', '12', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('12', 'admin/attachment/setting', '设置', '1', 'admin', '1', '2', '', null, '0', 'left', '0', '0', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('13', 'admin/link/index', '友情链接', '1', 'admin', '1', '10', '', null, '1', 'left', '0', '6', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('14', 'admin/link/edit', '链接编辑', '1', 'admin', '1', '13', '', null, '0', 'left', '0', '1', '1519307879', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('15', 'user/auth', '权限管理', '1', 'user', '1', '0', 'fa fa-sun-o', null, '1', 'left', '0', '4', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('16', 'admin/auth/index', '规则管理', '1', 'admin', '1', '15', 'fa fa-500px', null, '1', 'left', '0', '2', '1520003985', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('17', 'admin/config/edit', '配置编辑或添加', '1', 'admin', '1', '2', '', null, '0', 'left', '0', '6', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('18', 'admin/navigation/edit', '导航编辑或添加', '1', 'admin', '1', '6', '', null, '0', 'left', '0', '1', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('19', 'admin/config/website', '网站设置', '1', 'admin', '1', '2', '', null, '1', 'left', '0', '4', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('20', 'admin/database/index', '数据库管理', '1', 'admin', '1', '10', 'fa fa-database', null, '1', 'left', '0', '13', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('21', 'user/user/resetPassword', '修改密码', '1', 'user', '1', '3', '', '', '1', 'top', '0', '99', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('22', 'admin/theme/index', '主题', '1', 'admin', '1', '5', 'fa fa-cloud', null, '1', 'left', '0', '3', '1518625223', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('23', 'admin/plugins/index', '插件', '1', 'admin', '1', '5', 'fa fa-cloud', null, '1', 'left', '0', '2', '1518625198', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('24', 'admin/modules/index', '模块', '1', 'admin', '1', '5', 'fa fa-cloud', null, '1', 'left', '0', '0', '1518625177', '1518796830', '0');
INSERT INTO `yf_auth_rule` VALUES ('25', 'admin/config/index', '配置管理', '1', 'admin', '1', '2', '', null, '1', 'left', '1', '15', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('26', 'admin/config/group', '系统设置', '1', 'admin', '1', '2', '', null, '1', 'left', '0', '1', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('27', 'admin/action', '系统安全', '1', 'admin', '1', '0', 'fa fa-list-alt', null, '1', 'left', '0', '3', '1518678277', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('28', 'admin/action/index', '用户行为', '1', 'user', '1', '27', null, null, '1', 'left', '0', '1', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('29', 'admin/action/log', '行为日志', '1', 'user', '1', '27', 'fa fa-address-book-o', null, '1', 'left', '0', '2', '1518680430', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('30', 'admin/plugins/hooks', '钩子管理', '1', 'admin', '1', '23', '', null, '0', 'left', '1', '1', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('32', 'admin/mailer/template', '邮件模板', '1', 'admin', '1', '10', null, null, '1', 'left', '0', '5', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('37', 'admin/attachment/attachmentCategory', '附件分类', '1', 'admin', '1', '4', null, null, '0', 'left', '0', '1', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('38', 'admin/attachment/upload', '文件上传', '1', 'admin', '1', '4', null, null, '0', 'left', '0', '1', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('39', 'admin/attachment/uploadPicture', '上传图片', '1', 'admin', '1', '4', null, null, '0', 'left', '0', '1', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('40', 'admin/attachment/upload_onlinefile', '添加外链附件', '1', 'admin', '1', '4', null, null, '0', 'left', '0', '1', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('41', 'admin/attachment/attachmentInfo', '附件详情', '1', 'admin', '1', '4', null, null, '0', 'left', '0', '1', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('42', 'admin/attachment/uploadAvatar', '上传头像', '1', 'admin', '1', '4', null, null, '0', 'left', '0', '1', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('43', 'user/tags/index', '标签管理', '1', 'user', '1', '3', '', null, '1', 'left', '0', '2', '1505816276', '1518796830', '0');
INSERT INTO `yf_auth_rule` VALUES ('44', 'user/tongji/analyze', '会员统计', '1', 'user', '1', '3', '', null, '1', 'left', '0', '4', '1505816276', '1518796830', '1');
INSERT INTO `yf_auth_rule` VALUES ('45', '/admin/follow/index', '关注列表', '1', 'admin', '1', '3', 'fa fa-address-book', '', '1', 'left', '0', '99', '1523781324', '1523781223', '1');
INSERT INTO `yf_auth_rule` VALUES ('46', 'admin/video/index', '视频管理', '1', 'admin', '1', '68', 'fa fa-video-camera', '', '1', 'left', '0', '99', '1529034659', '1523782717', '1');
INSERT INTO `yf_auth_rule` VALUES ('47', '/admin/buildings/index', '小区管理', '1', 'admin', '1', '65', 'fa fa-bank', '', '1', 'left', '0', '99', '1525510573', '1523785017', '1');
INSERT INTO `yf_auth_rule` VALUES ('48', 'admin/comment/index', '评论管理', '1', 'admin', '1', '0', 'fa fa-edit', '', '1', 'left', '0', '99', '1524202829', '1524202780', '1');
INSERT INTO `yf_auth_rule` VALUES ('49', 'admin/config/setParam', '参数管理', '1', 'admin', '1', '2', 'fa fa-asl-interpreting', '', '1', 'left', '0', '99', '1524203703', '1524203357', '1');
INSERT INTO `yf_auth_rule` VALUES ('50', 'version/index', '版本号管理', '1', 'admin', '1', '0', 'fa fa-dashboard', '', '1', 'left', '0', '99', '1524204031', '1524204031', '1');
INSERT INTO `yf_auth_rule` VALUES ('51', 'admin/version/index1', '上传版本', '1', 'admin', '1', '50', 'fa fa-arrow-up', '', '1', 'left', '0', '99', '1524320286', '1524215811', '0');
INSERT INTO `yf_auth_rule` VALUES ('52', 'admin/version/index', '版本列表', '1', 'admin', '1', '50', 'fa fa-align-justify', '', '1', 'left', '0', '99', '1524320272', '1524215904', '1');
INSERT INTO `yf_auth_rule` VALUES ('53', 'user/admin/index', '前台用户列表', '1', 'admin', '1', '3', 'fa fa-user-circle', '', '1', 'left', '0', '1', '1524736306', '1524736229', '1');
INSERT INTO `yf_auth_rule` VALUES ('54', 'admin/music/index', '音乐管理', '1', 'admin', '1', '0', 'fa fa-music', '', '1', 'left', '0', '99', '1524792710', '1524748394', '1');
INSERT INTO `yf_auth_rule` VALUES ('55', '/admin/label/index', '标签管理', '1', 'admin', '1', '0', 'fa fa-align-center', '', '1', 'left', '0', '99', '1524834524', '1524826574', '1');
INSERT INTO `yf_auth_rule` VALUES ('57', 'admin/question/index', '常见问题', '1', 'admin', '1', '0', 'fa fa-question', '', '1', 'left', '0', '99', '1524899759', '1524899759', '1');
INSERT INTO `yf_auth_rule` VALUES ('58', 'admin/report', '举报管理', '1', 'admin', '1', '0', 'fa fa-exclamation', '', '1', 'left', '0', '99', '1528076956', '1524907375', '1');
INSERT INTO `yf_auth_rule` VALUES ('59', 'admin/Account/index', '账单详情管理', '1', '0', '1', '0', 'fa fa-dollar', '', '1', 'left', '0', '5', '1525410771', '1525254006', '1');
INSERT INTO `yf_auth_rule` VALUES ('61', 'admin/buildings/tongji', '小区统计', '1', 'admin', '1', '65', 'fa fa-area-chart', '', '1', 'left', '0', '99', '1525510556', '1525505078', '1');
INSERT INTO `yf_auth_rule` VALUES ('65', 'admin/buildings', '小区', '1', 'admin', '1', '0', 'fa fa-bank', '', '1', 'left', '0', '12', '1525656489', '1525510535', '1');
INSERT INTO `yf_auth_rule` VALUES ('67', '/admin/video/tongji', '视频详情页统计', '1', 'admin', '1', '68', 'fa fa-area-chart', '', '1', 'left', '0', '99', '1525690142', '1525681526', '1');
INSERT INTO `yf_auth_rule` VALUES ('68', '/admin', '视频', '1', 'admin', '1', '0', 'fa fa-video-camera', '', '1', 'left', '0', '15', '1525689945', '1525689945', '1');
INSERT INTO `yf_auth_rule` VALUES ('69', 'admin/video/publishtongji', '视频发布流程统计', '1', 'admin', '1', '68', 'fa fa-area-chart', '', '1', 'left', '0', '99', '1525690167', '1525690109', '1');
INSERT INTO `yf_auth_rule` VALUES ('70', 'admin/video/repaytongji', '视频转发统计', '1', 'admin', '1', '68', 'fa fa-area-chart', '', '1', 'left', '0', '99', '1525694096', '1525694068', '1');
INSERT INTO `yf_auth_rule` VALUES ('71', 'user/admin/tongji', '邀请好友统计', '1', 'admin', '1', '3', 'fa fa-area-chart', '', '1', 'left', '0', '99', '1526453746', '1526453685', '1');
INSERT INTO `yf_auth_rule` VALUES ('72', 'user/share/tongji', '个人主页分享统计', '1', 'admin', '1', '3', 'fa fa-area-chart', '', '1', 'left', '0', '99', '1526547115', '1526547096', '0');
INSERT INTO `yf_auth_rule` VALUES ('73', 'admin/report/report_index', '举报原因管理', '1', 'admin', '1', '58', 'fa fa-question', '', '1', 'left', '0', '99', '1528079033', '1528076914', '1');
INSERT INTO `yf_auth_rule` VALUES ('74', 'admin/report/index', '举报管理', '1', 'admin', '1', '58', 'fa fa-info', '', '1', 'left', '0', '99', '1528077039', '1528077009', '1');
INSERT INTO `yf_auth_rule` VALUES ('75', 'admin/video/trash', '视频回收站', '1', 'admin', '1', '68', 'fa fa-trash-o', '', '1', 'left', '0', '99', '1528870895', '1528869484', '1');
INSERT INTO `yf_auth_rule` VALUES ('76', 'admin/video/createqiniu', '视频审核上传七牛', '1', 'admin', '1', '68', 'fa fa-chrome', '', '1', 'left', '0', '99', '1528870871', '1528870822', '1');
INSERT INTO `yf_auth_rule` VALUES ('77', 'user/admin/share', '邀请好友数量分布', '1', 'admin', '1', '3', 'fa fa-area-chart', '', '1', 'left', '0', '99', '1528884405', '1528884325', '0');
INSERT INTO `yf_auth_rule` VALUES ('78', 'admin/video/uploadVideos', '视频批量上传到七牛云', '1', 'admin', '1', '68', 'fa fa-align-center', '', '1', 'left', '0', '99', '1529402865', '1529401029', '1');
INSERT INTO `yf_auth_rule` VALUES ('79', 'admin/video/verifyList', '视频待审核列表', '1', 'admin', '1', '68', 'fa fa-video-camera', '', '1', 'left', '0', '99', '1529918648', '1529918542', '1');
INSERT INTO `yf_auth_rule` VALUES ('80', 'admin/chat/index', '官方客服', '1', '0', '1', '0', 'fa fa-user-circle-o', '', '1', 'left', '0', '99', '1530148846', '1530003982', '1');
INSERT INTO `yf_auth_rule` VALUES ('81', 'admin/buildings/addBuildingsList', '上报小区', '1', 'admin', '1', '65', 'fa fa-building-o', '', '1', 'left', '0', '99', '1530846147', '1530688871', '1');

-- ----------------------------
-- Table structure for yf_config
-- ----------------------------
DROP TABLE IF EXISTS `yf_config`;
CREATE TABLE `yf_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '配置名称',
  `title` varchar(50) NOT NULL COMMENT '配置说明',
  `value` text NOT NULL COMMENT '配置值',
  `options` varchar(255) NOT NULL COMMENT '配置额外值',
  `group` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '配置分组',
  `sub_group` tinyint(3) DEFAULT '0' COMMENT '子分组，子分组需要自己定义',
  `type` varchar(16) NOT NULL DEFAULT '' COMMENT '配置类型',
  `remark` varchar(500) NOT NULL COMMENT '配置说明',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sort` tinyint(3) unsigned NOT NULL DEFAULT '99' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8 COMMENT='配置表';

-- ----------------------------
-- Records of yf_config
-- ----------------------------
INSERT INTO `yf_config` VALUES ('1', 'toggle_web_site', '站点开关', '1', '0:关闭\r\n1:开启', '1', '0', 'select', '站点关闭后将提示网站已关闭，不能正常访问', '1378898976', '1519825876', '1', '1');
INSERT INTO `yf_config` VALUES ('2', 'web_site_title', '网站标题', '嗨房-不一样的体验', '', '6', '0', 'text', '网站标题前台显示标题', '1378898976', '1507036190', '2', '1');
INSERT INTO `yf_config` VALUES ('4', 'web_site_logo', '网站LOGO', '92', '', '6', '0', 'picture', '网站LOGO', '1407003397', '1507036190', '4', '1');
INSERT INTO `yf_config` VALUES ('5', 'web_site_description', 'SEO描述', '嗨房', '', '6', '1', 'textarea', '网站搜索引擎描述', '1378898976', '1506257875', '6', '1');
INSERT INTO `yf_config` VALUES ('6', 'web_site_keyword', 'SEO关键字', '嗨房', '', '6', '1', 'textarea', '网站搜索引擎关键字', '1378898976', '1506257874', '4', '1');
INSERT INTO `yf_config` VALUES ('7', 'web_site_copyright', '版权信息', 'Copyright © ******有限公司 All rights reserved.', '', '1', '0', 'text', '设置在网站底部显示的版权信息', '1406991855', '1468493911', '7', '1');
INSERT INTO `yf_config` VALUES ('8', 'web_site_icp', '网站备案号', '沪ICP备16002193号-1', '', '6', '0', 'text', '设置在网站底部显示的备案号，如“苏ICP备1502009-2号\"', '1378900335', '1507036190', '8', '1');
INSERT INTO `yf_config` VALUES ('9', 'web_site_statistics', '站点统计', '', '', '1', '0', 'textarea', '支持百度、Google、cnzz等所有Javascript的统计代码', '1378900335', '1415983236', '9', '1');
INSERT INTO `yf_config` VALUES ('10', 'index_url', '首页地址', 'http://admin1.fujuhaofang.com', '', '2', '0', 'text', '可以通过配置此项自定义系统首页的地址，比如：http://www.xxx.com', '1471579753', '1519825834', '0', '1');
INSERT INTO `yf_config` VALUES ('13', 'admin_tags', '后台多标签', '1', '0:关闭\r\n1:开启', '2', '0', 'radio', '', '1453445526', '1519825844', '3', '1');
INSERT INTO `yf_config` VALUES ('14', 'admin_page_size', '后台分页数量', '12', '', '2', '0', 'number', '后台列表分页时每页的记录数', '1434019462', '1518942039', '4', '1');
INSERT INTO `yf_config` VALUES ('15', 'admin_theme', '后台主题', 'default', 'default:默认主题\r\nblue:蓝色理想\r\ngreen:绿色生活', '2', '0', 'select', '后台界面主题', '1436678171', '1506099586', '5', '1');
INSERT INTO `yf_config` VALUES ('16', 'develop_mode', '开发模式', '1', '1:开启\r\n0:关闭', '3', '0', 'select', '开发模式下会显示菜单管理、配置管理、数据字典等开发者工具', '1432393583', '1507724972', '1', '1');
INSERT INTO `yf_config` VALUES ('17', 'app_trace', '是否显示页面Trace', '0', '1:开启\r\n0:关闭', '3', '0', 'select', '是否显示页面Trace信息', '1387165685', '1507724972', '2', '1');
INSERT INTO `yf_config` VALUES ('18', 'auth_key', '系统加密KEY', 'vzxI=vf[=xV)?a^XihbLKx?pYPw$;Mi^R*<mV;yJh$wy(~~E?<.JA&ANdIZ#QhPq', '', '3', '0', 'textarea', '轻易不要修改此项，否则容易造成用户无法登录；如要修改，务必备份原key', '1438647773', '1507724972', '3', '1');
INSERT INTO `yf_config` VALUES ('19', 'only_auth_rule', '权限仅验证规则表', '1', '1:开启\n0:关闭', '4', '0', 'radio', '开启此项，则后台验证授权只验证规则表存在的规则', '1473437355', '1473437355', '0', '1');
INSERT INTO `yf_config` VALUES ('20', 'static_domain', '静态文件独立域名', '', '', '3', '0', 'text', '静态文件独立域名一般用于在用户无感知的情况下平和的将网站图片自动存储到腾讯万象优图、又拍云等第三方服务。', '1438564784', '1438564784', '3', '1');
INSERT INTO `yf_config` VALUES ('21', 'config_group_list', '配置分组', '1:基本\r\n2:系统\r\n3:开发\r\n4:安全\r\n5:数据库\r\n6:网站设置\r\n7:用户\r\n8:邮箱\r\n9:高级\r\n10:参数管理', '', '3', '0', 'array', '配置分组的键值对不要轻易改变', '1379228036', '1518783085', '5', '1');
INSERT INTO `yf_config` VALUES ('25', 'form_item_type', '表单项目类型', 'hidden:隐藏\r\nonlyreadly:仅读文本\r\nnumber:数字\r\ntext:单行文本\r\ntextarea:多行文本\r\narray:数组\r\npassword:密码\r\nradio:单选框\r\ncheckbox:复选框\r\nselect:下拉框\r\nicon:字体图标\r\ndate:日期\r\ndatetime:时间\r\npicture:单张图片\r\npictures:多张图片\r\nfile:单个文件\r\nfiles:多个文件\r\nwangeditor:wangEditor编辑器\r\nueditor:百度富文本编辑器\r\neditormd:Markdown编辑器\r\ntags:标签\r\njson:JSON\r\nboard:拖', '', '3', '0', 'array', '专为配置管理设定\r\n', '1464533806', '1500174666', '0', '1');
INSERT INTO `yf_config` VALUES ('26', 'term_taxonomy', '分类法', 'post_category:分类目录\r\npost_tag:标签\r\nmedia_cat:多媒体分类', '', '3', '0', 'array', '', '1465267993', '1468421717', '0', '1');
INSERT INTO `yf_config` VALUES ('27', 'data_backup_path', '数据库备份根路径', '../data/backup', '', '5', '0', 'text', '', '1465478225', '1506099586', '0', '1');
INSERT INTO `yf_config` VALUES ('28', 'data_backup_part_size', '数据库备份卷大小', '20971520', '', '5', '0', 'number', '', '1465478348', '1506099586', '0', '1');
INSERT INTO `yf_config` VALUES ('29', 'data_backup_compress_level', '数据库备份文件压缩级别', '4', '1:普通\r\n4:一般\r\n9:最高', '5', '0', 'radio', '', '1465478496', '1506099586', '0', '1');
INSERT INTO `yf_config` VALUES ('30', 'data_backup_compress', '数据库备份文件压缩', '1', '0:不压缩\r\n1:启用压缩', '5', '0', 'radio', '', '1465478578', '1506099586', '0', '1');
INSERT INTO `yf_config` VALUES ('31', 'hooks_type', '钩子的类型', '1:视图\r\n2:控制器', '', '3', '0', 'array', '', '1465478697', '1465478697', '0', '1');
INSERT INTO `yf_config` VALUES ('33', 'action_type', '行为类型', '1:系统\r\n2:用户', '1:系统\r\n2:用户', '7', '0', 'array', '配置说明', '1466953086', '1466953086', '0', '1');
INSERT INTO `yf_config` VALUES ('34', 'website_group', '网站信息子分组', '0:基本信息\r\n1:SEO设置\r\n3:其它', '', '6', '0', 'array', '作为网站信息配置的子分组配置，每个大分组可设置子分组作为tab切换', '1467516762', '1518785115', '20', '1');
INSERT INTO `yf_config` VALUES ('36', 'mail_reg_active_template', '注册激活邮件模板', '{\"active\":\"0\",\"subject\":\"\\u6ce8\\u518c\\u6fc0\\u6d3b\\u901a\\u77e5\"}', '', '8', '0', 'json', 'JSON格式保存除了模板内容的属性', '1467519451', '1467519451', '0', '1');
INSERT INTO `yf_config` VALUES ('37', 'mail_captcha_template', '验证码邮件模板', '{\"active\":\"0\",\"subject\":\"\\u90ae\\u7bb1\\u9a8c\\u8bc1\\u7801\\u901a\\u77e5\"}', '', '8', '0', 'json', 'JSON格式保存除了模板内容的属性', '1467519582', '1467818456', '0', '1');
INSERT INTO `yf_config` VALUES ('38', 'mail_reg_active_template_content', '注册激活邮件模板内容', '<p><span style=\"font-family: 微软雅黑; font-size: 14px;\"></span><span style=\"font-family: 微软雅黑; font-size: 14px;\">您在{$title}的激活链接为</span><a href=\"{$url}\" target=\"_blank\" style=\"font-family: 微软雅黑; font-size: 14px; white-space: normal;\">激活</a><span style=\"font-family: 微软雅黑; font-size: 14px;\">，或者请复制链接：{$url}到浏览器打开。</span></p>', '', '8', '0', 'textarea', '注册激活模板邮件内容部分，模板内容单独存放', '1467818340', '1467818340', '0', '1');
INSERT INTO `yf_config` VALUES ('39', 'mail_captcha_template_content', '验证码邮件模板内容', '<p><span style=\"font-family: 微软雅黑; font-size: 14px;\">您的验证码为{$verify}验证码，账号为{$account}。</span></p>', '', '8', '0', 'textarea', '验证码邮件模板内容部分', '1467818435', '1467818435', '0', '1');
INSERT INTO `yf_config` VALUES ('40', 'attachment_options', '附件配置选项', '{\"driver\":\"local\",\"file_max_size\":\"2097152\",\"file_exts\":\"doc,docx,xls,xlsx,ppt,pptx,pdf,wps,txt,zip,rar,gz,bz2,7z\",\"file_save_name\":\"uniqid\",\"image_max_size\":\"2097152\",\"image_exts\":\"gif,jpg,jpeg,bmp,png\",\"image_save_name\":\"uniqid\",\"page_number\":\"24\",\"widget_show_type\":\"0\",\"cut\":\"1\",\"small_size\":{\"width\":\"150\",\"height\":\"150\"},\"medium_size\":{\"width\":\"320\",\"height\":\"280\"},\"large_size\":{\"width\":\"560\",\"height\":\"430\"},\"watermark_scene\":\"2\",\"watermark_type\":\"1\",\"water_position\":\"9\",\"water_img\":\"\\/logo.png\",\"water_opacity\":\"80\"}', '', '9', '0', 'json', '以JSON格式保存', '1467858734', '1519804860', '0', '1');
INSERT INTO `yf_config` VALUES ('42', 'user_deny_username', '保留用户名和昵称', '管理员,测试,admin,垃圾', '', '7', '0', 'textarea', '禁止注册用户名和昵称，包含这些即无法注册,用&quot; , &quot;号隔开，用户只能是英文，下划线_，数字等', '1468493201', '1468493201', '0', '1');
INSERT INTO `yf_config` VALUES ('43', 'captcha_open', '验证码配置', 'reg,login,reset', 'reg:注册显示\r\nlogin:登陆显示\r\nreset:密码重置', '4', '0', 'checkbox', '验证码开启配置', '1468494419', '1506099586', '0', '1');
INSERT INTO `yf_config` VALUES ('44', 'captcha_type', '验证码类型', '4', '1:中文\r\n2:英文\r\n3:数字\r\n4:英文+数字', '4', '0', 'select', '验证码类型', '1468494591', '1506099586', '0', '1');
INSERT INTO `yf_config` VALUES ('45', 'web_site_subtitle', '网站副标题', '找房不再难，真实体验', '', '6', '0', 'textarea', '用简洁的文字描述本站点（网站口号、宣传标语、一句话介绍）', '1468593713', '1507036190', '2', '1');
INSERT INTO `yf_config` VALUES ('46', 'cache', '缓存配置', '{\"type\":\"File\",\"path\":\"\\/Library\\/WebServer\\/Documents\\/EacooPHP\\/runtime\\/cache\\/\",\"prefix\":\"\",\"expire\":\"0\"}', '', '9', '0', 'json', '以JSON格式保存', '1518696015', '1518696015', '0', '1');
INSERT INTO `yf_config` VALUES ('47', 'session', 'Session配置', '{\"type\":\"\",\"prefix\":\"eacoophp_\",\"auto_start\":\"1\"}', '', '9', '0', 'json', '以JSON格式保存', '1518696015', '1518696015', '99', '1');
INSERT INTO `yf_config` VALUES ('48', 'cookie', 'Cookie配置', '{\"path\":\"\\/\",\"prefix\":\"eacoophp_\",\"expire\":\"0\",\"domain\":\"\",\"secure\":\"0\",\"httponly\":\"\",\"setcookie\":\"1\"}', '', '9', '0', 'json', '以JSON格式保存', '1518696015', '1518696015', '99', '1');
INSERT INTO `yf_config` VALUES ('49', 'reg_default_roleid', '注册默认角色', '4', '', '7', '0', 'select', '', '1471681620', '1471689765', '0', '1');
INSERT INTO `yf_config` VALUES ('50', 'open_register', '开放注册', '0', '1:是\r\n0:否', '7', '0', 'radio', '', '1471681674', '1471681674', '0', '1');
INSERT INTO `yf_config` VALUES ('56', 'meanwhile_user_online', '允许同时登录', '1', '1:是\r\n0:否', '7', '0', 'radio', '是否允许同一帐号在不同地方同时登录', '1473437355', '1473437355', '0', '1');
INSERT INTO `yf_config` VALUES ('57', 'admin_collect_menus', '后台收藏菜单', '{\"/admin.php/admin/attachment/setting.html\":{\"title\":\"u591au5a92u4f53u8bbeu7f6e\"},\"/admin.php/admin/auth/index.html\":{\"title\":\"u89c4u5219u7ba1u7406\"},\"/admin.php/admin/modules/index.html\":{\"title\":\"u6a21u5757u5e02u573a\"}}', '', '2', '0', 'json', '在后台顶部菜单栏展示，可以方便快速菜单入口', '1518629152', '1518629152', '99', '1');
INSERT INTO `yf_config` VALUES ('58', 'minify_status', '开启minify', '1', '1:开启\r\n0:关闭', '2', '0', 'radio', '开启minify会压缩合并js、css文件，可以减少资源请求次数，如果不支持minify，可关闭', '1518716395', '1518716395', '99', '1');
INSERT INTO `yf_config` VALUES ('59', 'admin_allow_login_many', '同账号多人登录后台', '0', '0:不允许\r\n1:允许', '2', '0', 'radio', '允许多个人使用同一个账号登录后台。默认：不允许', '1519785747', '1519785747', '99', '1');
INSERT INTO `yf_config` VALUES ('60', 'admin_allow_ip', '仅限登录后台IP', '', '', '4', '0', 'textarea', '填写IP地址，多个IP用英文逗号隔开。默认为空，允许所有IP', '1519828685', '1519828685', '99', '1');
INSERT INTO `yf_config` VALUES ('61', 'user_total', '被邀请用户的总数量', '10', '', '10', '0', 'text', '请输入被邀请的用户总数量', '0', '1524209313', '99', '1');
INSERT INTO `yf_config` VALUES ('62', 'is_video', '全局发布视频权限', '1', '1:是\r\n0:否', '10', '0', 'radio', '', '1524207398', '1531714752', '99', '1');
INSERT INTO `yf_config` VALUES ('63', 'release_video_num', '用户一天可发视频的奖励数量', '1', '', '10', '0', 'text', '', '1524207605', '1529563705', '99', '1');
INSERT INTO `yf_config` VALUES ('65', 'request_register_icon', '外部显示发布视频审核成功后奖励', '10-200', '', '10', '0', 'text', '单位：嗨币。输入范围例如：12-30 [英文横杠]', '1524208441', '1529649763', '98', '1');
INSERT INTO `yf_config` VALUES ('66', 'forward_read_icon', '转发阅读奖励金额', '1', '', '10', '0', 'text', '单位：嗨币', '1524208588', '1529567595', '99', '1');
INSERT INTO `yf_config` VALUES ('67', 'create_video_icon', '邀请用户注册奖励', '30', '', '10', '0', 'text', '单位：嗨币', '1524208724', '1529572095', '99', '1');
INSERT INTO `yf_config` VALUES ('68', 'report_icon', '举报核实奖励金额', '5', '', '10', '0', 'text', '单位：嗨币', '1524208768', '1529567613', '99', '1');
INSERT INTO `yf_config` VALUES ('69', 'examine', '提现金额超出由管理员审核', '0', '', '10', '0', 'text', '', '1525412722', '1525412722', '99', '1');
INSERT INTO `yf_config` VALUES ('70', 'invite_title', '邀请栏标题', '邀请好友一起玩，瓜分百万现金！', '', '10', '0', 'text', '', '1525506053', '1525506053', '99', '1');
INSERT INTO `yf_config` VALUES ('71', 'invite_info', '邀请栏详情', '每邀请一个好友，最多可得20元', '', '10', '0', 'text', '', '1525506088', '1525506088', '99', '1');
INSERT INTO `yf_config` VALUES ('72', 'put_forward_alipay', '提现到支付宝金额', '5', '', '10', '0', 'text', '单位：元', '1526365936', '1529567652', '99', '1');
INSERT INTO `yf_config` VALUES ('73', 'video_total_reward', '一个人一天视频的最多奖励总额', '50', '', '10', '0', 'text', '单位：嗨币', '1526382723', '1529656565', '99', '1');
INSERT INTO `yf_config` VALUES ('74', 'register_icon', '注册用户奖励金额', '30', '5', '10', '0', 'text', '单位：嗨币', '1526610105', '1529567674', '99', '1');
INSERT INTO `yf_config` VALUES ('75', 'exchange_icon', '一块钱兑换嗨币', '10', '', '10', '0', 'text', '', '1526971898', '1526971980', '99', '1');
INSERT INTO `yf_config` VALUES ('77', 'ios_index_switch', 'ios首页接口', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"code\":1,\"img\":\"https://yftest.fujuhaofang.com/uploads/picture/2018-05-22/5b03780844e04.png\",\"text\":\"福居嗨房是一个原创短视频社区平台,致力于打破现有房地产信息平台上虚假房源,虚假宣传的乱象,为经纪人和消费者提供真实的房源信息,同时帮助经纪人打造个人品牌。\r\n\r\n福居嗨房采用时下最流行的基于区块链的token经济模型,对用户进行多次优于物质的激励,使经纪人和消费者的角色发生变化,在不同的时间轴上贡献出自己的权重。\r\n\r\n福居嗨房的目标是服务百万经纪人和千万消费者!\r\n\r\n 福居嗨房是一个原创短视频社区平台,致力于打破现有房地产信息平台上虚假房源,虚假宣传的乱象,为经纪人和消费者提供真实的房源信息,同时帮助经纪人打造个人品牌。\r\n\r\n福居嗨房采用时下最流行的基于区块链的token经济模型,对用户进行多次优于物质的激励,使经纪人和消费者的角色发生变化,在不同的时间轴上贡献出自己的权重。\r\n\r\n福居嗨房的目标是服务百万经纪人和千万消费者!\r\n\r\n\",\"button\":{\"button_text\":\"进入\",\"button_key\":\"publish\"}}}', '', '10', '0', 'textarea', '', '1527068286', '1527068331', '99', '1');
INSERT INTO `yf_config` VALUES ('78', 'put_forward_money', '可提现数额', '5，10，15，20，25', '', '10', '0', 'text', '每个金额间请用中文逗号隔开', '1529486071', '1530251694', '99', '1');
INSERT INTO `yf_config` VALUES ('79', 'create_money', '内部显示发布视频审核成功后奖励', '10-50', '', '10', '0', 'text', '单位：嗨币。输入范围例如：12-30 [英文横杠]', '1529649738', '1529649837', '97', '1');
INSERT INTO `yf_config` VALUES ('80', 'rent_down_time', '出租房源自动下架时间', '7', '', '10', '0', 'text', '单位：天', '1529893175', '1529893242', '99', '1');
INSERT INTO `yf_config` VALUES ('81', 'sell_down_time', '出售房源自动下架时间', '7', '', '10', '0', 'text', '单位：天', '1529893206', '1529893251', '99', '1');
INSERT INTO `yf_config` VALUES ('82', 'kefu_member_id', '客服id', '2243', '', '10', '0', 'number', '客服用户id', '1529922026', '1530266897', '99', '1');
INSERT INTO `yf_config` VALUES ('83', 'kefu_info', '客服消息', '{\"username\":\"\\u55e8\\u623f\\u5ba2\\u6237\",\"avatar\":\"https://hifang.fujuhaofang.com/uploads/picture/2018-07-02/5b39f930eb142.png\",\"fromid\":\"2243\",\"type\":\"friend\",\"content\":\"\\u55e8\\u623f\\u662f\\u4e00\\u4e2a\\u539f\\u521b\\u771f\\u623f\\u6e90\\u77ed\\u89c6\\u9891\\u793e\\u533a\\u5e73\\u53f0 \\u623f\\u6e90\\u62cd\\u6444\\u6807\\u51c6\\uff1a\\n 1\\u3001\\u7ad6\\u62cd\\uff1b\\n 2\\u3001\\u62cd\\u6444\\u4e2d\\u4e0d\\u80fd\\u6296\\u52a8\\uff1b\\n 3\\u3001\\u4fdd\\u6301\\u623f\\u95f4\\u201c\\u5ba4-\\u5385-\\u536b\\u201d\\u7ed3\\u6784\\u5b8c\\u6574\\uff1b\\n 4\\u3001\\u4fdd\\u6301\\u5149\\u7ebf\\u660e\\u4eae\\uff0c\\u80fd\\u770b\\u6e05\\u623f\\u95f4\\u5185\\u73af\\u5883\\u7ec6\\u8282\\uff1b\\n 5\\u3001\\u540c\\u4e00\\u4e2a\\u623f\\u6e90\\u53ea\\u80fd\\u62cd\\u6444\\u4e00\\u4e2a\\u89c6\\u9891\\u3002\\n \\u89c6\\u9891\\u89c4\\u8303\\uff1a\\n 1\\u3001\\u4e0d\\u662f\\u623f\\u6e90\\u89c6\\u9891\\uff1b\\n 2\\u3001\\u89c6\\u9891\\u4e2d\\u4e0d\\u80fd\\u51fa\\u73b0\\u5176\\u4ed6\\u5e73\\u53f0\\u3001\\u7ad9\\u5916\\u5e97\\u94fa\\u7684\\u4e8c\\u7ef4\\u7801\\u4fe1\\u606f\\uff1b\\n 3\\u3001\\u4e0d\\u80fd\\u4ee5\\u6587\\u5b57\\u6216\\u53e3\\u64ad\\u5f62\\u5f0f\\u5f15\\u5bfc\\u7528\\u6237\\u52a0QQ\\u3001\\u5fae\\u4fe1\\uff0c\\u5b89\\u5c45\\u5ba2\\u7b49\\u5176\\u4ed6\\u5e73\\u53f0\\uff1b\\n 4\\u3001\\u4e0d\\u80fd\\u51fa\\u73b0\\u6d89\\u5acc\\u8272\\u60c5\\u4f4e\\u4fd7\\u3001\\u8fdd\\u53cd\\u6cd5\\u5f8b\\u6cd5\\u89c4\\u3001\\u5f15\\u4eba\\u4e0d\\u9002\\u7684\\u89c6\\u9891\\u5185\\u5bb9\\u3002\\n \\u83b7\\u5f97\\u5956\\u52b1\\u65b9\\u5f0f\\uff1a\\n 1\\u3001\\u6ce8\\u518c 2\\u3001\\u53d1\\u5e03\\u623f\\u6e90\\u89c6\\u9891\\n 3\\u3001\\u8f6c\\u53d1\\u623f\\u6e90\\u89c6\\u9891\\n 4\\u3001\\u9080\\u8bf7\\u597d\\u53cb\",\"toid\":\"578\",\"mine\":false,\"timestamp\":1530178496692.6,\"id\":\"2243\"}\r\n', '', '10', '0', '', '', '1529922238', '1530526724', '99', '1');
INSERT INTO `yf_config` VALUES ('84', 'kefu_info', '客服消息', '{\"username\":\"\\u55e8\\u623f\\u5ba2\\u6237\",\"avatar\":\"https://hifang.fujuhaofang.com/uploads/picture/2018-07-02/5b39f930eb142.png\",\"fromid\":\"2243\",\"type\":\"friend\",\r\n\"content\":\"\\u60a8\\u597d\\uff0c\\u8fd9\\u91cc\\u662f\\u55e8\\u623f\\u5b98\\u65b9\\u5ba2\\u670d\\uff01 \\u4f7f\\u7528\\u7591\\u95ee\\u6216\\u4ea7\\u54c1\\u5efa\\u8bae\\u53ef\\u4ee5\\u76f4\\u63a5\\u56de\\u590d\\u6b64\\u6d88\\u606f\\u3002\",\r\n\"toid\":\"578\",\"mine\":false,\"timestamp\":1530178496692.6,\"id\":\"2243\"}', '', '10', '0', '', '', '1529922238', '1530526738', '99', '1');
INSERT INTO `yf_config` VALUES ('85', 'radius', '查找小区半径', '0.6', '', '10', '0', 'text', '半径：千米', '1530500774', '1530500854', '99', '1');
INSERT INTO `yf_config` VALUES ('86', 'find_radius', '手动搜索小区半径', '1.5', '单位：千米', '10', '0', 'text', '', '1530500907', '1530500907', '99', '1');
INSERT INTO `yf_config` VALUES ('87', 'imageurl', '首页红包弹窗头像', '110', '', '10', '0', 'picture', '', '1530682848', '1530682848', '99', '1');
INSERT INTO `yf_config` VALUES ('88', 'packetSender', '红包发送人', 'c罗', '', '10', '0', 'text', '', '1530683578', '1530683578', '99', '1');
INSERT INTO `yf_config` VALUES ('89', 'packetOperation', '红包操作', '给你发了一个红包', '', '10', '0', 'text', '', '1530683630', '1530683630', '99', '1');
INSERT INTO `yf_config` VALUES ('90', 'packageNotes', '红包备注', '你是最棒的', '', '10', '0', 'text', '', '1530683862', '1530683862', '99', '1');
INSERT INTO `yf_config` VALUES ('91', 'amount', '发送红包金额', '30', '', '10', '0', 'text', '单位：元', '1530687514', '1530687514', '99', '1');
INSERT INTO `yf_config` VALUES ('92', 'is_open', '是否开启活动', '1', '1:是\r\n0:否', '10', '0', 'radio', '1开启 0关闭', '1531714613', '1531714764', '99', '1');
INSERT INTO `yf_config` VALUES ('93', 'activity_img', '活动图片', '111', '', '10', '0', 'text', '', '1531714879', '1531714892', '99', '1');
INSERT INTO `yf_config` VALUES ('94', 'activity_url', '活动链接', '111', '', '10', '0', 'text', '', '1531714916', '1531714916', '99', '1');
INSERT INTO `yf_config` VALUES ('95', 'is_open1', '开启首页弹框', '1', '', '10', '0', 'radio', '1:开启\r\n0:关闭', '1531732990', '1531732990', '99', '1');
INSERT INTO `yf_config` VALUES ('96', 'activity_img1', '首页弹框图片', '111', '', '10', '0', 'text', '', '1531733029', '1531733029', '99', '1');
INSERT INTO `yf_config` VALUES ('97', 'activity_url1', '首页弹框链接', '11', '', '10', '0', 'text', '', '1531733065', '1531733081', '99', '1');

-- ----------------------------
-- Table structure for yf_hf_account_details
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_account_details`;
CREATE TABLE `yf_hf_account_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `Recommend_member_id` varchar(100) DEFAULT '0' COMMENT '邀请好友id/通过微信授权观看视频用户的unionid',
  `withdrawals_id` int(11) DEFAULT '0' COMMENT '提现id',
  `video_id` int(11) DEFAULT NULL COMMENT '视频ID',
  `money` decimal(10,2) DEFAULT '0.00' COMMENT '金额（嗨币）',
  `is_lock` int(255) DEFAULT '0' COMMENT '是1否0锁定',
  `type` int(11) NOT NULL COMMENT '变动类型：收入（1发布视频，2推荐视频，3邀请好友，7 举报核实 8被邀请注册，9填写邀请码赠送500币），支出 （4获取推荐位，5提现），退入（6支付宝提现失败，退回账户）',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态:0处理中，1成功,2失败',
  `pay_status` int(11) DEFAULT '0' COMMENT '支付状态:1支付成功，其它失败',
  `remarks` varchar(500) DEFAULT NULL COMMENT '备注',
  `img` varchar(200) DEFAULT NULL COMMENT '转账截图',
  `pay_msg` varchar(500) DEFAULT NULL COMMENT '支付消息',
  `order_id` varchar(300) DEFAULT NULL COMMENT '支付宝交易码',
  `pay_date` varchar(100) DEFAULT NULL COMMENT '支付宝转账日期',
  `payee_account` varchar(300) DEFAULT NULL COMMENT '收款支付宝',
  `amount` decimal(10,2) DEFAULT '0.00' COMMENT '实际转出金额',
  `payer_show_name` varchar(200) DEFAULT NULL COMMENT '转出名称，默认公司名',
  `payee_real_name` varchar(200) DEFAULT NULL COMMENT '支付宝姓名',
  `payremark` varchar(200) DEFAULT NULL COMMENT '转账备注',
  `nickname` varchar(300) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(500) DEFAULT NULL COMMENT '支付宝头像',
  `app_version` varchar(20) DEFAULT NULL COMMENT '用户当前版本',
  `create_time` int(10) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(10) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4729 DEFAULT CHARSET=utf8 COMMENT='账户流水明细表';

-- ----------------------------
-- Records of yf_hf_account_details
-- ----------------------------
INSERT INTO `yf_hf_account_details` VALUES ('3566', '522', '0', '0', '694', '4.00', '0', '1', '1', '0', '', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528003047', '1528097919');
INSERT INTO `yf_hf_account_details` VALUES ('3569', '587', '0', '0', '694', '5.00', '0', '7', '2', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528008159', '1528118630');
INSERT INTO `yf_hf_account_details` VALUES ('3570', '522', '0', '0', '695', '4.00', '0', '1', '1', '0', '', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528008199', '1528018999');
INSERT INTO `yf_hf_account_details` VALUES ('3571', '449', '0', '0', '696', '4.00', '0', '1', '2', '0', '111', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528008513', '1528119760');
INSERT INTO `yf_hf_account_details` VALUES ('3572', '521', '0', '0', '697', '4.00', '0', '1', '2', '0', '1111', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528011495', '1528120697');
INSERT INTO `yf_hf_account_details` VALUES ('3573', '587', '0', '0', '698', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528011873', '1528011873');
INSERT INTO `yf_hf_account_details` VALUES ('3574', '587', '0', '0', '699', '4.00', '0', '1', '2', '0', '111', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528012621', '1528119795');
INSERT INTO `yf_hf_account_details` VALUES ('3575', '449', '0', '0', '700', '4.00', '0', '1', '1', '0', '', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528013061', '1528367127');
INSERT INTO `yf_hf_account_details` VALUES ('3576', '449', '0', '0', '701', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528015093', '1528015093');
INSERT INTO `yf_hf_account_details` VALUES ('3577', '586', '0', '0', '702', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528015669', '1528015669');
INSERT INTO `yf_hf_account_details` VALUES ('3578', '522', '0', '0', '703', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528018075', '1528018075');
INSERT INTO `yf_hf_account_details` VALUES ('3580', '2022', '', '0', null, '5.00', '0', '8', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528018562', '1528018562');
INSERT INTO `yf_hf_account_details` VALUES ('3582', '2023', '', '0', null, '5.00', '0', '8', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528018757', '1528018757');
INSERT INTO `yf_hf_account_details` VALUES ('3584', '586', '0', '0', '704', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528019124', '1528019124');
INSERT INTO `yf_hf_account_details` VALUES ('3586', '473', '0', '0', '705', '4.00', '0', '1', '1', '0', '', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528020470', '1528020991');
INSERT INTO `yf_hf_account_details` VALUES ('3587', '473', '0', '0', '705', '5.00', '0', '7', '1', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528021046', '1528021081');
INSERT INTO `yf_hf_account_details` VALUES ('3589', '521', '0', '0', '706', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528022482', '1528022482');
INSERT INTO `yf_hf_account_details` VALUES ('3592', '449', '0', '0', '709', '4.00', '0', '1', '2', '0', '不通过不通过', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528028240', '1528367145');
INSERT INTO `yf_hf_account_details` VALUES ('3593', '2026', '0', '0', '709', '5.00', '0', '7', '0', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528030449', '1528030449');
INSERT INTO `yf_hf_account_details` VALUES ('3595', '521', '0', '0', '711', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528033636', '1528033636');
INSERT INTO `yf_hf_account_details` VALUES ('3596', '449', '0', '0', '712', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528040781', '1528040781');
INSERT INTO `yf_hf_account_details` VALUES ('3597', '570', '0', '0', '712', '5.00', '0', '7', '0', '0', '8.假房源', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528076360', '1528076360');
INSERT INTO `yf_hf_account_details` VALUES ('3598', '570', '0', '0', '703', '5.00', '0', '7', '2', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528076790', '1528120191');
INSERT INTO `yf_hf_account_details` VALUES ('3599', '570', '0', '0', '701', '5.00', '0', '7', '0', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528077071', '1528077071');
INSERT INTO `yf_hf_account_details` VALUES ('3600', '570', '0', '0', '698', '5.00', '0', '7', '0', '0', '8.假房源', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528077230', '1528077230');
INSERT INTO `yf_hf_account_details` VALUES ('3601', '516', '0', '0', '713', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528077286', '1528077286');
INSERT INTO `yf_hf_account_details` VALUES ('3602', '570', '0', '0', '713', '5.00', '0', '7', '0', '0', '14.77715.999', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528077393', '1528077393');
INSERT INTO `yf_hf_account_details` VALUES ('3603', '516', '0', '0', '714', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528077511', '1528077511');
INSERT INTO `yf_hf_account_details` VALUES ('3604', '521', '0', '0', '698', '5.00', '0', '7', '1', '0', '6.广告太多8.假房源11.广告内容,非视频内容', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528077548', '1528187068');
INSERT INTO `yf_hf_account_details` VALUES ('3605', '570', '0', '0', '690', '5.00', '0', '7', '0', '0', '8.假房源', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528077678', '1528077678');
INSERT INTO `yf_hf_account_details` VALUES ('3606', '0', '473', '0', null, '0.00', '0', '3', '0', '0', '被邀请的用户总数量已满', null, null, null, null, null, '0.00', null, null, null, '有魅力踢红牛', null, '1.0.0', '1528078597', '1528078597');
INSERT INTO `yf_hf_account_details` VALUES ('3607', '473', '2034', '0', null, '40.00', '0', '3', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528079286', '1528079286');
INSERT INTO `yf_hf_account_details` VALUES ('3608', '2034', '', '0', null, '5.00', '0', '8', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528079286', '1528079286');
INSERT INTO `yf_hf_account_details` VALUES ('3609', '5', '0', '0', '523', '5.00', '0', '7', '0', '0', '6.广告太多8.假房源11.广告内容,非视频内容', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528079327', '1528079327');
INSERT INTO `yf_hf_account_details` VALUES ('3610', '0', '473', '0', null, '0.00', '0', '3', '0', '0', '被邀请的用户总数量已满', null, null, null, null, null, '0.00', null, null, null, '耍酷有音响', null, '1.0.0', '1528079334', '1528079334');
INSERT INTO `yf_hf_account_details` VALUES ('3611', '449', '0', '0', '715', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528079487', '1528079487');
INSERT INTO `yf_hf_account_details` VALUES ('3612', '570', '0', '0', '691', '5.00', '0', '7', '0', '0', '11.广告内容,非视频内容', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528080033', '1528080033');
INSERT INTO `yf_hf_account_details` VALUES ('3613', '449', '0', '0', '716', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528080067', '1528080067');
INSERT INTO `yf_hf_account_details` VALUES ('3614', '570', '0', '0', '694', '5.00', '0', '7', '0', '0', '11.广告内容,非视频内容', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528080270', '1528080270');
INSERT INTO `yf_hf_account_details` VALUES ('3615', '449', '0', '0', '717', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528080535', '1528080535');
INSERT INTO `yf_hf_account_details` VALUES ('3616', '570', '0', '0', '717', '5.00', '0', '7', '0', '0', '11.广告内容,非视频内容', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528080555', '1528080555');
INSERT INTO `yf_hf_account_details` VALUES ('3617', '0', '473', '0', null, '0.00', '0', '3', '0', '0', '被邀请的用户总数量已满', null, null, null, null, null, '0.00', null, null, null, '啤酒帅气', null, '1.0.0', '1528080619', '1528080619');
INSERT INTO `yf_hf_account_details` VALUES ('3618', '513', '0', '0', '717', '5.00', '0', '7', '0', '0', '11.广告内容,非视频内容', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528080809', '1528080809');
INSERT INTO `yf_hf_account_details` VALUES ('3620', '513', '0', '0', '718', '5.00', '0', '7', '0', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528080987', '1528080987');
INSERT INTO `yf_hf_account_details` VALUES ('3621', '513', '0', '0', '713', '5.00', '0', '7', '0', '0', '11.广告内容,非视频内容', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528081151', '1528081151');
INSERT INTO `yf_hf_account_details` VALUES ('3622', '2037', '473', '0', null, '0.00', '0', '3', '1', '0', '被邀请的用户总数量已满', null, null, null, null, null, '0.00', null, null, null, '悲凉迎裙子', null, '1.0.0', '1528081158', '1528081158');
INSERT INTO `yf_hf_account_details` VALUES ('3623', '5', '0', '0', '611', '5.00', '0', '7', '0', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528081296', '1528081296');
INSERT INTO `yf_hf_account_details` VALUES ('3624', '449', '0', '0', '718', '5.00', '0', '7', '1', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528081370', '1528359830');
INSERT INTO `yf_hf_account_details` VALUES ('3625', '449', '0', '0', '712', '5.00', '0', '7', '2', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528081567', '1528359846');
INSERT INTO `yf_hf_account_details` VALUES ('3626', '2038', '473', '0', null, '0.00', '0', '3', '1', '0', '被邀请的用户总数量已满', null, null, null, null, null, '0.00', null, null, null, '沉默与大白', null, '1.0.0', '1528081572', '1528081572');
INSERT INTO `yf_hf_account_details` VALUES ('3627', '473', '2039', '0', null, '49.00', '0', '3', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528081632', '1528081632');
INSERT INTO `yf_hf_account_details` VALUES ('3628', '2039', '', '0', null, '5.00', '0', '8', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528081632', '1528081632');
INSERT INTO `yf_hf_account_details` VALUES ('3631', '449', '0', '0', '690', '5.00', '0', '7', '1', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528081853', '1528359855');
INSERT INTO `yf_hf_account_details` VALUES ('3632', '473', '2041', '0', null, '48.00', '0', '3', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528081935', '1528081935');
INSERT INTO `yf_hf_account_details` VALUES ('3633', '2041', '', '0', null, '5.00', '0', '8', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528081935', '1528081935');
INSERT INTO `yf_hf_account_details` VALUES ('3634', '473', '2042', '0', null, '29.00', '0', '3', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528081990', '1528081990');
INSERT INTO `yf_hf_account_details` VALUES ('3635', '2042', '', '0', null, '5.00', '0', '8', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528081990', '1528081990');
INSERT INTO `yf_hf_account_details` VALUES ('3636', '473', '2043', '0', null, '36.00', '0', '3', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528082246', '1528082246');
INSERT INTO `yf_hf_account_details` VALUES ('3637', '2043', '', '0', null, '5.00', '0', '8', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528082246', '1528082246');
INSERT INTO `yf_hf_account_details` VALUES ('3639', '449', '0', '0', '691', '5.00', '0', '7', '0', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528082772', '1528082772');
INSERT INTO `yf_hf_account_details` VALUES ('3640', '513', '0', '0', '719', '5.00', '0', '7', '0', '0', '11.广告内容,非视频内容', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528083533', '1528083533');
INSERT INTO `yf_hf_account_details` VALUES ('3641', '577', '0', '0', '719', '5.00', '0', '7', '0', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528083804', '1528083804');
INSERT INTO `yf_hf_account_details` VALUES ('3642', '577', '0', '0', '717', '5.00', '0', '7', '0', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528086399', '1528086399');
INSERT INTO `yf_hf_account_details` VALUES ('3643', '577', '0', '0', '718', '5.00', '0', '7', '0', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528086630', '1528086630');
INSERT INTO `yf_hf_account_details` VALUES ('3644', '577', '0', '0', '713', '5.00', '0', '7', '0', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528086758', '1528086758');
INSERT INTO `yf_hf_account_details` VALUES ('3646', '449', '0', '0', '709', '5.00', '0', '7', '0', '0', '8.假房源', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528089442', '1528089442');
INSERT INTO `yf_hf_account_details` VALUES ('3649', '513', '0', '0', '701', '5.00', '0', '7', '0', '0', '11.广告内容,非视频内容', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528090250', '1528090250');
INSERT INTO `yf_hf_account_details` VALUES ('3652', '515', '0', '0', '720', '4.00', '0', '1', '1', '0', '', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528093655', '1528094276');
INSERT INTO `yf_hf_account_details` VALUES ('3653', '5', '0', '0', '520', '5.00', '0', '7', '0', '0', '6.广告太多', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528094765', '1528094765');
INSERT INTO `yf_hf_account_details` VALUES ('3654', '577', '0', '0', '720', '5.00', '0', '7', '0', '0', '8.假房源', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528094881', '1528094881');
INSERT INTO `yf_hf_account_details` VALUES ('3656', '2044', '', '0', null, '5.00', '0', '8', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528095049', '1528095049');
INSERT INTO `yf_hf_account_details` VALUES ('3660', '513', '0', '0', '720', '5.00', '0', '7', '0', '0', '8.假房源', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528095607', '1528095607');
INSERT INTO `yf_hf_account_details` VALUES ('3662', '2045', '', '0', null, '5.00', '0', '8', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528095616', '1528095616');
INSERT INTO `yf_hf_account_details` VALUES ('3664', '522', '2025', '0', null, '46.00', '0', '3', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, '追寻', null, '1.0.0', '1528096081', '1528096081');
INSERT INTO `yf_hf_account_details` VALUES ('3665', '2046', '2047', '0', null, '29.00', '0', '3', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528097043', '1528097043');
INSERT INTO `yf_hf_account_details` VALUES ('3666', '2047', '', '0', null, '5.00', '0', '8', '1', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528097043', '1528097043');
INSERT INTO `yf_hf_account_details` VALUES ('3668', '2046', '0', '0', '723', '4.00', '0', '1', '1', '0', '', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528097250', '1528097292');
INSERT INTO `yf_hf_account_details` VALUES ('3670', '2025', '0', '0', '724', '4.00', '0', '1', '1', '0', '', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528097544', '1528099489');
INSERT INTO `yf_hf_account_details` VALUES ('3671', '2025', '0', '0', '724', '5.00', '0', '7', '1', '0', '8.假房源', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528097675', '1528097710');
INSERT INTO `yf_hf_account_details` VALUES ('3673', '2025', '0', '0', '725', '4.00', '0', '1', '1', '0', '', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528098074', '1528098752');
INSERT INTO `yf_hf_account_details` VALUES ('3674', '2046', '0', '0', '726', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528100087', '1528100087');
INSERT INTO `yf_hf_account_details` VALUES ('3675', '2025', '0', '0', '727', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528101733', '1528101733');
INSERT INTO `yf_hf_account_details` VALUES ('3676', '473', '586', '0', null, '26.00', '0', '3', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, '宋健', null, '1.0.0', '1528102988', '1528102988');
INSERT INTO `yf_hf_account_details` VALUES ('3677', '586', '0', '0', '728', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528103133', '1528103133');
INSERT INTO `yf_hf_account_details` VALUES ('3678', '514', '0', '0', '729', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528103588', '1528103588');
INSERT INTO `yf_hf_account_details` VALUES ('3679', '473', '0', '0', '730', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528104450', '1528104450');
INSERT INTO `yf_hf_account_details` VALUES ('3680', '514', '0', '0', '731', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528104530', '1528104530');
INSERT INTO `yf_hf_account_details` VALUES ('3681', '2046', '0', '0', '732', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528104831', '1528104831');
INSERT INTO `yf_hf_account_details` VALUES ('3682', '517', '0', '0', '733', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528107417', '1528107417');
INSERT INTO `yf_hf_account_details` VALUES ('3683', '586', '0', '0', '734', '4.00', '0', '1', '1', '0', '', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528108395', '1528181083');
INSERT INTO `yf_hf_account_details` VALUES ('3684', '522', '2050', '0', null, '15.00', '0', '3', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, '追寻', null, '1.0.0', '1528108564', '1528108564');
INSERT INTO `yf_hf_account_details` VALUES ('3685', '581', '0', '0', '735', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528108596', '1528108596');
INSERT INTO `yf_hf_account_details` VALUES ('3686', '581', '0', '0', '736', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528108684', '1528108684');
INSERT INTO `yf_hf_account_details` VALUES ('3687', '2050', '0', '0', '737', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528108724', '1528108724');
INSERT INTO `yf_hf_account_details` VALUES ('3688', '2046', '0', '0', '738', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528108929', '1528108929');
INSERT INTO `yf_hf_account_details` VALUES ('3689', '516', '0', '0', '739', '4.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528109351', '1528109351');
INSERT INTO `yf_hf_account_details` VALUES ('3690', '522', '2051', '0', null, '0.00', '0', '3', '0', '0', '被邀请的用户总数量已满', null, null, null, null, null, '0.00', null, null, null, '追寻', null, '1.0.0', '1528109551', '1528109551');
INSERT INTO `yf_hf_account_details` VALUES ('3692', '522', '0', '522', null, '0.00', '0', '5', '1', '0', '备注', null, null, '20181528112456', null, '(null)', '0.00', '嗨房提现操作', null, null, null, null, '1.0.0', '1528112456', '1528112456');
INSERT INTO `yf_hf_account_details` VALUES ('3693', '513', '0', '0', '740', '5.00', '0', '1', '0', '0', null, null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528112604', '1528112604');
INSERT INTO `yf_hf_account_details` VALUES ('3694', '513', '0', '0', '740', '5.00', '0', '7', '1', '0', '8.假房源', null, null, null, null, null, '0.00', null, null, null, null, null, null, '1528113629', '1528113661');

-- ----------------------------
-- Table structure for yf_hf_alipay_users
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_alipay_users`;
CREATE TABLE `yf_hf_alipay_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `alipay_id` varchar(200) DEFAULT NULL COMMENT '支付宝id',
  `create_time` int(11) DEFAULT NULL COMMENT '添加日期',
  `update_time` int(11) DEFAULT NULL COMMENT '修改日期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='支付宝授权用户';

-- ----------------------------
-- Records of yf_hf_alipay_users
-- ----------------------------
INSERT INTO `yf_hf_alipay_users` VALUES ('1', '565', '24589763159', '1526895107', '1526895107');
INSERT INTO `yf_hf_alipay_users` VALUES ('2', '520', '2088302497061411', '1527155355', '1527478202');
INSERT INTO `yf_hf_alipay_users` VALUES ('3', '513', '2088912118917212', '1528115710', '1528115710');
INSERT INTO `yf_hf_alipay_users` VALUES ('4', '514', '2088302285680002', '1528117381', '1528169335');
INSERT INTO `yf_hf_alipay_users` VALUES ('5', '2071', '2088912118917212', '1528187889', '1528187889');
INSERT INTO `yf_hf_alipay_users` VALUES ('6', '473', '2088312535688632', '1528188399', '1528454408');
INSERT INTO `yf_hf_alipay_users` VALUES ('7', '2092', '2088912118917212', '1528200164', '1528200164');
INSERT INTO `yf_hf_alipay_users` VALUES ('8', '599', '2088602103627236', '1528370556', '1528374631');
INSERT INTO `yf_hf_alipay_users` VALUES ('9', '2184', '2088912118917212', '1528379145', '1529648819');
INSERT INTO `yf_hf_alipay_users` VALUES ('10', '579', '2088302285680002', '1528447277', '1531734891');
INSERT INTO `yf_hf_alipay_users` VALUES ('11', '2223', '2088912118917212', '1529567036', '1529650103');
INSERT INTO `yf_hf_alipay_users` VALUES ('12', '598', '2088402059271387', '1529637923', '1529650356');
INSERT INTO `yf_hf_alipay_users` VALUES ('13', '575', '2088302497061411', '1529646053', '1530258125');
INSERT INTO `yf_hf_alipay_users` VALUES ('14', '2231', '2088912118917212', '1530166918', '1530166918');
INSERT INTO `yf_hf_alipay_users` VALUES ('15', '2243', '2088912118917212', '1530241053', '1531467000');

-- ----------------------------
-- Table structure for yf_hf_area
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_area`;
CREATE TABLE `yf_hf_area` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `dic_key` varchar(100) DEFAULT NULL COMMENT '关键字',
  `dic_value` varchar(100) DEFAULT NULL COMMENT '值',
  `fa_value` varchar(100) DEFAULT NULL COMMENT '父值',
  `other` varchar(100) DEFAULT NULL COMMENT '备用',
  `dic_frvalue` varchar(100) DEFAULT NULL COMMENT '法语国家名称',
  `send_fee` float DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `dic_key` (`dic_key`) USING BTREE,
  KEY `dic_value` (`dic_value`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=717 DEFAULT CHARSET=utf8 COMMENT='地区数据';

-- ----------------------------
-- Records of yf_hf_area
-- ----------------------------
INSERT INTO `yf_hf_area` VALUES ('0', '市', '未知区域', null, 'WeiZhiArea', null, null);
INSERT INTO `yf_hf_area` VALUES ('1', '国家', '阿鲁巴', '', 'Aruba', 'Aruba', '240.5');
INSERT INTO `yf_hf_area` VALUES ('2', '国家', '阿富汗', '', 'Afghanistan', 'Afghanistan', '240.5');
INSERT INTO `yf_hf_area` VALUES ('3', '国家', '安哥拉', '', 'Angola', 'Angola', '240.5');
INSERT INTO `yf_hf_area` VALUES ('4', '国家', '安圭拉', '', 'Anguilla', 'Anguilla', '240.5');
INSERT INTO `yf_hf_area` VALUES ('5', '国家', '阿尔巴尼亚', '', 'Albania', 'Albanie', '240.5');
INSERT INTO `yf_hf_area` VALUES ('6', '国家', '安道尔', '', 'Andorra', 'Andorre', '240.5');
INSERT INTO `yf_hf_area` VALUES ('7', '国家', '荷属安的列斯', '', 'Netherlands Antilles', 'Antilles néerlandaises', '240.5');
INSERT INTO `yf_hf_area` VALUES ('8', '国家', '阿联酋', '', 'United Arab Emirates', 'Émirats arabes unis', '169');
INSERT INTO `yf_hf_area` VALUES ('9', '国家', '阿根廷', '', 'Argentina', 'Argentine', '169');
INSERT INTO `yf_hf_area` VALUES ('10', '国家', '亚美尼亚', '', 'Armenia', 'Arménie', '240.5');
INSERT INTO `yf_hf_area` VALUES ('11', '国家', '美属萨摩亚', '', 'American Samoa', 'Samoa américaines', '240.5');
INSERT INTO `yf_hf_area` VALUES ('12', '国家', '南极洲', '', 'Antarctica', 'Antarctique', null);
INSERT INTO `yf_hf_area` VALUES ('13', '国家', '法属南部领地', '', 'French Southern Territories', 'Terres australes françaises', null);
INSERT INTO `yf_hf_area` VALUES ('14', '国家', '安提瓜和巴布达', '', 'Antigua and Barbuda', 'Antigua et Barbuda', '240.5');
INSERT INTO `yf_hf_area` VALUES ('15', '国家', '澳大利亚', '', 'Australia', 'Australie', '104');
INSERT INTO `yf_hf_area` VALUES ('16', '国家', '奥地利', '', 'Austria', 'Autriche', '143');
INSERT INTO `yf_hf_area` VALUES ('17', '国家', '阿塞拜疆', '', 'Azerbaijan', 'Azerbaïdjan', '240.5');
INSERT INTO `yf_hf_area` VALUES ('18', '国家', '布隆迪', '', 'Burundi', 'Burundi', '240.5');
INSERT INTO `yf_hf_area` VALUES ('19', '国家', '比利时', '', 'Belgium', 'Belgique', '143');
INSERT INTO `yf_hf_area` VALUES ('20', '国家', '贝宁', '', 'Benin', 'Bénin', '240.5');
INSERT INTO `yf_hf_area` VALUES ('21', '国家', '布基纳法索', '', 'Burkina Faso', 'Burkina-Faso', '240.5');
INSERT INTO `yf_hf_area` VALUES ('22', '国家', '孟加拉国', '', 'Bangladesh', 'Bangladesh', '156');
INSERT INTO `yf_hf_area` VALUES ('23', '国家', '保加利亚', '', 'Bulgaria', 'Bulgarie', '240.5');
INSERT INTO `yf_hf_area` VALUES ('24', '国家', '巴林', '', 'Bahrain', 'Bahreïn', '169');
INSERT INTO `yf_hf_area` VALUES ('25', '国家', '巴哈马', '', 'Bahamas', 'Bahamas', '169');
INSERT INTO `yf_hf_area` VALUES ('26', '国家', '波黑', '', 'Bosnia and Herzegovina', 'Bosnie-Herzégovine', '240.5');
INSERT INTO `yf_hf_area` VALUES ('27', '国家', '白俄罗斯', '', 'Belarus', 'Bélarus', '240.5');
INSERT INTO `yf_hf_area` VALUES ('28', '国家', '伯利兹', '', 'Belize', 'Belize', '240.5');
INSERT INTO `yf_hf_area` VALUES ('29', '国家', '百慕大', '', 'Bermuda', 'Bermudes', '240.5');
INSERT INTO `yf_hf_area` VALUES ('30', '国家', '玻利维亚', '', 'Bolivia', 'Bolivie', '169');
INSERT INTO `yf_hf_area` VALUES ('31', '国家', '巴西', '', 'Brazil', 'Brésil', '169');
INSERT INTO `yf_hf_area` VALUES ('32', '国家', '巴巴多斯', '', 'Barbados', 'Barbade', '169');
INSERT INTO `yf_hf_area` VALUES ('33', '国家', '文莱', '', 'Brunei', 'Brunei', '104');
INSERT INTO `yf_hf_area` VALUES ('34', '国家', '不丹', '', 'Bhutan', 'Bhoutan', '240.5');
INSERT INTO `yf_hf_area` VALUES ('35', '国家', '布维岛', '', 'Bouvet Island', 'Bouvet Island', null);
INSERT INTO `yf_hf_area` VALUES ('36', '国家', '博茨瓦纳', '', 'Botswana', 'Botswana', '240.5');
INSERT INTO `yf_hf_area` VALUES ('37', '国家', '中非', '', 'Central Africa', 'Centrafrique', '240.5');
INSERT INTO `yf_hf_area` VALUES ('38', '国家', '加拿大', '', 'Canada', 'Canada', '143');
INSERT INTO `yf_hf_area` VALUES ('39', '国家', '科科斯（基林）群岛', '', 'Cocos (Keeling) Islands', 'Cocos (Keeling)', '240.5');
INSERT INTO `yf_hf_area` VALUES ('40', '国家', '瑞士', '', 'Switzerland', 'Suisse', '143');
INSERT INTO `yf_hf_area` VALUES ('41', '国家', '智利', '', 'Chile', 'Chili', null);
INSERT INTO `yf_hf_area` VALUES ('42', '国家', '中国', '', 'China', 'Chine', null);
INSERT INTO `yf_hf_area` VALUES ('43', '国家', '科特迪瓦', '', 'C?te d\'Ivoire', 'Côte d\'Ivoire', '240.5');
INSERT INTO `yf_hf_area` VALUES ('44', '国家', '喀麦隆', '', 'Cameroon', 'Cameroun', '240.5');
INSERT INTO `yf_hf_area` VALUES ('45', '国家', '刚果（金）', '', 'Congo (Kinshasa)', 'Congo （République du)', '240.5');
INSERT INTO `yf_hf_area` VALUES ('46', '国家', '刚果（布）', '', 'Congo (Brazzaville)', 'Congo （République démocratique du)', '240.5');
INSERT INTO `yf_hf_area` VALUES ('47', '国家', '库克群岛', '', 'Cook Islands', 'Iles Cook', '240.5');
INSERT INTO `yf_hf_area` VALUES ('48', '国家', '哥伦比亚', '', 'Columbia', 'Colombie', '169');
INSERT INTO `yf_hf_area` VALUES ('49', '国家', '科摩罗', '', 'Comoros', 'Comores', '240.5');
INSERT INTO `yf_hf_area` VALUES ('50', '国家', '佛得角', '', 'Cape Verde', 'Cap Vert', '240.5');
INSERT INTO `yf_hf_area` VALUES ('51', '国家', '哥斯达黎加', '', 'Costa Rica', 'Costa Rica', '169');
INSERT INTO `yf_hf_area` VALUES ('52', '国家', '古巴', '', 'Cuba', 'Cuba', '169');
INSERT INTO `yf_hf_area` VALUES ('53', '国家', '圣诞岛', '', 'Christmas Island', 'Christmas Island', '240.5');
INSERT INTO `yf_hf_area` VALUES ('54', '国家', '开曼群岛', '', 'Cayman Islands', 'Iles Caïmans', '240.5');
INSERT INTO `yf_hf_area` VALUES ('55', '国家', '塞浦路斯', '', 'Cyprus', 'Chypre', '169');
INSERT INTO `yf_hf_area` VALUES ('56', '国家', '捷克', '', 'Czech', 'République tchèque', '240.5');
INSERT INTO `yf_hf_area` VALUES ('57', '国家', '德国', '', 'Germany', 'Allemagne', '143');
INSERT INTO `yf_hf_area` VALUES ('58', '国家', '吉布提', '', 'Djibouti', 'Djibouti', '240.5');
INSERT INTO `yf_hf_area` VALUES ('59', '国家', '多米尼克', '', 'Dominique', 'Dominique', '169');
INSERT INTO `yf_hf_area` VALUES ('60', '国家', '丹麦', '', 'Denmark', 'Danemark', '143');
INSERT INTO `yf_hf_area` VALUES ('61', '国家', '多米尼加', '', 'Dominica', 'Dominique', '169');
INSERT INTO `yf_hf_area` VALUES ('62', '国家', '阿尔及利亚', '', 'Algeria', 'Algérie', '240.5');
INSERT INTO `yf_hf_area` VALUES ('63', '国家', '厄瓜多尔', '', 'Ecuador', 'Equateur', '169');
INSERT INTO `yf_hf_area` VALUES ('64', '国家', '埃及', '', 'Egypt', 'Egypte', '169');
INSERT INTO `yf_hf_area` VALUES ('65', '国家', '厄立特里亚', '', 'Eritrea', 'Erythrée', null);
INSERT INTO `yf_hf_area` VALUES ('66', '国家', '西撒哈拉', '', 'Western Sahara', 'Sahara occidental', null);
INSERT INTO `yf_hf_area` VALUES ('67', '国家', '西班牙', '', 'Spain', 'Espagne', '143');
INSERT INTO `yf_hf_area` VALUES ('68', '国家', '爱沙尼亚', '', 'Estonia', 'Estonie', '240.5');
INSERT INTO `yf_hf_area` VALUES ('69', '国家', '埃塞俄比亚', '', 'Ethiopia', 'Ethiopie', '240.5');
INSERT INTO `yf_hf_area` VALUES ('70', '国家', '芬兰', '', 'Finland', 'Finlande', '143');
INSERT INTO `yf_hf_area` VALUES ('71', '国家', '斐济', '', 'Fiji', 'Fidji', '143');
INSERT INTO `yf_hf_area` VALUES ('72', '国家', '福克兰群岛（马尔维纳斯）', '', 'Falkland Islands (Malvinas)', 'Îles Falkland (Malvinas)', null);
INSERT INTO `yf_hf_area` VALUES ('73', '国家', '法国', '', 'France', 'France', '143');
INSERT INTO `yf_hf_area` VALUES ('74', '国家', '法罗群岛', '', 'Faroe Islands', 'Îles Féroé', '240.5');
INSERT INTO `yf_hf_area` VALUES ('75', '国家', '密克罗尼西亚联邦', '', 'Federated States of Micronesia', 'États fédérés de Micronésie', '240.5');
INSERT INTO `yf_hf_area` VALUES ('76', '国家', '加蓬', '', 'Gabon', 'Gabon', '240.5');
INSERT INTO `yf_hf_area` VALUES ('77', '国家', '英国', '', 'Britain', 'Angleterre', '143');
INSERT INTO `yf_hf_area` VALUES ('78', '国家', '格鲁吉亚', '', 'Georgia', 'Géorgie', '240.5');
INSERT INTO `yf_hf_area` VALUES ('79', '国家', '加纳', '', 'Ghana', 'Ghana', '240.5');
INSERT INTO `yf_hf_area` VALUES ('80', '国家', '哈萨克斯坦', '', 'Kazakhstan', 'Kazakhstan', '240.5');
INSERT INTO `yf_hf_area` VALUES ('81', '国家', '肯尼亚', '', 'Kenya', 'Kenya', '240.5');
INSERT INTO `yf_hf_area` VALUES ('82', '国家', '吉尔吉斯斯坦', '', 'Kirghizstan', 'Kirghizstan', '240.5');
INSERT INTO `yf_hf_area` VALUES ('83', '国家', '柬埔寨', '', 'Cambodia', 'Cambodge', '240.5');
INSERT INTO `yf_hf_area` VALUES ('84', '国家', '基里巴斯', '', 'Kiribati', 'Kiribati', '240.5');
INSERT INTO `yf_hf_area` VALUES ('85', '国家', '圣基茨和尼维斯', '', 'Saint Kitts and Nevis', 'Saint Christophe et Nevis', '240.5');
INSERT INTO `yf_hf_area` VALUES ('86', '国家', '韩国', '', 'Korea', 'République de Corée', '74.75');
INSERT INTO `yf_hf_area` VALUES ('87', '国家', '科威特', '', 'Kuwait', 'Koweit', '169');
INSERT INTO `yf_hf_area` VALUES ('88', '国家', '老挝', '', 'Laos', 'Laos', '240.5');
INSERT INTO `yf_hf_area` VALUES ('89', '国家', '黎巴嫩', '', 'Lebanon', 'Liban', '169');
INSERT INTO `yf_hf_area` VALUES ('90', '国家', '利比里亚', '', 'Liberia', 'Libéria', '240.5');
INSERT INTO `yf_hf_area` VALUES ('91', '国家', '利比亚', '', 'Libya', 'Libye', '240.5');
INSERT INTO `yf_hf_area` VALUES ('92', '国家', '圣卢西亚', '', 'Saint Lucia', 'Ste-Lucie', '240.5');
INSERT INTO `yf_hf_area` VALUES ('93', '国家', '列支敦士登', '', 'Liechtenstein', 'Liechtenstein', '240.5');
INSERT INTO `yf_hf_area` VALUES ('94', '国家', '斯里兰卡', '', 'Sri Lanka', 'Sri Lanka', '156');
INSERT INTO `yf_hf_area` VALUES ('95', '国家', '莱索托', '', 'Lesotho', 'Lesotho', '240.5');
INSERT INTO `yf_hf_area` VALUES ('96', '国家', '立陶宛', '', 'Lithuania', 'Lituanie', '240.5');
INSERT INTO `yf_hf_area` VALUES ('97', '国家', '卢森堡', '', 'Luxembourg', 'Luxembourg', '143');
INSERT INTO `yf_hf_area` VALUES ('98', '国家', '拉脱维亚', '', 'Latvia', 'Lettonie', '240.5');
INSERT INTO `yf_hf_area` VALUES ('99', '国家', '中国澳门', '', 'Macau, China', 'Macao', '58.5');

-- ----------------------------
-- Table structure for yf_hf_behavior
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_behavior`;
CREATE TABLE `yf_hf_behavior` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` varchar(100) NOT NULL COMMENT 'type : \r\n视频发布流程统计：\r\n1.点击发布按钮\r\n2.添加音乐\r\n3.添加封面\r\n4.房源信息\r\n5.成功发布\r\n视频详情页统计：\r\n6.开始观看\r\n7.完整观看\r\n8.点赞视频\r\n9.评论视频\r\n10.转发视频\r\n11.进入小区主页\r\n12.进入ta个人主页\r\n邀请好友统计:\r\n13.进入(打开)邀请页面\r\n视频转发效果统计\r\n13.视频转发\r\n14.进入被转视频转发页面\r\n15.转发视频点击播放\r\n16.转发视频完整观看\r\n26.点击相关视频\r\n邀请好友页面\r\n17.邀请好友\r\n18.进入被转页面\r\n19.登录\r\n30.点开红包进入邀请页面\r\n个人主页分享页面\r\n20.分享个人主页\r\n21.进入被转个人主页页面\r\n小区\r\n22.关注小区\r\n23.上传出租房源\r\n24.上传出售房源',
  `userid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id,有则传入用户id，无则传0',
  `video_id` int(11) DEFAULT '0' COMMENT '视频id',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(11) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21276 DEFAULT CHARSET=utf8 COMMENT='行为表';

-- ----------------------------
-- Records of yf_hf_behavior
-- ----------------------------
INSERT INTO `yf_hf_behavior` VALUES ('5940', '14', '0', '80', '1529638220', '1529638220');
INSERT INTO `yf_hf_behavior` VALUES ('5941', '6', '2184', '80', '1529638235', '1529638235');
INSERT INTO `yf_hf_behavior` VALUES ('5942', '6', '2184', '80', '1529638243', '1529638243');
INSERT INTO `yf_hf_behavior` VALUES ('5943', '14', '0', '80', '1529638259', '1529638259');
INSERT INTO `yf_hf_behavior` VALUES ('5944', '6', '598', '80', '1529638264', '1529638264');
INSERT INTO `yf_hf_behavior` VALUES ('5945', '6', '598', '80', '1529638268', '1529638268');
INSERT INTO `yf_hf_behavior` VALUES ('5946', '2', '575', '80', '1529638329', '1529638329');
INSERT INTO `yf_hf_behavior` VALUES ('5947', '18', '0', '80', '1529638334', '1529638334');
INSERT INTO `yf_hf_behavior` VALUES ('5948', '4', '575', '80', '1529638361', '1529638361');
INSERT INTO `yf_hf_behavior` VALUES ('5949', '6', '2226', '80', '1529638402', '1529638402');
INSERT INTO `yf_hf_behavior` VALUES ('5950', '6', '2226', '80', '1529638403', '1529638403');
INSERT INTO `yf_hf_behavior` VALUES ('5951', '11', '570', '80', '1529638460', '1529638460');
INSERT INTO `yf_hf_behavior` VALUES ('5952', '11', '570', '80', '1529638462', '1529638462');
INSERT INTO `yf_hf_behavior` VALUES ('5953', '18', '0', '80', '1529638539', '1529638539');
INSERT INTO `yf_hf_behavior` VALUES ('5954', '18', '0', '80', '1529638542', '1529638542');
INSERT INTO `yf_hf_behavior` VALUES ('5955', '6', '575', '80', '1529638609', '1529638609');
INSERT INTO `yf_hf_behavior` VALUES ('5956', '1', '575', '80', '1529638643', '1529638643');
INSERT INTO `yf_hf_behavior` VALUES ('5957', '2', '575', '80', '1529638661', '1529638661');
INSERT INTO `yf_hf_behavior` VALUES ('5958', '4', '575', '80', '1529638684', '1529638684');
INSERT INTO `yf_hf_behavior` VALUES ('5959', '14', '0', '80', '1529638685', '1529638685');
INSERT INTO `yf_hf_behavior` VALUES ('5960', '15', '0', '80', '1529638687', '1529638687');
INSERT INTO `yf_hf_behavior` VALUES ('5961', '14', '0', '80', '1529638697', '1529638697');
INSERT INTO `yf_hf_behavior` VALUES ('5962', '16', '0', '80', '1529638700', '1529638700');
INSERT INTO `yf_hf_behavior` VALUES ('5963', '16', '0', '80', '1529638702', '1529638702');
INSERT INTO `yf_hf_behavior` VALUES ('5964', '14', '0', '80', '1529638710', '1529638710');
INSERT INTO `yf_hf_behavior` VALUES ('5965', '15', '0', '80', '1529638712', '1529638712');
INSERT INTO `yf_hf_behavior` VALUES ('5966', '14', '0', '80', '1529638718', '1529638718');
INSERT INTO `yf_hf_behavior` VALUES ('5967', '15', '0', '80', '1529638719', '1529638719');
INSERT INTO `yf_hf_behavior` VALUES ('5968', '16', '0', '80', '1529638725', '1529638725');
INSERT INTO `yf_hf_behavior` VALUES ('5969', '16', '0', '80', '1529638732', '1529638732');
INSERT INTO `yf_hf_behavior` VALUES ('5970', '14', '0', '80', '1529638734', '1529638734');
INSERT INTO `yf_hf_behavior` VALUES ('5971', '16', '0', '80', '1529638735', '1529638735');
INSERT INTO `yf_hf_behavior` VALUES ('5972', '26', '0', '80', '1529638736', '1529638736');
INSERT INTO `yf_hf_behavior` VALUES ('5973', '14', '0', '80', '1529638738', '1529638738');
INSERT INTO `yf_hf_behavior` VALUES ('5974', '15', '0', '80', '1529638741', '1529638741');
INSERT INTO `yf_hf_behavior` VALUES ('5975', '16', '0', '80', '1529638753', '1529638753');
INSERT INTO `yf_hf_behavior` VALUES ('5976', '14', '0', '80', '1529638794', '1529638794');
INSERT INTO `yf_hf_behavior` VALUES ('5977', '15', '0', '80', '1529638795', '1529638795');
INSERT INTO `yf_hf_behavior` VALUES ('5978', '15', '0', '80', '1529638798', '1529638798');
INSERT INTO `yf_hf_behavior` VALUES ('5979', '15', '0', '80', '1529638805', '1529638805');
INSERT INTO `yf_hf_behavior` VALUES ('5980', '14', '0', '80', '1529638813', '1529638813');
INSERT INTO `yf_hf_behavior` VALUES ('5981', '15', '0', '80', '1529638817', '1529638817');
INSERT INTO `yf_hf_behavior` VALUES ('5982', '6', '575', '80', '1529638820', '1529638820');
INSERT INTO `yf_hf_behavior` VALUES ('5983', '1', '575', '80', '1529638823', '1529638823');
INSERT INTO `yf_hf_behavior` VALUES ('5984', '14', '0', '80', '1529638843', '1529638843');
INSERT INTO `yf_hf_behavior` VALUES ('5985', '15', '0', '80', '1529638849', '1529638849');
INSERT INTO `yf_hf_behavior` VALUES ('5986', '15', '0', '80', '1529638851', '1529638851');
INSERT INTO `yf_hf_behavior` VALUES ('5987', '2', '575', '80', '1529638851', '1529638851');
INSERT INTO `yf_hf_behavior` VALUES ('5988', '14', '0', '80', '1529638853', '1529638853');
INSERT INTO `yf_hf_behavior` VALUES ('5989', '15', '0', '80', '1529638865', '1529638865');
INSERT INTO `yf_hf_behavior` VALUES ('5990', '15', '0', '80', '1529638868', '1529638868');
INSERT INTO `yf_hf_behavior` VALUES ('5991', '16', '0', '80', '1529638870', '1529638870');
INSERT INTO `yf_hf_behavior` VALUES ('5992', '4', '575', '80', '1529638884', '1529638884');
INSERT INTO `yf_hf_behavior` VALUES ('5993', '14', '0', '80', '1529638922', '1529638922');
INSERT INTO `yf_hf_behavior` VALUES ('5994', '14', '0', '80', '1529638938', '1529638938');
INSERT INTO `yf_hf_behavior` VALUES ('5995', '26', '0', '80', '1529638942', '1529638942');
INSERT INTO `yf_hf_behavior` VALUES ('5996', '14', '0', '80', '1529638946', '1529638946');
INSERT INTO `yf_hf_behavior` VALUES ('5997', '14', '0', '80', '1529638947', '1529638947');
INSERT INTO `yf_hf_behavior` VALUES ('5998', '26', '0', '80', '1529638948', '1529638948');
INSERT INTO `yf_hf_behavior` VALUES ('5999', '14', '0', '80', '1529638951', '1529638951');
INSERT INTO `yf_hf_behavior` VALUES ('6000', '14', '0', '80', '1529638952', '1529638952');
INSERT INTO `yf_hf_behavior` VALUES ('6001', '6', '570', '80', '1529639015', '1529639015');
INSERT INTO `yf_hf_behavior` VALUES ('6002', '6', '570', '80', '1529639039', '1529639039');
INSERT INTO `yf_hf_behavior` VALUES ('6003', '6', '2184', '80', '1529639095', '1529639095');
INSERT INTO `yf_hf_behavior` VALUES ('6004', '6', '575', '80', '1529639171', '1529639171');
INSERT INTO `yf_hf_behavior` VALUES ('6005', '1', '575', '80', '1529639187', '1529639187');
INSERT INTO `yf_hf_behavior` VALUES ('6006', '2', '575', '80', '1529639208', '1529639208');
INSERT INTO `yf_hf_behavior` VALUES ('6007', '4', '575', '80', '1529639229', '1529639229');
INSERT INTO `yf_hf_behavior` VALUES ('6008', '4', '575', '80', '1529639252', '1529639252');
INSERT INTO `yf_hf_behavior` VALUES ('6009', '6', '2184', '80', '1529639652', '1529639652');
INSERT INTO `yf_hf_behavior` VALUES ('6010', '6', '2184', '80', '1529639655', '1529639655');
INSERT INTO `yf_hf_behavior` VALUES ('6011', '6', '2184', '80', '1529639656', '1529639656');
INSERT INTO `yf_hf_behavior` VALUES ('6012', '6', '2184', '80', '1529639657', '1529639657');
INSERT INTO `yf_hf_behavior` VALUES ('6013', '6', '2184', '80', '1529639658', '1529639658');
INSERT INTO `yf_hf_behavior` VALUES ('6014', '6', '2184', '80', '1529639658', '1529639658');
INSERT INTO `yf_hf_behavior` VALUES ('6015', '6', '2184', '80', '1529639660', '1529639660');
INSERT INTO `yf_hf_behavior` VALUES ('6016', '6', '2184', '80', '1529639661', '1529639661');
INSERT INTO `yf_hf_behavior` VALUES ('6017', '6', '2184', '80', '1529639662', '1529639662');
INSERT INTO `yf_hf_behavior` VALUES ('6018', '6', '2184', '80', '1529639663', '1529639663');
INSERT INTO `yf_hf_behavior` VALUES ('6019', '6', '2184', '80', '1529639666', '1529639666');
INSERT INTO `yf_hf_behavior` VALUES ('6020', '6', '2184', '80', '1529639667', '1529639667');
INSERT INTO `yf_hf_behavior` VALUES ('6021', '6', '2184', '80', '1529639674', '1529639674');
INSERT INTO `yf_hf_behavior` VALUES ('6022', '6', '2184', '80', '1529639675', '1529639675');
INSERT INTO `yf_hf_behavior` VALUES ('6023', '6', '2184', '80', '1529639713', '1529639713');
INSERT INTO `yf_hf_behavior` VALUES ('6024', '6', '2184', '80', '1529639714', '1529639714');
INSERT INTO `yf_hf_behavior` VALUES ('6025', '6', '2184', '80', '1529639715', '1529639715');
INSERT INTO `yf_hf_behavior` VALUES ('6026', '6', '2184', '80', '1529639716', '1529639716');
INSERT INTO `yf_hf_behavior` VALUES ('6027', '6', '2184', '80', '1529639716', '1529639716');
INSERT INTO `yf_hf_behavior` VALUES ('6028', '6', '2184', '80', '1529639717', '1529639717');
INSERT INTO `yf_hf_behavior` VALUES ('6029', '6', '2184', '80', '1529639717', '1529639717');
INSERT INTO `yf_hf_behavior` VALUES ('6030', '6', '2184', '80', '1529639718', '1529639718');
INSERT INTO `yf_hf_behavior` VALUES ('6031', '6', '2184', '80', '1529639719', '1529639719');
INSERT INTO `yf_hf_behavior` VALUES ('6032', '6', '2184', '80', '1529639723', '1529639723');
INSERT INTO `yf_hf_behavior` VALUES ('6033', '6', '2184', '80', '1529639767', '1529639767');
INSERT INTO `yf_hf_behavior` VALUES ('6034', '6', '2184', '80', '1529639770', '1529639770');
INSERT INTO `yf_hf_behavior` VALUES ('6035', '6', '2184', '80', '1529639773', '1529639773');
INSERT INTO `yf_hf_behavior` VALUES ('6036', '6', '2184', '80', '1529639774', '1529639774');
INSERT INTO `yf_hf_behavior` VALUES ('6037', '4', '575', '80', '1529640013', '1529640013');
INSERT INTO `yf_hf_behavior` VALUES ('6038', '6', '2184', '80', '1529640051', '1529640051');
INSERT INTO `yf_hf_behavior` VALUES ('6039', '6', '2184', '80', '1529640131', '1529640131');

-- ----------------------------
-- Table structure for yf_hf_buildings
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_buildings`;
CREATE TABLE `yf_hf_buildings` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) NOT NULL COMMENT '小区名称',
  `address` varchar(1000) NOT NULL COMMENT '小区地址',
  `area_id` int(11) DEFAULT '0' COMMENT '地区id',
  `average_price` int(30) DEFAULT NULL COMMENT '均价',
  `architectural_age` int(11) DEFAULT NULL COMMENT '建筑年代',
  `architectural_type` varchar(100) DEFAULT NULL COMMENT '建筑类型',
  `property_cost` varchar(100) DEFAULT NULL COMMENT '物业费用',
  `property_company` varchar(100) DEFAULT NULL COMMENT '物业公司',
  `longitude` double DEFAULT NULL COMMENT '小区经度',
  `latitude` double DEFAULT NULL COMMENT '小区纬度',
  `developers` varchar(100) DEFAULT NULL COMMENT '开发商',
  `num_building` int(11) DEFAULT NULL COMMENT '楼栋总数',
  `num_room` int(11) DEFAULT NULL COMMENT '房屋总数',
  `follow_count` int(10) DEFAULT '0' COMMENT '关注数量',
  `url` varchar(200) NOT NULL COMMENT '小区url',
  `is_user_add` int(11) DEFAULT '0' COMMENT '小区上报:1是0否',
  `user_type` int(11) DEFAULT '0' COMMENT '用户类型:1管理员2普通用户0机器',
  `user_id` int(11) DEFAULT '0' COMMENT '用户id:0机器，其它具体id',
  `is_confirm` int(11) DEFAULT '1' COMMENT '1审核通过0未审核',
  `remarks` varchar(500) DEFAULT '' COMMENT '用户备注',
  `create_time` int(10) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(10) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `longitude` (`longitude`),
  KEY `latitude` (`latitude`)
) ENGINE=InnoDB AUTO_INCREMENT=18785 DEFAULT CHARSET=utf8 COMMENT='小区表';

-- ----------------------------
-- Records of yf_hf_buildings
-- ----------------------------
INSERT INTO `yf_hf_buildings` VALUES ('1574', '海上国际花园(二期)', '(浦东北蔡)博华路380弄1-2号', '588', '51087', '2008', '塔楼/板楼', '1.88元/平米/月', '上海杨房物业管理有限公司', '121.554634', '31.187139', '上海香溢房地产有限公司', '3', '239', '1', 'https://sh.lianjia.com/xiaoqu/5011000015605/', '0', '1', '0', '1', '', null, '1528166635');
INSERT INTO `yf_hf_buildings` VALUES ('1575', '南新四村', '(浦东北蔡)下南路501弄,下南路551弄', '588', '52525', '1994', '板楼', '0.35元/平米/月', '上海同康物业管理公司', '121.548629', '31.180431', '上海建工集团', '107', '1788', '0', 'https://sh.lianjia.com/xiaoqu/5011000003831/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1576', '南新二村', '(浦东北蔡)下南路309弄23-70号', '588', '49018', '1993', '板楼', '0.8元/平米/月', '扬帆物业服务有限责任公司', '121.5485751', '31.17475354', '暂无信息', '47', '553', '0', 'https://sh.lianjia.com/xiaoqu/5011000003351/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1577', '绿川公寓', '(浦东北蔡)博华路980弄', '588', '56725', '1998', '板楼', '1.5元/平米/月', '上海绿地物业服务有限公司', '121.5573574', '31.17737539', '绿城集团', '27', '324', '0', 'https://sh.lianjia.com/xiaoqu/5011000003443/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1578', '芳草路253弄', '(浦东北蔡)芳草路253弄', '588', '61437', '2001', '板楼', '0.35元/平米/月', '上海源开房地产开发公司', '121.5623189', '31.19969846', '上海裕华', '9', '100', '0', 'https://sh.lianjia.com/xiaoqu/5011000005874/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1579', '杨莲路225、227号', '(浦东北蔡)杨莲路225、227号', '588', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.562656', '31.176652', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020022917262554/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1580', '龙阳路2000号', '(浦东北蔡)龙阳路2000号', '588', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.5644701832', '31.209643507858', '暂无信息', '1', '36', '0', 'https://sh.lianjia.com/xiaoqu/5012970721292451/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1581', '康琳大楼', '(浦东北蔡)杨高南路2875号', '588', '0', '2001', '板楼', '暂无信息', '上海杨高物业管理有限公司', '121.5264746', '31.18188011', '上海康琳房地产开发经营公司', '3', '74', '0', 'https://sh.lianjia.com/xiaoqu/5011000013920/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1582', '严镇路95号', '(浦东北蔡)严镇路95号', '588', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.535141', '31.197022', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020021025089980/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1583', '芳华路498号', '(浦东北蔡)芳华路498号', '588', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.56767500039', '31.202297862858', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5012970599658138/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1584', '芳华路494-498号', '(浦东北蔡)芳华路494-498号', '588', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.56755079798', '31.202295524047', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5012970599658137/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1585', '北艾路1254号', '(浦东北蔡)北艾路1254号', '588', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.53927092242', '31.188479168282', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5012970584453757/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1586', '北艾路227弄22号', '(浦东北蔡)北艾路227弄22号', '588', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.5498820269', '31.192539931369', '暂无信息', '1', '2', '0', 'https://sh.lianjia.com/xiaoqu/5012970584453784/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1587', '银东大厦', '(浦东碧云)新金桥路58号', '588', '0', '1998', '未知类型', '暂无信息', '暂无信息', '121.5998192', '31.25312938', '暂无信息', '1', '202', '0', 'https://sh.lianjia.com/xiaoqu/5011000016002/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1588', '龚华新村', '(浦东曹路)龚华路425弄', '588', '38792', '1994', '板楼', '0.55元/平米/月', '上海浦东物业管理公司', '121.6929692', '31.26780736', '上海龚华房地产咨询有限公司', '46', '738', '0', 'https://sh.lianjia.com/xiaoqu/5011000011252/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1589', '上川路1690号', '(浦东曹路)上川路1690号', '588', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.675612', '31.285225', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020021381714316/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1590', '佳洲欣苑', '(浦东川沙)新川路995弄', '588', '44879', '2004', '板楼', '0.35元/平米/月', '上海昌悦物业管理有限公司', '121.6934158', '31.19500894', '上海佳运置业有限公司', '46', '550', '0', 'https://sh.lianjia.com/xiaoqu/5011000014950/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1591', '鑫龙佳苑', '(浦东川沙)城丰路212弄', '588', '36245', '1994', '板楼', '0.8元/平米/月', '上海荣唐物业管理有限公司', '121.6931618', '31.19666303', '上海佳唐房地产开发有限公司', '42', '495', '0', 'https://sh.lianjia.com/xiaoqu/5011000009249/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1592', '新德四村', '(浦东川沙)华夏东路2026弄', '588', '37998', '1993', '板楼', '0.36元/平米/月', '沪萌物业', '121.6970692', '31.20495723', '暂无信息', '28', '420', '0', 'https://sh.lianjia.com/xiaoqu/5011000008785/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1593', '川北小区', '(浦东川沙)川沙路4586弄1-29号（川沙路640弄）', '588', '42112', '1984', '板楼', '0.3元/平米/月', '上海浦东新区新川物业公司', '121.699478', '31.20653', '杨行西城区建设开发有限公司', '27', '573', '0', 'https://sh.lianjia.com/xiaoqu/5011000013957/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1594', '曙光北苑', '(浦东川沙)南桥路86弄1-27号', '588', '41425', '2004', '板楼', '1.1元/平米/月', '暂无信息', '121.716617', '31.198682', '上海兴都房地产发展有限公司', '26', '320', '0', 'https://sh.lianjia.com/xiaoqu/5011000017693/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1595', '妙境三村', '(浦东川沙)南桥路1060弄', '588', '30961', '1996', '板楼', '0.36元/平米/月', '上海川北物业有限公司', '121.6974197', '31.19368289', '上川房产开发有限公司', '9', '84', '0', 'https://sh.lianjia.com/xiaoqu/5011000018654/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1596', '城南路小区', '(浦东川沙)城南路633号, 城南路639号, 城南路647号, 城南路653号, 城南路669号, 城南路685号, 城南路713号, 城南路719号, 城南路725号', '588', '42985', '1989', '板楼', '0.3元/平米/月', '上海浦东物业管理公司', '121.699169', '31.195371', '暂无信息', '9', '108', '0', 'https://sh.lianjia.com/xiaoqu/5016389506369957/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1597', '妙境路395弄', '(浦东川沙)妙境路395弄', '588', '38466', '1994', '板楼', '暂无信息', '暂无信息', '121.697169', '31.199176', '暂无信息', '9', '108', '0', 'https://sh.lianjia.com/xiaoqu/5011000011976/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1598', '象屿鼎城(别墅)', '(浦东川沙)华夏二路728弄', '588', '0', '2013', '板楼', '3.9元/平米/月', '同进物业', '121.691668', '31.193333', '杭州林庐房地产开发有限公司', '16', '16', '0', 'https://sh.lianjia.com/xiaoqu/5011000000307/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1599', '普庆路95,97号', '(浦东川沙)普庆路95, 97号', '588', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.725937', '31.160608', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020021887184995/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1600', '鹤兴苑', '(浦东川沙)乔家浜路81弄', '588', '43488', '2003', '板楼', '1.9元/平米/月', '暂无信息', '121.7088087', '31.201381', '暂无信息', '6', '72', '0', 'https://sh.lianjia.com/xiaoqu/5011102207636/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1601', '绿地东海岸', '(浦东川沙)绣川路581号,绣川路561号', '588', '0', '2009', '塔楼/板楼', '暂无信息', '暂无信息', '121.7059461', '31.1891666', '暂无信息', '2', '385', '0', 'https://sh.lianjia.com/xiaoqu/5011102207554/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1602', '进贤路188弄', '(浦东川沙)进贤路188弄', '588', '0', '2015', '未知类型', '暂无信息', '暂无信息', '121.699352', '31.199145', '暂无信息', '7', '9', '0', 'https://sh.lianjia.com/xiaoqu/5011000008920/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1603', '新德路365弄小区', '(浦东川沙)新德路365弄, 新德路361号, 新德路363号, 新德路367号, 西河浜路116弄, 西河浜路118弄', '588', '40422', '1982', '板楼', '0.3至0.6元/平米/月', '沪萌物业', '121.7040558', '31.20358863', '暂无信息', '23', '356', '0', 'https://sh.lianjia.com/xiaoqu/5011000008485/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1604', '新建路16弄', '(浦东川沙)新建路16弄', '588', '25776', '0', '未知类型', '暂无信息', '暂无信息', '121.752589', '31.179602', '暂无信息', '2', '3', '0', 'https://sh.lianjia.com/xiaoqu/5020029876515499/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1605', '施宏路448弄', '(浦东川沙)施宏路448弄', '588', '28676', '0', '未知类型', '暂无信息', '暂无信息', '121.76646572573', '31.157703168931', '暂无信息', '2', '15', '0', 'https://sh.lianjia.com/xiaoqu/509821540057993/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1606', '西市街101弄', '(浦东川沙)西市街101弄', '588', '42161', '1994', '板楼', '0.2元/平米/月', '上海浦东新区新川物业公司', '121.70706174085', '31.202121178289', '暂无信息', '2', '48', '0', 'https://sh.lianjia.com/xiaoqu/5011063203915/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1607', '新德路386弄', '(浦东川沙)新德路386弄', '588', '38000', '1995', '板楼', '0.3元/平米/月', '欣城物业', '121.7030368', '31.2034748', '暂无信息', '3', '29', '0', 'https://sh.lianjia.com/xiaoqu/5011000020128/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1608', '东塘花苑', '(浦东川沙)华夏东路2496弄', '588', '35702', '1998', '板楼', '0.4元/平米/月', '上海浦东新区新川物业公司', '121.70688', '31.20525104', '上海新唐房地产咨询有限公司', '8', '94', '0', 'https://sh.lianjia.com/xiaoqu/5011000010464/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1609', '石皮路小区', '(浦东川沙)石皮路54弄, 石皮路61弄, 石皮路75弄, 石皮路89弄', '588', '42705', '1993', '板楼', '0.2元/平米/月', '上海浦东物业管理公司', '121.70894', '31.20204888', '暂无信息', '25', '275', '0', 'https://sh.lianjia.com/xiaoqu/5011000019816/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1610', '新德路341弄', '(浦东川沙)新德路341弄', '588', '35580', '1992', '板楼', '0.8元/平米/月', '上海瑞创物业管理有限公司', '121.705045', '31.20385447', '上海中友房产开发有限公司', '9', '112', '0', 'https://sh.lianjia.com/xiaoqu/5011000006427/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1611', '川沙路5046弄', '(浦东川沙)川沙路5046弄', '588', '41919', '1982', '板楼', '0.8元/平米/月', '川顺物业', '121.7046687', '31.19789571', '暂无信息', '8', '160', '0', 'https://sh.lianjia.com/xiaoqu/5011000018652/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1612', '黄楼新邨', '(浦东川沙)栏学路366弄, 栏学路396弄, 栏学路402弄, 栏学路404弄, 栏学路408弄', '588', '32680', '1996', '板楼', '暂无信息', '暂无信息', '121.6756801', '31.17117611', '暂无信息', '12', '101', '0', 'https://sh.lianjia.com/xiaoqu/5011102207250/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1613', '王桥街41弄', '(浦东川沙)王桥街41弄', '588', '34106', '1998', '板楼', '0.1元/平米/月', '益华物业', '121.7067391', '31.20894339', '暂无信息', '6', '72', '0', 'https://sh.lianjia.com/xiaoqu/5011000019811/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1614', '新德路379弄-385号', '(浦东川沙)新德路379弄, 新德路381号, 新德路383号, 新德路385号', '588', '37778', '1987', '板楼', '0.3元/平米/月', '欣城物业', '121.70333796061', '31.20350039696', '暂无信息', '6', '110', '0', 'https://sh.lianjia.com/xiaoqu/5011063203409/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1615', '天竹新村', '(浦东川沙)天竹新村', '588', '29280', '1995', '板楼', '0.6元/平米/月', '暂无信息', '121.755119', '31.179228', '暂无信息', '10', '109', '0', 'https://sh.lianjia.com/xiaoqu/5011000019995/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1616', '绿地公寓(浦东)', '(浦东川沙)青夏路226弄', '588', '36189', '1998', '板楼', '0.8元/平米/月', '万晟物业', '121.6932733', '31.20337782', '绿城集团', '6', '62', '0', 'https://sh.lianjia.com/xiaoqu/5011000009429/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1617', '华夏花园', '(浦东川沙)华夏东路1298弄,华夏东路1348弄', '588', '58909', '1993', '板楼', '1.2元/平米/月', '上海伟发物业有限公司', '121.681774', '31.202383', '华夏集团', '42', '42', '0', 'https://sh.lianjia.com/xiaoqu/5011000002728/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1618', '新德路502弄', '(浦东川沙)新德路502弄', '588', '35427', '1995', '板楼', '0.3元/平米/月', '欣城物业', '121.698822', '31.20283977', '暂无信息', '4', '28', '0', 'https://sh.lianjia.com/xiaoqu/5011102207683/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1619', '万丰别墅', '(浦东川沙)青厦路150弄', '588', '71938', '2001', '板楼', '0.6元/平米/月', '上海联讯物业管理有限公司', '121.691703', '31.20346616', '远洋地产控股有限公司', '40', '40', '0', 'https://sh.lianjia.com/xiaoqu/5011000004018/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1620', '妙境路715弄', '(浦东川沙)妙境路715弄', '588', '31252', '1993', '板楼', '0.8元/平米/月', '上海裕华物业管理有限公司', '121.6984978', '31.1944246', '上海裕华', '5', '50', '0', 'https://sh.lianjia.com/xiaoqu/5011000019996/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1621', '南市街小区', '(浦东川沙)南市街16弄, 南市街30弄, 南市街42弄, 南市街45弄, 南市街49弄, 南市街58弄, 新川路209弄', '588', '39141', '1989', '板楼', '0.8至2元/平米/月', '上海浦东新区新川物业公司', '121.711754', '31.20024', '暂无信息', '31', '298', '0', 'https://sh.lianjia.com/xiaoqu/5011102207630/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1622', '西泥路小区', '(浦东川沙)西泥路79弄, 西泥路95弄, 西泥路107弄, 西泥路108弄, 西泥路113弄, 西泥路130弄, 西泥路139弄, 西泥路153弄, 西泥路87弄, 北城壕路57号, 北城壕路51号, 北城壕路63号', '588', '38102', '1974', '板楼', '0.2至1.2元/平米/月', '上海浦东新区新川物业公司', '121.710079', '31.201781', '暂无信息', '25', '339', '0', 'https://sh.lianjia.com/xiaoqu/509821540057761/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1623', '川沙路4650弄', '(浦东川沙)川沙路4650弄, （川环西路608弄）', '588', '40814', '1985', '板楼', '0.55元/平米/月', '上海浦东新区新川物业公司', '121.7030977', '31.20424112', '暂无信息', '10', '208', '0', 'https://sh.lianjia.com/xiaoqu/5011000020136/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1624', '川沙新川路190弄', '(浦东川沙)新川路190弄', '588', '40852', '1993', '板楼', '2元/平米/月', '上海浦东新区新川物业公司', '121.7120736', '31.20104194', '暂无信息', '15', '193', '0', 'https://sh.lianjia.com/xiaoqu/5011000007724/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1625', '华夏金桂苑(公寓)', '(浦东川沙)华夏东路1349弄', '588', '44997', '2000', '板楼', '0.8元/平米/月', '隆庆物业', '121.6831552', '31.2038219', '上海金桂房地产开发有限公司', '23', '146', '0', 'https://sh.lianjia.com/xiaoqu/5011000000863/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1626', '金钟苑', '(浦东川沙)妙境路55弄', '588', '38368', '2001', '板楼', '0.38元/平米/月', '暂无信息', '121.6958162', '31.20505127', '暂无信息', '9', '83', '0', 'https://sh.lianjia.com/xiaoqu/5011102207653/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1627', '云川公寓', '(浦东川沙)民贤路28弄', '588', '36842', '2000', '板楼', '1元/平米/月', '振群物业', '121.6989017', '31.20236872', '上海云川房地产开发有限公司', '18', '206', '0', 'https://sh.lianjia.com/xiaoqu/5011000019820/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1628', '西市街50号', '(浦东川沙)西市街50号', '588', '47892', '0', '未知类型', '暂无信息', '暂无信息', '121.708741', '31.202863', '暂无信息', '1', '2', '0', 'https://sh.lianjia.com/xiaoqu/5014963403164158/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1629', '施宏小区', '(浦东川沙)施宏路539弄, 施宏路501弄', '588', '29807', '1993', '板楼', '0.35元/平米/月', '施港物业', '121.7674788', '31.15830508', '暂无信息', '10', '120', '0', 'https://sh.lianjia.com/xiaoqu/5011102207361/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1630', '捷雄花园', '(浦东川沙)华夏东路1645弄', '588', '41885', '1999', '板楼', '0.63元/平米/月', '上海浦东物业管理公司', '121.687976', '31.206189', '捷雄房地产开发有限公司', '18', '19', '0', 'https://sh.lianjia.com/xiaoqu/5011102207665/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1631', '玉宇小区', '(浦东川沙)新川路856弄', '588', '35884', '1999', '板楼', '0.6元/平米/月', '正群物业', '121.6957683', '31.19691961', '上海玉宇房地产开发有限公司', '17', '194', '0', 'https://sh.lianjia.com/xiaoqu/5011000019736/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1632', '欧洲苑', '(浦东川沙)进贤路155弄', '588', '0', '2002', '板楼', '1.2元/平米/月', '大华物业', '121.698314', '31.198077', '上海通城房产经营开发有限公司', '7', '152', '0', 'https://sh.lianjia.com/xiaoqu/5011000005545/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1633', '施镇公寓', '(浦东川沙)航城四路616弄', '588', '33829', '0', '板楼', '暂无信息', '暂无信息', '121.762041', '31.1488', '暂无信息', '44', '528', '0', 'https://sh.lianjia.com/xiaoqu/5013146323431516/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1634', '佳腾花园', '(浦东川沙)华夏一路1782弄', '588', '36211', '1998', '板楼', '0.45元/平米/月', '上海联讯物业管理有限公司', '121.692346', '31.204574', '暂无信息', '14', '160', '0', 'https://sh.lianjia.com/xiaoqu/5011102207632/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1635', '汇领商墅', '(浦东川沙)鹿达路38号', '588', '13832', '1999', '板楼', '3元/平米/月', '无', '121.7027316', '31.11273547', '暂无信息', '15', '19', '0', 'https://sh.lianjia.com/xiaoqu/5011000011587/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1636', '曙光路25弄', '(浦东川沙)曙光路25弄', '588', '40269', '1991', '板楼', '0.5元/平米/月', '吉利物业', '121.7147856', '31.19888647', '暂无信息', '17', '182', '0', 'https://sh.lianjia.com/xiaoqu/5011000019547/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1637', '华茂苑', '(浦东川沙)川沙路4625弄', '588', '37645', '2002', '板楼', '0.45元/平米/月', '暂无信息', '121.7045847', '31.20539208', '暂无信息', '9', '75', '0', 'https://sh.lianjia.com/xiaoqu/5011102207671/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1638', '新建路40弄', '(浦东川沙)新建路40弄', '588', '30303', '0', '板楼', '0.35元/平米/月', '晨阳物业', '121.720768', '31.200481', '上海江镇房地产开发商', '2', '32', '0', 'https://sh.lianjia.com/xiaoqu/5011102205818/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1639', '城丰路15弄', '(浦东川沙)城丰路15弄', '588', '30293', '1996', '板楼', '1.6元/平米/月', '上海东郊皇庭物业管理有限公司', '121.69695', '31.197771', '上海裕华', '13', '104', '0', 'https://sh.lianjia.com/xiaoqu/5011000000528/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1640', '贤居苑', '(浦东川沙)进贤路168弄1-6号', '588', '37853', '2002', '板楼', '0.5元/平米/月', '天津市天乐物业管理有限公司', '121.698962', '31.19874', '上海云川房地产开发有限公司', '6', '64', '0', 'https://sh.lianjia.com/xiaoqu/5011000001741/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1641', '新川路300弄', '(浦东川沙)新川路300弄', '588', '34998', '0', '板楼', '0.8元/平米/月', '暂无信息', '121.708146', '31.200002', '暂无信息', '1', '29', '0', 'https://sh.lianjia.com/xiaoqu/5012719613291791/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1642', '华佳苑', '(浦东川沙)华夏东路1881弄', '588', '36911', '2002', '板楼', '1.2元/平米/月', '水景豪园物业', '121.6930818', '31.20609282', '上海国基房地产发展有限公司', '24', '105', '0', 'https://sh.lianjia.com/xiaoqu/5011102207696/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1643', '天和湖滨家园(别墅)', '(浦东川沙)晚霞路715弄', '588', '47872', '2010', '板楼', '2.2元/平米/月', '上海浦东东龙物业有限公司', '121.7584435', '31.18435157', '上海丞泰房地产开发有限公司', '65', '65', '0', 'https://sh.lianjia.com/xiaoqu/5011102207427/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1644', '情谊苑', '(浦东川沙)新德路602弄', '588', '47826', '2002', '板楼', '0.45元/平米/月', '上海倍至物业管理有限公司', '121.697748', '31.20391989', '暂无信息', '16', '186', '0', 'https://sh.lianjia.com/xiaoqu/5011000010586/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1645', '华夏银桂苑', '(浦东川沙)青厦路200弄', '588', '32287', '2005', '板楼', '1.1元/平米/月', '万晟物业', '121.6908564', '31.20380439', '暂无信息', '9', '132', '0', 'https://sh.lianjia.com/xiaoqu/5011000020131/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1646', '新川公寓', '(浦东川沙)新川路603弄', '588', '41213', '1997', '板楼', '4.5元/平米/月', '自主物业', '121.7008923', '31.19807873', '上海通城房产经营开发有限公司', '14', '125', '0', 'https://sh.lianjia.com/xiaoqu/5011000018455/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1647', '新德路558弄', '(浦东川沙)新德路558弄', '588', '38034', '1994', '板楼', '0.3元/平米/月', '万晟物业', '121.6989986', '31.2030037', '暂无信息', '9', '108', '0', 'https://sh.lianjia.com/xiaoqu/5011000004472/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1648', '妙境路338弄', '(浦东川沙)妙境路338弄', '588', '36257', '1997', '板楼', '0.3元/平米/月', '上海仙城物业', '121.6957087', '31.20081005', '上海海富置业有限公司', '7', '67', '0', 'https://sh.lianjia.com/xiaoqu/5011102207616/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1649', '新润花苑', '(浦东川沙)妙境路99弄', '588', '37913', '1999', '板楼', '0.6元/平米/月', '振群物业', '121.695658', '31.206059', '暂无信息', '7', '76', '0', 'https://sh.lianjia.com/xiaoqu/5011000011744/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1650', '川沙公寓', '(浦东川沙)新川路899弄', '588', '37407', '2004', '板楼', '0.83元/平米/月', '通城物业', '121.695375', '31.195895', '上海通城房地产经营开发有限公司', '14', '156', '0', 'https://sh.lianjia.com/xiaoqu/5011000011400/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1651', '兴东名苑', '(浦东川沙)华夏东路2139弄', '588', '42105', '2002', '板楼', '0.6元/平米/月', '上海兴东物业有限公司', '121.6986613', '31.20663761', '上海兴东房地产有限公司', '25', '272', '0', 'https://sh.lianjia.com/xiaoqu/5011000010597/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1652', '新川路742弄', '(浦东川沙)新川路742弄', '588', '39684', '1993', '板楼', '0.35元/平米/月', '吉利物业', '121.698299', '31.197262', '暂无信息', '12', '123', '0', 'https://sh.lianjia.com/xiaoqu/5011000019517/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1653', '黄楼新世纪花苑', '(浦东川沙)迎春街75弄', '588', '27737', '2005', '板楼', '0.5元/平米/月', '川迪物业', '121.6774876', '31.17214102', '上海辰辉房地产开发有限公司', '12', '140', '0', 'https://sh.lianjia.com/xiaoqu/5011102207286/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1654', '妙境路627弄', '(浦东川沙)妙境路627弄', '588', '32304', '1995', '板楼', '1.2元/平米/月', '无', '121.6981251', '31.19548772', '川沙房地产开发有限公司', '3', '24', '0', 'https://sh.lianjia.com/xiaoqu/5011102207566/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1655', '同济东时区', '(浦东川沙)航城四路318弄, 航城三路288弄', '588', '42203', '0', '板楼', '4.5元/平米/月', '上海同科物业管理有限公司', '121.756749', '31.151789', '上海同悦湾置业有限公司（同济房产）', '279', '909', '0', 'https://sh.lianjia.com/xiaoqu/5011063909411/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1656', '绿地云悦坊', '(浦东川沙)川沙路5600弄', '588', '40769', '0', '塔楼', '暂无信息', '上海欣周物业管理有限公司', '121.7069404', '31.18911903', '上海浦云房地产开发有限公司', '3', '822', '0', 'https://sh.lianjia.com/xiaoqu/5011000020066/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1657', '川南奉公路3424弄', '(浦东川沙)川南奉公路3424弄', '588', '28504', '1998', '板楼', '0.3至0.45元/平米/月', '晨阳物业', '121.7639374', '31.15492951', '暂无信息', '36', '359', '0', 'https://sh.lianjia.com/xiaoqu/5011000019541/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1658', '曙光苑', '(浦东川沙)学北路165弄', '588', '40735', '2001', '板楼', '0.7元/平米/月', '吉利物业', '121.71387', '31.196535', '上海兴都房地产发展有限公司', '21', '194', '0', 'https://sh.lianjia.com/xiaoqu/5011000014499/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1659', '爱家华城东区', '(浦东川沙)吉灿路18弄', '588', '26944', '2008', '板楼', '2.05元/平米/月', '迪亚物业', '121.7148602', '31.1170753', '上海利星房地产有限公司', '26', '498', '0', 'https://sh.lianjia.com/xiaoqu/5011000001948/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1660', '妙龙小区', '(浦东川沙)川环南路1223弄', '588', '42954', '1994', '板楼', '0.6元/平米/月', '上海佳龙物业公司', '121.6928783', '31.18931149', '上海王桥工业区联合投资开发公司', '8', '96', '0', 'https://sh.lianjia.com/xiaoqu/5011000019513/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1661', '妙栏路200弄', '(浦东川沙)妙栏路200弄', '588', '41791', '1997', '板楼', '0.45元/平米/月', '上海东川物业管理有限公司', '121.6956037', '31.19169995', '川沙房地产开发有限公司', '32', '378', '0', 'https://sh.lianjia.com/xiaoqu/5011000001489/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1662', '北城小区', '(浦东川沙)北城壕路111弄, 北城壕路153弄', '588', '37940', '1994', '板楼', '0.2元/平米/月', '上海浦东新区新川物业公司', '121.7076873', '31.20398807', '暂无信息', '14', '204', '0', 'https://sh.lianjia.com/xiaoqu/5011000019455/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1663', '思凡花苑三街坊', '(浦东川沙)航城五路151弄', '588', '30614', '1997', '板楼', '0.5元/平米/月', '上海浦东物业管理公司', '121.7542154', '31.14833166', '上海思凡房地产开发公司', '27', '320', '0', 'https://sh.lianjia.com/xiaoqu/5011102207317/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1664', '爱家华城', '(浦东川沙)吉灿路17弄', '588', '27399', '2008', '板楼', '2.05元/平米/月', '迪亚物业', '121.7148602', '31.1170753', '上海利星房地产有限公司', '29', '500', '0', 'https://sh.lianjia.com/xiaoqu/5011000001598/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1665', '普陀新村', '(浦东川沙)川六公路1937弄, 川六公路1903弄, 川六公路2001弄', '588', '26397', '1995', '板楼', '0.3元/平米/月', '周康物业管理有限公司', '121.7360785', '31.16136387', '上海周康房地产有限公司', '25', '248', '0', 'https://sh.lianjia.com/xiaoqu/5011000010234/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1666', '曙光东苑', '(浦东川沙)学北路337弄1-19号', '588', '40496', '2005', '板楼', '0.7元/平米/月', '上海金桥物业有限公司', '121.7139122', '31.19654454', '上海兴都房地产发展有限公司', '19', '183', '0', 'https://sh.lianjia.com/xiaoqu/5011000014349/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1667', '南桥小区', '(浦东川沙)南桥路297弄, 南桥路289号, 南桥路291号, 南桥路293号, 南桥路295号, 南桥路299号, 南桥路301号, 南桥路303号, 南桥路305号, 南桥路307号, 南桥路309号, 南桥路311号, 南桥路313号', '588', '40101', '1982', '板楼', '0.3至0.35元/平米/月', '暂无信息', '121.7136336', '31.19745284', '暂无信息', '31', '444', '0', 'https://sh.lianjia.com/xiaoqu/5011000019610/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1668', '曙航苑', '(浦东川沙)川环南路148弄', '588', '40397', '1993', '板楼', '0.8元/平米/月', '上海曙光物业管理有限公司', '121.7169744', '31.1957031', '上海方天建设有限公司', '18', '283', '0', 'https://sh.lianjia.com/xiaoqu/5011000003416/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1669', '东亚启航公馆', '(浦东川沙)航城三路518弄', '588', '35552', '0', '板楼', '2.8元/平米/月', '北京东亚时代物业管理有限公司', '121.75954581788', '31.152553012813', '上海硕日旷宇投资有限公司', '30', '686', '0', 'https://sh.lianjia.com/xiaoqu/509821540057106/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1670', '绿都绣云里', '(浦东川沙)崇溪路111弄', '588', '0', '0', '塔楼/板楼', '3.8元/平米/月', '南阳绿都物业', '121.712548', '31.114024', '上海迪南房地产开发有限公司', '34', '1574', '0', 'https://sh.lianjia.com/xiaoqu/5010477202844805/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1671', '江绣苑', '(浦东川沙)海霞路135弄', '588', '0', '0', '板楼', '0.55元/平米/月', '上海浦东物业管理公司', '121.7424422', '31.17283825', '上海玉宇房地产开发有限公司', '52', '658', '0', 'https://sh.lianjia.com/xiaoqu/5011102207299/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1672', '云川商汇苑', '(浦东川沙)学北路27弄', '588', '34666', '2002', '板楼', '0.4元/平米/月', '北华物业', '121.7114359', '31.19606243', '上海云川房地产开发有限公司', '5', '49', '0', 'https://sh.lianjia.com/xiaoqu/5011102207419/', '0', '1', '0', '1', '', null, null);
INSERT INTO `yf_hf_buildings` VALUES ('1673', '金宇别墅', '(浦东川沙)华夏三路201弄1-66号', '588', '58172', '2000', '板楼', '3元/平米/月', '天力物业', '121.684756', '31.200171', '上海天力房地产开发有限公司', '58', '58', '0', 'https://sh.lianjia.com/xiaoqu/5011000017561/', '0', '1', '0', '1', '', null, null);

-- ----------------------------
-- Table structure for yf_hf_buildings_lianjia
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_buildings_lianjia`;
CREATE TABLE `yf_hf_buildings_lianjia` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) NOT NULL COMMENT '小区名称',
  `address` varchar(1000) NOT NULL COMMENT '小区地址',
  `area_id` int(11) DEFAULT '0' COMMENT '地区id',
  `average_price` int(30) DEFAULT NULL COMMENT '均价',
  `architectural_age` int(11) DEFAULT NULL COMMENT '建筑年代',
  `architectural_type` varchar(100) DEFAULT NULL COMMENT '建筑类型',
  `property_cost` varchar(100) DEFAULT NULL COMMENT '物业费用',
  `property_company` varchar(100) DEFAULT NULL COMMENT '物业公司',
  `longitude` double DEFAULT NULL COMMENT '小区经度',
  `latitude` double DEFAULT NULL COMMENT '小区纬度',
  `developers` varchar(100) DEFAULT NULL COMMENT '开发商',
  `num_building` int(11) DEFAULT NULL COMMENT '楼栋总数',
  `num_room` int(11) DEFAULT NULL COMMENT '房屋总数',
  `follow_count` int(10) DEFAULT '0' COMMENT '关注数量',
  `url` varchar(200) NOT NULL COMMENT '小区url',
  `create_time` int(10) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(10) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `longitude` (`longitude`) USING BTREE,
  KEY `latitude` (`latitude`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36227 DEFAULT CHARSET=utf8 COMMENT='小区表';

-- ----------------------------
-- Records of yf_hf_buildings_lianjia
-- ----------------------------
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18778', '文汇小区(浦东)', '(浦东北蔡)下南路276弄,下南路370弄,下南路320弄', '0', '48467', '1994', '板楼', '0.8元/平米/月', '上海欣荣置业有限公司', '121.5479974', '31.17541349', '上海市绿地集团置业有限公司', '73', '1752', '0', 'https://sh.lianjia.com/xiaoqu/5011000014437/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18779', '南新四村', '(浦东北蔡)下南路501弄,下南路551弄', '0', '51680', '1994', '板楼', '0.35元/平米/月', '上海同康物业管理公司', '121.548629', '31.180431', '上海建工集团', '107', '1788', '0', 'https://sh.lianjia.com/xiaoqu/5011000003831/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18780', '芳华路253弄', '(浦东北蔡)芳华路253弄', '0', '57579', '1995', '板楼', '0.65元/平米/月', '上海花木物业', '121.5619343', '31.20179036', '上海花木开发有限公司', '24', '330', '0', 'https://sh.lianjia.com/xiaoqu/5011000006510/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18781', '高科西路2763弄', '(浦东北蔡)高科西路2763弄（川北公路63弄）', '0', '53796', '1994', '板楼', '0.6元/平米/月', '北蔡物业', '121.5611992', '31.19518835', '上海华佳实业有限公司', '16', '274', '0', 'https://sh.lianjia.com/xiaoqu/5011000001909/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18782', '芳草路253弄', '(浦东北蔡)芳草路253弄', '0', '61437', '2001', '板楼', '0.35元/平米/月', '上海源开房地产开发公司', '121.5623189', '31.19969846', '上海裕华', '9', '100', '0', 'https://sh.lianjia.com/xiaoqu/5011000005874/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18783', '杨莲路213号', '(浦东北蔡)杨莲路213号', '0', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.562283', '31.176536', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020022917261458/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18784', '严镇路93号', '(浦东北蔡)严镇路93号', '0', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.538307', '31.198116', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020026322538410/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18785', '北蔡休闲广场', '(浦东北蔡)北中路183号, 北中路187弄, 北中路191号', '0', '0', '2010', '未知类型', '暂无信息', '暂无信息', '121.561724', '31.18979056', '暂无信息', '34', '47', '0', 'https://sh.lianjia.com/xiaoqu/5011000008878/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18786', '龙阳路2000号', '(浦东北蔡)龙阳路2000号', '0', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.5644701832', '31.209643507858', '暂无信息', '1', '36', '0', 'https://sh.lianjia.com/xiaoqu/5012970721292451/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18787', '锦尊路229号', '(浦东北蔡)锦尊路229号', '0', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.537694', '31.190033', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020028473041205/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18788', '沪南路611-615号', '(浦东北蔡)沪南路611-615号', '0', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.55893928203', '31.195748431102', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5012970706350324/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18789', '严镇路95号', '(浦东北蔡)严镇路95号', '0', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.535141', '31.197022', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020021025089980/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18790', '芳华路498号', '(浦东北蔡)芳华路498号', '0', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.56767500039', '31.202297862858', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5012970599658138/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18791', '黄杨路6号', '(浦东碧云)黄杨路6号', '0', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.592295', '31.249449', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5017115729899700/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18792', '佳伟景苑', '(浦东曹路)金钻路669弄', '0', '45323', '2000', '板楼', '1.6元/平米/月', '上海昌悦物业管理有限公司', '121.681247', '31.289809', '暂无信息', '64', '2010', '0', 'https://sh.lianjia.com/xiaoqu/5011000010002/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18793', '川沙路520、530号', '(浦东曹路)川沙路520、530号', '0', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.675564', '31.281999', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020024424732169/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18794', '界龙花苑', '(浦东川沙)川环南路1049弄', '0', '39506', '1993', '板楼', '0.35元/平米/月', '上海佳龙物业公司', '121.6999222', '31.19136103', '上丰开发有限公司', '51', '684', '0', 'https://sh.lianjia.com/xiaoqu/5011000014881/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18795', '思凡馨苑', '(浦东川沙)施湾三路1055弄,施湾三路1056弄', '0', '28998', '2005', '板楼', '0.4元/平米/月', '东郊物业', '121.7582471', '31.14723428', '上海华飞置业有限公司', '88', '1140', '0', 'https://sh.lianjia.com/xiaoqu/5011000000764/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18796', '钻石苑', '(浦东川沙)城南路747弄', '0', '40878', '1999', '板楼', '0.6元/平米/月', '上海浦东物业管理公司', '121.698957', '31.194605', '上海浦东开发公司', '32', '239', '0', 'https://sh.lianjia.com/xiaoqu/5011000001869/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18797', '金象华庭', '(浦东川沙)华夏三路85弄', '0', '51239', '2004', '板楼', '3元/平米/月', '上海伟发物业有限公司', '121.6839093', '31.20243991', '海金象置业有限公司', '113', '134', '0', 'https://sh.lianjia.com/xiaoqu/5011000017829/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18798', '黄楼新世纪花苑', '(浦东川沙)迎春街75弄', '0', '27372', '2005', '板楼', '0.5元/平米/月', '川迪物业', '121.6774876', '31.17214102', '上海辰辉房地产开发有限公司', '12', '140', '0', 'https://sh.lianjia.com/xiaoqu/5011102207286/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18799', '金钟苑', '(浦东川沙)妙境路55弄', '0', '38368', '2001', '板楼', '0.38元/平米/月', '暂无信息', '121.6958162', '31.20505127', '暂无信息', '9', '83', '0', 'https://sh.lianjia.com/xiaoqu/5011102207653/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18800', '城南路小区', '(浦东川沙)城南路633号, 城南路639号, 城南路647号, 城南路653号, 城南路669号, 城南路685号, 城南路713号, 城南路719号, 城南路725号', '0', '42985', '1989', '板楼', '0.3元/平米/月', '上海浦东物业管理公司', '121.699169', '31.195371', '暂无信息', '9', '108', '0', 'https://sh.lianjia.com/xiaoqu/5016389506369957/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18801', '普庆路95,97号', '(浦东川沙)普庆路95, 97号', '0', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.725937', '31.160608', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020021887184995/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18802', '鹤兴苑', '(浦东川沙)乔家浜路81弄', '0', '43488', '2003', '板楼', '1.9元/平米/月', '暂无信息', '121.7088087', '31.201381', '暂无信息', '6', '72', '0', 'https://sh.lianjia.com/xiaoqu/5011102207636/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18803', '妙境路395弄', '(浦东川沙)妙境路395弄', '0', '37170', '1994', '板楼', '暂无信息', '暂无信息', '121.697169', '31.199176', '暂无信息', '9', '108', '0', 'https://sh.lianjia.com/xiaoqu/5011000011976/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18804', '进贤路188弄', '(浦东川沙)进贤路188弄', '0', '0', '2015', '未知类型', '暂无信息', '暂无信息', '121.699352', '31.199145', '暂无信息', '7', '9', '0', 'https://sh.lianjia.com/xiaoqu/5011000008920/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18805', '新建路16弄', '(浦东川沙)新建路16弄', '0', '25776', '0', '未知类型', '暂无信息', '暂无信息', '121.752589', '31.179602', '暂无信息', '2', '3', '0', 'https://sh.lianjia.com/xiaoqu/5020029876515499/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18806', '施宏路448弄', '(浦东川沙)施宏路448弄', '0', '28676', '0', '未知类型', '暂无信息', '暂无信息', '121.76646572573', '31.157703168931', '暂无信息', '2', '15', '0', 'https://sh.lianjia.com/xiaoqu/509821540057993/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18807', '新德路365弄小区', '(浦东川沙)新德路365弄, 新德路361号, 新德路363号, 新德路367号, 西河浜路116弄, 西河浜路118弄', '0', '41976', '1982', '板楼', '0.3至0.6元/平米/月', '沪萌物业', '121.7040558', '31.20358863', '暂无信息', '23', '356', '0', 'https://sh.lianjia.com/xiaoqu/5011000008485/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18808', '西市街101弄', '(浦东川沙)西市街101弄', '0', '42161', '1994', '板楼', '0.2元/平米/月', '上海浦东新区新川物业公司', '121.70706174085', '31.202121178289', '暂无信息', '2', '48', '0', 'https://sh.lianjia.com/xiaoqu/5011063203915/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18809', '龙馨茗园', '(浦东川沙)普庆路500弄', '0', '0', '0', '板楼', '0.8元/平米/月', '暂无信息', '121.736009', '31.162198', '暂无信息', '4', '39', '0', 'https://sh.lianjia.com/xiaoqu/5012512798715477/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18810', '川沙路5046弄', '(浦东川沙)川沙路5046弄', '0', '42100', '1982', '板楼', '0.8元/平米/月', '川顺物业', '121.7046687', '31.19789571', '暂无信息', '8', '160', '0', 'https://sh.lianjia.com/xiaoqu/5011000018652/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18811', '东塘花苑', '(浦东川沙)华夏东路2496弄', '0', '35217', '1998', '板楼', '0.4元/平米/月', '上海浦东新区新川物业公司', '121.70688', '31.20525104', '上海新唐房地产咨询有限公司', '8', '94', '0', 'https://sh.lianjia.com/xiaoqu/5011000010464/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18812', '新德路341弄', '(浦东川沙)新德路341弄', '0', '36237', '1992', '板楼', '0.8元/平米/月', '上海瑞创物业管理有限公司', '121.705045', '31.20385447', '上海中友房产开发有限公司', '9', '112', '0', 'https://sh.lianjia.com/xiaoqu/5011000006427/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18813', '新德路386弄', '(浦东川沙)新德路386弄', '0', '36934', '1995', '板楼', '0.3元/平米/月', '欣城物业', '121.7030368', '31.2034748', '暂无信息', '3', '29', '0', 'https://sh.lianjia.com/xiaoqu/5011000020128/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18814', '石皮路小区', '(浦东川沙)石皮路54弄, 石皮路61弄, 石皮路75弄, 石皮路89弄', '0', '42705', '1993', '板楼', '0.2元/平米/月', '上海浦东物业管理公司', '121.70894', '31.20204888', '暂无信息', '25', '275', '0', 'https://sh.lianjia.com/xiaoqu/5011000019816/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18815', '王桥街41弄', '(浦东川沙)王桥街41弄', '0', '34106', '1998', '板楼', '0.1元/平米/月', '益华物业', '121.7067391', '31.20894339', '暂无信息', '6', '72', '0', 'https://sh.lianjia.com/xiaoqu/5011000019811/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18816', '黄楼新邨', '(浦东川沙)栏学路366弄, 栏学路396弄, 栏学路402弄, 栏学路404弄, 栏学路408弄', '0', '32680', '1996', '板楼', '暂无信息', '暂无信息', '121.6756801', '31.17117611', '暂无信息', '12', '101', '0', 'https://sh.lianjia.com/xiaoqu/5011102207250/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18817', '天竹新村', '(浦东川沙)天竹新村', '0', '29280', '1995', '板楼', '0.6元/平米/月', '暂无信息', '121.755119', '31.179228', '暂无信息', '10', '109', '0', 'https://sh.lianjia.com/xiaoqu/5011000019995/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18818', '新德路379弄-385号', '(浦东川沙)新德路379弄, 新德路381号, 新德路383号, 新德路385号', '0', '36573', '1987', '板楼', '0.3元/平米/月', '欣城物业', '121.70333796061', '31.20350039696', '暂无信息', '6', '110', '0', 'https://sh.lianjia.com/xiaoqu/5011063203409/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18819', '华夏花园', '(浦东川沙)华夏东路1298弄,华夏东路1348弄', '0', '58909', '1993', '板楼', '1.2元/平米/月', '上海伟发物业有限公司', '121.681774', '31.202383', '华夏集团', '42', '42', '0', 'https://sh.lianjia.com/xiaoqu/5011000002728/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18820', '西泥路小区', '(浦东川沙)西泥路79弄, 西泥路95弄, 西泥路107弄, 西泥路108弄, 西泥路113弄, 西泥路130弄, 西泥路139弄, 西泥路153弄, 西泥路87弄, 北城壕路57号, 北城壕路51号, 北城壕路63号', '0', '38626', '1974', '板楼', '0.2至1.2元/平米/月', '上海浦东新区新川物业公司', '121.710079', '31.201781', '暂无信息', '25', '339', '0', 'https://sh.lianjia.com/xiaoqu/509821540057761/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18821', '新德路502弄', '(浦东川沙)新德路502弄', '0', '35427', '1995', '板楼', '0.3元/平米/月', '欣城物业', '121.698822', '31.20283977', '暂无信息', '4', '28', '0', 'https://sh.lianjia.com/xiaoqu/5011102207683/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18822', '妙境三村', '(浦东川沙)南桥路1060弄', '0', '30961', '1996', '板楼', '0.36元/平米/月', '上海川北物业有限公司', '121.6974197', '31.19368289', '上川房产开发有限公司', '9', '84', '0', 'https://sh.lianjia.com/xiaoqu/5011000018654/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18823', '捷雄花园', '(浦东川沙)华夏东路1645弄', '0', '41885', '1999', '板楼', '0.63元/平米/月', '上海浦东物业管理公司', '121.687976', '31.206189', '捷雄房地产开发有限公司', '18', '19', '0', 'https://sh.lianjia.com/xiaoqu/5011102207665/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18824', '绿地公寓(浦东)', '(浦东川沙)青夏路226弄', '0', '34396', '1998', '板楼', '0.8元/平米/月', '万晟物业', '121.6932733', '31.20337782', '绿城集团', '6', '62', '0', 'https://sh.lianjia.com/xiaoqu/5011000009429/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18825', '华夏金桂苑(公寓)', '(浦东川沙)华夏东路1349弄', '0', '47063', '2000', '板楼', '0.8元/平米/月', '隆庆物业', '121.6831552', '31.2038219', '上海金桂房地产开发有限公司', '23', '146', '0', 'https://sh.lianjia.com/xiaoqu/5011000000863/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18826', '玉宇小区', '(浦东川沙)新川路856弄', '0', '34028', '1999', '板楼', '0.6元/平米/月', '正群物业', '121.6957683', '31.19691961', '上海玉宇房地产开发有限公司', '17', '194', '0', 'https://sh.lianjia.com/xiaoqu/5011000019736/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18827', '西市街50号', '(浦东川沙)西市街50号', '0', '47892', '0', '未知类型', '暂无信息', '暂无信息', '121.708741', '31.202863', '暂无信息', '1', '2', '0', 'https://sh.lianjia.com/xiaoqu/5014963403164158/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18828', '妙境路715弄', '(浦东川沙)妙境路715弄', '0', '32991', '1993', '板楼', '0.8元/平米/月', '上海裕华物业管理有限公司', '121.6984978', '31.1944246', '上海裕华', '5', '50', '0', 'https://sh.lianjia.com/xiaoqu/5011000019996/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18829', '云川公寓', '(浦东川沙)民贤路28弄', '0', '37143', '2000', '板楼', '1元/平米/月', '振群物业', '121.6989017', '31.20236872', '上海云川房地产开发有限公司', '18', '206', '0', 'https://sh.lianjia.com/xiaoqu/5011000019820/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18830', '万丰别墅', '(浦东川沙)青厦路150弄', '0', '71938', '2001', '板楼', '0.6元/平米/月', '上海联讯物业管理有限公司', '121.691703', '31.20346616', '远洋地产控股有限公司', '40', '40', '0', 'https://sh.lianjia.com/xiaoqu/5011000004018/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18831', '汇领商墅', '(浦东川沙)鹿达路38号', '0', '13832', '1999', '板楼', '3元/平米/月', '无', '121.7027316', '31.11273547', '暂无信息', '15', '19', '0', 'https://sh.lianjia.com/xiaoqu/5011000011587/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18832', '施宏小区', '(浦东川沙)施宏路539弄, 施宏路501弄', '0', '29807', '1993', '板楼', '0.35元/平米/月', '施港物业', '121.7674788', '31.15830508', '暂无信息', '10', '120', '0', 'https://sh.lianjia.com/xiaoqu/5011102207361/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18833', '南市街小区', '(浦东川沙)南市街16弄, 南市街30弄, 南市街42弄, 南市街45弄, 南市街49弄, 南市街58弄, 新川路209弄', '0', '39141', '1989', '板楼', '0.8至2元/平米/月', '上海浦东新区新川物业公司', '121.711754', '31.20024', '暂无信息', '31', '298', '0', 'https://sh.lianjia.com/xiaoqu/5011102207630/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18834', '川沙新川路190弄', '(浦东川沙)新川路190弄', '0', '40202', '1993', '板楼', '2元/平米/月', '上海浦东新区新川物业公司', '121.7120736', '31.20104194', '暂无信息', '15', '193', '0', 'https://sh.lianjia.com/xiaoqu/5011000007724/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18835', '城丰路15弄', '(浦东川沙)城丰路15弄', '0', '30911', '1996', '板楼', '1.6元/平米/月', '上海东郊皇庭物业管理有限公司', '121.69695', '31.197771', '上海裕华', '13', '104', '0', 'https://sh.lianjia.com/xiaoqu/5011000000528/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18836', '欧洲苑', '(浦东川沙)进贤路155弄', '0', '0', '2002', '板楼', '1.2元/平米/月', '大华物业', '121.698314', '31.198077', '上海通城房产经营开发有限公司', '7', '152', '0', 'https://sh.lianjia.com/xiaoqu/5011000005545/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18837', '川沙路4650弄', '(浦东川沙)川沙路4650弄, （川环西路608弄）', '0', '38452', '1985', '板楼', '0.55元/平米/月', '上海浦东新区新川物业公司', '121.7030977', '31.20424112', '暂无信息', '10', '208', '0', 'https://sh.lianjia.com/xiaoqu/5011000020136/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18838', '佳腾花园', '(浦东川沙)华夏一路1782弄', '0', '36211', '1998', '板楼', '0.45元/平米/月', '上海联讯物业管理有限公司', '121.692346', '31.204574', '暂无信息', '14', '160', '0', 'https://sh.lianjia.com/xiaoqu/5011102207632/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18839', '施镇公寓', '(浦东川沙)航城四路616弄', '0', '33772', '0', '板楼', '暂无信息', '暂无信息', '121.762041', '31.1488', '暂无信息', '44', '528', '0', 'https://sh.lianjia.com/xiaoqu/5013146323431516/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18840', '贤居苑', '(浦东川沙)进贤路168弄1-6号', '0', '37338', '2002', '板楼', '0.5元/平米/月', '天津市天乐物业管理有限公司', '121.698962', '31.19874', '上海云川房地产开发有限公司', '6', '64', '0', 'https://sh.lianjia.com/xiaoqu/5011000001741/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18841', '华茂苑', '(浦东川沙)川沙路4625弄', '0', '34261', '2002', '板楼', '0.45元/平米/月', '暂无信息', '121.7045847', '31.20539208', '暂无信息', '9', '75', '0', 'https://sh.lianjia.com/xiaoqu/5011102207671/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18842', '鹿汇花园', '(浦东川沙)南六公路1628弄1-10号', '0', '21404', '1995', '板楼', '暂无信息', '暂无信息', '121.70652', '31.125548', '暂无信息', '6', '60', '0', 'https://sh.lianjia.com/xiaoqu/5013988706946608/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18843', '新建路40弄', '(浦东川沙)新建路40弄', '0', '32353', '0', '板楼', '0.35元/平米/月', '晨阳物业', '121.720768', '31.200481', '上海江镇房地产开发商', '2', '32', '0', 'https://sh.lianjia.com/xiaoqu/5011102205818/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18844', '新德路558弄', '(浦东川沙)新德路558弄', '0', '36331', '1994', '板楼', '0.3元/平米/月', '万晟物业', '121.6989986', '31.2030037', '暂无信息', '9', '108', '0', 'https://sh.lianjia.com/xiaoqu/5011000004472/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18845', '新川路300弄', '(浦东川沙)新川路300弄', '0', '34998', '0', '板楼', '0.8元/平米/月', '暂无信息', '121.708146', '31.200002', '暂无信息', '1', '29', '0', 'https://sh.lianjia.com/xiaoqu/5012719613291791/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18846', '华佳苑', '(浦东川沙)华夏东路1881弄', '0', '36911', '2002', '板楼', '1.2元/平米/月', '水景豪园物业', '121.6930818', '31.20609282', '上海国基房地产发展有限公司', '24', '105', '0', 'https://sh.lianjia.com/xiaoqu/5011102207696/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18847', '华夏银桂苑', '(浦东川沙)青厦路200弄', '0', '32287', '2005', '板楼', '1.1元/平米/月', '万晟物业', '121.6908564', '31.20380439', '暂无信息', '9', '132', '0', 'https://sh.lianjia.com/xiaoqu/5011000020131/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18848', '曙光路25弄', '(浦东川沙)曙光路25弄', '0', '39775', '1991', '板楼', '0.5元/平米/月', '吉利物业', '121.7147856', '31.19888647', '暂无信息', '17', '182', '0', 'https://sh.lianjia.com/xiaoqu/5011000019547/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18849', '天和湖滨家园(别墅)', '(浦东川沙)晚霞路715弄', '0', '47872', '2010', '板楼', '2.2元/平米/月', '上海浦东东龙物业有限公司', '121.7584435', '31.18435157', '上海丞泰房地产开发有限公司', '65', '65', '0', 'https://sh.lianjia.com/xiaoqu/5011102207427/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18850', '情谊苑', '(浦东川沙)新德路602弄', '0', '47826', '2002', '板楼', '0.45元/平米/月', '上海倍至物业管理有限公司', '121.697748', '31.20391989', '暂无信息', '16', '186', '0', 'https://sh.lianjia.com/xiaoqu/5011000010586/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18851', '新润花苑', '(浦东川沙)妙境路99弄', '0', '37097', '1999', '板楼', '0.6元/平米/月', '振群物业', '121.695658', '31.206059', '暂无信息', '7', '76', '0', 'https://sh.lianjia.com/xiaoqu/5011000011744/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18852', '新川公寓', '(浦东川沙)新川路603弄', '0', '40332', '1997', '板楼', '4.5元/平米/月', '自主物业', '121.7008923', '31.19807873', '上海通城房产经营开发有限公司', '14', '125', '0', 'https://sh.lianjia.com/xiaoqu/5011000018455/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18853', '妙境路338弄', '(浦东川沙)妙境路338弄', '0', '35823', '1997', '板楼', '0.3元/平米/月', '上海仙城物业', '121.6957087', '31.20081005', '上海海富置业有限公司', '7', '67', '0', 'https://sh.lianjia.com/xiaoqu/5011102207616/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18854', '兴东名苑', '(浦东川沙)华夏东路2139弄', '0', '42105', '2002', '板楼', '0.6元/平米/月', '上海兴东物业有限公司', '121.6986613', '31.20663761', '上海兴东房地产有限公司', '25', '272', '0', 'https://sh.lianjia.com/xiaoqu/5011000010597/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18855', '川沙公寓', '(浦东川沙)新川路899弄', '0', '37407', '2004', '板楼', '0.83元/平米/月', '通城物业', '121.695375', '31.195895', '上海通城房地产经营开发有限公司', '14', '156', '0', 'https://sh.lianjia.com/xiaoqu/5011000011400/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18856', '妙境路627弄', '(浦东川沙)妙境路627弄', '0', '32678', '1995', '板楼', '1.2元/平米/月', '无', '121.6981251', '31.19548772', '川沙房地产开发有限公司', '3', '24', '0', 'https://sh.lianjia.com/xiaoqu/5011102207566/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18857', '曙光苑', '(浦东川沙)学北路165弄', '0', '41430', '2001', '板楼', '0.7元/平米/月', '吉利物业', '121.71387', '31.196535', '上海兴都房地产发展有限公司', '21', '194', '0', 'https://sh.lianjia.com/xiaoqu/5011000014499/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18858', '曙光北苑', '(浦东川沙)南桥路86弄1-27号', '0', '41211', '2004', '板楼', '1.1元/平米/月', '暂无信息', '121.716617', '31.198682', '上海兴都房地产发展有限公司', '26', '320', '0', 'https://sh.lianjia.com/xiaoqu/5011000017693/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18859', '新川路742弄', '(浦东川沙)新川路742弄', '0', '38129', '1993', '板楼', '0.35元/平米/月', '吉利物业', '121.698299', '31.197262', '暂无信息', '12', '123', '0', 'https://sh.lianjia.com/xiaoqu/5011000019517/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18860', '同济东时区', '(浦东川沙)航城四路318弄, 航城三路288弄', '0', '42203', '0', '板楼', '4.5元/平米/月', '上海同科物业管理有限公司', '121.756749', '31.151789', '上海同悦湾置业有限公司（同济房产）', '279', '909', '0', 'https://sh.lianjia.com/xiaoqu/5011063909411/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18861', '北城小区', '(浦东川沙)北城壕路111弄, 北城壕路153弄', '0', '37131', '1994', '板楼', '0.2元/平米/月', '上海浦东新区新川物业公司', '121.7076873', '31.20398807', '暂无信息', '14', '204', '0', 'https://sh.lianjia.com/xiaoqu/5011000019455/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18862', '川南奉公路3424弄', '(浦东川沙)川南奉公路3424弄', '0', '27742', '1998', '板楼', '0.3至0.45元/平米/月', '晨阳物业', '121.7639374', '31.15492951', '暂无信息', '36', '359', '0', 'https://sh.lianjia.com/xiaoqu/5011000019541/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18863', '思凡花苑三街坊', '(浦东川沙)航城五路151弄', '0', '30279', '1997', '板楼', '0.5元/平米/月', '上海浦东物业管理公司', '121.7542154', '31.14833166', '上海思凡房地产开发公司', '27', '320', '0', 'https://sh.lianjia.com/xiaoqu/5011102207317/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18864', '爱家华城', '(浦东川沙)吉灿路17弄', '0', '27399', '2008', '板楼', '2.05元/平米/月', '迪亚物业', '121.7148602', '31.1170753', '上海利星房地产有限公司', '29', '500', '0', 'https://sh.lianjia.com/xiaoqu/5011000001598/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18865', '绿地云悦坊', '(浦东川沙)川沙路5600弄', '0', '40769', '0', '塔楼', '暂无信息', '上海欣周物业管理有限公司', '121.7069404', '31.18911903', '上海浦云房地产开发有限公司', '3', '822', '0', 'https://sh.lianjia.com/xiaoqu/5011000020066/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18866', '妙龙小区', '(浦东川沙)川环南路1223弄', '0', '42288', '1994', '板楼', '0.6元/平米/月', '上海佳龙物业公司', '121.6928783', '31.18931149', '上海王桥工业区联合投资开发公司', '8', '96', '0', 'https://sh.lianjia.com/xiaoqu/5011000019513/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18867', '爱家华城东区', '(浦东川沙)吉灿路18弄', '0', '28417', '2008', '板楼', '2.05元/平米/月', '迪亚物业', '121.7148602', '31.1170753', '上海利星房地产有限公司', '26', '498', '0', 'https://sh.lianjia.com/xiaoqu/5011000001948/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18868', '妙栏路200弄', '(浦东川沙)妙栏路200弄', '0', '41791', '1997', '板楼', '0.45元/平米/月', '上海东川物业管理有限公司', '121.6956037', '31.19169995', '川沙房地产开发有限公司', '32', '378', '0', 'https://sh.lianjia.com/xiaoqu/5011000001489/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18869', '曙光东苑', '(浦东川沙)学北路337弄1-19号', '0', '45027', '2005', '板楼', '0.7元/平米/月', '上海金桥物业有限公司', '121.7139122', '31.19654454', '上海兴都房地产发展有限公司', '19', '183', '0', 'https://sh.lianjia.com/xiaoqu/5011000014349/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18870', '曙航苑', '(浦东川沙)川环南路148弄', '0', '38732', '1993', '板楼', '0.8元/平米/月', '上海曙光物业管理有限公司', '121.7169744', '31.1957031', '上海方天建设有限公司', '18', '283', '0', 'https://sh.lianjia.com/xiaoqu/5011000003416/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18871', '江绣苑', '(浦东川沙)海霞路135弄', '0', '0', '0', '板楼', '0.55元/平米/月', '上海浦东物业管理公司', '121.7424422', '31.17283825', '上海玉宇房地产开发有限公司', '52', '658', '0', 'https://sh.lianjia.com/xiaoqu/5011102207299/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18872', '南桥小区', '(浦东川沙)南桥路297弄, 南桥路289号, 南桥路291号, 南桥路293号, 南桥路295号, 南桥路299号, 南桥路301号, 南桥路303号, 南桥路305号, 南桥路307号, 南桥路309号, 南桥路311号, 南桥路313号', '0', '39430', '1982', '板楼', '0.3至0.35元/平米/月', '暂无信息', '121.7136336', '31.19745284', '暂无信息', '31', '444', '0', 'https://sh.lianjia.com/xiaoqu/5011000019610/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18873', '绿都绣云里', '(浦东川沙)崇溪路111弄', '0', '0', '0', '塔楼/板楼', '3.8元/平米/月', '南阳绿都物业', '121.712548', '31.114024', '上海迪南房地产开发有限公司', '34', '1574', '0', 'https://sh.lianjia.com/xiaoqu/5010477202844805/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18874', '普陀新村', '(浦东川沙)川六公路1937弄, 川六公路1903弄, 川六公路2001弄', '0', '25902', '1995', '板楼', '0.3元/平米/月', '周康物业管理有限公司', '121.7360785', '31.16136387', '上海周康房地产有限公司', '25', '248', '0', 'https://sh.lianjia.com/xiaoqu/5011000010234/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18875', '东亚启航公馆', '(浦东川沙)航城三路518弄', '0', '35619', '0', '塔楼/板楼', '2.8元/平米/月', '北京东亚时代物业管理有限公司', '121.75954581788', '31.152553012813', '上海硕日旷宇投资有限公司', '30', '686', '0', 'https://sh.lianjia.com/xiaoqu/509821540057106/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18876', '贝越河滨雅筑', '(浦东川沙)北市街308弄', '0', '51765', '2010', '板楼', '3.5元/平米/月', '上海荣唐物业管理有限公司', '121.7090017', '31.2055457', '上海东士房地产经营有限责任公司', '13', '196', '0', 'https://sh.lianjia.com/xiaoqu/5011000004992/', null, null);
INSERT INTO `yf_hf_buildings_lianjia` VALUES ('18877', '金宇别墅', '(浦东川沙)华夏三路201弄1-66号', '0', '58172', '2000', '板楼', '3元/平米/月', '天力物业', '121.684756', '31.200171', '上海天力房地产开发有限公司', '58', '58', '0', 'https://sh.lianjia.com/xiaoqu/5011000017561/', null, null);

-- ----------------------------
-- Table structure for yf_hf_buildings_src
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_buildings_src`;
CREATE TABLE `yf_hf_buildings_src` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) NOT NULL COMMENT '小区名称',
  `address` varchar(1000) NOT NULL COMMENT '小区地址',
  `average_price` int(30) DEFAULT NULL COMMENT '均价',
  `architectural_age` int(11) DEFAULT NULL COMMENT '建筑年代',
  `architectural_type` varchar(100) DEFAULT NULL COMMENT '建筑类型',
  `property_cost` varchar(100) DEFAULT NULL COMMENT '物业费用',
  `property_company` varchar(100) DEFAULT NULL COMMENT '物业公司',
  `longitude` double DEFAULT NULL COMMENT '小区经度',
  `latitude` double DEFAULT NULL COMMENT '小区纬度',
  `developers` varchar(100) DEFAULT NULL COMMENT '开发商',
  `num_building` int(11) DEFAULT NULL COMMENT '楼栋总数',
  `num_room` int(11) DEFAULT NULL COMMENT '房屋总数',
  `follow_count` int(10) DEFAULT '0' COMMENT '关注数量',
  `url` varchar(200) NOT NULL COMMENT '小区url',
  `create_time` int(10) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(10) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `longitude` (`longitude`),
  KEY `latitude` (`latitude`)
) ENGINE=InnoDB AUTO_INCREMENT=18764 DEFAULT CHARSET=utf8 COMMENT='小区表';

-- ----------------------------
-- Records of yf_hf_buildings_src
-- ----------------------------
INSERT INTO `yf_hf_buildings_src` VALUES ('1574', '海上国际花园(二期)', '(浦东北蔡)博华路380弄1-2号', '51087', '2008', '塔楼/板楼', '1.88元/平米/月', '上海杨房物业管理有限公司', '121.554634', '31.187139', '上海香溢房地产有限公司', '239', '239', '0', 'https://sh.lianjia.com/xiaoqu/5011000015605/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1575', '南新四村', '(浦东北蔡)下南路501弄,下南路551弄', '52525', '1994', '板楼', '0.35元/平米/月', '上海同康物业管理公司', '121.548629', '31.180431', '上海建工集团', '1788', '1788', '0', 'https://sh.lianjia.com/xiaoqu/5011000003831/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1576', '南新二村', '(浦东北蔡)下南路309弄23-70号', '49018', '1993', '板楼', '0.8元/平米/月', '扬帆物业服务有限责任公司', '121.5485751', '31.17475354', '暂无信息', '553', '553', '0', 'https://sh.lianjia.com/xiaoqu/5011000003351/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1577', '绿川公寓', '(浦东北蔡)博华路980弄', '56725', '1998', '板楼', '1.5元/平米/月', '上海绿地物业服务有限公司', '121.5573574', '31.17737539', '绿城集团', '324', '324', '0', 'https://sh.lianjia.com/xiaoqu/5011000003443/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1578', '芳草路253弄', '(浦东北蔡)芳草路253弄', '61437', '2001', '板楼', '0.35元/平米/月', '上海源开房地产开发公司', '121.5623189', '31.19969846', '上海裕华', '100', '100', '0', 'https://sh.lianjia.com/xiaoqu/5011000005874/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1579', '杨莲路225、227号', '(浦东北蔡)杨莲路225、227号', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.562656', '31.176652', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020022917262554/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1580', '龙阳路2000号', '(浦东北蔡)龙阳路2000号', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.5644701832', '31.209643507858', '暂无信息', '36', '36', '0', 'https://sh.lianjia.com/xiaoqu/5012970721292451/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1581', '康琳大楼', '(浦东北蔡)杨高南路2875号', '0', '2001', '板楼', '暂无信息', '上海杨高物业管理有限公司', '121.5264746', '31.18188011', '上海康琳房地产开发经营公司', '74', '74', '0', 'https://sh.lianjia.com/xiaoqu/5011000013920/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1582', '严镇路95号', '(浦东北蔡)严镇路95号', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.535141', '31.197022', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020021025089980/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1583', '芳华路498号', '(浦东北蔡)芳华路498号', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.56767500039', '31.202297862858', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5012970599658138/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1584', '芳华路494-498号', '(浦东北蔡)芳华路494-498号', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.56755079798', '31.202295524047', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5012970599658137/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1585', '北艾路1254号', '(浦东北蔡)北艾路1254号', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.53927092242', '31.188479168282', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5012970584453757/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1586', '北艾路227弄22号', '(浦东北蔡)北艾路227弄22号', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.5498820269', '31.192539931369', '暂无信息', '2', '2', '0', 'https://sh.lianjia.com/xiaoqu/5012970584453784/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1587', '银东大厦', '(浦东碧云)新金桥路58号', '0', '1998', '未知类型', '暂无信息', '暂无信息', '121.5998192', '31.25312938', '暂无信息', '202', '202', '0', 'https://sh.lianjia.com/xiaoqu/5011000016002/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1588', '龚华新村', '(浦东曹路)龚华路425弄', '38792', '1994', '板楼', '0.55元/平米/月', '上海浦东物业管理公司', '121.6929692', '31.26780736', '上海龚华房地产咨询有限公司', '738', '738', '0', 'https://sh.lianjia.com/xiaoqu/5011000011252/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1589', '上川路1690号', '(浦东曹路)上川路1690号', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.675612', '31.285225', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020021381714316/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1590', '佳洲欣苑', '(浦东川沙)新川路995弄', '44879', '2004', '板楼', '0.35元/平米/月', '上海昌悦物业管理有限公司', '121.6934158', '31.19500894', '上海佳运置业有限公司', '550', '550', '0', 'https://sh.lianjia.com/xiaoqu/5011000014950/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1591', '鑫龙佳苑', '(浦东川沙)城丰路212弄', '36245', '1994', '板楼', '0.8元/平米/月', '上海荣唐物业管理有限公司', '121.6931618', '31.19666303', '上海佳唐房地产开发有限公司', '495', '495', '0', 'https://sh.lianjia.com/xiaoqu/5011000009249/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1592', '新德四村', '(浦东川沙)华夏东路2026弄', '37998', '1993', '板楼', '0.36元/平米/月', '沪萌物业', '121.6970692', '31.20495723', '暂无信息', '420', '420', '0', 'https://sh.lianjia.com/xiaoqu/5011000008785/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1593', '川北小区', '(浦东川沙)川沙路4586弄1-29号（川沙路640弄）', '42112', '1984', '板楼', '0.3元/平米/月', '上海浦东新区新川物业公司', '121.699478', '31.20653', '杨行西城区建设开发有限公司', '573', '573', '0', 'https://sh.lianjia.com/xiaoqu/5011000013957/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1594', '曙光北苑', '(浦东川沙)南桥路86弄1-27号', '41425', '2004', '板楼', '1.1元/平米/月', '暂无信息', '121.716617', '31.198682', '上海兴都房地产发展有限公司', '320', '320', '0', 'https://sh.lianjia.com/xiaoqu/5011000017693/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1595', '妙境三村', '(浦东川沙)南桥路1060弄', '30961', '1996', '板楼', '0.36元/平米/月', '上海川北物业有限公司', '121.6974197', '31.19368289', '上川房产开发有限公司', '84', '84', '0', 'https://sh.lianjia.com/xiaoqu/5011000018654/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1596', '城南路小区', '(浦东川沙)城南路633号, 城南路639号, 城南路647号, 城南路653号, 城南路669号, 城南路685号, 城南路713号, 城南路719号, 城南路725号', '42985', '1989', '板楼', '0.3元/平米/月', '上海浦东物业管理公司', '121.699169', '31.195371', '暂无信息', '108', '108', '0', 'https://sh.lianjia.com/xiaoqu/5016389506369957/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1597', '妙境路395弄', '(浦东川沙)妙境路395弄', '38466', '1994', '板楼', '暂无信息', '暂无信息', '121.697169', '31.199176', '暂无信息', '108', '108', '0', 'https://sh.lianjia.com/xiaoqu/5011000011976/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1598', '象屿鼎城(别墅)', '(浦东川沙)华夏二路728弄', '0', '2013', '板楼', '3.9元/平米/月', '同进物业', '121.691668', '31.193333', '杭州林庐房地产开发有限公司', '16', '16', '0', 'https://sh.lianjia.com/xiaoqu/5011000000307/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1599', '普庆路95,97号', '(浦东川沙)普庆路95, 97号', '0', '0', '未知类型', '暂无信息', '暂无信息', '121.725937', '31.160608', '暂无信息', '1', '1', '0', 'https://sh.lianjia.com/xiaoqu/5020021887184995/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1600', '鹤兴苑', '(浦东川沙)乔家浜路81弄', '43488', '2003', '板楼', '1.9元/平米/月', '暂无信息', '121.7088087', '31.201381', '暂无信息', '72', '72', '0', 'https://sh.lianjia.com/xiaoqu/5011102207636/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1601', '绿地东海岸', '(浦东川沙)绣川路581号,绣川路561号', '0', '2009', '塔楼/板楼', '暂无信息', '暂无信息', '121.7059461', '31.1891666', '暂无信息', '385', '385', '0', 'https://sh.lianjia.com/xiaoqu/5011102207554/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1602', '进贤路188弄', '(浦东川沙)进贤路188弄', '0', '2015', '未知类型', '暂无信息', '暂无信息', '121.699352', '31.199145', '暂无信息', '9', '9', '0', 'https://sh.lianjia.com/xiaoqu/5011000008920/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1603', '新德路365弄小区', '(浦东川沙)新德路365弄, 新德路361号, 新德路363号, 新德路367号, 西河浜路116弄, 西河浜路118弄', '40422', '1982', '板楼', '0.3至0.6元/平米/月', '沪萌物业', '121.7040558', '31.20358863', '暂无信息', '356', '356', '0', 'https://sh.lianjia.com/xiaoqu/5011000008485/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1604', '新建路16弄', '(浦东川沙)新建路16弄', '25776', '0', '未知类型', '暂无信息', '暂无信息', '121.752589', '31.179602', '暂无信息', '3', '3', '0', 'https://sh.lianjia.com/xiaoqu/5020029876515499/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1605', '施宏路448弄', '(浦东川沙)施宏路448弄', '28676', '0', '未知类型', '暂无信息', '暂无信息', '121.76646572573', '31.157703168931', '暂无信息', '15', '15', '0', 'https://sh.lianjia.com/xiaoqu/509821540057993/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1606', '西市街101弄', '(浦东川沙)西市街101弄', '42161', '1994', '板楼', '0.2元/平米/月', '上海浦东新区新川物业公司', '121.70706174085', '31.202121178289', '暂无信息', '48', '48', '0', 'https://sh.lianjia.com/xiaoqu/5011063203915/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1607', '新德路386弄', '(浦东川沙)新德路386弄', '38000', '1995', '板楼', '0.3元/平米/月', '欣城物业', '121.7030368', '31.2034748', '暂无信息', '29', '29', '0', 'https://sh.lianjia.com/xiaoqu/5011000020128/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1608', '东塘花苑', '(浦东川沙)华夏东路2496弄', '35702', '1998', '板楼', '0.4元/平米/月', '上海浦东新区新川物业公司', '121.70688', '31.20525104', '上海新唐房地产咨询有限公司', '94', '94', '0', 'https://sh.lianjia.com/xiaoqu/5011000010464/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1609', '石皮路小区', '(浦东川沙)石皮路54弄, 石皮路61弄, 石皮路75弄, 石皮路89弄', '42705', '1993', '板楼', '0.2元/平米/月', '上海浦东物业管理公司', '121.70894', '31.20204888', '暂无信息', '275', '275', '0', 'https://sh.lianjia.com/xiaoqu/5011000019816/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1610', '新德路341弄', '(浦东川沙)新德路341弄', '35580', '1992', '板楼', '0.8元/平米/月', '上海瑞创物业管理有限公司', '121.705045', '31.20385447', '上海中友房产开发有限公司', '112', '112', '0', 'https://sh.lianjia.com/xiaoqu/5011000006427/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1611', '川沙路5046弄', '(浦东川沙)川沙路5046弄', '41919', '1982', '板楼', '0.8元/平米/月', '川顺物业', '121.7046687', '31.19789571', '暂无信息', '160', '160', '0', 'https://sh.lianjia.com/xiaoqu/5011000018652/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1612', '黄楼新邨', '(浦东川沙)栏学路366弄, 栏学路396弄, 栏学路402弄, 栏学路404弄, 栏学路408弄', '32680', '1996', '板楼', '暂无信息', '暂无信息', '121.6756801', '31.17117611', '暂无信息', '101', '101', '0', 'https://sh.lianjia.com/xiaoqu/5011102207250/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1613', '王桥街41弄', '(浦东川沙)王桥街41弄', '34106', '1998', '板楼', '0.1元/平米/月', '益华物业', '121.7067391', '31.20894339', '暂无信息', '72', '72', '0', 'https://sh.lianjia.com/xiaoqu/5011000019811/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1614', '新德路379弄-385号', '(浦东川沙)新德路379弄, 新德路381号, 新德路383号, 新德路385号', '37778', '1987', '板楼', '0.3元/平米/月', '欣城物业', '121.70333796061', '31.20350039696', '暂无信息', '110', '110', '0', 'https://sh.lianjia.com/xiaoqu/5011063203409/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1615', '天竹新村', '(浦东川沙)天竹新村', '29280', '1995', '板楼', '0.6元/平米/月', '暂无信息', '121.755119', '31.179228', '暂无信息', '109', '109', '0', 'https://sh.lianjia.com/xiaoqu/5011000019995/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1616', '绿地公寓(浦东)', '(浦东川沙)青夏路226弄', '36189', '1998', '板楼', '0.8元/平米/月', '万晟物业', '121.6932733', '31.20337782', '绿城集团', '62', '62', '0', 'https://sh.lianjia.com/xiaoqu/5011000009429/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1617', '华夏花园', '(浦东川沙)华夏东路1298弄,华夏东路1348弄', '58909', '1993', '板楼', '1.2元/平米/月', '上海伟发物业有限公司', '121.681774', '31.202383', '华夏集团', '42', '42', '0', 'https://sh.lianjia.com/xiaoqu/5011000002728/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1618', '新德路502弄', '(浦东川沙)新德路502弄', '35427', '1995', '板楼', '0.3元/平米/月', '欣城物业', '121.698822', '31.20283977', '暂无信息', '28', '28', '0', 'https://sh.lianjia.com/xiaoqu/5011102207683/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1619', '万丰别墅', '(浦东川沙)青厦路150弄', '71938', '2001', '板楼', '0.6元/平米/月', '上海联讯物业管理有限公司', '121.691703', '31.20346616', '远洋地产控股有限公司', '40', '40', '0', 'https://sh.lianjia.com/xiaoqu/5011000004018/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1620', '妙境路715弄', '(浦东川沙)妙境路715弄', '31252', '1993', '板楼', '0.8元/平米/月', '上海裕华物业管理有限公司', '121.6984978', '31.1944246', '上海裕华', '50', '50', '0', 'https://sh.lianjia.com/xiaoqu/5011000019996/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1621', '南市街小区', '(浦东川沙)南市街16弄, 南市街30弄, 南市街42弄, 南市街45弄, 南市街49弄, 南市街58弄, 新川路209弄', '39141', '1989', '板楼', '0.8至2元/平米/月', '上海浦东新区新川物业公司', '121.711754', '31.20024', '暂无信息', '298', '298', '0', 'https://sh.lianjia.com/xiaoqu/5011102207630/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1622', '西泥路小区', '(浦东川沙)西泥路79弄, 西泥路95弄, 西泥路107弄, 西泥路108弄, 西泥路113弄, 西泥路130弄, 西泥路139弄, 西泥路153弄, 西泥路87弄, 北城壕路57号, 北城壕路51号, 北城壕路63号', '38102', '1974', '板楼', '0.2至1.2元/平米/月', '上海浦东新区新川物业公司', '121.710079', '31.201781', '暂无信息', '326', '326', '0', 'https://sh.lianjia.com/xiaoqu/509821540057761/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1623', '川沙路4650弄', '(浦东川沙)川沙路4650弄, （川环西路608弄）', '40814', '1985', '板楼', '0.55元/平米/月', '上海浦东新区新川物业公司', '121.7030977', '31.20424112', '暂无信息', '208', '208', '0', 'https://sh.lianjia.com/xiaoqu/5011000020136/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1624', '川沙新川路190弄', '(浦东川沙)新川路190弄', '40852', '1993', '板楼', '2元/平米/月', '上海浦东新区新川物业公司', '121.7120736', '31.20104194', '暂无信息', '193', '193', '0', 'https://sh.lianjia.com/xiaoqu/5011000007724/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1625', '华夏金桂苑(公寓)', '(浦东川沙)华夏东路1349弄', '44997', '2000', '板楼', '0.8元/平米/月', '隆庆物业', '121.6831552', '31.2038219', '上海金桂房地产开发有限公司', '146', '146', '0', 'https://sh.lianjia.com/xiaoqu/5011000000863/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1626', '金钟苑', '(浦东川沙)妙境路55弄', '38368', '2001', '板楼', '0.38元/平米/月', '暂无信息', '121.6958162', '31.20505127', '暂无信息', '83', '83', '0', 'https://sh.lianjia.com/xiaoqu/5011102207653/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1627', '云川公寓', '(浦东川沙)民贤路28弄', '36842', '2000', '板楼', '1元/平米/月', '振群物业', '121.6989017', '31.20236872', '上海云川房地产开发有限公司', '206', '206', '0', 'https://sh.lianjia.com/xiaoqu/5011000019820/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1628', '西市街50号', '(浦东川沙)西市街50号', '47892', '0', '未知类型', '暂无信息', '暂无信息', '121.708741', '31.202863', '暂无信息', '2', '2', '0', 'https://sh.lianjia.com/xiaoqu/5014963403164158/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1629', '施宏小区', '(浦东川沙)施宏路539弄, 施宏路501弄', '29807', '1993', '板楼', '0.35元/平米/月', '施港物业', '121.7674788', '31.15830508', '暂无信息', '120', '120', '0', 'https://sh.lianjia.com/xiaoqu/5011102207361/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1630', '捷雄花园', '(浦东川沙)华夏东路1645弄', '41885', '1999', '板楼', '0.63元/平米/月', '上海浦东物业管理公司', '121.687976', '31.206189', '捷雄房地产开发有限公司', '19', '19', '0', 'https://sh.lianjia.com/xiaoqu/5011102207665/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1631', '玉宇小区', '(浦东川沙)新川路856弄', '35884', '1999', '板楼', '0.6元/平米/月', '正群物业', '121.6957683', '31.19691961', '上海玉宇房地产开发有限公司', '194', '194', '0', 'https://sh.lianjia.com/xiaoqu/5011000019736/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1632', '欧洲苑', '(浦东川沙)进贤路155弄', '0', '2002', '板楼', '1.2元/平米/月', '大华物业', '121.698314', '31.198077', '上海通城房产经营开发有限公司', '152', '152', '0', 'https://sh.lianjia.com/xiaoqu/5011000005545/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1633', '施镇公寓', '(浦东川沙)航城四路616弄', '33829', '0', '板楼', '暂无信息', '暂无信息', '121.762041', '31.1488', '暂无信息', '528', '528', '0', 'https://sh.lianjia.com/xiaoqu/5013146323431516/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1634', '佳腾花园', '(浦东川沙)华夏一路1782弄', '36211', '1998', '板楼', '0.45元/平米/月', '上海联讯物业管理有限公司', '121.692346', '31.204574', '暂无信息', '160', '160', '0', 'https://sh.lianjia.com/xiaoqu/5011102207632/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1635', '汇领商墅', '(浦东川沙)鹿达路38号', '13832', '1999', '板楼', '3元/平米/月', '无', '121.7027316', '31.11273547', '暂无信息', '19', '19', '0', 'https://sh.lianjia.com/xiaoqu/5011000011587/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1636', '曙光路25弄', '(浦东川沙)曙光路25弄', '40269', '1991', '板楼', '0.5元/平米/月', '吉利物业', '121.7147856', '31.19888647', '暂无信息', '182', '182', '0', 'https://sh.lianjia.com/xiaoqu/5011000019547/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1637', '华茂苑', '(浦东川沙)川沙路4625弄', '37645', '2002', '板楼', '0.45元/平米/月', '暂无信息', '121.7045847', '31.20539208', '暂无信息', '75', '75', '0', 'https://sh.lianjia.com/xiaoqu/5011102207671/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1638', '新建路40弄', '(浦东川沙)新建路40弄', '30303', '0', '板楼', '0.35元/平米/月', '晨阳物业', '121.720768', '31.200481', '上海江镇房地产开发商', '32', '32', '0', 'https://sh.lianjia.com/xiaoqu/5011102205818/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1639', '城丰路15弄', '(浦东川沙)城丰路15弄', '30293', '1996', '板楼', '1.6元/平米/月', '上海东郊皇庭物业管理有限公司', '121.69695', '31.197771', '上海裕华', '104', '104', '0', 'https://sh.lianjia.com/xiaoqu/5011000000528/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1640', '贤居苑', '(浦东川沙)进贤路168弄1-6号', '37853', '2002', '板楼', '0.5元/平米/月', '天津市天乐物业管理有限公司', '121.698962', '31.19874', '上海云川房地产开发有限公司', '64', '64', '0', 'https://sh.lianjia.com/xiaoqu/5011000001741/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1641', '新川路300弄', '(浦东川沙)新川路300弄', '34998', '0', '板楼', '0.8元/平米/月', '暂无信息', '121.708146', '31.200002', '暂无信息', '29', '29', '0', 'https://sh.lianjia.com/xiaoqu/5012719613291791/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1642', '华佳苑', '(浦东川沙)华夏东路1881弄', '36911', '2002', '板楼', '1.2元/平米/月', '水景豪园物业', '121.6930818', '31.20609282', '上海国基房地产发展有限公司', '105', '105', '0', 'https://sh.lianjia.com/xiaoqu/5011102207696/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1643', '天和湖滨家园(别墅)', '(浦东川沙)晚霞路715弄', '47872', '2010', '板楼', '2.2元/平米/月', '上海浦东东龙物业有限公司', '121.7584435', '31.18435157', '上海丞泰房地产开发有限公司', '65', '65', '0', 'https://sh.lianjia.com/xiaoqu/5011102207427/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1644', '情谊苑', '(浦东川沙)新德路602弄', '47826', '2002', '板楼', '0.45元/平米/月', '上海倍至物业管理有限公司', '121.697748', '31.20391989', '暂无信息', '186', '186', '0', 'https://sh.lianjia.com/xiaoqu/5011000010586/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1645', '华夏银桂苑', '(浦东川沙)青厦路200弄', '32287', '2005', '板楼', '1.1元/平米/月', '万晟物业', '121.6908564', '31.20380439', '暂无信息', '132', '132', '0', 'https://sh.lianjia.com/xiaoqu/5011000020131/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1646', '新川公寓', '(浦东川沙)新川路603弄', '41213', '1997', '板楼', '4.5元/平米/月', '自主物业', '121.7008923', '31.19807873', '上海通城房产经营开发有限公司', '125', '125', '0', 'https://sh.lianjia.com/xiaoqu/5011000018455/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1647', '新德路558弄', '(浦东川沙)新德路558弄', '38034', '1994', '板楼', '0.3元/平米/月', '万晟物业', '121.6989986', '31.2030037', '暂无信息', '108', '108', '0', 'https://sh.lianjia.com/xiaoqu/5011000004472/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1648', '妙境路338弄', '(浦东川沙)妙境路338弄', '36257', '1997', '板楼', '0.3元/平米/月', '上海仙城物业', '121.6957087', '31.20081005', '上海海富置业有限公司', '67', '67', '0', 'https://sh.lianjia.com/xiaoqu/5011102207616/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1649', '新润花苑', '(浦东川沙)妙境路99弄', '37913', '1999', '板楼', '0.6元/平米/月', '振群物业', '121.695658', '31.206059', '暂无信息', '76', '76', '0', 'https://sh.lianjia.com/xiaoqu/5011000011744/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1650', '川沙公寓', '(浦东川沙)新川路899弄', '37407', '2004', '板楼', '0.83元/平米/月', '通城物业', '121.695375', '31.195895', '上海通城房地产经营开发有限公司', '156', '156', '0', 'https://sh.lianjia.com/xiaoqu/5011000011400/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1651', '兴东名苑', '(浦东川沙)华夏东路2139弄', '42105', '2002', '板楼', '0.6元/平米/月', '上海兴东物业有限公司', '121.6986613', '31.20663761', '上海兴东房地产有限公司', '272', '272', '0', 'https://sh.lianjia.com/xiaoqu/5011000010597/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1652', '新川路742弄', '(浦东川沙)新川路742弄', '39684', '1993', '板楼', '0.35元/平米/月', '吉利物业', '121.698299', '31.197262', '暂无信息', '123', '123', '0', 'https://sh.lianjia.com/xiaoqu/5011000019517/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1653', '黄楼新世纪花苑', '(浦东川沙)迎春街75弄', '27737', '2005', '板楼', '0.5元/平米/月', '川迪物业', '121.6774876', '31.17214102', '上海辰辉房地产开发有限公司', '140', '140', '0', 'https://sh.lianjia.com/xiaoqu/5011102207286/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1654', '妙境路627弄', '(浦东川沙)妙境路627弄', '32304', '1995', '板楼', '1.2元/平米/月', '无', '121.6981251', '31.19548772', '川沙房地产开发有限公司', '24', '24', '0', 'https://sh.lianjia.com/xiaoqu/5011102207566/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1655', '同济东时区', '(浦东川沙)航城四路318弄, 航城三路288弄', '42203', '0', '板楼', '4.5元/平米/月', '上海同科物业管理有限公司', '121.756749', '31.151789', '上海同悦湾置业有限公司（同济房产）', '909', '909', '0', 'https://sh.lianjia.com/xiaoqu/5011063909411/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1656', '绿地云悦坊', '(浦东川沙)川沙路5600弄', '40769', '0', '塔楼', '暂无信息', '上海欣周物业管理有限公司', '121.7069404', '31.18911903', '上海浦云房地产开发有限公司', '822', '822', '0', 'https://sh.lianjia.com/xiaoqu/5011000020066/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1657', '川南奉公路3424弄', '(浦东川沙)川南奉公路3424弄', '28504', '1998', '板楼', '0.3至0.45元/平米/月', '晨阳物业', '121.7639374', '31.15492951', '暂无信息', '359', '359', '0', 'https://sh.lianjia.com/xiaoqu/5011000019541/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1658', '曙光苑', '(浦东川沙)学北路165弄', '40735', '2001', '板楼', '0.7元/平米/月', '吉利物业', '121.71387', '31.196535', '上海兴都房地产发展有限公司', '194', '194', '0', 'https://sh.lianjia.com/xiaoqu/5011000014499/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1659', '爱家华城东区', '(浦东川沙)吉灿路18弄', '26944', '2008', '板楼', '2.05元/平米/月', '迪亚物业', '121.7148602', '31.1170753', '上海利星房地产有限公司', '498', '498', '0', 'https://sh.lianjia.com/xiaoqu/5011000001948/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1660', '妙龙小区', '(浦东川沙)川环南路1223弄', '42954', '1994', '板楼', '0.6元/平米/月', '上海佳龙物业公司', '121.6928783', '31.18931149', '上海王桥工业区联合投资开发公司', '96', '96', '0', 'https://sh.lianjia.com/xiaoqu/5011000019513/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1661', '妙栏路200弄', '(浦东川沙)妙栏路200弄', '41791', '1997', '板楼', '0.45元/平米/月', '上海东川物业管理有限公司', '121.6956037', '31.19169995', '川沙房地产开发有限公司', '378', '378', '0', 'https://sh.lianjia.com/xiaoqu/5011000001489/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1662', '北城小区', '(浦东川沙)北城壕路111弄, 北城壕路153弄', '37940', '1994', '板楼', '0.2元/平米/月', '上海浦东新区新川物业公司', '121.7076873', '31.20398807', '暂无信息', '204', '204', '0', 'https://sh.lianjia.com/xiaoqu/5011000019455/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1663', '思凡花苑三街坊', '(浦东川沙)航城五路151弄', '30614', '1997', '板楼', '0.5元/平米/月', '上海浦东物业管理公司', '121.7542154', '31.14833166', '上海思凡房地产开发公司', '320', '320', '0', 'https://sh.lianjia.com/xiaoqu/5011102207317/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1664', '爱家华城', '(浦东川沙)吉灿路17弄', '27399', '2008', '板楼', '2.05元/平米/月', '迪亚物业', '121.7148602', '31.1170753', '上海利星房地产有限公司', '500', '500', '0', 'https://sh.lianjia.com/xiaoqu/5011000001598/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1665', '普陀新村', '(浦东川沙)川六公路1937弄, 川六公路1903弄, 川六公路2001弄', '26397', '1995', '板楼', '0.3元/平米/月', '周康物业管理有限公司', '121.7360785', '31.16136387', '上海周康房地产有限公司', '248', '248', '0', 'https://sh.lianjia.com/xiaoqu/5011000010234/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1666', '曙光东苑', '(浦东川沙)学北路337弄1-19号', '40496', '2005', '板楼', '0.7元/平米/月', '上海金桥物业有限公司', '121.7139122', '31.19654454', '上海兴都房地产发展有限公司', '183', '183', '0', 'https://sh.lianjia.com/xiaoqu/5011000014349/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1667', '南桥小区', '(浦东川沙)南桥路297弄, 南桥路289号, 南桥路291号, 南桥路293号, 南桥路295号, 南桥路299号, 南桥路301号, 南桥路303号, 南桥路305号, 南桥路307号, 南桥路309号, 南桥路311号, 南桥路313号', '40101', '1982', '板楼', '0.3至0.35元/平米/月', '暂无信息', '121.7136336', '31.19745284', '暂无信息', '444', '444', '0', 'https://sh.lianjia.com/xiaoqu/5011000019610/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1668', '曙航苑', '(浦东川沙)川环南路148弄', '40397', '1993', '板楼', '0.8元/平米/月', '上海曙光物业管理有限公司', '121.7169744', '31.1957031', '上海方天建设有限公司', '283', '283', '0', 'https://sh.lianjia.com/xiaoqu/5011000003416/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1669', '东亚启航公馆', '(浦东川沙)航城三路518弄', '35552', '0', '板楼', '2.8元/平米/月', '北京东亚时代物业管理有限公司', '121.75954581788', '31.152553012813', '上海硕日旷宇投资有限公司', '686', '686', '0', 'https://sh.lianjia.com/xiaoqu/509821540057106/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1670', '绿都绣云里', '(浦东川沙)崇溪路111弄', '0', '0', '塔楼/板楼', '3.8元/平米/月', '南阳绿都物业', '121.712548', '31.114024', '上海迪南房地产开发有限公司', '1574', '1574', '0', 'https://sh.lianjia.com/xiaoqu/5010477202844805/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1671', '江绣苑', '(浦东川沙)海霞路135弄', '0', '0', '板楼', '0.55元/平米/月', '上海浦东物业管理公司', '121.7424422', '31.17283825', '上海玉宇房地产开发有限公司', '658', '658', '0', 'https://sh.lianjia.com/xiaoqu/5011102207299/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1672', '云川商汇苑', '(浦东川沙)学北路27弄', '34666', '2002', '板楼', '0.4元/平米/月', '北华物业', '121.7114359', '31.19606243', '上海云川房地产开发有限公司', '49', '49', '0', 'https://sh.lianjia.com/xiaoqu/5011102207419/', null, null);
INSERT INTO `yf_hf_buildings_src` VALUES ('1673', '金宇别墅', '(浦东川沙)华夏三路201弄1-66号', '58172', '2000', '板楼', '3元/平米/月', '天力物业', '121.684756', '31.200171', '上海天力房地产开发有限公司', '58', '58', '0', 'https://sh.lianjia.com/xiaoqu/5011000017561/', null, null);

-- ----------------------------
-- Table structure for yf_hf_chat_app
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_chat_app`;
CREATE TABLE `yf_hf_chat_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_key` varchar(60) NOT NULL,
  `app_secret` varchar(60) NOT NULL,
  `state` enum('forbidden_group_chat','forbidden_private_chat','using','forbidden_all_chat') NOT NULL DEFAULT 'using' COMMENT '状态：''禁止群聊'',''禁止私聊'',‘正常使用’，‘禁止私聊和群聊’',
  `mode` enum('private','public') NOT NULL DEFAULT 'public' COMMENT '模式：‘公用’，‘私有安全模式’',
  `links` int(10) NOT NULL DEFAULT '100' COMMENT '最大链接数',
  `orderid` int(10) NOT NULL COMMENT '拥有者id',
  `create_time` int(10) NOT NULL COMMENT '申请创建时间',
  `buy_time` int(10) NOT NULL COMMENT '购买时间',
  `end_time` int(10) DEFAULT NULL COMMENT '到期时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_chat_app
-- ----------------------------
INSERT INTO `yf_hf_chat_app` VALUES ('1', 'b054014693241bcd9c20', '44166c9e7acafe44a320', 'using', 'public', '100', '100', '1525227974', '1525227974', null);

-- ----------------------------
-- Table structure for yf_hf_chat_gaglist
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_chat_gaglist`;
CREATE TABLE `yf_hf_chat_gaglist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `gid` int(11) NOT NULL COMMENT '被禁的群id',
  `userid` varchar(255) NOT NULL COMMENT '被禁言人的id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `app_id` (`app_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_chat_gaglist
-- ----------------------------

-- ----------------------------
-- Table structure for yf_hf_chat_gagwords
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_chat_gagwords`;
CREATE TABLE `yf_hf_chat_gagwords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `data` varchar(30) NOT NULL COMMENT '敏感词',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `app_id` (`app_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_chat_gagwords
-- ----------------------------

-- ----------------------------
-- Table structure for yf_hf_chat_message
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_chat_message`;
CREATE TABLE `yf_hf_chat_message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '消息id',
  `app_key` varchar(32) NOT NULL DEFAULT '' COMMENT 'app_key',
  `from` varchar(255) NOT NULL DEFAULT '' COMMENT '发起者uid/group_id',
  `to` varchar(255) NOT NULL DEFAULT '' COMMENT '接收者id，根据type不同，可能是用户uid，可能是群组id',
  `data` text NOT NULL COMMENT '具体的消息数据',
  `isread` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否阅读过该条消息  0未读 1已读',
  `type` enum('friend','group') DEFAULT NULL,
  `timestamp` int(11) unsigned NOT NULL COMMENT '消息时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `app_key` (`app_key`) USING BTREE,
  KEY `timestamp` (`timestamp`) USING BTREE,
  KEY `from` (`from`(191)) USING BTREE,
  KEY `to` (`to`(191)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2247 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of yf_hf_chat_message
-- ----------------------------
INSERT INTO `yf_hf_chat_message` VALUES ('236', 'b054014693241bcd9c20', '445', '460', '{\"username\":\"\",\"avatar\":\"\",\"fromid\":\"\",\"type\":\"friend\",\"content\":\"1355\",\"toid\":\"219\",\"mine\":false,\"timestamp\":1525951101060.4,\"id\":\"\"}', '1', 'friend', '1525951101');
INSERT INTO `yf_hf_chat_message` VALUES ('244', 'b054014693241bcd9c20', '445', '460', '{\"username\":\"\\u5f7c\\u5cb8\\u6d6e\\u706f\",\"avatar\":\"http:\\/\\/thirdwx.qlogo.cn\\/mmopen\\/vi_32\\/Q0j4TwGTfTJF2YJjW11KZ4NtibGWKG8QElHRONZMQd0LzMMoZYJnY7tmnK6KWaBibIl1wvvgbliaAqAWyDSVxqNOA\\/132\",\"fromid\":\"445\",\"type\":\"friend\",\"content\":\"\\u4f60\\u597d\",\"toid\":\"460\",\"mine\":false,\"timestamp\":1525951618278,\"id\":\"445\"}', '1', 'friend', '1525951618');
INSERT INTO `yf_hf_chat_message` VALUES ('248', 'b054014693241bcd9c20', '445', '460', '{\"username\":\"\\u5f7c\\u5cb8\\u6d6e\\u706f\",\"avatar\":\"http:\\/\\/thirdwx.qlogo.cn\\/mmopen\\/vi_32\\/Q0j4TwGTfTJF2YJjW11KZ4NtibGWKG8QElHRONZMQd0LzMMoZYJnY7tmnK6KWaBibIl1wvvgbliaAqAWyDSVxqNOA\\/132\",\"fromid\":\"445\",\"type\":\"friend\",\"content\":\"img[https:\\/\\/yftest.fujuhaofang.com\\/assets\\/upload\\/images\\/5af42cb3e72c.jpeg]\",\"toid\":\"460\",\"mine\":false,\"timestamp\":1525951667402.2,\"id\":\"445\"}', '1', 'friend', '1525951667');
INSERT INTO `yf_hf_chat_message` VALUES ('250', 'b054014693241bcd9c20', '445', '460', '{\"username\":\"\\u5f7c\\u5cb8\\u6d6e\\u706f\",\"avatar\":\"http:\\/\\/thirdwx.qlogo.cn\\/mmopen\\/vi_32\\/Q0j4TwGTfTJF2YJjW11KZ4NtibGWKG8QElHRONZMQd0LzMMoZYJnY7tmnK6KWaBibIl1wvvgbliaAqAWyDSVxqNOA\\/132\",\"fromid\":\"445\",\"type\":\"friend\",\"content\":\"\\u808c\\u80a4\",\"toid\":\"460\",\"mine\":false,\"timestamp\":1525951757073.8,\"id\":\"445\"}', '1', 'friend', '1525951757');
INSERT INTO `yf_hf_chat_message` VALUES ('252', 'b054014693241bcd9c20', '445', '460', '{\"username\":\"\\u5f7c\\u5cb8\\u6d6e\\u706f\",\"avatar\":\"http:\\/\\/thirdwx.qlogo.cn\\/mmopen\\/vi_32\\/Q0j4TwGTfTJF2YJjW11KZ4NtibGWKG8QElHRONZMQd0LzMMoZYJnY7tmnK6KWaBibIl1wvvgbliaAqAWyDSVxqNOA\\/132\",\"fromid\":\"445\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\",\"toid\":\"460\",\"mine\":false,\"timestamp\":1525951965760.9,\"id\":\"445\"}', '1', 'friend', '1525951965');
INSERT INTO `yf_hf_chat_message` VALUES ('257', 'b054014693241bcd9c20', '445', '460', '{\"username\":\"\\u5f7c\\u5cb8\\u6d6e\\u706f\",\"avatar\":\"http:\\/\\/thirdwx.qlogo.cn\\/mmopen\\/vi_32\\/Q0j4TwGTfTJF2YJjW11KZ4NtibGWKG8QElHRONZMQd0LzMMoZYJnY7tmnK6KWaBibIl1wvvgbliaAqAWyDSVxqNOA\\/132\",\"fromid\":\"445\",\"type\":\"friend\",\"content\":\"\\u54c8\\u55bd\",\"toid\":\"460\",\"mine\":false,\"timestamp\":1525952064323.3,\"id\":\"445\"}', '1', 'friend', '1525952064');
INSERT INTO `yf_hf_chat_message` VALUES ('330', 'b054014693241bcd9c20', '513', '515', '{\"username\":\"\\u5c0f\\u738b\",\"avatar\":\"\",\"fromid\":\"232\",\"type\":\"friend\",\"content\":\"66\",\"toid\":\"477\",\"mine\":false,\"timestamp\":1526360917462.8,\"id\":\"232\"}', '1', 'friend', '1526360917');
INSERT INTO `yf_hf_chat_message` VALUES ('437', 'b054014693241bcd9c20', '447', '224', '{\"username\":\"\\u5f20\\u4e09\\u4e30\",\"avatar\":\"http:\\/\\/thirdwx.qlogo.cn\\/mmopen\\/vi_32\\/Q0j4TwGTfTJF2YJjW11KZ4NtibGWKG8QElHRONZMQd0LzMMoZYJnY7tmnK6KWaBibIl1wvvgbliaAqAWyDSVxqNOA\\/132\",\"fromid\":\"449\",\"type\":\"friend\",\"content\":\"img[https:\\/\\/yftest.fujuhaofang.com\\/assets\\/upload\\/images\\/5afd6d2bf19b.jpeg]\",\"toid\":\"514\",\"mine\":false,\"timestamp\":1526557996048.5,\"id\":\"449\"}', '1', 'friend', '1526557996');
INSERT INTO `yf_hf_chat_message` VALUES ('674', 'b054014693241bcd9c20', '516', '598', '{\"username\":\"u9ed8u9ed8\",\"avatar\":\"https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png\",\"fromid\":\"516\",\"type\":\"friend\",\"content\":\"u5475u5475\",\"toid\":\"598\",\"mine\":false,\"timestamp\":1527785358142.8,\"id\":\"516\"}', '1', 'friend', '1527785358');
INSERT INTO `yf_hf_chat_message` VALUES ('828', 'b054014693241bcd9c20', '2025', '2021', '{\"username\":\"u5b89u9759u7528u661fu6708\",\"avatar\":\"https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png\",\"fromid\":\"2025\",\"type\":\"friend\",\"content\":\"123\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528099642202.7,\"id\":\"2025\"}', '1', 'friend', '1528099642');
INSERT INTO `yf_hf_chat_message` VALUES ('829', 'b054014693241bcd9c20', '2025', '2021', '{\"username\":\"u5b89u9759u7528u661fu6708\",\"avatar\":\"https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png\",\"fromid\":\"2025\",\"type\":\"friend\",\"content\":\"456\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528099646394.2,\"id\":\"2025\"}', '1', 'friend', '1528099646');
INSERT INTO `yf_hf_chat_message` VALUES ('830', 'b054014693241bcd9c20', '2025', '2021', '{\"username\":\"u5b89u9759u7528u661fu6708\",\"avatar\":\"https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png\",\"fromid\":\"2025\",\"type\":\"friend\",\"content\":\"789\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528099652173.3,\"id\":\"2025\"}', '1', 'friend', '1528099652');
INSERT INTO `yf_hf_chat_message` VALUES ('831', 'b054014693241bcd9c20', '2025', '2021', '{\"username\":\"u5b89u9759u7528u661fu6708\",\"avatar\":\"https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png\",\"fromid\":\"2025\",\"type\":\"friend\",\"content\":\"987\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528099657803.6,\"id\":\"2025\"}', '1', 'friend', '1528099657');
INSERT INTO `yf_hf_chat_message` VALUES ('832', 'b054014693241bcd9c20', '2025', '2021', '{\"username\":\"u5b89u9759u7528u661fu6708\",\"avatar\":\"https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png\",\"fromid\":\"2025\",\"type\":\"friend\",\"content\":\"654\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528099661734.4,\"id\":\"2025\"}', '1', 'friend', '1528099661');
INSERT INTO `yf_hf_chat_message` VALUES ('833', 'b054014693241bcd9c20', '2025', '2021', '{\"username\":\"u5b89u9759u7528u661fu6708\",\"avatar\":\"https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png\",\"fromid\":\"2025\",\"type\":\"friend\",\"content\":\"321\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528099668726.4,\"id\":\"2025\"}', '1', 'friend', '1528099668');
INSERT INTO `yf_hf_chat_message` VALUES ('845', 'b054014693241bcd9c20', '2025', '2021', '{\"username\":\"u5b89u9759u7528u661fu6708\",\"avatar\":\"https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png\",\"fromid\":\"2025\",\"type\":\"friend\",\"content\":\"8766\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528104989609.2,\"id\":\"2025\"}', '1', 'friend', '1528104989');
INSERT INTO `yf_hf_chat_message` VALUES ('846', 'b054014693241bcd9c20', '2025', '2021', '{\"username\":\"u5b89u9759u7528u661fu6708\",\"avatar\":\"https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png\",\"fromid\":\"2025\",\"type\":\"friend\",\"content\":\"77777\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528104995639.7,\"id\":\"2025\"}', '1', 'friend', '1528104995');
INSERT INTO `yf_hf_chat_message` VALUES ('871', 'b054014693241bcd9c20', '2024', '515', '{\"username\":\"u542bu7ccau6253u767du732b\",\"avatar\":\"https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png\",\"fromid\":\"2024\",\"type\":\"friend\",\"content\":\"u4f60u597d\",\"toid\":\"515\",\"mine\":false,\"timestamp\":1528117553354.7,\"id\":\"2024\"}', '1', 'friend', '1528172613');
INSERT INTO `yf_hf_chat_message` VALUES ('872', 'b054014693241bcd9c20', '2024', '515', '{\"username\":\"u542bu7ccau6253u767du732b\",\"avatar\":\"https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png\",\"fromid\":\"2024\",\"type\":\"friend\",\"content\":\"face[u6316u9f3b] \",\"toid\":\"515\",\"mine\":false,\"timestamp\":1528117562716.4,\"id\":\"2024\"}', '1', 'friend', '1528172613');
INSERT INTO `yf_hf_chat_message` VALUES ('877', 'b054014693241bcd9c20', '2024', '568', '{\"username\":\"\\u542b\\u7cca\\u6253\\u767d\\u732b\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2024\",\"type\":\"friend\",\"content\":\"\\u66ff\\u60a8\\u540d\",\"toid\":\"568\",\"mine\":false,\"timestamp\":1528176327430.4,\"id\":\"2024\"}', '1', 'friend', '1528179007');
INSERT INTO `yf_hf_chat_message` VALUES ('878', 'b054014693241bcd9c20', '516', '598', '{\"username\":\"\\u9ed8\\u9ed8\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"516\",\"type\":\"friend\",\"content\":\"face[\\u998b\\u5634] \",\"toid\":\"598\",\"mine\":false,\"timestamp\":1528176357470.4,\"id\":\"516\"}', '1', 'friend', '1528176357');
INSERT INTO `yf_hf_chat_message` VALUES ('879', 'b054014693241bcd9c20', '516', '598', '{\"username\":\"\\u9ed8\\u9ed8\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"516\",\"type\":\"friend\",\"content\":\"face[\\u767d\\u773c] \",\"toid\":\"598\",\"mine\":false,\"timestamp\":1528176377680.8,\"id\":\"516\"}', '1', 'friend', '1528176377');
INSERT INTO `yf_hf_chat_message` VALUES ('880', 'b054014693241bcd9c20', '2024', '568', '{\"username\":\"\\u542b\\u7cca\\u6253\\u767d\\u732b\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2024\",\"type\":\"friend\",\"content\":\"face[\\u563b\\u563b] \",\"toid\":\"568\",\"mine\":false,\"timestamp\":1528176473198.7,\"id\":\"2024\"}', '1', 'friend', '1528179007');
INSERT INTO `yf_hf_chat_message` VALUES ('882', 'b054014693241bcd9c20', '516', '598', '{\"username\":\"\\u9ed8\\u9ed8\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"516\",\"type\":\"friend\",\"content\":\"\\u989d\\u7684\",\"toid\":\"598\",\"mine\":false,\"timestamp\":1528176596671,\"id\":\"516\"}', '1', 'friend', '1528176596');
INSERT INTO `yf_hf_chat_message` VALUES ('883', 'b054014693241bcd9c20', '2063', '2062', '{\"username\":\"\\u5520\\u53e8\\u65b9\\u9ed1\\u732b\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2063\",\"type\":\"friend\",\"content\":\"\\u4f60\\u597d\",\"toid\":\"2062\",\"mine\":false,\"timestamp\":1528176684937.5,\"id\":\"2063\"}', '1', 'friend', '1528182438');
INSERT INTO `yf_hf_chat_message` VALUES ('884', 'b054014693241bcd9c20', '2063', '2062', '{\"username\":\"\\u5520\\u53e8\\u65b9\\u9ed1\\u732b\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2063\",\"type\":\"friend\",\"content\":\"face[\\u563b\\u563b] \",\"toid\":\"2062\",\"mine\":false,\"timestamp\":1528176691877.6,\"id\":\"2063\"}', '1', 'friend', '1528182438');
INSERT INTO `yf_hf_chat_message` VALUES ('885', 'b054014693241bcd9c20', '2063', '2062', '{\"username\":\"\\u5520\\u53e8\\u65b9\\u9ed1\\u732b\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2063\",\"type\":\"friend\",\"content\":\"face[\\u5fae\\u7b11] \",\"toid\":\"2062\",\"mine\":false,\"timestamp\":1528176702736.1,\"id\":\"2063\"}', '1', 'friend', '1528182438');
INSERT INTO `yf_hf_chat_message` VALUES ('886', 'b054014693241bcd9c20', '516', '598', '{\"username\":\"\\u9ed8\\u9ed8\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"516\",\"type\":\"friend\",\"content\":\"\\u989d\\u7684\\u989d\",\"toid\":\"598\",\"mine\":false,\"timestamp\":1528176704636.4,\"id\":\"516\"}', '1', 'friend', '1528176704');
INSERT INTO `yf_hf_chat_message` VALUES ('887', 'b054014693241bcd9c20', '2063', '2062', '{\"username\":\"\\u5520\\u53e8\\u65b9\\u9ed1\\u732b\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2063\",\"type\":\"friend\",\"content\":\"img[https:\\/\\/yftest.fujuhaofang.com\\/assets\\/upload\\/images\\/5b1620521134.jpg]\",\"toid\":\"2062\",\"mine\":false,\"timestamp\":1528176722795.8,\"id\":\"2063\"}', '1', 'friend', '1528182438');
INSERT INTO `yf_hf_chat_message` VALUES ('889', 'b054014693241bcd9c20', '516', '598', '{\"username\":\"\\u9ed8\\u9ed8\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"516\",\"type\":\"friend\",\"content\":\"\\u56fe\\u56fe\",\"toid\":\"598\",\"mine\":false,\"timestamp\":1528176806189.7,\"id\":\"516\"}', '1', 'friend', '1528176806');
INSERT INTO `yf_hf_chat_message` VALUES ('890', 'b054014693241bcd9c20', '516', '598', '{\"username\":\"\\u9ed8\\u9ed8\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"516\",\"type\":\"friend\",\"content\":\"\\u8003\\u8651\\u8003\\u8651\\u56fe\",\"toid\":\"598\",\"mine\":false,\"timestamp\":1528176849195.6,\"id\":\"516\"}', '1', 'friend', '1528176849');
INSERT INTO `yf_hf_chat_message` VALUES ('893', 'b054014693241bcd9c20', '2063', '2062', '{\"username\":\"\\u5520\\u53e8\\u65b9\\u9ed1\\u732b\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2063\",\"type\":\"friend\",\"content\":\"\\u4f60\\u4eec\\u90fd\\u4f1a\\u597d\",\"toid\":\"2062\",\"mine\":false,\"timestamp\":1528177361269.4,\"id\":\"2063\"}', '1', 'friend', '1528182438');
INSERT INTO `yf_hf_chat_message` VALUES ('894', 'b054014693241bcd9c20', '516', '598', '{\"username\":\"\\u9ed8\\u9ed8\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"516\",\"type\":\"friend\",\"content\":\"\\u81ea\\u7531\\u804c\\u4e1a\",\"toid\":\"598\",\"mine\":false,\"timestamp\":1528177429277.4,\"id\":\"516\"}', '1', 'friend', '1528177429');
INSERT INTO `yf_hf_chat_message` VALUES ('946', 'b054014693241bcd9c20', '2062', '473', '{\"username\":\"\\u5149\\u4eae\\u7b11\\u5c0f\\u8682\\u8681\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2062\",\"type\":\"friend\",\"content\":\"26637\",\"toid\":\"473\",\"mine\":false,\"timestamp\":1528182573045.8,\"id\":\"2062\"}', '1', 'friend', '1528183169');
INSERT INTO `yf_hf_chat_message` VALUES ('947', 'b054014693241bcd9c20', '2062', '581', '{\"username\":\"\\u5149\\u4eae\\u7b11\\u5c0f\\u8682\\u8681\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2062\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\",\"toid\":\"581\",\"mine\":false,\"timestamp\":1528182779486.4,\"id\":\"2062\"}', '1', 'friend', '1528182779');
INSERT INTO `yf_hf_chat_message` VALUES ('948', 'b054014693241bcd9c20', '2062', '517', '{\"username\":\"\\u5149\\u4eae\\u7b11\\u5c0f\\u8682\\u8681\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2062\",\"type\":\"friend\",\"content\":\"\\u5475\\u5475\\u54c8\\u54c8\\u54c8\",\"toid\":\"517\",\"mine\":false,\"timestamp\":1528182832878.7,\"id\":\"2062\"}', '1', 'friend', '1528182832');
INSERT INTO `yf_hf_chat_message` VALUES ('992', 'b054014693241bcd9c20', '2108', '2113', '{\"username\":\"\\u542b\\u7f9e\\u8349\\u7075\\u5de7\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2108\",\"type\":\"friend\",\"content\":\"\\u60a8\\u597d\",\"toid\":\"2113\",\"mine\":false,\"timestamp\":1528204398100.5,\"id\":\"2108\"}', '1', 'friend', '1528204787');
INSERT INTO `yf_hf_chat_message` VALUES ('993', 'b054014693241bcd9c20', '2108', '2113', '{\"username\":\"\\u542b\\u7f9e\\u8349\\u7075\\u5de7\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2108\",\"type\":\"friend\",\"content\":\"\\u53e4\\u53e4\\u602a\\u602a\",\"toid\":\"2113\",\"mine\":false,\"timestamp\":1528204430467.1,\"id\":\"2108\"}', '1', 'friend', '1528204787');
INSERT INTO `yf_hf_chat_message` VALUES ('994', 'b054014693241bcd9c20', '2108', '2113', '{\"username\":\"\\u542b\\u7f9e\\u8349\\u7075\\u5de7\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2108\",\"type\":\"friend\",\"content\":\"\\u5730\\u65b9\\u65b9\\u6cd5\",\"toid\":\"2113\",\"mine\":false,\"timestamp\":1528204563078.2,\"id\":\"2108\"}', '1', 'friend', '1528204787');
INSERT INTO `yf_hf_chat_message` VALUES ('995', 'b054014693241bcd9c20', '2108', '2113', '{\"username\":\"\\u542b\\u7f9e\\u8349\\u7075\\u5de7\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2108\",\"type\":\"friend\",\"content\":\"\\u5475\\u5475vv\\u4e2a\",\"toid\":\"2113\",\"mine\":false,\"timestamp\":1528204675283.3,\"id\":\"2108\"}', '1', 'friend', '1528204787');
INSERT INTO `yf_hf_chat_message` VALUES ('996', 'b054014693241bcd9c20', '2108', '2113', '{\"username\":\"\\u542b\\u7f9e\\u8349\\u7075\\u5de7\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2108\",\"type\":\"friend\",\"content\":\"\\u4e92\\u76f8\\u5173\\u5fc3\\u597d\\u6210\\u7ee9\\u8fdb\\u8fdb\\u51fa\\u51fa\",\"toid\":\"2113\",\"mine\":false,\"timestamp\":1528204687823.4,\"id\":\"2108\"}', '1', 'friend', '1528204787');
INSERT INTO `yf_hf_chat_message` VALUES ('997', 'b054014693241bcd9c20', '2113', '2108', '{\"username\":\"\\u8d85\\u5e05\\u4e0e\\u98de\\u673a\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2113\",\"type\":\"friend\",\"content\":\"\\u53ef\\u53c2\\u8003\\u53c2\\u8003\\u53c2\\u8003\",\"toid\":\"2108\",\"mine\":false,\"timestamp\":1528204790096.8,\"id\":\"2113\"}', '1', 'friend', '1528204795');
INSERT INTO `yf_hf_chat_message` VALUES ('998', 'b054014693241bcd9c20', '2108', '2113', '{\"username\":\"\\u542b\\u7f9e\\u8349\\u7075\\u5de7\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2108\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\\u54c8\\u54c8\\u54c8\\u54c8\\u54c8\",\"toid\":\"2113\",\"mine\":false,\"timestamp\":1528204802960.5,\"id\":\"2108\"}', '1', 'friend', '1528204890');
INSERT INTO `yf_hf_chat_message` VALUES ('999', 'b054014693241bcd9c20', '2113', '2108', '{\"username\":\"\\u8d85\\u5e05\\u4e0e\\u98de\\u673a\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2113\",\"type\":\"friend\",\"content\":\"3636366\",\"toid\":\"2108\",\"mine\":false,\"timestamp\":1528204895972.9,\"id\":\"2113\"}', '1', 'friend', '1528255290');
INSERT INTO `yf_hf_chat_message` VALUES ('1000', 'b054014693241bcd9c20', '2113', '2108', '{\"username\":\"\\u8d85\\u5e05\\u4e0e\\u98de\\u673a\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2113\",\"type\":\"friend\",\"content\":\"\\u4e2a\\u54e5\\u54e5\\u54e5\\u54e5\",\"toid\":\"2108\",\"mine\":false,\"timestamp\":1528204905883.4,\"id\":\"2113\"}', '1', 'friend', '1528255290');
INSERT INTO `yf_hf_chat_message` VALUES ('1001', 'b054014693241bcd9c20', '2121', '473', '{\"username\":\"\\u4e49\\u6c14\\u7231\\u82b1\\u751f\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2121\",\"type\":\"friend\",\"content\":\"\\u9ed8\\u9ed8\",\"toid\":\"473\",\"mine\":false,\"timestamp\":1528247968383.6,\"id\":\"2121\"}', '1', 'friend', '1528247968');
INSERT INTO `yf_hf_chat_message` VALUES ('1003', 'b054014693241bcd9c20', '2113', '2087', '{\"username\":\"\\u8d85\\u5e05\\u4e0e\\u98de\\u673a\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2113\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\\u54c8\\u54c8\",\"toid\":\"2087\",\"mine\":false,\"timestamp\":1528250700001.2,\"id\":\"2113\"}', '1', 'friend', '1528250818');
INSERT INTO `yf_hf_chat_message` VALUES ('1004', 'b054014693241bcd9c20', '2087', '2121', '{\"username\":\"Fiona\",\"avatar\":\"https:\\/\\/thirdwx.qlogo.cn\\/mmopen\\/vi_32\\/Q0j4TwGTfTKFMHC57CAEBXuqG4JeQXtGXWFxg35CsbKnmxou9FuF0EkIN3Q0MQVZlptynyicQDkojYh9YwtguAA\\/132\",\"fromid\":\"2087\",\"type\":\"friend\",\"content\":\"Hhh\",\"toid\":\"2121\",\"mine\":false,\"timestamp\":1528250824205.3,\"id\":\"2087\"}', '1', 'friend', '1528250824');
INSERT INTO `yf_hf_chat_message` VALUES ('1005', 'b054014693241bcd9c20', '2087', '2121', '{\"username\":\"Fiona\",\"avatar\":\"https:\\/\\/thirdwx.qlogo.cn\\/mmopen\\/vi_32\\/Q0j4TwGTfTKFMHC57CAEBXuqG4JeQXtGXWFxg35CsbKnmxou9FuF0EkIN3Q0MQVZlptynyicQDkojYh9YwtguAA\\/132\",\"fromid\":\"2087\",\"type\":\"friend\",\"content\":\"Hhhhhhhhhjjj\",\"toid\":\"2121\",\"mine\":false,\"timestamp\":1528250829865.8,\"id\":\"2087\"}', '1', 'friend', '1528250829');
INSERT INTO `yf_hf_chat_message` VALUES ('1006', 'b054014693241bcd9c20', '2087', '2121', '{\"username\":\"Fiona\",\"avatar\":\"https:\\/\\/thirdwx.qlogo.cn\\/mmopen\\/vi_32\\/Q0j4TwGTfTKFMHC57CAEBXuqG4JeQXtGXWFxg35CsbKnmxou9FuF0EkIN3Q0MQVZlptynyicQDkojYh9YwtguAA\\/132\",\"fromid\":\"2087\",\"type\":\"friend\",\"content\":\" Hhhh\",\"toid\":\"2121\",\"mine\":false,\"timestamp\":1528250873280.1,\"id\":\"2087\"}', '1', 'friend', '1528250873');
INSERT INTO `yf_hf_chat_message` VALUES ('1007', 'b054014693241bcd9c20', '2087', '2121', '{\"username\":\"Fiona\",\"avatar\":\"https:\\/\\/thirdwx.qlogo.cn\\/mmopen\\/vi_32\\/Q0j4TwGTfTKFMHC57CAEBXuqG4JeQXtGXWFxg35CsbKnmxou9FuF0EkIN3Q0MQVZlptynyicQDkojYh9YwtguAA\\/132\",\"fromid\":\"2087\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\\u54c8\",\"toid\":\"2121\",\"mine\":false,\"timestamp\":1528251240341,\"id\":\"2087\"}', '1', 'friend', '1528251240');
INSERT INTO `yf_hf_chat_message` VALUES ('1009', 'b054014693241bcd9c20', '2108', '2059', '{\"username\":\"\\u542b\\u7f9e\\u8349\\u7075\\u5de7\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2108\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\\u54c8\",\"toid\":\"2059\",\"mine\":false,\"timestamp\":1528255593820.3,\"id\":\"2108\"}', '1', 'friend', '1528255593');
INSERT INTO `yf_hf_chat_message` VALUES ('1010', 'b054014693241bcd9c20', '599', '2138', '{\"username\":\"\\u5c0f\\u4e38\\u5b50\\u65e0\\u8f9c\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"599\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\\u54c8\",\"toid\":\"2138\",\"mine\":false,\"timestamp\":1528255797629.8,\"id\":\"599\"}', '1', 'friend', '1528255797');
INSERT INTO `yf_hf_chat_message` VALUES ('1011', 'b054014693241bcd9c20', '2108', '599', '{\"username\":\"\\u542b\\u7f9e\\u8349\\u7075\\u5de7\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2108\",\"type\":\"friend\",\"content\":\"2456\",\"toid\":\"599\",\"mine\":false,\"timestamp\":1528255888862.8,\"id\":\"2108\"}', '1', 'friend', '1528255888');
INSERT INTO `yf_hf_chat_message` VALUES ('1012', 'b054014693241bcd9c20', '2108', '599', '{\"username\":\"\\u542b\\u7f9e\\u8349\\u7075\\u5de7\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2108\",\"type\":\"friend\",\"content\":\"957\",\"toid\":\"599\",\"mine\":false,\"timestamp\":1528256027727.5,\"id\":\"2108\"}', '1', 'friend', '1528256027');
INSERT INTO `yf_hf_chat_message` VALUES ('1013', 'b054014693241bcd9c20', '2108', '599', '{\"username\":\"\\u542b\\u7f9e\\u8349\\u7075\\u5de7\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2108\",\"type\":\"friend\",\"content\":\"966\",\"toid\":\"599\",\"mine\":false,\"timestamp\":1528256563534.9,\"id\":\"2108\"}', '1', 'friend', '1528256563');
INSERT INTO `yf_hf_chat_message` VALUES ('1014', 'b054014693241bcd9c20', '599', '2139', '{\"username\":\"\\u5c0f\\u4e38\\u5b50\\u65e0\\u8f9c\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"599\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\\u54c8\",\"toid\":\"2139\",\"mine\":false,\"timestamp\":1528261667756.4,\"id\":\"599\"}', '1', 'friend', '1528261667');
INSERT INTO `yf_hf_chat_message` VALUES ('1015', 'b054014693241bcd9c20', '599', '2113', '{\"username\":\"\\u5c0f\\u4e38\\u5b50\\u65e0\\u8f9c\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"599\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\\u54c8jgj\",\"toid\":\"2113\",\"mine\":false,\"timestamp\":1528261708956.7,\"id\":\"599\"}', '1', 'friend', '1528261708');
INSERT INTO `yf_hf_chat_message` VALUES ('1016', 'b054014693241bcd9c20', '2138', '599', '{\"username\":\"\\u591a\\u60c5\\u6f14\\u53d8\\u7206\\u7c73\\u82b1\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2138\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\\u54c8\",\"toid\":\"599\",\"mine\":false,\"timestamp\":1528261724847.3,\"id\":\"2138\"}', '1', 'friend', '1528261724');
INSERT INTO `yf_hf_chat_message` VALUES ('1045', 'b054014693241bcd9c20', '2142', '2141', '{\"username\":\"\\u6545\\u610f\\u6709\\u706b\\u8f66\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2142\",\"type\":\"friend\",\"content\":\"1666\",\"toid\":\"2141\",\"mine\":false,\"timestamp\":1528265127590.7,\"id\":\"2142\"}', '1', 'friend', '1528267817');
INSERT INTO `yf_hf_chat_message` VALUES ('1054', 'b054014693241bcd9c20', '2146', '2144', '{\"username\":\"\\u73b0\\u5b9e\\u65b9\\u84dd\\u5929\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2146\",\"type\":\"friend\",\"content\":\"12356\",\"toid\":\"2144\",\"mine\":false,\"timestamp\":1528267392320.7,\"id\":\"2146\"}', '1', 'friend', '1528267405');
INSERT INTO `yf_hf_chat_message` VALUES ('1056', 'b054014693241bcd9c20', '2146', '2144', '{\"username\":\"\\u73b0\\u5b9e\\u65b9\\u84dd\\u5929\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2146\",\"type\":\"friend\",\"content\":\"654\",\"toid\":\"2144\",\"mine\":false,\"timestamp\":1528267424220.1,\"id\":\"2146\"}', '1', 'friend', '1528267441');
INSERT INTO `yf_hf_chat_message` VALUES ('1057', 'b054014693241bcd9c20', '2146', '2144', '{\"username\":\"\\u73b0\\u5b9e\\u65b9\\u84dd\\u5929\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2146\",\"type\":\"friend\",\"content\":\"5555\",\"toid\":\"2144\",\"mine\":false,\"timestamp\":1528267431796.1,\"id\":\"2146\"}', '1', 'friend', '1528267441');
INSERT INTO `yf_hf_chat_message` VALUES ('1060', 'b054014693241bcd9c20', '2146', '2146', '{\"username\":\"\\u73b0\\u5b9e\\u65b9\\u84dd\\u5929\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2146\",\"type\":\"friend\",\"content\":\"\\u5feb\\u5feb\\u4e50\\u4e50\",\"toid\":\"2146\",\"mine\":false,\"timestamp\":1528268097483,\"id\":\"2146\"}', '1', 'friend', '1528268132');
INSERT INTO `yf_hf_chat_message` VALUES ('1061', 'b054014693241bcd9c20', '2146', '2146', '{\"username\":\"\\u73b0\\u5b9e\\u65b9\\u84dd\\u5929\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2146\",\"type\":\"friend\",\"content\":\"\\u4f60\\u770b\\u770b\",\"toid\":\"2146\",\"mine\":false,\"timestamp\":1528268105202.7,\"id\":\"2146\"}', '1', 'friend', '1528268132');
INSERT INTO `yf_hf_chat_message` VALUES ('1062', 'b054014693241bcd9c20', '2146', '2144', '{\"username\":\"\\u73b0\\u5b9e\\u65b9\\u84dd\\u5929\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2146\",\"type\":\"friend\",\"content\":\"\\u5f00\\u8f66\\u770b\\u770b\",\"toid\":\"2144\",\"mine\":false,\"timestamp\":1528268157263.6,\"id\":\"2146\"}', '0', 'friend', '1528268157');
INSERT INTO `yf_hf_chat_message` VALUES ('1064', 'b054014693241bcd9c20', '2146', '2146', '{\"username\":\"\\u73b0\\u5b9e\\u65b9\\u84dd\\u5929\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2146\",\"type\":\"friend\",\"content\":\"\\u65b9\\u6cd5\\u770b\\u770b\",\"toid\":\"2146\",\"mine\":false,\"timestamp\":1528268352986.2,\"id\":\"2146\"}', '0', 'friend', '1528268352');
INSERT INTO `yf_hf_chat_message` VALUES ('1065', 'b054014693241bcd9c20', '2146', '2146', '{\"username\":\"\\u73b0\\u5b9e\\u65b9\\u84dd\\u5929\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2146\",\"type\":\"friend\",\"content\":\"\\u8bf4\",\"toid\":\"2146\",\"mine\":false,\"timestamp\":1528268369854.8,\"id\":\"2146\"}', '0', 'friend', '1528268369');
INSERT INTO `yf_hf_chat_message` VALUES ('1067', 'b054014693241bcd9c20', '2146', '2146', '{\"username\":\"\\u73b0\\u5b9e\\u65b9\\u84dd\\u5929\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2146\",\"type\":\"friend\",\"content\":\"\\u56de\\u5bb6\\u53eb\\u6211\",\"toid\":\"2146\",\"mine\":false,\"timestamp\":1528268526009.4,\"id\":\"2146\"}', '0', 'friend', '1528268526');
INSERT INTO `yf_hf_chat_message` VALUES ('1098', 'b054014693241bcd9c20', '2154', '473', '{\"username\":\"\\u91ce\\u6027\\u6253\\u673a\\u5668\\u732b\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2154\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\\u54c8\",\"toid\":\"473\",\"mine\":false,\"timestamp\":1528273978212.7,\"id\":\"2154\"}', '1', 'friend', '1528273978');
INSERT INTO `yf_hf_chat_message` VALUES ('1099', 'b054014693241bcd9c20', '2154', '2152', '{\"username\":\"\\u91ce\\u6027\\u6253\\u673a\\u5668\\u732b\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2154\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\\u54c8\",\"toid\":\"2152\",\"mine\":false,\"timestamp\":1528274039911.5,\"id\":\"2154\"}', '1', 'friend', '1528274308');
INSERT INTO `yf_hf_chat_message` VALUES ('1100', 'b054014693241bcd9c20', '2154', '2152', '{\"username\":\"\\u91ce\\u6027\\u6253\\u673a\\u5668\\u732b\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2154\",\"type\":\"friend\",\"content\":\"\\u54c8\\u54c8\",\"toid\":\"2152\",\"mine\":false,\"timestamp\":1528274078612.1,\"id\":\"2154\"}', '1', 'friend', '1528274308');
INSERT INTO `yf_hf_chat_message` VALUES ('1102', 'b054014693241bcd9c20', '2152', '2154', '{\"username\":\"\\u68c9\\u82b1\\u7cd6\\u5b8c\\u7f8e\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2152\",\"type\":\"friend\",\"content\":\" \\u5f88\\u5c34\\u5c2c\\u5427\",\"toid\":\"2154\",\"mine\":false,\"timestamp\":1528274318089.6,\"id\":\"2152\"}', '1', 'friend', '1528274319');
INSERT INTO `yf_hf_chat_message` VALUES ('1146', 'b054014693241bcd9c20', '2054', '1075', '{\"username\":\"\\u8001\\u90c1\\u7c73\",\"avatar\":\"http:\\/\\/q2.qlogo.cn\\/g?b=qq&amp;k=9xRnOVQKOxAO5WtzSBTNwA&amp;s=40&amp;t=1527955200\",\"content\":\"https:\\/\\/open.weixin.qq.com\\/connect\\/oauth2\\/authorize?appid=wxfb04e0c5fd994aa9&amp;redirect_uri=https%3A%2F%2Fyftest.fujuhaofang.com%2Fapi%2Fwxpublic%2Fgetuserinfo%3Fweb=aHR0cHM6Ly95ZnRlc3QuZnVqdWhhb2ZhbmcuY29tL3dlYi9pbmRleC5odG1sIy92aWRlb0RldGFpbHM\\/bWVtYmVyX2lkPTIwNTQmdmlkZW9faWQ9ODIw&amp;response_type=code&amp;scope=snsapi_userinfo&amp;state=aHR0cDovL3A3OXFrd3o2Yy5ia3QuY2xvdWRkbi5jb20vdmlkZW9faU9TXzIwMTgwNjA2MTYwNjE5P21lbWJlcl9pZD1NakExTkE9PSZpZD1PREl3#wechat_redirect\",\"fromid\":2054,\"type\":\"friend\",\"toid\":\"1075\",\"mine\":false,\"timestamp\":1528282347065.7,\"id\":2054,\"appkey\":\"b054014693241bcd9c20\"}', '0', 'friend', '1528282347');
INSERT INTO `yf_hf_chat_message` VALUES ('1147', 'b054014693241bcd9c20', '2054', '1075', '{\"username\":\"\\u8001\\u90c1\\u7c73\",\"avatar\":\"http:\\/\\/q2.qlogo.cn\\/g?b=qq&amp;k=9xRnOVQKOxAO5WtzSBTNwA&amp;s=40&amp;t=1527955200\",\"content\":\"https:\\/\\/open.weixin.qq.com\\/connect\\/oauth2\\/authorize?appid=wxfb04e0c5fd994aa9&amp;redirect_uri=https%3A%2F%2Fyftest.fujuhaofang.com%2Fapi%2Fwxpublic%2Fgetuserinfo%3Fweb=aHR0cHM6Ly95ZnRlc3QuZnVqdWhhb2ZhbmcuY29tL3dlYi9pbmRleC5odG1sIy92aWRlb0RldGFpbHM\\/bWVtYmVyX2lkPTIwNTQmdmlkZW9faWQ9ODIw&amp;response_type=code&amp;scope=snsapi_userinfo&amp;state=aHR0cDovL3A3OXFrd3o2Yy5ia3QuY2xvdWRkbi5jb20vdmlkZW9faU9TXzIwMTgwNjA2MTYwNjE5P21lbWJlcl9pZD1NakExTkE9PSZpZD1PREl3#wechat_redirect\",\"fromid\":2054,\"type\":\"friend\",\"toid\":\"1075\",\"mine\":false,\"timestamp\":1528282757055.7,\"id\":2054,\"appkey\":\"b054014693241bcd9c20\"}', '0', 'friend', '1528282757');
INSERT INTO `yf_hf_chat_message` VALUES ('1180', 'b054014693241bcd9c20', '599', '2113', '{\"username\":\"\\u5c0f\\u4e38\\u5b50\\u65e0\\u8f9c\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"599\",\"type\":\"friend\",\"content\":\"\\u5acc\\u6211\\u58a8\\u8ff9\\u5566\\u554a\",\"toid\":\"2113\",\"mine\":false,\"timestamp\":1528291822018.4,\"id\":\"599\"}', '0', 'friend', '1528291822');
INSERT INTO `yf_hf_chat_message` VALUES ('1181', 'b054014693241bcd9c20', '599', '2113', '{\"username\":\"\\u5c0f\\u4e38\\u5b50\\u65e0\\u8f9c\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"599\",\"type\":\"friend\",\"content\":\"\\u672b\\u672b\\u6d53\\u7eff\\u4e0d\",\"toid\":\"2113\",\"mine\":false,\"timestamp\":1528291842993.4,\"id\":\"599\"}', '0', 'friend', '1528291842');
INSERT INTO `yf_hf_chat_message` VALUES ('1184', 'b054014693241bcd9c20', '583', '568', '{\"username\":\"\\u6d3b\\u6cfc\\u4fdd\\u536b\\u871c\\u8702\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"583\",\"type\":\"friend\",\"content\":\"face[\\u5fae\\u7b11] \",\"toid\":\"568\",\"mine\":false,\"timestamp\":1528292329011.1,\"id\":\"583\"}', '1', 'friend', '1528337745');
INSERT INTO `yf_hf_chat_message` VALUES ('1185', 'b054014693241bcd9c20', '583', '1184', '{\"username\":\"\\u6d3b\\u6cfc\\u4fdd\\u536b\\u871c\\u8702\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"content\":\"https:\\/\\/open.weixin.qq.com\\/connect\\/oauth2\\/authorize?appid=wxfb04e0c5fd994aa9&amp;redirect_uri=https%3A%2F%2Fyftest.fujuhaofang.com%2Fapi%2Fwxpublic%2Fgetuserinfo%3Fweb=aHR0cHM6Ly95ZnRlc3QuZnVqdWhhb2ZhbmcuY29tL3dlYi9pbmRleC5odG1sIy92aWRlb0RldGFpbHM\\/bWVtYmVyX2lkPTU4MyZ2aWRlb19pZD04MTk=&amp;response_type=code&amp;scope=snsapi_userinfo&amp;state=aHR0cDovL3A3OXFrd3o2Yy5ia3QuY2xvdWRkbi5jb20vdmlkZW8tYW5kcm9pZC0yMDE4MDYwNjE2MDUxMD9tZW1iZXJfaWQ9TlRneiZpZD1PREU1#wechat_redirect\",\"fromid\":583,\"type\":\"friend\",\"toid\":\"1184\",\"mine\":false,\"timestamp\":1528292349119.1,\"id\":583,\"appkey\":\"b054014693241bcd9c20\"}', '0', 'friend', '1528292349');
INSERT INTO `yf_hf_chat_message` VALUES ('1186', 'b054014693241bcd9c20', '1184', '583', '{\"username\":\"\\u6d3b\\u6cfc\\u4fdd\\u536b\\u871c\\u8702\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"content\":\"https:\\/\\/open.weixin.qq.com\\/connect\\/oauth2\\/authorize?appid=wxfb04e0c5fd994aa9&amp;redirect_uri=https%3A%2F%2Fyftest.fujuhaofang.com%2Fapi%2Fwxpublic%2Fgetuserinfo%3Fweb=aHR0cHM6Ly95ZnRlc3QuZnVqdWhhb2ZhbmcuY29tL3dlYi9pbmRleC5odG1sIy92aWRlb0RldGFpbHM\\/bWVtYmVyX2lkPTU4MyZ2aWRlb19pZD04MTk=&amp;response_type=code&amp;scope=snsapi_userinfo&amp;state=aHR0cDovL3A3OXFrd3o2Yy5ia3QuY2xvdWRkbi5jb20vdmlkZW8tYW5kcm9pZC0yMDE4MDYwNjE2MDUxMD9tZW1iZXJfaWQ9TlRneiZpZD1PREU1#wechat_redirect\",\"fromid\":583,\"type\":\"friend\",\"toid\":\"1184\",\"mine\":false,\"timestamp\":1528292349119.1,\"id\":583,\"appkey\":\"b054014693241bcd9c20\"}', '1', 'friend', '1528342825');
INSERT INTO `yf_hf_chat_message` VALUES ('1187', 'b054014693241bcd9c20', '583', '1184', '{\"username\":\"\\u6d3b\\u6cfc\\u4fdd\\u536b\\u871c\\u8702\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"content\":\"https:\\/\\/open.weixin.qq.com\\/connect\\/oauth2\\/authorize?appid=wxfb04e0c5fd994aa9&amp;redirect_uri=https%3A%2F%2Fyftest.fujuhaofang.com%2Fapi%2Fwxpublic%2Fgetuserinfo%3Fweb=aHR0cHM6Ly95ZnRlc3QuZnVqdWhhb2ZhbmcuY29tL3dlYi9pbmRleC5odG1sIy92aWRlb0RldGFpbHM\\/bWVtYmVyX2lkPTU4MyZ2aWRlb19pZD04Mjc=&amp;response_type=code&amp;scope=snsapi_userinfo&amp;state=aHR0cDovL3A3OXFrd3o2Yy5ia3QuY2xvdWRkbi5jb20vdmlkZW9faU9TXzIwMTgwNjA2MTk1MDQzP21lbWJlcl9pZD1OVGd6JmlkPU9ESTM=#wechat_redirect\",\"fromid\":583,\"type\":\"friend\",\"toid\":\"1184\",\"mine\":false,\"timestamp\":1528292375385.7,\"id\":583,\"appkey\":\"b054014693241bcd9c20\"}', '0', 'friend', '1528292375');
INSERT INTO `yf_hf_chat_message` VALUES ('1188', 'b054014693241bcd9c20', '1184', '583', '{\"username\":\"\\u6d3b\\u6cfc\\u4fdd\\u536b\\u871c\\u8702\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"content\":\"https:\\/\\/open.weixin.qq.com\\/connect\\/oauth2\\/authorize?appid=wxfb04e0c5fd994aa9&amp;redirect_uri=https%3A%2F%2Fyftest.fujuhaofang.com%2Fapi%2Fwxpublic%2Fgetuserinfo%3Fweb=aHR0cHM6Ly95ZnRlc3QuZnVqdWhhb2ZhbmcuY29tL3dlYi9pbmRleC5odG1sIy92aWRlb0RldGFpbHM\\/bWVtYmVyX2lkPTU4MyZ2aWRlb19pZD04Mjc=&amp;response_type=code&amp;scope=snsapi_userinfo&amp;state=aHR0cDovL3A3OXFrd3o2Yy5ia3QuY2xvdWRkbi5jb20vdmlkZW9faU9TXzIwMTgwNjA2MTk1MDQzP21lbWJlcl9pZD1OVGd6JmlkPU9ESTM=#wechat_redirect\",\"fromid\":583,\"type\":\"friend\",\"toid\":\"1184\",\"mine\":false,\"timestamp\":1528292375385.7,\"id\":583,\"appkey\":\"b054014693241bcd9c20\"}', '1', 'friend', '1528342825');
INSERT INTO `yf_hf_chat_message` VALUES ('1239', 'b054014693241bcd9c20', '2178', '2021', '{\"username\":\"\\u75f4\\u60c5\\u8fce\\u67e0\\u6aac\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2178\",\"type\":\"friend\",\"content\":\"9875355\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528348924176.7,\"id\":\"2178\"}', '1', 'friend', '1528348950');
INSERT INTO `yf_hf_chat_message` VALUES ('1240', 'b054014693241bcd9c20', '2178', '2021', '{\"username\":\"\\u75f4\\u60c5\\u8fce\\u67e0\\u6aac\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2178\",\"type\":\"friend\",\"content\":\"3557\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528348946470.1,\"id\":\"2178\"}', '1', 'friend', '1528348950');
INSERT INTO `yf_hf_chat_message` VALUES ('1242', 'b054014693241bcd9c20', '2178', '2021', '{\"username\":\"\\u75f4\\u60c5\\u8fce\\u67e0\\u6aac\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2178\",\"type\":\"friend\",\"content\":\"555555\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528348958295.4,\"id\":\"2178\"}', '1', 'friend', '1528349086');
INSERT INTO `yf_hf_chat_message` VALUES ('1244', 'b054014693241bcd9c20', '2178', '2021', '{\"username\":\"\\u75f4\\u60c5\\u8fce\\u67e0\\u6aac\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2178\",\"type\":\"friend\",\"content\":\"5555\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528348964190.4,\"id\":\"2178\"}', '1', 'friend', '1528349086');
INSERT INTO `yf_hf_chat_message` VALUES ('1245', 'b054014693241bcd9c20', '2179', '2021', '{\"username\":\"\\u8bfa\\u8a00\\u523b\\u82e6\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2179\",\"type\":\"friend\",\"content\":\"357\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528349036999.7,\"id\":\"2179\"}', '1', 'friend', '1528349086');
INSERT INTO `yf_hf_chat_message` VALUES ('1246', 'b054014693241bcd9c20', '2179', '2021', '{\"username\":\"\\u8bfa\\u8a00\\u523b\\u82e6\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2179\",\"type\":\"friend\",\"content\":\"44885\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528349040584.8,\"id\":\"2179\"}', '1', 'friend', '1528349086');
INSERT INTO `yf_hf_chat_message` VALUES ('1247', 'b054014693241bcd9c20', '2179', '2021', '{\"username\":\"\\u8bfa\\u8a00\\u523b\\u82e6\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2179\",\"type\":\"friend\",\"content\":\"999\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528349069732.7,\"id\":\"2179\"}', '1', 'friend', '1528349086');
INSERT INTO `yf_hf_chat_message` VALUES ('1248', 'b054014693241bcd9c20', '2179', '2021', '{\"username\":\"\\u8bfa\\u8a00\\u523b\\u82e6\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2179\",\"type\":\"friend\",\"content\":\"55555\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528349072681.3,\"id\":\"2179\"}', '1', 'friend', '1528349086');
INSERT INTO `yf_hf_chat_message` VALUES ('1249', 'b054014693241bcd9c20', '2179', '2021', '{\"username\":\"\\u8bfa\\u8a00\\u523b\\u82e6\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2179\",\"type\":\"friend\",\"content\":\"ggggg\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528349091764.9,\"id\":\"2179\"}', '1', 'friend', '1528349146');
INSERT INTO `yf_hf_chat_message` VALUES ('1251', 'b054014693241bcd9c20', '2179', '2021', '{\"username\":\"\\u8bfa\\u8a00\\u523b\\u82e6\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2179\",\"type\":\"friend\",\"content\":\"gggggg\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528349139560.6,\"id\":\"2179\"}', '1', 'friend', '1528349146');
INSERT INTO `yf_hf_chat_message` VALUES ('1252', 'b054014693241bcd9c20', '2179', '2021', '{\"username\":\"\\u8bfa\\u8a00\\u523b\\u82e6\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2179\",\"type\":\"friend\",\"content\":\"bdbhdjjchch\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528349191996.6,\"id\":\"2179\"}', '1', 'friend', '1528349201');
INSERT INTO `yf_hf_chat_message` VALUES ('1254', 'b054014693241bcd9c20', '2179', '2021', '{\"username\":\"\\u8bfa\\u8a00\\u523b\\u82e6\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2179\",\"type\":\"friend\",\"content\":\"jdhdh\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528349264122.3,\"id\":\"2179\"}', '1', 'friend', '1528349268');
INSERT INTO `yf_hf_chat_message` VALUES ('1256', 'b054014693241bcd9c20', '2179', '2021', '{\"username\":\"\\u8bfa\\u8a00\\u523b\\u82e6\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2179\",\"type\":\"friend\",\"content\":\"jhgg\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528349305058.3,\"id\":\"2179\"}', '1', 'friend', '1528349308');
INSERT INTO `yf_hf_chat_message` VALUES ('1257', 'b054014693241bcd9c20', '2179', '2021', '{\"username\":\"\\u8bfa\\u8a00\\u523b\\u82e6\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"fromid\":\"2179\",\"type\":\"friend\",\"content\":\"ggggg\",\"toid\":\"2021\",\"mine\":false,\"timestamp\":1528349381776.4,\"id\":\"2179\"}', '1', 'friend', '1528349387');
INSERT INTO `yf_hf_chat_message` VALUES ('1283', 'b054014693241bcd9c20', '515', '514', '{\"username\":\"nothing\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"content\":\"a(https:\\/\\/www.baidu.com)[layui]\",\"fromid\":514,\"type\":\"friend\",\"toid\":\"515\",\"mine\":false,\"timestamp\":1528354968846,\"id\":514,\"appkey\":\"b054014693241bcd9c20\"}', '1', 'friend', '1528352491');
INSERT INTO `yf_hf_chat_message` VALUES ('1285', 'b054014693241bcd9c20', '515', '514', '{\"username\":\"nothing\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"content\":\"a(https:\\/\\/www.baidu.com)[layui]\",\"fromid\":514,\"type\":\"friend\",\"toid\":\"515\",\"mine\":false,\"timestamp\":1528355011934.3,\"id\":514,\"appkey\":\"b054014693241bcd9c20\"}', '1', 'friend', '1528355085');
INSERT INTO `yf_hf_chat_message` VALUES ('1289', 'b054014693241bcd9c20', '515', '514', '{\"username\":\"nothing\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"content\":\"a(https:\\/\\/www.baidu.com)[layui]\",\"fromid\":514,\"type\":\"friend\",\"toid\":\"515\",\"mine\":false,\"timestamp\":1528355112554.5,\"id\":514,\"appkey\":\"b054014693241bcd9c20\"}', '1', 'friend', '1528355613');
INSERT INTO `yf_hf_chat_message` VALUES ('1291', 'b054014693241bcd9c20', '515', '514', '{\"username\":\"nothing\",\"avatar\":\"https:\\/\\/yftest.fujuhaofang.com\\/uploads\\/picture\\/default\\/default-logo.png\",\"content\":\"a(https:\\/\\/www.baidu.com)[layui]\",\"fromid\":514,\"type\":\"friend\",\"toid\":\"515\",\"mine\":false,\"timestamp\":1528355141180.7,\"id\":514,\"appkey\":\"b054014693241bcd9c20\"}', '1', 'friend', '1528355613');

-- ----------------------------
-- Table structure for yf_hf_chat_white_list
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_chat_white_list`;
CREATE TABLE `yf_hf_chat_white_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(255) NOT NULL COMMENT ' 被添加人员id',
  `app_id` int(11) NOT NULL COMMENT ' ',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_chat_white_list
-- ----------------------------

-- ----------------------------
-- Table structure for yf_hf_comment
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_comment`;
CREATE TABLE `yf_hf_comment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `content` varchar(100) CHARACTER SET utf8mb4 DEFAULT '' COMMENT '评论内容',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '评论人id',
  `video_id` int(11) DEFAULT '0' COMMENT '视频id',
  `user_id` int(10) DEFAULT NULL COMMENT '发布视频的用户id',
  `parent_id` int(11) DEFAULT '0' COMMENT '上一条评论id',
  `comment_num` int(10) DEFAULT '0' COMMENT '点赞评论的总数量',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1808 DEFAULT CHARSET=utf8 COMMENT='视频评论表';

-- ----------------------------
-- Records of yf_hf_comment
-- ----------------------------
INSERT INTO `yf_hf_comment` VALUES ('746', '频房子还在么？', '1814', '793', '2106', '0', '0', '1528241440', '1528241440');
INSERT INTO `yf_hf_comment` VALUES ('747', '请问这是2室吗？没有看到另一个卧室。', '1969', '793', '2106', '0', '0', '1528241440', '1528241440');
INSERT INTO `yf_hf_comment` VALUES ('748', '有空调吗？', '969', '793', '2106', '0', '0', '1528241440', '1528241440');
INSERT INTO `yf_hf_comment` VALUES ('749', '可以养狗吗？', '1502', '793', '2106', '0', '0', '1528241440', '1528241440');
INSERT INTO `yf_hf_comment` VALUES ('759', '888', '1496', '797', '2059', '0', '0', '1528252719', '1528252719');
INSERT INTO `yf_hf_comment` VALUES ('889', '舍友怎么样？', '1586', '833', '473', '0', '0', '1528296787', '1528296787');
INSERT INTO `yf_hf_comment` VALUES ('890', '整租可以么？', '1123', '833', '473', '0', '0', '1528296787', '1528296787');
INSERT INTO `yf_hf_comment` VALUES ('891', '物业水电？', '1719', '833', '473', '0', '0', '1528296787', '1528296787');
INSERT INTO `yf_hf_comment` VALUES ('892', '还有不？实拍实价嘛？', '1635', '833', '473', '0', '0', '1528296787', '1528296787');
INSERT INTO `yf_hf_comment` VALUES ('893', '大宋，回复我一下', '2152', '833', '473', '0', '0', '1528333905', '1528333905');
INSERT INTO `yf_hf_comment` VALUES ('894', '可以，我回复你了，要来看房子吗', '473', '833', '473', '893', '0', '1528334270', '1528334270');
INSERT INTO `yf_hf_comment` VALUES ('895', '看得见吗', '473', '833', '473', '893', '0', '1528334753', '1528334753');
INSERT INTO `yf_hf_comment` VALUES ('896', '可以', '2152', '833', '473', '895', '0', '1528334793', '1528334793');
INSERT INTO `yf_hf_comment` VALUES ('897', '喂', '473', '833', '473', '893', '0', '1528334805', '1528334805');
INSERT INTO `yf_hf_comment` VALUES ('898', '在哪呀这房子', '2168', '833', '473', '0', '0', '1528336287', '1528336287');
INSERT INTO `yf_hf_comment` VALUES ('901', '在嘉定新城，怎么样来看看？', '473', '833', '473', '898', '0', '1528337537', '1528337537');
INSERT INTO `yf_hf_comment` VALUES ('905', '这么贵～', '575', '833', '473', '901', '1', '1528344022', '1528781155');
INSERT INTO `yf_hf_comment` VALUES ('919', '已经不贵了，价格好商量', '473', '833', '473', '905', '0', '1528350397', '1528350397');
INSERT INTO `yf_hf_comment` VALUES ('1147', '产权多少年？', '1146', '882', '598', '0', '0', '1528697124', '1529402912');
INSERT INTO `yf_hf_comment` VALUES ('1148', '小区绿化怎么样？', '794', '882', '598', '0', '1', '1528697124', '1529402911');
INSERT INTO `yf_hf_comment` VALUES ('1152', '租哪个房间，主卧？要3000？', '575', '833', '473', '919', '0', '1528703361', '1528703361');
INSERT INTO `yf_hf_comment` VALUES ('1158', '次卧，但是也不小，2000', '473', '833', '473', '1152', '1', '1528785623', '1530236242');
INSERT INTO `yf_hf_comment` VALUES ('1245', '周边有家庭聚会的地方吗？', '1689', '897', '575', '0', '0', '1528873893', '1528873893');
INSERT INTO `yf_hf_comment` VALUES ('1246', '产权多少年？', '1678', '897', '575', '0', '0', '1528873893', '1528873893');
INSERT INTO `yf_hf_comment` VALUES ('1247', '小区附近有幼儿园么？', '1102', '897', '575', '0', '0', '1528873894', '1528873894');
INSERT INTO `yf_hf_comment` VALUES ('1248', '有花园或露天阳台的房子吗？', '733', '898', '579', '0', '0', '1528873894', '1528873894');
INSERT INTO `yf_hf_comment` VALUES ('1249', '产权多少年？', '1241', '898', '579', '0', '0', '1528873894', '1528873894');
INSERT INTO `yf_hf_comment` VALUES ('1250', '哦哦', '575', '882', '598', '0', '1', '1528875930', '1529402912');
INSERT INTO `yf_hf_comment` VALUES ('1259', '哈哈', '575', '882', '598', '0', '1', '1528963395', '1529402911');
INSERT INTO `yf_hf_comment` VALUES ('1260', '哦哦', '575', '833', '473', '919', '0', '1528964926', '1530236237');
INSERT INTO `yf_hf_comment` VALUES ('1261', '你好，没有的', '579', '898', '579', '1248', '0', '1528966972', '1528966972');
INSERT INTO `yf_hf_comment` VALUES ('1262', '我评论', '575', '897', '575', '0', '0', '1528968494', '1528968494');
INSERT INTO `yf_hf_comment` VALUES ('1263', '没有了', '579', '898', '579', '1248', '0', '1528970599', '1528970599');
INSERT INTO `yf_hf_comment` VALUES ('1264', '没有了', '579', '898', '579', '1248', '0', '1528970599', '1528970599');
INSERT INTO `yf_hf_comment` VALUES ('1265', '没有了', '579', '898', '579', '1248', '0', '1528970600', '1528970600');
INSERT INTO `yf_hf_comment` VALUES ('1267', '你还，还在的', '579', '898', '579', '1248', '0', '1529026925', '1529026925');
INSERT INTO `yf_hf_comment` VALUES ('1268', '50年了，欢迎亲来看房', '579', '898', '579', '1249', '0', '1529026969', '1529026969');
INSERT INTO `yf_hf_comment` VALUES ('1273', '同小心翼翼', '449', '797', '2059', '759', '0', '1529030375', '1529030375');
INSERT INTO `yf_hf_comment` VALUES ('1274', '咯哦哦哦', '449', '797', '2059', '759', '0', '1529030399', '1529030399');
INSERT INTO `yf_hf_comment` VALUES ('1275', '哼哼唧唧', '570', '905', '579', '0', '0', '1529041614', '1529041614');
INSERT INTO `yf_hf_comment` VALUES ('1276', '哈哈哈', '570', '905', '579', '0', '0', '1529041641', '1529041641');
INSERT INTO `yf_hf_comment` VALUES ('1277', '那就将就', '570', '905', '579', '0', '0', '1529041711', '1529041711');
INSERT INTO `yf_hf_comment` VALUES ('1278', '哈哈哈哈', '570', '905', '579', '0', '0', '1529041727', '1529041727');
INSERT INTO `yf_hf_comment` VALUES ('1279', '黄宾虹旧居', '570', '905', '579', '0', '0', '1529042065', '1529042065');
INSERT INTO `yf_hf_comment` VALUES ('1281', '斤斤计较', '570', '905', '579', '0', '0', '1529043814', '1529043814');
INSERT INTO `yf_hf_comment` VALUES ('1284', '房子还在吗', '579', '908', '449', '0', '0', '1529048531', '1529048531');
INSERT INTO `yf_hf_comment` VALUES ('1285', '有时间可以看看嘛', '579', '908', '449', '0', '0', '1529048542', '1529048542');
INSERT INTO `yf_hf_comment` VALUES ('1286', '有优惠吗', '579', '908', '449', '0', '0', '1529048558', '1529048558');
INSERT INTO `yf_hf_comment` VALUES ('1293', '漂亮', '2054', '905', '579', '0', '0', '1529396127', '1529396127');
INSERT INTO `yf_hf_comment` VALUES ('1294', '小区里有健身房么？', '1799', '899', '570', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1295', '房子一般都在什么价位到什么价位？', '851', '899', '570', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1296', '小区是封闭式的么？保安怎么样？', '1147', '899', '570', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1297', '小区附近有幼儿园么？', '1644', '900', '449', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1298', '小区附近有幼儿园么？', '2014', '901', '449', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1299', '小区内的路走车方便么？能两辆车一块走么？', '1464', '902', '575', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1300', '房子一般都在什么价位到什么价位？', '1606', '902', '575', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1301', '有花园或露天阳台的房子吗？', '1092', '902', '575', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1302', '物业类型是那些？', '794', '902', '575', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1303', '小区内的路走车方便么？能两辆车一块走么？', '1305', '904', '575', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1304', '保安的素质怎么样？', '1174', '904', '575', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1305', '小区的道路、楼道干净吗？', '1859', '904', '575', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1306', '这个房价是否值得入？还能再涨吗？', '613', '904', '575', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1307', '怎么联系你？', '1558', '905', '579', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1308', '具体位置是哪？', '2009', '905', '579', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1309', '联系方式多少？', '1925', '905', '579', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1310', '还有不？实拍实价嘛？', '611', '905', '579', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1311', '房子跟视频一样嘛？', '847', '905', '579', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1312', '我想租有窗，室内采光好，最重要押一付一。', '1133', '907', '449', '0', '0', '1529460724', '1529460724');
INSERT INTO `yf_hf_comment` VALUES ('1313', '你好，是和那个单位签合同？', '1461', '907', '449', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1314', '带卫生间？', '1439', '907', '449', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1315', '房子还在么？', '810', '908', '449', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1316', '何时可看房？ ', '1089', '908', '449', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1317', '有空调吗？', '1723', '908', '449', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1318', '你好，还有其他单间吗？', '1368', '908', '449', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1319', '押金多少？', '1953', '908', '449', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1320', '附近有地铁站么？', '1269', '910', '2054', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1321', '有地方停车么？', '1050', '910', '2054', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1322', '小区好停车吗？车位多不多？', '1704', '911', '570', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1323', '小区那个大门靠近主干道？', '627', '911', '570', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1324', '有花园或露天阳台的房子吗？', '1310', '911', '570', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1325', '小区附近有幼儿园么？', '834', '911', '570', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1326', '小区附近有幼儿园么？', '986', '913', '570', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1327', '怎么联系你？', '1558', '919', '2203', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1328', '让带孩子么？', '1226', '919', '2203', '0', '0', '1529460725', '1529460725');
INSERT INTO `yf_hf_comment` VALUES ('1329', '小区的成交量在整个板块处于什么位置？', '834', '924', '579', '0', '0', '1529462080', '1529462080');
INSERT INTO `yf_hf_comment` VALUES ('1330', '小区是封闭式的么？保安怎么样？', '883', '924', '579', '0', '0', '1529462081', '1529462081');
INSERT INTO `yf_hf_comment` VALUES ('1331', '房子一般都在什么价位到什么价位？', '1193', '925', '579', '0', '0', '1529463526', '1529463526');
INSERT INTO `yf_hf_comment` VALUES ('1332', '小区的成交量在整个板块处于什么位置？', '1969', '925', '579', '0', '0', '1529463526', '1529463526');
INSERT INTO `yf_hf_comment` VALUES ('1333', '约个时间看下房吧', '1758', '926', '579', '0', '0', '1529464071', '1529464071');
INSERT INTO `yf_hf_comment` VALUES ('1334', '怎么联系你？', '1819', '927', '579', '0', '0', '1529464071', '1529464071');
INSERT INTO `yf_hf_comment` VALUES ('1335', '房子带阳台吗？', '1309', '927', '579', '0', '0', '1529464071', '1529464071');
INSERT INTO `yf_hf_comment` VALUES ('1336', '我想租有窗，室内采光好，最重要押一付一。', '1721', '927', '579', '0', '0', '1529464072', '1529464072');
INSERT INTO `yf_hf_comment` VALUES ('1337', '商业用电？', '1914', '927', '579', '0', '0', '1529464072', '1529464072');
INSERT INTO `yf_hf_comment` VALUES ('1338', '房子在什么位置呀', '2184', '939', '521', '0', '0', '1529482131', '1529482131');
INSERT INTO `yf_hf_comment` VALUES ('1340', '房租', '521', '931', '2184', '0', '0', '1529482326', '1529482326');
INSERT INTO `yf_hf_comment` VALUES ('1341', '给给给', '2184', '931', '2184', '1340', '0', '1529482335', '1529482335');
INSERT INTO `yf_hf_comment` VALUES ('1342', '哈哈哈哈哈哈哈', '2184', '931', '2184', '1341', '0', '1529482388', '1529482388');
INSERT INTO `yf_hf_comment` VALUES ('1343', '古古怪怪', '2184', '931', '2184', '1340', '0', '1529482404', '1529482404');
INSERT INTO `yf_hf_comment` VALUES ('1344', '家斤斤计较', '521', '931', '2184', '0', '0', '1529482460', '1529482460');
INSERT INTO `yf_hf_comment` VALUES ('1345', '点点滴滴', '2184', '931', '2184', '1344', '0', '1529482487', '1529482487');

-- ----------------------------
-- Table structure for yf_hf_device
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_device`;
CREATE TABLE `yf_hf_device` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `member_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户member_id',
  `device_id` varchar(100) NOT NULL COMMENT '手机设备唯一ID 安卓uuid 苹果deviceToken',
  `os` varchar(10) NOT NULL DEFAULT '' COMMENT '设备  iOS android unknow',
  `version` varchar(10) NOT NULL DEFAULT '' COMMENT '版本',
  `create_time` int(10) NOT NULL DEFAULT '0',
  `update_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_name` (`device_id`)
) ENGINE=InnoDB AUTO_INCREMENT=384 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统行为表';

-- ----------------------------
-- Records of yf_hf_device
-- ----------------------------
INSERT INTO `yf_hf_device` VALUES ('1', '222', '45645645645646', 'ios', '1.0.0', '0', '1525922944');
INSERT INTO `yf_hf_device` VALUES ('17', '232', '45645645645646', 'ios', '', '1525575682', '1525575682');
INSERT INTO `yf_hf_device` VALUES ('18', '445', '1356498635', 'ios', '1.1.2', '1525845825', '1531190986');
INSERT INTO `yf_hf_device` VALUES ('19', '446', '45645645645646', 'ios', '', '1525923200', '1525923200');
INSERT INTO `yf_hf_device` VALUES ('20', '447', '68f6eba3d14e446983531e183987506e', 'ios', '1.0.0', '1525928586', '1526295982');
INSERT INTO `yf_hf_device` VALUES ('21', '448', '', '', '', '1525930024', '1526118660');
INSERT INTO `yf_hf_device` VALUES ('22', '450', '45645645645646', 'ios', '', '1525941794', '1525941794');
INSERT INTO `yf_hf_device` VALUES ('23', '451', '466052a43443604c', 'Android', '1.0.0', '1525943467', '1526274494');
INSERT INTO `yf_hf_device` VALUES ('24', '452', '', '', '', '1525949768', '1525950508');
INSERT INTO `yf_hf_device` VALUES ('25', '460', '', '', '', '1525951565', '1526002536');
INSERT INTO `yf_hf_device` VALUES ('26', '468', 'yyyyMMDDHHmmss', 'ios', '', '1526005951', '1526005951');
INSERT INTO `yf_hf_device` VALUES ('27', '470', '45645645645646', 'ios', '', '1526024345', '1526024345');
INSERT INTO `yf_hf_device` VALUES ('28', '471', 'yyyyMMDDHHmmss', 'ios', '', '1526035992', '1526035992');
INSERT INTO `yf_hf_device` VALUES ('29', '476', 'a8fe8e10cb5024fa', 'Android', '', '1526284865', '1526284865');
INSERT INTO `yf_hf_device` VALUES ('32', '503', '71d847e0c4f6495baebe770b761ff4a0', 'ios', '', '1526353743', '1526353743');
INSERT INTO `yf_hf_device` VALUES ('36', '504', '2f0cf2f75f79496893a35ea7ef1b274f', 'ios', '', '1526361749', '1526361749');
INSERT INTO `yf_hf_device` VALUES ('38', '505', '45645645645646', 'ios', '', '1526362086', '1526362086');
INSERT INTO `yf_hf_device` VALUES ('40', '506', '45645645645646', 'ios', '', '1526362216', '1526362216');
INSERT INTO `yf_hf_device` VALUES ('41', '507', '45645645645646', 'ios', '', '1526362250', '1526362250');
INSERT INTO `yf_hf_device` VALUES ('42', '508', '45645645645646', 'ios', '', '1526362451', '1526362451');
INSERT INTO `yf_hf_device` VALUES ('43', '509', '45645645645646', 'ios', '', '1526363553', '1526363553');
INSERT INTO `yf_hf_device` VALUES ('44', '510', '45645645645646', 'ios', '', '1526363802', '1526363802');
INSERT INTO `yf_hf_device` VALUES ('45', '511', '45645645645646', 'ios', '', '1526364198', '1526364198');
INSERT INTO `yf_hf_device` VALUES ('46', '512', '45645645645646', 'ios', '', '1526364426', '1526364426');
INSERT INTO `yf_hf_device` VALUES ('47', '513', '1', 'Android', '1.0.0', '1526367958', '1531813650');
INSERT INTO `yf_hf_device` VALUES ('48', '514', '111', 'android', '1.0.0', '1526368555', '1528386082');
INSERT INTO `yf_hf_device` VALUES ('49', '515', '0f35e5c9d32745b348ed2bbb46b2733b', 'Android', '1.0.0', '1526368695', '1528423502');
INSERT INTO `yf_hf_device` VALUES ('50', '516', '867f5faef186dfb4b0bc5d7d7fd95fa4', 'ios', '1.1.0', '1526370194', '1528440602');
INSERT INTO `yf_hf_device` VALUES ('54', '518', '41195d7f817c490d935e05e843dc990e', 'ios', '', '1526523486', '1526523486');
INSERT INTO `yf_hf_device` VALUES ('55', '519', '45645645645646', 'ios', '', '1526524233', '1526524233');
INSERT INTO `yf_hf_device` VALUES ('56', '520', '9ae01dfdc0bb8a7cee077b127acbc58d', 'Android', '1.0.0', '1526529126', '1528168104');
INSERT INTO `yf_hf_device` VALUES ('57', '521', '53cc896c1cceaf99a32fe615a344556a', 'ios', '1.1.3', '1526546639', '1531447219');
INSERT INTO `yf_hf_device` VALUES ('58', '522', '53cc896c1cceaf99a32fe615a344556a', 'ios', '1.1.3', '1526546691', '1531389283');
INSERT INTO `yf_hf_device` VALUES ('59', '517', '00938ca3a8638858093b039baecbbc5a', 'ios', '1.1.0', '1526612609', '1528696591');
INSERT INTO `yf_hf_device` VALUES ('60', '523', '41195d7f817c490d935e05e843dc990e', 'ios', '1.0.0', '1526613421', '1528076131');
INSERT INTO `yf_hf_device` VALUES ('69', '561', '45645645645646', 'ios', '', '1526892559', '1526892559');
INSERT INTO `yf_hf_device` VALUES ('70', '564', '45645645645646', 'ios', '', '1526893075', '1526893075');
INSERT INTO `yf_hf_device` VALUES ('71', '565', '45645645645646', 'ios', '', '1526893595', '1526893595');
INSERT INTO `yf_hf_device` VALUES ('74', '566', 'ebcfdae8e39d03d1d92fe28a1bc5c71a', 'ios', '1.0.0', '1526978132', '1528249826');
INSERT INTO `yf_hf_device` VALUES ('84', '568', '8a7788085faa8f0217d2e8a08eb8ee23', 'ios', '1.1.2', '1527127671', '1530855323');
INSERT INTO `yf_hf_device` VALUES ('88', '571', '792ab500e5294500ac600eda287bc897', 'ios', '', '1527260316', '1527260316');
INSERT INTO `yf_hf_device` VALUES ('89', '572', '6caac4b86be72c75e3f57f34a51ec87b', 'ios', '1.1.0', '1527260393', '1528684421');
INSERT INTO `yf_hf_device` VALUES ('90', '573', '867f5faef186dfb4b0bc5d7d7fd95fa4', 'ios', '1.1.0', '1527260405', '1528684232');
INSERT INTO `yf_hf_device` VALUES ('94', '574', '10c20382d78d6daf86639b3fc588f046', 'ios', '1.0.0', '1527388030', '1528169113');
INSERT INTO `yf_hf_device` VALUES ('95', '575', 'ff04908bd0cc2367482944c1fae1560b', 'Android', '1.0.0', '1527495232', '1531465591');
INSERT INTO `yf_hf_device` VALUES ('99', '576', '6f77d69eedf250cc', 'Android', '', '1527649098', '1527649098');
INSERT INTO `yf_hf_device` VALUES ('100', '580', '8983d9ceb9760b91fa62ee122d2d0833', 'Android', '1.0.0', '1527668219', '1528697243');
INSERT INTO `yf_hf_device` VALUES ('101', '581', '417ffa288ab936163288b1d90ba56fff', 'Android', '1.0.0', '1527677341', '1528795435');
INSERT INTO `yf_hf_device` VALUES ('102', '582', 'c531d373fc2f046', 'Android', '1.0.0', '1527677534', '1527818470');
INSERT INTO `yf_hf_device` VALUES ('103', '583', '8a7788085faa8f0217d2e8a08eb8ee23', 'ios', '1.0.0', '1527730005', '1528342732');
INSERT INTO `yf_hf_device` VALUES ('104', '584', '96599d055527452bb25d6914b69fe42f', 'ios', '', '1527745261', '1527745261');
INSERT INTO `yf_hf_device` VALUES ('105', '570', '11b26b732e5da87b10fab97fa9bcb58c', 'Android', '1.0.0', '1527747354', '1528681597');
INSERT INTO `yf_hf_device` VALUES ('107', '585', '5777731fd2c043378274b84016531c5f', 'ios', '', '1527751442', '1527751442');
INSERT INTO `yf_hf_device` VALUES ('108', '586', '10c20382d78d6daf86639b3fc588f046', 'ios', '1.0.0', '1527753474', '1528186383');
INSERT INTO `yf_hf_device` VALUES ('109', '587', '09f4817821e08139c910fc035bb680e5', 'Android', '1.0.0', '1527753559', '1528007962');
INSERT INTO `yf_hf_device` VALUES ('110', '588', 'xxxxxxxxxxxx', 'unknow', '', '1527754047', '1527754047');
INSERT INTO `yf_hf_device` VALUES ('115', '590', 'xxxxxxxxxxxx', 'unknow', '', '1527759654', '1527759654');
INSERT INTO `yf_hf_device` VALUES ('116', '590', 'xxxxxxxxxxxx', 'unknow', '', '1527759758', '1527759758');
INSERT INTO `yf_hf_device` VALUES ('120', '597', 'xxxxxxxxxxxx', 'unknow', '', '1527760912', '1527760912');
INSERT INTO `yf_hf_device` VALUES ('121', '598', 'c0c45b898776ae17d0750bd3e8cc2af9', 'Android', '1.0.0', '1527761381', '1528681356');
INSERT INTO `yf_hf_device` VALUES ('122', '599', '8983d9ceb9760b91fa62ee122d2d0833', 'Android', '1.0.0', '1527819797', '1528252260');
INSERT INTO `yf_hf_device` VALUES ('123', '600', '2f0cf2f75f79496893a35ea7ef1b274f', 'ios', '', '1527819797', '1527819797');
INSERT INTO `yf_hf_device` VALUES ('128', '601', '5777731fd2c043378274b84016531c5f', 'ios', '', '1527837539', '1527837539');
INSERT INTO `yf_hf_device` VALUES ('130', '602', '5777731fd2c043378274b84016531c5f', 'ios', '', '1527840717', '1527840717');
INSERT INTO `yf_hf_device` VALUES ('131', '603', '466052a43443604c', 'Android', '', '1527841128', '1527841128');
INSERT INTO `yf_hf_device` VALUES ('132', '604', '466052a43443604c', 'Android', '', '1527841192', '1527841192');
INSERT INTO `yf_hf_device` VALUES ('154', '2022', 'xxxxxxxxxxxx', 'unknow', '', '1528018562', '1528018562');
INSERT INTO `yf_hf_device` VALUES ('155', '2023', 'xxxxxxxxxxxx', 'unknow', '', '1528018757', '1528018757');
INSERT INTO `yf_hf_device` VALUES ('157', '2024', 'e82f9c62d519e48acc552b43c752a54d', 'Android', '1.0.0', '1528019638', '1528182716');
INSERT INTO `yf_hf_device` VALUES ('159', '2025', '41195d7f817c490d935e05e843dc990e', 'ios', '1.0.0', '1528023229', '1528095993');
INSERT INTO `yf_hf_device` VALUES ('160', '2026', '41195d7f817c490d935e05e843dc990e', 'ios', '', '1528027508', '1528027508');
INSERT INTO `yf_hf_device` VALUES ('168', '2033', 'xxxxxxxxxxxx', 'unknow', '', '1528078596', '1528078596');
INSERT INTO `yf_hf_device` VALUES ('169', '2034', 'xxxxxxxxxxxx', 'unknow', '', '1528079286', '1528079286');
INSERT INTO `yf_hf_device` VALUES ('170', '2035', 'xxxxxxxxxxxx', 'unknow', '', '1528079334', '1528079334');
INSERT INTO `yf_hf_device` VALUES ('171', '2036', 'xxxxxxxxxxxx', 'unknow', '', '1528080619', '1528080619');
INSERT INTO `yf_hf_device` VALUES ('172', '2037', 'xxxxxxxxxxxx', 'unknow', '', '1528081158', '1528081158');
INSERT INTO `yf_hf_device` VALUES ('173', '2038', 'xxxxxxxxxxxx', 'unknow', '', '1528081572', '1528081572');
INSERT INTO `yf_hf_device` VALUES ('174', '2039', 'xxxxxxxxxxxx', 'unknow', '', '1528081631', '1528081631');
INSERT INTO `yf_hf_device` VALUES ('176', '2041', 'xxxxxxxxxxxx', 'unknow', '', '1528081935', '1528081935');
INSERT INTO `yf_hf_device` VALUES ('177', '2042', 'xxxxxxxxxxxx', 'unknow', '', '1528081990', '1528081990');
INSERT INTO `yf_hf_device` VALUES ('178', '2043', 'xxxxxxxxxxxx', 'unknow', '', '1528082246', '1528082246');
INSERT INTO `yf_hf_device` VALUES ('179', '577', 'c4534421f865c901f8b006ab24557be7', 'Android', '1.0.0', '1528083785', '1528276299');
INSERT INTO `yf_hf_device` VALUES ('181', '2044', 'xxxxxxxxxxxx', 'unknow', '', '1528095049', '1528095049');
INSERT INTO `yf_hf_device` VALUES ('182', '2045', 'xxxxxxxxxxxx', 'unknow', '', '1528095616', '1528095616');
INSERT INTO `yf_hf_device` VALUES ('183', '2046', '466052a43443604c', 'Android', '', '1528096985', '1528096985');
INSERT INTO `yf_hf_device` VALUES ('184', '2047', 'xxxxxxxxxxxx', 'unknow', '', '1528097043', '1528097043');
INSERT INTO `yf_hf_device` VALUES ('187', '2049', '5777731fd2c043378274b84016531c5f', 'ios', '', '1528102980', '1528102980');
INSERT INTO `yf_hf_device` VALUES ('188', '2050', '470ec663a7bb495ab851304fd841a5a3', 'ios', '', '1528106356', '1528106356');
INSERT INTO `yf_hf_device` VALUES ('189', '2051', '41195d7f817c490d935e05e843dc990e', 'ios', '', '1528109534', '1528109534');
INSERT INTO `yf_hf_device` VALUES ('190', '2052', 'xxxxxxxxxxxx', 'unknow', '', '1528114533', '1528114533');
INSERT INTO `yf_hf_device` VALUES ('192', '2053', 'c6d3329d2450253c', 'Android', '', '1528118263', '1528118263');
INSERT INTO `yf_hf_device` VALUES ('193', '2055', 'xxxxxxxxxxxx', 'unknow', '', '1528119193', '1528119193');
INSERT INTO `yf_hf_device` VALUES ('194', '2056', '466052a43443604c', 'Android', '', '1528162083', '1528162083');
INSERT INTO `yf_hf_device` VALUES ('195', '2057', '470ec663a7bb495ab851304fd841a5a3', 'ios', '', '1528162139', '1528162139');
INSERT INTO `yf_hf_device` VALUES ('196', '2058', '466052a43443604c', 'Android', '', '1528162196', '1528162196');
INSERT INTO `yf_hf_device` VALUES ('203', '2059', '960c781d62094cd3f38cfaf437301235', 'Android', '', '1528167448', '1528167448');
INSERT INTO `yf_hf_device` VALUES ('204', '473', '204', 'Android', '1.0.0', '1528167611', '1531813882');
INSERT INTO `yf_hf_device` VALUES ('205', '2060', 'xxxxxxxxxxxx', 'unknow', '', '1528172585', '1528172585');
INSERT INTO `yf_hf_device` VALUES ('206', '2061', '775a117a633c9cac9281fc1a705c93ba', 'Android', '', '1528172844', '1528172844');
INSERT INTO `yf_hf_device` VALUES ('207', '2062', 'ed55847a7d2011f083ba53040f064189', 'ios', '1.0.0', '1528172973', '1528182136');

-- ----------------------------
-- Table structure for yf_hf_follow
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_follow`;
CREATE TABLE `yf_hf_follow` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '关注id',
  `member_id` int(11) unsigned NOT NULL COMMENT '用户id',
  `followed_id` int(11) unsigned NOT NULL COMMENT '被关注id',
  `type` tinyint(3) unsigned NOT NULL COMMENT '关注类型 0关注人 1关注小区 2关注视频,点赞视频 3点赞别人的评论',
  `black` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '拉黑:双方拉黑关系删除，（单方拉黑，另一方发消息时提示）',
  `is_followed` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否关注 1关注  0取消关注',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关注时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2382 DEFAULT CHARSET=utf8 COMMENT='关注表';

-- ----------------------------
-- Records of yf_hf_follow
-- ----------------------------
INSERT INTO `yf_hf_follow` VALUES ('711', '514', '517', '0', '0', '0', '1528003219', '1528003219');
INSERT INTO `yf_hf_follow` VALUES ('712', '449', '517', '0', '0', '1', '1528003225', '1528003225');
INSERT INTO `yf_hf_follow` VALUES ('713', '522', '460', '0', '0', '1', '1528003246', '1528003246');
INSERT INTO `yf_hf_follow` VALUES ('715', '522', '517', '0', '0', '0', '1528003339', '1528003339');
INSERT INTO `yf_hf_follow` VALUES ('716', '522', '7525', '1', '0', '1', '1528003341', '1528003341');
INSERT INTO `yf_hf_follow` VALUES ('718', '570', '520', '0', '0', '0', '1528003381', '1528003381');
INSERT INTO `yf_hf_follow` VALUES ('719', '570', '473', '0', '0', '0', '1528003386', '1528003386');
INSERT INTO `yf_hf_follow` VALUES ('720', '570', '460', '0', '0', '0', '1528003390', '1528003390');
INSERT INTO `yf_hf_follow` VALUES ('721', '570', '224', '0', '0', '0', '1528003392', '1528003392');
INSERT INTO `yf_hf_follow` VALUES ('722', '570', '574', '0', '0', '0', '1528003401', '1528003404');
INSERT INTO `yf_hf_follow` VALUES ('723', '514', '1574', '1', '0', '1', '1528003403', '1528003405');
INSERT INTO `yf_hf_follow` VALUES ('724', '570', '515', '0', '0', '0', '1528003412', '1528003406');
INSERT INTO `yf_hf_follow` VALUES ('725', '570', '522', '0', '0', '0', '1528003413', '1528003407');
INSERT INTO `yf_hf_follow` VALUES ('726', '570', '514', '0', '0', '0', '1528003414', '1528003408');
INSERT INTO `yf_hf_follow` VALUES ('727', '570', '588', '0', '0', '0', '1528003416', '1528003409');
INSERT INTO `yf_hf_follow` VALUES ('728', '570', '589', '0', '0', '0', '1528003417', '1528003410');
INSERT INTO `yf_hf_follow` VALUES ('729', '570', '597', '0', '0', '0', '1528003420', '1528003411');
INSERT INTO `yf_hf_follow` VALUES ('730', '570', '517', '0', '0', '0', '1528003421', '1529648591');
INSERT INTO `yf_hf_follow` VALUES ('731', '570', '521', '0', '0', '0', '1528003422', '1529648596');
INSERT INTO `yf_hf_follow` VALUES ('732', '570', '512', '0', '1', '0', '1528003424', '1531209506');
INSERT INTO `yf_hf_follow` VALUES ('733', '570', '513', '0', '0', '0', '1528003425', '1528003415');
INSERT INTO `yf_hf_follow` VALUES ('734', '570', '516', '0', '0', '0', '1528003427', '1528003416');
INSERT INTO `yf_hf_follow` VALUES ('735', '570', '518', '0', '0', '0', '1528003428', '1529648600');
INSERT INTO `yf_hf_follow` VALUES ('736', '570', '519', '0', '0', '0', '1528003429', '1529648604');
INSERT INTO `yf_hf_follow` VALUES ('737', '570', '523', '0', '0', '0', '1528003432', '1529648607');
INSERT INTO `yf_hf_follow` VALUES ('738', '570', '561', '0', '0', '0', '1528003434', '1529648611');
INSERT INTO `yf_hf_follow` VALUES ('742', '522', '7524', '1', '0', '1', '1528003841', '1528003421');
INSERT INTO `yf_hf_follow` VALUES ('743', '449', '7525', '1', '0', '1', '1528004357', '1528003422');
INSERT INTO `yf_hf_follow` VALUES ('744', '522', '516', '0', '0', '1', '1528004478', '1528003423');
INSERT INTO `yf_hf_follow` VALUES ('745', '473', '520', '0', '0', '0', '1528004863', '1528003424');
INSERT INTO `yf_hf_follow` VALUES ('746', '473', '514', '0', '0', '1', '1528005090', '1528003425');
INSERT INTO `yf_hf_follow` VALUES ('747', '473', '1282', '0', '0', '1', '1528005151', '1528003426');
INSERT INTO `yf_hf_follow` VALUES ('748', '515', '768', '0', '0', '1', '1528005211', '1528003427');
INSERT INTO `yf_hf_follow` VALUES ('750', '473', '1024', '0', '0', '1', '1528005301', '1528013403');
INSERT INTO `yf_hf_follow` VALUES ('751', '515', '473', '0', '0', '1', '1528006141', '1528023403');
INSERT INTO `yf_hf_follow` VALUES ('752', '516', '572', '0', '0', '1', '1528007308', '1528003303');
INSERT INTO `yf_hf_follow` VALUES ('753', '587', '7524', '1', '0', '0', '1528007969', '1528003203');
INSERT INTO `yf_hf_follow` VALUES ('754', '587', '522', '0', '0', '0', '1528007980', '1528003103');
INSERT INTO `yf_hf_follow` VALUES ('755', '449', '522', '0', '0', '1', '1528008577', '1528003503');
INSERT INTO `yf_hf_follow` VALUES ('761', '449', '7506', '1', '0', '0', '1528009172', '1528003603');
INSERT INTO `yf_hf_follow` VALUES ('762', '522', '8151', '1', '0', '1', '1528009259', '1528009259');
INSERT INTO `yf_hf_follow` VALUES ('763', '522', '7799', '1', '0', '1', '1528009267', '1528009267');
INSERT INTO `yf_hf_follow` VALUES ('766', '570', '573', '0', '0', '0', '1528009935', '1529648618');
INSERT INTO `yf_hf_follow` VALUES ('767', '570', '572', '0', '0', '0', '1528009936', '1529648621');
INSERT INTO `yf_hf_follow` VALUES ('768', '570', '571', '0', '0', '0', '1528009937', '1529648626');
INSERT INTO `yf_hf_follow` VALUES ('769', '570', '569', '0', '0', '0', '1528009943', '1529648629');
INSERT INTO `yf_hf_follow` VALUES ('770', '570', '568', '0', '0', '0', '1528009944', '1529648633');
INSERT INTO `yf_hf_follow` VALUES ('771', '570', '567', '0', '0', '0', '1528009945', '1529648637');
INSERT INTO `yf_hf_follow` VALUES ('772', '570', '566', '0', '0', '0', '1528009947', '1529648646');
INSERT INTO `yf_hf_follow` VALUES ('773', '570', '565', '0', '0', '0', '1528009945', '1529648643');
INSERT INTO `yf_hf_follow` VALUES ('774', '570', '564', '0', '0', '0', '1528009951', '1529648650');
INSERT INTO `yf_hf_follow` VALUES ('775', '570', '7524', '1', '0', '0', '1528009971', '1528009971');
INSERT INTO `yf_hf_follow` VALUES ('776', '570', '8151', '1', '0', '0', '1528009975', '1529648292');
INSERT INTO `yf_hf_follow` VALUES ('777', '570', '7525', '1', '0', '0', '1528009978', '1528009978');
INSERT INTO `yf_hf_follow` VALUES ('778', '570', '7799', '1', '0', '0', '1528009983', '1528009983');
INSERT INTO `yf_hf_follow` VALUES ('784', '521', '449', '0', '0', '1', '1528011345', '1528011345');
INSERT INTO `yf_hf_follow` VALUES ('785', '521', '570', '0', '0', '1', '1528011351', '1528011351');
INSERT INTO `yf_hf_follow` VALUES ('786', '522', '449', '0', '0', '1', '1528011355', '1531476535');
INSERT INTO `yf_hf_follow` VALUES ('787', '521', '522', '0', '0', '0', '1528011391', '1528011391');
INSERT INTO `yf_hf_follow` VALUES ('788', '449', '521', '0', '0', '0', '1528011532', '1530253077');
INSERT INTO `yf_hf_follow` VALUES ('789', '522', '521', '0', '1', '1', '1528011583', '1528011583');
INSERT INTO `yf_hf_follow` VALUES ('790', '473', '570', '0', '0', '1', '1528012165', '1528012165');
INSERT INTO `yf_hf_follow` VALUES ('791', '473', '449', '0', '0', '1', '1528012256', '1528012256');
INSERT INTO `yf_hf_follow` VALUES ('793', '514', '7524', '1', '0', '0', '1528014323', '1528014323');
INSERT INTO `yf_hf_follow` VALUES ('796', '517', '449', '0', '0', '0', '1528015055', '1528015055');
INSERT INTO `yf_hf_follow` VALUES ('798', '517', '7429', '1', '0', '0', '1528015132', '1528015132');
INSERT INTO `yf_hf_follow` VALUES ('816', '1594', '18777', '1', '0', '0', '1528015837', '1528015837');
INSERT INTO `yf_hf_follow` VALUES ('817', '2012', '18777', '1', '0', '0', '1528015837', '1528015837');
INSERT INTO `yf_hf_follow` VALUES ('818', '1167', '18777', '1', '0', '0', '1528015837', '1528015837');
INSERT INTO `yf_hf_follow` VALUES ('819', '1148', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('820', '1253', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('821', '1801', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('822', '1372', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('823', '1105', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('824', '1768', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('825', '852', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('826', '1605', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('827', '995', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('828', '1859', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('829', '1690', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('830', '917', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('831', '2019', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('832', '1642', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('833', '1504', '18777', '1', '0', '0', '1528015838', '1528015838');
INSERT INTO `yf_hf_follow` VALUES ('835', '586', '520', '0', '0', '0', '1528018179', '1528018257');
INSERT INTO `yf_hf_follow` VALUES ('838', '586', '473', '0', '0', '1', '1528018225', '1528018258');
INSERT INTO `yf_hf_follow` VALUES ('841', '586', '460', '0', '0', '1', '1528018252', '1528018252');
INSERT INTO `yf_hf_follow` VALUES ('842', '586', '224', '0', '0', '1', '1528018257', '1528018257');
INSERT INTO `yf_hf_follow` VALUES ('843', '586', '522', '0', '0', '1', '1528018264', '1528018264');
INSERT INTO `yf_hf_follow` VALUES ('844', '586', '514', '0', '0', '0', '1528018266', '1528018266');
INSERT INTO `yf_hf_follow` VALUES ('845', '586', '588', '0', '0', '1', '1528018268', '1528018268');
INSERT INTO `yf_hf_follow` VALUES ('846', '586', '589', '0', '0', '1', '1528018271', '1528018271');
INSERT INTO `yf_hf_follow` VALUES ('847', '586', '597', '0', '0', '0', '1528018288', '1528018288');
INSERT INTO `yf_hf_follow` VALUES ('848', '586', '521', '0', '0', '0', '1528018290', '1528018290');
INSERT INTO `yf_hf_follow` VALUES ('849', '586', '7429', '1', '0', '1', '1528018309', '1528018309');
INSERT INTO `yf_hf_follow` VALUES ('850', '586', '449', '0', '0', '1', '1528018314', '1528018314');
INSERT INTO `yf_hf_follow` VALUES ('853', '586', '517', '0', '0', '0', '1528018455', '1528018455');
INSERT INTO `yf_hf_follow` VALUES ('854', '516', '449', '0', '0', '1', '1528019196', '1528019196');
INSERT INTO `yf_hf_follow` VALUES ('856', '514', '473', '0', '0', '1', '1528020134', '1528020134');
INSERT INTO `yf_hf_follow` VALUES ('859', '514', '570', '0', '0', '1', '1528020798', '1528020798');

-- ----------------------------
-- Table structure for yf_hf_imgs
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_imgs`;
CREATE TABLE `yf_hf_imgs` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` int(11) DEFAULT NULL COMMENT '用户id编号',
  `video_id` int(11) DEFAULT NULL COMMENT '视频id：-1为头像 0或其他为户型图',
  `img_type` int(11) DEFAULT NULL COMMENT '图片类型:1头像，2发布视频户型图',
  `image_name` varchar(200) DEFAULT NULL COMMENT '图片名称',
  `tmp_name` varchar(200) DEFAULT NULL COMMENT '临时名',
  `session_id` varchar(200) DEFAULT NULL COMMENT '临时图片',
  `rank` int(11) DEFAULT NULL COMMENT '排序号',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_time` datetime DEFAULT NULL COMMENT '修改日期',
  PRIMARY KEY (`id`),
  KEY `FK_Reference_3` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1922 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='图片';

-- ----------------------------
-- Records of yf_hf_imgs
-- ----------------------------
INSERT INTO `yf_hf_imgs` VALUES ('1917', '449', '782', '2', '6afc2a047d4eb97ca3a279ae15ffa67e.jpg', '6afc2a047d4eb97ca3a279ae15ffa67e.jpg', '0', null, '2018-06-05 18:03:47', '2018-06-05 18:03:49');
INSERT INTO `yf_hf_imgs` VALUES ('1918', '2121', '790', '2', '8a9492a6dd5823f765d69fcf08f4065a.jpg', '8a9492a6dd5823f765d69fcf08f4065a.jpg', '0', null, '2018-06-05 21:31:53', '2018-06-05 21:31:54');
INSERT INTO `yf_hf_imgs` VALUES ('1919', '2145', '813', '2', '4ac5c06ea2aca41ccd61a86dc98ced53.jpg', '4ac5c06ea2aca41ccd61a86dc98ced53.jpg', '0', null, '2018-06-06 14:23:44', '2018-06-06 14:23:47');
INSERT INTO `yf_hf_imgs` VALUES ('1920', '2189', '842', '2', 'a5ecdaa6b56fde3760eb73b8656b256d.jpg', 'a5ecdaa6b56fde3760eb73b8656b256d.jpg', '0', null, '2018-06-07 14:48:59', '2018-06-07 14:48:59');
INSERT INTO `yf_hf_imgs` VALUES ('1921', '2189', '842', '2', '829ad9ee783f9e1c35053e5686331366.jpg', '829ad9ee783f9e1c35053e5686331366.jpg', '0', null, '2018-06-07 14:49:50', '2018-06-07 14:49:50');

-- ----------------------------
-- Table structure for yf_hf_label
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_label`;
CREATE TABLE `yf_hf_label` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '标签id',
  `label_name` varchar(255) DEFAULT NULL COMMENT '标签名称',
  `sort` tinyint(3) DEFAULT NULL COMMENT '排序',
  `create_time` int(10) DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_label
-- ----------------------------
INSERT INTO `yf_hf_label` VALUES ('1', '业主', '3', '1524827956', '1524827956');
INSERT INTO `yf_hf_label` VALUES ('2', '经纪人', '4', '1524836954', '1524836954');
INSERT INTO `yf_hf_label` VALUES ('3', '买房者', '2', '1524836965', '1524836965');
INSERT INTO `yf_hf_label` VALUES ('4', '租房者', '1', '1524836976', '1524836976');

-- ----------------------------
-- Table structure for yf_hf_lookthrough
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_lookthrough`;
CREATE TABLE `yf_hf_lookthrough` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '浏览表',
  `member_id` int(11) DEFAULT NULL COMMENT '用户id',
  `video_id` int(11) DEFAULT NULL COMMENT '视频id',
  `real_time` int(11) DEFAULT NULL COMMENT '真实时间',
  `create_time` int(11) DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13819 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_lookthrough
-- ----------------------------
INSERT INTO `yf_hf_lookthrough` VALUES ('1', '578', '937', '1529479874', '1529479874', '1529479874');
INSERT INTO `yf_hf_lookthrough` VALUES ('2', '578', '937', '1529479893', '1529479893', '1529479893');
INSERT INTO `yf_hf_lookthrough` VALUES ('3', '2054', '937', '1529479910', '1529479910', '1529479910');
INSERT INTO `yf_hf_lookthrough` VALUES ('4', '578', '937', '1529479920', '1529479920', '1529479920');
INSERT INTO `yf_hf_lookthrough` VALUES ('5', '2054', '937', '1529480044', '1529480044', '1529480044');
INSERT INTO `yf_hf_lookthrough` VALUES ('6', '570', '933', '1529480110', '1529480110', '1529480110');
INSERT INTO `yf_hf_lookthrough` VALUES ('7', '570', '933', '1529480165', '1529480165', '1529480165');
INSERT INTO `yf_hf_lookthrough` VALUES ('8', '575', '933', '1529480167', '1529480167', '1529480167');
INSERT INTO `yf_hf_lookthrough` VALUES ('9', '575', '933', '1529480267', '1529480267', '1529480267');
INSERT INTO `yf_hf_lookthrough` VALUES ('10', '2184', '933', '1529480334', '1529480334', '1529480334');
INSERT INTO `yf_hf_lookthrough` VALUES ('11', '2184', '931', '1529480337', '1529480337', '1529480337');
INSERT INTO `yf_hf_lookthrough` VALUES ('12', '2184', '933', '1529480338', '1529480338', '1529480338');
INSERT INTO `yf_hf_lookthrough` VALUES ('13', '2184', '931', '1529480338', '1529480338', '1529480338');
INSERT INTO `yf_hf_lookthrough` VALUES ('14', '570', '931', '1529480346', '1529480346', '1529480346');
INSERT INTO `yf_hf_lookthrough` VALUES ('15', '570', '923', '1529480346', '1529480346', '1529480346');
INSERT INTO `yf_hf_lookthrough` VALUES ('16', '570', '922', '1529480347', '1529480347', '1529480347');
INSERT INTO `yf_hf_lookthrough` VALUES ('17', '570', '921', '1529480348', '1529480348', '1529480348');
INSERT INTO `yf_hf_lookthrough` VALUES ('18', '570', '920', '1529480348', '1529480348', '1529480348');
INSERT INTO `yf_hf_lookthrough` VALUES ('19', '570', '918', '1529480349', '1529480349', '1529480349');
INSERT INTO `yf_hf_lookthrough` VALUES ('20', '570', '917', '1529480350', '1529480350', '1529480350');
INSERT INTO `yf_hf_lookthrough` VALUES ('21', '570', '916', '1529480350', '1529480350', '1529480350');
INSERT INTO `yf_hf_lookthrough` VALUES ('22', '570', '914', '1529480351', '1529480351', '1529480351');
INSERT INTO `yf_hf_lookthrough` VALUES ('23', '570', '914', '1529480352', '1529480352', '1529480352');
INSERT INTO `yf_hf_lookthrough` VALUES ('24', '570', '909', '1529480352', '1529480352', '1529480352');
INSERT INTO `yf_hf_lookthrough` VALUES ('25', '570', '906', '1529480353', '1529480353', '1529480353');
INSERT INTO `yf_hf_lookthrough` VALUES ('26', '570', '904', '1529480354', '1529480354', '1529480354');
INSERT INTO `yf_hf_lookthrough` VALUES ('27', '570', '903', '1529480354', '1529480354', '1529480354');
INSERT INTO `yf_hf_lookthrough` VALUES ('28', '570', '902', '1529480355', '1529480355', '1529480355');
INSERT INTO `yf_hf_lookthrough` VALUES ('29', '521', '937', '1529480365', '1529480365', '1529480365');
INSERT INTO `yf_hf_lookthrough` VALUES ('30', '521', '937', '1529480587', '1529480587', '1529480587');
INSERT INTO `yf_hf_lookthrough` VALUES ('31', '521', '939', '1529480590', '1529480590', '1529480590');
INSERT INTO `yf_hf_lookthrough` VALUES ('32', '521', '937', '1529480600', '1529480600', '1529480600');
INSERT INTO `yf_hf_lookthrough` VALUES ('33', '2059', '933', '1529480601', '1529480601', '1529480601');
INSERT INTO `yf_hf_lookthrough` VALUES ('34', '521', '936', '1529480603', '1529480603', '1529480603');
INSERT INTO `yf_hf_lookthrough` VALUES ('35', '2059', '931', '1529480606', '1529480606', '1529480606');
INSERT INTO `yf_hf_lookthrough` VALUES ('36', '2059', '933', '1529480610', '1529480610', '1529480610');
INSERT INTO `yf_hf_lookthrough` VALUES ('37', '2059', '931', '1529480611', '1529480611', '1529480611');
INSERT INTO `yf_hf_lookthrough` VALUES ('38', '2059', '923', '1529480611', '1529480611', '1529480611');
INSERT INTO `yf_hf_lookthrough` VALUES ('39', '521', '936', '1529480620', '1529480620', '1529480620');
INSERT INTO `yf_hf_lookthrough` VALUES ('40', '521', '939', '1529480621', '1529480621', '1529480621');
INSERT INTO `yf_hf_lookthrough` VALUES ('41', '521', '939', '1529480622', '1529480622', '1529480622');
INSERT INTO `yf_hf_lookthrough` VALUES ('42', '2059', '922', '1529480624', '1529480624', '1529480624');
INSERT INTO `yf_hf_lookthrough` VALUES ('43', '2059', '921', '1529480627', '1529480627', '1529480627');
INSERT INTO `yf_hf_lookthrough` VALUES ('44', '521', '936', '1529480630', '1529480630', '1529480630');
INSERT INTO `yf_hf_lookthrough` VALUES ('45', '521', '936', '1529480644', '1529480644', '1529480644');
INSERT INTO `yf_hf_lookthrough` VALUES ('46', '521', '939', '1529480647', '1529480647', '1529480647');
INSERT INTO `yf_hf_lookthrough` VALUES ('47', '521', '939', '1529480662', '1529480662', '1529480662');
INSERT INTO `yf_hf_lookthrough` VALUES ('48', '521', '939', '1529480674', '1529480674', '1529480674');
INSERT INTO `yf_hf_lookthrough` VALUES ('49', '521', '936', '1529480722', '1529480722', '1529480722');
INSERT INTO `yf_hf_lookthrough` VALUES ('50', '521', '936', '1529480723', '1529480723', '1529480723');
INSERT INTO `yf_hf_lookthrough` VALUES ('51', '521', '936', '1529480725', '1529480725', '1529480725');
INSERT INTO `yf_hf_lookthrough` VALUES ('52', '521', '936', '1529480727', '1529480727', '1529480727');
INSERT INTO `yf_hf_lookthrough` VALUES ('53', '521', '936', '1529480727', '1529480727', '1529480727');
INSERT INTO `yf_hf_lookthrough` VALUES ('54', '521', '936', '1529480728', '1529480728', '1529480728');
INSERT INTO `yf_hf_lookthrough` VALUES ('55', '521', '936', '1529480732', '1529480732', '1529480732');
INSERT INTO `yf_hf_lookthrough` VALUES ('56', '521', '936', '1529480733', '1529480733', '1529480733');
INSERT INTO `yf_hf_lookthrough` VALUES ('57', '521', '936', '1529480735', '1529480735', '1529480735');
INSERT INTO `yf_hf_lookthrough` VALUES ('58', '521', '936', '1529480747', '1529480747', '1529480747');
INSERT INTO `yf_hf_lookthrough` VALUES ('59', '521', '939', '1529480751', '1529480751', '1529480751');
INSERT INTO `yf_hf_lookthrough` VALUES ('60', '521', '939', '1529481013', '1529481013', '1529481013');
INSERT INTO `yf_hf_lookthrough` VALUES ('61', '2184', '931', '1529481044', '1529481044', '1529481044');
INSERT INTO `yf_hf_lookthrough` VALUES ('62', '2184', '931', '1529481044', '1529481044', '1529481044');
INSERT INTO `yf_hf_lookthrough` VALUES ('63', '2184', '923', '1529481054', '1529481054', '1529481054');
INSERT INTO `yf_hf_lookthrough` VALUES ('64', '2184', '931', '1529481055', '1529481055', '1529481055');
INSERT INTO `yf_hf_lookthrough` VALUES ('65', '575', '939', '1529481146', '1529481146', '1529481146');
INSERT INTO `yf_hf_lookthrough` VALUES ('66', '2184', '939', '1529481179', '1529481179', '1529481179');
INSERT INTO `yf_hf_lookthrough` VALUES ('67', '2184', '939', '1529481196', '1529481196', '1529481196');
INSERT INTO `yf_hf_lookthrough` VALUES ('68', '2184', '935', '1529481197', '1529481197', '1529481197');
INSERT INTO `yf_hf_lookthrough` VALUES ('69', '2184', '939', '1529481198', '1529481198', '1529481198');
INSERT INTO `yf_hf_lookthrough` VALUES ('70', '2184', '939', '1529481200', '1529481200', '1529481200');
INSERT INTO `yf_hf_lookthrough` VALUES ('71', '2184', '935', '1529481201', '1529481201', '1529481201');
INSERT INTO `yf_hf_lookthrough` VALUES ('72', '2184', '933', '1529481202', '1529481202', '1529481202');
INSERT INTO `yf_hf_lookthrough` VALUES ('73', '2184', '935', '1529481203', '1529481203', '1529481203');
INSERT INTO `yf_hf_lookthrough` VALUES ('74', '2184', '939', '1529481205', '1529481205', '1529481205');
INSERT INTO `yf_hf_lookthrough` VALUES ('75', '2184', '939', '1529481206', '1529481206', '1529481206');
INSERT INTO `yf_hf_lookthrough` VALUES ('76', '575', '939', '1529481225', '1529481225', '1529481225');
INSERT INTO `yf_hf_lookthrough` VALUES ('77', '2184', '935', '1529481247', '1529481247', '1529481247');
INSERT INTO `yf_hf_lookthrough` VALUES ('78', '2184', '933', '1529481249', '1529481249', '1529481249');
INSERT INTO `yf_hf_lookthrough` VALUES ('79', '2184', '935', '1529481249', '1529481249', '1529481249');
INSERT INTO `yf_hf_lookthrough` VALUES ('80', '2184', '935', '1529481268', '1529481268', '1529481268');
INSERT INTO `yf_hf_lookthrough` VALUES ('81', '2184', '935', '1529481268', '1529481268', '1529481268');
INSERT INTO `yf_hf_lookthrough` VALUES ('82', '2184', '935', '1529481268', '1529481268', '1529481268');
INSERT INTO `yf_hf_lookthrough` VALUES ('83', '2184', '935', '1529481268', '1529481268', '1529481268');
INSERT INTO `yf_hf_lookthrough` VALUES ('84', '568', '939', '1529481277', '1529481277', '1529481277');
INSERT INTO `yf_hf_lookthrough` VALUES ('85', '2184', '940', '1529481280', '1529481280', '1529481280');
INSERT INTO `yf_hf_lookthrough` VALUES ('86', '568', '940', '1529481281', '1529481281', '1529481281');
INSERT INTO `yf_hf_lookthrough` VALUES ('87', '568', '940', '1529481286', '1529481286', '1529481286');
INSERT INTO `yf_hf_lookthrough` VALUES ('88', '2184', '935', '1529481286', '1529481286', '1529481286');
INSERT INTO `yf_hf_lookthrough` VALUES ('89', '2184', '939', '1529481299', '1529481299', '1529481299');
INSERT INTO `yf_hf_lookthrough` VALUES ('90', '2184', '933', '1529481301', '1529481301', '1529481301');
INSERT INTO `yf_hf_lookthrough` VALUES ('91', '2054', '936', '1529481303', '1529481303', '1529481303');
INSERT INTO `yf_hf_lookthrough` VALUES ('92', '2184', '939', '1529481303', '1529481303', '1529481303');
INSERT INTO `yf_hf_lookthrough` VALUES ('93', '2184', '940', '1529481304', '1529481304', '1529481304');
INSERT INTO `yf_hf_lookthrough` VALUES ('94', '2184', '940', '1529481305', '1529481305', '1529481305');
INSERT INTO `yf_hf_lookthrough` VALUES ('95', '2184', '939', '1529481307', '1529481307', '1529481307');
INSERT INTO `yf_hf_lookthrough` VALUES ('96', '2184', '935', '1529481308', '1529481308', '1529481308');
INSERT INTO `yf_hf_lookthrough` VALUES ('97', '2184', '940', '1529481313', '1529481313', '1529481313');
INSERT INTO `yf_hf_lookthrough` VALUES ('98', '2054', '936', '1529481318', '1529481318', '1529481318');
INSERT INTO `yf_hf_lookthrough` VALUES ('99', '2054', '930', '1529481323', '1529481323', '1529481323');
INSERT INTO `yf_hf_lookthrough` VALUES ('100', '2054', '928', '1529481325', '1529481325', '1529481325');

-- ----------------------------
-- Table structure for yf_hf_member
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_member`;
CREATE TABLE `yf_hf_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `openid` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '普通app用户openid',
  `unionid` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。',
  `hiid` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '0' COMMENT '嗨id',
  `is_power` tinyint(1) NOT NULL DEFAULT '0' COMMENT '权限：0没有权限，1有权限',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '普通用户昵称',
  `sex` tinyint(4) NOT NULL DEFAULT '0' COMMENT '普通用户性别，1为男性，2为女性',
  `birthday` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '0' COMMENT '出生年月',
  `province` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '普通用户个人资料填写的省份',
  `city` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '普通用户个人资料填写的城市',
  `country` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '国家，如中国为CN',
  `headimgurl` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空',
  `label` tinyint(1) NOT NULL DEFAULT '4' COMMENT '用户标签: 1:业主 2经纪人 3买房者 4租房者',
  `area_id` int(11) NOT NULL DEFAULT '0' COMMENT '业务区域,只有经纪人标签才有,其他标签默认为0',
  `privilege` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '用户特权信息，json数组，如微信沃卡用户为（chinaunicom）',
  `phone` varchar(20) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '手机号',
  `use_wechat_headimg` int(10) DEFAULT '0' COMMENT '是0否1使用微信头像',
  `app_version` varchar(20) CHARACTER SET utf8 DEFAULT '' COMMENT '用户当前版本',
  `sign` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '个性签名',
  `num_follow` int(10) DEFAULT '0' COMMENT '粉丝数',
  `num_publish` int(11) DEFAULT '0' COMMENT '发布数',
  `num_good_video` int(11) DEFAULT '0' COMMENT '点赞视频数',
  `num_buildings` int(11) DEFAULT '0' COMMENT '关注小区数',
  `num_prise` int(11) DEFAULT '0' COMMENT '获赞',
  `num_member` int(11) DEFAULT '0' COMMENT '关注人数',
  `balance` int(11) DEFAULT '0' COMMENT '钱包余额',
  `invite_code` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '本用户邀请码',
  `invite_from_id` int(10) DEFAULT '0' COMMENT '发起邀请人id',
  `app_key` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT 'app_key',
  `logout_timestamp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '退出系统时间戳，用于查询离线消息',
  `status` enum('online','offline') CHARACTER SET utf8 NOT NULL DEFAULT 'offline' COMMENT '在线状态，在线或者离线',
  `is_robot` tinyint(4) DEFAULT '0',
  `create_time` int(10) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(10) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2258 DEFAULT CHARSET=utf8mb4 COMMENT='会员表';

-- ----------------------------
-- Records of yf_hf_member
-- ----------------------------
INSERT INTO `yf_hf_member` VALUES ('225', 'oxR0M1IkP5kel7DWi7W-nn-3e9hw', '0', '633804352', '0', '', '1', '0', 'Shanghai', '', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/mUjv4zYCJiaMZdJcJEpEm3Q1MYOiboiahEuZorobPFwstjsvZuwgpYRl8m7IE9gybOgQROXAq0fH8AhHE3GiacRdLw/132', '2', '0', '', '', '0', null, '个性签名', '0', '0', '0', '0', '0', '0', '0', null, '0', 'b054014693241bcd9c20', '1525413236', 'offline', '0', '1525340833', '1526119563');
INSERT INTO `yf_hf_member` VALUES ('445', '', '0', '2147483646', '0', '马冬梅', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '2', '0', '', '13419959203', '0', '1.1.2', null, '2', '0', '0', '0', '0', '2', '0', '0000XX', '473', 'b054014693241bcd9c20', '1525665160', 'online', '0', null, '1531191149');
INSERT INTO `yf_hf_member` VALUES ('449', '12345678900', '12', '2147483647', '1', '张翠山', '1', '2018-05-31', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJF2YJjW11KZ4NtibGWKG8QElHRONZMQd0LzMMoZYJnY7tmnK6KWaBibIl1wvvgbliaAqAWyDSVxqNOA/132', '2', '5', '', '12345678900', '0', '1.0.0', '闵行', '20', '1', '13', '8', '14', '18', '469', null, '0', 'b054014693241bcd9c20', '1531461871', 'offline', '0', null, '1531480296');
INSERT INTO `yf_hf_member` VALUES ('470', '', '0', '454342062', '0', '专一打高跟鞋', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '5', '', '13869472561', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000NP', '0', '', '0', 'offline', '0', null, '1526225546');
INSERT INTO `yf_hf_member` VALUES ('473', '', 'oNOSMwTnJOgPESltzC73X-Md9h-E', '2147483647', '1', '我不再胡闹', '1', '1995-06-04', '山东', '枣庄', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJfic3yUNdDhjwVIvn64GKOLQKg3NtuOSwQYGsz6dudFRVMiak1sBD76AaUSwgMBgBZyZPibluSBoBVg/132', '2', '0', '', '18616812914', '0', '1.0.0', null, '34', '1', '4', '1', '13', '15', '1036', '666666', '512', '', '1528682037', 'offline', '0', '1526281006', '1531813882');
INSERT INTO `yf_hf_member` VALUES ('512', '', '', '9462446362', '0', '苹果给火', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '5', '', '13869472554', '0', '1.0.0', null, '8', '0', '0', '0', '0', '8', '376', '0000OU', '0', '', '0', 'offline', '0', '1526364426', '1528271584');
INSERT INTO `yf_hf_member` VALUES ('513', '', '', '1185976362', '1', '老衲洗发用飘柔', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '234', '', '15618226393', '0', '1.0.0', null, '5', '0', '0', '2', '0', '2', '7', '0000OV', '0', '', '1528100930', 'offline', '0', '1526367958', '1531813650');
INSERT INTO `yf_hf_member` VALUES ('514', '', '', '2555586362', '1', 'nothing', '2', '2015-06-04', '', '', '', '/uploads/picture/default/default-logo.png', '1', '586', '', '17638103673', '0', '1.0.0', null, '14', '8', '5', '4', '1', '15', '20', '0000O6', '473', '', '1528434553', 'online', '0', '1526368555', '1531186780');
INSERT INTO `yf_hf_member` VALUES ('515', '', '', '7259686362', '0', 'songjian', '1', '1993-06-07', '', '', '', '/uploads/picture/default/default-logo.png', '1', '234', '', '18616812914', '0', '1.0.0', '此时此刻我想吟诗一首', '7', '0', '1', '0', '0', '0', '86', '0000O7', '0', '', '1528421828', 'offline', '0', '1526368695', '1529656425');
INSERT INTO `yf_hf_member` VALUES ('516', '', '', '8649107362', '1', '默默', '2', '2018-05-18', '', '', '', '/uploads/picture/default/default-logo.png', '0', '234', '', '18516014525', '0', '1.1.0', '密码是0123456', '7', '0', '24', '2', '0', '2', '30', '0000OM', '0', '', '1528440715', 'online', '0', '1526370194', '1528468529');
INSERT INTO `yf_hf_member` VALUES ('517', 'oxR0M1CpHVyqYvRJ-RHXdaeCv4bs', 'oNOSMwZyP3FiWajgnXZUNNy-zqhY', '5895727362', '1', '彼岸浮灯', '1', '1990-07-28', 'Firenze', '', 'IT', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJF2YJjW11KZ4NtibGWKG8QElHRONZMQd0LzMMoZYJnY7tmnK6KWaBibIl1wvvgbliaAqAWyDSVxqNOA/132', '4', '585', '', '17319066282', '0', '1.1.0', '岁月如长河无尽，沧海也变成桑田', '8', '0', '7', '1', '0', '1', '38', '0000OW', '0', '', '1528012728', 'online', '0', '1526372759', '1529648591');
INSERT INTO `yf_hf_member` VALUES ('518', '', '', '06684325', '0', '幽默迎可乐', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '578', '', '15216883795', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000OX', '0', '', '0', 'offline', '0', '1526523486', '1529648600');
INSERT INTO `yf_hf_member` VALUES ('519', '', '', '27332425', '0', '聪慧迎白云', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '5', '', '13419959201', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000O8', '0', '', '0', 'offline', '0', '1526524233', '1529648604');
INSERT INTO `yf_hf_member` VALUES ('520', '', '', '02621925', '1', '宋江', '1', '0', '', '', '', '/uploads/picture/default/default-logo.png', '2', '234', '', '17621859931', '0', '1.0.0', null, '5', '0', '0', '0', '0', '0', '200', '0000O9', '0', '', '0', 'offline', '0', '1526529126', '1529656422');
INSERT INTO `yf_hf_member` VALUES ('521', '', '', '87836645', '1', '小小', '1', '2017-05-31', '', '', '', '/uploads/picture/default/default-logo.png', '1', '578', '', '17717536290', '0', '1.1.3', '徽墨', '14', '0', '10', '9', '21', '12', '95', '0000OK', '0', '', '1531480487', 'offline', '0', '1526546638', '1531463685');
INSERT INTO `yf_hf_member` VALUES ('522', '', '', '25196645', '1', '追寻', '2', '2018-05-31', '', '', '', '/uploads/picture/default/default-logo.png', '1', '578', '', '17621970092', '0', '1.1.3', '一起源于热爱', '13', '0', '8', '9', '0', '21', '102', '0000OL', '0', '', '1531475516', 'offline', '0', '1526546691', '1531477091');
INSERT INTO `yf_hf_member` VALUES ('523', '', '', '18124316', '0', '测试结果', '0', '2015-05-29', '', '', '', '/uploads/picture/default/default-logo.png', '1', '234', '', '15601652352', '0', '1.0.0', '也uur jrh', '0', '0', '0', '0', '0', '0', '0', '0000OY', '0', '', '0', 'offline', '0', '1526613421', '1529648607');
INSERT INTO `yf_hf_member` VALUES ('561', '', '', '94955298', '0', '想人陪打绿茶', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '5', '', '18616800000', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000I5', '0', '', '0', 'offline', '0', '1526892559', '1529648611');
INSERT INTO `yf_hf_member` VALUES ('564', '', '', '88570398', '0', '昏睡演变店员', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '5', '', '18616800001', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000ID', '0', '', '0', 'offline', '0', '1526893075', '1529648650');
INSERT INTO `yf_hf_member` VALUES ('565', '', '', '87595398', '0', '彪壮演变鸭子', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '5', '', '18616800002', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IG', '0', '', '0', 'offline', '0', '1526893595', '1529648643');
INSERT INTO `yf_hf_member` VALUES ('566', 'oxR0M1HTb-8BGgZN6sMz7mOIlxRA', 'oNOSMwV9l7-StZPuo_0kC_PU-c64', '67231879', '1', 'D', '2', '2018-06-07', 'Fujian', 'Quanzhou', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIuqOuvZLWMJ2euic3BIjdIzibuMx94jZPf7GtJib3MWWc1ONNBfrZfeY8PbicvlHE6PnM5PiaWjXRvtAA/132', '4', '584', '', '18964231232', '0', '1.1.3', '哈尔滨', '7', '0', '4', '4', '0', '12', '49', '0000I3', '0', '', '1531465382', 'offline', '0', '1526978132', '1531476659');
INSERT INTO `yf_hf_member` VALUES ('567', 'oxR0M1EO-Od7O4Xqq_X3mYBtdAyQ', 'oNOSMwYbQUbUL8MDeLOTkOsZ8Xj8', '45902621', '1', '惊寒。', '1', '0', '上海', '徐汇', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/ERCGGnJdzA5YjTLruhaH8uEkyPtYib64E3PLJyJ5Jm0u1GbMELA7uibHicibDVjOXHyBJN8KmV9icbD74mbyRvjqsDA/132', '4', '0', '', '', '0', '1.0.0', null, '1', '0', '3', '3', '0', '4', '0', '0000IH', '0', '', '0', 'offline', '0', null, '1529648637');
INSERT INTO `yf_hf_member` VALUES ('568', 'oxR0M1BuynYtmu1-nFwKAfHRIx6U', 'oNOSMwUTZvsQ0X1frLqIYCSD5mCs', '48076721', '1', '逆', '1', '0', 'Shanghai', 'Xuhui', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKhkIick43GoVMqf1ibgjV4mq7WicSMNJwCbZC283aPlI4ichIbMxuPnJJ2RISP4S6aRY9D3icxlcWCicaA/132', '0', '1', '', '18101725237', '0', '1.1.2', null, '11', '1', '0', '2', '15', '9', '60', '0000IQ', '2243', '', '1530786947', 'offline', '0', '1527127670', '1530871078');
INSERT INTO `yf_hf_member` VALUES ('569', '', 'oNOSMwZR4IcL3aeG_CirSw2cS7Wc', '15261242', '0', '离水的 ', '2', '0', '上海', '', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/8icfELo600aEeXpEic6AxoqS9GAzjCl037N9ctU2ribYo12LyiaVoymrrePE3Bx3JqG0Z26CtpS42tBZyFy0GZZPkw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '0', null, '1529648629');
INSERT INTO `yf_hf_member` VALUES ('570', 'oxR0M1AJHLjrlEGToTUHVSZjJqEM', 'oNOSMwWan2m4Tgif6WuUyhoaBEvU', '44691242', '1', '昔日流年', '0', '0', '安徽', '安庆', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLPiaj14cVKiaicR89ib7ictFMcyehU8hyWtZuLpRmxVxslwCsNzUejOzyel4lAWqJWcB9CXYpktz8sbEQ/132', '4', '0', '', '15821759915', '0', '1.0.0', null, '27', '0', '10', '2', '22', '14', '51', '0000I4', '2243', '', '1531200081', 'offline', '0', null, '1531478249');
INSERT INTO `yf_hf_member` VALUES ('571', 'oxR0M1AYQU8OhNUwjbBm8eVnBCXY', 'oNOSMwT_PLrSdYxAuIbUq1kR5mJE', '06613062', '1', 'a施海彦《同联商业》《福居好房》', '0', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqTKJsGHIZ6Y0CmVIGGT6BV4FqVO3PvmibvKI7JlvrkaRPwNfFIc7Dk3HGibZmniaSia0jYNu3blga9CA/132', '4', '576', '', '13482498882', '0', '1.0.0', null, '3', '0', '0', '1', '0', '0', '2', '0000IB', '0', '', '0', 'offline', '0', '1527260316', '1529648626');
INSERT INTO `yf_hf_member` VALUES ('572', 'oxR0M1HBAIActyJ3E_Xk89zQjz0I', 'oNOSMwYzD5vNr0gW1PjOAnLmIPTg', '87393062', '1', '许正', '1', '0', 'Shanghai', 'Changning', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTICOAdU4ZDNQiaGcFxiaVUXc6GfAgH3oQV2L8r1cqzA0a5y4CuMZzLRDNvy3nrhySm86GiaevGsWQCcw/132', '4', '585', '', '15502198310', '0', '1.1.0', null, '1', '0', '1', '1', '0', '1', '0', '0000I1', '0', '', '0', 'offline', '0', '1527260393', '1529648621');
INSERT INTO `yf_hf_member` VALUES ('573', 'oxR0M1PvPQ-QuliUlewIbxta7Gtk', 'oNOSMwd34L78Y4s3wYWT1jzZ_Vl4', '01504062', '1', 'JasonXu', '1', '1990-06-11', 'Shanghai', 'Pudong New District', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLmKFb7tzySXmJic6IORtXyFrTBM5za47xNo5Gr3CDgVfyaFia87vVQESpWzWT17fefeYiccRTz25jIg/132', '3', '588', '', '18516014515', '0', '1.1.0', null, '0', '0', '4', '0', '0', '1', '0', '0000IN', '0', '', '0', 'offline', '0', '1527260405', '1529648618');
INSERT INTO `yf_hf_member` VALUES ('574', '', '', '86030883', '1', '疯狂方菠萝', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '85', '', '18101725237', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IO', '0', '', '0', 'offline', '0', '1527388030', '1528271566');
INSERT INTO `yf_hf_member` VALUES ('575', 'oxR0M1IkP5kel7DWi7W-nn-3e9hw', 'oNOSMwe8BzWCjGaH_Y1unNcBr1J4', '48232594', '1', '呵呵哒', '1', '2018-06-11', 'Shanghai', '', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/mUjv4zYCJiaMZdJcJEpEm3Q1MYOiboiahEuZorobPFwstjsvZuwgpYRl8m7IE9gybOgQROXAq0fH8AhHE3GiacRdLw/132', '2', '593', '', '18516014520', '0', '1.0.0', '我是签名设计师', '10', '4', '23', '17', '2', '17', '5', '0000IP', '0', '', '1531389392', 'offline', '0', '1527495232', '1531465950');
INSERT INTO `yf_hf_member` VALUES ('576', '', '', '74890946', '0', '树叶迷路', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '2', '0', '', '18516014528', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000II', '0', '', '0', 'offline', '0', '1527649098', '1527649098');
INSERT INTO `yf_hf_member` VALUES ('577', 'oxR0M1IeTE15QrOb5kXIuPcAAhsg', 'oNOSMwex6-HunICmoXTr0aWw6jzg', '59919656', '0', 'Agping', '2', '0', '河南', '信阳', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/AzicNNoeYZgWEFR8rEB3GBbSKN49nkMzDicMM5t3yzJ7iaFTR4cUChwWB1cPEUGqSulOIJrGicESZT64hvS7AgYM2g/132', '4', '0', '', '', '0', '1.0.0', null, '0', '0', '1', '0', '0', '2', '2', '0000IJ', '0', '', '1528322957', 'offline', '0', null, '1528682020');
INSERT INTO `yf_hf_member` VALUES ('578', 'oxR0M1MLdoqwhSMyzOndrt4rDT1A', 'oNOSMwR6bRhGUR0zY9d2-Vt4aT3E', '68191766', '0', '曾啊牛', '1', '0', '上海', '浦东新区', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLqeib8OfVoRA0Y70YbMsQ8I4wvVIC3ccEgwtJfC5icpEZhgbekLIwicbFCBcCk0bxYG7s6LoNdIndUA/132', '4', '0', '', '', '0', '1.1.0', null, '1', '0', '1', '0', '0', '1', '0', '0000I2', '0', '', '1528685472', 'offline', '0', null, '1529476714');
INSERT INTO `yf_hf_member` VALUES ('579', 'oxR0M1FT0w9vy-_mOfSnTvTX0cWA', 'oNOSMwXeZI94STyuahcL8lMAKJ9I', '91332766', '1', 'coco—哆啦', '2', '0', '河南', '郑州', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLX8ole5k6gIf7hlliaGb3ZzFBD4TPkc98SnGRR9kfd5d7Aj1mtlHhsFg2EWA6tNrc8PrYxXZbnhPA/132', '4', '0', '', '17638103673', '0', '1.0.0', null, '11', '0', '5', '2', '29', '9', '23', '0000IR', '517', '', '1531731960', 'offline', '0', null, '1531123922');
INSERT INTO `yf_hf_member` VALUES ('580', 'oxR0M1JNfFBy04p5taTnnPnQVLFY', 'oNOSMwV_MHF3VqFJU32jEaPqURJA', '27912866', '1', 'luna', '2', '0', '', '', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/4MjEPyUh1Bq4q6ib1TTEY39E3eBBS7RZQxF9IHJctYpTJo1H8YfichRdBSkaI81v6FdtpgicpI3MUcWDZ1K4PImrQ/132', '4', '585', '', '', '0', '1.0.0', null, '5', '0', '0', '2', '3', '5', '0', '0000IS', '0', '', '1530495805', 'offline', '0', '1527668219', '1530855913');
INSERT INTO `yf_hf_member` VALUES ('581', 'oxR0M1HaCzkqakEZRGRf4TmXoPRk', 'oNOSMwdE1y9iJDiP3ZkF52FVZJ68', '05143776', '1', 'sosence', '1', '0', 'Shanghai', 'Changning', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83epOJBffbo5iaadD28aYlwJJv1jWYoXNuJsXDND5E6ug1fX8A4k3HsyhNxdstrdoUqKrarYkCPC5LPg/132', '3', '577', '', '15216883796', '0', '1.0.0', null, '6', '0', '0', '1', '0', '2', '0', '0000IT', '0', '', '1528773396', 'offline', '0', '1527677341', '1530240007');
INSERT INTO `yf_hf_member` VALUES ('582', '', '', '99435776', '0', '友好爱银耳汤', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '2', '0', '', '15601652351', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IU', '0', '', '0', 'offline', '0', '1527677534', '1527821625');
INSERT INTO `yf_hf_member` VALUES ('583', '', '', '14500037', '0', '活泼保卫蜜蜂', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '234', '', '13764803660', '0', '1.0.0', null, '1', '0', '0', '2', '0', '3', '0', '0000IV', '0', '', '1528342936', 'online', '0', '1527730005', '1528342784');
INSERT INTO `yf_hf_member` VALUES ('584', '', '', '81162547', '1', '雪碧能干', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '234', '', '15601655351', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000I6', '0', '', '0', 'offline', '0', '1527745261', '1527855082');
INSERT INTO `yf_hf_member` VALUES ('585', '', '', '96244157', '0', '勤奋和橘子', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '578', '', '15623562580', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000I7', '0', '', '0', 'offline', '0', '1527751442', '1527751827');
INSERT INTO `yf_hf_member` VALUES ('586', '', '', '88374357', '1', '有点甜', '2', '2018-06-05', '', '', '', '/uploads/picture/default/default-logo.png', '2', '0', '', '15612345678', '0', '1.0.0', '好多好多好', '5', '0', '3', '3', '0', '10', '46', '0000IM', '0', '', '1528018367', 'online', '0', '1527753473', '1528474237');
INSERT INTO `yf_hf_member` VALUES ('587', '', '', '94955357', '0', '呼呼', '1', '2016-06-03', '', '', '', '/uploads/picture/default/default-logo.png', '1', '578', '', '15612345688', '0', '1.0.0', '很好', '3', '0', '2', '0', '0', '0', '0', '0000IW', '0', '', '0', 'offline', '0', '1527753559', '1528081394');
INSERT INTO `yf_hf_member` VALUES ('588', '', '', '67740457', '1', '拼搏和小白菜', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '4', '0', '', '13636508937', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '5', '0000IX', '0', '', '0', 'offline', '0', '1527754047', '1528023062');
INSERT INTO `yf_hf_member` VALUES ('589', '', '', '27462757', '1', '壮观保卫发卡', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '4', '0', '', '13636508937', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '5', null, '0', '', '0', 'offline', '0', '1527757264', '1528271573');
INSERT INTO `yf_hf_member` VALUES ('597', '', '', '48219067', '1', '爱听歌心情', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png0', '4', '0', '', '15121118600', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '5', '0000JF', '0', '', '0', 'offline', '0', '1527760912', '1528271577');
INSERT INTO `yf_hf_member` VALUES ('598', 'oxR0M1HYOS8Q0FFTRn6fm_Ipps_c', 'oNOSMwXuaFGWhN8xORs8_vGcGCjI', '94183167', '1', '枷', '1', '2018-06-22', '', '', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Txy2JrK73zU0cqoxic7jiajGSudyqYLqSRslTShLXL7yKQ86xbmZywF1hWtF6cGXNB8KMgjO2LD9EA1LnGOkFOoQ/132', '2', '577', '', '17301850006', '0', '1.0.0', '开着拖拉机迎接冬天的到来', '3', '1', '3', '4', '8', '26', '3030', '0000JC', '0', '', '1529656357', 'offline', '0', '1527761381', '1529656899');
INSERT INTO `yf_hf_member` VALUES ('601', '', '', '47935738', '0', '西牛火星上', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '3', '234', '', '17621970093', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000J3', '0', '', '0', 'offline', '0', '1527837539', '1527837539');
INSERT INTO `yf_hf_member` VALUES ('602', '', '', '48717048', '0', '音响醉熏', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '3', '234', '', '17621970094', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000JH', '0', '', '0', 'offline', '0', '1527840717', '1527840717');
INSERT INTO `yf_hf_member` VALUES ('603', '', '', '18821148', '0', '小蚂蚁结实', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '581', '', '17621970095', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000JQ', '0', '', '0', 'offline', '0', '1527841128', '1527841128');
INSERT INTO `yf_hf_member` VALUES ('604', '', '', '77291148', '0', '怕黑给台灯', '0', '0', '', '', '', '/uploads/picture/default/default-logo.png', '1', '581', '', '17717536297', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000JA', '0', '', '0', 'offline', '0', '1527841192', '1527841192');
INSERT INTO `yf_hf_member` VALUES ('605', '', '', '84528203', '0', '阳光普照', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/I7r6G5lrb2dCCGsvWxvPoia1iaS3bESicC71xq6YZ7adbAsax2uJxlFO7KSGoGfQV6DibQdZRKEvKj5BZsM11aibT6A/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('606', '', '', '47747221', '0', '做快乐的自己', '2', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=FFc7kS8iaZ6TuXegc7WZibGQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '1', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('607', '', '', '72952052', '0', '残弦', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=Kk9sv1L08R5EgbHic3Dc6EA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '2', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('608', '', '', '30166439', '0', '酒是故乡醇', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=DHepoCJibE9VM2eG5UHL2jg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '1', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('609', '', '', '45743775', '0', '铿锵，青春！', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLlrIZk5vUWzaDZqe7ETxVnXofVfUHdtbom7EcbIGPWOibCIEdia1CcguYFOwAzrNuxAkhR7fz8r2Vw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('610', '', '', '75655249', '0', '龙莺', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/jNwribcdBCDD3YJk697pXzPdKhkMxkiagDAEBGhuJzv3v73PeV0Pb2YM49ickSrK8AcV4WibhaO9PSnkE0SdZaMlpw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '2', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('611', '', '', '78668144', '0', '阿冰', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=QM4YP0b0UEX79mYicjNv1Jg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('612', '', '', '22176910', '0', '斌', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=KIP70FwP5398oERtkzO4DQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('613', '', '', '33750645', '0', '面朝大海', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=8QADt61IwXv8Z7uY30Zxrg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('614', '', '', '75862002', '0', '情若心相惜', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/0FnrhWNLyceVHpzydzATE5H7uptvv7mLxnpuicBeQDOzgUTicStmPgTPz0qo5o1m2YsVXrbkHTmJGLJv0Coydk8w/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('615', '', '', '57720868', '0', '猴王', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=Giaq7wt54UIeQyouTYYT3TA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('616', '', '', '38895017', '0', '文頓', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/rF9QsOVzupDXTHjicp4oI4eUT875PTBicMf4T6p400CVUHglic3Gd3FQ54xEqfKYQOz2I5a4NeBE8rpiboV1PoZqWA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('617', '', '', '56422960', '0', '一鸣', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=TTSGjCic3mOrGeBl4S6dheA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('618', '', '', '86706003', '0', '。。。。', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83er2gA6MVHqPbWMjw50McOgib84uOckAsZrRKOBn0vCe1ia79nCUmTeHRYI5QkbbBHpXjWbXGg5UibgKw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('619', '', '', '43554346', '0', '割腕浇玫瑰', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=8KiarWbzbPyItyu67NQMUFQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '1', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('620', '', '', '84094107', '0', '希望', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/uVLcoYVUlia7hmGkjrHUibtCibB9BI6urW9z1g2iaiciae7frvibGxCLDJ9ETXzdbEzXrzJbw7Y5LNPwibV87t4RuwFpJQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('621', '', '', '85784076', '0', 'じAomrご淡墨つ', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=PQO7d1SwiceBgs6hrFu9tkg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('622', '', '', '95974976', '0', '队长', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=jORDsNjqicXOMQ4s8GQAmTw&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('623', '', '', '99874646', '0', '原', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/PiajxSqBRaEId67rclUHMl5JudH1FoALH9HsUkds8Wu4ickTxiao2oF4TZF0BpntqSI5PtSwjc2Pzajb1FGutb7OQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('624', '', '', '86717786', '0', '漫步者', '2', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=C1qnZsiaNnb4gbN3F5XSoCA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('625', '', '', '47396776', '0', 'Memory。', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=tdwkQvhjWOFtIJ7OKhnbicg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('626', '', '', '59283040', '0', '朱伟梧', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/78AvToPqWCiczORTsyVn5ELvibtBiaiaNeecKvTu87zMZBpHic9Rk1QP6JuZaoTHefY9oibJtl30twYjTWAFDDpFicVZQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('627', '', '', '68225301', '0', '邹邹（如意）', '1', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqwFkeesElOQBQSMmibm9ZwKdNVQwOhYbktFR4Y1tSqZfCK4x5vx4j2tF7FWeHI7xvXxSzEdcLVsDA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '2', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('628', '', '', '19808550', '0', '双子鱼', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJNsPRYGU8PSPmu2zQ33cQADDjBvTMk9ibQBwBwmZAx1KTMK0hQYibKeL2mVTqYNdAlOXXibKa1rFHlQ/132', '4', '0', '', '', '0', '', null, '0', '0', '1', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('629', '', '', '17382160', '0', '透明人', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIWahIUV0nblGojL34sSQOZ0BkpNMggQT15IeJ82zV8ldyCz79S05wyoKanzibjNjnTjxIicmr12Agg/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('630', '', '', '29408472', '0', '夢ジ微笑', '2', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=YOicl7BTEAyKA9AdMflh9sw&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('631', '', '', '62927155', '0', '烘焙达人', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJzXEPugnVKqe4jVh6K2lsicB2GQ6Gcico0aYAicdk71pxnjLymbArkdicMnODF8B2bSpPQBsSGfdrmjQ/132', '4', '0', '', '', '0', '', null, '0', '0', '2', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('632', '', '', '23390551', '0', '南丰浪人', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=3Vp6tjxy0WicbL3ZCVda5GQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '1', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('633', '', '', '98666505', '0', '蝴蝶剑', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=Nl6MRMPfFoVlzlRScTx8xg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('634', '', '', '42474543', '0', 'LIN', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=yyNqynjBBbTclZIv9AoHbA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '1', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('635', '', '', '87055527', '0', '斌', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=KIP70FwP5398oERtkzO4DQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('636', '', '', '49773439', '0', '双子鱼', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJNsPRYGU8PSPmu2zQ33cQADDjBvTMk9ibQBwBwmZAx1KTMK0hQYibKeL2mVTqYNdAlOXXibKa1rFHlQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('637', '', '', '44915887', '0', '阿冰', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=QM4YP0b0UEX79mYicjNv1Jg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '1', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('638', '', '', '91470840', '0', '漫步者', '2', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=C1qnZsiaNnb4gbN3F5XSoCA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('639', '', '', '60252599', '0', '城市花园', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=ASY4tia397kEOhdrKiboialicQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('640', '', '', '79315598', '0', '阳光普照', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/I7r6G5lrb2dCCGsvWxvPoia1iaS3bESicC71xq6YZ7adbAsax2uJxlFO7KSGoGfQV6DibQdZRKEvKj5BZsM11aibT6A/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('641', '', '', '46217701', '0', '面朝大海', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=8QADt61IwXv8Z7uY30Zxrg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('642', '', '', '95320511', '0', '夢ジ微笑', '2', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=YOicl7BTEAyKA9AdMflh9sw&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('643', '', '', '61234767', '0', '邹邹（如意）', '1', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqwFkeesElOQBQSMmibm9ZwKdNVQwOhYbktFR4Y1tSqZfCK4x5vx4j2tF7FWeHI7xvXxSzEdcLVsDA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('644', '', '', '81134663', '0', '猴王', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=Giaq7wt54UIeQyouTYYT3TA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('645', '', '', '53018670', '0', 'じAomrご淡墨つ', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=PQO7d1SwiceBgs6hrFu9tkg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('646', '', '', '60502626', '0', '情若心相惜', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/0FnrhWNLyceVHpzydzATE5H7uptvv7mLxnpuicBeQDOzgUTicStmPgTPz0qo5o1m2YsVXrbkHTmJGLJv0Coydk8w/132', '4', '0', '', '', '0', '', null, '0', '0', '1', '1', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('647', '', '', '26526888', '0', '铿锵，青春！', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLlrIZk5vUWzaDZqe7ETxVnXofVfUHdtbom7EcbIGPWOibCIEdia1CcguYFOwAzrNuxAkhR7fz8r2Vw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('648', '', '', '75005732', '0', 'TJX', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJlaMp21eww0xrlGXVwgDshZEp7lCb0M7ClMNcvYic4uGJh8dDoDIhhFe2VPIibeaYawC7t5Cr1IdJA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '2', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('649', '', '', '55342112', '0', '原', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/PiajxSqBRaEId67rclUHMl5JudH1FoALH9HsUkds8Wu4ickTxiao2oF4TZF0BpntqSI5PtSwjc2Pzajb1FGutb7OQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('650', '', '', '83073981', '0', '狼', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=yWdelQjhLiapvI7CoicXQNKA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '1', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('651', '', '', '12621239', '0', '透明人', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIWahIUV0nblGojL34sSQOZ0BkpNMggQT15IeJ82zV8ldyCz79S05wyoKanzibjNjnTjxIicmr12Agg/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('652', '', '', '21188250', '0', '唯一', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/YGbbwKGicU3ibZpeDY2IS88UvWEOG9xLulaSsjjiarU9N1yPunuZNUiahz9Sey8ibnKB1DwH01NoXNKN4kMzCORaeWQ/132', '4', '0', '', '', '0', '', null, '0', '0', '1', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('653', '', '', '25705655', '0', 'OverDsoe 上瘾i', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=wWZ2qWITkkCnJRQUt5fH7g&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);
INSERT INTO `yf_hf_member` VALUES ('654', '', '', '70204804', '0', 'LIN', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=yyNqynjBBbTclZIv9AoHbA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '1', '0', '0', '0', '0', null, '0', '', '0', 'offline', '1', null, null);

-- ----------------------------
-- Table structure for yf_hf_member_copy1
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_member_copy1`;
CREATE TABLE `yf_hf_member_copy1` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `openid` varchar(100) NOT NULL DEFAULT '' COMMENT '普通app用户openid',
  `unionid` varchar(100) NOT NULL DEFAULT '' COMMENT '用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。',
  `hiid` varchar(100) NOT NULL DEFAULT '0' COMMENT '嗨id',
  `is_power` tinyint(1) NOT NULL DEFAULT '0' COMMENT '权限：0没有权限，1有权限',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '普通用户昵称',
  `sex` tinyint(4) NOT NULL DEFAULT '0' COMMENT '普通用户性别，1为男性，2为女性',
  `birthday` varchar(100) NOT NULL DEFAULT '0' COMMENT '出生年月',
  `province` varchar(50) NOT NULL DEFAULT '' COMMENT '普通用户个人资料填写的省份',
  `city` varchar(50) NOT NULL DEFAULT '' COMMENT '普通用户个人资料填写的城市',
  `country` varchar(50) NOT NULL DEFAULT '' COMMENT '国家，如中国为CN',
  `headimgurl` varchar(255) NOT NULL DEFAULT '' COMMENT '用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空',
  `label` tinyint(1) NOT NULL DEFAULT '4' COMMENT '用户标签: 1:业主 2经纪人 3买房者 4租房者',
  `area_id` int(11) NOT NULL DEFAULT '0' COMMENT '业务区域,只有经纪人标签才有,其他标签默认为0',
  `privilege` varchar(255) NOT NULL DEFAULT '' COMMENT '用户特权信息，json数组，如微信沃卡用户为（chinaunicom）',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
  `use_wechat_headimg` int(10) DEFAULT '0' COMMENT '是0否1使用微信头像',
  `app_version` varchar(20) DEFAULT '' COMMENT '用户当前版本',
  `sign` varchar(20) DEFAULT NULL COMMENT '个性签名',
  `num_follow` int(10) DEFAULT '0' COMMENT '粉丝数',
  `num_publish` int(11) DEFAULT '0' COMMENT '发布数',
  `num_good_video` int(11) DEFAULT '0' COMMENT '点赞视频数',
  `num_buildings` int(11) DEFAULT '0' COMMENT '关注小区数',
  `num_prise` int(11) DEFAULT '0' COMMENT '获赞',
  `num_member` int(11) DEFAULT '0' COMMENT '关注人数',
  `balance` int(11) DEFAULT '0' COMMENT '钱包余额',
  `invite_code` varchar(20) DEFAULT NULL COMMENT '本用户邀请码',
  `invite_from_id` int(10) DEFAULT '0' COMMENT '发起邀请人id',
  `app_key` varchar(32) NOT NULL COMMENT 'app_key',
  `logout_timestamp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '退出系统时间戳，用于查询离线消息',
  `is_robot` tinyint(4) DEFAULT '0',
  `status` enum('online','offline') NOT NULL DEFAULT 'offline' COMMENT '在线状态，在线或者离线',
  `create_time` int(10) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(10) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=605 DEFAULT CHARSET=utf8 COMMENT='会员表';

-- ----------------------------
-- Records of yf_hf_member_copy1
-- ----------------------------
INSERT INTO `yf_hf_member_copy1` VALUES ('224', '12568463', '123796745', '0', '0', 'mrsongasd', '1', '0', '山东', '枣庄', '中国', 'www.baidu.com/url/asdasd', '1', '0', 'asdasddgdrgrw', '', '0', '1.0.0', '看房小能手', '1', '0', '0', '0', '0', '0', '128', null, '0', 'b054014693241bcd9c20', '1525436401', '0', 'offline', '1523781354', '1528003392');
INSERT INTO `yf_hf_member_copy1` VALUES ('225', 'oxR0M1IkP5kel7DWi7W-nn-3e9hw', '0', '633804352', '0', '微信名', '1', '0', 'Shanghai', '', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/mUjv4zYCJiaMZdJcJEpEm3Q1MYOiboiahEuZorobPFwstjsvZuwgpYRl8m7IE9gybOgQROXAq0fH8AhHE3GiacRdLw/132', '2', '0', '', '', '0', null, '个性签名', '0', '0', '0', '0', '0', '0', '0', null, '0', 'b054014693241bcd9c20', '1525413236', '0', 'offline', '1525340833', '1526119563');
INSERT INTO `yf_hf_member_copy1` VALUES ('445', '', '0', '2147483646', '0', '马冬梅', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '2', '0', '', '13419959203', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000XX', '0', 'b054014693241bcd9c20', '1525665160', '0', 'online', null, '1527230218');
INSERT INTO `yf_hf_member_copy1` VALUES ('449', '12345678900', '0', '2147483647', '1', '测试', '1', '2018-05-31', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJF2YJjW11KZ4NtibGWKG8QElHRONZMQd0LzMMoZYJnY7tmnK6KWaBibIl1wvvgbliaAqAWyDSVxqNOA/132', '2', '5', '', '12345678900', '0', '1.0.0', '闵行', '0', '0', '0', '0', '0', '0', '0', null, '0', 'b054014693241bcd9c20', '1527996661', '0', 'online', null, '1527855319');
INSERT INTO `yf_hf_member_copy1` VALUES ('460', '125684643', '123796745', '0', '1', 'mrsongasd', '1', '0', '山东', '枣庄', '中国', '', '1', '0', 'asdasddgdrgrw', '', '0', '1.0.0', null, '2', '0', '0', '0', '0', '0', '128', null, '0', 'b054014693241bcd9c20', '1526628478', '0', 'online', '1523951065', '1528003390');
INSERT INTO `yf_hf_member_copy1` VALUES ('470', '', '0', '454342062', '0', '专一打高跟鞋', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '5', '', '18616812456', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000NP', '0', '', '0', '0', 'offline', null, '1526225546');
INSERT INTO `yf_hf_member_copy1` VALUES ('473', 'oxR0M1H5ugX9BEHVcN76rOAjIikM', 'oNOSMwTnJOgPESltzC73X-Md9h-E', '2147483647', '1', '宋健', '1', '0', '山东', '枣庄', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJfic3yUNdDhjwVIvn64GKOLQKg3NtuOSwQYGsz6dudFRVMiak1sBD76AaUSwgMBgBZyZPibluSBoBVg/132', '2', '0', '', '13869472562', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '129', '0000N2', '0', '', '0', '0', 'offline', '1526281006', '1528003386');
INSERT INTO `yf_hf_member_copy1` VALUES ('512', '', '', '9462446362', '0', '苹果给火', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '5', '', '13869472554', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '0', '0000OU', '0', '', '0', '0', 'offline', '1526364426', '1528003424');
INSERT INTO `yf_hf_member_copy1` VALUES ('513', '', '', '1185976362', '0', '老衲洗发用飘柔', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '234', '', '15821759915', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '0', '0000OV', '0', '', '1527680987', '0', 'offline', '1526367958', '1528003425');
INSERT INTO `yf_hf_member_copy1` VALUES ('514', '', '', '2555586362', '0', 'nothing', '2', '2017-05-31', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '586', '', '17638103673', '0', '1.0.0', null, '1', '0', '0', '1', '0', '0', '6', '0000O6', '0', '', '1527997669', '0', 'offline', '1526368555', '1528003414');
INSERT INTO `yf_hf_member_copy1` VALUES ('515', '', '', '7259686362', '0', 'songjian', '1', '2005-06-01', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '234', '', '18616812914', '0', '1.0.0', '此时此刻我想吟诗一首', '1', '0', '0', '0', '0', '0', '80', '0000O7', '0', '', '1527854530', '0', 'offline', '1526368695', '1528003412');
INSERT INTO `yf_hf_member_copy1` VALUES ('516', '', '', '8649107362', '0', '默默', '2', '2018-05-18', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '0', '234', '', '18516014525', '0', '1.0.0', '密码是0123456', '1', '0', '0', '0', '0', '0', '0', '0000OM', '0', '', '1527785361', '0', 'offline', '1526370194', '1528003427');
INSERT INTO `yf_hf_member_copy1` VALUES ('517', 'oxR0M1CpHVyqYvRJ-RHXdaeCv4bs', 'oNOSMwZyP3FiWajgnXZUNNy-zqhY', '5895727362', '1', '或许只有我遗落在时间的罅隙永无归途', '1', '1991-05-24', 'Firenze', '', 'IT', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJF2YJjW11KZ4NtibGWKG8QElHRONZMQd0LzMMoZYJnY7tmnK6KWaBibIl1wvvgbliaAqAWyDSVxqNOA/132', '4', '585', '', '17319066282', '0', '1.0.0', '岁月如长河无尽，沧海也变成桑田', '3', '0', '0', '0', '0', '0', '4', '0000OW', '0', '', '1527994606', '0', 'online', '1526372759', '1528003434');
INSERT INTO `yf_hf_member_copy1` VALUES ('518', '', '', '06684325', '0', '幽默迎可乐', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '578', '', '15216883796', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '0', '0000OX', '0', '', '0', '0', 'offline', '1526523486', '1528003428');
INSERT INTO `yf_hf_member_copy1` VALUES ('519', '', '', '27332425', '0', '聪慧迎白云', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '5', '', '13419959201', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '0', '0000O8', '0', '', '0', '0', 'offline', '1526524233', '1528003429');
INSERT INTO `yf_hf_member_copy1` VALUES ('520', '', '', '02621925', '0', '宋江', '1', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '2', '234', '', '17621859931', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '200', '0000O9', '0', '', '0', '0', 'offline', '1526529126', '1528003395');
INSERT INTO `yf_hf_member_copy1` VALUES ('521', '', '', '87836645', '1', '潇潇', '1', '2017-05-31', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '578', '', '17717536290', '0', '1.0.0', '徽墨', '1', '0', '0', '0', '0', '0', '2', '0000OK', '0', '', '1527677304', '0', 'offline', '1526546638', '1528003422');
INSERT INTO `yf_hf_member_copy1` VALUES ('522', '', '', '25196645', '1', '追寻', '2', '2018-05-31', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '578', '', '17621970092', '0', '1.0.0', '领域', '1', '1', '0', '1', '0', '0', '58', '0000OL', '0', '', '1528003298', '0', 'offline', '1526546691', '1528003413');
INSERT INTO `yf_hf_member_copy1` VALUES ('523', '', '', '18124316', '0', '测试结果', '0', '2015-05-29', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '234', '', '15601652352', '0', '1.0.0', '也uur jrh', '1', '0', '0', '0', '0', '0', '0', '0000OY', '0', '', '0', '0', 'offline', '1526613421', '1528003432');
INSERT INTO `yf_hf_member_copy1` VALUES ('561', '', '', '94955298', '0', '想人陪打绿茶', '0', '0', '', '', '', 'http://www.haifang.com/uploads/picture/default/default-logo.png', '1', '5', '', '18616800000', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '0', '0000I5', '0', '', '0', '0', 'offline', '1526892559', '1528003434');
INSERT INTO `yf_hf_member_copy1` VALUES ('564', '', '', '88570398', '0', '昏睡演变店员', '0', '0', '', '', '', 'http://www.haifang.com/uploads/picture/default/default-logo.png', '1', '5', '', '18616800001', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000ID', '0', '', '0', '0', 'offline', '1526893075', '1527769685');
INSERT INTO `yf_hf_member_copy1` VALUES ('565', '', '', '87595398', '0', '彪壮演变鸭子', '0', '0', '', '', '', 'http://www.haifang.com/uploads/picture/default/default-logo.png', '1', '5', '', '18616800002', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IG', '0', '', '0', '0', 'offline', '1526893595', '1527769683');
INSERT INTO `yf_hf_member_copy1` VALUES ('566', 'oxR0M1HTb-8BGgZN6sMz7mOIlxRA', 'oNOSMwV9l7-StZPuo_0kC_PU-c64', '67231879', '1', 'D', '2', '0', 'Fujian', 'Quanzhou', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIuqOuvZLWMJ2euic3BIjdIzibuMx94jZPf7GtJib3MWWc1ONNBfrZfeY8PbicvlHE6PnM5PiaWjXRvtAA/132', '4', '584', '', '18964231232', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000I3', '0', '', '0', '0', 'offline', '1526978132', '1527838897');
INSERT INTO `yf_hf_member_copy1` VALUES ('567', '', 'oNOSMwYbQUbUL8MDeLOTkOsZ8Xj8', '45902621', '0', '惊寒。', '1', '0', '上海', '徐汇', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/ERCGGnJdzA5YjTLruhaH8uEkyPtYib64E3PLJyJ5Jm0u1GbMELA7uibHicibDVjOXHyBJN8KmV9icbD74mbyRvjqsDA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '0', 'offline', null, '1527638547');
INSERT INTO `yf_hf_member_copy1` VALUES ('568', 'oxR0M1BuynYtmu1-nFwKAfHRIx6U', 'oNOSMwUTZvsQ0X1frLqIYCSD5mCs', '48076721', '0', '逆', '1', '0', 'Shanghai', 'Xuhui', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKhkIick43GoVMqf1ibgjV4mq7WicSMNJwCbZC283aPlI4ichIbMxuPnJJ2RISP4S6aRY9D3icxlcWCicaA/132', '0', '1', '', '', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IQ', '0', '', '0', '0', 'offline', '1527127670', '1527843530');
INSERT INTO `yf_hf_member_copy1` VALUES ('569', '', 'oNOSMwZR4IcL3aeG_CirSw2cS7Wc', '15261242', '0', '离水的 ', '2', '0', '上海', '', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/8icfELo600aEeXpEic6AxoqS9GAzjCl037N9ctU2ribYo12LyiaVoymrrePE3Bx3JqG0Z26CtpS42tBZyFy0GZZPkw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '0', 'offline', null, '1527857130');
INSERT INTO `yf_hf_member_copy1` VALUES ('570', 'oxR0M1AJHLjrlEGToTUHVSZjJqEM', 'oNOSMwWan2m4Tgif6WuUyhoaBEvU', '44691242', '0', '昔日流年', '1', '0', '安徽', '安庆', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLPiaj14cVKiaicR89ib7ictFMcyehU8hyWtZuLpRmxVxslwCsNzUejOzyel4lAWqJWcB9CXYpktz8sbEQ/132', '4', '0', '', '', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000I4', '0', '', '1528003460', '0', 'offline', null, '1527993916');
INSERT INTO `yf_hf_member_copy1` VALUES ('571', 'oxR0M1AYQU8OhNUwjbBm8eVnBCXY', 'oNOSMwT_PLrSdYxAuIbUq1kR5mJE', '06613062', '0', 'a施海彦《同联商业》《福居好房》', '0', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqTKJsGHIZ6Y0CmVIGGT6BV4FqVO3PvmibvKI7JlvrkaRPwNfFIc7Dk3HGibZmniaSia0jYNu3blga9CA/132', '4', '576', '', '13482498882', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IB', '0', '', '0', '0', 'offline', '1527260316', '1527992801');
INSERT INTO `yf_hf_member_copy1` VALUES ('572', 'oxR0M1HBAIActyJ3E_Xk89zQjz0I', 'oNOSMwYzD5vNr0gW1PjOAnLmIPTg', '87393062', '0', '许正', '1', '0', 'Shanghai', 'Changning', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTICOAdU4ZDNQiaGcFxiaVUXc6GfAgH3oQV2L8r1cqzA0a5y4CuMZzLRDNvy3nrhySm86GiaevGsWQCcw/132', '4', '585', '', '15502198310', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000I1', '0', '', '0', '0', 'offline', '1527260393', '1527994052');
INSERT INTO `yf_hf_member_copy1` VALUES ('573', 'oxR0M1PvPQ-QuliUlewIbxta7Gtk', 'oNOSMwd34L78Y4s3wYWT1jzZ_Vl4', '01504062', '0', 'JasonXu', '1', '0', 'Shanghai', 'Pudong New District', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLmKFb7tzySXmJic6IORtXyFrTBM5za47xNo5Gr3CDgVfyaFia87vVQESpWzWT17fefeYiccRTz25jIg/132', '3', '588', '', '18516014525', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IN', '0', '', '0', '0', 'offline', '1527260405', '1527991560');
INSERT INTO `yf_hf_member_copy1` VALUES ('574', '', '', '86030883', '0', '疯狂方菠萝', '0', '0', '', '', '', 'http://www.haifang.com/uploads/picture/default/default-logo.png', '1', '85', '', '18101725237', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '0', '0000IO', '0', '', '0', '0', 'offline', '1527388030', '1528003401');
INSERT INTO `yf_hf_member_copy1` VALUES ('575', 'oxR0M1IkP5kel7DWi7W-nn-3e9hw', 'oNOSMwe8BzWCjGaH_Y1unNcBr1J4', '48232594', '0', '像我这样的人', '1', '0', 'Shanghai', '', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/mUjv4zYCJiaMZdJcJEpEm3Q1MYOiboiahEuZorobPFwstjsvZuwgpYRl8m7IE9gybOgQROXAq0fH8AhHE3GiacRdLw/132', '2', '593', '', '', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IP', '0', '', '0', '0', 'offline', '1527495232', '1528000172');
INSERT INTO `yf_hf_member_copy1` VALUES ('576', '', '', '74890946', '0', '树叶迷路', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '2', '0', '', '18516014528', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000II', '0', '', '0', '0', 'offline', '1527649098', '1527649098');
INSERT INTO `yf_hf_member_copy1` VALUES ('577', '', 'oNOSMwex6-HunICmoXTr0aWw6jzg', '59919656', '0', 'Agping', '2', '0', '河南', '信阳', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/AzicNNoeYZgWEFR8rEB3GBbSKN49nkMzDicMM5t3yzJ7iaFTR4cUChwWB1cPEUGqSulOIJrGicESZT64hvS7AgYM2g/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '0', 'offline', null, null);
INSERT INTO `yf_hf_member_copy1` VALUES ('578', '', 'oNOSMwR6bRhGUR0zY9d2-Vt4aT3E', '68191766', '0', '曾啊牛', '1', '0', '上海', '浦东新区', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLqeib8OfVoRA0Y70YbMsQ8I4wvVIC3ccEgwtJfC5icpEZhgbekLIwicbFCBcCk0bxYG7s6LoNdIndUA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '0', 'offline', null, null);
INSERT INTO `yf_hf_member_copy1` VALUES ('579', '', 'oNOSMwXeZI94STyuahcL8lMAKJ9I', '91332766', '0', 'coco—哆啦', '2', '0', '河南', '郑州', '中国', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLX8ole5k6gIf7hlliaGb3ZzFBD4TPkc98SnGRR9kfd5d7Aj1mtlHhsFg2EWA6tNrc8PrYxXZbnhPA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '0', 'offline', null, null);
INSERT INTO `yf_hf_member_copy1` VALUES ('580', 'oxR0M1JNfFBy04p5taTnnPnQVLFY', 'oNOSMwV_MHF3VqFJU32jEaPqURJA', '27912866', '0', '', '2', '0', '', '', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/4MjEPyUh1Bq4q6ib1TTEY39E3eBBS7RZQxF9IHJctYpTJo1H8YfichRdBSkaI81v6FdtpgicpI3MUcWDZ1K4PImrQ/132', '4', '585', '', '', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IS', '0', '', '0', '0', 'offline', '1527668219', '1527838040');
INSERT INTO `yf_hf_member_copy1` VALUES ('581', 'oxR0M1HaCzkqakEZRGRf4TmXoPRk', 'oNOSMwdE1y9iJDiP3ZkF52FVZJ68', '05143776', '0', 'sosence', '1', '0', 'Shanghai', 'Changning', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83epOJBffbo5iaadD28aYlwJJv1jWYoXNuJsXDND5E6ug1fX8A4k3HsyhNxdstrdoUqKrarYkCPC5LPg/132', '3', '577', '', '', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IT', '0', '', '0', '0', 'offline', '1527677341', '1527677438');
INSERT INTO `yf_hf_member_copy1` VALUES ('582', '', '', '99435776', '0', '友好爱银耳汤', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '2', '0', '', '15601652351', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IU', '0', '', '0', '0', 'offline', '1527677534', '1527821625');
INSERT INTO `yf_hf_member_copy1` VALUES ('583', '', '', '14500037', '0', '活泼保卫蜜蜂', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '234', '', '13764803661', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IV', '0', '', '0', '0', 'offline', '1527730005', '1527821146');
INSERT INTO `yf_hf_member_copy1` VALUES ('584', '', '', '81162547', '1', '雪碧能干', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '234', '', '15601655351', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000I6', '0', '', '0', '0', 'offline', '1527745261', '1527855082');
INSERT INTO `yf_hf_member_copy1` VALUES ('585', '', '', '96244157', '0', '勤奋和橘子', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '578', '', '15623562580', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000I7', '0', '', '0', '0', 'offline', '1527751442', '1527751827');
INSERT INTO `yf_hf_member_copy1` VALUES ('586', '', '', '88374357', '0', '棒球风趣', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '2', '0', '', '15612345678', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IM', '0', '', '0', '0', 'offline', '1527753473', '1527832985');
INSERT INTO `yf_hf_member_copy1` VALUES ('587', '', '', '94955357', '0', '煎饼顺利', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '578', '', '15512345678', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000IW', '0', '', '0', '0', 'offline', '1527753559', '1527753559');
INSERT INTO `yf_hf_member_copy1` VALUES ('588', '', '', '67740457', '1', '拼搏和小白菜', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '4', '0', '', '13636508937', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '5', '0000IX', '0', '', '0', '0', 'offline', '1527754047', '1528003416');
INSERT INTO `yf_hf_member_copy1` VALUES ('589', '', '', '27462757', '1', '壮观保卫发卡', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '4', '0', '', '13636508937', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '5', null, '0', '', '0', '0', 'offline', '1527757264', '1528003417');
INSERT INTO `yf_hf_member_copy1` VALUES ('597', '', '', '48219067', '1', '爱听歌心情', '0', '0', '', '', '', 'http://www.haifang.com/uploads/picture/default/default-logo.png', '4', '0', '', '15121118600', '0', '1.0.0', null, '1', '0', '0', '0', '0', '0', '5', '0000JF', '0', '', '0', '0', 'offline', '1527760912', '1528003420');
INSERT INTO `yf_hf_member_copy1` VALUES ('598', 'oxR0M1HYOS8Q0FFTRn6fm_Ipps_c', 'oNOSMwXuaFGWhN8xORs8_vGcGCjI', '94183167', '0', '枷', '1', '0', '', '', 'CN', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Txy2JrK73zU0cqoxic7jiajGSudyqYLqSRslTShLXL7yKQ86xbmZywF1hWtF6cGXNB8KMgjO2LD9EA1LnGOkFOoQ/132', '2', '577', '', '', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000JC', '0', '', '0', '0', 'offline', '1527761381', '1527990437');
INSERT INTO `yf_hf_member_copy1` VALUES ('599', '', '', '58797918', '0', '小丸子无辜', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '588', '', '15207141670', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000JD', '0', '', '0', '0', 'offline', '1527819797', '1527834441');
INSERT INTO `yf_hf_member_copy1` VALUES ('600', '', '', '52797918', '0', '含羞草欣慰', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '588', '', '15207141670', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000JG', '0', '', '0', '0', 'offline', '1527819797', '1527819797');
INSERT INTO `yf_hf_member_copy1` VALUES ('601', '', '', '47935738', '0', '西牛火星上', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '3', '234', '', '17621970093', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000J3', '0', '', '0', '0', 'offline', '1527837539', '1527837539');
INSERT INTO `yf_hf_member_copy1` VALUES ('602', '', '', '48717048', '0', '音响醉熏', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '3', '234', '', '17621970094', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000JH', '0', '', '0', '0', 'offline', '1527840717', '1527840717');
INSERT INTO `yf_hf_member_copy1` VALUES ('603', '', '', '18821148', '0', '小蚂蚁结实', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '581', '', '17621970095', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000JQ', '0', '', '0', '0', 'offline', '1527841128', '1527841128');
INSERT INTO `yf_hf_member_copy1` VALUES ('604', '', '', '77291148', '0', '怕黑给台灯', '0', '0', '', '', '', 'https://yftest.fujuhaofang.com/uploads/picture/default/default-logo.png', '1', '581', '', '17717536297', '0', '1.0.0', null, '0', '0', '0', '0', '0', '0', '0', '0000JA', '0', '', '0', '0', 'offline', '1527841192', '1527841192');

-- ----------------------------
-- Table structure for yf_hf_member_robot
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_member_robot`;
CREATE TABLE `yf_hf_member_robot` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `openid` varchar(100) NOT NULL DEFAULT '' COMMENT '普通app用户openid',
  `unionid` varchar(100) NOT NULL DEFAULT '' COMMENT '用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。',
  `hiid` varchar(100) NOT NULL DEFAULT '0' COMMENT '嗨id',
  `is_power` tinyint(1) NOT NULL DEFAULT '0' COMMENT '权限：0没有权限，1有权限',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '普通用户昵称',
  `sex` tinyint(4) NOT NULL DEFAULT '0' COMMENT '普通用户性别，1为男性，2为女性',
  `birthday` varchar(100) NOT NULL DEFAULT '0' COMMENT '出生年月',
  `province` varchar(50) NOT NULL DEFAULT '' COMMENT '普通用户个人资料填写的省份',
  `city` varchar(50) NOT NULL DEFAULT '' COMMENT '普通用户个人资料填写的城市',
  `country` varchar(50) NOT NULL DEFAULT '' COMMENT '国家，如中国为CN',
  `headimgurl` varchar(255) NOT NULL DEFAULT '' COMMENT '用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空',
  `label` tinyint(1) NOT NULL DEFAULT '4' COMMENT '用户标签: 1:业主 2经纪人 3买房者 4租房者',
  `area_id` int(11) NOT NULL DEFAULT '0' COMMENT '业务区域,只有经纪人标签才有,其他标签默认为0',
  `privilege` varchar(255) NOT NULL DEFAULT '' COMMENT '用户特权信息，json数组，如微信沃卡用户为（chinaunicom）',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
  `use_wechat_headimg` int(10) DEFAULT '0' COMMENT '是0否1使用微信头像',
  `app_version` varchar(20) DEFAULT '' COMMENT '用户当前版本',
  `sign` varchar(20) DEFAULT NULL COMMENT '个性签名',
  `num_follow` int(10) DEFAULT '0' COMMENT '粉丝数',
  `num_publish` int(11) DEFAULT '0' COMMENT '发布数',
  `num_good_video` int(11) DEFAULT '0' COMMENT '点赞视频数',
  `num_buildings` int(11) DEFAULT '0' COMMENT '关注小区数',
  `num_prise` int(11) DEFAULT '0' COMMENT '获赞',
  `num_member` int(11) DEFAULT '0' COMMENT '关注人数',
  `balance` int(11) DEFAULT '0' COMMENT '钱包余额',
  `invite_code` varchar(20) DEFAULT NULL COMMENT '本用户邀请码',
  `invite_from_id` int(10) DEFAULT '0' COMMENT '发起邀请人id',
  `app_key` varchar(32) NOT NULL COMMENT 'app_key',
  `logout_timestamp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '退出系统时间戳，用于查询离线消息',
  `is_robot` tinyint(4) DEFAULT '0',
  `status` enum('online','offline') NOT NULL DEFAULT 'offline' COMMENT '在线状态，在线或者离线',
  `create_time` int(10) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(10) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1997 DEFAULT CHARSET=utf8 COMMENT='会员表';

-- ----------------------------
-- Records of yf_hf_member_robot
-- ----------------------------
INSERT INTO `yf_hf_member_robot` VALUES ('605', '', '', '0', '0', 'じAomrご淡墨つ', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=PQO7d1SwiceBgs6hrFu9tkg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('606', '', '', '0', '0', '烘焙达人', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJzXEPugnVKqe4jVh6K2lsicB2GQ6Gcico0aYAicdk71pxnjLymbArkdicMnODF8B2bSpPQBsSGfdrmjQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('607', '', '', '0', '0', '邹邹（如意）', '1', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqwFkeesElOQBQSMmibm9ZwKdNVQwOhYbktFR4Y1tSqZfCK4x5vx4j2tF7FWeHI7xvXxSzEdcLVsDA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('608', '', '', '0', '0', '猴王', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=Giaq7wt54UIeQyouTYYT3TA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('609', '', '', '0', '0', '面朝大海', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=8QADt61IwXv8Z7uY30Zxrg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('610', '', '', '0', '0', '一鸣', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=TTSGjCic3mOrGeBl4S6dheA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('611', '', '', '0', '0', '文頓', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/rF9QsOVzupDXTHjicp4oI4eUT875PTBicMf4T6p400CVUHglic3Gd3FQ54xEqfKYQOz2I5a4NeBE8rpiboV1PoZqWA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('612', '', '', '0', '0', 'Memory。', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=tdwkQvhjWOFtIJ7OKhnbicg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('613', '', '', '0', '0', '蝴蝶剑', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=Nl6MRMPfFoVlzlRScTx8xg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('614', '', '', '0', '0', '双子鱼', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJNsPRYGU8PSPmu2zQ33cQADDjBvTMk9ibQBwBwmZAx1KTMK0hQYibKeL2mVTqYNdAlOXXibKa1rFHlQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('615', '', '', '0', '0', '情若心相惜', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/0FnrhWNLyceVHpzydzATE5H7uptvv7mLxnpuicBeQDOzgUTicStmPgTPz0qo5o1m2YsVXrbkHTmJGLJv0Coydk8w/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('616', '', '', '0', '0', '残弦', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=Kk9sv1L08R5EgbHic3Dc6EA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('617', '', '', '0', '0', '希望', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/uVLcoYVUlia7hmGkjrHUibtCibB9BI6urW9z1g2iaiciae7frvibGxCLDJ9ETXzdbEzXrzJbw7Y5LNPwibV87t4RuwFpJQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('618', '', '', '0', '0', '阿冰', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=QM4YP0b0UEX79mYicjNv1Jg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('619', '', '', '0', '0', '夢ジ微笑', '2', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=YOicl7BTEAyKA9AdMflh9sw&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('620', '', '', '0', '0', '阳光普照', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/I7r6G5lrb2dCCGsvWxvPoia1iaS3bESicC71xq6YZ7adbAsax2uJxlFO7KSGoGfQV6DibQdZRKEvKj5BZsM11aibT6A/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('621', '', '', '0', '0', '斌', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=KIP70FwP5398oERtkzO4DQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('622', '', '', '0', '0', '做快乐的自己', '2', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=FFc7kS8iaZ6TuXegc7WZibGQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('623', '', '', '0', '0', '朱伟梧', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/78AvToPqWCiczORTsyVn5ELvibtBiaiaNeecKvTu87zMZBpHic9Rk1QP6JuZaoTHefY9oibJtl30twYjTWAFDDpFicVZQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('624', '', '', '0', '0', '漫步者', '2', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=C1qnZsiaNnb4gbN3F5XSoCA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('625', '', '', '0', '0', '原', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/PiajxSqBRaEId67rclUHMl5JudH1FoALH9HsUkds8Wu4ickTxiao2oF4TZF0BpntqSI5PtSwjc2Pzajb1FGutb7OQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('626', '', '', '0', '0', '队长', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=jORDsNjqicXOMQ4s8GQAmTw&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('627', '', '', '0', '0', 'LIN', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=yyNqynjBBbTclZIv9AoHbA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('628', '', '', '0', '0', '龙莺', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/jNwribcdBCDD3YJk697pXzPdKhkMxkiagDAEBGhuJzv3v73PeV0Pb2YM49ickSrK8AcV4WibhaO9PSnkE0SdZaMlpw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('629', '', '', '0', '0', '南丰浪人', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=3Vp6tjxy0WicbL3ZCVda5GQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('630', '', '', '0', '0', '。。。。', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83er2gA6MVHqPbWMjw50McOgib84uOckAsZrRKOBn0vCe1ia79nCUmTeHRYI5QkbbBHpXjWbXGg5UibgKw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('631', '', '', '0', '0', '透明人', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIWahIUV0nblGojL34sSQOZ0BkpNMggQT15IeJ82zV8ldyCz79S05wyoKanzibjNjnTjxIicmr12Agg/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('632', '', '', '0', '0', '割腕浇玫瑰', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=8KiarWbzbPyItyu67NQMUFQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('633', '', '', '0', '0', '铿锵，青春！', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLlrIZk5vUWzaDZqe7ETxVnXofVfUHdtbom7EcbIGPWOibCIEdia1CcguYFOwAzrNuxAkhR7fz8r2Vw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('634', '', '', '0', '0', '酒是故乡醇', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=DHepoCJibE9VM2eG5UHL2jg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('635', '', '', '0', '0', '双子鱼', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJNsPRYGU8PSPmu2zQ33cQADDjBvTMk9ibQBwBwmZAx1KTMK0hQYibKeL2mVTqYNdAlOXXibKa1rFHlQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('636', '', '', '0', '0', '阳光普照', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/I7r6G5lrb2dCCGsvWxvPoia1iaS3bESicC71xq6YZ7adbAsax2uJxlFO7KSGoGfQV6DibQdZRKEvKj5BZsM11aibT6A/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('637', '', '', '0', '0', '酒是故乡醇', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=DHepoCJibE9VM2eG5UHL2jg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('638', '', '', '0', '0', '猴王', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=Giaq7wt54UIeQyouTYYT3TA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('639', '', '', '0', '0', '面朝大海', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=8QADt61IwXv8Z7uY30Zxrg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('640', '', '', '0', '0', '兰兰', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83epJD0SEy6FrzbPuMPiaGZAk6MdPMbNmtbgDX4rEztib2cvyJbjYwcibfjfXVL61flOibed9vu7HwCjorQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('641', '', '', '0', '0', '狼', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=yWdelQjhLiapvI7CoicXQNKA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('642', '', '', '0', '0', 'Memory。', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=tdwkQvhjWOFtIJ7OKhnbicg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('643', '', '', '0', '0', '铿锵，青春！', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLlrIZk5vUWzaDZqe7ETxVnXofVfUHdtbom7EcbIGPWOibCIEdia1CcguYFOwAzrNuxAkhR7fz8r2Vw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('644', '', '', '0', '0', '原', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/PiajxSqBRaEId67rclUHMl5JudH1FoALH9HsUkds8Wu4ickTxiao2oF4TZF0BpntqSI5PtSwjc2Pzajb1FGutb7OQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('645', '', '', '0', '0', '潇湘钓翁', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Hkf9191m152mLjC15OficwXfW1NjeYicRz7aVCLBdFAeAO7aftX88hLGGSvEEVYGXicWrJopyDiaCB2CrlbWqmjLWA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('646', '', '', '0', '0', '阿冰', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=QM4YP0b0UEX79mYicjNv1Jg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('647', '', '', '0', '0', '斌', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=KIP70FwP5398oERtkzO4DQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('648', '', '', '0', '0', '情若心相惜', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/0FnrhWNLyceVHpzydzATE5H7uptvv7mLxnpuicBeQDOzgUTicStmPgTPz0qo5o1m2YsVXrbkHTmJGLJv0Coydk8w/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('649', '', '', '0', '0', '城市花园', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=ASY4tia397kEOhdrKiboialicQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('650', '', '', '0', '0', '星星之火', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=QOOwickdIvHem0pg0MJRmicQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('651', '', '', '0', '0', 'OverDsoe 上瘾i', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=wWZ2qWITkkCnJRQUt5fH7g&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('652', '', '', '0', '0', '夢ジ微笑', '2', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=YOicl7BTEAyKA9AdMflh9sw&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('653', '', '', '0', '0', '南宁百桂装饰18577154233', '1', '0', '', '', '', 'http://thirdqq.qlogo.cn/g?b=sdk&k=icsMlnQhac2USlExwratiaRg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('654', '', '', '0', '0', '。。。。', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83er2gA6MVHqPbWMjw50McOgib84uOckAsZrRKOBn0vCe1ia79nCUmTeHRYI5QkbbBHpXjWbXGg5UibgKw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('655', '', '', '0', '0', 'TJX', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJlaMp21eww0xrlGXVwgDshZEp7lCb0M7ClMNcvYic4uGJh8dDoDIhhFe2VPIibeaYawC7t5Cr1IdJA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('656', '', '', '0', '0', '南丰浪人', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=3Vp6tjxy0WicbL3ZCVda5GQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('657', '', '', '0', '0', '割腕浇玫瑰', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=8KiarWbzbPyItyu67NQMUFQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('658', '', '', '0', '0', 'LIN', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=yyNqynjBBbTclZIv9AoHbA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('659', '', '', '0', '0', 'CAT', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/bwKWGubqiapZwMAsw0YX2eH6984X7j9b4q9oPkxKvf8WXq2LY4KrcvibjE75W90kRMxQCS8bOuPXZliaH0TSXrv9g/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('660', '', '', '0', '0', '漫步者', '2', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=C1qnZsiaNnb4gbN3F5XSoCA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('661', '', '', '0', '0', '唯一', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/YGbbwKGicU3ibZpeDY2IS88UvWEOG9xLulaSsjjiarU9N1yPunuZNUiahz9Sey8ibnKB1DwH01NoXNKN4kMzCORaeWQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('662', '', '', '0', '0', 'じAomrご淡墨つ', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=PQO7d1SwiceBgs6hrFu9tkg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('663', '', '', '0', '0', '透明人', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIWahIUV0nblGojL34sSQOZ0BkpNMggQT15IeJ82zV8ldyCz79S05wyoKanzibjNjnTjxIicmr12Agg/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('664', '', '', '0', '0', '邹邹（如意）', '1', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqwFkeesElOQBQSMmibm9ZwKdNVQwOhYbktFR4Y1tSqZfCK4x5vx4j2tF7FWeHI7xvXxSzEdcLVsDA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('665', '', '', '0', '0', '斌', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=KIP70FwP5398oERtkzO4DQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('666', '', '', '0', '0', '漫步者', '2', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=C1qnZsiaNnb4gbN3F5XSoCA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('667', '', '', '0', '0', '时间为我留影过往', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/tlM8WhGvibNHSxfARYKso4OcGCNW5DTc4BRmbGHqTJNcG2EEJdaJvO77XVHicMeXWgn85icSLljiaTHCC8JkdUHzLA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('668', '', '', '0', '0', '情若心相惜', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/0FnrhWNLyceVHpzydzATE5H7uptvv7mLxnpuicBeQDOzgUTicStmPgTPz0qo5o1m2YsVXrbkHTmJGLJv0Coydk8w/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('669', '', '', '0', '0', '南宁百桂装饰18577154233', '1', '0', '', '', '', 'http://thirdqq.qlogo.cn/g?b=sdk&k=icsMlnQhac2USlExwratiaRg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('670', '', '', '0', '0', '潇湘钓翁', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Hkf9191m152mLjC15OficwXfW1NjeYicRz7aVCLBdFAeAO7aftX88hLGGSvEEVYGXicWrJopyDiaCB2CrlbWqmjLWA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('671', '', '', '0', '0', '唯一', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/YGbbwKGicU3ibZpeDY2IS88UvWEOG9xLulaSsjjiarU9N1yPunuZNUiahz9Sey8ibnKB1DwH01NoXNKN4kMzCORaeWQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('672', '', '', '0', '0', '简爱', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=uhribJQoaLtyRDX5mcT39sA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('673', '', '', '0', '0', '南丰浪人', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=3Vp6tjxy0WicbL3ZCVda5GQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('674', '', '', '0', '0', '疯了', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/6MliblNXYPjvlcdfMxGuOZviceNG30Z8XPJXcSvgCPrQ20LRaMibzPmTrYDTXW98oic68Vz580egKAHicYCBy3u1cDw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('675', '', '', '0', '0', '一刀', '1', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTK2B2lS6OYAVT9dGLc0ZKZWJjEbGibfNMXfRAc32CVpuL2lztds1A5Owu6L0MR1Zevta31Zx6y6VwQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('676', '', '', '0', '0', '原', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/PiajxSqBRaEId67rclUHMl5JudH1FoALH9HsUkds8Wu4ickTxiao2oF4TZF0BpntqSI5PtSwjc2Pzajb1FGutb7OQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('677', '', '', '0', '0', 'LIN', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=yyNqynjBBbTclZIv9AoHbA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('678', '', '', '0', '0', '城市花园', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=ASY4tia397kEOhdrKiboialicQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('679', '', '', '0', '0', 'TJX', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJlaMp21eww0xrlGXVwgDshZEp7lCb0M7ClMNcvYic4uGJh8dDoDIhhFe2VPIibeaYawC7t5Cr1IdJA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('680', '', '', '0', '0', '川哥', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTK7WRtaqmx28Iib7A2prHu0nu8mHTSdmsibA0HssGB19Gtrz0OV96zyypFxUMsraSqdcxPP3yyMrib2A/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('681', '', '', '0', '0', 'Memory。', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=tdwkQvhjWOFtIJ7OKhnbicg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('682', '', '', '0', '0', 'OverDsoe 上瘾i', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=wWZ2qWITkkCnJRQUt5fH7g&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('683', '', '', '0', '0', '兰兰', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83epJD0SEy6FrzbPuMPiaGZAk6MdPMbNmtbgDX4rEztib2cvyJbjYwcibfjfXVL61flOibed9vu7HwCjorQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('684', '', '', '0', '0', '。。。。', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83er2gA6MVHqPbWMjw50McOgib84uOckAsZrRKOBn0vCe1ia79nCUmTeHRYI5QkbbBHpXjWbXGg5UibgKw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('685', '', '', '0', '0', '割腕浇玫瑰', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=8KiarWbzbPyItyu67NQMUFQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('686', '', '', '0', '0', '长枪赵子龙', '1', '0', '', '', '', 'http://thirdqq.qlogo.cn/g?b=sdk&k=IxzJwAiaIsZdCg4Bxia6nmlw&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('687', '', '', '0', '0', 'CAT', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/bwKWGubqiapZwMAsw0YX2eH6984X7j9b4q9oPkxKvf8WXq2LY4KrcvibjE75W90kRMxQCS8bOuPXZliaH0TSXrv9g/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('688', '', '', '0', '0', '李洪明-和合影建', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Qw6zl3NUfHvZiaibYQtrSdHicKNd6XPHXStY4XEAibOAibBRhqUvN52xtQNPxtAGj2Ml04cHL5Kmtnt30icUFsvcNI5w/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('689', '', '', '0', '0', '星星之火', '1', '0', '', '', '', 'http://q1.qlogo.cn/g?b=qq&k=QOOwickdIvHem0pg0MJRmicQ&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('690', '', '', '0', '0', '铿锵，青春！', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLlrIZk5vUWzaDZqe7ETxVnXofVfUHdtbom7EcbIGPWOibCIEdia1CcguYFOwAzrNuxAkhR7fz8r2Vw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('691', '', '', '0', '0', '懂得珍惜', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/h05yQwCUib8ZcKbZfBFDMibm0f8qG5d7A1xobWPzfqIxhnomaFcIY9SerOHWVTA90icvN9dAkP6MkVVDb35kXoqag/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('692', '', '', '0', '0', '狼', '1', '0', '', '', '', 'http://q3.qlogo.cn/g?b=qq&k=yWdelQjhLiapvI7CoicXQNKA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('693', '', '', '0', '0', '可可', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLxnG0lldxqgQTjRtA8WB74Gb83LyiaYfSgiapKGyn5aWY3TAjM7ArpiciaHhU4wF9cAY2dPvj49Mia3AA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('694', '', '', '0', '0', '酒是故乡醇', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=DHepoCJibE9VM2eG5UHL2jg&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('695', '', '', '0', '0', '时间为我留影过往', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/tlM8WhGvibNHSxfARYKso4OcGCNW5DTc4BRmbGHqTJNcG2EEJdaJvO77XVHicMeXWgn85icSLljiaTHCC8JkdUHzLA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('696', '', '', '0', '0', '川哥', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTK7WRtaqmx28Iib7A2prHu0nu8mHTSdmsibA0HssGB19Gtrz0OV96zyypFxUMsraSqdcxPP3yyMrib2A/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('697', '', '', '0', '0', '説書先生', '2', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=siauSeStuiauY3DhP6r2fJKA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('698', '', '', '0', '0', '一刀', '1', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTK2B2lS6OYAVT9dGLc0ZKZWJjEbGibfNMXfRAc32CVpuL2lztds1A5Owu6L0MR1Zevta31Zx6y6VwQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('699', '', '', '0', '0', '张立', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83erwBvXKKVpILwf4H61qzicrRo7LfP4R7XmR9qKGVwqYyc20A91MibBAjx5rWAcib1vweL4FyfgVicGhng/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('700', '', '', '0', '0', '简爱', '1', '0', '', '', '', 'http://q2.qlogo.cn/g?b=qq&k=uhribJQoaLtyRDX5mcT39sA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('701', '', '', '0', '0', '请等待', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/dLviaz3IsSQs7Ledr5gqpmEvgWQouH1qVQQSiaTT37eRtvpVVtsq34vd816wiaVB81mibTqk9vPslqrbibcVtO4kicoQ/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('702', '', '', '0', '0', '懂你', '1', '0', '', '', '', 'http://q4.qlogo.cn/g?b=qq&k=m9s37Qgy13DzN9JIAKXGEA&s=40&t=1527955200', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('703', '', '', '0', '0', '云', '2', '0', '', '', '', 'http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIM0aLd8cjg35O8hAF4icKqj4WiauicTR9QFaZpkDIUS6wlESiadndNShu0PAcN9MOU4iayvGZSIZyEjaw/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);
INSERT INTO `yf_hf_member_robot` VALUES ('704', '', '', '0', '0', '黄文', '2', '0', '', '', '', 'http://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83ersjucuS0zawO3icQyibOJqOiabjvPlChCWGTWSqKwiasCug6IIPIP4g461OjSCGY9TNGTeljJN2g0PPA/132', '4', '0', '', '', '0', '', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '', '0', '1', 'offline', null, null);

-- ----------------------------
-- Table structure for yf_hf_music
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_music`;
CREATE TABLE `yf_hf_music` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '音乐id',
  `music_url` varchar(255) NOT NULL DEFAULT '' COMMENT '音乐链接',
  `image_url` varchar(255) NOT NULL DEFAULT '' COMMENT '音乐封面图',
  `title` varchar(50) NOT NULL COMMENT '标题',
  `time` varchar(20) NOT NULL DEFAULT '' COMMENT '音乐时长',
  `create_time` int(10) DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_music
-- ----------------------------
INSERT INTO `yf_hf_music` VALUES ('6', 'http://p9qck5myp.bkt.clouddn.com/%E6%88%91%E7%9A%84%E5%AE%9D%E8%B4%9D-LD.mp3', '/uploads/picture/2018-06-05/5b1650e22890b.png', '甜蜜', '67', '1524814447', '1528360323');
INSERT INTO `yf_hf_music` VALUES ('7', 'http://p9qck5myp.bkt.clouddn.com/%E5%A4%B1%E6%81%8B%E8%80%85%E8%81%94%E7%9B%9F-LD.mp3', '/uploads/picture/2018-06-05/5b164dc5048cb.png', '怀旧', '59', '1524815023', '1528361089');
INSERT INTO `yf_hf_music` VALUES ('13', 'http://p9qck5myp.bkt.clouddn.com/%E5%A4%9A%E5%B9%B8%E8%BF%90-LD.mp3', '/uploads/picture/2018-06-07/5b18a0a165f84.png', '浪漫', '88', '1526899043', '1528361154');
INSERT INTO `yf_hf_music` VALUES ('14', 'http://p9qck5myp.bkt.clouddn.com/%E6%88%91%E7%88%B1%E4%BD%A0%E4%BA%B2%E7%88%B1%E7%9A%84-LD.mp3', '/uploads/picture/2018-06-07/5b189f766807e.png', '家庭', '24', '1528188905', '1528361058');
INSERT INTO `yf_hf_music` VALUES ('16', 'http://p9qck5myp.bkt.clouddn.com/trip-LD.mp3', '/uploads/picture/2018-06-07/5b18a076c1112.png', '纯音乐', '19', '1528340604', '1528360948');
INSERT INTO `yf_hf_music` VALUES ('17', 'http://p9qck5myp.bkt.clouddn.com/%E5%8F%91%E7%8E%B0-LD.mp3', '/uploads/picture/2018-06-07/5b18a1355c25d.png', '抒情', '54', '1528340792', '1528361121');
INSERT INTO `yf_hf_music` VALUES ('18', 'http://p9qck5myp.bkt.clouddn.com/%E6%97%A7%E6%97%B6%E5%85%89-LD.mp3', '/uploads/picture/2018-06-07/5b18a16e64d58.png', '民谣', '61', '1528340851', '1528360894');
INSERT INTO `yf_hf_music` VALUES ('19', 'http://p9qck5myp.bkt.clouddn.com/%E8%AE%A4%E7%9C%9F%E7%9A%84%E9%9B%AA-LD.mp3', '/uploads/picture/2018-06-07/5b18a1acbe4d6.png', '舒缓', '49', '1528340913', '1528360839');
INSERT INTO `yf_hf_music` VALUES ('20', 'http://p9qck5myp.bkt.clouddn.com/%E5%92%96%E5%96%B1%E5%92%96%E5%96%B1-LD.mp3', '/uploads/picture/2018-06-13/5b20c26a4b778.png', '愉快', '58', '1528340957', '1528873578');
INSERT INTO `yf_hf_music` VALUES ('21', 'http://p9qck5myp.bkt.clouddn.com/%E9%97%B7-LD.mp3', '/uploads/picture/2018-06-07/5b18a20b7576a.png', '无聊', '55', '1528341013', '1528360687');
INSERT INTO `yf_hf_music` VALUES ('22', 'http://p9qck5myp.bkt.clouddn.com/%E5%8F%AF%E7%88%B1%E9%A2%82-LD.mp3', '/uploads/picture/2018-06-07/5b18a238cc1ec.png', '可爱', '43', '1528341051', '1528360641');
INSERT INTO `yf_hf_music` VALUES ('23', 'http://p9qck5myp.bkt.clouddn.com/%E7%BB%93%E5%A9%9A%E5%90%A7-LD.mp3', '/uploads/picture/2018-06-07/5b18a26dd2775.png', '居家', '63', '1528341104', '1528360608');
INSERT INTO `yf_hf_music` VALUES ('24', 'http://p9qck5myp.bkt.clouddn.com/%E9%86%89-LD.mp3', '/uploads/picture/2018-06-07/5b18a28fdb252.png', '流行', '59', '1528341137', '1528360584');
INSERT INTO `yf_hf_music` VALUES ('25', 'http://p9qck5myp.bkt.clouddn.com/%E6%9C%89%E4%BD%95%E4%B8%8D%E5%8F%AF-LD.mp3', '/uploads/picture/2018-06-07/5b18a2b6d07bf.png', '轻快', '80', '1528341180', '1528360974');
INSERT INTO `yf_hf_music` VALUES ('26', 'http://p9qck5myp.bkt.clouddn.com/%E5%8D%88%E9%A4%90-LD.mp3', '/uploads/picture/2018-06-07/5b18a2f07a246.png', '民谣', '83', '1528341237', '1528360553');
INSERT INTO `yf_hf_music` VALUES ('27', 'http://p9qck5myp.bkt.clouddn.com/%E7%AE%97%E4%BD%A0%E7%8B%A0-LD.mp3', '/uploads/picture/2018-06-07/5b18fe9413a35.png', '节奏', '52', '1528341321', '1528364693');
INSERT INTO `yf_hf_music` VALUES ('28', 'http://p9qck5myp.bkt.clouddn.com/%E6%9C%89%E7%82%B9%E7%94%9C-LD.mp3', '/uploads/picture/2018-06-13/5b20c28002786.png', '甜心', '37', '1528341413', '1528873601');
INSERT INTO `yf_hf_music` VALUES ('29', 'http://p9qck5myp.bkt.clouddn.com/%E5%A5%87%E5%A6%99%E8%83%BD%E5%8A%9B%E6%AD%8C-LD.mp3', '/uploads/picture/2018-06-13/5b20c240866b8.png', '宁静', '46', '1528341501', '1528873537');
INSERT INTO `yf_hf_music` VALUES ('30', 'http://p9qck5myp.bkt.clouddn.com/%E8%BF%9C%E8%B5%B0%E9%AB%98%E9%A3%9E-LD.mp3', '/uploads/picture/2018-06-13/5b20c2022e096.png', '奔放', '72', '1528341621', '1528873475');
INSERT INTO `yf_hf_music` VALUES ('31', 'http://p9qck5myp.bkt.clouddn.com/GQ-LD.mp3', '/uploads/picture/2018-06-13/5b20c0509eaec.png', '欧美', '49', '1528341682', '1528873043');

-- ----------------------------
-- Table structure for yf_hf_note_log
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_note_log`;
CREATE TABLE `yf_hf_note_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '短信发送记录表（注册/登陆/找回密码/其他...）',
  `ip` varchar(100) NOT NULL DEFAULT '' COMMENT 'ip地址',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '发送手机号',
  `template_msg` varchar(255) DEFAULT '' COMMENT '短信模板',
  `code` varchar(20) DEFAULT '' COMMENT '短信code',
  `is_success` tinyint(2) DEFAULT '1' COMMENT '是否发送成功 1成功 2失败',
  `app_version` varchar(20) NOT NULL COMMENT '用户当前版本',
  `send_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '发送时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=951 DEFAULT CHARSET=utf8 COMMENT='短信记录';

-- ----------------------------
-- Records of yf_hf_note_log
-- ----------------------------
INSERT INTO `yf_hf_note_log` VALUES ('1', '180.162.250.137', '13524893873', '【同联商业】您的验证码为8868，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '8868', '1', '1.0.0', '2018-05-21 12:05:06');
INSERT INTO `yf_hf_note_log` VALUES ('2', '180.162.250.137', '13524893873', '【同联商业】您的验证码为8868，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '8868', '1', '1.0.0', '2018-05-21 12:05:06');
INSERT INTO `yf_hf_note_log` VALUES ('3', '180.162.250.137', '18616812909', '【同联商业】您的验证码为4688，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '4688', '1', '1.0.0', '2018-05-21 13:36:55');
INSERT INTO `yf_hf_note_log` VALUES ('4', '180.162.250.137', '18516014525', '【同联商业】您的验证码为5362，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '5362', '1', '1.0.0', '2018-05-21 13:47:02');
INSERT INTO `yf_hf_note_log` VALUES ('5', '180.162.250.137', '17638103673', '【同联商业】您的验证码为6570，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '6570', '1', '1.0.0', '2018-05-21 14:04:52');
INSERT INTO `yf_hf_note_log` VALUES ('6', '180.162.250.137', '18616812909', '【同联商业】您的验证码为2731，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '2731', '1', '1.0.0', '2018-05-21 14:05:56');
INSERT INTO `yf_hf_note_log` VALUES ('7', '180.162.250.137', '18616812914', '【同联商业】您的验证码为4592，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '4592', '1', '1.0.0', '2018-05-21 14:08:15');
INSERT INTO `yf_hf_note_log` VALUES ('8', '101.81.75.122', '18516014525', '【同联商业】您的验证码为3667，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '3667', '1', '1.0.0', '2018-05-21 14:56:02');
INSERT INTO `yf_hf_note_log` VALUES ('9', '127.0.0.1', '18616800000', '【同联商业】您的验证码为5847，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '5847', '1', '1.0.0', '2018-05-21 16:36:17');
INSERT INTO `yf_hf_note_log` VALUES ('10', '127.0.0.1', '18616800001', '【同联商业】您的验证码为7386，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '7386', '1', '1.0.0', '2018-05-21 16:38:51');
INSERT INTO `yf_hf_note_log` VALUES ('11', '116.225.66.138', '18616800001', '【同联商业】您的验证码为9749，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '9749', '1', '1.0.0', '2018-05-21 16:42:44');
INSERT INTO `yf_hf_note_log` VALUES ('12', '116.225.66.138', '18616812914', '【同联商业】您的验证码为7638，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '7638', '1', '1.0.0', '2018-05-21 16:43:11');
INSERT INTO `yf_hf_note_log` VALUES ('13', '127.0.0.1', '18616800000', '【同联商业】您的验证码为2957，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '2957', '1', '1.0.0', '2018-05-21 16:46:36');
INSERT INTO `yf_hf_note_log` VALUES ('14', '127.0.0.1', '18616800001', '【同联商业】您的验证码为3423，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '3423', '1', '1.0.0', '2018-05-21 16:55:37');
INSERT INTO `yf_hf_note_log` VALUES ('15', '127.0.0.1', '18616800002', '【同联商业】您的验证码为1095，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '1095', '1', '1.0.0', '2018-05-21 17:06:26');
INSERT INTO `yf_hf_note_log` VALUES ('16', '116.225.66.138', '18616812914', '【同联商业】您的验证码为3711，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '3711', '1', '1.0.0', '2018-05-21 18:48:22');
INSERT INTO `yf_hf_note_log` VALUES ('17', '61.171.201.170', '18516014528', '【同联商业】您的验证码为4031，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '4031', '1', '1.0.0', '2018-05-21 23:33:36');
INSERT INTO `yf_hf_note_log` VALUES ('18', '61.171.201.170', '18516014525', '【同联商业】您的验证码为3142，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '3142', '1', '1.0.0', '2018-05-21 23:34:36');
INSERT INTO `yf_hf_note_log` VALUES ('19', '127.0.0.1', '18616812914', '【同联商业】您的验证码为1198，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '1198', '1', '1.0.0', '2018-05-22 09:58:32');
INSERT INTO `yf_hf_note_log` VALUES ('20', '116.225.66.138', '18516014525', '【同联商业】您的验证码为2157，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '2157', '1', '1.0.0', '2018-05-22 11:06:34');
INSERT INTO `yf_hf_note_log` VALUES ('21', '101.90.124.36', '18964231232', '【同联商业】您的验证码为1988，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '1988', '1', '1.0.0', '2018-05-22 16:39:19');
INSERT INTO `yf_hf_note_log` VALUES ('22', '180.162.250.174', '13524893873', '【同联商业】您的验证码为8431，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '8431', '1', '1.0.0', '2018-05-22 18:53:56');
INSERT INTO `yf_hf_note_log` VALUES ('23', '61.171.201.170', '18516014525', '【同联商业】您的验证码为4641，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '4641', '1', '1.0.0', '2018-05-22 23:10:10');
INSERT INTO `yf_hf_note_log` VALUES ('24', '180.162.250.174', '17621859931', '【同联商业】您的验证码为5650，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '5650', '1', '1.0.0', '2018-05-23 17:25:59');
INSERT INTO `yf_hf_note_log` VALUES ('25', '180.162.250.174', '18815762077', '【同联商业】您的验证码为1913，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '1913', '1', '1.0.0', '2018-05-24 10:35:54');
INSERT INTO `yf_hf_note_log` VALUES ('26', '180.162.250.174', '18616812914', '【同联商业】您本次的验证码为：1376，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '1376', '1', '1.0.0', '2018-05-24 10:55:49');
INSERT INTO `yf_hf_note_log` VALUES ('27', '223.104.212.90', '18815762077', '【同联商业】您的验证码为1542，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '1542', '1', '1.0.0', '2018-05-24 11:10:48');
INSERT INTO `yf_hf_note_log` VALUES ('28', '223.104.212.90', '15821759915', '【同联商业】您的验证码为4974，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '4974', '1', '1.0.0', '2018-05-24 11:12:03');
INSERT INTO `yf_hf_note_log` VALUES ('29', '180.162.250.174', '18516014525', '【同联商业】您本次的验证码为：7690，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '7690', '1', '1.0.0', '2018-05-24 17:08:33');
INSERT INTO `yf_hf_note_log` VALUES ('30', '180.162.250.174', '18516014525', '【同联商业】您本次的验证码为：9653，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '9653', '1', '1.0.0', '2018-05-24 17:19:40');
INSERT INTO `yf_hf_note_log` VALUES ('31', '180.162.250.174', '18516014525', '【同联商业】您本次的验证码为：7763，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '7763', '1', '1.0.0', '2018-05-24 17:25:44');
INSERT INTO `yf_hf_note_log` VALUES ('32', '180.162.250.174', '18516014525', '【同联商业】您本次的验证码为：8539，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '8539', '1', '1.0.0', '2018-05-24 17:47:25');
INSERT INTO `yf_hf_note_log` VALUES ('33', '180.162.250.174', '17621859931', '【同联商业】您本次的验证码为：8722，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '8722', '1', '1.0.0', '2018-05-24 17:48:12');
INSERT INTO `yf_hf_note_log` VALUES ('34', '112.65.61.5', '17621859931', '【同联商业】您本次的验证码为：2790，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '2790', '1', '1.0.0', '2018-05-24 18:08:57');
INSERT INTO `yf_hf_note_log` VALUES ('35', '112.65.61.5', '17621859931', '【同联商业】您本次的验证码为：3462，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '3462', '1', '1.0.0', '2018-05-24 19:48:22');
INSERT INTO `yf_hf_note_log` VALUES ('36', '112.65.61.5', '17621859931', '【同联商业】您本次的验证码为：6004，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '6004', '1', '1.0.0', '2018-05-24 19:56:12');
INSERT INTO `yf_hf_note_log` VALUES ('37', '112.65.61.5', '17621859931', '【同联商业】您本次的验证码为：7642，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '7642', '1', '1.0.0', '2018-05-24 20:01:09');
INSERT INTO `yf_hf_note_log` VALUES ('38', '180.162.250.174', '17621859931', '【同联商业】您的验证码为4870，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '4870', '1', '1.0.0', '2018-05-25 10:01:55');
INSERT INTO `yf_hf_note_log` VALUES ('39', '180.162.250.174', '17621859931', '【同联商业】您本次的验证码为：5528，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '5528', '1', '1.0.0', '2018-05-25 10:04:17');
INSERT INTO `yf_hf_note_log` VALUES ('40', '180.162.250.174', '17621859931', '【同联商业】您本次的验证码为：3547，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '3547', '1', '1.0.0', '2018-05-25 10:15:08');
INSERT INTO `yf_hf_note_log` VALUES ('41', '180.162.250.174', '17621859931', '【同联商业】您本次的验证码为：9070，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '9070', '1', '1.0.0', '2018-05-25 10:40:07');
INSERT INTO `yf_hf_note_log` VALUES ('42', '116.225.66.138', '17621859931', '【同联商业】您本次的验证码为：2197，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '2197', '1', '1.0.0', '2018-05-25 11:18:14');
INSERT INTO `yf_hf_note_log` VALUES ('43', '180.162.250.174', '18616812914', '【同联商业】您的验证码为7451，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '7451', '1', '1.0.0', '2018-05-25 17:35:27');
INSERT INTO `yf_hf_note_log` VALUES ('44', '112.65.61.6', '17621859931', '【同联商业】您本次的验证码为：8153，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '8153', '1', '1.0.0', '2018-05-25 17:37:21');
INSERT INTO `yf_hf_note_log` VALUES ('45', '180.162.250.174', '18616812914', '【同联商业】您本次的验证码为：5597，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '5597', '1', '1.0.0', '2018-05-25 17:40:15');
INSERT INTO `yf_hf_note_log` VALUES ('46', '180.162.250.174', '18616812914', '【同联商业】您本次的验证码为：3873，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '3873', '1', '1.0.0', '2018-05-25 17:51:22');
INSERT INTO `yf_hf_note_log` VALUES ('47', '180.162.250.174', '18616812914', '【同联商业】您本次的验证码为：4696，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '4696', '1', '1.0.0', '2018-05-25 17:55:35');
INSERT INTO `yf_hf_note_log` VALUES ('48', '180.162.250.174', '18616812914', '【同联商业】您本次的验证码为：5807，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '5807', '1', '1.0.0', '2018-05-25 18:16:12');
INSERT INTO `yf_hf_note_log` VALUES ('49', '180.162.250.174', '18616812914', '【同联商业】您本次的验证码为：3355，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '3355', '1', '1.0.0', '2018-05-25 18:17:58');
INSERT INTO `yf_hf_note_log` VALUES ('50', '114.93.164.44', '13482498882', '【同联商业】您的验证码为1932，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '1932', '1', '1.0.0', '2018-05-25 22:58:45');
INSERT INTO `yf_hf_note_log` VALUES ('51', '114.93.164.44', '13482498882', '【同联商业】您的验证码为9950，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '9950', '1', '1.0.0', '2018-05-25 22:59:45');
INSERT INTO `yf_hf_note_log` VALUES ('52', '116.237.100.22', '15502198310', '【同联商业】您的验证码为3776，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '3776', '1', '1.0.0', '2018-05-25 23:00:04');
INSERT INTO `yf_hf_note_log` VALUES ('53', '116.237.100.22', '15502198310', '【同联商业】您的验证码为2069，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '2069', '1', '1.0.0', '2018-05-25 23:01:05');
INSERT INTO `yf_hf_note_log` VALUES ('54', '112.64.68.221', '18516014525', '【同联商业】您的验证码为2955，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '2955', '1', '1.0.0', '2018-05-25 23:02:33');
INSERT INTO `yf_hf_note_log` VALUES ('55', '114.93.164.44', '13482498882', '【同联商业】您的验证码为9648，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '9648', '1', '1.0.0', '2018-05-25 23:12:02');
INSERT INTO `yf_hf_note_log` VALUES ('56', '220.112.121.28', '18101725237', '【同联商业】您的验证码为6564，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '6564', '1', '1.0.0', '2018-05-27 09:31:31');
INSERT INTO `yf_hf_note_log` VALUES ('57', '220.112.121.28', '18101725237', '【同联商业】您的验证码为4743，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '4743', '1', '1.0.0', '2018-05-27 09:35:04');
INSERT INTO `yf_hf_note_log` VALUES ('58', '220.112.121.28', '15821506181', '【同联商业】您的验证码为6628，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '6628', '1', '1.0.0', '2018-05-27 09:37:47');
INSERT INTO `yf_hf_note_log` VALUES ('59', '220.112.121.28', '18101725237', '【同联商业】您的验证码为7822，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '7822', '1', '1.0.0', '2018-05-27 09:38:27');
INSERT INTO `yf_hf_note_log` VALUES ('60', '180.175.107.14', '18616812914', '【同联商业】您的验证码为1213，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '1213', '1', '1.0.0', '2018-05-27 10:10:50');
INSERT INTO `yf_hf_note_log` VALUES ('61', '180.175.107.14', '18101725237', '【同联商业】您的验证码为9823，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '9823', '1', '1.0.0', '2018-05-27 10:13:30');
INSERT INTO `yf_hf_note_log` VALUES ('62', '220.112.121.28', '18616812914', '【同联商业】您的验证码为9369，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '9369', '1', '1.0.0', '2018-05-27 10:15:24');
INSERT INTO `yf_hf_note_log` VALUES ('63', '220.112.121.28', '18616812914', '【同联商业】您的验证码为1808，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '1808', '1', '1.0.0', '2018-05-27 10:18:17');
INSERT INTO `yf_hf_note_log` VALUES ('64', '127.0.0.1', '18101725237', '【同联商业】您的验证码为1785，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '1785', '1', '1.0.0', '2018-05-27 10:23:22');
INSERT INTO `yf_hf_note_log` VALUES ('73', '180.162.250.174', '18616812914', '【同联商业】您本次的验证码为：8265，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '8265', '1', '1.0.0', '2018-05-28 11:22:05');
INSERT INTO `yf_hf_note_log` VALUES ('74', '180.162.250.174', '17621859931', '【同联商业】您本次的验证码为：9854，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '9854', '1', '1.0.0', '2018-05-28 11:29:40');
INSERT INTO `yf_hf_note_log` VALUES ('75', '180.162.250.174', '18616812914', '【同联商业】您本次的验证码为：5090，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '5090', '1', '1.0.0', '2018-05-28 11:31:03');
INSERT INTO `yf_hf_note_log` VALUES ('76', '180.162.250.174', '17621859931', '【同联商业】您本次的验证码为：8345，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '8345', '1', '1.0.0', '2018-05-28 11:39:06');
INSERT INTO `yf_hf_note_log` VALUES ('77', '127.0.0.1', '13869472562', '【同联商业】你的朋友马冬梅邀请你来使用嗨房啦，输入邀请码：0000XX，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000XX', '1', '1.0.0', '2018-05-28 15:18:49');
INSERT INTO `yf_hf_note_log` VALUES ('78', '114.91.76.133', '18516014525', '【同联商业】您的验证码为2317，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '2317', '1', '1.0.0', '2018-05-28 15:23:38');
INSERT INTO `yf_hf_note_log` VALUES ('79', '127.0.0.1', '13869472562', '【同联商业】你的朋友马冬梅邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=445，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000XX', '1', '1.0.0', '2018-05-28 15:27:59');
INSERT INTO `yf_hf_note_log` VALUES ('80', '114.91.76.133', '13869472562', '【同联商业】你的朋友马冬梅邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=445，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000XX', '1', '1.0.0', '2018-05-28 15:36:28');
INSERT INTO `yf_hf_note_log` VALUES ('81', '114.91.76.133', '18516014525', '【同联商业】您的验证码为4759，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '4759', '1', '1.0.0', '2018-05-28 15:39:29');
INSERT INTO `yf_hf_note_log` VALUES ('82', '114.91.76.133', '13869472562', '【同联商业】你的朋友马冬梅邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=445，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000XX', '1', '1.0.0', '2018-05-28 15:42:13');
INSERT INTO `yf_hf_note_log` VALUES ('83', '114.91.76.133', '13677579777', '【同联商业】你的朋友老衲洗发用飘柔邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=513，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000OV', '1', '1.0.0', '2018-05-28 15:45:18');
INSERT INTO `yf_hf_note_log` VALUES ('84', '114.91.76.133', '17621859931', '【同联商业】您的验证码为8736，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '8736', '1', '1.0.0', '2018-05-28 16:25:42');
INSERT INTO `yf_hf_note_log` VALUES ('85', '114.91.76.133', '18516014525', '【同联商业】您的验证码为2265，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '2265', '1', '1.0.0', '2018-05-29 10:33:01');
INSERT INTO `yf_hf_note_log` VALUES ('86', '114.91.76.133', '18516014525', '【同联商业】您的验证码为6506，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '6506', '1', '1.0.0', '2018-05-29 14:29:19');
INSERT INTO `yf_hf_note_log` VALUES ('87', '114.91.76.133', '18516014525', '【同联商业】您的验证码为6451，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '6451', '1', '1.0.0', '2018-05-29 14:38:31');
INSERT INTO `yf_hf_note_log` VALUES ('88', '114.91.76.133', '18516014525', '【同联商业】您的验证码为2948，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '2948', '1', '1.0.0', '2018-05-29 14:58:04');
INSERT INTO `yf_hf_note_log` VALUES ('89', '223.104.210.119', '186 1681 2914', '【同联商业】你的朋友老衲洗发用飘柔邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=513，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000OV', '1', '1.0.0', '2018-05-29 15:03:25');
INSERT INTO `yf_hf_note_log` VALUES ('90', '223.104.210.119', '158 2175 9915', '【同联商业】你的朋友老衲洗发用飘柔邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=513，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000OV', '1', '1.0.0', '2018-05-29 15:05:30');
INSERT INTO `yf_hf_note_log` VALUES ('91', '223.104.210.119', '158 2175 9915', '【同联商业】你的朋友老衲洗发用飘柔邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=513，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000OV', '1', '1.0.0', '2018-05-29 15:09:55');
INSERT INTO `yf_hf_note_log` VALUES ('92', '223.104.210.119', '18516014525', '【同联商业】您的验证码为6793，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '6793', '1', '1.0.0', '2018-05-29 18:26:36');
INSERT INTO `yf_hf_note_log` VALUES ('93', '61.171.201.170', '15005531473', '【同联商业】你的朋友像我这样的人邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=575，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000IP', '1', '1.0.0', '2018-05-29 23:40:19');
INSERT INTO `yf_hf_note_log` VALUES ('94', '61.171.201.170', '15005531473', '【同联商业】你的朋友像我这样的人邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=575，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000IP', '1', '1.0.0', '2018-05-29 23:40:19');
INSERT INTO `yf_hf_note_log` VALUES ('95', '61.171.201.170', '15005531473', '【同联商业】你的朋友像我这样的人邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=575，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000IP', '1', '1.0.0', '2018-05-29 23:40:19');
INSERT INTO `yf_hf_note_log` VALUES ('96', '61.171.201.170', '15005531473', '【同联商业】你的朋友像我这样的人邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=575，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000IP', '1', '1.0.0', '2018-05-29 23:40:19');
INSERT INTO `yf_hf_note_log` VALUES ('97', '114.91.76.133', '18516014525', '【同联商业】您的验证码为7481，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '7481', '1', '1.0.0', '2018-05-30 10:25:29');
INSERT INTO `yf_hf_note_log` VALUES ('98', '114.91.76.133', '18516014528', '【同联商业】您的验证码为3604，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '3604', '1', '1.0.0', '2018-05-30 10:57:54');
INSERT INTO `yf_hf_note_log` VALUES ('99', '114.91.76.133', '18516014525', '【同联商业】您的验证码为8892，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '8892', '1', '1.0.0', '2018-05-30 13:40:36');
INSERT INTO `yf_hf_note_log` VALUES ('100', '114.91.76.133', '17717536290', '【同联商业】您的验证码为8212，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '8212', '1', '1.0.0', '2018-05-30 14:23:21');
INSERT INTO `yf_hf_note_log` VALUES ('101', '223.104.213.99', '18815762077', '【同联商业】您的验证码为7844，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '7844', '1', '1.0.0', '2018-05-30 14:59:10');
INSERT INTO `yf_hf_note_log` VALUES ('102', '223.104.213.99', '15821759915', '【同联商业】您的验证码为9216，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '9216', '1', '1.0.0', '2018-05-30 15:01:14');
INSERT INTO `yf_hf_note_log` VALUES ('103', '223.104.213.99', '186 1681 2914', '【同联商业】你的朋友老衲洗发用飘柔邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=513，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000OV', '1', '1.0.0', '2018-05-30 16:47:25');
INSERT INTO `yf_hf_note_log` VALUES ('104', '223.104.213.99', '158 2175 9915', '【同联商业】你的朋友老衲洗发用飘柔邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=513，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000OV', '1', '1.0.0', '2018-05-30 16:49:56');
INSERT INTO `yf_hf_note_log` VALUES ('105', '223.104.213.99', '186 1681 2914', '【同联商业】你的朋友老衲洗发用飘柔邀请你来使用嗨房啦，点击此页面进行注册：www.haifang.com/xxx/xxx/xxx?userid=513，一起玩吧！请于5分钟内正确输入，如非本人操作，请忽略此短信。', '0000OV', '1', '1.0.0', '2018-05-30 16:50:09');
INSERT INTO `yf_hf_note_log` VALUES ('106', '114.91.76.133', '17717536290', '【同联商业】您的验证码为3170，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '3170', '1', '1.0.0', '2018-05-30 18:46:18');
INSERT INTO `yf_hf_note_log` VALUES ('107', '114.91.76.133', '15601652351', '【同联商业】您的验证码为7709，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '7709', '1', '1.0.0', '2018-05-30 18:50:39');
INSERT INTO `yf_hf_note_log` VALUES ('108', '114.91.76.133', '15601652351', '【同联商业】您的验证码为4839，请于5分钟内正确输入，如非本人操作，请忽略此短信。', '4839', '1', '1.0.0', '2018-05-30 18:52:45');

-- ----------------------------
-- Table structure for yf_hf_phpmailer
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_phpmailer`;
CREATE TABLE `yf_hf_phpmailer` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL COMMENT '发布视频的用户id',
  `video_id` int(11) DEFAULT NULL COMMENT '视频id',
  `type` tinyint(1) DEFAULT '0' COMMENT '1发布视频 2身份认证',
  `create_time` int(11) DEFAULT '0',
  `update_time` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_phpmailer
-- ----------------------------
INSERT INTO `yf_hf_phpmailer` VALUES ('1', '514', '1042', '1', '1529896813', '1529896813');
INSERT INTO `yf_hf_phpmailer` VALUES ('2', '579', '1044', '1', '1529916103', '1529916103');
INSERT INTO `yf_hf_phpmailer` VALUES ('3', '579', '1048', '1', '1529917055', '1529917055');

-- ----------------------------
-- Table structure for yf_hf_question
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_question`;
CREATE TABLE `yf_hf_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '问题id',
  `title` varchar(255) NOT NULL COMMENT '问题标题',
  `content` varchar(255) NOT NULL COMMENT '问题内容',
  `type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '0举报1常见问题',
  `create_time` int(10) DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_question
-- ----------------------------
INSERT INTO `yf_hf_question` VALUES ('1', '嗨币有什么用?', '<p>嗨币的用处有两个:1,购买视频观看量. 2,10个嗨币价值1元钱,累计满500个嗨币后,可兑换50元红包进行支付宝提现.</p><p>555kkkkjjj j我认为</p><p>饿的翁额</p>', '1', '1524900739', '1530611756');
INSERT INTO `yf_hf_question` VALUES ('3', '嗨币如何获取', '<p>通过发布视频,转发视频都有可能随机获取嗨币哦</p>', '1', '1525747760', '1530611732');
INSERT INTO `yf_hf_question` VALUES ('6', '广告太多', '', '0', '1524900739', '1524900756');
INSERT INTO `yf_hf_question` VALUES ('8', '假房源', '', '0', '1527833211', '1527833211');
INSERT INTO `yf_hf_question` VALUES ('11', '广告内容,非视频内容', '', '0', '1528077191', '1528077191');

-- ----------------------------
-- Table structure for yf_hf_redpacket
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_redpacket`;
CREATE TABLE `yf_hf_redpacket` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) DEFAULT NULL COMMENT '本用户id',
  `enter_id` int(11) DEFAULT NULL COMMENT '进入邀请，被邀请人id',
  `num` int(11) DEFAULT NULL COMMENT '本记录为该用户的第几条记录',
  `money` varchar(20) DEFAULT NULL COMMENT '奖励金额',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_redpacket
-- ----------------------------
INSERT INTO `yf_hf_redpacket` VALUES ('42', '473', '245', '1', '4.5', '1530695292', '1530695292');
INSERT INTO `yf_hf_redpacket` VALUES ('43', '473', '785', '2', '4.0', '1530695292', '1530695292');
INSERT INTO `yf_hf_redpacket` VALUES ('44', '473', '149', '3', '2.0', '1530695292', '1530695292');
INSERT INTO `yf_hf_redpacket` VALUES ('45', '473', '753', '4', '5.8', '1530695292', '1530695292');
INSERT INTO `yf_hf_redpacket` VALUES ('46', '473', '2054', '5', '4.1', '1530695292', '1530695292');
INSERT INTO `yf_hf_redpacket` VALUES ('47', '473', '2216', '6', '2.6', '1530695292', '1530695292');
INSERT INTO `yf_hf_redpacket` VALUES ('48', '473', '579', '7', '4.4', '1530695292', '1530695292');
INSERT INTO `yf_hf_redpacket` VALUES ('49', '473', '579', '8', '1.7', '1530695292', '1530695292');
INSERT INTO `yf_hf_redpacket` VALUES ('50', '473', '0', '9', '0.2', '1530695292', '1530695292');
INSERT INTO `yf_hf_redpacket` VALUES ('51', '473', '0', '10', '0.7', '1530695292', '1530695292');
INSERT INTO `yf_hf_redpacket` VALUES ('112', '512', '570', '1', '4.4', '1530757463', '1530757463');
INSERT INTO `yf_hf_redpacket` VALUES ('113', '512', '473', '2', '2.9', '1530757463', '1530757463');
INSERT INTO `yf_hf_redpacket` VALUES ('114', '512', '0', '3', '2.6', '1530757463', '1530757463');
INSERT INTO `yf_hf_redpacket` VALUES ('115', '512', '0', '4', '4.4', '1530757463', '1530757463');
INSERT INTO `yf_hf_redpacket` VALUES ('116', '512', '0', '5', '2.5', '1530757463', '1530757463');
INSERT INTO `yf_hf_redpacket` VALUES ('117', '512', '0', '6', '3.2', '1530757464', '1530757464');
INSERT INTO `yf_hf_redpacket` VALUES ('118', '512', '0', '7', '4.9', '1530757464', '1530757464');
INSERT INTO `yf_hf_redpacket` VALUES ('119', '512', '0', '8', '2.1', '1530757464', '1530757464');
INSERT INTO `yf_hf_redpacket` VALUES ('120', '512', '0', '9', '1.0', '1530757464', '1530757464');
INSERT INTO `yf_hf_redpacket` VALUES ('121', '512', '0', '10', '2', '1530757464', '1530757464');
INSERT INTO `yf_hf_redpacket` VALUES ('122', '2243', '2244', '1', '5.4', '1530779692', '1530779692');
INSERT INTO `yf_hf_redpacket` VALUES ('123', '2243', '2245', '2', '2.8', '1530779692', '1530779692');
INSERT INTO `yf_hf_redpacket` VALUES ('124', '2243', '2246', '3', '2.5', '1530779692', '1530779692');
INSERT INTO `yf_hf_redpacket` VALUES ('125', '2243', '2247', '4', '4.9', '1530779692', '1530779692');
INSERT INTO `yf_hf_redpacket` VALUES ('126', '2243', '2251', '5', '3.6', '1530779692', '1530779692');
INSERT INTO `yf_hf_redpacket` VALUES ('127', '2243', '2252', '6', '2.4', '1530779692', '1530779692');
INSERT INTO `yf_hf_redpacket` VALUES ('128', '2243', '0', '7', '5.9', '1530779692', '1530779692');
INSERT INTO `yf_hf_redpacket` VALUES ('129', '2243', '0', '8', '0.9', '1530779692', '1530779692');
INSERT INTO `yf_hf_redpacket` VALUES ('130', '2243', '0', '9', '0.4', '1530779692', '1530779692');
INSERT INTO `yf_hf_redpacket` VALUES ('131', '2243', '0', '10', '1.2', '1530779692', '1530779692');
INSERT INTO `yf_hf_redpacket` VALUES ('132', '2247', '2248', '1', '4.5', '1530851853', '1530851853');
INSERT INTO `yf_hf_redpacket` VALUES ('133', '2247', '0', '2', '3.8', '1530851853', '1530851853');
INSERT INTO `yf_hf_redpacket` VALUES ('134', '2247', '0', '3', '3.5', '1530851853', '1530851853');
INSERT INTO `yf_hf_redpacket` VALUES ('135', '2247', '0', '4', '4.8', '1530851853', '1530851853');
INSERT INTO `yf_hf_redpacket` VALUES ('136', '2247', '0', '5', '3.1', '1530851853', '1530851853');
INSERT INTO `yf_hf_redpacket` VALUES ('137', '2247', '0', '6', '2.8', '1530851853', '1530851853');
INSERT INTO `yf_hf_redpacket` VALUES ('138', '2247', '0', '7', '5.6', '1530851853', '1530851853');
INSERT INTO `yf_hf_redpacket` VALUES ('139', '2247', '0', '8', '0.8', '1530851853', '1530851853');
INSERT INTO `yf_hf_redpacket` VALUES ('140', '2247', '0', '9', '0.6', '1530851853', '1530851853');
INSERT INTO `yf_hf_redpacket` VALUES ('141', '2247', '0', '10', '0.5', '1530851853', '1530851853');
INSERT INTO `yf_hf_redpacket` VALUES ('142', '2252', '2253', '1', '4.2', '1530865278', '1530865278');
INSERT INTO `yf_hf_redpacket` VALUES ('143', '2252', '0', '2', '2.5', '1530865278', '1530865278');
INSERT INTO `yf_hf_redpacket` VALUES ('144', '2252', '0', '3', '3.6', '1530865278', '1530865278');
INSERT INTO `yf_hf_redpacket` VALUES ('145', '2252', '0', '4', '4.9', '1530865278', '1530865278');
INSERT INTO `yf_hf_redpacket` VALUES ('146', '2252', '0', '5', '3.3', '1530865278', '1530865278');
INSERT INTO `yf_hf_redpacket` VALUES ('147', '2252', '0', '6', '2.4', '1530865278', '1530865278');
INSERT INTO `yf_hf_redpacket` VALUES ('148', '2252', '0', '7', '4.1', '1530865278', '1530865278');
INSERT INTO `yf_hf_redpacket` VALUES ('149', '2252', '0', '8', '3.0', '1530865278', '1530865278');
INSERT INTO `yf_hf_redpacket` VALUES ('150', '2252', '0', '9', '1.6', '1530865278', '1530865278');
INSERT INTO `yf_hf_redpacket` VALUES ('151', '2252', '0', '10', '0.4', '1530865278', '1530865278');
INSERT INTO `yf_hf_redpacket` VALUES ('152', '2256', '2257', '1', '4.9', '1531816547', '1531816547');
INSERT INTO `yf_hf_redpacket` VALUES ('153', '2256', '0', '2', '2.8', '1531816547', '1531816547');
INSERT INTO `yf_hf_redpacket` VALUES ('154', '2256', '0', '3', '4.2', '1531816547', '1531816547');
INSERT INTO `yf_hf_redpacket` VALUES ('155', '2256', '0', '4', '4.3', '1531816547', '1531816547');
INSERT INTO `yf_hf_redpacket` VALUES ('156', '2256', '0', '5', '1.8', '1531816547', '1531816547');
INSERT INTO `yf_hf_redpacket` VALUES ('157', '2256', '0', '6', '3.4', '1531816547', '1531816547');
INSERT INTO `yf_hf_redpacket` VALUES ('158', '2256', '0', '7', '4.8', '1531816547', '1531816547');
INSERT INTO `yf_hf_redpacket` VALUES ('159', '2256', '0', '8', '2.9', '1531816547', '1531816547');
INSERT INTO `yf_hf_redpacket` VALUES ('160', '2256', '0', '9', '0.0', '1531816547', '1531816547');
INSERT INTO `yf_hf_redpacket` VALUES ('161', '2256', '0', '10', '0.9', '1531816547', '1531816547');

-- ----------------------------
-- Table structure for yf_hf_report
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_report`;
CREATE TABLE `yf_hf_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '举报人id',
  `video_id` int(11) NOT NULL COMMENT '被举报视频id',
  `content_id` varchar(11) DEFAULT NULL COMMENT '举报内容id,多个id用逗号分隔',
  `status` tinyint(3) DEFAULT '0' COMMENT '举报状态 0审核中 1审核通过 2审核不通过',
  `reason` varchar(255) DEFAULT NULL COMMENT '举报原因',
  `create_time` int(10) DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_report
-- ----------------------------
INSERT INTO `yf_hf_report` VALUES ('41', '587', '694', '6', '2', '111', '1528008159', '1528118630');
INSERT INTO `yf_hf_report` VALUES ('42', '2021', '703', '6,8', '1', null, '1528019484', '1528095395');
INSERT INTO `yf_hf_report` VALUES ('43', '473', '705', '6', '1', null, '1528021046', '1528021081');
INSERT INTO `yf_hf_report` VALUES ('44', '2026', '709', '6', '0', null, '1528030448', '1528030448');
INSERT INTO `yf_hf_report` VALUES ('45', '570', '712', '8', '0', null, '1528076360', '1528076360');
INSERT INTO `yf_hf_report` VALUES ('46', '570', '703', '6', '2', '2222222', '1528076790', '1528120191');
INSERT INTO `yf_hf_report` VALUES ('47', '570', '701', '6', '0', null, '1528077071', '1528077071');
INSERT INTO `yf_hf_report` VALUES ('48', '570', '698', '8', '0', null, '1528077230', '1528077230');
INSERT INTO `yf_hf_report` VALUES ('49', '570', '713', '15,14', '0', null, '1528077393', '1528077393');
INSERT INTO `yf_hf_report` VALUES ('50', '521', '698', '6,8,11', '1', null, '1528077548', '1528187068');
INSERT INTO `yf_hf_report` VALUES ('51', '570', '690', '8', '0', null, '1528077678', '1528077678');
INSERT INTO `yf_hf_report` VALUES ('52', '5', '523', '6,8,11', '0', null, '1528079326', '1528079326');
INSERT INTO `yf_hf_report` VALUES ('53', '570', '691', '11', '0', null, '1528080033', '1528080033');
INSERT INTO `yf_hf_report` VALUES ('54', '570', '694', '11', '0', null, '1528080270', '1528080270');
INSERT INTO `yf_hf_report` VALUES ('55', '570', '717', '11', '0', null, '1528080555', '1528080555');
INSERT INTO `yf_hf_report` VALUES ('56', '513', '717', '11', '0', null, '1528080809', '1528080809');
INSERT INTO `yf_hf_report` VALUES ('57', '513', '718', '6', '0', null, '1528080987', '1528080987');
INSERT INTO `yf_hf_report` VALUES ('58', '513', '713', '11', '0', null, '1528081151', '1528081151');
INSERT INTO `yf_hf_report` VALUES ('59', '5', '611', '6', '0', null, '1528081296', '1528081296');
INSERT INTO `yf_hf_report` VALUES ('60', '449', '718', '6', '1', null, '1528081370', '1528359830');
INSERT INTO `yf_hf_report` VALUES ('61', '449', '712', '6', '2', '12345678900', '1528081567', '1528359846');
INSERT INTO `yf_hf_report` VALUES ('62', '449', '690', '6', '1', null, '1528081853', '1528359855');
INSERT INTO `yf_hf_report` VALUES ('63', '449', '691', '6', '0', null, '1528082772', '1528082772');
INSERT INTO `yf_hf_report` VALUES ('64', '513', '719', '11', '0', null, '1528083533', '1528083533');
INSERT INTO `yf_hf_report` VALUES ('65', '577', '719', '6', '0', null, '1528083804', '1528083804');
INSERT INTO `yf_hf_report` VALUES ('66', '577', '717', '6', '0', null, '1528086399', '1528086399');
INSERT INTO `yf_hf_report` VALUES ('67', '577', '718', '6', '0', null, '1528086630', '1528086630');
INSERT INTO `yf_hf_report` VALUES ('68', '577', '713', '6', '0', null, '1528086758', '1528086758');
INSERT INTO `yf_hf_report` VALUES ('69', '449', '709', '8', '0', null, '1528089442', '1528089442');
INSERT INTO `yf_hf_report` VALUES ('70', '2024', '719', '8', '0', null, '1528089461', '1528089461');
INSERT INTO `yf_hf_report` VALUES ('71', '513', '701', '11', '0', null, '1528090250', '1528090250');
INSERT INTO `yf_hf_report` VALUES ('72', '5', '520', '6', '0', null, '1528094764', '1528094764');
INSERT INTO `yf_hf_report` VALUES ('73', '577', '720', '8', '0', null, '1528094881', '1528094881');
INSERT INTO `yf_hf_report` VALUES ('74', '2021', '720', '6,8,11', '1', null, '1528095372', '1528095516');
INSERT INTO `yf_hf_report` VALUES ('75', '2021', '719', '8', '1', null, '1528095438', '1528095477');
INSERT INTO `yf_hf_report` VALUES ('76', '513', '720', '8', '0', null, '1528095607', '1528095607');
INSERT INTO `yf_hf_report` VALUES ('77', '2025', '724', '8', '1', null, '1528097675', '1528097710');
INSERT INTO `yf_hf_report` VALUES ('78', '513', '740', '8', '1', null, '1528113629', '1528113661');
INSERT INTO `yf_hf_report` VALUES ('79', '513', '737', '8', '1', null, '1528114191', '1528114247');
INSERT INTO `yf_hf_report` VALUES ('80', '2024', '728', '8', '0', null, '1528114921', '1528114921');
INSERT INTO `yf_hf_report` VALUES ('81', '2024', '720', '11', '0', null, '1528114994', '1528114994');
INSERT INTO `yf_hf_report` VALUES ('82', '2024', '718', '11', '0', null, '1528115030', '1528115030');
INSERT INTO `yf_hf_report` VALUES ('83', '514', '742', '8', '2', '1111', '1528118266', '1528118587');
INSERT INTO `yf_hf_report` VALUES ('84', '514', '737', '8', '0', null, '1528118571', '1528118571');
INSERT INTO `yf_hf_report` VALUES ('85', '514', '729', '11', '2', '22', '1528118797', '1528118805');
INSERT INTO `yf_hf_report` VALUES ('86', '522', '746', '8', '1', null, '1528119506', '1528119677');
INSERT INTO `yf_hf_report` VALUES ('87', '2024', '739', '6', '0', null, '1528120591', '1528120591');
INSERT INTO `yf_hf_report` VALUES ('88', '570', '755', '11', '0', null, '1528175194', '1528175194');
INSERT INTO `yf_hf_report` VALUES ('89', '2062', '756', '8', '1', null, '1528175602', '1528175645');
INSERT INTO `yf_hf_report` VALUES ('90', '2063', '765', '8', '1', null, '1528180555', '1528180602');
INSERT INTO `yf_hf_report` VALUES ('91', '2062', '765', '8,11', '1', null, '1528180682', '1528180699');
INSERT INTO `yf_hf_report` VALUES ('92', '2062', '761', '8,11', '1', null, '1528180749', '1528180772');
INSERT INTO `yf_hf_report` VALUES ('93', '2062', '755', '6,8', '0', null, '1528180881', '1528180881');
INSERT INTO `yf_hf_report` VALUES ('94', '586', '769', '8', '1', null, '1528185090', '1528185118');
INSERT INTO `yf_hf_report` VALUES ('95', '521', '776', '8,11', '1', null, '1528186019', '1528187088');
INSERT INTO `yf_hf_report` VALUES ('96', '521', '774', '8,11', '1', null, '1528186088', '1528187100');
INSERT INTO `yf_hf_report` VALUES ('97', '521', '773', '6,8,11', '0', null, '1528187229', '1528187229');
INSERT INTO `yf_hf_report` VALUES ('98', '2121', '787', '8', '1', null, '1528206336', '1528206430');
INSERT INTO `yf_hf_report` VALUES ('99', '577', '799', '6', '0', null, '1528254239', '1528254239');
INSERT INTO `yf_hf_report` VALUES ('100', '577', '803', '6', '0', null, '1528254282', '1528254282');
INSERT INTO `yf_hf_report` VALUES ('101', '577', '805', '8', '0', null, '1528257014', '1528257014');
INSERT INTO `yf_hf_report` VALUES ('102', '567', '805', '6', '0', null, '1528264302', '1528264302');
INSERT INTO `yf_hf_report` VALUES ('103', '2145', '813', '6,8,11', '1', null, '1528266388', '1528266406');
INSERT INTO `yf_hf_report` VALUES ('104', '567', '790', '6', '0', null, '1528271596', '1528271596');
INSERT INTO `yf_hf_report` VALUES ('105', '2158', '825', '6,8,11', '1', null, '1528283740', '1528283768');
INSERT INTO `yf_hf_report` VALUES ('106', '2163', '827', '8,11', '1', null, '1528287477', '1528287527');
INSERT INTO `yf_hf_report` VALUES ('107', '2163', '830', '8,6,11', '2', '审核不通过审核不通过', '1528288642', '1528288820');
INSERT INTO `yf_hf_report` VALUES ('108', '2182', '832', '6,8,11', '2', '审核不通过 审核不通过', '1528350488', '1528350838');
INSERT INTO `yf_hf_report` VALUES ('109', '2182', '827', '8,11', '1', null, '1528350515', '1528350780');
INSERT INTO `yf_hf_report` VALUES ('110', '2182', '825', '8', '1', null, '1528350930', '1528350988');
INSERT INTO `yf_hf_report` VALUES ('111', '2182', '820', '6', '2', '审核不通过审核不通过', '1528350953', '1528351050');
INSERT INTO `yf_hf_report` VALUES ('112', '2188', '844', '8,11', '1', null, '1528354508', '1528354635');
INSERT INTO `yf_hf_report` VALUES ('113', '2188', '843', '6,11', '2', '13526313118', '1528354527', '1528354660');
INSERT INTO `yf_hf_report` VALUES ('114', '2054', '816', '11', '0', null, '1528355232', '1528355232');
INSERT INTO `yf_hf_report` VALUES ('115', '2194', '845', '8', '0', null, '1528356139', '1528356139');
INSERT INTO `yf_hf_report` VALUES ('116', '449', '848', '6,8,11', '0', null, '1528359737', '1528359737');
INSERT INTO `yf_hf_report` VALUES ('117', '449', '846', '8,11', '2', '不通过不通过', '1528367038', '1528367107');
INSERT INTO `yf_hf_report` VALUES ('118', '449', '832', '6,11', '1', null, '1528367046', '1528367090');
INSERT INTO `yf_hf_report` VALUES ('119', '577', '852', '6', '0', null, '1528367125', '1528367125');
INSERT INTO `yf_hf_report` VALUES ('120', '2197', '854', '8,11', '1', null, '1528367944', '1528368166');
INSERT INTO `yf_hf_report` VALUES ('121', '566', '856', '11', '1', null, '1528369883', '1528369957');
INSERT INTO `yf_hf_report` VALUES ('122', '2184', '874', '8,11', '1', null, '1528446623', '1528446639');
INSERT INTO `yf_hf_report` VALUES ('123', '2184', '940', '8,11', '2', '9551', '1529481337', '1529482028');
INSERT INTO `yf_hf_report` VALUES ('124', '521', '923', '8,11', '1', null, '1529481893', '1529482004');

-- ----------------------------
-- Table structure for yf_hf_robot_data
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_robot_data`;
CREATE TABLE `yf_hf_robot_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `robot_id` int(11) DEFAULT NULL COMMENT '用户表中机器人id',
  `operated_id` int(11) DEFAULT NULL COMMENT '被操作id(status=1时存入视频id,status=2时存入用户id,status=3时存入小区id,status=4时存入点赞视频id)status=5s时存入浏览视频(视频id)',
  `data` varchar(255) DEFAULT NULL COMMENT '内容(status=1时存入评论内容,否则为空)',
  `status` tinyint(3) DEFAULT '0' COMMENT '状态(1评论 2关注用户)',
  `create_time` int(10) DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1081 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_robot_data
-- ----------------------------
INSERT INTO `yf_hf_robot_data` VALUES ('820', '642', '1098', '在小区内适合养什么宠物？', '1', '1530592548', '1530592548');
INSERT INTO `yf_hf_robot_data` VALUES ('821', '692', '1098', '', '4', '1530617748', '1530617748');
INSERT INTO `yf_hf_robot_data` VALUES ('822', '676', '7503', '', '3', '1530689748', '1530689748');
INSERT INTO `yf_hf_robot_data` VALUES ('824', '653', '1099', '小区的公公水电费是公摊的吗？多久交一次？', '1', '1530679475', '1530679475');
INSERT INTO `yf_hf_robot_data` VALUES ('825', '674', '1100', '房子一般都在什么价位到什么价位？', '1', '1530702016', '1530702016');
INSERT INTO `yf_hf_robot_data` VALUES ('826', '695', '1100', '请问这里大概是什么年代建造的？', '1', '1530727216', '1530727216');
INSERT INTO `yf_hf_robot_data` VALUES ('827', '689', '1100', '', '4', '1530799216', '1530799216');
INSERT INTO `yf_hf_robot_data` VALUES ('828', '697', '1100', '', '5', '1530691652', '1530691652');
INSERT INTO `yf_hf_robot_data` VALUES ('829', '640', '1101', '有客厅？', '1', '1530778648', '1530778648');
INSERT INTO `yf_hf_robot_data` VALUES ('830', '674', '1101', '', '4', '1530875848', '1530875848');
INSERT INTO `yf_hf_robot_data` VALUES ('831', '686', '1101', '', '5', '1530768031', '1530768031');
INSERT INTO `yf_hf_robot_data` VALUES ('832', '695', '1101', '', '5', '1530767948', '1530767948');
INSERT INTO `yf_hf_robot_data` VALUES ('833', '695', '1102', '在小区内适合养什么宠物？', '1', '1530791793', '1530791793');
INSERT INTO `yf_hf_robot_data` VALUES ('834', '618', '1102', '', '4', '1530816993', '1530816993');
INSERT INTO `yf_hf_robot_data` VALUES ('835', '650', '1102', '小区的配套设施有专人管理么？', '1', '1530888993', '1530888993');
INSERT INTO `yf_hf_robot_data` VALUES ('836', '678', '1102', '', '5', '1530781246', '1530781246');
INSERT INTO `yf_hf_robot_data` VALUES ('837', '610', '1102', '', '5', '1530781193', '1530781193');
INSERT INTO `yf_hf_robot_data` VALUES ('838', '640', '1103', '联系方式多少？', '1', '1530794064', '1530794064');
INSERT INTO `yf_hf_robot_data` VALUES ('839', '637', '2245', '', '2', '1530819264', '1530819264');
INSERT INTO `yf_hf_robot_data` VALUES ('840', '696', '7437', '', '3', '1530891264', '1530891264');
INSERT INTO `yf_hf_robot_data` VALUES ('841', '640', '1103', '', '5', '1530783808', '1530783808');
INSERT INTO `yf_hf_robot_data` VALUES ('842', '610', '1103', '', '5', '1530783581', '1530783581');
INSERT INTO `yf_hf_robot_data` VALUES ('843', '630', '1103', '', '5', '1530783593', '1530783593');
INSERT INTO `yf_hf_robot_data` VALUES ('844', '633', '1104', '请问距离地铁站多远？', '1', '1530794257', '1530794257');
INSERT INTO `yf_hf_robot_data` VALUES ('845', '666', '1104', '', '4', '1530819457', '1530819457');
INSERT INTO `yf_hf_robot_data` VALUES ('846', '702', '1104', '', '5', '1530783600', '1530783600');
INSERT INTO `yf_hf_robot_data` VALUES ('847', '636', '1104', '', '5', '1530783784', '1530783784');
INSERT INTO `yf_hf_robot_data` VALUES ('848', '643', '1105', '要最小的多少钱？', '1', '1530794327', '1530794327');
INSERT INTO `yf_hf_robot_data` VALUES ('849', '701', '1105', '', '4', '1530891527', '1530891527');
INSERT INTO `yf_hf_robot_data` VALUES ('850', '612', '1105', '', '5', '1530783709', '1530783709');
INSERT INTO `yf_hf_robot_data` VALUES ('851', '631', '1105', '', '5', '1530784045', '1530784045');
INSERT INTO `yf_hf_robot_data` VALUES ('852', '660', '1105', '', '5', '1530783629', '1530783629');
INSERT INTO `yf_hf_robot_data` VALUES ('853', '663', '1105', '', '5', '1530783625', '1530783625');
INSERT INTO `yf_hf_robot_data` VALUES ('854', '690', '1106', '房子适合一家三口住吗?', '1', '1530798135', '1530798135');
INSERT INTO `yf_hf_robot_data` VALUES ('855', '676', '1106', '小区是封闭式的么？保安怎么样？', '1', '1530823335', '1530823335');
INSERT INTO `yf_hf_robot_data` VALUES ('856', '674', '1106', '', '5', '1530787934', '1530787934');
INSERT INTO `yf_hf_robot_data` VALUES ('857', '639', '1106', '', '5', '1530787879', '1530787879');
INSERT INTO `yf_hf_robot_data` VALUES ('858', '607', '1106', '', '5', '1530787735', '1530787735');
INSERT INTO `yf_hf_robot_data` VALUES ('859', '625', '1107', '小区的配套设施有专人管理么？', '1', '1530798244', '1530798244');
INSERT INTO `yf_hf_robot_data` VALUES ('860', '633', '1107', '小区总共有多少栋楼？', '1', '1530823445', '1530823445');
INSERT INTO `yf_hf_robot_data` VALUES ('861', '658', '1107', '小区那个大门靠近主干道？', '1', '1530895445', '1530895445');
INSERT INTO `yf_hf_robot_data` VALUES ('862', '651', '1107', '', '5', '1530787711', '1530787711');
INSERT INTO `yf_hf_robot_data` VALUES ('863', '620', '1107', '', '5', '1530787764', '1530787764');
INSERT INTO `yf_hf_robot_data` VALUES ('864', '628', '1108', '这个小区有精装修房吗？', '1', '1530852547', '1530852547');
INSERT INTO `yf_hf_robot_data` VALUES ('865', '703', '1108', '这个房价是否值得入？还能再涨吗？', '1', '1530877747', '1530877747');
INSERT INTO `yf_hf_robot_data` VALUES ('866', '650', '1108', '房子适合一家三口住吗?', '1', '1530949747', '1530949747');
INSERT INTO `yf_hf_robot_data` VALUES ('867', '673', '1108', '', '5', '1530841924', '1530841924');
INSERT INTO `yf_hf_robot_data` VALUES ('868', '655', '1108', '', '5', '1530841941', '1530841941');
INSERT INTO `yf_hf_robot_data` VALUES ('869', '618', '1109', '小区附近有幼儿园么？', '1', '1530852692', '1530852692');
INSERT INTO `yf_hf_robot_data` VALUES ('870', '622', '1109', '小区的公公水电费是公摊的吗？多久交一次？', '1', '1530949892', '1530949892');
INSERT INTO `yf_hf_robot_data` VALUES ('871', '673', '1109', '', '5', '1530842036', '1530842036');
INSERT INTO `yf_hf_robot_data` VALUES ('872', '686', '1110', '附近有地铁站么？', '1', '1530853503', '1530853503');
INSERT INTO `yf_hf_robot_data` VALUES ('873', '621', '18777', '', '3', '1530878703', '1530878703');
INSERT INTO `yf_hf_robot_data` VALUES ('874', '633', '2246', '', '2', '1530950703', '1530950703');
INSERT INTO `yf_hf_robot_data` VALUES ('875', '667', '1110', '', '5', '1530843090', '1530843090');
INSERT INTO `yf_hf_robot_data` VALUES ('876', '673', '1111', '具体位置是哪？', '1', '1530854242', '1530854242');
INSERT INTO `yf_hf_robot_data` VALUES ('877', '670', '1111', '这个价格是一间，还是整套？', '1', '1530879442', '1530879442');
INSERT INTO `yf_hf_robot_data` VALUES ('878', '687', '18777', '', '3', '1530951442', '1530951442');
INSERT INTO `yf_hf_robot_data` VALUES ('879', '645', '1111', '', '5', '1530843685', '1530843685');
INSERT INTO `yf_hf_robot_data` VALUES ('880', '692', '1112', '请问这里大概是什么年代建造的？', '1', '1530857081', '1530857081');
INSERT INTO `yf_hf_robot_data` VALUES ('881', '628', '1112', '', '4', '1530882281', '1530882281');
INSERT INTO `yf_hf_robot_data` VALUES ('882', '679', '1113', '房子还有么？我女生，一个人住。', '1', '1530859504', '1530859504');
INSERT INTO `yf_hf_robot_data` VALUES ('883', '630', '1113', '', '4', '1530884704', '1530884704');
INSERT INTO `yf_hf_robot_data` VALUES ('884', '665', '1113', '让带孩子么？', '1', '1530956704', '1530956704');
INSERT INTO `yf_hf_robot_data` VALUES ('885', '677', '1113', '', '5', '1530848813', '1530848813');
INSERT INTO `yf_hf_robot_data` VALUES ('886', '620', '1113', '', '5', '1530849151', '1530849151');
INSERT INTO `yf_hf_robot_data` VALUES ('887', '636', '1113', '', '5', '1530849289', '1530849289');
INSERT INTO `yf_hf_robot_data` VALUES ('888', '673', '1113', '', '5', '1530849162', '1530849162');
INSERT INTO `yf_hf_robot_data` VALUES ('889', '698', '1114', '这是几楼？', '1', '1530859547', '1530859547');
INSERT INTO `yf_hf_robot_data` VALUES ('890', '684', '18782', '', '3', '1530884747', '1530884747');
INSERT INTO `yf_hf_robot_data` VALUES ('891', '663', '1114', '', '4', '1530956747', '1530956747');
INSERT INTO `yf_hf_robot_data` VALUES ('892', '636', '1114', '', '5', '1530849157', '1530849157');
INSERT INTO `yf_hf_robot_data` VALUES ('893', '649', '1114', '', '5', '1530849319', '1530849319');
INSERT INTO `yf_hf_robot_data` VALUES ('894', '631', '1114', '', '5', '1530849197', '1530849197');
INSERT INTO `yf_hf_robot_data` VALUES ('895', '675', '1114', '', '5', '1530849143', '1530849143');
INSERT INTO `yf_hf_robot_data` VALUES ('896', '624', '1114', '', '5', '1530848916', '1530848916');
INSERT INTO `yf_hf_robot_data` VALUES ('897', '690', '1115', '有电梯么？', '1', '1530859878', '1530859878');
INSERT INTO `yf_hf_robot_data` VALUES ('898', '613', '1115', '', '4', '1530885078', '1530885078');
INSERT INTO `yf_hf_robot_data` VALUES ('899', '608', '1115', '请问大概多少平方？', '1', '1530957078', '1530957078');
INSERT INTO `yf_hf_robot_data` VALUES ('900', '634', '1115', '', '5', '1530849668', '1530849668');
INSERT INTO `yf_hf_robot_data` VALUES ('901', '616', '1115', '', '5', '1530849671', '1530849671');
INSERT INTO `yf_hf_robot_data` VALUES ('902', '611', '1116', '周边有几家搬家公司？', '1', '1530859947', '1530859947');
INSERT INTO `yf_hf_robot_data` VALUES ('903', '674', '1116', '', '4', '1530957147', '1530957147');
INSERT INTO `yf_hf_robot_data` VALUES ('904', '610', '1117', '附近的发展，政府有什么重大的规划么？', '1', '1530866852', '1530866852');
INSERT INTO `yf_hf_robot_data` VALUES ('905', '637', '1117', '', '4', '1530892052', '1530892052');
INSERT INTO `yf_hf_robot_data` VALUES ('906', '701', '1117', '展示房价可信吗？', '1', '1530964052', '1530964052');
INSERT INTO `yf_hf_robot_data` VALUES ('907', '619', '1117', '', '5', '1530856479', '1530856479');
INSERT INTO `yf_hf_robot_data` VALUES ('908', '637', '1117', '', '5', '1530856429', '1530856429');
INSERT INTO `yf_hf_robot_data` VALUES ('909', '629', '1117', '', '5', '1530856401', '1530856401');
INSERT INTO `yf_hf_robot_data` VALUES ('910', '692', '1117', '', '5', '1530856509', '1530856509');
INSERT INTO `yf_hf_robot_data` VALUES ('911', '693', '1117', '', '5', '1530856240', '1530856240');
INSERT INTO `yf_hf_robot_data` VALUES ('912', '621', '1118', '有花园或露天阳台的房子吗？', '1', '1530867579', '1530867579');
INSERT INTO `yf_hf_robot_data` VALUES ('913', '642', '18779', '', '3', '1530892779', '1530892779');
INSERT INTO `yf_hf_robot_data` VALUES ('914', '625', '1118', '', '4', '1530964779', '1530964779');
INSERT INTO `yf_hf_robot_data` VALUES ('915', '622', '1118', '', '5', '1530857076', '1530857076');
INSERT INTO `yf_hf_robot_data` VALUES ('916', '613', '1118', '', '5', '1530856852', '1530856852');
INSERT INTO `yf_hf_robot_data` VALUES ('917', '615', '1118', '', '5', '1530856965', '1530856965');
INSERT INTO `yf_hf_robot_data` VALUES ('918', '616', '1118', '', '5', '1530857267', '1530857267');
INSERT INTO `yf_hf_robot_data` VALUES ('919', '692', '1119', '让带孩子么？', '1', '1530867639', '1530867639');
INSERT INTO `yf_hf_robot_data` VALUES ('920', '696', '1119', '房子包括哪些？', '1', '1530892839', '1530892839');

-- ----------------------------
-- Table structure for yf_hf_setting
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_setting`;
CREATE TABLE `yf_hf_setting` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(100) DEFAULT NULL COMMENT '设置名',
  `key` varchar(100) DEFAULT '' COMMENT '设置键',
  `value` varchar(100) DEFAULT '' COMMENT '设置值1',
  `description` varchar(100) DEFAULT '' COMMENT '备注',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8 COMMENT='设置表';

-- ----------------------------
-- Records of yf_hf_setting
-- ----------------------------
INSERT INTO `yf_hf_setting` VALUES ('74', '被邀请的用户总数量', 'invite_max_num', '100', '被邀请的用户总数量', '0', '0');

-- ----------------------------
-- Table structure for yf_hf_share
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_share`;
CREATE TABLE `yf_hf_share` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) DEFAULT NULL COMMENT '分享人id',
  `video_id` int(11) DEFAULT NULL COMMENT '分享视频id',
  `shared_user_id` int(11) DEFAULT NULL COMMENT '被分享者用户id',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1629 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_share
-- ----------------------------
INSERT INTO `yf_hf_share` VALUES ('39', '515', '692', '517', '1528007590', '1528007590');
INSERT INTO `yf_hf_share` VALUES ('40', '570', '694', '522', '1528012086', '1528012086');
INSERT INTO `yf_hf_share` VALUES ('41', '522', '698', '587', '1528013527', '1528013527');
INSERT INTO `yf_hf_share` VALUES ('43', '570', '703', '522', '1528019329', '1528019329');
INSERT INTO `yf_hf_share` VALUES ('44', '570', '703', '522', '1528019341', '1528019341');
INSERT INTO `yf_hf_share` VALUES ('45', '570', '703', '522', '1528020165', '1528020165');
INSERT INTO `yf_hf_share` VALUES ('46', '570', '703', '522', '1528020182', '1528020182');
INSERT INTO `yf_hf_share` VALUES ('47', '570', '703', '522', '1528022158', '1528022158');
INSERT INTO `yf_hf_share` VALUES ('48', '570', '703', '522', '1528022177', '1528022177');
INSERT INTO `yf_hf_share` VALUES ('49', '570', '703', '522', '1528024027', '1528024027');
INSERT INTO `yf_hf_share` VALUES ('51', '570', '712', '449', '1528074654', '1528074654');
INSERT INTO `yf_hf_share` VALUES ('52', '570', '712', '449', '1528074659', '1528074659');
INSERT INTO `yf_hf_share` VALUES ('53', '570', '712', '449', '1528074672', '1528074672');
INSERT INTO `yf_hf_share` VALUES ('54', '570', '712', '449', '1528074677', '1528074677');
INSERT INTO `yf_hf_share` VALUES ('55', '570', '712', '449', '1528074764', '1528074764');
INSERT INTO `yf_hf_share` VALUES ('56', '570', '712', '449', '1528074770', '1528074770');
INSERT INTO `yf_hf_share` VALUES ('57', '570', '690', '516', '1528075735', '1528075735');
INSERT INTO `yf_hf_share` VALUES ('58', '570', '713', '516', '1528078867', '1528078867');
INSERT INTO `yf_hf_share` VALUES ('59', '513', '713', '516', '1528081423', '1528081423');
INSERT INTO `yf_hf_share` VALUES ('60', '473', '715', '449', '1528082387', '1528082387');
INSERT INTO `yf_hf_share` VALUES ('61', '515', '715', '449', '1528082444', '1528082444');
INSERT INTO `yf_hf_share` VALUES ('62', '515', '714', '516', '1528083193', '1528083193');
INSERT INTO `yf_hf_share` VALUES ('63', '515', '716', '449', '1528087083', '1528087083');
INSERT INTO `yf_hf_share` VALUES ('64', '515', '714', '516', '1528087295', '1528087295');
INSERT INTO `yf_hf_share` VALUES ('65', '515', '711', '521', '1528087551', '1528087551');
INSERT INTO `yf_hf_share` VALUES ('66', '515', '710', '2021', '1528087614', '1528087614');
INSERT INTO `yf_hf_share` VALUES ('67', '515', '709', '449', '1528087800', '1528087800');
INSERT INTO `yf_hf_share` VALUES ('68', '515', '708', '2021', '1528088123', '1528088123');
INSERT INTO `yf_hf_share` VALUES ('69', '515', '707', '2024', '1528088481', '1528088481');
INSERT INTO `yf_hf_share` VALUES ('70', '515', '707', '2024', '1528088481', '1528088481');
INSERT INTO `yf_hf_share` VALUES ('71', '513', '719', '2024', '1528089070', '1528089070');
INSERT INTO `yf_hf_share` VALUES ('72', '513', '719', '2024', '1528089128', '1528089128');
INSERT INTO `yf_hf_share` VALUES ('73', '513', '719', '2024', '1528089668', '1528089668');
INSERT INTO `yf_hf_share` VALUES ('74', '513', '719', '2024', '1528089676', '1528089676');
INSERT INTO `yf_hf_share` VALUES ('75', '513', '719', '2024', '1528089755', '1528089755');
INSERT INTO `yf_hf_share` VALUES ('76', '513', '701', '449', '1528090279', '1528090279');
INSERT INTO `yf_hf_share` VALUES ('77', '513', '719', '2024', '1528090821', '1528090821');
INSERT INTO `yf_hf_share` VALUES ('78', '515', '706', '521', '1528090944', '1528090944');
INSERT INTO `yf_hf_share` VALUES ('79', '513', '713', '516', '1528091092', '1528091092');
INSERT INTO `yf_hf_share` VALUES ('80', '515', '700', '449', '1528091132', '1528091132');
INSERT INTO `yf_hf_share` VALUES ('84', '513', '720', '515', '1528097062', '1528097062');
INSERT INTO `yf_hf_share` VALUES ('85', '2046', '720', '515', '1528097069', '1528097069');
INSERT INTO `yf_hf_share` VALUES ('86', '2046', '720', '515', '1528097097', '1528097097');
INSERT INTO `yf_hf_share` VALUES ('87', '513', '720', '515', '1528097207', '1528097207');
INSERT INTO `yf_hf_share` VALUES ('88', '513', '720', '515', '1528097270', '1528097270');
INSERT INTO `yf_hf_share` VALUES ('89', '2046', '720', '515', '1528097306', '1528097306');
INSERT INTO `yf_hf_share` VALUES ('90', '513', '720', '515', '1528097349', '1528097349');
INSERT INTO `yf_hf_share` VALUES ('91', '513', '720', '515', '1528100295', '1528100295');
INSERT INTO `yf_hf_share` VALUES ('92', '513', '720', '515', '1528100563', '1528100563');
INSERT INTO `yf_hf_share` VALUES ('93', '514', '740', '513', '1528114080', '1528114080');
INSERT INTO `yf_hf_share` VALUES ('94', '449', '739', '516', '1528117371', '1528117371');
INSERT INTO `yf_hf_share` VALUES ('95', '449', '739', '516', '1528118206', '1528118206');
INSERT INTO `yf_hf_share` VALUES ('96', '449', '739', '516', '1528118564', '1528118564');
INSERT INTO `yf_hf_share` VALUES ('97', '449', '739', '516', '1528118570', '1528118570');
INSERT INTO `yf_hf_share` VALUES ('98', '449', '739', '516', '1528118643', '1528118643');
INSERT INTO `yf_hf_share` VALUES ('99', '449', '739', '516', '1528118882', '1528118882');
INSERT INTO `yf_hf_share` VALUES ('100', '449', '739', '516', '1528118978', '1528118978');
INSERT INTO `yf_hf_share` VALUES ('101', '449', '739', '516', '1528119027', '1528119027');
INSERT INTO `yf_hf_share` VALUES ('102', '449', '735', '581', '1528119036', '1528119036');
INSERT INTO `yf_hf_share` VALUES ('103', '449', '739', '516', '1528119140', '1528119140');
INSERT INTO `yf_hf_share` VALUES ('104', '449', '735', '581', '1528119151', '1528119151');
INSERT INTO `yf_hf_share` VALUES ('105', '449', '733', '517', '1528119161', '1528119161');
INSERT INTO `yf_hf_share` VALUES ('106', '449', '739', '516', '1528119567', '1528119567');
INSERT INTO `yf_hf_share` VALUES ('107', '570', '739', '516', '1528119750', '1528119750');
INSERT INTO `yf_hf_share` VALUES ('108', '473', '747', '570', '1528120225', '1528120225');
INSERT INTO `yf_hf_share` VALUES ('109', '473', '763', '473', '1528178024', '1528178024');
INSERT INTO `yf_hf_share` VALUES ('110', '2062', '764', '2063', '1528178178', '1528178178');
INSERT INTO `yf_hf_share` VALUES ('111', '514', '761', '568', '1528178425', '1528178425');
INSERT INTO `yf_hf_share` VALUES ('112', '514', '763', '473', '1528178578', '1528178578');
INSERT INTO `yf_hf_share` VALUES ('113', '2063', '766', '521', '1528180422', '1528180422');
INSERT INTO `yf_hf_share` VALUES ('114', '2063', '766', '521', '1528180423', '1528180423');
INSERT INTO `yf_hf_share` VALUES ('115', '2059', '752', '570', '1528180724', '1528180724');
INSERT INTO `yf_hf_share` VALUES ('116', '2024', '765', '473', '1528181073', '1528181073');
INSERT INTO `yf_hf_share` VALUES ('117', '568', '769', '2062', '1528181185', '1528181185');
INSERT INTO `yf_hf_share` VALUES ('118', '449', '761', '568', '1528181246', '1528181246');
INSERT INTO `yf_hf_share` VALUES ('119', '449', '761', '568', '1528181273', '1528181273');
INSERT INTO `yf_hf_share` VALUES ('120', '449', '769', '2062', '1528181372', '1528181372');
INSERT INTO `yf_hf_share` VALUES ('121', '449', '769', '2062', '1528181424', '1528181424');
INSERT INTO `yf_hf_share` VALUES ('122', '449', '769', '2062', '1528181624', '1528181624');
INSERT INTO `yf_hf_share` VALUES ('123', '449', '769', '2062', '1528181680', '1528181680');
INSERT INTO `yf_hf_share` VALUES ('124', '586', '769', '2062', '1528181965', '1528181965');
INSERT INTO `yf_hf_share` VALUES ('125', '586', '769', '2062', '1528182009', '1528182009');
INSERT INTO `yf_hf_share` VALUES ('126', '449', '769', '2062', '1528182081', '1528182081');
INSERT INTO `yf_hf_share` VALUES ('127', '586', '769', '2062', '1528182178', '1528182178');
INSERT INTO `yf_hf_share` VALUES ('128', '449', '769', '2062', '1528182368', '1528182368');
INSERT INTO `yf_hf_share` VALUES ('129', '449', '769', '2062', '1528182390', '1528182390');
INSERT INTO `yf_hf_share` VALUES ('130', '449', '769', '2062', '1528182734', '1528182734');
INSERT INTO `yf_hf_share` VALUES ('131', '586', '707', '2024', '1528183360', '1528183360');
INSERT INTO `yf_hf_share` VALUES ('132', '449', '769', '2062', '1528183372', '1528183372');
INSERT INTO `yf_hf_share` VALUES ('133', '586', '707', '2024', '1528183403', '1528183403');
INSERT INTO `yf_hf_share` VALUES ('134', '449', '761', '568', '1528183448', '1528183448');
INSERT INTO `yf_hf_share` VALUES ('135', '449', '761', '568', '1528183458', '1528183458');
INSERT INTO `yf_hf_share` VALUES ('136', '2062', '769', '2062', '1528183563', '1528183563');
INSERT INTO `yf_hf_share` VALUES ('137', '2062', '769', '2062', '1528183676', '1528183676');
INSERT INTO `yf_hf_share` VALUES ('138', '449', '761', '568', '1528183727', '1528183727');
INSERT INTO `yf_hf_share` VALUES ('139', '521', '768', '521', '1528183743', '1528183743');
INSERT INTO `yf_hf_share` VALUES ('140', '2062', '768', '521', '1528183759', '1528183759');
INSERT INTO `yf_hf_share` VALUES ('141', '2062', '768', '521', '1528183916', '1528183916');
INSERT INTO `yf_hf_share` VALUES ('142', '586', '707', '2024', '1528184442', '1528184442');
INSERT INTO `yf_hf_share` VALUES ('143', '586', '769', '2062', '1528185086', '1528185086');

-- ----------------------------
-- Table structure for yf_hf_task
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_task`;
CREATE TABLE `yf_hf_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '用户id(执行者)',
  `content` varchar(255) DEFAULT NULL COMMENT '内容',
  `type` tinyint(5) DEFAULT '0' COMMENT '1 发布视频审核通过获得奖励,已审核到账 \r\n11 发布视频审核通过,没有获得奖励(不是第一次发布)\r\n2发布视频审核被拒绝 \r\n21 后台管理员删除视频(审核不通过平台要求)\r\n22 后台管理员审核上报小区审核不通过，删除小区及发布的视频\r\n3邀请好友成功得奖励 \r\n4举报视频 \r\n50提现成功 \r\n51提现退回 \r\n52提现被拒绝 \r\n6评论 \r\n7点赞视频 \r\n8关注\r\n9分享 \r\n10发送消息 私信推送',
  `is_show` tinyint(1) DEFAULT '0' COMMENT '是否查看 0未查看 1查看',
  `create_time` int(10) DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4491 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_task
-- ----------------------------
INSERT INTO `yf_hf_task` VALUES ('1', '517', 'nothing关注了您,快去看看', '8', '1', '1527230357', '1527230357');
INSERT INTO `yf_hf_task` VALUES ('2', '517', 'nothing关注了您,快去看看', '8', '1', '1527230378', '1527230378');
INSERT INTO `yf_hf_task` VALUES ('3', '517', 'nothing关注了您,快去看看', '8', '1', '1527230393', '1527230393');
INSERT INTO `yf_hf_task` VALUES ('4', '517', 'nothing关注了您,快去看看', '8', '1', '1527230403', '1527230403');
INSERT INTO `yf_hf_task` VALUES ('5', '62', 'nothing点赞了您的视频,快去看看', '7', '0', '1527230452', '1527230452');
INSERT INTO `yf_hf_task` VALUES ('6', '515', '好的评论了您的视频:love哈', '6', '0', '1527232294', '1527232294');
INSERT INTO `yf_hf_task` VALUES ('7', '644', 'songjian点赞了您的视频,快去看看', '7', '0', '1527235855', '1527235855');
INSERT INTO `yf_hf_task` VALUES ('8', '644', 'songjian点赞了您的视频,快去看看', '7', '0', '1527235859', '1527235859');
INSERT INTO `yf_hf_task` VALUES ('9', '644', 'songjian点赞了您的视频,快去看看', '7', '0', '1527235860', '1527235860');
INSERT INTO `yf_hf_task` VALUES ('10', '62', 'nothing点赞了您的视频,快去看看', '7', '0', '1527239127', '1527239127');
INSERT INTO `yf_hf_task` VALUES ('11', '515', 'nothing关注了您,快去看看', '8', '0', '1527239758', '1527239758');
INSERT INTO `yf_hf_task` VALUES ('12', '515', 'nothing关注了您,快去看看', '8', '0', '1527239913', '1527239913');
INSERT INTO `yf_hf_task` VALUES ('13', '5', '三丰关注了您,快去看看', '8', '0', '1527239951', '1527239951');
INSERT INTO `yf_hf_task` VALUES ('14', '514', '您的提现已到账', '50', '1', '1527239959', '1528360581');
INSERT INTO `yf_hf_task` VALUES ('15', '515', 'nothing关注了您,快去看看', '8', '0', '1527239990', '1527239990');
INSERT INTO `yf_hf_task` VALUES ('16', '445', '三丰评论了您的视频:咯咯哒', '6', '0', '1527239994', '1527239994');
INSERT INTO `yf_hf_task` VALUES ('17', '445', '三丰评论了您的视频:YY呀', '6', '0', '1527240002', '1527240002');
INSERT INTO `yf_hf_task` VALUES ('18', '514', '您的提现已到账', '50', '1', '1527240239', '1528360581');
INSERT INTO `yf_hf_task` VALUES ('19', '644', 'nothing点赞了您的视频,快去看看', '7', '0', '1527242307', '1527242307');
INSERT INTO `yf_hf_task` VALUES ('20', '514', 'nothing点赞了您的视频,快去看看', '7', '1', '1527242316', '1527242316');
INSERT INTO `yf_hf_task` VALUES ('21', '639', 'nothing点赞了您的视频,快去看看', '7', '0', '1527242326', '1527242326');
INSERT INTO `yf_hf_task` VALUES ('22', '639', 'nothing点赞了您的视频,快去看看', '7', '0', '1527243660', '1527243660');
INSERT INTO `yf_hf_task` VALUES ('23', '644', 'nothing点赞了您的视频,快去看看', '7', '0', '1527243708', '1527243708');
INSERT INTO `yf_hf_task` VALUES ('24', '644', 'nothing点赞了您的视频,快去看看', '7', '0', '1527243709', '1527243709');
INSERT INTO `yf_hf_task` VALUES ('25', '644', 'nothing点赞了您的视频,快去看看', '7', '0', '1527243711', '1527243711');
INSERT INTO `yf_hf_task` VALUES ('26', '644', 'nothing点赞了您的视频,快去看看', '7', '0', '1527243712', '1527243712');
INSERT INTO `yf_hf_task` VALUES ('27', '514', 'nothing点赞了您的视频,快去看看', '7', '1', '1527243803', '1527243803');
INSERT INTO `yf_hf_task` VALUES ('28', '639', 'nothing点赞了您的视频,快去看看', '7', '0', '1527243804', '1527243804');
INSERT INTO `yf_hf_task` VALUES ('29', '639', 'nothing点赞了您的视频,快去看看', '7', '0', '1527243841', '1527243841');
INSERT INTO `yf_hf_task` VALUES ('30', '638', 'nothing点赞了您的视频,快去看看', '7', '0', '1527243925', '1527243925');
INSERT INTO `yf_hf_task` VALUES ('31', '644', 'nothing点赞了您的视频,快去看看', '7', '0', '1527244523', '1527244523');
INSERT INTO `yf_hf_task` VALUES ('32', '517', '三丰关注了您,快去看看', '8', '1', '1527245010', '1527245010');
INSERT INTO `yf_hf_task` VALUES ('33', '515', '饿评论了您的视频:得得', '6', '0', '1527256264', '1527256264');
INSERT INTO `yf_hf_task` VALUES ('34', '515', '许正关注了您,快去看看', '8', '0', '1527266054', '1527266054');
INSERT INTO `yf_hf_task` VALUES ('35', '644', '许正点赞了您的视频,快去看看', '7', '0', '1527285814', '1527285814');
INSERT INTO `yf_hf_task` VALUES ('36', '515', '好的评论了您的视频:嘿嘿嘿', '6', '0', '1527302245', '1527302245');
INSERT INTO `yf_hf_task` VALUES ('37', '515', '好的评论了您的视频:厉害了', '6', '0', '1527302767', '1527302767');
INSERT INTO `yf_hf_task` VALUES ('38', '515', '饿关注了您,快去看看', '8', '0', '1527303572', '1527303572');
INSERT INTO `yf_hf_task` VALUES ('39', '515', '饿关注了您,快去看看', '8', '0', '1527303584', '1527303584');
INSERT INTO `yf_hf_task` VALUES ('40', '633', '饿点赞了您的视频,快去看看', '7', '0', '1527303623', '1527303623');
INSERT INTO `yf_hf_task` VALUES ('41', '644', '饿点赞了您的视频,快去看看', '7', '0', '1527304220', '1527304220');
INSERT INTO `yf_hf_task` VALUES ('42', '644', '饿点赞了您的视频,快去看看', '7', '0', '1527304222', '1527304222');
INSERT INTO `yf_hf_task` VALUES ('43', '644', '饿点赞了您的视频,快去看看', '7', '0', '1527304224', '1527304224');
INSERT INTO `yf_hf_task` VALUES ('44', '515', '饿关注了您,快去看看', '8', '0', '1527304263', '1527304263');
INSERT INTO `yf_hf_task` VALUES ('45', '515', '好的评论了您的视频:累死了。', '6', '0', '1527307904', '1527307904');
INSERT INTO `yf_hf_task` VALUES ('46', '515', '好的评论了您的视频:', '6', '0', '1527349626', '1527349626');
INSERT INTO `yf_hf_task` VALUES ('47', '644', 'a施海彦《同联商业》《福居好房》点赞了您的视频,快去看看', '7', '0', '1527350901', '1527350901');
INSERT INTO `yf_hf_task` VALUES ('48', '515', '好的评论了您的视频:我们总是喜欢拿顺其自然来敷衍人生道路上的荆棘坎坷，却很少承认，真正的顺其自然，其实是竭尽所能之后的不强求，而非两手一摊的不作为。', '6', '0', '1527352381', '1527352381');
INSERT INTO `yf_hf_task` VALUES ('49', '515', '我们评论了您的视频:半天上的秃鹰那张脸 半生中的记忆在盘旋 第五十三天后的日夜线 等黑夜问白天 能不能赦免 灰色的人间 别交换吧日夜 冰封的眼泪 一滴就很咸 来自暮光的 明信片 它无声无色无言 翻过山巅跟我扮鬼脸 但黑夜恨白天 拼命的往前 听不到救援 命运太疯癫 每一眨眼 都很玄 那对逆光中的黑雁 也飞过去老远 等再见不如说一次再见 挑一天', '6', '0', '1527352857', '1527352857');
INSERT INTO `yf_hf_task` VALUES ('50', '515', '我们回复了您的视频:落魄的iOS开发', '6', '0', '1527355913', '1527355913');
INSERT INTO `yf_hf_task` VALUES ('51', '515', '我们评论了您的视频:iOS开发真的落魄', '6', '0', '1527355944', '1527355944');
INSERT INTO `yf_hf_task` VALUES ('52', '515', '我们回复了您的视频:真的急', '6', '0', '1527355985', '1527355985');
INSERT INTO `yf_hf_task` VALUES ('53', '515', '我们回复了您的视频:有多急', '6', '0', '1527356089', '1527356089');
INSERT INTO `yf_hf_task` VALUES ('54', '517', '我们回复了您的视频:不错个屁呀。', '6', '1', '1527361007', '1527361007');
INSERT INTO `yf_hf_task` VALUES ('55', '517', '我们回复了您的视频:666', '6', '1', '1527361031', '1527361031');
INSERT INTO `yf_hf_task` VALUES ('56', '516', '我们评论了您的视频:消灭0评论！', '6', '1', '1527361075', '1527361075');
INSERT INTO `yf_hf_task` VALUES ('57', '633', '我们点赞了您的视频,快去看看', '7', '0', '1527361136', '1527361136');
INSERT INTO `yf_hf_task` VALUES ('58', '449', '我们关注了您,快去看看', '8', '1', '1527361410', '1527361410');
INSERT INTO `yf_hf_task` VALUES ('59', '519', '我们评论了您的视频:这个评论呢？不是有3条吗？', '6', '0', '1527361545', '1527361545');
INSERT INTO `yf_hf_task` VALUES ('60', '623', '我们点赞了您的视频,快去看看', '7', '0', '1527362178', '1527362178');
INSERT INTO `yf_hf_task` VALUES ('61', '449', '我们回复了您的视频:就你能。', '6', '1', '1527362232', '1527362232');
INSERT INTO `yf_hf_task` VALUES ('62', '445', '我们回复了您的视频:嗯哼', '6', '0', '1527362314', '1527362314');
INSERT INTO `yf_hf_task` VALUES ('63', '515', '我们回复了您的视频:我们总是喜欢拿顺其自然来敷衍人生道路上的荆棘坎坷，却很少承认，真正的顺其自然，其实是竭尽所能之后的不强求，而非两手一摊的不作为。', '6', '0', '1527362481', '1527362481');
INSERT INTO `yf_hf_task` VALUES ('64', '639', '饿点赞了您的视频,快去看看', '7', '0', '1527387300', '1527387300');
INSERT INTO `yf_hf_task` VALUES ('65', '639', '饿点赞了您的视频,快去看看', '7', '0', '1527387303', '1527387303');
INSERT INTO `yf_hf_task` VALUES ('66', '639', '饿点赞了您的视频,快去看看', '7', '0', '1527387307', '1527387307');
INSERT INTO `yf_hf_task` VALUES ('67', '578', '饿点赞了您的视频,快去看看', '7', '0', '1527388197', '1527388197');
INSERT INTO `yf_hf_task` VALUES ('68', '515', '我们回复了您的视频:呵呵', '6', '0', '1527394571', '1527394571');
INSERT INTO `yf_hf_task` VALUES ('69', '515', '我们回复了您的视频:哎呀，我的。', '6', '0', '1527394638', '1527394638');
INSERT INTO `yf_hf_task` VALUES ('70', '515', '我们回复了您的视频:deidei', '6', '0', '1527394665', '1527394665');
INSERT INTO `yf_hf_task` VALUES ('71', '515', '我们回复了您的视频:塑料同学情', '6', '0', '1527394748', '1527394748');
INSERT INTO `yf_hf_task` VALUES ('72', '515', '我们回复了您的视频:不知道', '6', '0', '1527394776', '1527394776');
INSERT INTO `yf_hf_task` VALUES ('73', '516', '我们评论了您的视频:哦', '6', '1', '1527394903', '1527394903');
INSERT INTO `yf_hf_task` VALUES ('74', '515', '我们回复了您的视频:我瞅我自己都上火', '6', '0', '1527395162', '1527395162');
INSERT INTO `yf_hf_task` VALUES ('75', '515', '我们回复了您的视频:上火了', '6', '0', '1527395333', '1527395333');
INSERT INTO `yf_hf_task` VALUES ('76', '517', '我们评论了您的视频:消灭0评论再次来了。', '6', '1', '1527402828', '1527402828');
INSERT INTO `yf_hf_task` VALUES ('77', '517', '我们评论了您的视频:666', '6', '1', '1527402902', '1527402902');
INSERT INTO `yf_hf_task` VALUES ('78', '644', '饿点赞了您的视频,快去看看', '7', '0', '1527433449', '1527433449');
INSERT INTO `yf_hf_task` VALUES ('79', '644', '饿点赞了您的视频,快去看看', '7', '0', '1527433803', '1527433803');
INSERT INTO `yf_hf_task` VALUES ('80', '652', '饿点赞了您的视频,快去看看', '7', '0', '1527434226', '1527434226');
INSERT INTO `yf_hf_task` VALUES ('81', '644', '饿点赞了您的视频,快去看看', '7', '0', '1527435027', '1527435027');
INSERT INTO `yf_hf_task` VALUES ('82', '652', '饿点赞了您的视频,快去看看', '7', '0', '1527435047', '1527435047');
INSERT INTO `yf_hf_task` VALUES ('83', '652', '饿点赞了您的视频,快去看看', '7', '0', '1527435049', '1527435049');
INSERT INTO `yf_hf_task` VALUES ('84', '644', '饿点赞了您的视频,快去看看', '7', '0', '1527435087', '1527435087');
INSERT INTO `yf_hf_task` VALUES ('85', '517', '我们评论了您的视频:http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180527143016', '6', '1', '1527470681', '1527470681');
INSERT INTO `yf_hf_task` VALUES ('86', '445', '饿评论了您的视频:天啦', '6', '0', '1527471600', '1527471600');
INSERT INTO `yf_hf_task` VALUES ('87', '445', '饿评论了您的视频:因为我', '6', '0', '1527471610', '1527471610');
INSERT INTO `yf_hf_task` VALUES ('88', '644', 'nothing点赞了您的视频,快去看看', '7', '0', '1527473111', '1527473111');
INSERT INTO `yf_hf_task` VALUES ('89', '652', 'nothing点赞了您的视频,快去看看', '7', '0', '1527474526', '1527474526');
INSERT INTO `yf_hf_task` VALUES ('90', '644', 'nothing点赞了您的视频,快去看看', '7', '0', '1527474532', '1527474532');
INSERT INTO `yf_hf_task` VALUES ('91', '652', 'nothing点赞了您的视频,快去看看', '7', '0', '1527474575', '1527474575');
INSERT INTO `yf_hf_task` VALUES ('92', '644', 'nothing点赞了您的视频,快去看看', '7', '0', '1527474588', '1527474588');
INSERT INTO `yf_hf_task` VALUES ('93', '652', 'nothing点赞了您的视频,快去看看', '7', '0', '1527474844', '1527474844');
INSERT INTO `yf_hf_task` VALUES ('94', '652', 'nothing点赞了您的视频,快去看看', '7', '0', '1527474845', '1527474845');
INSERT INTO `yf_hf_task` VALUES ('95', '62', 'nothing点赞了您的视频,快去看看', '7', '0', '1527475564', '1527475564');
INSERT INTO `yf_hf_task` VALUES ('96', '652', 'nothing点赞了您的视频,快去看看', '7', '0', '1527476993', '1527476993');
INSERT INTO `yf_hf_task` VALUES ('97', '652', 'nothing点赞了您的视频,快去看看', '7', '0', '1527477059', '1527477059');
INSERT INTO `yf_hf_task` VALUES ('98', '652', 'nothing点赞了您的视频,快去看看', '7', '0', '1527477060', '1527477060');
INSERT INTO `yf_hf_task` VALUES ('99', '652', 'nothing点赞了您的视频,快去看看', '7', '0', '1527477064', '1527477064');
INSERT INTO `yf_hf_task` VALUES ('100', '652', 'nothing点赞了您的视频,快去看看', '7', '0', '1527477202', '1527477202');

-- ----------------------------
-- Table structure for yf_hf_uninterested
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_uninterested`;
CREATE TABLE `yf_hf_uninterested` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '不敢兴趣表',
  `member_id` int(11) DEFAULT '0' COMMENT '用户id',
  `video_id` int(11) DEFAULT '0' COMMENT '视频id',
  `video_type` tinyint(4) DEFAULT '0' COMMENT '视频类型',
  `num_room` tinyint(4) DEFAULT NULL COMMENT '几室',
  `num_hall` tinyint(4) DEFAULT NULL COMMENT '几厅',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_uninterested
-- ----------------------------
INSERT INTO `yf_hf_uninterested` VALUES ('17', '515', '692', '0', '1', '0', '1528007704', '1528007704');
INSERT INTO `yf_hf_uninterested` VALUES ('18', '570', '694', '1', '3', '1', '1528008878', '1528008878');
INSERT INTO `yf_hf_uninterested` VALUES ('19', '587', '694', '1', '3', '1', '1528008905', '1528008905');
INSERT INTO `yf_hf_uninterested` VALUES ('20', '2021', '703', '1', '3', '2', '1528019546', '1528019546');
INSERT INTO `yf_hf_uninterested` VALUES ('21', '570', '703', '1', '3', '2', '1528020172', '1528020172');
INSERT INTO `yf_hf_uninterested` VALUES ('22', '2026', '709', '0', '2', '1', '1528030453', '1528030453');
INSERT INTO `yf_hf_uninterested` VALUES ('23', '2021', '701', '1', '1', '0', '1528032379', '1528032379');
INSERT INTO `yf_hf_uninterested` VALUES ('24', '570', '712', '1', '1', '0', '1528074653', '1528074653');
INSERT INTO `yf_hf_uninterested` VALUES ('25', '570', '690', '1', '2', '2', '1528075730', '1528075730');
INSERT INTO `yf_hf_uninterested` VALUES ('26', '521', '698', '0', '5', '3', '1528077940', '1528077940');
INSERT INTO `yf_hf_uninterested` VALUES ('27', '521', '707', '0', '1', '0', '1528077984', '1528077984');
INSERT INTO `yf_hf_uninterested` VALUES ('28', '2025', '724', '0', '3', '1', '1528097626', '1528097626');
INSERT INTO `yf_hf_uninterested` VALUES ('29', '513', '720', '1', '2', '0', '1528103986', '1528103986');
INSERT INTO `yf_hf_uninterested` VALUES ('30', '2025', '729', '0', '3', '1', '1528104431', '1528104431');
INSERT INTO `yf_hf_uninterested` VALUES ('31', '2024', '728', '1', '1', '0', '1528114974', '1528114974');
INSERT INTO `yf_hf_uninterested` VALUES ('32', '2024', '720', '1', '2', '0', '1528114985', '1528114985');
INSERT INTO `yf_hf_uninterested` VALUES ('33', '2063', '765', '1', '3', '1', '1528180280', '1528180280');
INSERT INTO `yf_hf_uninterested` VALUES ('34', '570', '0', '0', '0', '0', '1528279921', '1528279921');
INSERT INTO `yf_hf_uninterested` VALUES ('35', '2152', '820', '0', '5', '3', '1528283707', '1528283707');
INSERT INTO `yf_hf_uninterested` VALUES ('36', '473', '818', '1', '3', '2', '1528356395', '1528356395');
INSERT INTO `yf_hf_uninterested` VALUES ('37', '473', '815', '1', '3', '1', '1528356590', '1528356590');
INSERT INTO `yf_hf_uninterested` VALUES ('38', '2054', '833', '0', '3', '1', '1529391811', '1529391811');
INSERT INTO `yf_hf_uninterested` VALUES ('39', '2054', '910', '0', '1', '1', '1529391848', '1529391848');
INSERT INTO `yf_hf_uninterested` VALUES ('40', '2054', '905', '0', '1', '0', '1529395657', '1529395657');
INSERT INTO `yf_hf_uninterested` VALUES ('41', '2184', '940', '1', '1', '0', '1529481343', '1529481343');
INSERT INTO `yf_hf_uninterested` VALUES ('42', '521', '923', '0', '3', '1', '1529481500', '1529481500');
INSERT INTO `yf_hf_uninterested` VALUES ('43', '598', '1021', '1', '1', '0', '1529654384', '1529654384');

-- ----------------------------
-- Table structure for yf_hf_version
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_version`;
CREATE TABLE `yf_hf_version` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'app版本号',
  `version_no` varchar(80) DEFAULT NULL COMMENT '版本编号',
  `intro` text COMMENT '发布简述',
  `type` tinyint(3) DEFAULT '0' COMMENT '1 安卓 2苹果',
  `app_path` varchar(255) DEFAULT NULL COMMENT '地址',
  `status` tinyint(1) NOT NULL COMMENT '0审核中 1审核通过',
  `is_del` tinyint(3) DEFAULT '0' COMMENT '是否删除  0正常  1删除',
  `create_time` int(10) unsigned DEFAULT '0',
  `update_time` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_version
-- ----------------------------
INSERT INTO `yf_hf_version` VALUES ('22', '1.1.4', '最新版本发布', '2', 'https://itunes.apple.com/cn/app/id1383123091', '0', '0', '1528428782', '1531462753');
INSERT INTO `yf_hf_version` VALUES ('25', '1.1.4', '修复bugs;优化细节', '1', 'http://p79qapu16.bkt.clouddn.com/haifang-1.1.0.apk', '0', '0', '1528687193', '1531463133');

-- ----------------------------
-- Table structure for yf_hf_video
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_video`;
CREATE TABLE `yf_hf_video` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(50) DEFAULT '' COMMENT '标题',
  `video_link` varchar(100) DEFAULT '' COMMENT '视频链接',
  `video_type` int(11) DEFAULT '0' COMMENT '视频类型:买卖1 合租0 整租2',
  `video_cover` varchar(300) DEFAULT NULL COMMENT '视频封面',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '上1下0架',
  `examine` tinyint(4) DEFAULT '0',
  `sort` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '排序',
  `num_visits` int(11) DEFAULT '0' COMMENT '浏览数量',
  `num_favorite` int(11) DEFAULT '0' COMMENT '收藏数量',
  `num_comment` int(11) DEFAULT '0' COMMENT '评论数量',
  `num_room` int(10) DEFAULT '1' COMMENT '几室',
  `num_hall` int(10) DEFAULT '1' COMMENT '几厅',
  `num_toilet` tinyint(4) DEFAULT '0' COMMENT '几卫',
  `area` int(11) NOT NULL DEFAULT '0' COMMENT '面积',
  `price` double(10,2) DEFAULT '0.00' COMMENT '房价',
  `join_rent` tinyint(4) DEFAULT '0' COMMENT '是否合租：0不合租，1合租',
  `area_id` int(4) DEFAULT '0' COMMENT '地区id',
  `member_id` int(11) DEFAULT NULL COMMENT '用户id',
  `building_id` int(11) DEFAULT NULL COMMENT '小区id',
  `longitude` double DEFAULT NULL COMMENT '经度',
  `latitude` double DEFAULT NULL COMMENT '纬度',
  `app_version` varchar(100) DEFAULT NULL COMMENT '用户当前版本',
  `remarks` varchar(100) DEFAULT NULL COMMENT '个人备注，其它人看不到',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0未删除 1已删除',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1153 DEFAULT CHARSET=utf8 COMMENT='视频表';

-- ----------------------------
-- Records of yf_hf_video
-- ----------------------------
INSERT INTO `yf_hf_video` VALUES ('793', '一室户，独立厨卫，急租', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180606073032', '0', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180606072925', '1', '1', '1', '849', '3', '5', '1', '0', '1', '20', '1500.00', '1', '582', '2106', '18187', '121.627954', '31.197106', '1.0.0', '看看吧', '0', '1528241440', '1531290843');
INSERT INTO `yf_hf_video` VALUES ('797', '房东诚意出售，价格可谈', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180606103813', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180606103519', '1', '0', '1', '774', '3', '3', '3', '2', '1', '108', '790.00', null, '581', '2059', '8405', '121.40362', '31.236504', '1.0.0', '', '0', '1528252719', '1528774100');
INSERT INTO `yf_hf_video` VALUES ('833', '新房子，现在就我一个人住，等待舍友的出现。。。', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180606225248', '0', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180606225132', '1', '0', '1', '1612', '7', '23', '3', '1', '1', '60', '4000.00', '1', '587', '473', '12601', '121.253322', '31.330544', '1.0.0', '快来看看吧', '0', '1528296787', '1531477091');
INSERT INTO `yf_hf_video` VALUES ('882', '楼王位置！', 'http://p79qkwz6c.bkt.clouddn.com/huangpuxinyuan.mp4', '1', 'http://p79qkwz6c.bkt.clouddn.com/huangpuxinyuan.jpg', '1', '0', '1', '515', '3', '5', '3', '2', '1', '127', '1050.00', null, '583', '598', '16834', '121.484179', '31.209388', '1.0.0', '', '0', '1528697124', '1529656073');
INSERT INTO `yf_hf_video` VALUES ('897', '用的是流量啊啊啊啊啊啊啊啊', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180613143603', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180613143514', '1', '1', '1', '449', '1', '5', '3', '1', '1', '45', '23.00', null, '578', '575', '7503', '121.457612', '31.164178', '1.0.0', '', '0', '1528871761', '1528971708');
INSERT INTO `yf_hf_video` VALUES ('898', '拥有几十年的产权，值得信赖', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180613150855', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180613150751', '0', '0', '1', '33', '0', '8', '2', '1', '1', '67', '254.00', null, '578', '579', '18764', '121.458299', '31.166434', '1.0.0', '等等', '0', '1528873738', '1528969658');
INSERT INTO `yf_hf_video` VALUES ('899', '那你就那就将就坎坎坷坷看坎坎坷坷看看密密麻麻魔女娜娜扭扭捏捏那你呢扭扭捏捏扭扭捏捏那你呢扭扭捏捏扭扭', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180613151937', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180613151842', '1', '0', '1', '7', '0', '3', '1', '0', '0', '2147483647', '99999999.99', null, '578', '570', '7503', '121.457635', '31.164218', '1.0.0', '', '1', '1528874389', '1528874389');
INSERT INTO `yf_hf_video` VALUES ('900', '咯哦哦', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180614105913', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180614102050', '1', '0', '1', '3', '0', '1', '1', '0', '0', '555', '85.00', '0', '578', '449', '7534', '121.4535856', '31.16486987', '1.0.0', '标记管理你的房子，别人看不到', '1', '1528945154', '1528945154');
INSERT INTO `yf_hf_video` VALUES ('901', 'jjlosong', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180614161331', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180614161305', '1', '0', '1', '120', '1', '1', '1', '0', '0', '56', '85.00', '0', '578', '449', '7534', '121.4535856', '31.16486987', '1.0.0', null, '1', '1528964035', '1529028636');
INSERT INTO `yf_hf_video` VALUES ('902', '微微一笑', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180615100105', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180615100042', '1', '0', '1', '87', '0', '4', '1', '1', '0', '36', '150.00', null, '578', '575', '7523', '121.457661', '31.164185', '1.0.0', '', '0', '1529028064', '1529028064');
INSERT INTO `yf_hf_video` VALUES ('903', '（宋健）中等楼层，正常首付可改两房，随时可入住。', 'http://p79qkwz6c.bkt.clouddn.com/test.mp4', '1', 'http://p79qkwz6c.bkt.clouddn.com/test.mp4_img.jpg', '1', '0', '1', '97', '0', '0', '1', '1', '1', '62', '110.00', '0', '587', '1967', '12927', '121.164623', '31.374811', '1.0.0', '', '0', '1529028160', '1529028160');
INSERT INTO `yf_hf_video` VALUES ('904', '危险品', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180615100505', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180615100433', '1', '0', '1', '193', '0', '4', '1', '0', '1', '25', '2.00', null, '578', '575', '7503', '121.457633', '31.164207', '1.0.0', '', '0', '1529028310', '1530691318');
INSERT INTO `yf_hf_video` VALUES ('905', '欢迎围观', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180615133406', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180615133330', '1', '0', '1', '133', '1', '12', '1', '0', '0', '5', '5.00', '0', '578', '579', '18768', '121.451545', '31.163774', '1.0.0', '标记管理你的房子，别人看不到', '1', '1529040847', '1529043809');
INSERT INTO `yf_hf_video` VALUES ('906', '罗南七号线小两室精装修房东急售出行便利性价比高', 'http://p79qkwz6c.bkt.clouddn.com/1006409882624090113_3_22.mp4.f30.mp4', '1', 'http://p79qkwz6c.bkt.clouddn.com/1006409882624090113_3_22.mp4.f30.mp4_img.jpg', '1', '0', '1', '230', '0', '0', '2', '1', '1', '55', '175.00', '0', '586', '1181', '6410', '121.36817', '31.389613', '1.0.0', '', '0', '1529041631', '1529041631');
INSERT INTO `yf_hf_video` VALUES ('907', '咯哦哦哦哦', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180615141221', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180615141143', '1', '0', '1', '16', '0', '3', '1', '0', '0', '58', '58.00', '0', '578', '449', '7540', '121.450384', '31.171308', '1.0.0', '标记管理你的房子，别人看不到', '1', '1529043172', '1529043172');
INSERT INTO `yf_hf_video` VALUES ('908', '同咯哦', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180615142929', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180615142901', '1', '0', '1', '13', '1', '8', '1', '0', '0', '85', '86.00', '0', '578', '449', '8634', '121.450674', '31.1622', '1.0.0', '标记管理你的房子，别人看不到', '1', '1529044192', '1529391147');
INSERT INTO `yf_hf_video` VALUES ('909', '塘和家园 实地拍照 毛坯房 有钥匙', 'http://p79qkwz6c.bkt.clouddn.com/1001008133176315904_3_22.mp4.f30.mp4', '1', 'http://p79qkwz6c.bkt.clouddn.com/1001008133176315904_3_22.mp4.f30.mp4_img.jpg', '1', '0', '1', '264', '0', '0', '2', '1', '1', '66', '176.00', '0', '590', '1803', '11757', '121.259957', '31.105423', '1.0.0', '', '0', '1529059459', '1529059459');
INSERT INTO `yf_hf_video` VALUES ('910', '说点什么好呢', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180619102532', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180619102351', '1', '0', '1', '92', '0', '2', '1', '1', '0', '35', '4000.00', '0', '578', '2054', '7513', '121.4552483', '31.16542876', '1.1.0', null, '1', '1529375289', '1529399569');
INSERT INTO `yf_hf_video` VALUES ('911', '哈哈哈姐姐家家户户还好还好哈刚好回家看看好大的v几个地方汉库克不反对攻坚克难规范化i就好黄v不将就近', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180619105241', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180619105202', '1', '0', '1', '93', '0', '4', '1', '0', '0', '566', '8556.00', null, '578', '570', '7503', '121.457783', '31.164261', '1.0.0', '', '1', '1529376766', '1529376766');
INSERT INTO `yf_hf_video` VALUES ('913', '哈哈哈哈哼哼唧唧斤斤计较斤斤计较斤斤计较健健康康坎坎坷坷看坎坎坷坷坎坎坷坷看坎坎坷坷看快快快坎坎坷坷', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180619132832', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180619132740', '1', '0', '1', '2', '0', '1', '1', '0', '0', '56663', '66666.00', null, '578', '570', '7503', '121.457725', '31.164245', '1.0.0', '就看看坎坎坷坷看看看健健康康坎坎坷坷近近景近景近近景近景看看JJ坎坎坷坷看坎坎坷坷看坎坎坷坷看看看', '1', '1529386124', '1529386124');
INSERT INTO `yf_hf_video` VALUES ('914', '紫薇茗庭 房东自住精装修 住了一年 诚心出售 可正常首付贷款', 'http://p79qkwz6c.bkt.clouddn.com/988614584568926208.mp4.f30.mp4', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180619132740', '1', '0', '1', '121', '0', '0', '2', '1', '1', '67', '175.00', '0', '587', '1761', '12927', '121.254533', '31.097594', '1.0.0', '', '0', '1529389210', '1529389210');
INSERT INTO `yf_hf_video` VALUES ('916', '首付15万！人才公寓！挑高4.5米！婚房装修！产权清晰！急售', 'http://p79qkwz6c.bkt.clouddn.com/1004173925254451200_3_22.mp4.f30.mp4', '1', '', '1', '0', '1', '87', '0', '0', '2', '2', '1', '48', '55.00', '0', '588', '1141', '2320', '121.708766', '31.252522', '1.0.0', '', '0', '1529392140', '1529392140');
INSERT INTO `yf_hf_video` VALUES ('917', '总价低产权住宅首付40电梯洋房智能精装可落户无税费', 'http://p79qkwz6c.bkt.clouddn.com/1004173925254451200_3_22.mp4.f30.mp4', '1', 'http://p79qkwz6c.bkt.clouddn.com/1006375135675969539_3_22.mp4.f30.mp4_img.jpg', '1', '0', '1', '109', '1', '0', '2', '2', '1', '77', '160.00', '0', '588', '1554', '2320', '121.74955', '30.901185', '1.0.0', '', '0', '1529392261', '1531389867');
INSERT INTO `yf_hf_video` VALUES ('918', '亲水湾一手精装修现房，只缴契税，中秧空调加新风系统，免金！', 'http://p79qkwz6c.bkt.clouddn.com/981726744966889473_3_22.mp4.f30.mp4', '1', '', '1', '0', '1', '143', '1', '0', '4', '2', '2', '142', '880.00', '0', '588', '1483', '3750', '121.585852', '31.155823', '1.0.0', '', '0', '1529394565', '1529549794');
INSERT INTO `yf_hf_video` VALUES ('919', '整租整租123', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180619162443', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180619162313', '1', '0', '1', '62', '0', '2', '3', '2', '1', '200', '2600.00', '0', '578', '2203', '8619', '121.451545', '31.163774', '1.1.0', '石龙小区石龙小区', '1', '1529396687', '1529396687');
INSERT INTO `yf_hf_video` VALUES ('920', '新青浦佳园,地铁通到家门口,精装修,房型好,楼层好,急售', 'http://p79qkwz6c.bkt.clouddn.com/1006405425886691329_3_22.mp4.f30.mp4', '1', 'http://p79qkwz6c.bkt.clouddn.com/1006405425886691329_3_22.mp4.f30.mp4_img.jpg', '1', '0', '1', '142', '1', '0', '3', '2', '2', '128', '320.00', '0', '591', '776', '15685', '121.135327', '31.162299', '1.0.0', '', '0', '1529401985', '1531389860');
INSERT INTO `yf_hf_video` VALUES ('921', '静安彭浦，南北通透，有饭厅，看房随时，有钥匙。诚意出售', 'http://p79qkwz6c.bkt.clouddn.com/1006463689810796544.mp4.f30.mp4', '1', 'http://p79qkwz6c.bkt.clouddn.com/1006463689810796544.mp4.f30.mp4_img.jpg', '1', '0', '1', '219', '1', '0', '2', '0', '1', '42', '193.00', '0', '582', '1962', '17355', '121.464284', '31.326016', '1.0.0', '', '0', '1529402103', '1531389853');
INSERT INTO `yf_hf_video` VALUES ('922', '我这里的房子不多，但都是你想要的。三房一厅一卫满五年送车库！', 'http://p79qkwz6c.bkt.clouddn.com/1003877127285657600_3_22.mp4.f30.mp4', '1', 'http://p79qkwz6c.bkt.clouddn.com/1003877127285657600_3_22.mp4.f30.mp4_img.jpg', '1', '0', '1', '297', '0', '0', '3', '1', '1', '66', '132.00', '0', '583', '664', '16304', '121.147419', '31.265569', '1.0.0', '', '0', '1529402509', '1531465950');
INSERT INTO `yf_hf_video` VALUES ('923', '我这里的房子不多，但都是你想要的。三房一厅一卫满五年送车库！', 'http://p79qkwz6c.bkt.clouddn.com/1003877127285657600_3_22.mp4.f30.mp4', '1', 'http://p79qkwz6c.bkt.clouddn.com/1003877127285657600_3_22.mp4.f30.mp4_img.jpg', '1', '0', '1', '1435', '2', '1', '3', '1', '1', '66', '132.00', '0', '583', '1647', '16304', '121.147419', '31.265569', '1.0.0', '', '0', '1529404876', '1531465897');
INSERT INTO `yf_hf_video` VALUES ('924', '单间适合一个人居住', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180620101518', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180620101425', '1', '0', '1', '14', '0', '2', '1', '0', '0', '18', '2000.00', null, '578', '579', '7523', '121.457638', '31.164166', '1.0.0', '没那么', '1', '1529460916', '1529460916');
INSERT INTO `yf_hf_video` VALUES ('925', '紧邻地铁，购物商场方便', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180620105501', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180620105321', '1', '0', '1', '19', '0', '2', '2', '1', '1', '80', '365.00', null, '578', '579', '7447', '121.457624', '31.164176', '1.0.0', '你没有', '1', '1529463302', '1529463302');
INSERT INTO `yf_hf_video` VALUES ('926', '看房的赶紧过来哈', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180620110113', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180620110030', '1', '0', '1', '5', '0', '1', '3', '1', '1', '105', '5200.00', '0', '578', '579', '7513', '121.457628', '31.164179', '1.0.0', '女女', '1', '1529463674', '1529463674');
INSERT INTO `yf_hf_video` VALUES ('927', '转租，本人有事不在上海了，急于转租，非诚勿扰', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180620110652', '0', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180620110535', '1', '0', '1', '66', '19', '4', '1', '1', '1', '30', '2900.00', '1', '578', '579', '7464', '121.457646', '31.16417', '1.0.0', '没那么', '1', '1529464024', '1529464024');
INSERT INTO `yf_hf_video` VALUES ('929', '合租合租合租', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180620133437', '0', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180620133244', '1', '0', '1', '15', '14', '1', '3', '2', '1', '200', '30000.00', '1', '578', '2184', '8156', '121.457626', '31.164191', '1.0.0', '', '1', '1529472913', '1529472913');
INSERT INTO `yf_hf_video` VALUES ('930', '合租合租合租', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180620133745', '0', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180620133510', '1', '0', '1', '75', '1', '2', '2', '2', '1', '200', '30000.00', '1', '578', '2203', '7479', '121.4519541', '31.17666902', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529473066', '1529549312');
INSERT INTO `yf_hf_video` VALUES ('931', '出售出957', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180620134427', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180620134343', '1', '0', '1', '75', '9', '13', '2', '1', '1', '260', '3000.00', null, '578', '2184', '7502', '121.457622', '31.164184', '1.0.0', '', '1', '1529473468', '1529483022');
INSERT INTO `yf_hf_video` VALUES ('933', '雅居乐二楼带大露台、户型正气、22号线+影视基地、升直潜力大', '', '1', '', '1', '0', '1', '103', '0', '0', '3', '2', '1', '117', '280.00', '0', '590', '660', '11423', '121.31737', '31.013677', '1.0.0', '', '1', '1529474484', '1529488413');
INSERT INTO `yf_hf_video` VALUES ('934', '出售出售出售123', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180620142623', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180620142527', '1', '0', '1', '68', '15', '13', '3', '2', '1', '160', '2000.00', null, '578', '2184', '8150', '121.457657', '31.164188', '1.0.0', '', '1', '1529475987', '1529485614');
INSERT INTO `yf_hf_video` VALUES ('935', '出售出售', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180620143014', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180620142945', '1', '0', '1', '23', '19', '1', '5', '2', '3', '222', '3333.00', null, '578', '2184', '7502', '121.45766', '31.164193', '1.0.0', '', '1', '1529476216', '1529481268');
INSERT INTO `yf_hf_video` VALUES ('939', '整租123', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180620154016', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180620153951', '1', '0', '1', '79', '13', '5', '2', '2', '1', '200', '3000.00', '0', '578', '521', '7522', '121.4576584', '31.16161238', '1.1.0', null, '1', '1529480586', '1529482425');
INSERT INTO `yf_hf_video` VALUES ('940', '蝴蝶结假的', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180620155230', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180620155209', '1', '0', '1', '209', '15', '8', '1', '0', '0', '56', '56.00', '0', '578', '568', '7464', '121.4557304', '31.16704511', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529481276', '1529549540');
INSERT INTO `yf_hf_video` VALUES ('942', '那就将就近近景近景看近近景近景家近近景近景解决斤斤计较就就斤斤计较急急急近近景近景近近景近景家斤斤计', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180620170405', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180620170321', '1', '0', '1', '1', '16', '5', '1', '0', '0', '5566', '8966.00', null, '578', '570', '7523', '121.457604', '31.164191', '1.0.0', '哼哼唧唧坎坎坷坷看快快快i哭唧唧姐姐', '1', '1529485471', '1529485471');
INSERT INTO `yf_hf_video` VALUES ('943', '合租合租', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180620170443', '0', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180620170423', '1', '0', '1', '48', '7', '4', '3', '2', '1', '200', '3000.00', '1', '578', '521', '7523', '121.459296', '31.164613', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529485505', '1529485532');
INSERT INTO `yf_hf_video` VALUES ('947', '买卖二手房', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180620224612', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180620224518', '1', '0', '1', '30', '1', '0', '3', '1', '1', '86', '256.00', null, '585', '579', '5611', '121.504909', '31.122236', '1.0.0', '没那么', '1', '1529505975', '1529549546');
INSERT INTO `yf_hf_video` VALUES ('948', '买卖二手房', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180620224618', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180620224518', '1', '0', '1', '51', '1', '0', '3', '1', '1', '86', '256.00', null, '585', '579', '5611', '121.504909', '31.122236', '1.0.0', '没那么', '1', '1529505983', '1529549565');
INSERT INTO `yf_hf_video` VALUES ('949', '买卖二手房', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180605195035', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180605194614', '1', '0', '1', '0', '0', '0', '3', '1', '1', '86', '256.00', '0', null, '579', '3434', '121.537036', '31.162872', null, '111', '1', '1529506417', '1529506417');
INSERT INTO `yf_hf_video` VALUES ('950', '买卖二手房', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180605195035', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180605194614', '1', '0', '1', '0', '0', '0', '3', '1', '1', '86', '256.00', '0', null, '579', '3434', '121.537036', '31.162872', null, '111', '1', '1529506594', '1529506594');
INSERT INTO `yf_hf_video` VALUES ('951', '买卖二手房', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180605195035', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180605194614', '1', '0', '1', '1', '0', '0', '3', '1', '1', '86', '256.00', '0', null, '579', '3434', '121.537036', '31.162872', null, '111', '1', '1529507113', '1529507113');
INSERT INTO `yf_hf_video` VALUES ('952', '买卖二手房', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180605195035', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180605194614', '1', '0', '1', '14', '0', '3', '3', '1', '1', '86', '256.00', '0', null, '579', '3434', '121.537036', '31.162872', null, '111', '1', '1529507226', '1529507226');
INSERT INTO `yf_hf_video` VALUES ('965', '出售出售957', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180621100644', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180621100554', '1', '0', '1', '7', '0', '0', '4', '2', '1', '200', '30000.00', null, '578', '2223', '7495', '121.45766', '31.164198', '1.0.0', '', '1', '1529546806', '1529546806');
INSERT INTO `yf_hf_video` VALUES ('968', '快来抢购', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180621103007', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180621102919', '1', '0', '1', '28', '1', '1', '2', '1', '1', '75', '280.00', null, '578', '579', '8146', '121.457708', '31.164218', '1.0.0', '你们', '1', '1529548213', '1529549953');
INSERT INTO `yf_hf_video` VALUES ('969', '抢购1', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180621103007', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-', '1', '0', '1', '3', '0', '0', '2', '1', '1', '80', '250.00', '0', '578', '579', '8146', '121.457708', '31.164218', null, '1111', '1', '1529549113', '1529549113');
INSERT INTO `yf_hf_video` VALUES ('970', '抢购1', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180621103007', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-', '1', '0', '1', '10', '0', '0', '2', '1', '1', '80', '250.00', '0', '578', '579', '8146', '121.457708', '31.164218', null, '1111', '1', '1529549162', '1529549162');
INSERT INTO `yf_hf_video` VALUES ('971', '抢购1', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180621103007', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-', '1', '0', '1', '27', '0', '0', '2', '1', '1', '80', '250.00', '0', '578', '579', '8146', '121.457708', '31.164218', null, '1111', '1', '1529549274', '1529549779');
INSERT INTO `yf_hf_video` VALUES ('975', '哈哈哈', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180621110238', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180621110215', '1', '0', '1', '133', '1', '2', '4', '1', '3', '160', '360.00', '0', '578', '2223', '7523', '121.457789', '31.164276', '1.1.0', '', '1', '1529550160', '1529559611');
INSERT INTO `yf_hf_video` VALUES ('985', '合租合租96', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180621131711', '0', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180621131642', '1', '0', '1', '91', '1', '3', '3', '1', '2', '200', '2600.00', '1', '578', '2184', '8628', '121.455365', '31.163235', '1.1.0', '嘿嘿', '1', '1529558272', '1529559851');
INSERT INTO `yf_hf_video` VALUES ('995', '咯公公', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180621151902', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180621151840', '1', '0', '1', '14', '1', '1', '1', '0', '0', '55', '55.00', '0', '578', '449', '7513', '121.4552483', '31.16542876', '1.0.0', '标记管理你的房子，别人看不到', '1', '1529565596', '1529565596');
INSERT INTO `yf_hf_video` VALUES ('996', '来渡过难关', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180621152144', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180621152121', '1', '0', '1', '45', '0', '2', '1', '0', '0', '8', '5.00', '0', '578', '449', '7534', '121.4535856', '31.16486987', '1.0.0', '标记管理你的房子，别人看不到', '1', '1529565727', '1529565727');
INSERT INTO `yf_hf_video` VALUES ('997', '老婆婆婆', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180621154438', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180621154415', '1', '0', '1', '25', '0', '2', '1', '0', '0', '886', '9767.00', '0', '578', '449', '7534', '121.4535856', '31.16486987', '1.0.0', '标记管理你的房子，别人看不到', '1', '1529567094', '1529567094');
INSERT INTO `yf_hf_video` VALUES ('998', '逆您名', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180621155354', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180621155328', '1', '0', '1', '30', '0', '1', '1', '0', '0', '55', '55.00', '0', '578', '449', '7534', '121.4535856', '31.16486987', '1.0.0', '标记管理你的房子，别人看不到', '1', '1529567652', '1529567652');
INSERT INTO `yf_hf_video` VALUES ('1002', '好的蝴蝶结假的', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180621181240', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180621181221', '1', '0', '1', '3', '0', '1', '1', '0', '0', '55', '55.00', '0', '578', '568', '8628', '121.455365', '31.163235', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529575982', '1529575982');
INSERT INTO `yf_hf_video` VALUES ('1006', '整租957', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180622091809', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180622091714', '1', '0', '1', '126', '1', '25', '3', '2', '2', '200', '1600.00', '0', '578', '2223', '7513', '121.4552483', '31.16542876', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529630376', '1529643121');
INSERT INTO `yf_hf_video` VALUES ('1007', '出售123', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180622092212', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180622092147', '1', '0', '1', '104', '1', '4', '3', '1', '2', '200', '3000.00', '0', '578', '2223', '8619', '121.451545', '31.163774', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529630559', '1529632395');
INSERT INTO `yf_hf_video` VALUES ('1008', '紧急出售紧急出售', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622092918', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622092917', '1', '0', '1', '66', '1', '1', '3', '2', '1', '200', '1600.00', null, '578', '2184', '7447', '121.457641', '31.164195', '1.0.0', '', '1', '1529631051', '1529644400');
INSERT INTO `yf_hf_video` VALUES ('1009', '哈哈哈哈南京', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622100421', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622100421', '1', '0', '1', '51', '0', '1', '1', '0', '0', '555', '555.00', null, '578', '570', '7523', '121.457618', '31.164192', '1.0.0', '', '1', '1529633097', '1529633097');
INSERT INTO `yf_hf_video` VALUES ('1010', '今明你民工', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180622100557', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180622100533', '1', '0', '1', '63', '0', '1', '1', '0', '0', '355', '88.00', '0', '578', '449', '7534', '121.4535856', '31.16486987', '1.0.0', '标记管理你的房子，别人看不到', '1', '1529633186', '1529633186');
INSERT INTO `yf_hf_video` VALUES ('1011', '哈哈哈哈', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622101159', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622101158', '1', '0', '1', '131', '2', '4', '1', '0', '0', '566', '566.00', null, '578', '570', '7503', '121.457574', '31.164232', '1.0.0', '', '1', '1529633592', '1529655852');
INSERT INTO `yf_hf_video` VALUES ('1012', '出售此号', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622105814', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622105814', '1', '0', '1', '183', '3', '15', '4', '2', '2', '60', '2000.00', null, '578', '2184', '7513', '121.457605', '31.164171', '1.0.0', '', '1', '1529636342', '1529653452');
INSERT INTO `yf_hf_video` VALUES ('1013', '测试工程师', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622111537', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622111537', '1', '0', '1', '165', '0', '0', '1', '0', '0', '58', '588.00', null, '578', '598', '8635', '121.457794', '31.164198', '1.0.0', '', '1', '1529637369', '1529637369');
INSERT INTO `yf_hf_video` VALUES ('1014', '你说要走', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622112748', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622112747', '1', '0', '1', '96', '1', '0', '1', '0', '0', '8598', '5666.00', '0', '578', '598', '8622', '121.457705', '31.164217', '1.0.0', '', '1', '1529638106', '1529651839');
INSERT INTO `yf_hf_video` VALUES ('1015', '发发发分回来看见古古怪怪好', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622131108', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622131108', '1', '0', '1', '195', '2', '42', '1', '0', '0', '888', '5855.00', null, '578', '570', '7503', '121.457592', '31.164202', '1.0.0', '', '1', '1529644293', '1529892555');
INSERT INTO `yf_hf_video` VALUES ('1016', '测试丹', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180622130013', '0', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180622125934', '0', '0', '1', '73', '0', '12', '1', '0', '0', '1', '1.00', '1', '578', '566', '7447', '121.459407', '31.163197', '1.1.0', '那谁能看见', '1', '1529644308', '1529651923');
INSERT INTO `yf_hf_video` VALUES ('1017', '你说要走', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622133933', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622133933', '0', '0', '1', '58', '1', '2', '1', '0', '0', '123', '4567.00', '0', '578', '598', '7527', '121.457398', '31.164499', '1.0.0', '', '1', '1529646005', '1529650907');
INSERT INTO `yf_hf_video` VALUES ('1018', '欢迎来看房哦', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622133809', '0', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622133803', '1', '0', '1', '124', '1', '2', '1', '0', '0', '20', '3000.00', '1', '578', '579', '8628', '121.457608', '31.164163', '1.0.0', '你没有', '1', '1529646063', '1529646063');
INSERT INTO `yf_hf_video` VALUES ('1019', '你说要走', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622140112', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622140112', '1', '0', '1', '97', '2', '1', '1', '0', '0', '123', '456.00', null, '578', '598', '7503', '121.45758', '31.164305', '1.0.0', '', '1', '1529647308', '1529647308');
INSERT INTO `yf_hf_video` VALUES ('1020', '展现', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622141313', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622141313', '1', '0', '1', '146', '1', '1', '5', '3', '3', '456', '5588.00', null, '578', '598', '7503', '121.457639', '31.16416', '1.0.0', '', '1', '1529648024', '1529656744');
INSERT INTO `yf_hf_video` VALUES ('1021', '我是小孩子', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622150300', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622150300', '1', '0', '1', '233', '2', '4', '1', '0', '0', '200', '205.00', null, '578', '580', '8146', '121.457532', '31.165507', '1.0.0', '', '1', '1529651070', '1529655513');
INSERT INTO `yf_hf_video` VALUES ('1022', '整租', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622153629', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622153629', '1', '0', '1', '84', '3', '8', '3', '2', '1', '260', '2600.00', '0', '578', '2223', '7534', '121.457613', '31.164181', '1.0.0', '', '1', '1529653118', '1529655060');
INSERT INTO `yf_hf_video` VALUES ('1023', '给哈哈哈哈', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180622162242', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180622162202', '1', '0', '1', '76', '0', '1', '3', '3', '2', '200', '260.00', '0', '578', '449', '8619', '121.451545', '31.163774', '1.0.0', '标记管理你的房子，别人看不到', '1', '1529655947', '1529655947');
INSERT INTO `yf_hf_video` VALUES ('1024', '整租0544', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622162615', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622162615', '1', '0', '1', '68', '0', '3', '3', '1', '3', '160', '2000.00', '0', '578', '2184', '7464', '121.457677', '31.164194', '1.1.0', null, '1', '1529656049', '1529662505');
INSERT INTO `yf_hf_video` VALUES ('1025', '出租', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180622164219', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180622164159', '1', '0', '1', '14', '0', '3', '5', '2', '0', '200', '2600.00', '0', '578', '2223', '7522', '121.4576584', '31.16161238', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529656967', '1529656967');
INSERT INTO `yf_hf_video` VALUES ('1026', '出售', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622164120', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622164111', '1', '0', '1', '37', '1', '9', '3', '2', '1', '260', '2000.00', null, '578', '2184', '7513', '121.457608', '31.164183', '1.0.0', '', '1', '1529657133', '1529892563');
INSERT INTO `yf_hf_video` VALUES ('1027', '出售', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180622164609', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180622164550', '1', '0', '1', '46', '0', '3', '3', '1', '2', '160', '2600.00', '0', '578', '2223', '7534', '121.4535856', '31.16486987', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529657236', '1529657236');
INSERT INTO `yf_hf_video` VALUES ('1028', '出租', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180622164841', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180622164818', '1', '0', '1', '84', '0', '1', '3', '1', '3', '160', '230.00', '0', '578', '2223', '8628', '121.455365', '31.163235', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529657341', '1529657341');
INSERT INTO `yf_hf_video` VALUES ('1029', '出售出售', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622171156', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622171156', '1', '0', '1', '41', '1', '6', '3', '2', '1', '160', '1800.00', null, '578', '2077', '7464', '121.457617', '31.164179', '1.0.0', '', '1', '1529658769', '1529659625');
INSERT INTO `yf_hf_video` VALUES ('1030', '反弹态势', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180622172208', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180622172150', '1', '0', '1', '13', '0', '3', '1', '0', '0', '54', '5.00', '0', '578', '568', '8628', '121.455365', '31.163235', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529659348', '1529659348');
INSERT INTO `yf_hf_video` VALUES ('1031', '整租', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622174333', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622174333', '1', '0', '1', '55', '0', '3', '3', '1', '1', '260', '3000.00', '0', '578', '570', '7513', '121.457679', '31.164201', '1.0.0', '', '1', '1529660653', '1529660653');
INSERT INTO `yf_hf_video` VALUES ('1032', '哼哼唧唧', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622174519', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622174519', '1', '0', '1', '0', '0', '3', '1', '0', '0', '666', '6666.00', null, '578', '570', '7447', '121.457668', '31.164222', '1.0.0', '胡军', '1', '1529660741', '1529660741');
INSERT INTO `yf_hf_video` VALUES ('1033', 'VB就你那姐姐', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622174803', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622174803', '1', '0', '1', '8', '0', '3', '1', '0', '0', '886', '5666.00', null, '578', '570', '7503', '121.457624', '31.164195', '1.0.0', '', '1', '1529660900', '1529660900');
INSERT INTO `yf_hf_video` VALUES ('1034', '能不能那你就', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622175500', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622175500', '1', '0', '1', '18', '0', '1', '1', '0', '0', '556', '966.00', null, '578', '570', '7447', '121.457621', '31.164195', '1.0.0', '', '1', '1529661321', '1529661321');
INSERT INTO `yf_hf_video` VALUES ('1035', '黑眼圈', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180622175734', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180622175650', '1', '0', '1', '29', '0', '3', '1', '0', '0', '100', '500.00', '0', '578', '566', '7447', '121.459407', '31.163197', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529661522', '1529661522');
INSERT INTO `yf_hf_video` VALUES ('1036', '2880', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622181202', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622181202', '1', '0', '1', '39', '0', '8', '3', '2', '1', '260', '2600.00', null, '578', '2077', '7534', '121.457615', '31.164173', '1.0.0', '', '1', '1529662389', '1529662389');
INSERT INTO `yf_hf_video` VALUES ('1037', '7655', 'http://p79qkwz6c.bkt.clouddn.com/video_iOS_20180622181156', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover_20180622181130', '1', '0', '1', '0', '0', '1', '3', '1', '1', '260', '2600.00', '0', '578', '2184', '7523', '121.459296', '31.164613', '1.1.0', '标记管理你的房子，别人看不到', '1', '1529662389', '1529662389');
INSERT INTO `yf_hf_video` VALUES ('1038', '不好好斤斤计较', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622181517', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622181516', '1', '0', '1', '6', '0', '1', '1', '0', '0', '886', '899.00', null, '578', '570', '7503', '121.45761', '31.164207', '1.0.0', '', '1', '1529662546', '1529662546');
INSERT INTO `yf_hf_video` VALUES ('1039', '哼哼唧唧看看', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180622181607', '2', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180622181607', '1', '0', '1', '5', '0', '3', '1', '0', '0', '899', '666.00', '0', '578', '570', '7513', '121.457812', '31.16426', '1.0.0', '', '1', '1529662619', '1529662619');
INSERT INTO `yf_hf_video` VALUES ('1040', '呵呵借口密密麻麻密密麻麻密密麻麻密密麻麻吗那你你呢扭扭捏捏那你呢扭扭捏捏那你呢没看看坎坎坷坷看坎坎坷', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180625101336', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180625101336', '1', '0', '1', '35', '1', '1', '1', '0', '0', '66666', '66666.00', null, '578', '570', '7503', '121.45765', '31.164291', '1.0.0', 'u就看你密密麻麻慢慢么么么强买强卖妈妈忙完没没忙完吗我们我们密密麻麻么么么我们我们我妈妈骂我', '1', '1529892885', '1529896958');
INSERT INTO `yf_hf_video` VALUES ('1041', '欢迎来看房哈', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180621103007', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-', '1', '0', '1', '28', '0', '1', '2', '1', '1', '80', '250.00', '0', '578', '514', '8145', '121.457708', '31.164218', '1.0.0', '1111', '1', '1529896735', '1529896735');
INSERT INTO `yf_hf_video` VALUES ('1042', '看房的赶紧来', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180621103007', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-', '1', '0', '1', '41', '0', '1', '2', '1', '1', '80', '250.00', '0', '578', '514', '8145', '121.457708', '31.164218', '1.0.0', '1111', '1', '1529896813', '1529896813');
INSERT INTO `yf_hf_video` VALUES ('1043', '健健康康坎坎坷坷哼哼唧唧坎坎坷坷看姐姐斤斤计较看我看我开机键加看尽快快快快看看看能jjkjh急急急\n', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180625112322', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180625112322', '1', '0', '1', '64', '0', '1', '1', '0', '0', '6666', '8966.00', null, '578', '570', '7503', '121.457697', '31.164277', '1.0.0', '', '1', '1529897067', '1529897067');
INSERT INTO `yf_hf_video` VALUES ('1044', '时间不等人，赶紧来抢购', 'http://p79qkwz6c.bkt.clouddn.com/video-android-20180625164043', '1', 'http://p79qkwz6c.bkt.clouddn.com/cover-android-20180625164043', '1', '0', '1', '8', '0', '3', '3', '1', '2', '102', '300.00', null, '578', '579', '7513', '121.457734', '31.164233', '1.0.0', '的', '1', '1529916102', '1529916102');

-- ----------------------------
-- Table structure for yf_hf_video_58
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_video_58`;
CREATE TABLE `yf_hf_video_58` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(50) DEFAULT '' COMMENT '标题',
  `num_room` int(10) DEFAULT '1' COMMENT '几室',
  `num_hall` int(10) DEFAULT '1' COMMENT '几厅',
  `num_toilet` tinyint(4) DEFAULT '0' COMMENT '几卫',
  `price` double(10,2) DEFAULT '0.00' COMMENT '房价',
  `area` int(11) NOT NULL DEFAULT '0' COMMENT '面积',
  `building_id` int(11) DEFAULT NULL COMMENT '小区id',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态：0 已操作完，1未操作,2软删除',
  `area_id` int(4) DEFAULT '0' COMMENT '地区id',
  `building` varchar(100) DEFAULT '' COMMENT '小区',
  `address` varchar(100) DEFAULT '' COMMENT '地址',
  `longitude` double DEFAULT NULL COMMENT '经度',
  `latitude` double DEFAULT NULL COMMENT '纬度',
  `videolink` varchar(100) DEFAULT '' COMMENT '视频链接',
  `videoname` varchar(100) DEFAULT '' COMMENT '视频name',
  `url` varchar(100) DEFAULT '' COMMENT 'url',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3291 DEFAULT CHARSET=utf8 COMMENT='视频表';

-- ----------------------------
-- Records of yf_hf_video_58
-- ----------------------------
INSERT INTO `yf_hf_video_58` VALUES ('906', '真实.房源实拍，别让虚假房源欺骗了你的感情。', '3', '2', '2', '200.00', '120', '0', '1', '0', '外冈景苑', '嘉定', '121.164623', '31.374811', 'https://58fang-10011010.video.myqcloud.com/58fang/1006717136564940801_3_22.mp4.f30.mp4', '1006717136564940801_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413161885902x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('907', '不搞虚假首付90万随时可以看房', '2', '2', '1', '145.00', '83', '0', '1', '0', '外冈景苑', '嘉定', '121.164623', '31.374811', 'https://58fang-10011010.video.myqcloud.com/58fang/1006717722714730497_3_22.mp4.f30.mp4', '1006717722714730497_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413124398134x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('917', '业主新挂牌 产权清晰 户口已迁 名额不占   置换诚售', '2', '1', '1', '520.00', '51', '0', '1', '0', '梅园三街坊', '浦东', '121.531872', '31.24025', 'https://58fang-10011010.video.myqcloud.com/58fang/1006362805533696001_3_22.mp4.f30.mp4', '1006362805533696001_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34402632044076x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('919', '新 崇明主城区小面积低总价优.质房源比的就是速度', '2', '2', '1', '50.00', '56', '0', '1', '0', '光华新村', '崇明', '121.548106', '31.685007', 'https://58fang-10011010.video.myqcloud.com/58fang/1006494393076572160_3_22.mp4.f30.mp4', '1006494393076572160_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34406647290057x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('921', '首付只需80万轻松买中套，随时可入住。', '2', '2', '1', '140.00', '81', '0', '1', '0', '外冈景苑', '嘉定', '121.164623', '31.374811', 'https://58fang-10011010.video.myqcloud.com/58fang/1006715715530551297_3_22.mp4.f30.mp4', '1006715715530551297_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413398703415x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('928', '石化一村南北房精装修房东把房型改得很好拎包入住低总价', '2', '2', '1', '125.00', '89', '0', '1', '0', '石化一村', '金山', '121.345051', '30.717767', 'https://58fang-10011010.video.myqcloud.com/58fang/1006711405207912449_3_22.mp4.f30.mp4', '1006711405207912449_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413188149568x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('948', '海尚馨苑豪装大三房+对口金山小学和金山中学+金山万达附近', '3', '2', '2', '270.00', '134', '0', '1', '0', '海尚馨苑', '金山', '121.354665', '30.761068', 'https://58fang-10011010.video.myqcloud.com/58fang/1002488040389627904_3_22.mp4.f30.mp4', '1002488040389627904_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34284212838335x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('952', '滨海花苑,成熟社区,机会留给有准备的人,亲、你准备好了吗？', '2', '2', '1', '85.00', '88', '0', '1', '0', '滨海花苑', '金山', '121.372654', '30.768002', 'https://58fang-10011010.video.myqcloud.com/58fang/1003810270209929217_3_22.mp4.f30.mp4', '1003810270209929217_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34324726225594x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('957', '房东诚心出售房源 看房有钥匙 精装修家具家电赠送 实地拍摄', '1', '0', '1', '84.00', '28', '0', '1', '0', '万乐城', '闵行', '121.452066', '31.044647', 'https://58fang-10011010.video.myqcloud.com/58fang/977376892438994944_3_22.mp4.f30.mp4', '977376892438994944_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33518045010512x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('960', '地铁口望佳一村5楼南北小三房213万急售 可随时看房满五唯一', '3', '1', '1', '213.00', '79', '0', '1', '0', '望佳一村', '闵行', '121.536608', '31.026163', 'https://58fang-10011010.video.myqcloud.com/58fang/997404833575108608_3_22.mp4.f30.mp4', '997404833575108608_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34129253198124x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('962', '巨龙台湾城急卖房、楼层好、地段佳、无增税、近地铁、配套齐全', '1', '1', '1', '115.00', '42', '0', '1', '0', '巨龙台湾城', '奉贤', '121.438995', '30.989819', 'https://58fang-10011010.video.myqcloud.com/58fang/994414247104512000_3_22.mp4.f30.mp4', '994414247104512000_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34037978946230x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('964', '新出房源五角场街道 部队品质小区 全明两房 我有钥匙随时看房', '2', '1', '1', '440.00', '71', '0', '1', '0', '天翔花苑', '杨浦', '121.51675', '31.302017', 'https://58fang-10011010.video.myqcloud.com/58fang/1002847889824702465_3_22.mp4.f30.mp4', '1002847889824702465_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34295312641716x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('969', '滚烫地段，南北通透1房，近龙柏地铁路站，精装看房随时', '1', '1', '1', '220.00', '47', '0', '1', '0', '龙柏四村', '闵行', '121.367365', '31.182959', 'https://58fang-10011010.video.myqcloud.com/58fang/1003458812662796290_3_22.mp4.f30.mp4', '1003458812662796290_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34314006873516x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('974', '低于市场价超值 急卖 看房随时方便，低于市场价40万急售', '1', '1', '1', '217.00', '46', '0', '1', '0', '龙柏四村', '闵行', '121.367365', '31.182959', 'https://58fang-10011010.video.myqcloud.com/58fang/1003823705626800130_3_22.mp4.f30.mp4', '1003823705626800130_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34325140206509x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('975', '永康城佳兴苑+190万70平全明户型+前后采光无遮挡+有钥匙', '2', '2', '1', '190.00', '69', '0', '1', '0', '永康城佳兴苑', '闵行', '121.517317', '31.04026', 'https://58fang-10011010.video.myqcloud.com/58fang/992938543288442880_3_22.mp4.f30.mp4', '992938543288442880_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33992949759677x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('976', '丽水湾新出2楼 小区中心位置 房东置换 有钥匙随时看', '2', '2', '1', '145.00', '86', '0', '1', '0', '丽水湾', '奉贤', '121.393319', '30.902382', 'https://58fang-10011010.video.myqcloud.com/58fang/1001992109424672768.mov.f30.mp4', '1001992109424672768.mov.f30.mp4', 'http://sh.58.com/ershoufang/34269238667566x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1002', '金汇一街坊 全明南北三房 三开间朝南 采光通风好 诚心出售', '3', '2', '2', '690.00', '137', '0', '1', '0', '金汇花园一街坊', '闵行', '121.377604', '31.188583', 'https://58fang-10011010.video.myqcloud.com/58fang/995500853009866755_3_22.mp4.f30.mp4', '995500853009866755_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34071112250046x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1003', '房正实用南北通透房东置换急售预购从速', '2', '1', '1', '200.00', '71', '0', '1', '0', '润渡佳苑(东区)', '嘉定', '121.232945', '31.273865', 'https://58fang-10011010.video.myqcloud.com/58fang/1005263957897793537_3_22.mp4.f30.mp4', '1005263957897793537_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34369095810218x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1005', '汤臣一品，新推高区顶楼复式，俯澜百年外滩，一线江景房值得收藏', '6', '3', '3', '19999.00', '888', '0', '1', '0', '汤臣一品', '浦东', '121.508381', '31.238608', 'https://58fang-10011010.video.myqcloud.com/58fang/995473397334953985_3_22.mp4.f30.mp4', '995473397334953985_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34070309808300x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1020', '宝欣苑双南两房167万靠地铁，房东急售首付5成，年底可过户', '2', '1', '1', '167.00', '71', '0', '1', '0', '美罗家园宝欣苑七村', '宝山', '121.346492', '31.390129', 'https://58fang-10011010.video.myqcloud.com/58fang/989708632172023810_3_22.mp4.f30.mp4', '989708632172023810_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33894384756165x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1023', '齐一学/区 赠送10平方不算产证面积 南北两房 钥匙', '2', '1', '1', '275.00', '40', '0', '1', '0', '秦家弄小区', '杨浦', '121.530701', '31.267961', 'https://58fang-10011010.video.myqcloud.com/58fang/998752882893283329_3_22.mp4.f30.mp4', '998752882893283329_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34170395665838x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1034', '带她看尽繁华，不如安稳一个家 上院南区房东急售 价钱 低 低', '2', '2', '1', '278.00', '82', '0', '1', '0', '上院(北区公寓)', '奉贤', '121.458891', '30.944694', 'https://58fang-10011010.video.myqcloud.com/58fang/993762214370373632_3_22.mp4.f30.mp4', '993762214370373632_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34018085951174x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1036', '房东出国急售，70年上海产权，可落户上学，送产权车位', '2', '2', '1', '150.00', '52', '0', '1', '0', '湄洲新村', '崇明', '121.415441', '31.626153', 'https://58fang-10011010.video.myqcloud.com/58fang/1002823967494402048_3_22.mp4.f30.mp4', '1002823967494402048_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34291819016134x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1042', '真实价 真实房 通河一村,双南两房, 房源', '2', '1', '1', '260.00', '55', '0', '1', '0', '通河一村', '宝山', '121.452419', '31.342201', 'https://58fang-10011010.video.myqcloud.com/58fang/1001013226349035522_3_22.mp4.f30.mp4', '1001013226349035522_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34239375830584x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1043', '南桥核心区域，BRT快速公交旁，户型方正，景观楼层，看过来', '1', '1', '1', '110.00', '52', '0', '1', '0', '汇港苑', '奉贤', '121.520032', '30.965363', 'https://58fang-10011010.video.myqcloud.com/58fang/1001049075275026432_3_22.mp4.f30.mp4', '1001049075275026432_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34217948958637x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1054', '新出板式南北大一房，有钥匙，婚房装修，赠家具家电，可拎包即住', '1', '1', '1', '300.00', '49', '0', '1', '0', '和欣国际花园', '宝山', '121.444171', '31.341211', 'https://58fang-10011010.video.myqcloud.com/58fang/1003467403469811712_3_22.mp4.f30.mp4', '1003467403469811712_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34314271381037x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1056', '三号线 万临家园，两房两厅精装修，带一个大院子，诚心出售', '2', '2', '1', '500.00', '98', '0', '1', '0', '万临家园', '宝山', '121.496779', '31.347576', 'https://58fang-10011010.video.myqcloud.com/58fang/1005400051935113217_3_22.mp4.f30.mp4', '1005400051935113217_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34371748092358x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1058', '特大好消息！次新小区，婚房装修 南北通两房 紧挨家乐福 急售', '2', '2', '1', '200.00', '75', '0', '1', '0', '华亭新家银杏苑', '松江', '121.199568', '31.01853', 'https://58fang-10011010.video.myqcloud.com/58fang/985318973446840322_3_22.mp4.f30.mp4', '985318973446840322_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33760423012522x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1060', '万泰纯毛坯朝南三房！看房方便有钥匙！装修自己想怎么装就怎么装', '3', '1', '1', '430.00', '85', '0', '1', '0', '万泰花园', '闵行', '121.362139', '31.148503', 'https://58fang-10011010.video.myqcloud.com/58fang/995915825770680321_3_22.mp4.f30.mp4', '995915825770680321_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34083792359243x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1061', '未来万达旁 出门幼儿园 社区医院在身边 底价抛售 随时看房', '2', '1', '1', '210.00', '77', '0', '1', '0', '颂和苑', '闵行', '121.506781', '31.039459', 'https://58fang-10011010.video.myqcloud.com/58fang/1002361806137614336_3_22.mp4.f30.mp4', '1002361806137614336_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34280529096654x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1062', '《醉新笋盘》一梯三户高得房率,两房，产权一个人、随时看房', '2', '2', '1', '240.00', '86', '0', '1', '0', '美罗家园罗翔苑', '宝山', '121.344069', '31.407166', 'https://58fang-10011010.video.myqcloud.com/58fang/1000355721444876289_3_22.mp4.f30.mp4', '1000355721444876289_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34214521308878x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1070', '虹桥宝龙城一期 急卖14楼 南北通透 可改三房 房东急卖可谈', '2', '2', '1', '290.00', '89', '0', '1', '0', '虹桥宝龙城(一期)', '青浦', '121.238968', '31.236431', 'https://58fang-10011010.video.myqcloud.com/58fang/983962592575782913_3_22.mp4.f30.mp4', '983962592575782913_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33719018912305x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1072', '万达广场旁！2.8万单价！首付3.5成！獨家委托！有钥匙！！', '2', '2', '1', '215.00', '77', '0', '1', '0', '永康城浦欣苑', '闵行', '121.505502', '31.034797', 'https://58fang-10011010.video.myqcloud.com/58fang/999470456836747264_3_22.mp4.f30.mp4', '999470456836747264_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34192294130219x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1079', '石化八村+双南房+精装修+满两年+房东置换', '2', '1', '1', '100.00', '53', '0', '1', '0', '石化八村', '金山', '121.352648', '30.718312', 'https://58fang-10011010.video.myqcloud.com/58fang/995163772995784705_3_22.mp4.f30.mp4', '995163772995784705_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34060781019434x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1081', '近万达！永康城永锦苑 首付3.5成，即可交房 房型正气景观房', '2', '1', '1', '210.00', '74', '0', '1', '0', '永康城永锦苑', '闵行', '121.508727', '31.034344', 'https://58fang-10011010.video.myqcloud.com/58fang/998741458188009472_3_22.mp4.f30.mp4', '998741458188009472_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34170046947512x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1084', '地铁口现房，绿地时代名邸，房东急售，精装修拎包入住，配套成熟', '2', '2', '1', '175.00', '82', '0', '1', '0', '绿地时代名邸(一期)', '青浦', '121.147726', '31.282728', 'https://58fang-10011010.video.myqcloud.com/58fang/973020648865558528_3_22.mp4.f30.mp4', '973020648865558528_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33376976601780x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1091', '名校驻守 绿中海雅庭89平两房 边套送大飘窗 急售330万！', '2', '2', '1', '330.00', '88', '0', '1', '0', '绿中海雅庭(公寓)', '青浦', '121.207205', '31.1603', 'https://58fang-10011010.video.myqcloud.com/58fang/1001674281375002624_3_22.mp4.f30.mp4', '1001674281375002624_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34259545390513x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1095', '蓝色收获东区板桥东路888弄5楼精装修小两房税少采光好通风好', '2', '1', '1', '163.00', '67', '0', '1', '0', '蓝色收获(东区)', '金山', '121.364867', '30.747063', 'https://58fang-10011010.video.myqcloud.com/58fang/986451154898542592_3_22.mp4.f30.mp4', '986451154898542592_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33794699280331x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1096', '美安苑本地动迁大两房南北通透278万，首付3.5成可贷款过户', '2', '2', '1', '278.00', '93', '0', '1', '0', '美罗家园美安苑', '宝山', '121.35256', '31.394245', 'https://58fang-10011010.video.myqcloud.com/58fang/989709578998411264_3_22.mp4.f30.mp4', '989709578998411264_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33894360719019x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1106', '丽水湾 4楼送阁楼 一分价钱一分货 位置好 装修好 送家电家', '2', '2', '1', '175.00', '86', '0', '1', '0', '丽水湾', '奉贤', '121.393319', '30.902382', 'https://58fang-10011010.video.myqcloud.com/58fang/999579016639827968_3_22.mp4.f30.mp4', '999579016639827968_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34195591797956x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1109', '家是温暖的港湾 家在这里欢迎看房买房', '2', '1', '1', '230.00', '49', '0', '1', '0', '长海一村', '杨浦', '121.53718', '31.316777', 'https://58fang-10011010.video.myqcloud.com/58fang/959370873708498944_3_22.mp4.f30.mp4', '959370873708498944_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/32968549250502x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1112', '地铁4号线塘桥商圈浦东南路小学旁，精装一房出售！', '1', '0', '1', '232.00', '33', '0', '1', '0', '西邱小区', '浦东', '121.520455', '31.212331', 'https://58fang-10011010.video.myqcloud.com/58fang/980374926089289729.mp4.f30.mp4', '980374926089289729.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33609372433587x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1118', '急抛，房东诚心卖，标准好房，两房朝南，环境优美，小桥流水。', '2', '1', '1', '150.00', '95', '0', '1', '0', '北唐新苑东区', '奉贤', '121.583762', '30.935523', 'https://58fang-10011010.video.myqcloud.com/58fang/992286873118330880_3_22.mp4.f30.mp4', '992286873118330880_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33972964651444x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1119', '星尚湾2+1边套户型300万(另有车位)', '2', '2', '1', '300.00', '89', '0', '1', '0', '恒文星尚湾', '青浦', '121.236343', '31.229019', 'https://58fang-10011010.video.myqcloud.com/58fang/992605576351481856.mov.f30.mp4', '992605576351481856.mov.f30.mp4', 'http://sh.58.com/ershoufang/33982631029426x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1124', '万科云间传奇墅地限供 一栋难求 精装带地暖，房型正气对口东华', '4', '2', '2', '550.00', '143', '0', '1', '0', '万科云间传奇(别墅)', '松江', '121.187649', '31.045717', 'https://58fang-10011010.video.myqcloud.com/58fang/988417721567834112_3_22.mp4.f30.mp4', '988417721567834112_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33854989681843x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1127', '海滨新二村大三房 送大车库 豪华装修 98平', '3', '1', '1', '158.00', '98', '0', '1', '0', '海滨新二村', '奉贤', '121.575063', '30.869825', 'https://58fang-10011010.video.myqcloud.com/58fang/978500699186810880_3_22.mp4.f30.mp4', '978500699186810880_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33552329229359x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1128', '青浦区、绿地时代名邸、开发商样板房装修、一手房无税', '2', '2', '1', '190.00', '84', '0', '1', '0', '绿地时代名邸(一期)', '青浦', '121.147726', '31.282728', 'https://58fang-10011010.video.myqcloud.com/58fang/978098362161070080_3_22.mp4.f30.mp4', '978098362161070080_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33540034276551x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1139', '金桥酒店公寓一室 395万有钥匙随时看房', '1', '1', '1', '395.00', '47', '0', '1', '0', '金桥酒店公寓', '浦东', '121.594494', '31.250181', 'https://58fang-10011010.video.myqcloud.com/58fang/979596596167602179_3_22.mp4.f30.mp4', '979596596167602179_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33584961459261x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1141', '朝南两房，全明南北通，地铁很近，首付40到50万就可以搞定', '2', '1', '1', '158.00', '55', '0', '1', '0', '鸿宝一村(南区)', '奉贤', '121.435122', '30.997602', 'https://58fang-10011010.video.myqcloud.com/58fang/1006134264829341698_3_22.mp4.f30.mp4', '1006134264829341698_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34395655260594x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1144', ',星纳家苑,次新房+小户型+南北通透+学qu房+高空无遮挡电', '2', '2', '1', '340.00', '80', '0', '1', '0', '星纳家园', '浦东', '121.67763', '31.298834', 'https://58fang-10011010.video.myqcloud.com/58fang/1003120545304182785_3_22.mp4.f30.mp4', '1003120545304182785_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34303686131765x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1159', '竹园新村小户型，对口竹园小学，满五税少总价低，看房有钥匙', '1', '0', '1', '220.00', '30', '0', '1', '0', '竹园新村', '浦东', '121.537542', '31.235247', 'https://58fang-10011010.video.myqcloud.com/58fang/1002170721884991488_3_22.mp4.f30.mp4', '1002170721884991488_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34274695046848x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1164', '雅居乐联排西边套、半环绕花园、上下五层、G15虹桥一站式交通', '4', '3', '3', '570.00', '200', '0', '1', '0', '雅居乐星徽(别墅)', '松江', '121.318314', '31.012122', 'https://58fang-10011010.video.myqcloud.com/58fang/1004569878662770689_3_22.mp4.f30.mp4', '1004569878662770689_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34347496793420x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1166', '丰庄低于市场价30万精装一房 急售 钥匙在手 随时看房', '1', '2', '1', '210.00', '48', '0', '1', '0', '丰庄十二街坊', '嘉定', '121.366473', '31.253291', 'https://58fang-10011010.video.myqcloud.com/58fang/998044645755736064.mov.f30.mp4', '998044645755736064.mov.f30.mp4', 'http://sh.58.com/ershoufang/34148767582122x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1173', '在售新房，亲水湾一手房一手房，精装修交付，带清风系统，有车位', '2', '2', '1', '460.00', '73', '0', '1', '0', '绿洲康城亲水湾(东区)', '浦东', '121.590406', '31.157933', 'https://58fang-10011010.video.myqcloud.com/58fang/981727103525343232_3_22.mp4.f30.mp4', '981727103525343232_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33650796116911x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1184', '超具性价比三房 华新公园旁 小区环境好 得房率高 一周必卖房', '3', '1', '1', '215.00', '83', '0', '1', '0', '华富公寓', '青浦', '121.239176', '31.251108', 'https://58fang-10011010.video.myqcloud.com/58fang/996942215865466883_3_22.mp4.f30.mp4', '996942215865466883_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34115113405005x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1185', '万科新作海上传奇 精装三居  可落户 出行自在配套齐全', '3', '2', '2', '135.00', '50', '0', '1', '0', '摩登蜂巢', '青浦', '121.203199', '31.200903', 'https://58fang-10011010.video.myqcloud.com/58fang/993327412173373441.mp4.f30.mp4', '993327412173373441.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34004635128784x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1187', '青浦区 绿地时代名邸 房东包税 一楼带地下室 南北通透', '2', '2', '1', '200.00', '86', '0', '1', '0', '绿地时代名邸(一期)', '青浦', '121.147726', '31.282728', 'https://58fang-10011010.video.myqcloud.com/58fang/981145850401017857_3_22.mp4.f30.mp4', '981145850401017857_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33633056031023x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1198', '蓝堡公馆+一梯一户电梯房+海景房+两房朝南+精装修', '3', '2', '1', '250.00', '92', '0', '1', '0', '蓝堡公馆', '金山', '121.362077', '30.737229', 'https://58fang-10011010.video.myqcloud.com/58fang/1003127711893323776_3_22.mp4.f30.mp4', '1003127711893323776_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34303782601924x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1202', '紫苑小区小平方毛胚房', '1', '1', '1', '78.00', '48', '0', '1', '0', '紫苑小区', '奉贤', '121.623579', '30.908831', 'https://58fang-10011010.video.myqcloud.com/58fang/995125845649551360.mov.f30.mp4', '995125845649551360.mov.f30.mp4', 'http://sh.58.com/ershoufang/34059704869165x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1213', '带她看尽繁华，不如安稳一个家 金水苑，诚心出售，真.实房源', '3', '2', '2', '295.00', '119', '0', '1', '0', '金水苑', '奉贤', '121.504997', '30.960305', 'https://58fang-10011010.video.myqcloud.com/58fang/994753489630416897_3_22.mp4.f30.mp4', '994753489630416897_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34048341618107x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1214', '廉价抛售 安贝尔准新房 精装全配 带车位 看房方便 仅此一套', '3', '2', '2', '230.00', '89', '0', '1', '0', '安贝尔花园(公寓)', '松江', '121.314851', '31.009962', 'https://58fang-10011010.video.myqcloud.com/58fang/1005305689016389632_3_22.mp4.f30.mp4', '1005305689016389632_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34370329799242x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1216', '真如地铁口300米 三轨交汇 精装修三房 房东急售 配套成熟', '3', '2', '2', '580.00', '105', '0', '1', '0', '高尚领域', '普陀', '121.412981', '31.260761', 'https://58fang-10011010.video.myqcloud.com/58fang/1004534848066445312.mp4.f30.mp4', '1004534848066445312.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34346845696058x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1218', '彭浦新村 兴泉小区 对口三泉路小學 南北全明户型 采光无遮挡', '2', '1', '1', '266.00', '64', '0', '1', '0', '兴泉小区', '闸北', '121.445908', '31.319839', 'https://58fang-10011010.video.myqcloud.com/58fang/1004357279308341248.mp4.f30.mp4', '1004357279308341248.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34269535047852x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1219', '影视乐园对面 雅居乐星徽 高品质联排别墅 诚意出售 价格面议', '4', '2', '3', '520.00', '200', '0', '1', '0', '雅居乐星徽(别墅)', '松江', '121.318314', '31.012122', 'https://58fang-10011010.video.myqcloud.com/58fang/1005305912170147840_3_22.mp4.f30.mp4', '1005305912170147840_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34370288116913x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1226', '急售，棕榈湾花园精装金山实验中学，乐购边，诚意出售！', '3', '2', '2', '275.00', '99', '0', '1', '0', '棕榈湾花园', '金山', '121.350805', '30.737253', 'https://58fang-10011010.video.myqcloud.com/58fang/1000953566837362688_3_22.mp4.f30.mp4', '1000953566837362688_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34237547323585x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1238', '美岸栖庭 板式婚房装修大两房 南北通透 次新小区得房率高房型', '2', '2', '1', '497.00', '91', '0', '1', '0', '美岸栖庭二期', '宝山', '121.495284', '31.331336', 'https://58fang-10011010.video.myqcloud.com/58fang/1000202013604077568_3_22.mp4.f30.mp4', '1000202013604077568_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34214618270910x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1244', '绿地小米公社 上叠别墅 送阁楼 送露台 房东诚心出售到价就签', '3', '2', '2', '228.00', '115', '0', '1', '0', '绿地小米公社', '奉贤', '121.670949', '30.917581', 'https://58fang-10011010.video.myqcloud.com/58fang/1003911590958886913_3_22.mp4.f30.mp4', '1003911590958886913_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34327820890948x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1256', '华发小区+诚意出售+钥匙房+精装南北2房+非顶楼非底楼+随看', '2', '1', '1', '300.00', '64', '0', '1', '0', '华发小区', '徐汇', '121.459805', '31.134695', 'https://58fang-10011010.video.myqcloud.com/58fang/1003907092802727936.mp4.f30.mp4', '1003907092802727936.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34326543090880x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1259', '价格可谈，不看购房资格，不限贷，复式公寓，近11号线白银路站', '1', '1', '1', '99.00', '43', '0', '1', '0', '新城金郡SOHO', '嘉定', '121.246655', '31.349492', 'https://58fang-10011010.video.myqcloud.com/58fang/996983300104941568_3_22.mp4.f30.mp4', '996983300104941568_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34116364929216x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1262', '急售梅园五街坊公司产权无税！对口冰厂田，福外，建平只卖两星期', '2', '1', '1', '510.00', '48', '0', '1', '0', '梅园五街坊', '浦东', '121.535752', '31.237927', 'https://58fang-10011010.video.myqcloud.com/58fang/1003619736958820352_3_22.mp4.f30.mp4', '1003619736958820352_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34318882833991x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1266', '金天地 两室两厅 两个房间朝南 精装修 业主搬家到市区，诚售', '2', '2', '1', '280.00', '102', '0', '1', '0', '金天地花园', '金山', '121.3556', '30.738212', 'https://58fang-10011010.video.myqcloud.com/58fang/999849557196038144_3_22.mp4.f30.mp4', '999849557196038144_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34203858298689x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1271', '疯了、疯了、低于市场价满五唯一的西郊河畔大两房，诚心出售', '2', '2', '1', '358.00', '90', '0', '1', '0', '西郊河畔家园', '闵行', '121.298253', '31.218186', 'https://58fang-10011010.video.myqcloud.com/58fang/995192118827843585_3_22.mp4.f30.mp4', '995192118827843585_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34061150812591x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1274', '新推精装房源,南华小区,楼层好采光无敌,满五省税', '2', '1', '1', '197.00', '51', '0', '1', '0', '南华小区', '嘉定', '121.314486', '31.294111', 'https://58fang-10011010.video.myqcloud.com/58fang/1004163205611671552_3_22.mp4.f30.mp4', '1004163205611671552_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34335505654457x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1290', '上海中环旁，加推清水湾一手房，没有税费63平到144平都有。', '2', '2', '1', '470.00', '76', '0', '1', '0', '绿洲康城亲水湾(东区)', '浦东', '121.590406', '31.157933', 'https://58fang-10011010.video.myqcloud.com/58fang/981720812702687232_3_22.mp4.f30.mp4', '981720812702687232_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33650562197816x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1292', '朝南一门关+楼层佳+杨浦公园', '1', '1', '1', '220.00', '33', '0', '1', '0', '控江路764弄小区', '杨浦', '121.544239', '31.290075', 'https://58fang-10011010.video.myqcloud.com/58fang/996621535928156160_3_22.mp4.f30.mp4', '996621535928156160_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34105322562619x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1306', '6月新上，小周好房美邻苑在售性价比高的两房，精装带阁楼', '2', '1', '1', '302.00', '67', '0', '1', '0', '美邻苑', '闵行', '121.289513', '31.207583', 'https://58fang-10011010.video.myqcloud.com/58fang/1003929706778619906_3_22.mp4.f30.mp4', '1003929706778619906_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34328307877047x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1307', '首付25 松江区交通便利商业齐全 南北通透 拎包入住送家具', '2', '1', '1', '92.00', '38', '0', '1', '0', '谷北小区', '松江', '121.243438', '31.018505', 'https://58fang-10011010.video.myqcloud.com/58fang/1005266427516583936_3_22.mp4.f30.mp4', '1005266427516583936_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34369131684420x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1315', '80万可议复式精装修公寓诚售 2房1厅2卫 精巧玲珑满足需求', '2', '1', '2', '85.00', '30', '0', '1', '0', '瑞立万立城(商住楼)', '嘉定', '121.184437', '31.289746', 'https://58fang-10011010.video.myqcloud.com/58fang/972679073706835968_3_22.mp4.f30.mp4', '972679073706835968_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33374679819598x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1317', '松江9号线大学城站万达广场旁挑高4.5米租金4000', '2', '2', '1', '120.00', '50', '0', '1', '0', '三迪曼哈顿', '松江', '121.25346', '31.063158', 'https://58fang-10011010.video.myqcloud.com/58fang/1005272983658319873_3_22.mp4.f30.mp4', '1005272983658319873_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34369243559469x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1319', '11号线地铁，周边配套齐全，送家具家电，可落户，租金高', '1', '1', '1', '95.00', '45', '0', '1', '0', '水仙小区', '嘉定', '121.163279', '31.301181', 'https://58fang-10011010.video.myqcloud.com/58fang/1005272158156390400_3_22.mp4.f30.mp4', '1005272158156390400_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34369336674109x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1333', '周浦万达旁，3条地铁环绕，一手房，配套成熟，看房方便', '2', '2', '1', '452.00', '102', '0', '1', '0', '尚景丽园', '浦东', '121.580556', '31.127118', 'https://58fang-10011010.video.myqcloud.com/58fang/1005981332410494978_3_22.mp4.f30.mp4', '1005981332410494978_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34390984235600x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1334', '瑞和城地铁500米+BRT+景观楼房+两大商场+房源真实', '1', '1', '1', '150.00', '52', '0', '1', '0', '浦江瑞和城壹街区', '闵行', '121.523058', '31.030173', 'https://58fang-10011010.video.myqcloud.com/58fang/1002093043676905473_3_22.mp4.f30.mp4', '1002093043676905473_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34272319723837x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1339', '绿地芳满庭 精装四房 两厅两卫 满五 房东急售 看房方便', '4', '2', '2', '250.00', '114', '0', '1', '0', '绿地金山名邸(公寓)', '金山', '121.323509', '30.756536', 'https://58fang-10011010.video.myqcloud.com/58fang/1006006112673099776_3_22.mp4.f30.mp4', '1006006112673099776_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34391740597321x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1341', '急急古华新村 直降30万急售，全明户型，近地铁，一梯两户，', '2', '1', '1', '160.00', '77', '0', '1', '0', '古华一区', '奉贤', '121.469479', '30.920867', 'https://58fang-10011010.video.myqcloud.com/58fang/1005405655760130049_3_22.mp4.f30.mp4', '1005405655760130049_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34373346182702x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1359', '因房东家特殊情况，直接从260万市场价，转到220万', '1', '1', '1', '220.00', '45', '0', '1', '0', '龙柏六村', '闵行', '121.372681', '31.179573', 'https://58fang-10011010.video.myqcloud.com/58fang/1004250101952053248_3_22.mp4.f30.mp4', '1004250101952053248_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34338155647033x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1363', '佰分佰眞寔房源 全明户型 随时看有钥匙 不辜负每一份信任', '1', '1', '1', '219.00', '45', '0', '1', '0', '龙柏四村', '闵行', '121.367365', '31.182959', 'https://58fang-10011010.video.myqcloud.com/58fang/1003467608923602944_3_22.mp4.f30.mp4', '1003467608923602944_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34314275332664x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1366', '昌鑫花园 全新装修+满五年+拎包入住+三新学校+随时看房！！', '2', '2', '1', '255.00', '89', '0', '1', '0', '昌鑫花园(公寓)', '松江', '121.209319', '31.031872', 'https://58fang-10011010.video.myqcloud.com/58fang/1000539972748472322_3_22.mp4.f30.mp4', '1000539972748472322_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34224931202246x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1372', '新出房源，华浜二村一楼南北通风，精装修双天井天井已搭房型正气', '2', '1', '1', '273.00', '67', '0', '1', '0', '华浜二村', '宝山', '121.505515', '31.351965', 'https://58fang-10011010.video.myqcloud.com/58fang/1005398547970945024_3_22.mp4.f30.mp4', '1005398547970945024_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34372294810427x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1374', '新出房源！小高层毛坯房出售！南北透通 满二年！', '2', '2', '1', '250.00', '81', '0', '1', '0', '虹桥宝龙城(二期公寓)', '青浦', '121.242043', '31.237604', 'https://58fang-10011010.video.myqcloud.com/58fang/1000946065928638464_3_22.mp4.f30.mp4', '1000946065928638464_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34237324279605x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1375', '精装一室厅厨卫 边套无税 高区视野好 低于行情 随时看房', '1', '1', '1', '142.00', '38', '0', '1', '0', '禹州蓝爵', '浦东', '121.616925', '31.262811', 'https://58fang-10011010.video.myqcloud.com/58fang/1002131299453915136_3_22.mp4.f30.mp4', '1002131299453915136_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34273494891328x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1379', '颛溪五村 全明户型 南北通透 精装修 拎包入住 急售 急售', '2', '1', '1', '240.00', '68', '0', '1', '0', '颛溪五村', '闵行', '121.403072', '31.072131', 'https://58fang-10011010.video.myqcloud.com/58fang/986443463274819585_3_22.mp4.f30.mp4', '986443463274819585_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33794739845456x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1382', '龙柏二村 南北两房 价格急降30万 还能谈 非常诚意出售', '2', '1', '1', '295.00', '67', '0', '1', '0', '龙柏二村', '闵行', '121.36934', '31.187472', 'https://58fang-10011010.video.myqcloud.com/58fang/999254779752374275_3_22.mp4.f30.mp4', '999254779752374275_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34185704426574x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1383', '香逸湾精装三房 业主买好房子了急售 中间楼层 看房方便', '3', '2', '1', '368.00', '89', '0', '1', '0', '香逸湾(南区)', '宝山', '121.451452', '31.367909', 'https://58fang-10011010.video.myqcloud.com/58fang/998157363745681408_3_22.mp4.f30.mp4', '998157363745681408_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34128160852142x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1384', '友谊家园两房 婚房精装 诚心急售 钥匙随时看房', '2', '2', '1', '282.00', '88', '0', '1', '0', '友谊家园(东区)', '宝山', '121.462947', '31.402918', 'https://58fang-10011010.video.myqcloud.com/58fang/998158578575507457_3_22.mp4.f30.mp4', '998158578575507457_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34128160740906x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1390', '彭浦新村场中路2965弄金泉苑双南双天井一梯两户全明！', '2', '1', '1', '385.00', '77', '0', '1', '0', '金泉苑', '闸北', '121.44393', '31.312089', 'https://58fang-10011010.video.myqcloud.com/58fang/983252603246764032.mov.f30.mp4', '983252603246764032.mov.f30.mp4', 'http://sh.58.com/ershoufang/33697335481646x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1394', '房东资金周转急抛 买房福利，，东边套全明，实拍视频！', '1', '1', '1', '217.00', '47', '0', '1', '0', '龙柏六村', '闵行', '121.372681', '31.179573', 'https://58fang-10011010.video.myqcloud.com/58fang/1004255905463689217_3_22.mp4.f30.mp4', '1004255905463689217_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34338333360076x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1405', '瑞和城+周边配套生活广场+地铁500米+实房实价！', '1', '1', '1', '190.00', '59', '0', '1', '0', '浦江瑞和城壹街区', '闵行', '121.523831', '31.030371', 'https://58fang-10011010.video.myqcloud.com/58fang/1003434705351106560_3_22.mp4.f30.mp4', '1003434705351106560_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34313268620090x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1415', '笋盘上市近地铁，行知学校，满五 顶楼复式', '2', '2', '1', '340.00', '86', '0', '1', '0', '葑润华庭', '宝山', '121.387767', '31.328444', 'https://58fang-10011010.video.myqcloud.com/58fang/999825857419706371_3_22.mp4.f30.mp4', '999825857419706371_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34195791090751x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1420', '曹路地铁站金钻苑 底价急售 精装南北通透 房源真实', '2', '2', '2', '340.00', '97', '0', '1', '0', '金钻苑(北区)', '浦东', '121.687192', '31.285693', 'https://58fang-10011010.video.myqcloud.com/58fang/999846231599501313_3_22.mp4.f30.mp4', '999846231599501313_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34203742016050x.shtml');
INSERT INTO `yf_hf_video_58` VALUES ('1423', '上门实勘带花园+车库+80万装修+满五少税（房东急售）', '4', '3', '3', '705.00', '151', '0', '1', '0', '锦秋花园(别墅)', '宝山', '121.397253', '31.328551', 'https://58fang-10011010.video.myqcloud.com/58fang/999861824964808705_3_22.mp4.f30.mp4', '999861824964808705_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34204217721391x.shtml');

-- ----------------------------
-- Table structure for yf_hf_video_58_copy1
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_video_58_copy1`;
CREATE TABLE `yf_hf_video_58_copy1` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(50) DEFAULT '' COMMENT '标题',
  `num_room` int(10) DEFAULT '1' COMMENT '几室',
  `num_hall` int(10) DEFAULT '1' COMMENT '几厅',
  `num_toilet` tinyint(4) DEFAULT '0' COMMENT '几卫',
  `price` double(10,2) DEFAULT '0.00' COMMENT '房价',
  `area` int(11) NOT NULL DEFAULT '0' COMMENT '面积',
  `building_id` int(11) DEFAULT NULL COMMENT '小区id',
  `area_id` int(4) DEFAULT '0' COMMENT '地区id',
  `building` varchar(100) DEFAULT '' COMMENT '小区',
  `address` varchar(100) DEFAULT '' COMMENT '地址',
  `longitude` double DEFAULT NULL COMMENT '经度',
  `latitude` double DEFAULT NULL COMMENT '纬度',
  `videolink` varchar(100) DEFAULT '' COMMENT '视频链接',
  `videoname` varchar(100) DEFAULT '' COMMENT '视频name',
  `url` varchar(100) DEFAULT '' COMMENT 'url',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3294 DEFAULT CHARSET=utf8 COMMENT='视频表';

-- ----------------------------
-- Records of yf_hf_video_58_copy1
-- ----------------------------
INSERT INTO `yf_hf_video_58_copy1` VALUES ('900', '业主委托于我出售钥匙在我手上學区未用房屋在小区中心位置', '2', '2', '1', '450.00', '93', '0', '0', '金桥新村四街坊长岛小区', '浦东', '121.600523', '31.268066', 'https://58fang-10011010.video.myqcloud.com/58fang/1005990185713827840_3_22.mp4.f30.mp4', '1005990185713827840_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34391260593067x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('901', '碧桂园打造临港蓝湾凤凰城天境政府大力扶持之地 精装交付', '3', '2', '2', '216.00', '94', '0', '0', '碧桂园浦东星作(公寓)', '南汇', '121.811749', '30.913132', 'https://58fang-10011010.video.myqcloud.com/58fang/1006756739468525569_3_22.mp4.f30.mp4', '1006756739468525569_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413891612998x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('902', '嘉善开发区，产权房，30万起,通燃气,民用水电', '2', '2', '1', '33.88', '40', '0', '0', '嘉汇城市广场', '上海周边', '120.963072', '30.84126', 'https://58fang-10011010.video.myqcloud.com/58fang/1006791567983276032_3_22.mp4.f30.mp4', '1006791567983276032_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34414129722443x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('903', '急售上海70年产权单价1.4万可贷款可落户大三房', '3', '1', '1', '125.00', '90', '0', '0', '紫苑小区', '奉贤', '121.623579', '30.908831', 'https://58fang-10011010.video.myqcloud.com/58fang/1006776261411893251_3_22.mp4.f30.mp4', '1006776261411893251_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34415244484812x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('904', '保留房源首付9万送车位送储藏室先到先得', '2', '2', '1', '35.00', '32', '0', '0', '风伟三村', '崇明', '121.50204', '31.70834', 'https://58fang-10011010.video.myqcloud.com/58fang/991483775202381827_3_22.mp4.f30.mp4', '991483775202381827_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34412531963852x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('905', '70年产权住宅，无需社保可落户，近地铁口，送20万精装送车位', '2', '2', '1', '56.00', '62', '0', '0', '光明馨座', '上海周边', '121.119731', '31.300528', 'https://58fang-10011010.video.myqcloud.com/58fang/1006725320360886272_3_22.mp4.f30.mp4', '1006725320360886272_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413692636223x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('906', '真实.房源实拍，别让虚假房源欺骗了你的感情。', '3', '2', '2', '200.00', '120', '0', '0', '外冈景苑', '嘉定', '121.164623', '31.374811', 'https://58fang-10011010.video.myqcloud.com/58fang/1006717136564940801_3_22.mp4.f30.mp4', '1006717136564940801_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413161885902x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('907', '不搞虚假首付90万随时可以看房', '2', '2', '1', '145.00', '83', '0', '0', '外冈景苑', '嘉定', '121.164623', '31.374811', 'https://58fang-10011010.video.myqcloud.com/58fang/1006717722714730497_3_22.mp4.f30.mp4', '1006717722714730497_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413124398134x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('908', '南郊庄园开发商保留房源临河景观位置可落户上学可公积金', '5', '3', '3', '270.00', '236', '0', '0', '南郊庄园', '上海周边', '121.153077', '32.241323', 'https://58fang-10011010.video.myqcloud.com/58fang/1006730003120943106_3_22.mp4.f30.mp4', '1006730003120943106_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413835782216x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('909', '大虹桥国家会展联排别墅赠私家电梯双车位全明地下室', '5', '3', '4', '1050.00', '253', '0', '0', '新虹桥君悦湾墅', '青浦', '121.282972', '31.167734', 'https://58fang-10011010.video.myqcloud.com/58fang/1006737812143230976_3_22.mp4.f30.mp4', '1006737812143230976_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34414039540285x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('910', '89平地铁口房 精装两房 送家具家电 带中央空调', '2', '2', '1', '220.00', '89', '0', '0', '光明馨座', '上海周边', '121.119731', '31.300528', 'https://58fang-10011010.video.myqcloud.com/58fang/1006440340946702336.mp4.f30.mp4', '1006440340946702336.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34404980175151x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('911', '嘉善高品质楼盘地.铁9号线无缝对接上海邻景区首付三成', '2', '2', '1', '98.00', '67', '0', '0', '光耀城', '上海周边', '120.917339', '30.864417', 'https://58fang-10011010.video.myqcloud.com/58fang/1000247238850543616_3_22.mp4.f30.mp4', '1000247238850543616_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34418413018803x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('912', '金地都会意境，地.铁高铁旁，重点学校，70年产权住宅', '3', '2', '2', '118.00', '89', '0', '0', '金地都会艺境', '上海周边', '120.814447', '30.676806', 'https://58fang-10011010.video.myqcloud.com/58fang/997658520432173058_3_22.mp4.f30.mp4', '997658520432173058_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34418412757702x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('913', '全新装修一年次新房品 牌开发商 户型正气家具家电可全送', '2', '2', '1', '200.00', '75', '0', '0', '中海悦府(公寓)', '松江', '121.303479', '31.09362', 'https://58fang-10011010.video.myqcloud.com/58fang/1006718808280293376_3_22.mp4.f30.mp4', '1006718808280293376_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413483023294x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('914', '双地铁交汇丨市中心核心地段丨重点學区丨可落户上学丨精装南北通', '3', '2', '1', '105.00', '72', '0', '0', '管弄小区', '崇明', '121.405765', '31.630549', 'https://58fang-10011010.video.myqcloud.com/58fang/1005275699612774401_3_22.mp4.f30.mp4', '1005275699612774401_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34368863868362x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('915', '近地铁，对口名校，现价100万急售软硬装修全送，拎包入住', '2', '2', '1', '110.00', '75', '0', '0', '翠谷小区', '松江', '121.185867', '31.105785', 'https://58fang-10011010.video.myqcloud.com/58fang/1005336795858100224_3_22.mp4.f30.mp4', '1005336795858100224_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34370127069383x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('917', '业主新挂牌 产权清晰 户口已迁 名额不占   置换诚售', '2', '1', '1', '520.00', '51', '0', '0', '梅园三街坊', '浦东', '121.531872', '31.24025', 'https://58fang-10011010.video.myqcloud.com/58fang/1006362805533696001_3_22.mp4.f30.mp4', '1006362805533696001_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34402632044076x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('918', '9号线地铁口 万科精装电梯房 上下两层 办公居住均可 ', '1', '2', '2', '208.00', '48', '0', '0', '万科七宝国际', '闵行', '121.342764', '31.157413', 'https://58fang-10011010.video.myqcloud.com/58fang/1006135313321451521_3_22.mp4.f30.mp4', '1006135313321451521_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34395568297160x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('919', '新 崇明主城区小面积低总价优.质房源比的就是速度', '2', '2', '1', '50.00', '56', '0', '0', '光华新村', '崇明', '121.548106', '31.685007', 'https://58fang-10011010.video.myqcloud.com/58fang/1006494393076572160_3_22.mp4.f30.mp4', '1006494393076572160_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34406647290057x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('920', '急业主上门降价，无需社保，11号线地铁口，低于市场价30万', '2', '2', '1', '56.00', '52', '0', '0', '花溪畔居', '上海周边', '121.102951', '31.304037', 'https://58fang-10011010.video.myqcloud.com/58fang/1006733991904043009_3_22.mp4.f30.mp4', '1006733991904043009_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413957697579x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('921', '首付只需80万轻松买中套，随时可入住。', '2', '2', '1', '140.00', '81', '0', '0', '外冈景苑', '嘉定', '121.164623', '31.374811', 'https://58fang-10011010.video.myqcloud.com/58fang/1006715715530551297_3_22.mp4.f30.mp4', '1006715715530551297_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413398703415x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('922', '花桥11号地铁口500米，悦城精装修现房 照片实地拍摄', '2', '2', '1', '90.00', '73', '0', '0', 'GOHO悦城', '上海周边', '121.129559', '31.3003', 'https://58fang-10011010.video.myqcloud.com/58fang/1006346541029416961_3_22.mp4.f30.mp4', '1006346541029416961_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34402059663690x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('923', '地铁11号线 嘉定北站 业主急售 精装两房 赠 送15平房', '2', '2', '1', '100.00', '53', '0', '0', '嘉定蔷薇苑', '嘉定', '121.228528', '31.395466', 'https://58fang-10011010.video.myqcloud.com/58fang/1006708817985032194.mov.f30.mp4', '1006708817985032194.mov.f30.mp4', 'http://sh.58.com/ershoufang/34413168663337x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('924', '19号线口崇明岛叠加别墅赠送100平米融创打造海上桃园', '3', '2', '2', '231.00', '150', '0', '0', '融创海上桃源', '上海周边', '121.465777', '31.789132', 'https://58fang-10011010.video.myqcloud.com/58fang/997652730845622274_3_22.mp4.f30.mp4', '997652730845622274_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34418414070201x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('925', '急卖恒信家园标准两房一厅一房朝南一房朝北精装全送加阁楼', '2', '1', '1', '155.00', '97', '0', '0', '恒信家园', '金山', '121.34798', '30.861244', 'https://58fang-10011010.video.myqcloud.com/58fang/1006703699885576192_3_22.mp4.f30.mp4', '1006703699885576192_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413032802732x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('926', '16号线新厂地铁站1公里精装修复式现房公寓 不限贷', '2', '2', '1', '150.00', '45', '0', '0', '中洲里程', '南汇', '121.643126', '31.038009', 'https://58fang-10011010.video.myqcloud.com/58fang/1006358402919591937.mov.f30.mp4', '1006358402919591937.mov.f30.mp4', 'http://sh.58.com/ershoufang/34402364648876x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('927', '11号线花桥站500米，急降20万送精装，配套成熟，对口名校', '2', '2', '1', '56.00', '62', '0', '0', '花桥阳光苑', '上海周边', '121.102327', '31.31044', 'https://58fang-10011010.video.myqcloud.com/58fang/1006716296550711299_3_22.mp4.f30.mp4', '1006716296550711299_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413389697600x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('928', '石化一村南北房精装修房东把房型改得很好拎包入住低总价', '2', '2', '1', '125.00', '89', '0', '0', '石化一村', '金山', '121.345051', '30.717767', 'https://58fang-10011010.video.myqcloud.com/58fang/1006711405207912449_3_22.mp4.f30.mp4', '1006711405207912449_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413188149568x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('929', '总价75万起 外地人可落户不限贷 全国公积金可用', '3', '2', '2', '75.00', '100', '0', '0', '金平小区', '上海周边', '121.013082', '30.703269', 'https://58fang-10011010.video.myqcloud.com/58fang/991653983309295616_3_22.mp4.f30.mp4', '991653983309295616_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413894187580x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('930', '宝龙广场地铁口  房东自住精装修  周边配套齐全', '3', '1', '1', '275.00', '96', '0', '0', '崧泽华城佳福雅苑', '青浦', '121.163655', '31.160739', 'https://58fang-10011010.video.myqcloud.com/58fang/1006707013897441280_3_22.mp4.f30.mp4', '1006707013897441280_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413132192835x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('931', '嘉兴市中心民用水电公寓精装交付可包租 以租养贷不成问题', '1', '1', '1', '52.00', '51', '0', '0', '立达汇园公寓', '上海周边', '120.728672', '30.769415', 'https://58fang-10011010.video.myqcloud.com/58fang/1006756502142218240_3_22.mp4.f30.mp4', '1006756502142218240_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34413894035789x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('942', '真实！房源 金地未未来 对口六师附小名额未用交通便利配套齐全', '2', '2', '1', '470.00', '65', '0', '0', '金地未未来', '浦东', '121.594133', '31.31268', 'https://58fang-10011010.video.myqcloud.com/58fang/969534605088542721_3_22.mp4.f30.mp4', '969534605088542721_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33276202788148x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('943', '房东急售：低于市场价 50万送15万车位送20万装修户型正气', '2', '2', '1', '263.00', '75', '0', '0', '绿地新翔家园', '嘉定', '121.321047', '31.303565', 'https://58fang-10011010.video.myqcloud.com/58fang/1001274962440380419_3_22.mp4.f30.mp4', '1001274962440380419_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34247358316733x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('944', '无需社保上海产权93平米、单价7500元、总价68万二房二厅', '2', '2', '1', '68.00', '93', '0', '0', '金山银海', '金山', '121.341343', '30.744486', 'https://58fang-10011010.video.myqcloud.com/58fang/991148054843248640_3_22.mp4.f30.mp4', '991148054843248640_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33938308035252x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('945', '嘉兴碧桂园，首付仅需6万，送车位，对口滨海小学，山水六旗旁', '3', '2', '1', '70.00', '96', '0', '0', '碧桂园海湾一号', '上海周边', '121.006138', '30.595579', 'https://58fang-10011010.video.myqcloud.com/58fang/994758371955470336_3_22.mp4.f30.mp4', '994758371955470336_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34412531785670x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('946', '首付45万 塞纳蓝湾 品质小区 开发商一手保留 嘉善高铁旁', '3', '2', '2', '156.00', '95', '0', '0', '塞纳蓝湾', '上海周边', '120.905387', '30.823632', 'https://58fang-10011010.video.myqcloud.com/58fang/1006743431629791233_3_22.mp4.f30.mp4', '1006743431629791233_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34414246088746x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('947', '平湖开发区，首付19万 无溢价可落户 送车位高地铁旁', '4', '2', '2', '155.00', '129', '0', '0', '紫金艺境', '上海周边', '120.791935', '30.734955', 'https://58fang-10011010.video.myqcloud.com/58fang/1006743267896741890_3_22.mp4.f30.mp4', '1006743267896741890_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34414239406764x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('948', '海尚馨苑豪装大三房+对口金山小学和金山中学+金山万达附近', '3', '2', '2', '270.00', '134', '0', '0', '海尚馨苑', '金山', '121.354665', '30.761068', 'https://58fang-10011010.video.myqcloud.com/58fang/1002488040389627904_3_22.mp4.f30.mp4', '1002488040389627904_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34284212838335x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('949', '临地铁近学校不限贷繁华地段精装层高5米诚售', '1', '1', '1', '80.00', '20', '0', '0', '和源大楼', '闸北', '121.474141', '31.270997', 'https://58fang-10011010.video.myqcloud.com/58fang/1005278426153639936_3_22.mp4.f30.mp4', '1005278426153639936_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34369515456716x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('950', '古华新村,全明户型,低于市场价30万,近乐购 南桥汽车站', '3', '1', '1', '166.00', '73', '0', '0', '古华一区', '奉贤', '121.469479', '30.920867', 'https://58fang-10011010.video.myqcloud.com/58fang/1005634863681785856_3_22.mp4.f30.mp4', '1005634863681785856_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34380416420285x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('951', '高端住宅房 精装70年产权 可落户上学 地段好', '2', '2', '1', '69.00', '68', '0', '0', '乐苑淀山湖花园', '上海周边', '121.02378', '31.177', 'https://58fang-10011010.video.myqcloud.com/58fang/997788418211598336_3_22.mp4.f30.mp4', '997788418211598336_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34140960372659x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('952', '滨海花苑,成熟社区,机会留给有准备的人,亲、你准备好了吗？', '2', '2', '1', '85.00', '88', '0', '0', '滨海花苑', '金山', '121.372654', '30.768002', 'https://58fang-10011010.video.myqcloud.com/58fang/1003810270209929217_3_22.mp4.f30.mp4', '1003810270209929217_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34324726225594x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('954', '大湾名苑 2室2厅 送阁楼 80平310万 有钥匙', '2', '1', '1', '310.00', '80', '0', '0', '大湾名苑', '浦东', '121.692087', '31.251461', 'https://58fang-10011010.video.myqcloud.com/58fang/1004556714390880257.mov.f30.mp4', '1004556714390880257.mov.f30.mp4', 'http://sh.58.com/ershoufang/34347511756724x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('955', '重磅出击/民乐小区/出门大润发/门口民乐/离地铁口500米/', '2', '2', '1', '235.00', '79', '0', '0', '民乐二村', '松江', '121.228228', '31.023449', 'https://58fang-10011010.video.myqcloud.com/58fang/1002349753477910531_3_22.mp4.f30.mp4', '1002349753477910531_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34280161362254x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('956', '雅居乐南北通三房、精装修、家具家电全送、居影视小镇享健康人生', '3', '2', '1', '250.00', '89', '0', '0', '雅居乐星徽(公寓)', '松江', '121.31737', '31.013677', 'https://58fang-10011010.video.myqcloud.com/58fang/1004566205652029440.mp4.f30.mp4', '1004566205652029440.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34347793219266x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('957', '房东诚心出售房源 看房有钥匙 精装修家具家电赠送 实地拍摄', '1', '0', '1', '84.00', '28', '0', '0', '万乐城', '闵行', '121.452066', '31.044647', 'https://58fang-10011010.video.myqcloud.com/58fang/977376892438994944_3_22.mp4.f30.mp4', '977376892438994944_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33518045010512x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('958', '东升家园 复试大三房 带露台 使用面积300平 楼层好价格低', '3', '2', '2', '305.00', '126', '0', '0', '东升家园(北区)', '南汇', '121.609599', '31.030545', 'https://58fang-10011010.video.myqcloud.com/58fang/1003170307764150272_3_22.mp4.f30.mp4', '1003170307764150272_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34305177895744x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('959', '电梯一居室 一梯三户 房型正气', '1', '1', '1', '160.00', '55', '0', '0', '绿地东岸涟城', '浦东', '121.922902', '30.890722', 'https://58fang-10011010.video.myqcloud.com/58fang/1005472140310380544.mp4.f30.mp4', '1005472140310380544.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34375448443577x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('960', '地铁口望佳一村5楼南北小三房213万急售 可随时看房满五唯一', '3', '1', '1', '213.00', '79', '0', '0', '望佳一村', '闵行', '121.536608', '31.026163', 'https://58fang-10011010.video.myqcloud.com/58fang/997404833575108608_3_22.mp4.f30.mp4', '997404833575108608_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34129253198124x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('961', '国际度假区山水六旗旁南北通透大3房首付15万拎包入住', '3', '2', '2', '68.00', '107', '0', '0', '凤凰名邸', '上海周边', '120.951314', '30.586988', 'https://58fang-10011010.video.myqcloud.com/58fang/1004341424910524416_3_22.mp4.f30.mp4', '1004341424910524416_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34340922119608x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('962', '巨龙台湾城急卖房、楼层好、地段佳、无增税、近地铁、配套齐全', '1', '1', '1', '115.00', '42', '0', '0', '巨龙台湾城', '奉贤', '121.438995', '30.989819', 'https://58fang-10011010.video.myqcloud.com/58fang/994414247104512000_3_22.mp4.f30.mp4', '994414247104512000_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34037978946230x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('964', '新出房源五角场街道 部队品质小区 全明两房 我有钥匙随时看房', '2', '1', '1', '440.00', '71', '0', '0', '天翔花苑', '杨浦', '121.51675', '31.302017', 'https://58fang-10011010.video.myqcloud.com/58fang/1002847889824702465_3_22.mp4.f30.mp4', '1002847889824702465_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34295312641716x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('965', '次新小区，婚房装修，配套成熟，交通便利，投/资落/户随时看房', '2', '1', '1', '165.00', '102', '0', '0', '恒顺馨苑', '金山', '121.34689', '30.863787', 'https://58fang-10011010.video.myqcloud.com/58fang/1005617952306782208_3_22.mp4.f30.mp4', '1005617952306782208_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34282466142653x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('967', '碧桂园精装两房 未来地铁口 交通便利 配套齐全 价格低高收益', '2', '2', '2', '62.00', '89', '0', '0', '碧桂园', '上海周边', '121.43655', '30.171547', 'https://58fang-10011010.video.myqcloud.com/58fang/1002023856585601025.mp4.f30.mp4', '1002023856585601025.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34270209532215x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('968', '上海9号线对接嘉善新城核心精装修可落户首付10万', '1', '2', '1', '40.00', '51', '0', '0', '万联城', '上海周边', '120.933918', '30.824594', 'https://58fang-10011010.video.myqcloud.com/58fang/1004757195570577408.mp4.f30.mp4', '1004757195570577408.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34274235291052x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('969', '滚烫地段，南北通透1房，近龙柏地铁路站，精装看房随时', '1', '1', '1', '220.00', '47', '0', '0', '龙柏四村', '闵行', '121.367365', '31.182959', 'https://58fang-10011010.video.myqcloud.com/58fang/1003458812662796290_3_22.mp4.f30.mp4', '1003458812662796290_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34314006873516x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('970', '玉兰公馆，昆山核心位置，融创实力打造宫殿建筑，无缝对接上海', '3', '2', '1', '180.00', '86', '0', '0', '昆山玉兰公馆', '上海周边', '120.980419', '31.35902', 'https://58fang-10011010.video.myqcloud.com/58fang/1005438887952154624_3_22.mp4.f30.mp4', '1005438887952154624_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34374394473926x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('971', '豪华装修150万，景观大平层，接受长期置换，送车位，看房随时', '4', '2', '3', '730.00', '229', '0', '0', '安信湖畔天地', '松江', '121.220994', '31.039702', 'https://58fang-10011010.video.myqcloud.com/58fang/1004886347195904001_3_22.mp4.f30.mp4', '1004886347195904001_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34357572002895x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('972', '亲自实拍！浦欣苑，南北通两室，户型正，正常首付，近万达、菜场', '2', '1', '1', '200.00', '76', '0', '0', '永康城浦欣苑', '闵行', '121.505502', '31.034797', 'https://58fang-10011010.video.myqcloud.com/58fang/999469797940948995_3_22.mp4.f30.mp4', '999469797940948995_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34192273980100x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('973', '近地铁。景观楼层。豪华装修全送。房东置换，诚意出售。有钥匙', '1', '1', '1', '182.00', '60', '0', '0', '瑞和华苑', '闵行', '121.542954', '31.045162', 'https://58fang-10011010.video.myqcloud.com/58fang/1003966738485768192_3_22.mp4.f30.mp4', '1003966738485768192_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34313704727480x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('974', '低于市场价超值 急卖 看房随时方便，低于市场价40万急售', '1', '1', '1', '217.00', '46', '0', '0', '龙柏四村', '闵行', '121.367365', '31.182959', 'https://58fang-10011010.video.myqcloud.com/58fang/1003823705626800130_3_22.mp4.f30.mp4', '1003823705626800130_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34325140206509x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('975', '永康城佳兴苑+190万70平全明户型+前后采光无遮挡+有钥匙', '2', '2', '1', '190.00', '69', '0', '0', '永康城佳兴苑', '闵行', '121.517317', '31.04026', 'https://58fang-10011010.video.myqcloud.com/58fang/992938543288442880_3_22.mp4.f30.mp4', '992938543288442880_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33992949759677x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('976', '丽水湾新出2楼 小区中心位置 房东置换 有钥匙随时看', '2', '2', '1', '145.00', '86', '0', '0', '丽水湾', '奉贤', '121.393319', '30.902382', 'https://58fang-10011010.video.myqcloud.com/58fang/1001992109424672768.mov.f30.mp4', '1001992109424672768.mov.f30.mp4', 'http://sh.58.com/ershoufang/34269238667566x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('977', '总价低 嘉兴高铁旁 年轻人过渡，老人养老，投Z自住均适合', '3', '2', '2', '110.00', '88', '0', '0', '绿城春风十里', '上海周边', '120.866473', '30.670492', 'https://58fang-10011010.video.myqcloud.com/58fang/1003486485657186304_3_22.mp4.f30.mp4', '1003486485657186304_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34314707777225x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('978', '业主急售 靠近悦华大酒店  置换新房低于市场价15W 有钥匙', '2', '2', '1', '173.00', '84', '0', '0', '江海新村', '奉贤', '121.461058', '30.911146', 'https://58fang-10011010.video.myqcloud.com/58fang/1004898179780472832_3_22.mp4.f30.mp4', '1004898179780472832_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34349333398722x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('979', '外地人无需社保，70年产权住宅可落户，送家具家电，配套齐全。', '2', '2', '1', '60.00', '50', '0', '0', '锦园小区', '嘉定', '121.225826', '31.436127', 'https://58fang-10011010.video.myqcloud.com/58fang/1005262378889150465_3_22.mp4.f30.mp4', '1005262378889150465_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34369028637772x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('980', '地铁口70年住宅，可以公积金贷款送家具家电带车位超划算', '2', '2', '1', '150.00', '70', '0', '0', '金沙湾绿地和苑', '嘉定', '121.273311', '31.32586', 'https://58fang-10011010.video.myqcloud.com/58fang/999227539547250689_3_22.mp4.f30.mp4', '999227539547250689_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34137030624962x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('982', '首付18万起+近山水六旗+地铁市中心+可落户+适合投z自住', '3', '2', '1', '76.00', '73', '0', '0', '金洲海景', '上海周边', '120.969418', '30.548988', 'https://58fang-10011010.video.myqcloud.com/58fang/1002400230605352963_3_22.mp4.f30.mp4', '1002400230605352963_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34273851388234x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('983', '11号线地铁口一房可改两房 繁华商圈 重点校区 房东置换急售', '1', '2', '1', '200.00', '60', '0', '0', '汇丰凯苑', '嘉定', '121.232652', '31.392654', 'https://58fang-10011010.video.myqcloud.com/58fang/1005275122409431040_3_22.mp4.f30.mp4', '1005275122409431040_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34369435152690x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('984', '拎包即住,婚房当选和欣国际花园小区,小区花园,给您一个温馨家', '2', '2', '1', '500.00', '99', '0', '0', '和欣国际花园', '宝山', '121.444171', '31.341211', 'https://58fang-10011010.video.myqcloud.com/58fang/1003465461473501185_3_22.mp4.f30.mp4', '1003465461473501185_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34314212118854x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('985', '满2年：高区景观房：近11号线陈翔站：南北通透：近菜场商场、', '2', '2', '1', '400.00', '87', '0', '0', '森林公馆(东区)', '嘉定', '121.324469', '31.316534', 'https://58fang-10011010.video.myqcloud.com/58fang/1002447344169410560_3_22.mp4.f30.mp4', '1002447344169410560_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34283094362689x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('986', '新：精装修：低税费：轨交房：湖景视野很好：全明户型：拎包入住', '3', '2', '2', '420.00', '113', '0', '0', '湖畔天下(公寓)', '嘉定', '121.31183', '31.31934', 'https://58fang-10011010.video.myqcloud.com/58fang/1002447720234901504_3_22.mp4.f30.mp4', '1002447720234901504_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34283123532338x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('987', '汇锦城精装三房、房东诚心 、随时看房、拎包入住', '3', '2', '2', '370.00', '123', '0', '0', '汇锦城(三期)', '南汇', '121.645199', '31.038234', 'https://58fang-10011010.video.myqcloud.com/58fang/1004903642622361601_3_22.mp4.f30.mp4', '1004903642622361601_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34258593345723x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('988', '我有钥匙，看房随时！南北通正气2房，进才，东方幼儿园,代理房', '2', '2', '2', '1120.00', '112', '0', '0', '仁恒河滨城(三期)', '浦东', '121.572096', '31.236467', 'https://58fang-10011010.video.myqcloud.com/58fang/997055420201730049_3_22.mp4.f30.mp4', '997055420201730049_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34118402709186x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('989', '南北通正气2房，楼层高，进才九年制，低于市场70万，急售！', '2', '2', '2', '1180.00', '112', '0', '0', '仁恒河滨城(三期)', '浦东', '121.572096', '31.236467', 'https://58fang-10011010.video.myqcloud.com/58fang/1003214401014104064_3_22.mp4.f30.mp4', '1003214401014104064_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34306515736519x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('990', '青浦南湖新村首付24万买两房丨不要社保丨随时看房', '2', '2', '1', '80.00', '75', '0', '0', '南湖新村', '青浦', '121.060489', '31.110794', 'https://58fang-10011010.video.myqcloud.com/58fang/1005257900358139904_3_22.mp4.f30.mp4', '1005257900358139904_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34368861230130x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('991', '招商雍和府，宝山刚需神盘，总价260万，住3房，送精装修', '3', '2', '1', '260.00', '98', '0', '0', '美兰金色宝邸', '宝山', '121.33913', '31.487911', 'https://58fang-10011010.video.myqcloud.com/58fang/1005296867304570880_3_22.mp4.f30.mp4', '1005296867304570880_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34370096571563x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('992', '宏立瑞园，高区南北通透大三房，一手动迁少税，低于市场价30万', '3', '2', '2', '390.00', '121', '0', '0', '宏立瑞园', '嘉定', '121.328875', '31.315826', 'https://58fang-10011010.video.myqcloud.com/58fang/1002071076345249792_3_22.mp4.f30.mp4', '1002071076345249792_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34271597275818x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('993', '精装地铁朝南LOFT 低于市场价30万 精装花了20万 诚售', '2', '2', '1', '130.00', '49', '0', '0', '旭辉U天地', '嘉定', '121.332361', '31.309044', 'https://58fang-10011010.video.myqcloud.com/58fang/1004927943224348672_3_22.mp4.f30.mp4', '1004927943224348672_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34358599303483x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('994', '學区（打一、模范）2房 78平285W ,景观楼层+南北诚', '2', '1', '1', '285.00', '78', '0', '0', '星纳家园', '浦东', '121.67763', '31.298834', 'https://58fang-10011010.video.myqcloud.com/58fang/999845178267160578_3_22.mp4.f30.mp4', '999845178267160578_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34203728709162x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('995', '三天必卖！地铁口的单价3万6好房！诚心不跳价！有钥匙 急售！', '2', '2', '1', '315.00', '87', '0', '0', '上隽嘉苑(公寓)', '嘉定', '121.323158', '31.321726', 'https://58fang-10011010.video.myqcloud.com/58fang/1000559483765686273_3_22.mp4.f30.mp4', '1000559483765686273_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34225460542923x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('996', '绿地长岛+精装一手房++世界生态岛', '2', '2', '1', '83.00', '75', '0', '0', '绿地长岛', '上海周边', '121.468122', '31.799206', 'https://58fang-10011010.video.myqcloud.com/58fang/986563749743722496.mov.f30.mp4', '986563749743722496.mov.f30.mp4', 'http://sh.58.com/ershoufang/33664135361208x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('997', '眞实在卖，假一罚万丨南北通两南户型丨景观视野好丨匹配东华學校', '3', '2', '1', '328.00', '91', '0', '0', '德邑小城(公寓)', '松江', '121.191737', '31.04598', 'https://58fang-10011010.video.myqcloud.com/58fang/1002764761751900160_3_22.mp4.f30.mp4', '1002764761751900160_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34292826255045x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('998', '送60平入室花园 正气飞机户型 低于市价50万 精装拎包入住', '3', '2', '2', '500.00', '120', '0', '0', '龙柏西郊公寓', '闵行', '121.367481', '31.185063', 'https://58fang-10011010.video.myqcloud.com/58fang/990777741706022912_3_22.mp4.f30.mp4', '990777741706022912_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/33927012257476x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('999', '新出笋盘 急售直降30万 无户口产权1人 近商场地铁 随时看', '2', '1', '1', '300.00', '75', '0', '0', '馨佳园十二街坊', '宝山', '121.378448', '31.36641', 'https://58fang-10011010.video.myqcloud.com/58fang/1000703334174187520_3_22.mp4.f30.mp4', '1000703334174187520_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34229916867523x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1000', '涨涨涨~中美止战~货币贬值~上海70年产权大三房~~东港花苑', '3', '2', '2', '385.00', '141', '0', '0', '东港花苑三村', '浦东', '121.771265', '31.115236', 'https://58fang-10011010.video.myqcloud.com/58fang/998027296906436608_3_22.mp4.f30.mp4', '998027296906436608_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34174587186116x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1001', '小区中心位置，精装修南北两房，房东诚售，出门就是公交车站台！', '2', '2', '1', '249.90', '95', '0', '0', '文怡花园', '奉贤', '121.446454', '30.999752', 'https://58fang-10011010.video.myqcloud.com/58fang/1003838515458367488_3_22.mp4.f30.mp4', '1003838515458367488_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34325589902660x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1002', '金汇一街坊 全明南北三房 三开间朝南 采光通风好 诚心出售', '3', '2', '2', '690.00', '137', '0', '0', '金汇花园一街坊', '闵行', '121.377604', '31.188583', 'https://58fang-10011010.video.myqcloud.com/58fang/995500853009866755_3_22.mp4.f30.mp4', '995500853009866755_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34071112250046x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1003', '房正实用南北通透房东置换急售预购从速', '2', '1', '1', '200.00', '71', '0', '0', '润渡佳苑(东区)', '嘉定', '121.232945', '31.273865', 'https://58fang-10011010.video.myqcloud.com/58fang/1005263957897793537_3_22.mp4.f30.mp4', '1005263957897793537_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34369095810218x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1004', '呼玛四村 地铁口小区 南北通透 精装修两房 交通便利 急卖', '2', '1', '1', '235.00', '58', '0', '0', '呼玛四村', '宝山', '121.45169', '31.350161', 'https://58fang-10011010.video.myqcloud.com/58fang/1002086205078134786_3_22.mp4.f30.mp4', '1002086205078134786_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34272120585131x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1005', '汤臣一品，新推高区顶楼复式，俯澜百年外滩，一线江景房值得收藏', '6', '3', '3', '19999.00', '888', '0', '0', '汤臣一品', '浦东', '121.508381', '31.238608', 'https://58fang-10011010.video.myqcloud.com/58fang/995473397334953985_3_22.mp4.f30.mp4', '995473397334953985_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34070309808300x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1006', '紧邻地铁口南北通两房，自带30平的小花园，精装修直接拎包入住', '2', '2', '1', '235.00', '83', '0', '0', '水岸家苑(一期)', '奉贤', '121.437794', '30.991647', 'https://58fang-10011010.video.myqcloud.com/58fang/1003846954125393923_3_22.mp4.f30.mp4', '1003846954125393923_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34325852772546x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1007', '赠100平露台，赠产权车位，一览二期好风景，满五少税，直接看', '2', '2', '3', '550.00', '90', '0', '0', '龙柏香榭苑', '闵行', '121.372972', '31.180961', 'https://58fang-10011010.video.myqcloud.com/58fang/1004934721727123456_3_22.mp4.f30.mp4', '1004934721727123456_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34359043073966x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1008', '淀山湖畔精装4房，无社保可买，首付3成，自带幼儿园商业', '4', '2', '2', '200.00', '125', '0', '0', '万科海上传奇', '上海周边', '120.967917', '31.187395', 'https://58fang-10011010.video.myqcloud.com/58fang/997294672781004800_3_22.mp4.f30.mp4', '997294672781004800_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34125889186246x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1009', '无需社保首付44万静安核心地段可网签挑高4.8米', '2', '2', '1', '145.00', '30', '0', '0', '灵石路1565弄小区', '普陀', '121.428864', '31.273432', 'https://58fang-10011010.video.myqcloud.com/58fang/1005265708298305537_3_22.mp4.f30.mp4', '1005265708298305537_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34369096472745x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1010', '海门港新区珍藏版别墅 叠加/联排/独栋 户户水景 随时看房！', '4', '2', '3', '154.00', '181', '0', '0', '海湾假日花园(别墅)', '上海周边', '121.485119', '32.117465', 'https://58fang-10011010.video.myqcloud.com/58fang/1002042104924372993_3_22.mp4.f30.mp4', '1002042104924372993_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34258409169600x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1011', '芳沁苑 近地铁 二中心小学 灵石公园 业主置换降价60万急售', '2', '2', '1', '549.00', '92', '0', '0', '芳沁苑', '闸北', '121.440493', '31.282447', 'https://58fang-10011010.video.myqcloud.com/58fang/1002783531878862849_3_22.mp4.f30.mp4', '1002783531878862849_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34293400113486x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1012', '首付19万 低密度花园洋房 上海9号线延伸 张江高科科技园', '3', '2', '1', '130.00', '89', '0', '0', '融创江南悦', '上海周边', '121.089242', '30.836026', 'https://58fang-10011010.video.myqcloud.com/58fang/1002740880207015936_3_22.mp4.f30.mp4', '1002740880207015936_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34292097288373x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1013', '~上海高铁东站~祝桥东港花苑大三房~祝桥航空交通枢纽中心~', '3', '2', '2', '385.00', '141', '0', '0', '东港花苑', '南汇', '121.768144', '31.114683', 'https://58fang-10011010.video.myqcloud.com/58fang/993395749913919490_3_22.mp4.f30.mp4', '993395749913919490_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34174580420175x.shtml');
INSERT INTO `yf_hf_video_58_copy1` VALUES ('1014', '汇锦城 毛坯复试178平 中间楼层 中间位置 看房随时', '4', '2', '3', '480.00', '178', '0', '0', '汇锦城(一期)', '南汇', '121.643007', '31.037817', 'https://58fang-10011010.video.myqcloud.com/58fang/1001031442232266752_3_22.mp4.f30.mp4', '1001031442232266752_3_22.mp4.f30.mp4', 'http://sh.58.com/ershoufang/34239930814261x.shtml');

-- ----------------------------
-- Table structure for yf_hf_watermark_video
-- ----------------------------
DROP TABLE IF EXISTS `yf_hf_watermark_video`;
CREATE TABLE `yf_hf_watermark_video` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_hiid` varchar(20) DEFAULT NULL COMMENT '用户hiid',
  `video_id` int(11) DEFAULT NULL,
  `video_name` varchar(50) DEFAULT NULL COMMENT '原视频文件名',
  `video_link` varchar(255) DEFAULT NULL COMMENT '加水印的新连接',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(11) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=457 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yf_hf_watermark_video
-- ----------------------------
INSERT INTO `yf_hf_watermark_video` VALUES ('2', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1006463689810796544.mp4.f30.mp4', '1529551489', '1529551489');
INSERT INTO `yf_hf_watermark_video` VALUES ('3', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621112035', '1529551886', '1529551886');
INSERT INTO `yf_hf_watermark_video` VALUES ('4', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621103007', '1529552290', '1529552290');
INSERT INTO `yf_hf_watermark_video` VALUES ('5', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1006463689810796544.mp4.f30.mp4', '1529552509', '1529552509');
INSERT INTO `yf_hf_watermark_video` VALUES ('6', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1006463689810796544.mp4.f30.mp4', '1529552645', '1529552645');
INSERT INTO `yf_hf_watermark_video` VALUES ('7', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621112035', '1529552774', '1529552774');
INSERT INTO `yf_hf_watermark_video` VALUES ('8', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621112035', '1529552787', '1529552787');
INSERT INTO `yf_hf_watermark_video` VALUES ('9', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621112035', '1529552794', '1529552794');
INSERT INTO `yf_hf_watermark_video` VALUES ('10', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621114725', '1529552847', '1529552847');
INSERT INTO `yf_hf_watermark_video` VALUES ('11', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621112035', '1529556722', '1529556722');
INSERT INTO `yf_hf_watermark_video` VALUES ('12', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621112035', '1529556809', '1529556809');
INSERT INTO `yf_hf_watermark_video` VALUES ('18', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621105207', '1529557156', '1529557156');
INSERT INTO `yf_hf_watermark_video` VALUES ('19', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621105207', '1529557164', '1529557164');
INSERT INTO `yf_hf_watermark_video` VALUES ('20', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621105207', '1529557172', '1529557172');
INSERT INTO `yf_hf_watermark_video` VALUES ('21', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621103007', '1529557298', '1529557298');
INSERT INTO `yf_hf_watermark_video` VALUES ('22', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621103007', '1529557357', '1529557357');
INSERT INTO `yf_hf_watermark_video` VALUES ('23', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621112035', '1529557437', '1529557437');
INSERT INTO `yf_hf_watermark_video` VALUES ('24', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621130516', '1529557517', '1529557517');
INSERT INTO `yf_hf_watermark_video` VALUES ('25', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621130935', '1529557777', '1529557777');
INSERT INTO `yf_hf_watermark_video` VALUES ('26', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621130948', '1529557789', '1529557789');
INSERT INTO `yf_hf_watermark_video` VALUES ('27', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621132434', '1529558676', '1529558676');
INSERT INTO `yf_hf_watermark_video` VALUES ('28', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621132434', '1529558990', '1529558990');
INSERT INTO `yf_hf_watermark_video` VALUES ('29', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621131406', '1529558995', '1529558995');
INSERT INTO `yf_hf_watermark_video` VALUES ('30', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621131406', '1529559021', '1529559021');
INSERT INTO `yf_hf_watermark_video` VALUES ('31', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621112035', '1529559028', '1529559028');
INSERT INTO `yf_hf_watermark_video` VALUES ('32', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621112035', '1529559183', '1529559183');
INSERT INTO `yf_hf_watermark_video` VALUES ('33', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621133422', '1529559264', '1529559264');
INSERT INTO `yf_hf_watermark_video` VALUES ('34', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1000566427213660161_3_22.mp4.f30.mp4', '1529559279', '1529559279');
INSERT INTO `yf_hf_watermark_video` VALUES ('35', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1001008133176315904_3_22.mp4.f30.mp4', '1529559567', '1529559567');
INSERT INTO `yf_hf_watermark_video` VALUES ('36', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1002357765701660672_3_22.mp4.f30.mp4', '1529559694', '1529559694');
INSERT INTO `yf_hf_watermark_video` VALUES ('37', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529559725', '1529559725');
INSERT INTO `yf_hf_watermark_video` VALUES ('38', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529559759', '1529559759');
INSERT INTO `yf_hf_watermark_video` VALUES ('39', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621133422', '1529559768', '1529559768');
INSERT INTO `yf_hf_watermark_video` VALUES ('40', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621132434', '1529559805', '1529559805');
INSERT INTO `yf_hf_watermark_video` VALUES ('41', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621131406', '1529559816', '1529559816');
INSERT INTO `yf_hf_watermark_video` VALUES ('42', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621112035', '1529559824', '1529559824');
INSERT INTO `yf_hf_watermark_video` VALUES ('43', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529559873', '1529559873');
INSERT INTO `yf_hf_watermark_video` VALUES ('44', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621133422', '1529559889', '1529559889');
INSERT INTO `yf_hf_watermark_video` VALUES ('45', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621132434', '1529559894', '1529559894');
INSERT INTO `yf_hf_watermark_video` VALUES ('46', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529559948', '1529559948');
INSERT INTO `yf_hf_watermark_video` VALUES ('47', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1003877127285657600_3_22.mp4.f30.mp4', '1529560091', '1529560091');
INSERT INTO `yf_hf_watermark_video` VALUES ('48', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1003877127285657600_3_22.mp4.f30.mp4', '1529560098', '1529560098');
INSERT INTO `yf_hf_watermark_video` VALUES ('49', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1006463689810796544.mp4.f30.mp4', '1529560109', '1529560109');
INSERT INTO `yf_hf_watermark_video` VALUES ('50', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529560167', '1529560167');
INSERT INTO `yf_hf_watermark_video` VALUES ('51', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529560260', '1529560260');
INSERT INTO `yf_hf_watermark_video` VALUES ('52', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529560356', '1529560356');
INSERT INTO `yf_hf_watermark_video` VALUES ('53', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529560407', '1529560407');
INSERT INTO `yf_hf_watermark_video` VALUES ('54', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529560562', '1529560562');
INSERT INTO `yf_hf_watermark_video` VALUES ('55', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529560602', '1529560602');
INSERT INTO `yf_hf_watermark_video` VALUES ('56', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529560796', '1529560796');
INSERT INTO `yf_hf_watermark_video` VALUES ('57', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621133422', '1529560807', '1529560807');
INSERT INTO `yf_hf_watermark_video` VALUES ('58', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180621133806', '1529560896', '1529560896');
INSERT INTO `yf_hf_watermark_video` VALUES ('59', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621133422', '1529560921', '1529560921');
INSERT INTO `yf_hf_watermark_video` VALUES ('60', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621132434', '1529560968', '1529560968');
INSERT INTO `yf_hf_watermark_video` VALUES ('61', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621112035', '1529560975', '1529560975');
INSERT INTO `yf_hf_watermark_video` VALUES ('62', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1006463689810796544.mp4.f30.mp4', '1529561012', '1529561012');
INSERT INTO `yf_hf_watermark_video` VALUES ('63', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180620155230', '1529561388', '1529561388');
INSERT INTO `yf_hf_watermark_video` VALUES ('64', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1003877127285657600_3_22.mp4.f30.mp4', '1529561476', '1529561476');
INSERT INTO `yf_hf_watermark_video` VALUES ('65', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180620155230', '1529561785', '1529561785');
INSERT INTO `yf_hf_watermark_video` VALUES ('66', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621141807', '1529561889', '1529561889');
INSERT INTO `yf_hf_watermark_video` VALUES ('67', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621141933', '1529561974', '1529561974');
INSERT INTO `yf_hf_watermark_video` VALUES ('68', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621142237', '1529562158', '1529562158');
INSERT INTO `yf_hf_watermark_video` VALUES ('69', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621142850', '1529562533', '1529562533');
INSERT INTO `yf_hf_watermark_video` VALUES ('70', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621143041', '1529562647', '1529562647');
INSERT INTO `yf_hf_watermark_video` VALUES ('71', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180620155230', '1529562806', '1529562806');
INSERT INTO `yf_hf_watermark_video` VALUES ('72', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1003877127285657600_3_22.mp4.f30.mp4', '1529562848', '1529562848');
INSERT INTO `yf_hf_watermark_video` VALUES ('73', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180621143413', '1529562855', '1529562855');
INSERT INTO `yf_hf_watermark_video` VALUES ('74', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo_iOS_20180620155230', '1529562960', '1529562960');
INSERT INTO `yf_hf_watermark_video` VALUES ('75', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1003877127285657600_3_22.mp4.f30.mp4', '1529563035', '1529563035');
INSERT INTO `yf_hf_watermark_video` VALUES ('76', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1003877127285657600_3_22.mp4.f30.mp4', '1529563511', '1529563511');
INSERT INTO `yf_hf_watermark_video` VALUES ('77', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1003877127285657600_3_22.mp4.f30.mp4', '1529563533', '1529563533');
INSERT INTO `yf_hf_watermark_video` VALUES ('78', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1003877127285657600_3_22.mp4.f30.mp4', '1529563629', '1529563629');
INSERT INTO `yf_hf_watermark_video` VALUES ('79', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1003877127285657600_3_22.mp4.f30.mp4', '1529563663', '1529563663');
INSERT INTO `yf_hf_watermark_video` VALUES ('80', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180615100105', '1529563683', '1529563683');
INSERT INTO `yf_hf_watermark_video` VALUES ('81', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180615100505', '1529563739', '1529563739');
INSERT INTO `yf_hf_watermark_video` VALUES ('82', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180615100505', '1529563837', '1529563837');
INSERT INTO `yf_hf_watermark_video` VALUES ('83', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180615100105', '1529563890', '1529563890');
INSERT INTO `yf_hf_watermark_video` VALUES ('84', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1003877127285657600_3_22.mp4.f30.mp4', '1529563998', '1529563998');
INSERT INTO `yf_hf_watermark_video` VALUES ('85', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1003877127285657600_3_22.mp4.f30.mp4', '1529564010', '1529564010');
INSERT INTO `yf_hf_watermark_video` VALUES ('86', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new997662835750227968_3_22.mp4.f30.mp4', '1529564279', '1529564279');
INSERT INTO `yf_hf_watermark_video` VALUES ('87', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new997662835750227968_3_22.mp4.f30.mp4', '1529564473', '1529564473');
INSERT INTO `yf_hf_watermark_video` VALUES ('88', '44691242', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new1006463689810796544.mp4.f30.mp4', '1529564555', '1529564555');
INSERT INTO `yf_hf_watermark_video` VALUES ('89', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new997662835750227968_3_22.mp4.f30.mp4', '1529565016', '1529565016');
INSERT INTO `yf_hf_watermark_video` VALUES ('90', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new997662835750227968_3_22.mp4.f30.mp4', '1529565059', '1529565059');
INSERT INTO `yf_hf_watermark_video` VALUES ('91', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180615100105', '1529565073', '1529565073');
INSERT INTO `yf_hf_watermark_video` VALUES ('92', '07976784', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new997662835750227968_3_22.mp4.f30.mp4', '1529565175', '1529565175');
INSERT INTO `yf_hf_watermark_video` VALUES ('93', '07976784', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new997662835750227968_3_22.mp4.f30.mp4', '1529565177', '1529565177');
INSERT INTO `yf_hf_watermark_video` VALUES ('94', '2147483647', '2147483647', null, 'http://p79qkwz6c.bkt.clouddn.com/new997662835750227968_3_22.mp4.f30.mp4', '1529565189', '1529565189');
INSERT INTO `yf_hf_watermark_video` VALUES ('95', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180615100505', '1529565208', '1529565208');
INSERT INTO `yf_hf_watermark_video` VALUES ('96', '07976784', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180606225248', '1529565221', '1529565221');
INSERT INTO `yf_hf_watermark_video` VALUES ('97', '07976784', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180606225248', '1529565225', '1529565225');
INSERT INTO `yf_hf_watermark_video` VALUES ('98', '07976784', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180606225248', '1529565236', '1529565236');
INSERT INTO `yf_hf_watermark_video` VALUES ('99', '07976784', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180606073032', '1529565248', '1529565248');
INSERT INTO `yf_hf_watermark_video` VALUES ('100', '07976784', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180606073032', '1529565255', '1529565255');
INSERT INTO `yf_hf_watermark_video` VALUES ('101', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180606225248', '1529565277', '1529565277');
INSERT INTO `yf_hf_watermark_video` VALUES ('102', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180606225248', '1529565301', '1529565301');
INSERT INTO `yf_hf_watermark_video` VALUES ('103', '44691242', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180606225248', '1529565303', '1529565303');
INSERT INTO `yf_hf_watermark_video` VALUES ('104', '07976784', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180606073032', '1529565313', '1529565313');
INSERT INTO `yf_hf_watermark_video` VALUES ('105', '07976784', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180606073032', '1529565316', '1529565316');
INSERT INTO `yf_hf_watermark_video` VALUES ('106', '2147483647', '0', null, 'http://p79qkwz6c.bkt.clouddn.com/newvideo-android-20180615100105', '1529565467', '1529565467');

-- ----------------------------
-- Table structure for yf_hooks
-- ----------------------------
DROP TABLE IF EXISTS `yf_hooks`;
CREATE TABLE `yf_hooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '钩子ID',
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT '钩子名称',
  `description` varchar(300) NOT NULL DEFAULT '' COMMENT '描述',
  `plugins` varchar(500) NOT NULL DEFAULT '' COMMENT '钩子挂载的插件',
  `type` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '类型。1视图，2控制器',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态。1启用，0禁用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='钩子表';

-- ----------------------------
-- Records of yf_hooks
-- ----------------------------
INSERT INTO `yf_hooks` VALUES ('1', 'AdminIndex', '后台首页小工具', '', '1', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('2', 'FormBuilderExtend', 'FormBuilder类型扩展Builder', '', '1', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('3', 'UploadFile', '上传文件钩子', '', '1', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('4', 'PageHeader', '页面header钩子，一般用于加载插件CSS文件和代码', '', '1', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('5', 'PageFooter', '页面footer钩子，一般用于加载插件CSS文件和代码', '', '1', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('6', 'ThirdLogin', '第三方账号登陆', '', '1', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('7', 'SendMessage', '发送消息钩子，用于消息发送途径的扩展', '', '2', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('8', 'sms', '短信插件钩子', '', '2', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('10', 'ImageGallery', '图片轮播钩子', '', '1', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('11', 'JChinaCity', '每个系统都需要的一个中国省市区三级联动插件。', '', '1', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('13', 'editor', '内容编辑器钩子', '', '1', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('14', 'adminEditor', '后台内容编辑页编辑器', '', '1', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('15', 'ThirdLogin', '集成第三方授权登录，包括微博、QQ、微信、码云', '', '1', '1518696015', '1518696015', '1');
INSERT INTO `yf_hooks` VALUES ('16', 'comment', '实现本地评论功能，支持评论点赞', '', '1', '1520776468', '1520776468', '1');

-- ----------------------------
-- Table structure for yf_links
-- ----------------------------
DROP TABLE IF EXISTS `yf_links`;
CREATE TABLE `yf_links` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `image` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '图标',
  `url` varchar(150) NOT NULL DEFAULT '' COMMENT '链接',
  `target` varchar(25) NOT NULL DEFAULT '_blank' COMMENT '打开方式',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  `rating` int(11) unsigned NOT NULL COMMENT '评级',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `sort` tinyint(3) unsigned NOT NULL DEFAULT '99' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态，1启用，0禁用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='友情链接表';

-- ----------------------------
-- Records of yf_links
-- ----------------------------
INSERT INTO `yf_links` VALUES ('1', '百度', '96', 'http://www.baidu.com', '_blank', '2', '8', '1467863440', '1506825187', '2', '1');
INSERT INTO `yf_links` VALUES ('2', '淘宝', '89', 'http://www.taobao.com', '_blank', '1', '9', '1465053539', '1506825148', '1', '1');

-- ----------------------------
-- Table structure for yf_modules
-- ----------------------------
DROP TABLE IF EXISTS `yf_modules`;
CREATE TABLE `yf_modules` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(31) NOT NULL DEFAULT '' COMMENT '名称',
  `title` varchar(63) NOT NULL DEFAULT '' COMMENT '标题',
  `description` varchar(127) NOT NULL DEFAULT '' COMMENT '描述',
  `author` varchar(31) NOT NULL DEFAULT '' COMMENT '开发者',
  `version` varchar(7) NOT NULL DEFAULT '' COMMENT '版本',
  `config` text NOT NULL COMMENT '配置',
  `is_system` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否允许卸载',
  `url` varchar(120) DEFAULT NULL COMMENT '站点',
  `admin_manage_into` varchar(60) DEFAULT '' COMMENT '后台管理入口',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sort` tinyint(3) unsigned NOT NULL DEFAULT '99' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态。0禁用，1启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='模块功能表';

-- ----------------------------
-- Records of yf_modules
-- ----------------------------
INSERT INTO `yf_modules` VALUES ('1', 'user', '用户中心', '用户模块，系统核心模块，不可卸载', '心云间、凝听', '1.0.2', '', '1', 'http://www.eacoo123.com', '', '1520095970', '1520095970', '99', '1');
INSERT INTO `yf_modules` VALUES ('2', 'home', '前台Home', '一款基础前台Home模块', '心云间、凝听', '1.0.0', '', '1', null, '', '1520095970', '1520095970', '99', '1');

-- ----------------------------
-- Table structure for yf_nav
-- ----------------------------
DROP TABLE IF EXISTS `yf_nav`;
CREATE TABLE `yf_nav` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(60) NOT NULL DEFAULT '' COMMENT '标题',
  `value` varchar(120) DEFAULT '' COMMENT 'url地址',
  `pid` smallint(6) unsigned NOT NULL DEFAULT '0' COMMENT '父级',
  `position` varchar(20) NOT NULL DEFAULT '' COMMENT '位置。头部：header，我的：my',
  `target` varchar(15) DEFAULT '_self' COMMENT '打开方式。',
  `depend_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '来源类型。0普通外链http，1模块扩展，2插件扩展，3主题扩展',
  `depend_flag` varchar(30) NOT NULL DEFAULT '' COMMENT '来源标记。如：模块或插件标识',
  `icon` varchar(120) NOT NULL DEFAULT '' COMMENT '图标',
  `sort` tinyint(3) unsigned NOT NULL DEFAULT '99' COMMENT '排序',
  `update_time` int(10) unsigned NOT NULL COMMENT '更新时间',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态。0禁用，1启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='前台导航';

-- ----------------------------
-- Records of yf_nav
-- ----------------------------
INSERT INTO `yf_nav` VALUES ('1', '主页', '/', '0', 'header', '_self', '1', 'home', 'fa fa-home', '10', '1517978360', '1516206948', '1');
INSERT INTO `yf_nav` VALUES ('2', '会员', 'user/index/index', '0', 'header', '_self', '1', 'user', '', '99', '1516245690', '1516245690', '1');
INSERT INTO `yf_nav` VALUES ('3', '下载', 'https://gitee.com/ZhaoJunfeng/EacooPHP/attach_files', '0', 'header', '_blank', '0', '', '', '99', '1516245884', '1516245884', '1');
INSERT INTO `yf_nav` VALUES ('4', '社区', 'http://forum.eacoo123.com', '0', 'header', '_blank', '0', '', '', '99', '1516246000', '1516246000', '1');
INSERT INTO `yf_nav` VALUES ('5', '文档', 'https://www.kancloud.cn/youpzt/eacoo', '0', 'header', '_blank', '0', '', '', '99', '1516249947', '1516249947', '1');

-- ----------------------------
-- Table structure for yf_plugins
-- ----------------------------
DROP TABLE IF EXISTS `yf_plugins`;
CREATE TABLE `yf_plugins` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT '插件名或标识',
  `title` varchar(32) NOT NULL DEFAULT '' COMMENT '中文名',
  `description` text NOT NULL COMMENT '插件描述',
  `config` text COMMENT '配置',
  `author` varchar(32) NOT NULL DEFAULT '' COMMENT '作者',
  `version` varchar(8) NOT NULL DEFAULT '' COMMENT '版本号',
  `admin_manage_into` varchar(60) DEFAULT '0' COMMENT '后台管理入口',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '插件类型',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '安装时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `sort` tinyint(3) unsigned NOT NULL DEFAULT '99' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='插件表';

-- ----------------------------
-- Records of yf_plugins
-- ----------------------------

-- ----------------------------
-- Table structure for yf_rewrite
-- ----------------------------
DROP TABLE IF EXISTS `yf_rewrite`;
CREATE TABLE `yf_rewrite` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id自增',
  `rule` varchar(255) NOT NULL DEFAULT '' COMMENT '规则',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT 'url',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态：0禁用，1启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='伪静态表';

-- ----------------------------
-- Records of yf_rewrite
-- ----------------------------

-- ----------------------------
-- Table structure for yf_terms
-- ----------------------------
DROP TABLE IF EXISTS `yf_terms`;
CREATE TABLE `yf_terms` (
  `term_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) NOT NULL COMMENT '分类名称',
  `slug` varchar(100) DEFAULT '' COMMENT '分类别名',
  `taxonomy` varchar(32) DEFAULT '' COMMENT '分类类型',
  `pid` int(10) unsigned DEFAULT '0' COMMENT '上级ID',
  `seo_title` varchar(128) DEFAULT '' COMMENT 'seo标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'seo 关键词',
  `seo_description` varchar(255) DEFAULT '' COMMENT 'seo描述',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sort` int(10) unsigned DEFAULT '99' COMMENT '排序号',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态，1发布，0不发布',
  PRIMARY KEY (`term_id`),
  KEY `idx_taxonomy` (`taxonomy`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='分类';

-- ----------------------------
-- Records of yf_terms
-- ----------------------------
INSERT INTO `yf_terms` VALUES ('1', '未分类', 'nocat', 'post_category', '0', '未分类', '', '自定义分类描述', '0', '1516432626', '99', '1');
INSERT INTO `yf_terms` VALUES ('4', '大数据', 'tag_dashuju', 'post_tag', '0', '大数据', '', '这是标签描述', '0', '1466612845', '99', '1');
INSERT INTO `yf_terms` VALUES ('5', '技术类', 'technology', 'post_category', '0', '技术类', '关键词', '自定义分类描述', '1465570866', '1516430690', '99', '1');
INSERT INTO `yf_terms` VALUES ('6', '大数据', 'cat_dashuju', 'post_category', '0', '大数据', '大数据', '这是描述内容', '1465576314', '1466607965', '99', '1');
INSERT INTO `yf_terms` VALUES ('7', '运营', 'yunying', 'post_tag', '0', '运营', '关键字', '自定义标签描述', '1466612937', '1516432746', '99', '1');
INSERT INTO `yf_terms` VALUES ('9', '人物', 'renwu', 'media_cat', '0', '人物', '', '聚集多为人物显示的分类', '1466613381', '1466613381', '99', '1');
INSERT INTO `yf_terms` VALUES ('10', '美食', 'meishi', 'media_cat', '0', '美食', '', '', '1466613499', '1466613499', '99', '1');
INSERT INTO `yf_terms` VALUES ('11', '图标素材', 'icons', 'media_cat', '0', '图标素材', '', '', '1466613803', '1466613803', '99', '1');
INSERT INTO `yf_terms` VALUES ('12', '风景', 'fengjin', 'media_cat', '0', '风景', '风景', '', '1466614026', '1506557501', '99', '1');
INSERT INTO `yf_terms` VALUES ('13', '其它', 'others', 'media_cat', '0', '其它', '', '', '1467689719', '1519814576', '99', '1');

-- ----------------------------
-- Table structure for yf_term_relationships
-- ----------------------------
DROP TABLE IF EXISTS `yf_term_relationships`;
CREATE TABLE `yf_term_relationships` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `object_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'posts表里文章id',
  `term_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '分类id',
  `table` varchar(60) NOT NULL COMMENT '数据表',
  `uid` int(11) unsigned DEFAULT '0' COMMENT '分类与用户关系',
  `sort` int(10) unsigned NOT NULL DEFAULT '99' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态，1发布，0不发布',
  PRIMARY KEY (`id`),
  KEY `idx_term_id` (`term_id`),
  KEY `idx_object_id` (`object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='对象分类对应表';

-- ----------------------------
-- Records of yf_term_relationships
-- ----------------------------
INSERT INTO `yf_term_relationships` VALUES ('1', '95', '9', 'attachment', '0', '99', '1');
INSERT INTO `yf_term_relationships` VALUES ('2', '94', '13', 'attachment', '0', '99', '1');
INSERT INTO `yf_term_relationships` VALUES ('3', '116', '12', 'attachment', '0', '99', '1');
INSERT INTO `yf_term_relationships` VALUES ('4', '92', '12', 'attachment', '0', '99', '1');
INSERT INTO `yf_term_relationships` VALUES ('5', '70', '12', 'attachment', '0', '9', '1');
INSERT INTO `yf_term_relationships` VALUES ('6', '93', '11', 'attachment', '0', '99', '1');
INSERT INTO `yf_term_relationships` VALUES ('7', '96', '12', 'attachment', '0', '99', '1');
INSERT INTO `yf_term_relationships` VALUES ('8', '12', '11', 'attachment', '0', '99', '1');

-- ----------------------------
-- Table structure for yf_themes
-- ----------------------------
DROP TABLE IF EXISTS `yf_themes`;
CREATE TABLE `yf_themes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT '名称',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT '标题',
  `description` varchar(127) NOT NULL DEFAULT '' COMMENT '描述',
  `author` varchar(32) NOT NULL DEFAULT '' COMMENT '开发者',
  `version` varchar(8) NOT NULL DEFAULT '' COMMENT '版本',
  `config` text COMMENT '主题配置',
  `current` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '当前主题类型，1PC端，2手机端。默认0',
  `website` varchar(120) DEFAULT '' COMMENT '站点',
  `sort` tinyint(4) unsigned NOT NULL DEFAULT '99' COMMENT '排序',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(3) NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='前台主题表';

-- ----------------------------
-- Records of yf_themes
-- ----------------------------
INSERT INTO `yf_themes` VALUES ('1', 'default', '默认主题', '内置于系统中，是其它主题的基础主题', '心云间、凝听', '1.0.2', '', '1', 'http://www.eacoo123.com', '99', '1475899420', '1520090170', '1');
INSERT INTO `yf_themes` VALUES ('2', 'default-mobile', '默认主题-手机端', '内置于系统中，是系统的默认主题。手机端', '心云间、凝听', '1.0.1', '', '2', '', '99', '1520089999', '1520092270', '1');

-- ----------------------------
-- Table structure for yf_users
-- ----------------------------
DROP TABLE IF EXISTS `yf_users`;
CREATE TABLE `yf_users` (
  `uid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL DEFAULT '""' COMMENT '用户名',
  `number` char(10) DEFAULT '' COMMENT '会员编号',
  `password` char(32) NOT NULL DEFAULT '' COMMENT '登录密码',
  `nickname` varchar(60) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '登录邮箱',
  `mobile` varchar(20) DEFAULT '' COMMENT '手机号',
  `avatar` varchar(150) DEFAULT '' COMMENT '用户头像，相对于uploads/avatar目录',
  `sex` smallint(1) unsigned DEFAULT '0' COMMENT '性别；0：保密，1：男；2：女',
  `birthday` date DEFAULT '0000-00-00' COMMENT '生日',
  `description` varchar(200) DEFAULT '' COMMENT '个人描述',
  `register_ip` varchar(16) DEFAULT '' COMMENT '注册IP',
  `login_num` tinyint(1) unsigned DEFAULT '0' COMMENT '登录次数',
  `last_login_ip` varchar(16) DEFAULT '' COMMENT '最后登录ip',
  `last_login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `activation_auth_sign` varchar(60) DEFAULT '' COMMENT '激活码',
  `url` varchar(100) DEFAULT '' COMMENT '用户个人网站',
  `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户积分',
  `money` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '金额',
  `freeze_money` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '冻结金额，和金币相同换算',
  `pay_pwd` char(32) DEFAULT '' COMMENT '支付密码',
  `reg_from` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '注册来源。1PC端，2WAP端，3微信端，4APP端，5后台添加',
  `reg_method` varchar(30) NOT NULL DEFAULT '' COMMENT '注册方式。wechat,sina,等',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `p_uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '推荐人会员ID',
  `allow_admin` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '允许后台。0不允许，1允许',
  `reg_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '2' COMMENT '用户状态 0：禁用； 1：正常 ；2：待验证',
  PRIMARY KEY (`uid`),
  KEY `idx_username` (`username`),
  KEY `idx_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of yf_users
-- ----------------------------
INSERT INTO `yf_users` VALUES ('1', 'fujuhaofang456', '', '031c9ffc4b280d3e78c750163d07d275', '管理员', 'admin@admin.com', '', 'http://img.eacoomall.com/images/static/assets/img/default-avatar.png', '0', '0000-00-00', '', '', '0', '61.165.167.122', '1531790709', 'ca0ed991446b6a8e9dc77c556e2612b189bba63f', '', '0', '0.00', '0.00', '', '0', '', '0', '0', '1', '1523348441', '1');
INSERT INTO `yf_users` VALUES ('4', 'fujuhaofang789', null, '031c9ffc4b280d3e78c750163d07d275', '妍冰', '', '', '/static/assets/img/avatar-woman.png', '2', null, '承接大型商业演出和传统文化学习班', null, '0', '61.165.167.122', '1531821686', 'b16df19f753d386160e4596334b91e7f9f09dd93', null, '0', '0.00', '0.00', '', '0', '', '0', '0', '1', '1518696015', '1');
INSERT INTO `yf_users` VALUES ('5', 'fujuhaofang258', '', '031c9ffc4b280d3e78c750163d07d275', '运营管理2', '', '', '', '0', '0000-00-00', '', '114.91.76.133', '0', null, '1528186172', 'e0b8f0d2731ffdee7ceb2587af178c1464ca45ff', '', '0', '0.00', '0.00', '', '0', '', '0', '0', '1', '1527680975', '1');
INSERT INTO `yf_users` VALUES ('6', 'fujuhaofang123', '', '031c9ffc4b280d3e78c750163d07d275', 'admin3', '', '', '/uploads/avatar/6/5b0e943bc5342.jpg', '1', '0000-00-00', '', '127.0.0.1', '0', '127.0.0.1', '1531476391', '177b5dd65c2e073095a734b1067e51509f715cc7', '', '0', '0.00', '0.00', '', '0', '', '0', '0', '1', '1527681417', '1');
INSERT INTO `yf_users` VALUES ('7', 'fujuhaofang147', '', '031c9ffc4b280d3e78c750163d07d275', '运营管理1', '361018729@qq.com', '', '', '0', '0000-00-00', '', '116.225.71.51', '0', null, '1530066389', '5577071f11f2fd9b6af5b1f5aade2fdafb5f094f', '', '0', '0.00', '0.00', '', '0', '', '0', '0', '1', '1528350839', '1');
INSERT INTO `yf_users` VALUES ('8', 'UU123456', '', '031c9ffc4b280d3e78c750163d07d275', 'UU23456', '', '', '', '0', '0000-00-00', '', '127.0.0.1', '0', '61.165.167.122', '1531475863', '08ea6bc438757c543dc7f92c1db576a55064a4d9', '', '0', '0.00', '0.00', '', '0', '', '0', '0', '1', '1531469863', '1');
INSERT INTO `yf_users` VALUES ('9', 'ly123456', '', '031c9ffc4b280d3e78c750163d07d275', 'lee', '', '', '', '0', '0000-00-00', '', '116.225.66.166', '0', '116.225.66.166', '1531473834', '69e0cc7cf1a65859aeea724535f31823ad514b17', '', '0', '0.00', '0.00', '', '0', '', '0', '0', '1', '1531469995', '1');
INSERT INTO `yf_users` VALUES ('10', 'wgl123456', '', '031c9ffc4b280d3e78c750163d07d275', 'wgl', '', '', '', '0', '0000-00-00', '', '', '0', '127.0.0.1', '1531797163', 'd0127001807937b501cf5c48825082db240ed969', '', '0', '0.00', '0.00', '', '0', '', '0', '0', '1', '0', '1');

-- ----------------------------
-- Table structure for yf_users_old
-- ----------------------------
DROP TABLE IF EXISTS `yf_users_old`;
CREATE TABLE `yf_users_old` (
  `uid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL DEFAULT '' COMMENT '用户名',
  `number` char(10) DEFAULT '' COMMENT '会员编号',
  `password` char(32) NOT NULL DEFAULT '' COMMENT '登录密码',
  `nickname` varchar(60) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '登录邮箱',
  `mobile` varchar(20) DEFAULT '' COMMENT '手机号',
  `avatar` varchar(150) DEFAULT '' COMMENT '用户头像，相对于uploads/avatar目录',
  `sex` smallint(1) unsigned DEFAULT '0' COMMENT '性别；0：保密，1：男；2：女',
  `birthday` date DEFAULT '0000-00-00' COMMENT '生日',
  `description` varchar(200) DEFAULT '' COMMENT '个人描述',
  `register_ip` varchar(16) DEFAULT '' COMMENT '注册IP',
  `login_num` tinyint(1) unsigned DEFAULT '0' COMMENT '登录次数',
  `last_login_ip` varchar(16) DEFAULT '' COMMENT '最后登录ip',
  `last_login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `activation_auth_sign` varchar(60) DEFAULT '' COMMENT '激活码',
  `url` varchar(100) DEFAULT '' COMMENT '用户个人网站',
  `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户积分',
  `money` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '金额',
  `freeze_money` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '冻结金额，和金币相同换算',
  `pay_pwd` char(32) DEFAULT '' COMMENT '支付密码',
  `reg_from` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '注册来源。1PC端，2WAP端，3微信端，4APP端，5后台添加',
  `reg_method` varchar(30) NOT NULL DEFAULT '' COMMENT '注册方式。wechat,sina,等',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `p_uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '推荐人会员ID',
  `allow_admin` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '允许后台。0不允许，1允许',
  `reg_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '2' COMMENT '用户状态 0：禁用； 1：正常 ；2：待验证',
  PRIMARY KEY (`uid`),
  UNIQUE KEY `uniq_number` (`number`),
  KEY `idx_username` (`username`),
  KEY `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of yf_users_old
-- ----------------------------

-- ----------------------------
-- View structure for yf_action
-- ----------------------------
DROP VIEW IF EXISTS `yf_action`;
