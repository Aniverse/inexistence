# To do list

近期  

* [x] inexistence.sh 启用 --help，解释各参数的作用与用法  
* [x] IPv6 脚本更新  
* [x] 启用 flexget/install  
* [x] 启用 flexget/configure  
* [x] 启用 vnstat/install  
* [x] 启用 transmission/configure  
* [x] 启用 novnc  
* [x] 启用 filebrowser  
* [x] 启用 deluge/configure  
* [ ] 启用 deluge/install，只支持安装 1.3  
* [ ] deluge/install 支持 2.0.3 的 efs deb  
* [x] 清理项目中的不再使用的大文件，缩减项目体积（主要是 deluge plugins）  
* [ ] 清理完以后发布 release，主要是备份和方便以后跨版本对比  
* [ ] 升级 bdinfocli 的版本  
* [x] 各软件的日志链接到一个目录内，方便在 h5ai／FileBrowser 中查看  
* [x] 各软件的配置文件链接到一个目录内，方便在 h5ai／FileBrowser 中查看  

中期  

* [x] 编写 deb-get，从 efs 的软件仓库中下载 deb，并设有 fallback  
* [x] 放弃 Debian 8 支持  
* [x] 移除脚本里的换源、tools、bbr、wine 问题  
* [x] 移除脚本里的 install from ppa. repo  
* [x] 移除 libtorrent 1.0 选项  
* [x] 启用 qbittorrent/install  
* [ ] 启用 flood/install  
* [ ] 启用 flood/configure  
* [ ] 启用 x2go/install  
* [ ] 启用 art/configure  
* [ ] 启用 transmission/install  
* [ ] 支持 Transmission 3.0  
* [x] 新 App：autoremove-torrents  
* [ ] 新 App：Jackett  
* [ ] 新 App：The Lounge  
* [ ] deluge/install 支持 2.0.3 的 building  
* [ ] 支持 python3-libtorrent building  
* [ ] 支持 libtorrent 1.2.x  
* [ ] `hezi` 脚本支持 `hezi install qb 4.2.5` 这样的用法  
* [ ] 补全 changelog，即补完我在使用 git 之前的更新记录  
* [ ] 大幅更新 README  
* [x] 移除升级系统的功能，要升级系统请用 [DieNacht 的脚本](https://github.com/DieNacht/debian-ubuntu-upgrade)  

远期  

* [ ] 支持 Ubuntu 20.04 LTS  
* [x] 使用 pyenv  
* [ ] 使主脚本 inexistence.sh 有完整的中文交互界面  
* [ ] 不使用 rtinst，自己写 rTorrent 与 ruTorrent 的安装  
* [ ] 启用 ftp/install  
* [ ] 启用 nginx/configure  
* [ ] `hezi` 脚本里加入新增用户、删除用户、改用户密码的功能  








# ChangeLog  





## [2020.07.26/08.05/08.09/08.17, 6 commits](https://github.com/Aniverse/inexistence/compare/620e4d3...bd189a8)  

`the inexistence project`  
1. Refactor：[BitTorrentClientCollection](https://github.com/Aniverse/BitTorrentClientCollection) 文件重新上传  
- 清空历史提交记录  
- 移除 deluge.plugins、firmware、miscellaneous，这些都放到了 [inexistence-files](https://github.com/Aniverse/inexistence-files) 内  
- 移除 tcp.cc，直接从 qss 的 repo 里下载  
- 新增 4.20-5.7 的 liquorix 内核（sid／buster 版）  
2. Refactor：[inexistence-files](https://github.com/Aniverse/inexistence-files) 文件重新上传  
- 清空历史提交记录  
- 移除 deb 文件，那些文件可以从 [quickbox-files](https://github.com/amefs/quickbox-files) 下载  
- 加入 ioping、fio、iperf3、smartctl 的静态编译版本  
- 加入一些 patch 文件，如 de 跳校验、老版 rt 支持 ipv6、qbt.webui.table 等  
- 更新 README  
3. Refactor：XanMod 内核的下载移动到 [XanMod-DL](https://github.com/Aniverse/XanMod-DL)  
- 目前有 4.9-5.7 的 XanMod 内核可供下载  

`inexistence 1.2.7.9`  
1. Feature：移除 speedtest-cli 的安装（避免与官方版本冲突）  
2. BugFix：Transmission 的安装使用 deb-get  

`deluge/configure r10011`  
1. Feature：移除 reannounce-0.1-py3.7.egg  

`filebrowser r11014`  
1. Feature：使用最新版 filebrowser release  

`s-alias r12022`  
1. Feature：jieya 支持解压 tar.xz 文件了，并可以选择删除源文件  
2. NewFunction：chaip，使用 ipapi 查 ip  
3. NewFunction：s-debug  
4. BugFix：修复注释了 setcolor 后，HISTTIMEFORMAT 无法显示高亮色彩的问题  





## [2020.07.18-20, 10 commits](https://github.com/Aniverse/inexistence/compare/ee983e3...620e4d3)  

`the inexistence project`  
1. **Codes：彻底删除了项目中的 deluge 插件（commits 历史中也删除了），减少了整个项目的体积**  

`inexistence 1.2.7.7`  
1. UI：系统可以升级时，加入 DieNacht 的升级系统脚本的提示信息  
2. UI：只有当 `lt_version` 存在且不为 RC_1_1 的时候才显示所选择的版本信息  
3. UI：`END_output_url` 输出时去掉结尾多余的空格  

`function r14140`  
1. **BugFix：配置文件和日志的链接从硬链改成了相对路径的软链**  
2. BugFix：修复 END_output_url 中 transmission 链接不包含密码的问题  
3. BugFix：修复 END_output_url 中 rtorrent 和 flood 的失败没有正确输出日志  
4. UI：rtorrent 失败时的两个日志合并上传到 sprunge.us  
5. set_log_when_there_is_none：不再 echo > $HOME/.123.log 的内容  

`s-alias r12019`
1. s-info：支持显示 CPU、内存、硬盘信息，增加网络配置和软件源配置文件的路径显示  

`ask r11041`  
1. BugFix：`create_log_link` 之前先 `export_inexistence_info`  

`xiansu r20003`  
1. BugFix：改进网卡的判断方式  
2. Feature：默认限速速度改为 50Mbps  





## [2020.07.07/15, 4+30 commits](https://github.com/Aniverse/inexistence/compare/5d302b6...3ff4800)  

`the inexistence project`  
1. **Codes：删除系统升级相关的代码**  
2. **NewFeature：将各软件的日志和配置文件链接到一个目录内，方便查看**  
3. **NewFeature：使用 deb-get 下载 QuickBox-Lite 的 deb**  
默认从 GitHub 下载，失败的话则依次从 CF、OSDN、SourceForge 下载，全都失败的话再提示  
4. NewOpts：`--qb-source`  
这个选项强制让 qb 从源码编译安装  
5. ClientScript：`export_inexistence_info` 后做 `check_var_iUser_iPass_iHome` 的检查  
6. ClientScript：`ddee`、`ttrr`、`qqbb` 加入种子文件保存路径提示，`ffgg` 显示第三方插件存放路径  
7. Delete：删除 `python` 脚本，因为已经有 `pyenv` 了  
8. **Delete：删除 `bejietu`、`de2rt`、`deratio2rt`、`password`、`rcloned`、`rtnew`、`rtskip`**  
因为留着也没啥用  
9. **Delete：删除各类配置文件模板、apt 源模板、systemd 文件、deluge 第三方插件**  
因为这些文件在各自软件的配置脚本里都已经包含了，而第三方 deluge 插件会从别处下载  

`inexistence 1.2.7.4`  
1. **Bump version to 1.2.7**  
2. **Codes：删除系统升级相关的代码**  
3. UI：对齐部分之前没对齐的文字  
4. Codes：因为删除了 flood 的 systemd 文件，所以这部分内容在脚本里写入  

`mingling 0.9.5.1`  
1. CodeStyle：完善缩进  
2. SSH_Usage：更新命令，删除不常用命令，`dew` 改为 `dw`  
3. BugFix：修复 deluged@.service 文件是否存在的判断  

`ask r11040`  
1. Selection：删除 qb 4.2.3 选项以及静态编译的选项，4.2.5 改为 deb  
2. Codes：删除各软件的 deb 可用列表变量  
3. Feature：`do_installation` 的 `qbittorrent/install` 增加模式 source  
4. Feature：`create_log_link`、`create_config_link`  
5. **Codes：删除系统升级相关的代码**  

`check-sys r12023`  
1. Feature：更好的网卡判断方式  
2. BugFix：修复检测到内网 IP 以后的 IP 判断逻辑  
3. `#shellcheck disable=SC2068`  

`function r14135`  
1. `_execute`：更好的输出格式  
2. NEW function：`echo_log_only`  
3. `check_var_iUser_iPass_iHome`：将用户是否存在的检查移到第一步  
4. **NEW function：`create_log_link`、`config_link_rename`、`create_config_link`**  
5. **NEW function：`deb-get`**  
6. NEW function：`set_log_when_there_is_none`、`lloogg`  
这两个函数方便在单独 source function 时 debug  

`s-alias r12018`  
1. 去掉 `$eth`  
2. `dew` 改为 `dw`  
3. 改进 `s-log` 逻辑  
4. **加入 `s-info`**  
s-info 可以引入变量和函数，显示 IP 信息、用户名、密码、常用路径（方便 debug 时复制粘贴）  

`qBittorrent/install r12045`  
1. **Feature：使用 `deb-get` 获取可用 deb 版本号，对于支持 deb 的版本，默认使用 deb 安装**  
目前有 4.1.7-4.2.5 的 deb 可供选择  

`FlexGet/configure r10017`  
1. BugFix：修复 `flexget_qbittorrent_mod` 插件没装好的问题  

`ffgg r10005`  
1. Feature：只有在显示帮助信息的时候才去检查 FlexGet 版本，由此加快脚本平时的运行速度  

`ABOUT transmission`  
1. 日志文件重命名为 `transmission.log`  





## [2020.07.03-04, 2+4 commits](https://github.com/Aniverse/inexistence/compare/d2f95a4...fde8a08)  

`inexistence 1.2.6.9`  
1. Feature：使用 apt_sources_replace 代替原先的 wget 下载替换 apt 源列表  
2. Feature：使用 apt_sources_add  

`function r13125`  
1. BugFix：Debian 9 下加密密码的方式不再使用 pbkdf2  
2. LittleFix：get_clients_port 里端口变量名的修改  
3. LittleFix：check_remote_git_repo_branch 的 No such branch! 保存到日志  
4. Feature：APT_UPGRADE 里，为了防止 apt source 实际是空着的情况，使用 `apt policy git` 检查是否有信息  

`Deluge/install r10006`  
1. 完成度大约 70%  

`FlexFet/configure r10016`  
1. Feature：更新 nginx 反代配置  
2. Feature：使用 get_clients_port 获取端口  
3. **Feature：下载第三方插件到 $inexistence_files 内，配置时从这个目录复制插件即可**  
4. **BugFix：修复 flexget_qbittorrent_mod 之前文件没复制完整的问题**  

`FlexFet/install r30024`  
1. BugFix：修复 flexget_qbittorrent_mod 依赖没装的问题  





## [2020.06.29-30, 30+2 commits](https://github.com/Aniverse/inexistence/compare/95bbd7a...d2f95a4)  

`the inexistence project`  
1. **NewFeature：启用配置 Deluge 的子脚本，使 Deluge 切换到用户态**  
2. **NewFeature：引入 pyenv**  
使用 pyenv 来配置 FlexGet 后，不至于影响原先系统的 Python 环境  
3. 更新了 apt.sources 文件的模板（其实用不到了）  
原先 debian 用的是德国的源，现在换到了官方源  

`inexistence 1.2.6.8`  
1. BugFix：修复 OpenVZ 下 atop 安装的判断  
2. Preparation：全部输出都重定向到日志文件，并完善这部分日志的保存  
3. BugFix：进一步完善 apt update 和 安装软件包失败时退出脚本的逻辑  
4. FeatureDropped：删除 config_deluge  

`function r13123`  
1. Typo：_excute → _execute  
2. NEW function：apt_sources_replace  
3. APT_UPGRADE：引入 /tmp/apt_status 作为判断状态的文件，update 失败时强制退出整个脚本  
4. Feature：apt 相关功能的执行结果非 0 的场合都会写入 /tmp/apt_status  
5. **NEW funtions：pyenv_install_python／pyenv_init_venv／python_getpip**  
6. BugFix：修复 tail log 的 read 提示  

`pyenv r20003`  
1. 原先的 python 脚本改成了 pyenv，具体配置功能在 function 里  

`s-alias r12013`  
1. 因为 deluge 切换到了用户态，故更新 alias  

`mingling 0.9.4.7`  
1. 因为 deluge 切换到了用户态，故更新控制菜单  

`Deluge/install r10005`  
1. Codes：更新到现在的风格，删除了大量不用和过时的内容……  
2. Feature：源码来自 git 时，取消 `-dev` 版本号标识  
3. **NewFeature：安装 efs 的 deluge 2.0.3 deb 的模式**  
4. Feature：完善 check_status_de  
5. FeatureDropped：不再支持从 apt/ppa 安装的模式  
6. FeatureDropped：不再支持安装低于 Deluge 1.3.11 的版本（不处理 SSL 问题）  

`Deluge/configure r10010`  
1. Feature：备份的日志文件移动到 $HOME/.config/deluge/logs  
2. BugFix：修复日志备份脚本权限不足、路径不存在的问题  
3. BugFix：修复各类手滑失误  
4. Feature：daemon 端口也写入文件  

`ddee/ddww r10002/10003`
1. BugFix：修复 Deluge 版本号提取不完整的问题  

`FlexFet/install r30023`  
1. **ScriptVersion：v3**  
2. **NewFeature：引入 pyenv 安装 Python 3.7.8**  
3. **NewFeature：顺便安装 AutoRemove-Torrents**  
4. FeatureDropped：不再从 apt/ppa/源码安装 python3  
5. BugFix：进一步修复 FlexGet 是否安装成功的判断  
6. Feature：软链 art 和 FlexGet 到 `/usr/local/bin` 方便使用  

`FlexFet/configure r10013`  
1. ConfigTemplate：更新模板，sequence 里 template 写两个输出实测只会输出到第一个  

`libtorrent-rasterbar r11065`  
1. Feature：切换到从 efs 的 GitHub repo 下载 deb 文件  
2. BugFix：修复可能存在的、在 Debian10 下安装 deb 时提示依赖不满足的情况  

`qBittorrent/install r12041`  
1. Feature：切换到从 efs 的 GitHub repo 下载 deb 文件  

`README 1.4.2`
1. 删除 efs 脚本以及 qq 群的介绍  
2. 去掉了 Installation Guide 开头部分脚本参数的说明  
3. 支持系统里去掉了 Debian 8  

















## [2020.06.24/26/27/28, 11 commits](https://github.com/Aniverse/inexistence/compare/94bedbf...95bbd7a)  

`the inexistence project`  
1. **BugFix：ddee/ddww/ttrr/qqbb/ffgg 等脚本使用 export_inexistence_info 导入信息**  

`function r13113`  
1. NEW Variable：$inexistence_files  
2. NEW function：backup_old_config  
3. BugFix：隐藏 export_inexistence_info 的错误输出  

`ask r11035`  
1. BugFix：之前有 --hostname 的选项但实际不起作用，现在修复了  

`options r10005`  
1. **NewFeature：检测输入的账号、密码的有效性**  
2. UI：Usage 里加入中文介绍的链接  

`mingling 0.9.4.5`  
1. BugFix：修复 showurl 文件路径不对的问题  
2. UI：显示脚本更新日期  

`Deluge/configure r10007`  
1. **NewFeature：每次启动 daemon、webui 前备份之前的日志(systemd StartPre 脚本)**  
2. **NewFeature：下载第三方插件到 $inexistence_files 内，配置时从这个目录复制插件即可**  
3. Feature：写入 nginx 反代配置  
4. Feature：其他基本功能完善  

`qBittorrent/configure r12049`  
1. Feature：使用 backup_old_config function  
2. Debug：写入 systemctl status 信息到日志  

`Transmission/configure r10007`  
1. Feature：使用 backup_old_config function  
2. Feature：写入 nginx 反代配置  
3. Debug：写入 systemctl status 信息到日志  

`FlexFet/install r20018`  
1. Feature：FlexGet 版本不再锁定到 3.0.31，而是安装最新版  
2. BugFix：修复 FlexGet 是否安装成功的判断  

`FlexFet/configure r10013`  
1. Feature：更新配置文件模板，示范站点换成了 CinemaGeddon 和 UHDBits  
2. Feature：写入 nginx 反代配置  
3. Feature：使用 backup_old_config function  





## [2020.06.06/17-19, 7/8 commits](https://github.com/Aniverse/inexistence/compare/c4c0a57...94bedbf)  

`the inexistence project`  
1. **Bump version to 1.2.6**  
2. **BugFix：应该是彻底修复了 2>1 的问题**  
3. 有一些界面调整、变量名修改之类的小改动就不写出来了  

`inexistence 1.2.6.2`  
1. UI：Flood 未选择时不在确认信息处显示 flood 的选项  
2. BugFix：尝试修复某些情况下 LC_ALL 无法设置为 en_US.UTF-8 的问题  
没想到我在 ik 上竟然出现了没有 en_US.UTF-8 的问题，做了点处理，但没测试是否成功修复了  

`function r13111`
1. echo_error2，不保存到日志  
2. NEW function：apt_install_dependencies  
安装依赖专用，失败时强制退出  

`qbittorrent/install r12040`
1. BugFix：修复 Debian 10 使用 3.16.0-4 等老内核时 qbittorrent-nox 找不到 ibQt5Core.so 的问题  
这是一个非常蛋疼的 bug……  
2. BugFix：修复单独使用本脚本安装 qbittorrent 时 libtorrent-rasterbar-dev 没装的问题  
（但我现在发现这个包其实不是依赖……只是编译需要）  

`transmission/install r10004`
1. 初始化  
2. 初步支持编译 Transmission 3.00，未作详细测试  
3. 不再编译 libevent  
4. transmission 的源码选择从 GitHub 的专用仓库里下载 tarball  

`de2rt r11000`
1. 修复 2>1 bug 的时候顺手改了下这个脚本的默认日志文件路径到 /log/script/de2rt.log  

`IPv6 r31218`
1. 同步 aBox 的改动  
2. 主要是修复了 IPIP 失效的问题，改用 IPAPI  





## [2020.0531/0602/0603, 1/24/1 commits](https://github.com/Aniverse/inexistence/compare/eed2a6c...c4c0a57)  

`the inexistence project`  
1. **Bump version to 1.2.5**  
2. **Feature：inexistence.sh / hezi --help**  
3. **Feature：调整了一些 opts，de/rt/qb/tr 不安装的选项从 No 改为 no**  
这个调整的主要目的是让 usage 中的 --no-SOMETHING 显得更加统一  
4. BugFix: check-sys / function / ask 等经常被 source 的脚本，版本号注释掉防止错乱  
5. **Feature：installed.log 和 end.log 移到了 $LogBase 下，且多次安装都写入到同一个文件**  
相应的，alias 也对应做了更新  
6. **Feature：所有配置类脚本都加入了 --force 的命令行参数，默认有配置文件的情况下就跳过配置**  

`ask r11034`
1. 去除了 `[[ -z $just_upgrade ]]` 的情形  
2. do_installation 第一步 mkdir -p $LogLocation  
3. 预留了 `$force_recover`  

`check-sys r12019`
1. 修复 nvme 硬盘型号可能提取到多余字符的问题  

`function r13108`
1. 去掉了 function 的 getopt（同样可能引起其他脚本 source 后出错）  

`s-alias r12012`
1. **从原先的 cat 写入改为可以直接 source 的版本**  
2. 变量只保留 $iUser，网卡、日志位置、是否写入 bashrc 等变量移除  
3. 好处①：是从 s-alias 复制粘贴更方便、更改更直观  
4. 好处②：方便更新 alias，每次直接 git pull 覆盖掉，然后 sed 替换 iUser 即可  
5. 备注：LogBase 变量取消掉是因为 s-end 和 s-opt 都是从固定的一个文件读取了  

`options r10003`
1. 这个脚本是从 inexistence 中原来 opts 处理部分中提取出来的，方便 hezi 脚本调用  
2. 增加了 usage，且针对 hezi 和 inexistence 使用的场景，内容会有所不同  

`hezi r11017`
1. 去掉了 just_upgrade 变量  
2. 加入 usage  
3. **buchong：支持使用 inexistence 的 opts（实际上两个脚本公用 opts）**  
4. **gengxin：初步的更新脚本功能**  
alias 和脚本权限会重新设置。由于采用了软链因此 /usr/local/bin/ 下的文件就不需要动了  

`deluge/configure r10005`
1. 加入了各类 conf 的写入  
2. 加入了插件下载的 function  

`qbittorrent/install r12038`
1. 修正 $version_s 的赋值  
2. 统一使用 echo_error_exit  

`README 1.4.1`
1. 更新 opts  





## [2020.05.12/13/23/27](https://github.com/Aniverse/inexistence/compare/7ba4632...33ef6a6)  

`inexistence 1.2.4.8`  
1. BugFix：修复 s-opt 中没有 MaxDisk 变量的问题  

`ask r11030`
1. 移除 qBittorrent 4.2.4 选项  
2. 新增 qBittorrent 4.2.5 (static, libtorrent 1.2) 选项  
3. 移除 Deluge 1.3.9/13/14 选项  
4. Deluge 2.0.3 only for test 的提示改为 Python 2.7  

`function r13104`
1. NEW function: check_var_iUser_iPass_iHome  
中间还修复了一次判断，现在检测 iHome 的方式应该靠谱了  
2. BugFix：增加 tweaks_enabled 的变量  
这个是为了修复 mingling 的 bug  

`qbittorrent/configure r12046`
1. 使用 check_var_iUser_iPass_iHome  

`qbittorrent/install r12035`
1. Feature：移除 qb 4.2.4 static，加入 4.2.5.12 static  
2. **Feature：从 GitHub release 下载 qbittorrent-nox static-build**  
SourceForge 有时候下载速度实在是堪忧，虽然现在 GitHub 也不是很稳，但 GitHub 的正常运转是整个脚本能正常运作的基础，要是 GitHub 都挂了那脚本功能出问题是非常正常的  
3. UI：从静态编译安装时，安装时的提示文字中去掉 from  

`deluge/configure r10003`
1. 同步近期代码变动，大改以后再说  

`README 1.3.9`
1. References：Special thanks to [efs](https://github.com/amefs) and [DieNacht](https://github.com/DieNacht)  
2. References：移除了一些已经不用的东西，比如 vcs 和 unrarall 脚本  
3. References：移除了一些官网教程的链接  
4. References：新增了近期集成的一些东西的链接，以及参考资料  

`ChangeLOG 1.1.0`  
1. 近期的 changelog 里都包含了 comparison 的链接  
2. to do list 从 README 移到了 ChangeLOG  





## [2020.04.24/25/27/30, 2020.05.02/09/10](https://github.com/Aniverse/inexistence/compare/9aaaa80...7ba4632)  

`inexistence 1.2.4.7`  
1. BugFix：修复一些手滑的地方  
2. 安装 deluge 2.0.3 依赖时指定使用 pip2  
现在默认 pip 使用 pip3 了，此外 de2.0 的安装似乎存在问题，以后再修  

`ask r11029`
1. 移除 qBittorrent 4.2.4 (with lt 1.2) 选项  
2. 新增 qBittorrent 4.2.5 (compile) 选项  

`function r13101`
1. NEW function: check_if_succeed  
2. UI：增加 filebrowser 出错时的输出  

`filebrowser r11012`
1. check_if_succeed 来判断 AppTest 是否成功    
2. BugFix：修复 /fb 反代跳转到 /filebrowser/ 的问题  

`libtorrent-rasterbar r11064`
1. UI：移动 install_base fpm 的位置  

`qbittorrent/install r12033`
1. Merge PR from DieNacht，修复模式判断的问题  

`guazai r11001`
1. 使用 `ro` (read-only) 挂载参数  

`README 1.3.8`
1. 更新了 filebrowser 启用 root 版的说明（之前忘了加 --now）  





## [2020.04.22/23, 1+28 commits](https://github.com/Aniverse/inexistence/compare/0e326d7...14f4f5d)  

`the inexistence project`  
1. **Bump version to 1.2.4**  
2. **Feature：放弃 Debian 8 支持**  
仍然可以用 `-s` 跳过检查来使用，基本功能还是没问题的，针对 Debian 8 的特殊处理的代码也仍然保留  
3. Feature：增加 qb 4.2.4  
4. BugFix：fix pattern full match  
5. deb_available 列表从 function 移到了 ask  
6. ask_username 等账号密码相关 function 从 ask 移到了 function  

`inexistence 1.2.4.6`  
1. Feature：export LogLocation=$LogTimes/log（原来是 $LogTimes/install）  
2. Codes：调整 if_need_lt 的位置  
3. SystemTwaeks：非 ext4 分区不释放保留空间，同时排除 MaxDisk 的检测上 grep -v overlay  
4. BugFix：修复 SystemTwaeks 日志保存位置不对的问题  
5. UI：输出最终结果前不做 clear  
6. Feature：加入 `--domain` 可以指定域名，并用 acme.sh 来签证书（安装 rTorrent 才有）  
7. BugFix：软链接一些路径的时候，输出也扔到 $OutputLOG  

`function r13098`
1. **NEW function app_manager**  
Usage: app_manager qbittorrent configure -u someone -p teleph0ne -w 7451 -i 9152  
2. Feature：app_manager 和 install_base 执行结束后会恢复原先的 /tmp/current.logfile  
3. BugFix：修复用户名对 reserved_names 的判断  
4. Feature：if_reverse 启用反代前会先检查 nginx 的运行状态  
5. Feature：启用 FlexGet 的反代  
6. Feature：output_url 可以输出先前指定的域名  
7. BugFix：修复部分软件日志路径错误的问题  

`ask r11028`
1. Feature：移除 tr 2.84/2.92 选项  
2. Feature：增加 qb 4.2.4，编译和静态模式两种选项，并提供 lt 1.2.6 版  
3. BugFix：修复 FileBrowser 没指定用户名和密码的问题  

`alias r11010`
1. BugFix：s-log，使用 function 代替 alias  

`filebrowser r11009`
1. 多用户支持，单用户挂载 /home/username 路径  
2. 有个 root 运行挂载 / 目录的 fb，这个 fb 默认不启用  
3. 默认账号密码为脚本设定的账号密码，而不再是 `admin`  
4. 是否在运行的检测方式更加严格，检测对应用户  
5. 修复是否在运行检测出错的问题  
6. 加入 `-u` 和 `-p` 参数  

`qbittorrent/install r12033`
1. BugFix：修复 install fpm 时因为多输出一行导致交互界面错乱的问题  
2. Feature：静态编译加上 4.2.4 和 4.2.4.12 (libtorrent 1.2 ver)  
3. BugFix：修复安装模式判断可能出错的问题  

`qbittorrent/configure r12045`
1. write_qbittorrent_nginx_reverse_proxy  
2. 部分内容 function 化  

`README 1.3.7`
1. 支持系统里去掉了 Debian 8，提示不支持 20.04  
2. 更新 to do list 的完成情况  
3. 更新了 filebrowser 的说明  





## 2020.04.21

`the inexistence project`  
1. lock 位置改成了 /log/inexistence/.lock，即隐藏了这个文件夹  

`npm r10000`  
1. 初始化  

`function r13088`
1. function loggg  
这个主要是自己单独测试某一部分 debug 时用的，与 write_current_logfile 稍有区别  
2. $LockLocation → $LOCKLocation  





## [2020.04.18/19, 5+44 commits](https://github.com/Aniverse/inexistence/compare/6a9dd59...10ba81b)  

`the inexistence project`  
直接总结下比较大的几点改动：  
1. hezi 脚本加入。这个脚本的使用场景是，安装完 inexistence 后，想补充安装之前没安装的软件，或者对 de/qb/tr/rt 进行升级/降级操作，就可以使用这个脚本而不至于重新跑一次 inexistence。这个也比使用单独的命令方便一些。目前的实现比较简单，交互与 inexistence 没什么区别，以后会往 QuickBox 和 swizzin 的 box 脚本方向靠拢  
2. 终于干掉了 ask_lt  
3. UI 方面，终于把各种安装时的输出隐藏掉了，看上去清爽不少  
4. Transmission 转为用户态运行，alias 和 mingling 也对应更新了  
5. inexistence 从 1580 行左右砍到了 950 行不到，mingling 也砍了 200 行  

`inexistence 1.2.3.10`  
1. **Bump version to 1.2.2**  
2. **Bump version to 1.2.3**  
3. **UI：不再询问 lt 版本，统一使用 lt 1.1.14**  
命令行参数指定的方式仍然可用  
4. **Feature：preparation 去掉 build-essential 和 python/pip 的安装**  
加速脚本安装  
5. **Codes：简化代码**  
又有一堆 functions 移到了 ask 和 function 内，大致的在下面有写  
6. **Codes：增加缩进**  
现在所有 function 都有缩进了  
7. UI：确认信息界面，修复 lt 和 bbr 是否显示的判断逻辑  
8. **Feature：preparation 部分引入了 APT_UPGRADE_SINGLE=1 APT_UPGRADE 与 apt_install_together & spinner $!**  
9. Other：installed.log 格式修改，因为空格长度还是不太好控制  
10. **Feature：盒子信息单独放到 info 目录，记录 ip 地址、asn 等用于后续判断**  
11. Codes：移除 Deluge 和 Transmission 从 repo 和 PPA 安装的代码  
12. UI：去掉了一堆 INSTALLATION-COMPLETED  
13. Codes：因为启用了 tr/conf ，所以删除了 config_transmission  
14. Feature：bionic 下不再编译 wget  
考虑整个 deb，或者干脆 static，或者直接编译好的 wget 替换说不定都可以？  
15. **UI：隐藏一切不必要的输出（>> "OutputLOG" 2>&1）**  
16. **UI：script_end 部分重写，重写的部分在 function 内**  
17. if_ask_lt=0 改为 if_need_lt=0  
18. **Codes：执行安装的部分改为 do_installation 并移到了 ask 内**  
19. 现在一堆功能都移到了 function、ask、各类 install/configure 里，inexistence 的行数会越来越少  

`ask r11021`
1. function set_language、ask_reboot、_input_version  
2. **删除 function ask_libtorrent**  
3. 修复 qb 安装 4.1.9/4.2.3 模式只能是 deb 的问题  
4. 修复对客户端是否已安装的判断  
5. **移除 deluge PPA 和 repo 的选项**  
6. ask_wine_mono 独立成 ask_wine 和 ask_mono  
7. function **do_installation**   
8. **整个安装过程中隐藏所有非必要输出**  
9. 使用 write_current_logfile 方便查看传统 function 的实时日志  
10. DEPRECATED 部分加入 version_check_latest_and_repo  
因为不使用 PPA 和 repo 了，所以其实版本检查显得没必要了  
11. 升级系统部分的代码暂时移了进来，等新版完成后移除  
12. 移除 FlexGet 提示与 qBittorrent 4.2 不兼容的提示  

`function r13085`
1. apt_sources_add
Debian 8 下添加源，其他 Debian 系统如果缺少 backports 也会补上  
2. apt_sources_add 已被添加到 APT_UPGRADE 内  
3. APT_UPGRADE_check：如果今天没跑过 apt update，那就在检查软件包之前先跑一次 update，同时生成当日的 lock  
4. apt_install_check 前加入 APT_UPGRADE_check  
这是综合考虑降低出错率和节省时间的方案  
5. write_current_logfile 配合传统安装 function 使用  
6. swap_on、swap_off、_time 引入  
7. **NEW：hezi_add_user**  
现在会记录账号和密码。密码的加密方式照抄 QuickBox-Lite  
8. **NEW：export_inexistence_info**  
用于检查安装信息，包括 ASN、IP 地址、用户名和密码的提取，用于后续安装  
9. if_running、check_install 引入  
主要是配合 hezi 使用，此外 check_install 也加入了 vnstat dashboard 之类的检测（通过 lock 文件判断）    
10. **NEW：END_output_url**  
使用 functions 以及 printf 大幅简化了之前的安装结果、访问链接输出，同时检测方式一部分也改为了 lock 检测，这样子也方便以后调用  
11. **NEW：show_uploaded_log**  
所有出错的日志都上传到 sprunge.us  
12. get_clients_port 和 get_clients_version 功能分离  

`hezi r11006`
1. 初始化  
2. 各种 bug fix，以及功能改进。具体 feature 见上文  
3. 没检测到 inexistence 设定的账号密码时也可以手动录入。从代码来看这个脚本大概是可以独立于 inexistence 使用的，不过我也还没测试过  

`check-sys r12017`
1. 部分缩进对齐  
2. 修复 isInternalIpAddress  

`mingling 0.9.4.4`
1. **引入 source function/check-sys，大幅简化代码**  
删了几百行，舒服多了。不过还是很乱  
2. 删了一些不用的注释和老旧的代码，进一步简化代码  
3. 缩进改正  
4. 配合 tr 用户态的改变，修改对应命令  
5. _client_version_check 里重新启用 flexget 和 irssi，这个以后还要重写  
6. 简化 if_running_check  

`alias r11008`
1. 加入 lines、$local_script、s-log  
2. tr 转为用户态的配套修改  

`python r10001`
1. 初始化  
2. 这个就是从 flexget 安装脚本里抽出来的  
3. 以后会改为 pyenv 的方式，这个以后再改。目前 pyenv 的安装代码是写了但是没启用  

`flexget/install`
1. 忘记改版本号了 orz  
2. 抽出 python3 安装部分成独立脚本，拿来调用  

`qbittorrent/install r12030`
1. dl_qbittorrent_alt_webui 加入  
unzip 如果没有的话从这里加上更合理  
2. AltWebUI 路径改为 /opt/qBittorrent/WebUI  
因为没必要每个用户都有单独的第三方 WebUI，有一份就行了  
3. install_qbittorrent_dependencies 启用备注是的依赖部分  

`qbittorrent/configure r12043`
1. dl_qbittorrent_alt_webui 移到了 qbittorrent/install  
2. 配置文件里 AltWebUI 路径对应变更  

`vnstat/install r10004`
1. 如果能访问 vnstat dashboard 那就生成一个 lock 文件用于后续判断  

`libtorrent-rasterbar r10062`
1. lt 1.0.11 无法在 buster 和 focal 下安装，增加 focal  
2. 加入 python3-libtorrent 包的安装  
3. **安装 efs 的 deb 时不安装编译依赖**  
缩短安装时间  

`README 1.3.5`
1. 开头的 Notes 部分，补充了一些内容，如只支持 amd64 的说明，以及推荐使用的系统  
2. 客户端安装选项这一栏删除  
3. libtorrent-rasterbar 因为变为隐藏项目了所以说明放后边，内容也重写了  
4. bbr 的说明也因为变为隐藏项所以放到了后边  
5. tweaks 部分说明保留空间的释放调整到了 1%，同时取消 wget 在 bionic 上的编译  





## 2020.04.12/13/15/17

`inexistence 1.2.1.6`  
1. **UI：隐藏选项，如 rclone 那些，如果没选就不在确认页面里出现**  
不然就会有人来问为什么没有选项  

`Aniverse/rtinst`
1. 尝试修复 pip 安装 cfscrape cloudscraper 的问题  

`function r12069`
1. check_var_OutputLOG，总是写入当前日志文件到 /tmp/current.logfile  
2. APT_UPGRADE 时，如果没有日志路径那就输出到 /dev/null  
3. 修复 apt_install_together  
之前一直没试过，这次试了下才发现有问题，需要 eval 处理下  

`filebrowser r10002`
1. 修复手滑带来的 bug  

`docker r11002`
1. **不再使用官方脚本安装，并安装 containerd.io**  

`README 1.3.3`
1. 更新上次忘记更新的脚本参数  
2. 补充说明 filebrowser 的账号密码都是 admin  
3. tweaks 上补充调整项目 - 释放保留空间  
这个很早就有了只是忘记写上去了  
4. tweaks 上补充说明 vnstat dashboard 的限定条件  
5. 说明目前只有 tr 保留了 repo/ppa 安装模式

`xiansu r20002`
1. 修复手滑带来的 bug  





## [2020.04.11, 43 commits](https://github.com/Aniverse/inexistence/compare/a9a8da1...0ca4d67)  

`inexistence 1.2.1.5`  
1. **Bump version to 1.2.0**  
1.1.0 到 1.2.0 差不多 1 年了……  
2. **Bump version to 1.2.1**  
一天连更两个版本号……  
3. **Feature：更新命令行参数**  
如 `--flexget-yes` 改为 `--flexget`，`--flood-no` 改为 `--no-flood`  
4. **Feature：rclone、rdp、tools、wine、mono 不再提问是否安装**  
仅能通过参数指定来安装，如 `--x2go`，取消了 `--rclone-no` 之类的参数    
5. **Codes：ask 类的问题移到 ask 脚本中**  
这一个操作大概让主脚本少了 700 行代码  
6. Codes：大量原先 function 里没缩进的地方，加上缩进  
7. Feature：去掉 qbittorrent_dev 变量  
8. Feature：IP 地址的检查部分移入 `check-sys`  
9. Feature：wine 和 mono 的安装和提问都独立开来  
10. Feature：去掉了 step one 里一些非必要包的安装  
11. **Feature：去掉了 step one 里安装 fpm 的步骤**  
12. **Feature：step one 里安装 NConvert 的步骤移到了 tools 部分**  
13. BugFix：更新 installed.log 里的信息  
14. BugFix：更新 BDinfoCLI 的安装路径  
15. Codes：删除 install_qbittorrent，全面使用子脚本  
16. BugFix：修复一些 `2>&1` 写成了 `2>1` 的问题  
17. UI：结尾处加入 FileBrowser 的链接  
18. UI：一些没必要的情况下不询问 libtorrent 版本  
19. UI：加入 filebrowser 是否安装的询问  
20. Feature：安装 libtorrent-rasterbar 时使用当前的 logbase  
21. Codes：删除了一些用不到的注释  

`Aniverse/rtinst`
1. 修复 rar 下载链接  
2. 更改 rarlinux 的安装路径  

`check-sys r12016`
1. hardware_check1 里加入更多的信息监测  
2. 加入 check_tcp_acc，支持监测锐速  
3. redact_ip 阻挡最后两位 IP  
4. 使用 ip 的命令，使用 2>&1 解决找不到命令的错误输出  
5. 加入 seedbox_check、seedbox_neighbors_check  
6. 加入 disk_check_smart、disk_check_raid、disk_check_no_root、  
7. 加入 deprecated_disk_check  
一堆都是从 abench 里来的功能。abench、inexistence、iferal、mingling 很多东西是互通的  

`ask r10006`
1. **初始化**  
2. **加入 filebrowser**  
3. fix ask_lt issue  
4. ask_rtorrent 里的变量使用 local  
5. **qBittorrent 默认选项改为 4.2.3 static，并去除编译选项**  
编译在指定版本时仍然可用  

`function r12067`
1. 加入 lt/de/qb/rt/tr 可用的 deb 版本列表变量  
2. 加入 echo_doing  
3. NEW function generate_status_lock  
进一步简化子脚本里的重复内容，不过之前的就懒得改了  
4. NEW function install_base  
5. NEW function _confirmation、validate_username    
来自主脚本  

`libtorrent-rasterbar r10062`
1. **路径变化，不放在文件夹里了**  
2. 使用 `install_base fpm` 来安装 fpm  

`qbittorrent/install r12028`
1. 使用 `install_base fpm` 来安装 fpm  

`docker r10000`
1. **初始化**  
2. 目前使用的是官方脚本来安装，所以其实就是一行的事情……  

`filebrowser r10001`
1. **初始化**  
2. 目前无法修改密码，默认账号密码都是 admin   
3. 使用的是灯大的 Docker 增强版，没有原版的计划  

`fpm r10001`
1. **初始化**  

`README 1.3.1`
1. 更新脚本参数的说明  
2. 那些隐藏选项的说明移动到了后边  
3. 增加 FileBrowser 的描述  
4. Some additional tools 的描述里移除了 mktorrent 和 bdinfocli  
因为这两个现在在脚本第一步就会安装  





## 2020.04.06/07

`inexistence 1.1.9.8`  
1. **NewFeature：使用独立脚本安装 qbittorrent**  
2. **Feature：移除 qbittorrent 的 ppa 和 repo 安装模式**  
3. Feature：加入 `--qb-static` 选项  
4. Feature：加入 `--quick` 选项  
目前区别就是不编绎 wget 和 vnstat，以后再改  
5. Feature：更换 tr 的下载链接到 GitHub  
6. Feature：s-opt 信息中不显示用户名，改为显示 Home 目录下的目录数量  
7. Codes：调整部分缩进  
8. **Codes：使用脚本 check-sys 简化代码**  

`Aniverse/rtinst`
1. 修复 rarlinux 的下载链接  

`function r12061`
1. Add stop_app and restart_app  
装软件前停止现有进程，装完后重启  
2. Fix Unnecessary output when add_local_script_to_PATH  

`check-sys r11008`
1. 加入 check-virt  
2. 加入 IP、硬件检查等大量 function  
从 aBench 和 inexistence 引入的，减少重复代码和维护量  

`libtorrent-rasterbar/install r11061`
1. 更换 lt 1.1.14 的下载链接到 GitHub  

`qbittorrent/install r12027`
1. 加入 install_qb_deb  
2. 加入 install_qb_static  
3. 加入 install_qt_deb_efs  
4. 装之前 stop app，装完后 restart app  

`qbittorrent/configure r12041`
1. 同时往配置文件里添加 4.2 和 4.1 的密码配置，提高兼容性  
经测试同时写两个没啥负面影响，好处是升级或者降级的时候不用重新配置密码了  





## 2020.04.03/05

`inexistence 1.1.9.1`  
1. Feature：qBittorrent 4.2.2 的选项换为 4.2.3  

`function r12058`
1. add_local_script_to_PATH  

`flexget/configure r10009`
1. FlexGet 第三方插件之前忘记扔到 plugins 目录里了  

`qbittorrent/configure r12040`
1. wget qqbb when local doesn't exist
2. wget -nv  
3. [[ $(command -v unzip) ]] && dl_qbittorrent_alt_webui  
4. add_local_script_to_PATH  

`qbittorrent/install r12023`
1. 从 separate-script 分支加进来  
2. 同步最近 master 分支的整体风格改动  
3. 抛弃 apt 与 ppa 模式，代码仍保留  
4. 更新 set_qt_dev  
5. Debian 8 下用回 qt 5.5.1  





## 2020.03.30

`qbittorrent/configure r12037`
1. 加入两个第三方 WebUI，默认不启用  
可以实现 RSS、批量替换 tracker（虽然我用起来有 bug……）  





## 2020.03.29

`the inexistence project`  
1. bdinfo、guazai、jietu、zuozhong 四个子脚本更新，避免使用 /etc/inexistence 路径  
现在路径全在 /log 下，具体是 screenshots、torrents、bdinfo  

`Aniverse/bluray`
1. 避免使用 /etc/inexistence 路径  
现在挂载和提取的路径全在 /bluray 下，具体有 mount、extract、tmp  
输出文件保存在 /log/bluray  

`Aniverse/rtinst`
1. 修复 ffmpeg 的下载链接  
2. 修复 rarlinux 的下载链接  
3. 修复 GeoIP2 缺少 php 模块 bcmath 的问题（可能有些系统还是有问题，懒得管了）  
4. 修复 autodl-irssi 下载链接失效的问题  
5. 更新 README  

`inexistence 1.1.9.0`  
1. **Bump version to 1.1.9**  
终于干掉了 /etc/inexistence 下的一堆文件夹……  
2. Feature：/etc/inexistence 的 02-09 文件夹全删了，部分移动到 /log 下  
为以后更新脚本做准备  
3. Feature：创建 /log 到 h5ai 的软链接  
4. Feature：下载 qBt 源码时 --depth=1，也因此放弃了 3.3.17 和 4.1.2 的 cherry-pick  
5. Feature：uptools 检测到 ffmpeg 后不再做重复的安装  

`novnc/configure r12011`
1. 启用 iptables 规则，增强安全性  

`ipv6 r31215`
1. Sync from upstream  
2. **修复 Online dibbler 在 Ubuntu 18.04 下的问题**  
3. netplan apply 后 sleep 5，防止 DNS 解析还没更上  
4. dibbler 和 odhcp6c 在检测到没安装的情况下才编译安装  
5. cleanup 里无论 type 都清除 netplan 的配置，并加上 dibbler 的配置清除  
6. info 上加入更多的输出信息，以及分隔符  
7. **修复 ikoula Ubuntu 18.04 配置文件手滑写错了的问题**  





## 2020.03.25/26

`inexistence 1.1.8.10`  
1. Feature：加入 qBittorrent 4.2.2 的选项  
2. Feature：自动检测 RC_1_2 分支的版本号  
3. Feature：编译 qbt 4.2 w/ lt 1.2 时，启用 `CXXFLAGS="-std=c++14"`  
4. sihuo：更新 qBittorrent 4.2.2 的 tables patch  

`libtorrent-rasterbar/install r11060`
1. 编译 lt 1.2 时，启用 `CXXFLAGS="-std=c++14"`  

`flexget/install r20015`
1. Debian 8/9 装完 FlexGet 后，Python3 版本切换回系统自带的版本  

`flexget/configure r10008`
1. 加入 [flexget_qbittorrent_mod](https://github.com/IvonWei/flexget_qbittorrent_mod) 和 [flexget-nexusphp](https://github.com/Juszoe/flexget-nexusphp)  

`xiansu r20001`
1. 更新代码风格  
2. 更新网卡判断方式  





## 2020.03.20/22

`inexistence 1.1.8.7`  
1. Feature：移除 transmission 的隐藏选项，包括 --tr-skip  

`check-sys r10004`
1. **加入 Alpine Linux 的初步支持**  

`README 1.3.0`
1. 更新 novnc 部分描述  
2. 提示 transmission 修改版已被移除  
3. 更新 FlexGet 的描述  
4. 更新 gclone 的描述  
5. 系统设置出增加 vnstat 和 wget 的编译说明  
6. 部分代码块加入 shell 语言的标注  





## 2020.03.15-18

`the inexistence project`  
1. 重命名 $local_package 为 $local_packages  
2. 清空了 [BittorrentClientCollection](https://github.com/Aniverse/BitTorrentClientCollection) 的 commits 历史，并重新整理文件上传  

`Aniverse/rtinst`
1. 反代文件的配置路径从 /etc/nginx/snippets 移动到了  /etc/nginx/apps  
2. nginx 的配置文件中 include apps/*;  

`inexistence 1.1.8.6`  
1. **Feature：启用 novnc，删除旧的 vnc 代码**  
2. **UI：输出 novnc web 地址**  
3. UI：增加 novnc 安装出错时的日志提示  
4. Simple：更新部分下载链接  

`function r12057`
1. **Bump version to r12000**  
2. Add `read pause` to `cat_outputlog`  
3. 增加变量 $tmp_dir  
4. **增加无 root 模式（共享盒子用）**  
5. 更新系统判断方式  

`check-sys r10004`
1. **初始化**  
2. 启用 `check_pm` 与 `check_release`  
3. 更新、修复 `pm_action`  
4. 使用 `detectOs` 代替 `check_release`  

`qbittorrent/configure r12035`
1. 加入 --shared（功能未完成）  
2. 加入 `$systemctl_user_flag`  
3. 使用 `command -v` 代替 `which`  
因为 which 在某些系统下有输出  
4. 使用 `--no-check-certificate`  
主要是为了适配 qbnox-static 的脚本，可能最小化安装完就直接跑脚本了  

`novnc/install r10006`
1. 增加安装 expect xserver-xorg-legacy x11-xserver-utils 包  
2. 增加安装 xserver-xorg 包  
3. 增加安装 python 包  
4. 增加安装 git 包  

`novnc/configure r12010`
1. `--root` 可以启用 root 用户的 novnc  
2. 顺应 rtinst 的修改，修改反代配置文件的路径  
3. **支持多用户**，端口号自动往下 +1  
4. 修改检测成功与否的方式回 systemctl is-active  





## 2020.03.13-14

`inexistence 1.1.8.1`  
1. **Bump version to 1.1.8**  
最大的更新是终于弄完了 novnc，这个测试了太久了  
2. BugFix：修复 sihuo，增加了 qb 4.2.1 的 sihuo 版本  
3. Simple：deluge wget 参数加上 -nv -N  
4. **NewFeature：novnc 的安装会在 `--separate` 时启用**  
5. **NewFeature：Ubuntu 18.04 在 tweaks 这一步编译 wget 1.20.3**  
因为系统自带的 wget 有 bug，wget -qO- 仍然会有输出，干脆自己编译更新的 wget 解决  

`function r11052`
1. 加入变量 LogRootPath  
2. some_info  
3. mkdir -p $PortLocation  
4. `_excute` function 现在会输出命令内容  
5. `get_clients_port` 写成指定变量的形式  

`alias r11005`
1. 加入几个新的 function，从 QuickBox 那抄来的  
2. 修复 HISTTIMEFORMAT  

`novnc/install r10002`
1. 增加安装 dbus-x11 xfonts-base xinit 包  
2. 增加安装 unzip 包  

`novnc/configure r10004`
1. **初始化**  
2. 修复 `netfilter-persistent save`  
3. 反复测试 systemd 的写法……  
4. 修复判断是否成功的方式  
5. 不再使用 iptables 阻止外部直接连接  

`deluge/configure r10002`
1. 同步代码风格……  

`ddee r10000`
1. **初始化**  

`ddww r10000`
1. **初始化**  

`README 1.2.7`
1. 手滑修复  
2. 更新 to do list   





## 2020.03.10-12

`inexistence 1.1.7.7`  
1. Feature：Debian 8 强制添加 snapshot 源，无论选项  
2. BugFix：去掉 qb 安装失败时 sprunge.us 网址前显示的 cat  
3. BugFix：更新网卡判断方式  
4. **UI：安装 vnstat dashboard 后，网址输出在最后的结果中**  

`flexget/install r20013`
- 在 Debian 8 下检查 libssl 1.0.2 是否成功安装  

`vnstat/install r10003`
1. 加入 -i，指定网卡  
2. 修改 vnstat 默认监控的网卡  

`alias r11004`
1. 加入不少新的 function，从 QuickBox 那抄来的  
2. Disable mail check/warning  
3. 修复 history 格式缺少颜色的问题  
4. 更新 this_is_for_copy  

`novnc/install r10001`
1. **初始化**  
2. 隐藏生成证书的输出  





## 2020.03.09

`the inexistence project`  
- 去除 qbittorrent systemd 里的 `TimeoutSec=300`  

`inexistence 1.1.7.1`  
- BugFix：修复 Flexget 安装报错时的输出，使用了 `sprunge.us`  

`flexget/install r20012`  
1. BugFix：锁定 setuptools 版本到 45.0.0，以解决装不上 flexget 的问题  
2. UI：Python 和 FlexGet 之间增加一段空白，方便找日志……  

`ipv6 r31208`
- **增加 LeaseWeb 支持**  





## 2020.03.07

`inexistence 1.1.7.0`  
1. **Bump version to 1.1.7**  
主脚本是没什么改的，别的东西有些改动也可以升下版本号是吧……  
2. Simple：安装 qt5 依赖的时候显示输出  
3. codes style update  
就是加了些缩进  

`README 1.2.6`
1. 加了个简化版的真·一键命令  
2. 更新 to do list 进度  





## 2020.03.06

`the inexistence project`  
- configure 子脚本全都写入端口到文件，以及启用端口可用性检查  

`function r11049`  
1. NewFunction：PortCheck  
2. New Global Variable：PortLocation  
3. 去掉了三种 echo 提示的下划线  

`qbittorrent/configure r12030`
1. **写入默认的高级参数到 qBittorrent.conf**  
2. **设置监控目录**  

`ttrr r10000`  
- **初始化**  





## 2020.03.05

`inexistence 1.1.6.2`  
1. **Bump version to 1.1.6**  
最近版本号会升得比较快……  
2. BugFix：修复 abox PATH 问题  
3.  **New Feature：启用 `vnstat/install`，带来了 vnstat 网页前端**  
4. Codes：Transmission 加强版 WebUI 的步骤移到 install 部分  
5. **New Feature：可以用 `--separate` 启用 `transmission/configure`，带来了 tr 用户态**  

`function r10047`  
- 增加新的全局变量 web_root，web_rutorrent  

`mingling 0.9.3.6`  
- 修复 flexget systemd 检测 (root → user)  
也是服了，写 ChangeLog 的时候才发现下午更新的时候又手滑了，赶快改了下  

`wine/install r10006`
- 修复 Ubuntu 18.04/Debian 10 缺少依赖的问题  

`vnstat/install r10002`
1. 初始化  
2. 编译安装最新版 vnstat  
3. 在装了 ruTorrent 的情况下（即有 nginx），再安装 vnstat dashboard (脚本内 Debian 8 不支持)  
Debian 8 可以考虑用 docker run  

`qbittorrent/configure r11026`
1. 全部操作的输出都会转存到日志文件  
2. 其他各种小问题修复和细节调整  

`transmission/configure r10001`
1. 初始化  
2. 全部操作的输出都会转存到日志文件  





## 2020.03.03-04

`inexistence 1.1.5.6`  
1. New Feature：写入 IP 地址到 `$LogBase/serverip`  
2. **New Feature：使用软链的方式导入 mingling 等脚本到 /usr/local/bin/abox 这个新 PATH 内**  
很遗憾地搞出了 bug，第二天修了  

`alias r11003`  
- 修复 flexget alias (root → user)  

`function r10045`  
- 增加新的全局变量 LogBase，LOCKLocation，local_package，local_script  

`mingling 0.9.3.4`  
- 修复 flexget 相关功能 (root → user)  

`qqbb r10003`  
1. 重命名为 qqbb  
2. show_usage 里增加了配置文件路径、网址、端口等信息  
3.  show_usage 里增加了本脚本的版本信息和 App 的版本信息  

`ffgg r10001`  
- 初始化，与 qqbb 同步更新  

`flexget/install r20009`  
1. 为 Ubuntu 16.04 加上 python3.6-gdbm（修复 command not found 时 py3 的报错）  
2. 创建 ffgg 的软链  





## 2020.03.02

`the inexistence project`  
1. 子脚本更新使用 `cat_outputlog`、`show_usage` 等 function  

`inexistence 1.1.5.3`  
1. **Bump version to 1.1.5**  
2. **New Feature：加入 `--separate` 参数，可以启用子脚本**  
3. **启用 flexget/wine/mono 子脚本，删除重复代码**  
4. **FlexGet 切换到普通用户运行，而不是原先的 root**  
5. BugFix：修复 systemd unit 的权限问题  
6. Fix：CRLF → LF  

`function r10044`  
1. BugFix：修复 `check_remote_git_repo_branch` 可能没有 git 的问题  
2. Feature：保险起见，`apt_install` 之前做 `APT_UPGRADE`  
3. Feature：增加 `cat_outputlog`，自带判断启用条件 `if [[ $show_log == 1 ]]`  
4. Feature：`debug_log_location` 增加条件 `if [[ $debug == 1 ]]`  

`libtorrent-rasterbar\install r10059`
1. 修复 status_lock 的创建方式  
2. 增加 `--log` 以查看日志  
3. 增加 `purge_old_libtorrent`，防止不同 deb 间覆盖安装的问题  

`flexget\install r20006`
1. 更新 `show_usage` 和 `getopt`  
2. 在安装 Py3 前先检查 lock，避免跑两次 Py3 安装过程  
3. Python3 lock 文件名改为小写  
4. 增加更多的 `>> "$OutputLOG" 2>&1`  
5. 修复 Debian 8 下 OpenSSL 的问题，使用 backports 的 1.0.2  

`flexget\configure r10006`
1. 合并 separate-script 分支的修改  
2. 放弃对用户名的 patch  
3. 放弃用户态模式下的配置，相关代码仍然保留  

`README 1.2.5`
- **加回 to do list**  





## 2020.03.01

`the inexistence project`  
1. 子脚本的 source 外部引用方式更新为  
```
source <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/function)
```
2. 子脚本使用了新的 `APT_UPGRADE`、`apt_install_check` 和 `apt_install_separate`  
3. 同步 bluray 的改动  
4. ipv6 重命名为 ipv6.old，ipv6.sh 重命名为 ipv6（同步 aBox 的修改）  

`bluray 3.0.3`  
1. **Bump version to 3.0.3**  
距离上次更新有 11 个月左右了  
2. **Feature：隐藏是否创建缩略图的问题**  
基本上没啥用，注释掉了  
3. **Feature：检查脚本运行依赖时，不再要求 vns, montage, identify**  
4. **Feature：加入安装/更新本脚本的功能，使用参数 `-i`**  
5. Feature：修复在没有写入权限的目录下运行脚本时无法提取 bdinfo quick summary 的问题  
6. Feature：检查 BDinfo 扫描是否成功，并在最后的结尾处做提示  
7. UI：脚本缺少依赖时，默认选项改为退出脚本  
8. UI：在显示版本号时也显示脚本更新时间  
9. BugFix：修复 logo 下载链接失效的问题  
10. 更新 README  
11. 加入短链接  
```
bash <(wget -qO- https://git.io/bluray) -u
```

`function r10039`  
1. **引入 `apt_install_check`，重写 `apt_install_separate`**  
2. 修复 `apt_install` 实际上什么也装不了的 bug，并改名为 `apt_install_together`  

`README 1.2.4`  
1. **在参数说明处，加上了我个人常用的参数**  
2. **bluray 脚本介绍重写，添加更新命令和 alias**  
3. 把 bluray 脚本的介绍移到 mingling 下，bdinfo 前  
4. 注明 bdinfo 脚本不支持 UHD，UHD 扫描请使用 bluray 脚本  
5. 提示 mingling 脚本可能会过时  





## 2020.02.28

`function r10037`  
1. 引入 `APT_UPGRADE`  
2. 引入 `echo_task` 和 `echo_error` 等通用信息相关 function  
3. 更新 `apt_install_separate` 中的 apt 选项以及输出  

`mingling 0.9.3.1`  
1. **Bump version to 0.9.3**  
距离上次更新很久了，需要改的东西挺多的了，上一个版本已经严重过时了  
2. 去除 virt-what 和 lsb_release 的依赖  
3. 更新是否启用了 tweaks 的检测  
4. 更新了 serveripv4 内网检测  
5. 更新了命令说明界面里的命令  
ruisua → sssa / lssa，swap-on → swapon  
6. 使用 superbench.sh 的办法检测虚拟化  
7. 更新了硬盘空间计算方式  
8. 优化了多路 CPU 的判定方式  
9. “运行其他一键脚本”的菜单里，更新脚本链接，加入 iperfff  
10. 更新 “某辣鸡的脚本说明”  
11. update_mingling 里移除 bdjietu 等，加入 password 等  
虽然 password 很久没写了，还没完成……  

`flexget/install r20002`  
1. 合并 separate-script 分支的修改  
2. 放弃单用户安装，改为安装到系统  
3. **抛弃 FlexGet 2，全面使用 FlexGet 3**  
4. 加入 `install_python3`  
5. 不针对 WebUI 用户名打补丁，不过**移除了密码复杂性验证**  

`wine/install r10003`  
1. 合并 separate-script 分支的修改  
2. 加入 APT_UPGRADE  

`wine/uninstall r10002`  
1. 合并 separate-script 分支的修改  
2. 加入 APT_UPGRADE  

`mono/install r10005`  
1. 合并 separate-script 分支的修改  
2. 加入 APT_UPGRADE  





## 2020.02.27

`the inexistence project`  
- 同步 separate-script 的改动，准备之后删除这个分支（commits 历史打算保留）  
- 具体来说，separate-script 分支对子脚本进行了以下同一类型的改动：  
1. 各类重复 function 移动到 function 脚本内，并 source function  
2. 脚本运行前 unset 变量  
3. 加入 AppName、AppNameLower、pm_action、Need_SourceCode、DebName 等变量  
4. 使用 set_variables_log_location 来设置各类变量并创建目录  
5. 用 +check_var_OutputLOG 确保 function 已被 source  
6. 优化显示效果，包括日志里也增强了易读性  

`inexistence 1.1.4.9`  
1. BugFix：修复 deluge skip hash check 下载链接错误的问题  
2. BugFix：修复 deluge skip hash check 补丁没打好的问题  

`alias r11002`  
1. 同步 separate-script 分支的修改  
2. 加入 `newpass` 和 `sprunge.us`，后者配合管道使用，方便直接上传日志  
3. 加入脚本相关的环境变量  
4. 加入脚本内部的 usage，包括从老版升级的部分  

`function r10035`  
1. 同步 separate-script 分支的修改  
2. 注释里说明代码是从哪里抄来的  
3. 增加 function lines  
4. 增加 function apt_install 和 apt_install_separate  
5. 增加 function set_variables_log_location  
6. 增加 function PortGenerator 和 PortCheck  
7. 增加 function check_remote_git_repo_branch  
8. 增加 function debug_log_location  
9. 修复 No such file: /tmp/Variables  
10. check_status 增加 `ERROR: No Variables` 状态  

`libtorrent-rasterbar/install r10054`  
1. 合并 separate-script 分支的修改  
2. 修复非 fpm 安装时的一些小问题  
3. 增加 deb3 模式，安装 efs 编译的 1.1.14 deb 包  





## 2020.02.25-26

`ChangeLog`
1. 快一年没更新 changelog 了吧……  
2. 先更新 2020 年的  
3. 补全了 2019 年缺的  
4. 修正了一些过往的小问题  

`the inexistence project`  
1. **删除 commits 历史中的无用文件**  
目前把整个项目的体积从 950MiB+ 缩减到了 5.3MiB  
图片部分移动到了 pics 项目，bdinfocli 选择从 bluray 项目下载  
各类 deb 目前从 SourceForge 下载  
2. **删除了旧的 tags**  
3. 更新 Deluge 设置，缓存大小默认 32768，不再启用 `sidebar_show_zero`  

`inexistence`  
1. Bug Fix：删除了安装 qt 时依赖里的 `checkinstall`  
现在 buster 好像又没有 `checkinstall` 的包了……  
2. Bug Fix：在安装 qt512 的时候，使用 `apt-get` 代替 `apt`  
3. Bug Fix：只有 `lspci | grep -i bcm` 有反馈时才会下载 bnx2 固件  
4. Codes：因为移除了 repo 里的 bdinfocli，因此改为从 bluray 项目上下载  
5. Feature：使用 patch 的方式给 de 1.3.15 加上跳校验功能
现在这个设置和 `--sihuo` 也兼容了  
6. Feature：设置 $PATH，解决部分机器环境变量不包含特定路径的问题  

`alias r11000`
1. **使用 source 的方式添加到 `/etc/bash.bashrc`**  
避免了大幅修改系统文件，也让修改变得更省力  
2. 添加了对 HISTSIZE、HISTTIMEFORMAT 的修改  
3. 改进了 `Customed alias is enabled` 的提示方式  
现在是输入 `. s-alias 1` 来激活，也不用 cd 到目录了  

`README 1.2.3`
1. 添加了短网址的 usage  
2. 更新了图片的链接到另外一个图床专用的项目  
3. 更新了 `--lt` 参数的用法  
4. 更新了 `--de 1.3.15_skip_hash_check` 的用法  
5. **增加 Notes 部分，提醒不一定兼容 Xen 和 OpenVZ 架构**  





## 2020.02.20-24

`ipv6 Gen3`
1. Feature：更完善的网卡判断机制  
2. BugFix：修复 ipip 检测 AS 信息丢失的问题  
3. Feature：检查参数时，不退出脚本，而是让用户补全参数  
4. UI：隐藏解压 dibbler 源码时的输出  
5. UI：检查连接性时的文字改为中文  
6. UI：小修小补，添加换行／空格之类的  
7. 询问参数改为 function，方便 check_var 调用  
8. BugFix：修复一次脚本运行中多次显示 menu 时，每次都要检查 IP 的问题  
9. Menu：添加重启、清除脚本配置文件、再次检查 IP、手动修改 IPv4 地址的功能  
10. Menu：加入脚本版本显示
11. Feature：可以修改脚本检测到的网卡名称  
12. Feature：增加 `-i` 参数，用于指定网卡  
13. BugFix：移除脚本配置时，关闭 odhco6c 服务  
14. **Bump version to Generation 3**  
15. BugFix：修复 cli 下使用 `-m` 参数没反应的问题  
16. 之后的移到 aBox 去更新了。。。。。  

`README 1.2.2`
1. **更新 ipv6 脚本的说明**  
老的 ipv6 脚本的说明直接移除  
2. **efs nb!**  
添加了 `QuickBox Lite` 和 `QuickBox ARM` 项目的宣传  
3. **加了 QQ 群的介绍到显目位置**  
然而并没有什么卵用~  
4. 更新英文说明，提醒没有 plex, emby, nzb  





## 2020.02.13-15

`inexistence 1.1.4.3`  
1. Feature：增加 gclone  
2. BugFix：使用 `apt-mark hold` 修复 transmission 2.94 deb 被 `apt upgrade` 的问题  
3. Feature：qBittorrent 默认版本改为 4.1.9  
主要是因为某瓷器不支持 4.1.9.1  

`alias`
- 修复 gclone 冲突的问题  





## 2020.02.10

`ipv6 Gen2`
1. **Feature：增加 ipip 检测**  
2. **Feature：根据 ASN 判断脚本是否支持**  
3. **Feature：增加菜单**  





## 2020.02.08

`the inexistence project`  
-  **迁移大量下载链接到 SourceForge**  
为之后项目瘦身做准备  

`inexistence 1.1.4.1`  
1. **Bump version to 1.1.4**  
2. Feature：增加 `--tr-deb` 参数，安装 efs 的 tr 2.94 deb  
3. Feature：增加 `--skip-system-upgrade` 参数，允许跳过系统升级检测  
4. BugFix：修复安装 vnstat 编译依赖时 `apt-get` 没用 `-y` 的问题  





## 2020.01.27

`inexistence 1.1.3.12`  
1. **Feature：libtorrent-rasterbar 升级到 1.1.14，统一使用 efs 的 deb**  
2. Feature：简化 fpm 的安装  
3. Feature：移除 Debian10 专用的 checkinstall 安装  

`00.Installation\package\qbittorrent\configure`
- **Feature：编译 libqbpasswd，不使用编译好的文件**  

`deluge-update-tracker r20005`  
- 更新脚本内注释部分的 Usage  





## 2020.01.19

`the inexistence project`  
1. 更新 systemd 配置文件，关闭使用 kill -9 $MAINPID（然而似乎不太好用）  
2. 更新 systemd 配置文件，LimitNOFILE 从 666666 改为 infinity（似乎改了反而降低到 65536 了）  
3. qb 的 systemd 不再指定 WebUI 端口  
4. tr 的 systemd 指定配置文件路径，并加入 reload action  

`inexistence 1.1.3.12`  
1. **Feature：transmission 默认使用 efs 的 2.94 deb**  

`alias`  
- 更新了 del、dewl、trl  

`README 1.2.1`
1. 更新 transmission 部分的说明  
2. 更新 `ipv6.sh` 的使用说明，加上了详细用法  





## 2020.01.06/07/14

`the inexistence project`  
1. **建立了一个脚本交流的 QQ 群**（我个人不习惯 TG）  
2. **建立了一个 gist，放一些网址和群公告**  
3. 从 separate-script 分支同步 ipv6 脚本的改动  

`inexistence 1.1.3.9`  
1. BugFIx：改进 flexget 依赖安装  
2. Feature：transmission apt 安装时增加 transmission-cli  

`deluge-update-tracker r20004`
1. 增加 usage  
2. 彩色化日志  
3. 增加 deluge-console 检测  
4. 增加命令行参数支持，`--log`、`--clean`  
5. 增加 `*Error*|*timed*out` 的 tracker 状态错误判断  

`ipv6 Gen2`
1. Feature：新增 `-r`、`-h`、`-t`、`-c` 选项
2. Feature：用 function check_var 检查变量*  
3. Feature：Ikoula netplan 改为覆盖式写入  
4. **Feature：各个单独的步骤都 function 化**  
5. **New Feature：新增 online_dibbler**  
6. **New Feature：新增 online_odhcp6c**  
7. **New Feature：新增清理脚本对系统文件修改的功能**  
8. **New Feature：新增帮助界面**  
9. **New Feature：新增测试界面**  

`alias r10009`
1. `yongle` 的单位改为 GiB  
2. 加入 `fiobench`、`dddd=rm -rf`  
3. `swap-on` → `swapon`  

`README 1.2.0`
1. 针对最近的脚本改动进行更新  
2. 去除了 qb 3.3.17 的说明  
3. Deluge 2.0.3 相关提示  
4. 系统支持方面的更新  
5. Flexget python2.7 的提示  
6. 加入 `ipv6.sh` 的介绍  
7. **在底部加了群号**  





## 2020.01.02

`inexistence 1.1.3.7`  
1. **New Feature：增加 qbittorrent 4.2.1**  
2. **New Feature：增加 qt 5.12**  
3. **New Feature：增加 Deluge 2.0.3**
4. Feature：增加安装 gnupg  
5. UI：qBittorrent 选项顺序调整  
6. UI：去掉一些几乎没人用的 tr 版本选项  










# ================= 2020 =================










## 2019.11.06/09

`inexistence`  
1. **Merge pull request #53 from DieNacht/master**  
距离上一个 pr 很久了呢  
2. **Bump version to 1.1.13**  
3. BugFix：修复 DN 忘记加 python-libtorrent deb 包的问题  

`Updates from PR`
1. **Feature：增加 Debian10 的预编译 libtorrent deb 包，from efs**  
2. **New Feature：允许各类老系统升级到最新的 LTS**  
具体来说，现在新增了 Debian 8/9 升级到 9/10，Ubuntu 16.04 升级到 18.04  
3. **New Feature：增加 qBittorrent 4.1.9.1 并设为默认选项**  
4. Codes：去掉了一些多余的空格  





## 2019.10.16

`inexistence 1.2.2.25`  
1. New Feature：新增 qBittorrent 4.1.8 选项，移除 4.1.6 选项  

`jietu r20047`  
1. 同步另外一个分支的更新  
2. 改进分辨率计算，注释掉旧的代码  





## 2019.09.08

`FILES`  
- Add deluge.1.3.15.skip.no.full.allocate.patch





## 2019.08.21

`inexistence 1.1.2.24`  
1. **New Feature：增加 rTorrent 0.9.8 和 feature-bind 选项**  
2. New Feature：新增 qBittorrent 4.1.7 选项
3. BugFix：修复 debian 开启 backports 时源写错了的问题  





## 2019.07.11/12/15 separate-script

`the inexistence project`  
- 删除 unrarll、spdtest、update-tracker.py 等现在用不到的文件和脚本  
（但是那个时候没有从 commits 历史里删掉）  

`inexistence 1.1.2.22`  
1. BugFix：修复 deluge 下载源码时翻车的问题  
2. Feature：脚本默认换源  
3. FixTypo

`rclone uninstall`  
- add status check  

`separate-script branch`
1. Add separate script of wine, mono install and uninstall
2. 其他的改了一堆，我都懒得写了。。。  





## 2019.07.10 Debian 10

我看 commits 看晕了，看这个直观点：https://github.com/Aniverse/inexistence/compare/15ac55d...60ecada  

`the inexistence project`  
1. 部分子脚本重命名、路径变更  
2. 增加 rclone install 与 uninstall  

`inexistence`  
1. **New Feature：正式支持 Debian 10**  
2. **Feature：为 Debian10 开启 rTorrent**  
3. **New Feature：使用子脚本安装 rclone**  
4. **New Feature：使用子脚本配置 qBittorrent**  
5. Feature：又加了一些 step one 安装的包  
6. UI：移除 qBittorrent 4.1.4-4.1.5 安装选项  
7. UI：移除 Debian8 警告  

`alias`
- 不给 alias 运行权限（644），避免直接运行，从而让意识到要 source  

`function`
- 增加环境变量设置  

`libtorrent-rasterbar/install`
1. 补充 function 脚本不存在的情况下的操作  
2. **使用 fpm 打包**  

`qbittorrent/configure`
- 细化输出日志，增加 logbase  





## 2019.07.08/09

`inexistence 1.1.2.13`  
1. New Feature：为 Debian 系统开启 backports 源支持（如果原来没有的话）  
2. **New Feature：添加 ruby-dev 包，并安装 fpm**  
3. Feature：改进 mono 安装  
4. Feature：源码编译 vnstat 移动到后边  

`FILES`  
- Add bbr for kernel 5.1 & 5.2  





## 2019.07.03

`ipv6 r20005`  
1. 安装 ifdown（其实应该是 ifupdown）仅在 ifdown 模式下，而非运行脚本就检查  
2. Codes style update  
3. **增加各类 mode，并用 case**  





## 2019.06.22/29

`inexistence 1.1.2.10`  
1. **Feature：使用新的检测方式代替 virt-what**  
2. UI：增加 OVZ 等架构的 VPS 跑脚本时候的警告  
3. BugFix：为了避免某些奇怪的 bug，OpenVZ 单独安装 atop  
4. Codes：部分 function 名字去掉开头的 _  
5. New Feature：Debian 8 的源里增加 `http://security.debian.org/ jessie/updates`  
6. Feature：移除安装 netplan 包  

`ipv6 r20004`  
1. 增加 `-6`、`-s`、`-d` 选项  
2. 更完善的 netplan 检测方式  
3. FixTypo  
4. Code Style Update  
5. 增加 function ipv6_test  





## 2019.06.15/18/21/22

`inexistence 1.1.2.5`  
1. Feature：移除安装 netplan 包  
2. BugFix：修复 deluge 源码下载失败问题，现在从 GitHub 下载  

`jietu r20046`  
1. 允许自定义设置截图张数  





## 2019.06.14

`inexistence 1.1.2.3`  
1. Feature：移除内网 IPv4 地址检测  
2. BugFix：强制使用 ipv4 下载 deluge 源码  
3. Feature：deluge 安装过程输出到一个 record 文件里，方便删除  
4. Feature：增加安装 lftp  
5. BugFix：为了避免某些奇怪的 bug，单独安装 atop  
6. BugFix：修复 lt=system 时 lt 版本显示的问题  

`alias`  
1. 增加 vnstat systemd 相关 alias  
2. 微调 s-end，s-opt，yuan  






## 2019.06.06

`alias 107`  
- 增加 abench 和 bench  

`README 1.1.7`  
1. 增加 Debian 10 相关说明  
2. 更新 qb 3.3.17 的说明  
3. 增加 Flood 挂载点和端口号的说明  
4. **删除 To Do List 和 Under Consideration 的内容**  
5. 注明 ipv6 脚本不支持 ikoula 和 Ubuntu 18.04  
6. 注明截图支持 DVD 的 ifo 的 mediainfo 获取  
7. 其他各种微调  





## 2019.05.23/24/25

https://github.com/Aniverse/inexistence/compare/0a9ef1a...6abdab5

`inexistence 1.1.2.2`  
1. **Bump version to 1.1.2**  
2. **Feature：加入 `--sihuo`**  
3. Codes：Style Update  
4. UI：部分 `read -ep` 换回 `echo -ne`+`read`  
5. **Feature：彻底移除 libtorrent 自定义选项的功能**  
6. Codes：修改部分 function 名称，去掉开头的 _  
7. Feature：增加 locate 包  
8. Feature：移除 jessie 的 gcc 7.3 deb 包  
9. **New Feature：使用 alias 脚本写入 bashrc**  
10. Codes：新增变量 $WebROOT  
11. BugFix：Debian 10 下编译安装 libtorrent-rasterbar  

`alias 106`  
1. `export eth=$wangka`  
2. 增加 IntoBashrc 模式  
3. 增加 `Customed alias is enabled` 提示  
4. 启用 `setcolor`  

`deluge/install r10020`  
- 反正就是照着别的脚本慢慢改的  

`install_libtorrent_rasterbar r10033`  
- 适配下 Debian 10  

`qbittorrent/configure r10002`  
- 变量名和输出微调  

`ipv6 r20003`
1. 禁用本地 ipv4 检测  
2. ikoula netplan 修复为覆盖式写入，网卡名称不固定  

`jietu r20045`
1. **不使用 bc**  
2. 检测 awk 是否可用  
3. **再次改进分辨率计算方式**  
4. 调整 debug 输出  
5. 代码优化  
6. 新增 function Deprecated  

`FILES`  
- Add sihuo (de/qb)  





## 2019.05.14/15/16/18

`inexistence 1.1.1.17`  
1. Codes：使用 `wget -nv -N`  
2. Codes：Style Update  
3. Feature：更新 getopt  
4. FixTypo  

`function r10005`
- 修复 getopt 问题  

`install_libtorrent_rasterbar r10031`  
1. 增加帮助界面  
2. 更新 getopt  

`mingling 0.9.2.004`
- 清理代码  

`FILES`  
1. Add rt fast resume  
2. Add tcp.cc (from qss)   
3. Add rTorrent patches  
4. README 更新软件的下载链接、编译方式  





## 2019.05.12/13

`inexistence 1.1.1.12`  
1. Feature：部分后边要装的依赖移动到 step one  
2. Codes：Style Update  
3. feature：跳校验的 3.3.11 改为 3.3.17  
4. BugFix：为 Debian 10 禁用 lt 1.0 选项  
5. Codes：移除部分 wget 的 `--no-check-certificate`  参数和 `-O`  

`install_libtorrent_rasterbar r10027`  
1. **初步支持 Debian 10**  
2. 结合 function 简化代码  

`function`  
1. **初始化**  

`FILES`  
1. **新增 README**   
2. Add TorrentGrid.js for Deluge 1.3.15.dev0  





## 2019.05.11 files 

`the inexistence project`  
- **新增 files 分支**  

`inexistence 1.1.1`  
1. **Bump version to 1.1.1**  
2. **Feature：改从 files 分支下载文件**  
3. **Feature：step one 的一堆包，安装之前先检测源里有没有**  
4. step one 即升级 pip，flexget 那里就不用升级了  
5. **Feature：vnstat 统一编译升级到 2.2**  
6. Feature：为 Debian10 安装 checkinstall  
7. Codes：改进 bnx2 固件下载的写法  
8. Codes：移除部分 wget 的 `--no-check-certificate`  参数  
9. Feature：更新 ffmpeg 的下载与安装  
10. `grep buster /etc/os-release -q && CODENAME=buster`  

`inexistence files`  
- 这时候只加了 logo  





## 2019.05.10

`inexistence 1.1.0.15`  
1. **Feature：加入初步的 Debian 10 支持，测试阶段**  





## 2019.05.05/06/09

`inexistence 1.1.0.14`  
1. BugFix：修复 vnstat 指定网卡的判断条件  
2. UI： lt 1.2 分支版本改为 1.2.1  
3. Feature：新增 qBittorrent 4.1.6  
4. Codes：Style Update  

`ipv6 Gen2`
1. **Initial**  
2. 加入 ikoula_interfaces 模式  
3. 加入 netplan (OL/IK)  





## 2019.04.25/27/29

`jietu 2.4.0`
1. 修复 ifo 包含空格时检测不到文件的 bug  
2. 注释掉容易出 bug 的 even_num function，用其他方法完成奇数进一  
3. 增加调试信息输出  

`install_libtorrent_rasterbar 1.2.4`  
1. Code Style Update  
2. 完善交互、功能、输出  

`zuozhong 1.1.0`  
1. 检测 mktorrent 是否在 $PATH 内  
2. 创建 BT 种子选项改为 99  
3. 去掉 mktorrent `-a ""` 参数  
4. Modernize codes  
5. 增加 piece_size 参数  
6. 增加 Classix-Unlimited tracker  





## 2019.04.24

https://github.com/Aniverse/inexistence/compare/2164c6e...949f69e

`inexistence 1.1.0.3`  
1. FixTypo  
2. Codes：Style update  
3. UI：OpenVZ 内存不足警告  
4. Debug：增加更多信息  

`alias`  
- FixTypo  

`qbittorrent/configure`  
- FixTypo  

`mingling`  
- 顺应脚本变化做相应的修改  






## 2019.04.16-17

`inexistence 1.1.0.3`  
1. Codes：用 `iUser` 代替 `ANUSER`，`iPass` 代替 `ANPASS`  
2. Codes：重新指定日志、源码等的存放路径，都在 `/log/inexistence` 内  
3. Feature：引入了 `$times`，判断安装过几次用的  
4. New Feature：增加 `--branch` 参数  
5. Codes：修改了 `deluged/deluge-web` 的日志文件路径  
6. Codes：重写 `$LogBase/version` 的内容  

`install/alias`
1. 对应 qb 采用普通用户运行，修改了对应的别名  
2. 对应日志文件存放路径的改动，修改了对应的别名  
3. 删除一些查看日志的别名  

`mingling 0.9.2.002`
对应主脚本的修改而修改  
- 用 `iUser` 代替 `ANUSER`  
- 更新检测 `$iUser` 和 `$tweaks`、`$inexistence` 的方式  
- 更新 alias 和操作选项  
- 重新启用菜单 5，检查运行状态，不过不显示选项  
- 一些文字、排版、注释的修改  

`install/qbittorrent/configure`
- 可以为每个用户进行单独配置  
- 可以用命令行参数设定网页端口、传输端口、用户名、密码、home 路径  
- systemd 改为 `qbittorrent-nox -d` 和 `Type=forking`，取消 `Umask=000`  
- systemd 文件打开数改为无限制，超时间隔 300 秒  
- 在脚本里写入配置文件和 systemd，不再在脚本仓库里存放模板文件  
- 日志文件存放在 `.config/qBittorrent/qbittorrent.log`  
- h5ai 部分暂时不做修改  

`install/qbittorrent/qb`
- 代替 alias 用的  
- 开／关／状态／重启／日志／配置文件／开机自启／禁用开机自启  
- 可以设定不同用户的进程，默认不用输入用户名自动检测脚本装的用户名  





## 2019.04.14

`inexistence 1.1.0.1`  
1. Feature：在 step-one 安装 Nconvert  

`bluray 2.9.7`  
1. Feature：更新 Nconvert 的安装方法  





## 2019.04.14

`inexistence 1.1.0`  
1. **Bump version to 1.1.0**  
距离上次版本变动快半年了……其实这次是因为除了修改 naive 外不知道改什么了就干脆升级版本号了  
2. UI：修复 Naive 拼错的问题  

`alias 102`  
1. Add `scrb` and `aatop`  





## 2019.04.13

`inexistence 1.0.9 34`  
1. Bug Fix：尝试修复安装指定版本 lt 找不到分支的问题  
04.14：实际上然并卵，下次再说  
2. Codes：颜色代码那边排版修改  
3. Codes：对应 alias 的修改，增加 alias 脚本的输入 $1 $2  
4. Bug Fix：修复指定 vnstat 网卡时 sed 没用双引号导致变量不识别的问题    

`alias`  
1. **使用 `while grep -q, sed -i '$d'` 的方式解决可能重复添加 alias 的问题**  
这是一个蠢办法，执行效率也低（相对），但是应该没人会在乎几十毫秒的差距吧  
此外这个办法仍然有可能删除用户自己添加的内容，不过老方法也会，所以不算引入缺点  
毕竟本来就有这个问题了，在更好的解决办法被我学会以前就先这样吧，我觉得已经比原先强多了  
2. **取消 ulimit 的设定**  
3. Color 部分也对应主脚本修改排版  
4. 排版修改，以及 `${ANUSER}` 改成 `$ANUSER`  
5. `jiaobenxuanxiang` 之类的改成 `s-opt` 之类的  

`mingling 0.9.2.001`  
1. 这放弃治疗的东西难得更新一次  
2. 没啥玩意儿，就是因为 alias 改了所以这个也要“与时俱进”一下  
3. 我都快忘了这货了，不过毕竟过了这么久了，感觉确实有些东西可以更新下  
比如系统信息检测那边，dd 测试啊啥的，不过以后再说吧  



## 2019.04.12

`inexistence 1.0.9 34`  
1. **Feature：将文件打开数修改、Jessie 升级 vnstat、vnstat 网卡修改提前到了第一步**  
这样一来，`system tweaks` 中包含的就是：alias、screenrc、设置英文语言、设置东八区为时区、保留空间释放  
2. **Alias：单独成一个脚本**  
3. **Codes：移除大量不再使用的代码**  

`alias`
1. 独立出来了  





## 2019.04.10

`inexistence 1.0.9 33`  
1. Bug Fix：Ctrl+C 时 `reset -w`（不然在 echo -ne 处 Vultr 的排版会错位）  
2. Feature：Add `WebUI\CSRFProtection=false` to `qBittorrent.conf` for `PT-Plugin-Plus`  
3. Bug Fix：Jessie 换源时忘记备份原先的文件了，备份下  





## 2019.04.09

`inexistence 1.0.9 32`  
1. Bug Fix：No arguments allowed $1 is not a valid argument  
2. Feature：指定 vnstat 网卡  
3. **Feature：重新启用 apt sources 的问题**  
4. **Feature：对于 Debian Jessie，换源采用 `snapshot.debian.org`**  
5. Alias：加入 LotServer 相关，删掉了大量别名，wangka 直接从脚本里写入  
6. Codes：function 化了 3 处原先已被注释的代码，之后再删  
7. Codes：注释一些代码，排版调整，增加 usage_guides  
8. Codes：移除 `Preparation for rtorrent_fast_resume.pl`  
9. Codes：移除 `wine` 和 `mono` 的编译安装方法  
10. Codes：移除了下载 wine 字体包的部分  
11. Codes：增加作者吐槽  
12. 很久没管过破脚本了……心情复杂.jpg  

`flexget.config.yml`  
1. 提示可能只有使用 qb 4.1+ 才能使用 flexget 的 qb 限速  





## 2019.03.15

`inexistence 1.0.9 31`  
1. Add UMask=000 for systemd  





## 2019.02.25

`bluray 2.9.4-2.9.6`  
1. Bug Fix：调整 PATH 的顺序  
2. Bug Fix：添加写丢了的 `even_number` function  
3. Bug Fix：其他手滑修复  





## 2019.02.22

`inexistence 1.0.9 31`   
1. SubScripts：同步更新 `bluray` 到 2.9.6  

`flexget.config.yml`  
1. HDChina 的演示改为更有意义的 HDSky，因为后者需要在 seen 插件里设定检查项为 url  
2. 增加 ADC 的 RSS 展示
ADC 需要用到 `headers` 的 `Cookie`，`urlrewrite`，`if` 的 `in description`，比较有教学意义  
3. 增加对反代设置项的注释说明，以及默认关闭 schedules 的说明  





## 2019.02.16

`inexistence 1.0.9 31`   
1. Bug Fix：修复 libtorrent 版本号显示的问题  
2. Bug Fix：remove unset lt_version in line929, due to this would make `--lt` opt useless  
3. Chinese：汉化 `Input the version you want`  
4. Codes：排版  
5. SubScripts：同步更新 `bluray` 到 2.9.2  

`install_libtorrent_rasterbar 1.2.3`  
1. 更新 `python-binding` 和 `C++11` 的处理方式  





## 2019.02.15

`config_deluge 1.0.0-1.0.1`  
1. 初始化，未完待续，咕咕





## 2019.02.13

`flexget.config.yml`  
1. 由于 Flexget 的更新，修改了 `deluge` 插件的 `max_up_speed` 写法  





## 2019.01.28

`jietu 2.3.7`  
1. 大概是忘记 commit 了，跳过了 2.3.6  
2. Bug Fix：修复可能出现两个视频分辨率的问题（选第一个）  





## 2019.01.27

`bluray 2.9.3`  
1. **Feature：更新分辨率的计算方式**  





## 2019.01.26

`inexistence 1.0.9 30`   
1. **Feature：不再默认启用 ltconfig 的 High Performance Seed**  
之前忘记删除 ltconfig.conf 了  
2. Feature：在第一步增加安装 `libelf-dev`  
3. Bug Fix：修复添加了 wine 的源后未添加 key 的问题  

`jietu 2.3.1-2.3.5`  
1. **Bug Fix：修复 IFO 文件的判断**  
2. Codes：增加判断 Blu-ray Disk 的 Source Type，并根据文件名提取 `disk title`  
3. **Feature：对 DVD 和 Blu-ray，输出的文件名前加上 `disk title`**  





## 2019.01.22

`bluray`  
1. 往软件库里加了 `bc`，我也忘记是哪个系统里拿出来的了，反正似乎有的系统使用会有问题  





## 2019.01.23

`inexistence 1.0.9 29`   
1. Improvement：修改 deluge 配置方法，注释部分也一并改了  
2. Upgrade：ffmpeg 4.1.0 static release  
3. 删除一些无用文件  
4. 更新了下 zshrc  





## 2019.01.22

`inexistence 1.0.9 28`  
1. Codes：不再使用 `local_packages` 这个变量  
主要是我自己复制粘贴都变得麻烦了 emmm  
2. UI： 中文的开始安装所需软件前去掉一个空行  
3. Codes：`QB_latest_ver=4.1.5`  

`guazai`  
1. Bug Fix：修复没有检查是否用 root 权限运行脚本的问题  

`jiegua`  
1. Bug Fix：修复没有检查是否用 root 权限运行脚本的问题  

`jietu 2.1.3-2.3.0`  
1. **New Feature：test(debug) mode**  
2. **Bug Fix：Calculate screenshots resolution properly**  
3. **New Feature：Adding IFO mediainfo for DVD**  





## 2019.01.20

`install_libtorrent_rasterbar 1.22`  
1. Bug Fix：增加 -m 错误时 deb3 的提示（其实还没编译 1.2.0 的 deb）  
2. Codes：优化排版，注释补充  





## 2019.01.17

`inexistence 1.0.9 `  
1. Chinese：继续汉化，正式开始安装前的确认信息部分完成  
2. Debug：加点更多的信息（那时候找不出问题所在……）  
3. Bug Fix：修复安装的 lt 版本没改为 1.1.12 的问题  

`install_libtorrent_rasterbar 1.20-1.21`  
1. Bug Fix：修复版本号强制指定为 1.1.9 导致一系列错误发生的问题  
2. Feature：加入 debug 模式  
3. Bug Fix：修复分支检测方式失效的问题  
4. Codes：优化排版  





## 2019.01.15

`jietu 2.1.2`  
1. **Improvement：升级、修复分辨率的计算方法**    
但之后发现其实这也有问题，真是蛋疼  
2. **Improvement：不再询问计算出来的分辨率是否正确，直接截图，方便无交互的操作**  
对于用于 `for` 等批量处理的情况会方便得多，如果分辨率有问题的话可以自己手动指定  
3. **Improvement：使用新的截图方式，解决 UHD BDMV 截图花屏问题**  

`install_libtorrent_rasterbar 1.19`  
1. 更新 usage 的写法  
2. 把 deb2 方式用的 1.1.11 升级到 1.1.12  

（这一次引入了一个重大 bug ……现已修复）





## 2019.01.14

`inexistence 1.0.9 27`  
1. Chinese：汉化一小部分，rTorrent 安装问题部分完成  
2. Improvement：lt 的 master 分支换成 RC_1_2 分支  
3. Bug Fix：对应昨天的改动，修改 rcloned 的位置  
4. Bug Fix：修复注释里 deluge.old 的 `rm -rf` 写成 `rm-rf` 的问题
5. Bug Fix：隐藏 qBittorrent 4.2.0 的选项  
因为 qb master 分支已经升级了对依赖的要求，Debian 8 用脚本已经编译不出来了……  
6. **Improvement：BDinfoCLI 版本从我瞎几把编译的 0.7.5 降级到原作者自己编译的 0.7.3**  
原先 bug 一堆其实都是我搞出来的，这个 0.7.3 目前我测试下来没啥毛病 orz  
7. Improvement：脚本自带的 `bluray` 脚本升级到 2.9.0  





## 2019.01.13

`inexistence 1.0.9`  
1. **Improvement：简化 flexget 配置文件模板，删除其中的所有中文字符**  
2. Improvement：优化文件夹内文件分布  
3. Other：删除 qbittorrent.autoremove.py  
反正我这脚本也不负责安装和教学，需要的自己装吧  

PS：没动 `inexistence.sh` 文件的话小版本号就不动  






## 2019.01.02

`inexistence 1.0.9 26`  
1. Bug Fix：修复开了 swap 但没删掉临时文件的问题  
2. Feature：Ctrl+C 退出时恢复字体样式    
3. Improvement：更新 deluge-update-tracker 脚本  










# ================= 2019 =================










## 2018.12.26

`inexistence 1.0.9 25`  
1. Bug Fix：修复提示系统不支持时没写 18.04 也支持的问题  
2. Bug Fix：修复未删除 wine 字体压缩包的问题  





## 2018.12.25

`inexistence 1.0.9 24`  
1. Feature：加回 qb 4.1.5 选项（已发布），并设为默认选项  
2. Bug Fix：只针对 deluge 2.0 更新部分依赖  
Deluge 1.3.15 也更新依赖的话会出现 WebUI 加了种子但没显示的 bug  





## 2018.12.22

`inexistence 1.0.9 23`  
1. Bug Fix：隐藏 qb 4.1.5 选项（还没发布）  





## 2018.12.21

`inexistence 1.0.9 18-22`  
1. Bug Fix：删除 `python-software-properties` 这个包的安装  
Ubuntu 18.04 没这名字的包了，导致 ppa 都没加上……  
2. Improvement：在一开始安装的一堆软件包里增加 `pkg-config`  
3. Improvement：`find /usr/lib -name libtorrent-rasterbar*` 检测 lt 是否已经安装  
4. DeBUG：安装 deluge 加入 31、32 选项测试 `install_deluge`  
5. UI：减少安装完后提示文字的空格行数  
6. Virt-what：增加 Docker 的检测  
7. 安装完后删除 qt.5.5.1.deb  

`install_libtorrent_rasterbar 1.18？`  
1. 修复使用方式的手滑  
2. 修复未检测到 lt 时的报错文字未重置样式为初始设定的问题  

`install_deluge 1.19`  
1. 修复使用方式的手滑  
2. 样式修复  





## 2018.12.19

`inexistence 1.0.9.14-17`  
1. Improvement：在一开始安装的一堆软件包里增加 `net-tools`  
因为有些系统里不带 `ifconfig`  
2. Bug Fix：修复安装 qBittorrent 4.2.0 装不上的 bug  
3. **Improvement：安装 libtorrent-rasterbar 重新使用 deb 包，加快速度**  
4. Feature：使用 2GB 的 swap  
5. Improvement：修复 wine 字体包的解压问题  
6. Feature：升级 NodeJS 到 10.X  

`install_libtorrent_rasterbar 1.18`  
1. 更新使用方式  
2. 增加 deb2 的选项，安装预编译好的 lt 1.11.1 deb  
3. 这次 lt 包名都统一成 `libtorrent-rasterbar` 了，搞了个脚本编译，省事一些  





## 2018.12.13

`inexistence 1.0.9.13`  
1. Bug Fix：继续修复 lt 版本检查的问题  





## 2018.12.13

`inexistence 1.0.9.12`  
1. Feature：为 Debian 8 系统升级 vnstat 到 1.18  

`install_deluge 1.18`  
1. 更新 usage  
2. 修复手滑导致 pip 包名写错的问题  





## 2018.12.11

`inexistence 1.0.9.11`  
1. wine 字体包的下载链接以防万一加上防超时设定  
2. Bug Fix：修复 lt 版本判断的一些问题……  
人菜，心累  





## 2018.12.05

`inexistence 1.0.9.10`  
1. Feature：继续完善能汉化的部分，不急慢慢来……  
2. Feature：更新无交互的语言和时区设定方法  





## 2018.12.04

`inexistence 1.0.9.9`  
1. 安装 lt 时增加 98 `lt_version=system` 的隐藏选项，以防万一  
2. 由于 18.04 已有 wine 的 ppa 源，因此不再使用 artful 的源  
3. 优化 wine 的字体显示  
抄袭自：https://blog.gloriousdays.pw/2018/12/01/optimize-wine-font-rendering/  
4. **New Feature，WIP：语言选项，脚本以后会加入中文显示**  

`mingling 0.9.2`  
1. 放弃治疗  
2. 更新 `inexistence` 的运行命令  
3. 用自己的 A bench 代替 UnixBench  
4. 隐藏更改终端语言为中文的选项  
5. 说明 IPv6 配置脚本是为了 Online.net 独服设计的  

`README 1.1.6`  
1. **更新 Usage**  
2. 更新 Issues 的要求  





## 2018.12.03

`inexistence 1.0.9.6`  
1. Apps 部分增加 ethtool  
2. DeBUG：完善 lt 选择部分 debug 的输出内容  
3. 升级 mediaarea 到 1.0.6  
4. **Bug Fix：修复选择 qBittorrent 4.1.3 也会强制要求安装 lt 1.1 的问题**  
5. **Bug Fix：修复已安装 lt 1.1 的情况下还强制要求安装 lt 1.1 的问题**  





## 2018.11.27

`inexistence 1.0.9.3`  
1. Bug Fix：修复 `--skip-apps` 无效的问题  

`install_deluge 1.17`  
1. UI：隐藏 pip 的输出日志  





## 2018.11.25

`inexistence 1.0.9.2`  
1. Bug Fix：修复老系统安装 Deluge 2.0 依赖不够新的问题  
2. UI：提示可以使用 `-s` 参数跳过校验  
原先是让你自己修改脚本里的内容  
3. UI：增加 `SKIPAPPS=Yes` 的提示  

`install_deluge 1.15`  
1. **Bug Fix：修复老系统安装 Deluge 2.0 依赖不够新的问题导致无法运行的问题**  






## inexistence 1.0.9 Full ChangeLOG
1. **Feature：使用 `install_libtorrent_rasterbar` 脚本安装 lt**  
2. **Feature：重写 libtorrent-rasterbar 的安装判断**  
3. **Feature：qBittorrent 可选版本调整，去掉了 3.3.11 可跳校验的隐藏选项**  
4. **Feature：Deluge 可选版本调整，增加 2.0.dev**  
5. Feature：apt 安装 deluge 时，也安装 deluge、deluge-console、deluge-gtk  
6. Feature：Deluge 从 PPA 安装时，不再指定使用 libtorrent-rasterbar8  
7. Feature：Deluge python setup.py install 的时候，记录文件变动，方便以后卸载  
8. Feature：添加新参数 `--skip-apps`，可以跳过安装 iperf 等软件  
9. Feature：安装 rTorrent 的时候不安装 webmin  
10. SubScript：更新 `bluray` 脚本，增加 BDinfoCLI 0.7.5  
11. SubScript：更新 `install_libtorrent_rasterbar`脚本  
12. SubScript：更新 `install_deluge` 脚本  
13. Code：qbittorrent checkinstall 的包名改回了 qbittorrent-nox，以防万一安装前再卸载下之前的版本  
14. Code：去掉了 _installqbt2 及其相关代码  
15. Code：去掉 spinner  
16. Code：启用对网卡的检测  
17. Code：一些变量名称以及注释文字的改动  
18. **Bug Fix：修复新版本 flexget 连接 deluge 还需要安装 deluge-client 却没装的问题**  
19. Bug Fix：修复 Flexget 里 transmission 认证信息丢失的问题（Merge PR from Rhilip）  
20. Bug Fix：修复 /etc/inexistence/00.Installation/MAKE 没被创建的问题  
21. Bug Fix：修复 rt/lt opinions 里有 ppa 等选项的问题  
22. **UI：去除是否开启 swap、是否换源、编译线程数量的问题**  
23. UI：重新用了 `read -ep`，缩短了一些问题的字数  
24. UI：提示文字内容调整  





## 2018.11.18

`inexistence 1.0.9.1`  
1. 修改之前安装过 `inexistence` 时对之前文件夹的处理，不删除只重命名  
2. UI：去掉了 `use it at your own risk` 的说明  
3. UI：其他界面调整，提示文字调整（最花时间了……）  
4. 变量名称调整  
5. Bug Fix：安装 lt 时新增 lt 是否大于 1.0.6 的判断（qb 需要）  
6. **New Feature：去掉了以前的 lt 安装代码，使用 `install_libtorrent_rasterbar` 脚本**  
7. 修复 deluge 2.0 deluge-web.service 的 systemd 不可用的问题  
8. UI：重新用了 `read -ep`，缩短了一些问题的字数  
9. UI：提示文字内容调整  





## 2018.11.17

`install_libtorrent_rasterbar 1.14`  
1. 修复 `version_ge` 使用不当的问题  
2. 检测 libtorrent 是否需要使用 1.1.3 及以上的版本  
3. 修复 apt 安装时显示版本号为空的问题  
4. 改进进度显示功能（花了我好几个小时 orz……）  
5. 修改版本号，代码微调  

`install_deluge 1.15`  
1. 进一步优化安装第二个 Deluge 的逻辑  
但发现逻辑是搞清楚了但是装的有问题，以后再说吧  
2. 修复 apt 安装时显示版本号为空的问题  
但发现逻辑是搞清楚了但是装的有问题，以后再说吧  
3. 增加进度显示功能  
4. 修改版本号，代码微调  





## 2018.11.15

实际上是 15 号写的，只是没弄到 git 上（一是没空测试，二是 lt 1.1.11 和 qb 4.1.4 还没发布）  

`inexistence 1.0.9.0`  
1. **Bump version to 1.0.9**  
2. **Feature：qBittorrent 可选版本调整，去掉了 3.3.11 和 4.1.1.1 两个隐藏选项**  
增加了 4.1.4，并作为默认选项  
对仍然使用 qB 3.3.X 的用户作出提示，下个版本抛弃 qb 3.3.x 的选项  
此外增加了 qb 4.2.0.alpha 的安装选项  
3. **Feature：Deluge 可选版本调整**  
1.3.9 不再作为隐藏选项而是直接显示，同时去掉了一些几乎没人用的版本  
4. 选择其他版本时候由于有安装失败的可能性，添加了 `use it at your own risk` 的说明  
5. **Feature：重写 libtorrent-rasterbar 的安装判断**  
但是目前尚未启用这个问题，将在下一个版本里启用；情况还挺复杂，分了四个情况讨论 orz  
6. 用新的办法检测当前系统里 libtorrent-rasterbar 的版本号  
7. 一些变量名称以及注释文字的改动  
8. 去掉 spinner  
9. Bug Fix：修复 /etc/inexistence/00.Installation/MAKE 没被创建的问题  
10. qbittorrent checkinstall 的包名改回了 qbittorrent-nox，以防万一安装前再卸载下之前的版本  
11. 去掉了 _installqbt2 及其相关代码  
12. Deluge 从 PPA 安装时，不再指定使用 libtorrent-rasterbar-8  
13. Deluge python setup.py install 的时候，记录文件变动，方便以后卸载  
14. Bug Fix：尝试修复 `--skip-apps` 参数无效的问题  

`install_deluge 1.0.10`  
1. 修复 Deluge 1.3.10 及以前版本 deamon 连不上的问题  
2. 记录 deluge python setup.py install 的文件变动日志，方便以后卸载  
3. 优化安装第二个 Deluge 的逻辑  

`README 1.1.4`  
1. 对应脚本改动更新说明  

`ChangeLOG 0.2.0`  
1. 补写之前的一些日志里标签（Feature、Bug Fix 之类的） 没写上的问题，不过还没补完  
2. 从 `1.0.9` 开始，每次 `inexistence` 版本号升级的时候都写上完整的 ChangeLog  
之前没写的也打算抽空补上  












## 2018.11.03

`inexistence 1.0.8`  
1. **UI：去除是否开启 swap、是否换源、编译线程数量的问题**  
感觉问题有点多，就简化了下，直接使用之前的默认选项（开启 swap、换源、全线程编译）  
对默认设定不满意的，还是可以使用参数来指定  
2. New Feature：添加新参数 `--skip-apps`，可以跳过安装 iperf 等软件  
20181105：实际上没用，还没研究为什么  

`install_deluge 1.0.9`  
1. 修复输入版本还要求你指定模式的问题  
2. Install 改为 Installing  
3. 增加 spinner，并投入使用（进度显示功能）    

`README 1.1.3`  
1. 对应脚本改动更新说明  














## 2018.10.29




`install_libtorrent_rasterbar 1.1.1`  
1. 自动判断各类 branch 所属的版本号  
2. 优化安装时候的文字提示排版  
3. 增加随机数用于下载同一个分支时作区分  
4. 代码排版风格改动  
5. checkinstall 失败后再 make install 一次，解决之前 checkinstall 安装时包名不一致的情况  















## 2018.10.23

`inexistence 1.0.8`  
1. 改了两次 flexget，这次我还是改回原先的，哎  
2. flexget 的 alias 从 `fl` 开头改成 `fg` 开头，`flood` 缩写成 `fl`  
3. 不安装 webmin，反正安装也就是 `rtwebmin` 一句的事情……  

`mingling 0.9.1`  
1. Bump Version  
2. 我好想删掉这货啊。。。  
3. 对应 fg alias 的改动，更新命令说明  

`TCP 2.2.2`  
1. 更新 Xanmod  
apt 安装的为最新的 4.19，输入 4.17/4.18 用 dpkg 安装该版本号最新的内核  
2. 启用卸载指定内核的功能  
3. 修复 Ubuntu 18.04 下安装锐速的问题  
4. **启用删除指定内核的功能**  
5. 可以检测到、删除 PVE 内核  
6. **检查 netboot (Beta)，并作出提示**  
在 Scaleway 上测试过了，并发现现在 netboot 也支持 BBR 了……  
7. 启用 bbr 前运行 `modprobe tcp_$bbrname`  
8. 更新检查普通版 bbr 是否开启成功的方式  
9. 加了 `ls /lib/modules/$(uname -r)/kernel/net/ipv4`，暂时没有测试条件，也不测试了  
10. 对应更新内容，更新 README  





## 2018.10.22

`TCP 2.1.4`  
1. 安装其他锐速内核时，多加几次 apt-get -f -y install  
2. 默认从 apt 安装 3.16.0-43 内核  
顺带一提，事实上现在从 deb 安装的方式是选都没得选的……  
3. 是否加入 trusty-security 源，先做个判断，免得加两遍  





## 2018.10.21

`inexistence 1.0.8`  
1. 修复昨天瞎改后 Flexget WebUI 不可用的问题  

`TCP 2.1.3`  
1. 重要的事情不说三遍了，自己看着都烦  
2. 关于 BBR 是否开启成功的事情，报道上可能会出现偏差，特此说明  





## 2018.10.20

`inexistence 1.0.8`  
1. 从源码安装 2.16.2 版本的 Flexget  
修复一个 bug 引入更严重的 bug 系列  
Flexget 最近的新版本会出现找不到 deluge-client 的问题，当时没想到 pip 安装老版本，从源码装了老版本，但没测试 WebUI ……  

`de2rt`  
1. 更新第二版  
2. 上传 deratio2rt





## 2018.10.18

`TCP 2.1.1`  
1. 由于 apt 安装的时候可能还强行给你塞个新内核进来，因此跑两次删除内核的命令  
2. 闪瞎狗眼，闪烁查看日志的文字提示，重要的事情说三遍  
有的人报错都不提供日志，心累。。。  





## 2018.10.17

`de2rt`  
1. 上传第一版  
2. 去除 tracker 标签功能  





## 2018.10.14

`TCP 2.0.8`  
1. **加入删除指定内核的功能**  
2. **Debian 和 Ubuntu 都默认从 apt 安装内核**
3. 修复 OVH 定制内核在内核列表的显示问题  





## 2018.10.13

`bluray 2.7.6`  
1. **允许在缺少软件的情况下继续运行脚本**  
主要是由于共享盒子缺少 bc 比较麻烦，而 bc 也不是必须  
于是在分辨率计算那边，针对没有 bc 命令的情况作了单独的处理  
2. 更新 README 部分说明，加入 https 直链的介绍  

`TCP 2.0.3`  
1. 3.16.0-4 锐速 apt 增加 headers  
2. **修改 bbr 是否开启的检测方法**  
3. 考虑到有的系统 lsmod 不出 bbr，因此错误时候的提示文字改成了 “可能开启失败”  
4. 修复系统版本号检查时可能出现的 bug  
5. 增加对 OVH 定制内核的检查  
6. 增加从 apt 安装 4.4.0-47 内核的功能，并默认使用这个  
7. 安装 3.16.0-4 内核时隐藏输出  
8. 更新 README  





## 2018.10.12

`inexistence 1.0.8`  
1. Merge PR from Rhilip  
fix auth of transmission miss in flexget config  

`bluray 2.7.5`  
1. 修复手滑  

`jietu`  
1. 修复手滑  





## 2018.10.11

`inexistence 1.0.8`  
1. 修复手滑  

`bluray 2.7.5`  
1. 修复手滑  
2. 加入 nconvert 的安装  

`jietu`  
1. 增加 nconvert 的使用  
2. 修复检测文件是否存在时的判断逻辑  





## 2018.10.10

`inexistence 1.0.8`  
1. **更新 bluray**  
2. 更新 ffmpeg 到 4.0.2（inexistence）  
3. 更新 gclone 命令  
4. 新增 vnss alias  
5. 启用对网卡的检测（之前是为什么关掉了？……）  

`bluray 2.7.2`  
1. **优化运行完成后的排版，BDinfo 改为可选显示**  
2. 更新自带库的 ffmpeg 到 4.0.2  
3. 更新 README  
4. 加入 nconvert  

`README 1.1.2`  
1. 小幅度删减  





## 2018.10.09

`inexistence 1.0.8`  
1. 增加 BDinfoCLI 0.7.5  

`bluray 2.6.9.UHD`  
1. **New Feature：支持 UHD Blu-ray**  
2. **增加 BDinfoCLI 0.7.5**  
3. **UI：改进 debug 模式，界面排版调整，增加信息量**  
4. **New Feature：截图增加 2160p 可选分辨率**  
5. Bug Fix：修复指定分辨率时没有出现默认分辨率数值的问题  
6. 有 root 权限的盒子，安装 ffmepg 时使用 4.0.2 static builds  
7. Bug Fix：修复选择制作含有空 tracker 的种子时无提示信息的问题  
8. Bug Fix：屏蔽 xargs 的错误输出  
9. Bug Fix：修复检查带多个视频轨（Dolby Vision, eg.）的原盘时检测到两个分辨率没有选择第一个分辨率的问题  
10. UI：部分界面调整以及代码缩进调整  





## 2018.10.08

`inexistence 1.0.8`  
1. apt 安装 deluge 时，也安装 deluge、deluge-console、deluge-gtk  





## 2018.10.07

`inexistence 1.0.8`  
1. 社畜的日子……脚本都没怎么动了，要做的事情一堆啊……  
1. **Bump version to 1.0.8**  
这次内容多一些，也好久没更新版本号了，升级下吧 _(:з」∠)_  
2. Bug Fix：修复 qBittorrent 默认版本不是 4.1.3 的问题  
3. 增加安装 socat、jq、iperf  
4. 增加一个隐藏选项，可以安装可以显示硬盘剩余空间的 qBittorrent 4.1.1  
5. qBittorrent 默认连接端口从默认的 8999 改成 9002  
这个操作可以让我判断有多少盒子是用我脚本装的，233  
6. 增加一些 alias  
7. 增加 update-tracker.sh 和 .py，用于 Deluge 配合 Auto-Irssi 使用时解决 Unregistered Torrents 问题  
8. **修复 Debian 9、Ubuntu 18.04 下安装 rTorrent 0.9.6 失败的问题（rtinst）**  
使用了 2018.01.30 的 feature-bind 版本  
9. 更新 ffmpeg 到 4.0.2、rar/unrar 到 5.6.1（rtinst）  
10. **重新启用 Deluge/qBittorrent/Transmission 的反代，新增 Flexget 的反代（rtinst）**  
不过默认网址还是用端口号的。以后可以考虑结合 acme.sh 脚本使用；Flood 反代还有问题，先不管了  

`rtinst`  
1. 修复 Debian 9、Ubuntu 18.04 下安装 rTorrent 0.9.6 的问题  
2. 更新 ffmpeg 到 4.0.2、rar/unrar 到 5.6.1  
3. 重新启用 Deluge/qBittorrent/Transmission 的反代，新增 Flexget 的反代  





## 2018.09.29

`TCP 2.0.0`  
1. **魔改版 BBR 支持 4.16-4.18 内核**  





## 2018.09.26

`inexistence 1.0.7`  
1. 增加 qbt 4.1.3 的选项，并将其设置为默认选项  





## 2018.09.07-08

`TCP 1.9.9`  
1. **安装 3.16.0-4 内核时默认从 apt 安装**  
2. 修复安装 xanmod 时的一些 bug  





## 2018.09.03

`inexistence 1.0.7`  
1. 上班真难受啊…… 盒子也没怎么管，痿得不行，bbr、qBittorrent、libtorrent-rasterbar 折腾来折腾去都残血  
反正这更新日志也没人看的，我就多吐槽一些吧 ←_←  
2. 增加 qBittorrent 4.1.2 的安装选项，并修复了原版 WebUI 可能打不开的问题  
3. qBittorrent 的默认选项设置为 4.1.1  
（其实似乎国内站对一定版本的还没发布的 qb 直接白名单了吧，刚发布几个小时我去测试发现国内主流站点全都支持）  
4. 修复 Flexget 报错时检查密码和检查配置文件弄反了的问题  





## 2018.07.23

`inexistence 1.0.7`  
1. 增加 iotop、htop、atop 的安装  
2. 不生成 SSL 证书  

`TCP 1.9.7`  
1. Xanmod 安装调整  





## 2018.07.16

`inexistence 1.0.7`  
1. 修复 Kimsufi 服务器安装时系统版本号显示不正常的问题  





## 2018.07.06

`inexistence 1.0.7`  
1. 重新加回 rTorrent 0.9.6 feature-bind 版，采用的是 2018.06.06 的版本（2018.06.07 版本号就升级到 0.9.7 了）  

`rtinst`
1. 重新加回 rTorrent 0.9.6 feature-bind 版，采用的是 2018.06.06 的版本（2018.06.07 版本号就升级到 0.9.7 了）  





## 2018.07.06

`inexistence 1.0.7`  
1. 上次改 rTorrent feature-bind 版本改为 0.9.7 后有些其他地方没改，这次修正下  





## 2018.06.28

`inexistence 1.0.7`  
1. Alias：完善 `sshr`，屏蔽 `del` 中 TotalTraffice 的日志部分  
2. rTorrent feature-bind 分支版本号也已改为 0.9.7，同步一下  

`ipv6`
1. 尝试适配 Ubuntu 18.04（尚未测试）  





## 2018.06.09

`inexistence 1.0.7`  
1. **Bump version to 1.0.7**  
2. 增加 rTorrent 0.9.7 的安装选项  

`rtinst`  
1. 支持安装 rTorrent 0.9.7  
2. 代码风格细微改动  
3. 不再强制新系统安装 0.9.6  
4. *粗暴地*修复 `Could not find xxx so using latest version instead` 版本的问题  





## 2018.05.28

`inexistence 1.0.6`  
1. 增加 `dpkg --configure -a`、`apt-get -f -y install` 以防万一  
2. 增加 qBittorrent 4.11 的安装选项  

`install_rclone 1.0.0`
1. 初始化  





## 2018.05.24

`inexistence 1.0.6`  
1. 上传了 `rtskip`  
2. 界面调整，以及注释  

`install_libtorrent_rasterbar 1.0.5`
1. 初始化  
2. 支持选项，可以自定义版本  
3. 隐藏输出，保存到日志  
4. 三个安装模式，deb，仓库，编译  
5. 自动 branch ←→ version 转换  
6. 英文注释（←_←）  

`mima 0.1.2`  
1. 设定密码时检查复杂性  





## 2018.05.21

`inexistence 1.0.6`  
1. **New Feature：显示 ISP／ASN／地理信息，并将其写入到安装日志**  
这个主要是来判断是什么盒子，这样查错的时候更有针对性  
2. 查错信息里加入 `ls /home`  
主要是检查是否存在多用户的情况（多用户某些情况下会出错）  
3. 暂时移除一些目前不启用的功能  
4. 更新了下 BBR 是否启用以及内核是否支持的检查方式  
5. 默认的 IP 检查方式不使用 ifconfig  
6. 先指定 repo、PPA 对应软件的版本号，再检查是否正确  
有可能出现刚开的机器在没有 apt update 的情况下直接 apt-cache policy 会提示找不到包的情况  

`README 1.1.2`  
1. 更新 To Do List、Under Consideration、Known Issues  





## 2018.05.20

`inexistence 1.0.6`  
1. **Bump version to 1.0.6**  
2. 删除不再使用的 BBR 脚本  
3. **New Feature：检查用户名、密码的有效性**  
用户名检查应该没问题了；密码复杂性还不够完善，目前只实现了要求必须同时带字母和数字  
对于常见密码比如 `12345678` 这样的密码还无法识别，以后再改进  

`rtinst`  
1. rar/unrar 的下载目录改到了 /root（避免用户没创建成功时 rar 也没装成功的问题）  
2. 稍微改进了下用户名的输入机制，自动转成小写用户名，同时用了 `--force-badname`  

`README 1.1.1`  
1. 增加参考资料  





## 2018.05.17

`inexistence 1.0.5`  
1. 改了下 IP 检测方式  
不过 Ubuntu 18.04 下可能有问题……  
2. 增加了删除 alias 部分的行数  
以后再研究下怎么精确地改……  





## 2018.05.15

`README 1.1.1`  
1. 更新 to do list  





## 2018.05.11-13

`mima `  
1. **Initial**  





## 2018.05.11

`inexistence 1.0.5`  
1. 增加 Ubuntu 18.04 下修改 /etc/php/7.2/fpm/php.ini 的内存限制  
其实我还没测试过这方面……  





## 2018.05.08 Ubuntu 18.04

`inexistence 1.0.5`  
1. **Bump version to 1.0.5**  
2. **New Feature：Add support for Ubuntu 18.04 bionic**  
主要就是 rtinst merge 原版更新，编译 lt 的 deb 包，检查适配情况  
发现 tr 编译安装 2.92 以前的版本会出错，主要原因在于 OpenSSL 1.1.0，用 Debian 9 的办法无解  
最后对于 2.92 选择 merge 一个包含在 2.93 内的 pr，然后其他版本直接隐藏掉不可选  
此外 wine 的软件源里还没有 bionic 的，因此目前使用 artful 的源代替，测试安装正常  
3. **New Feature：生成可以跳过校验的种子 rtskip 脚本**  
写好了但是还没上传，以后再说 orz ……  





## 2018.05.06

`inexistence 1.0.4`  
1. 把 qBittorrent 的默认安装版本改为 4.0.4  
天空终于支持 qBittorrent 4.X（4.1.0 都支持了） 了，没有理由再用 3.3.11 了  
顺带一提，有的站点连 4.2.0 Alpha 都能用……怀疑是不是所有 qb 都在白名单内  





## 2018.05.05

`inexistence 1.0.4`  
1. New Feature：增加 qBittorrent 4.10 的安装选项  
2. Alias：IO 测试加个空格……  

`mingling 0.9.0`  
1. **UI：显示脚本版本号**  
2. **New Feature：增加 更新脚本 的功能**  
3. **Feature：合并客户端运行情况与操作菜单**  
4. **Feature：一开始不检查 IP 地址与系统信息，加速脚本启动过程**  
5. Feature：Flexget 版本检查实在太慢，直接移除了  
6. Bug Fix：修复客户端操作菜单里 rTorrent 与 Irssi 选项无效的问题  





## 2018.05.03

`inexistence 1.0.4`  
1. Deluge 安装老版本时，仅使用老版本的 deluged，其余使用 1.3.15 的文件  





## 2018.05.02

`inexistence 1.0.4`  
1. New Feature：增加 Transmission 2.94 的安装选项  
2. 安装 flexget 前先安装 markdown  

`bluray 2.4.5`  
1. Bug Fix：-i 参数现在会覆盖 -d 参数了  
2. Bug Fix：-s 参数支持 autoar  
3. New Feature：-t 参数增加 input 类型  
4. New Feature：--no-vcs 参数，跳过缩略图  
5. **New Feature：增加 -p 参数，可以指定 BD 路径**  
6. UI：显示脚本版本号  
7. **UI：高亮显示每个选项的回应**  
8. Known Issues：-t 参数指定 Tracker 可能导致无法制作种子，待修复  





## 2018.04.30

`inexistence 1.0.4`  
1. Bug Fix：针对使用参数运行脚本的情况，修正了下 bbr 的安装逻辑  
即 `--bbr-yes` 的情况下根据实际情况判断是否安装新内核  
2. Bug Fix：增加对 libssl 1.0 的安装以免不满足 4.11 headers 依赖的情况  
3. Bug Fix：qb deb 包 mv 的问题  
4. Alias：改进开启 root 登陆的命令  

`bluray 2.4.0`  
1. **New Feature：增加运行参数**  
d,y,i,s,t  





## 2018.04.29

`inexistence 1.0.4`  
1. Bug Fix：升级系统结束后，在 reboot 后再使用 init 6 重启  

`jietu`  
1. **New Feature：自动判断分辨率后询问是否正确，若不正确则可以手动输入**  

`bdinfo`  
1. Bug Fix：修复 BDinfo 文件名判断错误的问题  

`bluray 2.3.7`  
1. Bug Fix：修复 BDinfo 文件名判断错误的问题  
2. Bug Fix：修复 询问分辨率时实际选项和显示的选项没对上的问题  
3. 截图询问自定义分辨率时，以视频原始分辨率为模板来询问  
也就是说，如果自动计算分辨率出错，要用回原始分辨率的话直接敲回车就行  
说到这个我又想到，我或许可以直接取消这个问题，先设定自动计算，然后询问是否使用这个计算出来的分辨率……  






## 2018.04.26

`inexistence 1.0.4`  
1. **Bump to 1.0.4**  
2. **New Feature：允许从 Ubuntu 14.04 升级到 18.04，允许从 Debian 7 升级到 Debian 9**  
升级前先替换系统源，然后如果垮了一个系统升级的话先升级 apt  
过段时间考虑开始适配 Ubuntu 18.04  
3. checkinstall 安装 qb 的包名改成 `qbittorrent-headless`，补充了更多的 deb 包信息  
为了和别的做区分而故意这么设计的  
4. 已经安装了 qb 的情况下，保险起见还是 make install   






## 2018.04.26

`inexistence 1.0.3`  
1. **Bump to 1.0.3**  
是不是稍微快了点，不过这次 dpkg libtorrent 确实是个很大的变化了……  
2. **New Feature：不再询问 libtorrent 版本，全部指定使用预编译好的 1.0.11 deb 包来安装**  
经过测试，在 Debian 8/9、Ubuntu 16.04 下都可以正常安装  
且在 U2/CMCT 使用 Deluge/qBittorrent 无需任何设置即可同时汇报 IPv6 与 IPv4 地址  
3. **New Feature：统一 libtorrent-rasterbar 的安装参数**  
现在可以同时支持 Deluge 和 qBittorrent 了  
解决办法从 GitHub 里某个 issue 下找来的，修改 libtorrent 源码里的一行就可以了  
这个问题折腾了我好长好长时间，现在终于解决了……  
怎么说呢，要自己看得懂才行，不然都只能请教别人……  
4. Ubuntu 16.04 下 Deluge 的默认选项改为从源码安装的 1.3.15  
主要是为了配合新的 libtorrent 包，并且 Deluge 安装怎么样都很快  
5. **Bug Fix：修复 Ubuntu 16.04 下编译安装 qBittorrent 4.0 后 Deluge libtorrent 失效的问题**  
其实 2/3/4/5 说的是同一件事情……  


`About` 
1. 再次提前写更新日志  
2. 这里是碎碎念时间  
3. 准备好了 qBittorrent 在三个系统下的 deb 包，以后进一步考虑全部使用 deb 包解决？！  
4. 这次重新写了下在 VPS 上编译的步骤，步骤简化+一步到位，省事很多了……  
5. 在 Vultr 5欧 Cloud Compute 上编译 qt 5.9.5 要 240-250 分钟……  
deb 包的体积 270MB 左右，无法直接扔 GitHUb 了  
编译 5.10.1 的话要 300 分钟左右，并且 configure 的时候还会提示缺了三个东西  
最后 checkinstall 只会出来一个十几 MB 的包，dpkg -i 装了这个包的话东西也是不全的……

`README 1.1.0` 
1. 加回以前的一行安装代码  
因为代码精简了，所以长度没有超出了  
2. 更新 libtorrent-rasterbar 的说明  





### About libtorrent-rasterbar
总结下三个系统和 Xenial PPA 自带的 libtorrent-rasterbar 的表现吧：  
Ubuntu 16.04 系统自带的 1.0.7 别的都没问题，qb 编译也能用，就是不支持 OurBits（别的站都没问题）  
Debian 8 自带的 0.16.18 汇报双栈 IP 没问题，但是无法不适配 qBittorrent（版本太老），OurBits 也不支持  
Debian 9 自带的 1.1.1 最尴尬，qBittorrent 编译不支持，给 Deluge 用 bug 也很多……  
PS：OB 最近 https 这方面有改过才导致一些老版本不支持  

来自 Ubuntu 16.04 Deluge PPA 的 libtorrent 1.0.11，有段时间我可以直接 V4+V6，现在不行了，大概包升级了  
这个版本无法用于编译 qb，但如果你 qb 已经编译完了再切换到这个包却又没问题……  
来自 Ubuntu 16.04 qBittorrent PPA 的 libtorrent 1.1.7，我得说 qb 官方更新这个还是很勤快的，现在用的往往是最新版本（3.3 的时候倒是停留在 1.0.11），但是追新不一定是件好事  
目前来看 libtorrent 1.1.X 系列的 bug 还是比较多的，不是很建议使用  

Deluge 目前基本上 0.16 以后的 lt 都能用，但是 1.1 的话用是能用，bug 却很多，比如汇报 tracker 时间显示为无限、无法限制速度等等  
qBittorrent 基本上需要 1.0.7 以后的（0.16 要用于编译好像也不是不行，但是官方说放弃支持了我觉得还是不要考虑了吧），1.1.X 在 qb 3.3 上支持不好；在 4.X 上官方都开始使用 1.1.X 了，然而 1.1.X 本身 bug 比较多……  

如果用 apt 安装的话，Deluge 对应的包是 python-libtorrent，qBittorrent 对应的包是 libtorrent-rasterbar-dev  
不过这两个包其实还是依赖于 libtorrent-rasterbar[789] 这个包，7 对应 libtorrent-rasterbar 0.16 版，8 对应 1.0，9 对应 1.1  

编译安装的话，confugure 的时候 Deluge 必须用上 --enable-python-binding  
qBittorrent 4.0 以后的版本最好用上 CXXFLAGS=-std=c++11（4.0 以前的版本这个不是必须）（不用好像也行，但不用的话 libboost 似乎要用 C++11 才行）  
此外 `--disable-debug --enable-encryption --with-libgeoip=system` 这几个我想或许没有也行？……  

如果要编译个 libtorrent-rasterbar 确保能同时给 Deluge 和 qBittorrent 使用，需要修改源码里的 bindings/python/setup.py 文件  
参考资料：[1](https://github.com/qbittorrent/qBittorrent/issues/6383)、[2](https://github.com/qbittorrent/qBittorrent/issues/6721)、[3](https://github.com/qbittorrent/qBittorrent/issues/7149)






## 2018.04.25

`inexistence 1.0.2`  
1. libtorrent 改为从 RC 分支安装  
2. 编译完后不删除编译时留下的文件（主要是用于 make uninstall）  
3. 修改编译安装时的下载路径  
4. 源码文件夹内记录版本号  
5. 增加一些路径与路径说明文件  

`README 1.0.8` 
1. 更新明天要改的 libtorrent 的内容  

`ChangeLog 0.3.0` 
1. 写了 libtorrent 的一些总结  





## 2018.04.22

`inexistence 1.0.2`  
1. Bug Fix：修复 Ubuntu16.04 可跳过校验的 Deluge 1.3.15 安装失败的问题  
竟然有 issues 了……  





## 2018.04.21

`inexistence 1.0.2`  
1. **Bump to 1.0.2**  
2. 修改 php 内存限制为 512MB  
原先为 128MB，听说这个值改大点 ruTorrent 会更稳定一些  





## 2018.04.19

`bluray 2.3.6`  
1. Bug Fix：修复分辨率算错的问题（乘除数字写反了）  
一行写错要去改 5 个地方 orz  

`jietu`  
1. Bug Fix：修复分辨率算错的问题（乘除数字写反了）  

`README 1.0.7`  
1. 更新 Transmission 的说明  
2. 更新 Deluge 插件的说明  
3. 增加一处参考资料  






## 2018.04.18

`inexistence 1.0.2`  
1. **Bump to 1.0.2**  
昨天没跳版本号那只能今天跳了  
2. Bug Fix：更新 mkvtoolnix repo 源  

`bluray 2.3.6`  
1. Bug Fix：修复分辨率算错的问题（又乘了一次高度比）  

`jietu`  
1. Bug Fix：修复分辨率算错的问题（又乘了一次高度比）  






## 2018.04.17

`inexistence 1.0.1`  
1. Opts：Deluge/qBittorrent 跳过校验的选项修复  
2. 增加 Debian 8 安装 qt 5.5.1 deb 包的选项（不启用）  
以后这个可以用于在 Debian 8 下编译安装 qBittorrent 4.0  
3. Code：高亮部分调整  
4. Bug Fix：修复 h5ai 有些文件夹访问不了的问题  
不给 777 权限还不行（给 666 不行……）  
5. Bug Fix：修复美化版 Transmission 安装脚本没有安装成功的问题  
作者这几天改进了脚本，因此无交互安装也要改一下……  
6. **New Feature：支持在 Debian 8 下编译安装 qBittorrent 4.0**  
采用安装 deb 包的方式解决系统源 qt 过老的问题  

`bluray 2.3.5`  
1. **改进了自动分辨率计算，使用 bc 代替 expr，由于考虑带小数点运算因此结果更精确**  
原先 720x480，DA 16:9 算出来分辨率是 848x480，现在算出来的是 854x480  

`jietu`  
1. 改进了自动分辨率计算，使用 bc 代替 expr，由于考虑带小数点运算因此结果更精确  
原先 720x480，DA 16:9 算出来分辨率是 848x480，现在算出来的是 854x480  

`zuozhong`  
1. 修复了手动输入链接不可用的问题  

`README 1.0.5`  
1. 更新 Transmission 跳过校验的 Opts 写法  
2. 更新 qBittorrent 安装的说明  





## 2018.04.16

`inexistence 1.0.1`  
1. **Bump to 1.0.1**  
2. 修改 rtinst 装的 h5ai 的位置，现设定为 `/var/www/h5ai`  
这样可以不用管 /var/www 路径下那些多余的东西了  
3. Bug Fix：修复 flexget 安装失败的问题  
以前都没问题的，pip 更新后，位置变成了 `/usr/local/bin/pip`，只在脚本里用 pip 的话会定位到以前的 `/usr/bin/pip` 于是就失败了  
4. UI：Flexget 安装完后使用 `flexget daemon status` 检查运行状态，同时状态里增加需要检查密码和配置文件的类型  
5. Opts：增加 Tr 跳过校验版本的 Opinions `--tr-skip`  
6. UI：部分文字高亮和换行调整  

`rtinst Aniverse Mod`  
1. 修改 rtinst 装的 h5ai 的位置，现设定为 `/var/www/h5ai`  

`README 1.0.2-1.0.4`  
1. 更新“无责任”部分  
2. 更新安装命令  
原先的长度太长用不了了，真蛋疼……  
3. To do list 更新  
增加 `Banben` 和一些说明
4. 增加一处参考资料  






## 2018.04.12

`inexistence 1.0.0`  
1. 更新可选的 libtorrent-rasterbar 版本到 1.1.7  






## 2018.04.10

`inexistence 1.0.0`  
1. rtupdate 编译时候的线程数量采用之前设定的数量  

`rtinst Aniverse Mod`  
1. 同步原作者的改动  





## 2018.04.09

`inexistence 1.0.0`  
1. 去除对于 Flood 安装成功与否的判断  
还有些问题，以后再说吧，写论文没空……






## 2018.04.08

`inexistence 1.0.0`  
1. 在日志里增加最大硬盘分区的记录  

`README 1.0.1`  
1. 增加软 RAID 升级系统后 IO 可能暴降的说明  






## 2018.04.06

`inexistence 1.0.0`  
1. Bug Fix：修复了 Deluge SSL 判断的问题  
2. Bug Fix：修复了 Deluge 1.3.15 skip hash check 安装失败的问题  
3. UI：最后安装完成界面调整，长度对齐，“缩进”对齐之类的  
4. 部分 chmod 777 改成 666  
5. **禁用反代**  
反代还导致 h5ai 出了点问题，暂时先禁用了  

`rtinst Aniverse Mod`  
1. 修改 h5ai 软链 rt 下载路径的名字    
2. **禁用反代**  





## 2018.04.04

`inexistence 1.0.0`  
1. Bug Fix：修复多创建了 /home/$ANUSER/qBittorrent(大写)，/home/$ANUSER/download, /home/$ANUSER/watch 目录的问题  
2. 将 Ubuntu 16.04 下 Deluge libtorrent 的默认版本改为从 PPA 安装  
似乎 OB 用了 TLS 1.2 后，系统源自带的 libtorrent 1.0.7 会连不上 Tracker  
3. Alias：只用成功修改设置的情况下 sshr 才输出修改成功  






## 2018.04.04

`inexistence 1.0.0`  
1. UI：升级系统后重启的提示修改了下；重启失败的话可能会有提示可能没有，这个情况不多见不好测试  
此外修正了一个拼错的单词……  

`IPv6`  
1. Bug Fix：看下面的吐槽  
不知道为什么这次我自己在 Debian 8 下跑了好几次都不成功，ifup 就行了，restart networking 还直接搞断网了，我不得不 IPMI 连上去重启了下网络……  
这样的话还是用回 ifup 算了，蛋疼  






## 2018.04.03

`inexistence 1.0.0`  
1. Bug Fix：暂时禁用 De/Qb 的反代  
原来 qb webui 图标显示不出来也是反代的问题。由于不懂 ngnix 所以这个暂时先搁置了吧，之前算是瞎折腾了  
2. 增加 lolcat 的安装  

`IPv6`  
1. New Feature：对于没有 `systemctl` 的，仍然使用 `ifdown` `ifup`  

`BDinfo`  
1. 修复文件名不对导致最后无法输出结果的问题  
2. 最后不经询问直接输出结果  
3. 改进一些写法  

`README 1.0.1`  
1. 更新 IPv6 部分的说明  
2. 说明 qb 的隐藏选项  
3. 说明 de/qb/tr/rt `No` 不安装的写法  






## 2018.04.02

`inexistence 1.0.0`  
1. Bug Fix：创建 qb 的日志文件  





## 2018.04.01

`inexistence 1.0.0`  
1. Bug Fix：启用 qb webui 的本地认证  

`IPv6`  
1. New Feature：使用参数的情况下也可以自动检测网卡  
2. UI：使用 jiacu 代替 white  





## 2018.03.31

`inexistence 1.0.0`  
1. Bug Fix：修复 qBittorrent WebUI 因为反代跳过了账号密码验证的问题  





## 2018.03.29

`inexistence 1.0.0`  
1. 还是加了个 speedtest-cli 的安装  
下一步原先那个可以删了，不需要 beta 的输出了……  
2. Code：部分调整  





## 2018.03.28

`inexistence 1.0.0`  
1. UI：脚本结尾处界面调整  
2. **UI：检查安装完成后客户端是否在运行**  
之前忘记写这个了，这次写吧，反正这次也做了很多调整  
3. rTorrent 输出自签的证书  

`MinGLiNG 0.8.6`  
1. 界面微调  

`README 1.0.0`  
1. **Bump to 1.0.0**  
2. **inexistence 和 mingling 重新截图**  
就截图+修改界面弄了我将近 2 个小时，醉了醉了……  
尽量调整宽度也统一……以后截图需要注意宽度了  
从现在开始截图文件直接存放在本项目下好了，反正也没多大  
3. **增加 Opinions 的说明**  
4. **增加 swap 的介绍**  
5. **重新加回 Usage**  
6. **去除不希望被宣传的声明**  
随它去吧……多点人测试也没啥不好  





## 2018.03.27

`inexistence 1.0.0`  
1. **Bump to 1.0.0**  
2. **调整 rTorrent，增加不支持 IPv6 的 rtorrent 0.9.6**  
3. **调整脚本安装选项**  
--enable-ipv6，--yes，以及 de/qb/tr ppa/repo 版本的输入  
4. UI：输出文字调整  
5. 增加 unrarall 脚本  
6. Bug fix：Flexget 密码没设置好时提示用户  
修了好几次终于搞定了……不知道为什么变量无法传递过去……  
7. **New Feature：安装完成后检查客户端是否在运行**  
又改了好久的排版，包括 Flexget 账号、密码部分  
8. **New Feature：增加对于架构的检查，不支持非 x86-64 架构**  





## 2018.03.26

`inexistence 0.9.9`  
1. Alias：rt 使用 -k 参数强行关闭  
2. Code：排版调整  
3. 删除 rTorrent 一些已经集成到 `rtinst` 的代码  
4. Bug Fix：修复 Deluge libtorrent 默认选项判断的问题  
5. **New Feature：脚本选项、参数**  
具体哪些选项以后再单独在 WiKi 写  
6. **New rtinst：重写的 rtinst，不再需要多个分支**  
此处具体请看 rtinst 项目  
7. **rTorrent 版本新增 0.9.2 与 0.9.3，包括对应的 IPv6 版本**  

`MinGLiNG 0.8.6`  
1. 客户端操作菜单：同步 `inexistence` 的改动，对于 `rt` 使用 `-k` 参数强关  

`README 0.8.0`  
1. 对应 `rtinst` 的改动，更新说明  
2. 增加参考资料  





## 2018.03.25

`inexistence 0.9.9`  
1. rtinst 维修中，暂无法使用  





## 2018.03.24

`inexistence 0.9.9`  
1. Deluge auth 的信息改为追加方式写入  





## 2018.03.23

`inexistence 0.9.9`  
1. Code：DeBUG 密码、其他微调  
2. Bug fix：修复公网 IPv4 地址未检测到那边 `||` 和 `&&` 没用对的情况  
虽然我还从来没碰到过会触发这个 bug 的情况  
3. Output：升级的话显示 upgradation 花了多少时间，而不是 installation  
4. Alias：`vms` 改成 1 秒更新 1 次  

`MinGLiNG 0.8.6`  
1. 启用 systemreinstall  
虽然我还没写好……    
2. Usage：更新部分 alias
vns, iotest, vms, yongle, sshr, cronr  
3. Code：写法微调  

`README 0.7.9`  
1. Under Consideration 那一块  
2. 去掉 mingling 的 usage  
4. 加了一堆空格，写的时候看上去舒服点，GitHub 上也看不出来因为会吞掉  
3. 其他微调  

`zuozhong`  
1. 增加署名  
2. 从 `bluray` 那同步关于 tracker 的代码  





## 2018.03.21

`inexistence 0.9.9`  
1. Code：root 检查在 DeBUG 模式下会跳过，同时修复了非 root 时提示语没有应用色彩样式的问题  
2. UI：询问是否升级系统处，彩色化系统文字部分  
3. DeBUG 模式下，跳过对于 root 的检查  
4. 在 BDinfo 文件夹下创建到 wine DVDFab10 BDinfo 的软链  

`Blu-ray 2.3.3.3`  
1. **New Feature：检查 pathtostuff 下是否有 ISO 存在**  
主要应对首发原盘的情况  
2. DeBUG Mode：补充了一些输出信息，调整界面  
3. **UI：${white}→${jiacu}**  
4. 有多余文件的情况下默认选择不复制  
5. Bug Fix：优化判断 main_m2ts 的逻辑，只选择 m2ts 文件  
因为发现如果是 MGVC 的 BDISO，挂载了以后最大的可能是 bin 文件而不是 m2ts  
6. Bug Fix：file_title_clean 去除斜杠，同时修复 BDinfo 命名问题  

### Blu-ray MGVC
这次对于比较少见的 MGVC 做了下测试，在此做个“测评报告”  
1. 首先发现了之前判断 main_m2ts 的逻辑有问题，已修复  
2. BDinfoCLI 扫出来的信息总体和 DVDFab 一致，只是 DiscSize 那边大概是两倍左右的体积（不过 DVDFab 其实是扫直接扫 BDISO 而不是 BDMV 的）  
3. DVDFab 也不会显示 MGVC 相关的特殊信息，可能只有松下的机器才能认出来？  
4. 是否需要考虑针对 MGVC 原盘，默认选择不重新做种？（靠检测里面是否有 KDM 文件夹？）  

`MinGLiNG 0.8.5`  
1. **UI：${white}→${jiacu}**  
2. 对于多个 CPU 可以显示正确的核心数量，并显示是双路、四路还是八路  
3. Code：去掉部分变量用到的双引号和大括号  
4. TuCao：其实都是同步 `inexistence` 的改动而已  
5. DeBUG，还没正式写入，只是先复制粘贴一下  

`BDjieTU`  
1. 其实这个已经不用了，不过顺手更新下也不难  
2. UI：${white}→${jiacu}  
3. 增加署名  
4. Bug Fix：优化判断 main_m2ts 的逻辑，只选择 m2ts 文件  
5. Bug Fix：file_title_clean 去除斜杠  
6. Code：简化写法  
7. New Feature：自动根据时长确定截图时间间隔  
8. 分辨率还是用以前的 1920x1080 算了  

`TCP 1.1.0`  
1. **New Feature：可安装自定义内核及其头文件**  
不过似乎 4.15 的头文件装不上……  
2. UI：调整  

`BDinfo`  
1. UI：${white}→${jiacu}  
2. Author & Date  
3. Bug Fix：file_title_clean 去除斜杠，同时修复 BDinfo 命名问题  

`xianSu`  
1. UI：${white}→${jiacu}  
2. Author & Date  

`GuaZAI`  
1. UI：${white}→${jiacu}  

`JiEGuA`  
1. UI：${white}→${jiacu}  






## 2018.03.20

`inexistence 0.9.9`  
1. Bug Fix：修复 Flood 无论如何都会被安装的问题  
2. 修复 Virt-what 无法正常运行的问题  
还是不用 cat，选择 wget 回来……  
同时修改了下 virt-what 脚本的输出  
3. Code：提前了 root 检查部分，以及缩进调整  
4. 对于多个 CPU 可以显示正确的核心数量，并显示是双路、四路还是八路  





## 2018.03.19

`inexistence 0.9.9`  
1. Bug Fix：修复 UseTweaks 选项直接跳过的问题  






## 2018.03.18

`inexistence 0.9.9`  
1. **Bump to 0.9.9**  
2. UI：把一些安装完成的步骤改得更明显，然后 deluge 的编译日志还是去掉了  
3. Code：换行、排版、去除双引号  
部分 while 改成 if  
4. **Bug Fix：编译安装 libtorrent-rasterbar 时若系统总内存小于 1900MB 则使用 swap**
5. **Bug Fix：修复 Debian 9 下 Deluge 和 qBittorrent 一起安装时 libtorrent 冲突的问题**  
首先发现 VPS 编译 libtorrent-rasterbar 可能出现内存不足的情况，先加了 swap  
然后发现其实以前写的 DeQbLT 之类的判断逻辑不太对，应该先全部认定是 No，再把 Yes 的情况写出来  
然后这样子总算是解决了  
忍不住再吐槽一次，真是麻烦…… 用编译好的多省事啊……  
6. **New Feature：内存较小时默认使用 swap**  
7. **Code：竟然有 3000+ 行了……**  
虽说好多是注释和空格，不过感觉也不少了……  
8. **Interactive：Deluge libtorrent 没选择默认选项的话弹出警告，要求用户再次确认**  
9. UI：询问版本时，which version of deluge，完整点  
10. 添加 rclone.service  
11. bash.bashrc：颜色设置、`iotest` 命令  
12. **用 cat 添加 `Virt-what` 并用于检测虚拟化技术**  





## 2018.03.17

`inexistence 0.9.8.17`  
1. **New Feature：询问问题询问前使用 while**  
为以后使用参数，以及 DeBUG 模式作准备  
写完了以后我才意识到为什么我要用 while 呢，用 if 不是也可以么……  
2. **Bug Fix：修复 Debian 9 下 Deluge 和 qBittorrent 一起安装时 libtorrent 冲突的问题**  
其实并没有修复成功←_←  
3. **Bug Fix：安装 flood 时若系统总内存小于 1900MB 则使用 swap**  
4. Bug Fix：修复 Deluge PPA libtorrent 版本判断不正确的问题  
5. UI：闪烁提示 libtorrent-rasterbar 不要乱选  
6. **Code：换行、去除双引号**  
从行数上来说这次行数变动很大 lol  
去除了所有的 ${white}，这下在白底黑字的情况下终于正常了  





## 2018.03.16

`inexistence 0.9.8.11`  
1. remove `export $TOP_PID_2=$$`  

`README 0.7.6`  
1. 增加升级系统的图  

`TrCtrlProToc0l 0.8.0-1.0.7`  
1. 界面调整  
2. 修复安装 BBR 没有成功安装固件的问题  





## 2018.03.15

`inexistence 0.9.8.10`  
1. **New Feature：-d 参数**  
-d：开启 DeBUG 模式。同时 DeBUG 下升级系统后不重启，方便跑 TCP 脚本  
2. alias：修改 `sshr` 的输出  
3. 增加对于 `rsync` 与 `build-essential` 的安装  
4. 修改了 firmware 的下载地址  
5. UI：优化了升级系统时的一些提示的显示效果  

`mingling 0.8.2`  
1. 同步 `TCP` 脚本的修改  

`TrCtrlProToc0l 0.8.0-1.0.3`  
1. 改了太多东西，懒得写了……  





## 2018.03.14

`inexistence 0.9.8.6`  
1. **alias 部分从 `/etc/profile` 改到 `/etc/bash.bashrc`**  
解决了非登录式 shell 下 alias 不可用的问题  
此外追加了一些 alias，添加了删除之前写入的内容的命令，只不过根据行的数量来删除，可能会有误删除的情况  
我在想是不是用 for 之类的来检查比较好？或者把 alias、export 带头的全删了之类的？  
2. `apt-get -y autoremove`  
3. 修改了 locks 的位置，补全 locks  
4. **BBR 不使用脚本安装**  
本来也没几步，就自己写了；内核固定为 4.11.12，方便之后安装魔改版 BBR  
5. UI：不屏蔽 apt 安装时的输出  
6. Bug Fix：修复 Flexget WebUI 密码没有设置好时没有提示的问题  
用 || 也没用，不返回 1，似乎只能根据输出内容判断了  
此外还有个问题，deluge auth 的密码太简单也不行，似乎不生效，然后 flexget 配置文件检查就失败了，就导致 flexget 没法正常运行，真是蛋疼……    

`mingling 0.8.1`  
1. 同步 `inexistence` 的改动，修改了判断方式  

`README 0.7.2-0.7.5`  
1. 去掉了一些分隔线  
2. BBR 部分改动  
3. mingling 增加了更新方法  
4. 更新不希望被宣传的说明
5. 其他小改  
6. 其实一般来说应该是稍微改了点就跟进一个版本号……  





## 2018.03.12

`inexistence 0.9.8`  
1. **Bump to 0.9.8**  
2. 增加 `debconf-get-selections`、`debconf-set-selections`、`besttrace`、`uuid` 的安装  
3. 增加 lock 文件，以后用于判断是否安装了某些软件/功能  

`mingling 0.8.0`  
1. **Bump to 0.8.0**  
2. **Code：大幅改动了已有代码的写法，部分优化**  
从 1000 多行砍到了 500 多行  
5. **UI：取消了隐藏光标的设定**  
老是有人以为卡死了，尴尬，取消了算了……  
4. **Usage：更新了部分 Usage 的说明**  
5. **Clients：使用 rtinst 的 rt 脚本代替了 rTorrent 的 systemd，并加入了 irssi 开关**  
6. **Clients：选项增加到 24 个**  
7. **Scripts：大致做了个样子，更正了写法，更新了一些内容**  
To be completed ...  
8. 更换了 IPv6 的检测地址  
9. 修复部分 bug  

`README 0.7.1`  
1. 错字更正，增加参考资料  

`ChangeLOG 0.2.1`  
1. 2017.12.07-2018.03.12  
2. 201710XX-20171015  
3. **三级标题改成二级标题**  
然后 GitHub 的 Markdown 会加上一个分隔线  





## 2018.03.11

`inexistence 0.9.7.9`  
1. UI：Flexget Webpass 若设置失败则提示手动设置  
2. UI：在一开始就检查系统源和网站上的软件版本，免得之后会卡一会儿  
3. **UI：每个软件安装完后的提示语彩色化**  
4. /etc/profile：加入 setcolors 的 function  
私货  





## 2018.03.10

`inexistence 0.9.7.8`  
1. **New Feature：Flood Installation**  
2. **UI：de/qb/tr 的选项，显示来自 repo 的具体版本号**  
从 PPA  安装时也能显示最新的版本号（查询得来）  
由于要查版本号所以上个选项答完了以后会卡一下  
3. Bug Fix：换了个 IPv6 检测的网站  
原先那个突然大姨妈了  






## 2018.03.09

`inexistence 0.9.7.6`  
1. **New Feature：对于 Debian 7 和 Ubuntu 14.04，可以用脚本升级到 Debian 8 和 Ubuntu 16.04**  
采用无交互的方式升级系统，应该不会再碰到各类询问你要怎么办的问题了  
升级完后显示所花费的时间，然后直接重启盒子，提示重启后再运行一次本脚本  
2. **Bug Fix：修复一开始 !/bin/bash not found 的报错**  
Linux 下 nano 粘贴上去再把脚本下回来就行，只是之前没有分段粘贴，整段粘贴内容太多塞不下，然后也有点偷懒就一直拖到现在；此外我以为 Windows 的 Notepad++ 编辑完后又会变回去，结果并不会，这下以后可以放心了  
3. **完善判断系统的代码**  
4. Code：换行调整，去掉一些双引号，一些单括号改成双括号  
5. UI: rTorrent 的安装提示也会安装 ruTorrent, vsftpd, h5ai, autodl-irssi  
6. **UI: 修正 SSH 客户端因为宽度不够导致一些文字畸形的问题**  
真是蛋疼，为此又用回了以前的 `echo -ne;read respinse`  
7. UI: 从 repo 安装软件时，版本号会从系统里自行判断  
8. UI：对于 Ubuntu 16.04 安装了 VNC 的，会显示 8 位的 VNC 密码  
9. UI：调整 VNC 可能翻车的错误提示，调整 libtorrent-rasterbar 处的选项名  

`README 0.7.0`  
1. 增加对于升级系统选项的描述  
2. 删除 `alias wget="wget --no-check-certificate"`  





## 2018.03.05

`inexistence 0.9.7.1`  
1. **Bug Fix：更换 ffmpeg 的下载链接为 GitHub 的链接，增加 -O 参数，版本改为 3.4.2**  
2. UI：确认信息处增加 mono 和 wine 的选项  
3. qBittorrent 3.3.11 的修改版增加一个 IO 显示 的 cherry-pick  

`README 0.6.9`  
1. 小修小补  

`WiKi`  
1. 碎碎念 Ver 0.2  
2. add Chinese title  





## 2018.03.04

`inexistence 0.9.7`  
1. **Bump to 0.9.7**  
2. **New Feature：安装 VNC**  
搞了好几个小时了还是没搞定，某些情况下没问题某些情况下死活连不上，(╯‵□′)╯︵┻━┻  
3. **New Feature：安装 X2Go**  
还是 X2Go 简单，就决定是你了！
4. **New Feature：安装 wine**  
5. **New Feature：安装 mono**  
6. **New Feature：Uploading ToolBox**  
安装最新版 ffmpeg、mkvtoolnix、mediainfo、eac3to，以及 mktorrent  
配合远程桌面就可以在盒子上做 Remux 了  
7. **New Feature：DeBUG**  
8. UI：系统不支持时提示字体改成粗体，DISABLE 界面去掉感叹号，deluge libtorrent 去掉一些提示  
9. TuCAO：我下次想又想往前进一个版本号了……  

`README 0.6.8`  
1. **补充了三个新选项的介绍**  

`WiKi`  
1. 碎碎念 Ver 0.1  





## 2018.03.03

`inexistence 0.9.6`  
1. qBittorrent 的 libtorrent-rasterbar 若要编译，所用分支从 RC_1_0 改成了 libtorrent-1_0_11  
2. 使用 rtinst 的 rt 脚本来管理 rt 和 irssi 的 alias 命令  
3. 加入了搜索的 alias  
4. 提示报错信息时加入了 jiaobenxuanxiang  
5. **加入了 DISABLE=0，若启用的话则脚本无法正常运行**  
目前不启用  

`README 0.6.5`  
1. 去除了 Usage  
2. 去除了 bdjietu  
3. 完善了其他的一些内容  





## 2018.03.01

`inexistence 0.9.6`  
1. New Feature：如果 rtorrent 已经安装则使用 rtupdate 更换版本  
2. 如果已经安装了 Transmission 或 qBittorrent，则本次安装采用 make install  
3. 修复 cesu2 和 jiaobenet 的 alias  
4. 网址检查设定了 6 秒的时限  
5. 内部排版修改  

`rtinst`  
1. 从 GitHub 下载 xmlrpc  
rtinst 作者指定的那个源这几天老是大姨妈，索性换了  





## 2018.02.23

`inexistence 0.9.6`  
1. Bug Fix：修复 Deluge 选项不管怎么选都采用默认选项的问题  
看来有的东西不能乱改  
2. UI：提示 Flexget WebUI 的用户名是 flexget  





## 2018.02.22

`inexistence 0.9.6`  
1. Bug Fix：修复安装包失败后没有退出的问题  
修了三次，换了个姿势终于修好了 orz  
2. UI：改进退出脚本以及提示跳过系统检查时的提示文字  

`bluray 2.2.2`  
1. **RENAME to bluray**  
1. **Bump to 2.2.2**  
这种东西的版本号其实就是随便写的  
2. New Feature：在制作种子时可以选择暂时移除非必要的文件  
因为 mktorrent 不支持跳过某些文件，所以只能先把文件移动到别的地方去了  
一般这些文件都是 ANY!、FAB!、!UHD、MAKEMKV、disk.inf 之类的  
3. New Feature：制作种子时候可以指定 Tracker  
默认为空 Tracker，等站点自己修改  
因为 HD-Torrents 必须写自己的 Tracker，所以单独为 HD-T 设计了一个选项  
还有 Public Trackers 的选项，预设里写了 16 个公开的 Trackers  
最后一个就是自定义 Tracker 的选项，不过自定义的话只能写一个 Tracker  





## 2018.02.21

`inexistence 0.9.6`  
1. **增加 Transmission 2.92/2.93 跳过校验、破解文件打开数限制的版本**  
隐藏选项11和12分别对应修改版的2.92/2.93  
注意：跳过校验有风险，使用修改版客户端有风险，用不用自己看着办  
2. 增加安装 ca-certificates  
3. 不知道有没有修复包安装失败时没有 exit 的问题  

`README 0.6.3`  
1. 更新了几个隐藏选项的说明  
2. 修改了使用说明  




## 2018.02.19

`jietu 2.1.0`  
1. 检测 ffmpeg 和 mediainfo 命令是否可用  
2. 检测是否有 root 权限，没有的话则要求必须自定义输出路径
3. New Feature：允许自定义输出路径

`guazai 2.0`  
1. New Feature：三种模式：当前路径寻找 ISO 挂载，指定路径寻找 ISO 挂载，挂载指定 ISO  
2. UI：界面改进，提示挂载模式
3. ToDo：目前失败了也不会有提示，并且没有检测是否为 ISO 文件
4. TuCao：然而 ToDo 的功能我大概是懒得做了……

`jiegua 1.0`  
1. NEW：统计当前已挂载 ISO 数量，批量解除挂载  

`rtinst`  
1. 去掉了某些冗长且无用的输出信息  
2. 同步原作者代码，去掉了对 python-software-properties 的安装  

`README 0.6.3`  
1. **更新了 jietu、guazai、jiegua 安装脚本的说明和截图**  
2. **修改了使用说明**  





## 2018.02.16

`inexistence 0.9.6`  
1. **Bump to 0.9.6**  
2. 其实这次单独而言没多少更新（不过相较 0.9.5 第一版还是有不少更新的），但就是想更新下版本号，新年了 ……  
3. 增加安装 qBittorrent 4.0.4 的选项  
4. BugFix：修复选择安装 qBittorrent 4.0.X 时候 Debian 9 和 Ubuntu 16.04 没提示文字的情况  
5. 吐槽下，最近主要在弄 bdupload  

`bdupload`  
1. **Bump to 2.0.8**  
2. 合并 bdupload-FH 分支  
3. New Feature：可以在非共享盒子上运行  
4. New Feature：NoInstall=1，允许每次都自动使用内置软件库  
5. New Feature：RCLONE=1，允许使用 rclone 备份生成的文件  
6. New Feature：DeBUG=1，允许输出更多的信息用于调试  
7. New Feature：CustomedOutput=1，允许自定义输出路径  
8. New Feature：判断是不是 UHD Blu-ray，是的话提示不支持，要求重新输入  
9. New Feature：判断文件夹下是否有 BDMV 文件夹存在  
10. New Feature：检测 DAR，默认使用 DAR 的分辨率，如不满意该分辨率也可以自定义分辨率  
11. UI：每一步操作完成后输出 DONE，每一张截图完成后输出 DONE  
12. 是否创建缩略图改成单独的问题  
13. 截图时间间隔修改  
14. 精简部分代码  
15. 运行完毕后输出 BDinfo QuickSummary （如果扫描了的话）

`jietu`  
1. Bump to 2.0.0  
2. New Feature：支持输入文件夹，会自动寻找文件夹里最大的文件来用于截图  
3. New Feature：可以不指定分辨率，脚本会自动计算 DAR 后的分辨率用于截图  
4. New Feature：判断视频时长，从而改变截图时间点  
5. UI：界面改进，在截图前先打省略号，完成后输出 done  
6. 主要代码都是 bdupload 小改一下  
7. 下次可能加入指定输出路径的功能，需要自己修改脚本  





## 2018.02.14

`inexistence 0.9.5`  
1. BugFix：修复系统不是 Debian 8 也会提示 qb 4.0 无法编译的问题  
2. BugFix：修复 libtorrent 选项默认选项显示不正确的问题  
3. BugFix：修复某些情况下可能 qb patch 没打上的问题  
4. **BugFix：修复 Deluge libtorrent 安装判断逻辑的问题**  
5. BugFix：修复安装失败时 tr 失败输出成 rt 日志的问题  
6. 舍弃了 Deluge 编译时候 install 的非错误日志  





## 2018.02.13

`inexistence 0.9.5`  
1. 排版上部分采用了 ; }  
2. 修复 available 单词拼错的问题（没人报错？！）  
3. **重新设计了 Deluge libtorrent 的选项**  
- 考虑到有的时候可能会用脚本更换 Deluge 的版本，因此加入了不再安装 libtorrent 的选项（需要检测到已安装 deluge 才会显示这个选项）  
- 此外，Ubuntu 系统也可以用来自 Deluge PPA 的 python-libtorrent，再另外编译自己需要的 Deluge 版本，因此加入了从 PPA 安装的选项  
- 选择从系统源和 PPA 安装的话也会输出要安装的版本号提示  
- 加入了可以自定义版本的功能，输入版本前会显示所有在 GitHub 上能下载的分支，不过能不能装上以及有没有 bug 是另一回事了  
- 原先的 RC_1_0 之类的分支改成了 0.16.19 1.0.11 1.1.6 这样的版本，同时让 DELTPKG 自动检测版本号  
- 修改了下默认选项的写法，感觉比之前好看一点  
5. 修复替换系统源，wget 文件时没有用 --no-check-certificate 导致可能出错的问题  
6. 修复安装包失败时，脚本没有退出，继续往下运行的问题  
7. 部分输出内容很冗长的，丢弃掉错误输出以外的部分  
8. qBittorrent 编译 libtorrent 时，只在 Ubuntu 16.04 下采用 C++11 模式  
9. checkinstall 前先做 dpke -r，减少可能存在的重装时翻车的可能性（但还未经测试……）  
10. checkinstall 后生成的安装包都会被存放到 /etc/inexistence/01.Log/INSTALLATION/packages 目录备用  
11. Transmission 编译 libevent 从 checkinstall 改回了 make install  
12. 部分 alias 调整，新增部分命令，举例如下：  
- sshr 重启 SSH，并开启 root 登陆  
- cronr 重启 cron  
- deyongle 检查 deluge 默认下载路径占用的硬盘空间  
13. 安装如有失败，在最后提示如何检查安装日志  






## 2018.02.08

`rtinst Aniverse Mod`  
1. 修复 Ubuntu 16.04 下 Autodl-Irssi 安装不正确的问题  
因为没安装 php-xml  

`ChangeLOG 0.2.0`  
1. 2017.12.07-2018.02.08  
2. 201710XX-20171015  





## 2018.02.05

`inexistence 0.9.5`  
1. 又是 libtorrent-rasterbar 的问题
没有完全修复，不知道怎么修，只能先提示用户没事不要去编译 libtorrent-rasterbar 1.0.11 给 Deluge 用  
不过 Debian 9 下就是个问题了，因为自带的 lt 有 bug，估摸着要取消 C++11 了……





## 2018.02.02

`inexistence 0.9.5`  
1. 对一些选项进行重新编号  
2. 增加能够跳过校验的 Deluge 1.3.15 的隐藏选项  
**一切后果自负**  
3. 增加 Deluge 1.3.5-1.3.9 的隐藏选项，修复了这些旧版 Deluge SSL 连接的问题  
SSL 的修改代码和 Deluge 1.3.11 的一样  
4. Transmission 的无限打开文件数版本改到了 31 选项，目前还在测试阶段  
5. 修复了 Deluge libtorrent 判断的问题  
6. 密码长度要求降低到至少 8位  
7. 已知问题：Transmission 无限打开数版本编译失败，以后看情况处理  

`IPv6`  
1. 加上了删除之前的 net.ipv6.conf.$INTERFACE.autoconf 的命令  

`README 0.6.0`  
1. **更新了 inexistence 安装脚本的截图**  
2. 补充、修正了一些内容  

`ChangeLOG 0.1.2`  
1. 暂时先空着  





## 2018.02.01

`inexistence 0.9.5`  
1. **Bump to 0.9.5**  
2. 优化界面  
3. 修复系统检查无效的问题  
4. **通过修改脚本开头的 SYSTEMCHECK=1，允许跳过系统检查**  
只不过 bug 我就不管了  
5. 修复录入用户名输入 No 后无限循环的问题  
6. **支持在 Debian 9 下编译 Transmission**  
7. **支持在 Ubuntu 16.04 下编译 qBittorrent 4.0**  
8. 使用 checkinstall 代替 make install，并写入对应的版本号  
9. **尝试使 Transmission 突破 1024 打开数的限制**  
因为可能存在问题，所以改成了需要手动输入版本的时候才会生效  
10. 隐藏安装 libtorrent-rasterbar 0.16 分支的选项  
11. 优化了检查 qb 版本是否大于等于 4.0 的判断方法  
12. **qBittorrent 安装部分重新编号，增加了可以跳过校验的 3.3.11 版本**  
**一切后果自负**  
13. IPv6 地址的检测时间增加到 8 秒  

`IPv6`  
1. **使用 systemctl reload-or-restart networking.service 代替 ifdown && ifup**  
应该没问题了吧，心情复杂  
2. 加上了脚本的修改日期  

`xiansu`  
1. 对应 IPv6 脚本，更新了网卡的检测方式  

`README 0.5.8`  
1. 随着脚本的更新，修正了一些内容  

`ChangeLOG 0.1.2`  
1. 超前写日志失败，昨天有事出去了结果没更新，尴尬……  
2. 2017.12-2018.02.01





## 2018.01.31

`README 0.5.5`  
1. **更新了 inexistence 安装脚本的截图**  





## 2018.01.30

`inexistence 0.9.4`  
1. 又缩短了一些语句，争取减少错位  
哎，真是心情复杂。我猜不用 read -p 的话大概是不会错位的？  
2. **export DEBIAN_FRONTEND=noninteractive**  
也不知道有没有用，反正学到了就用上吧，QuickBox 是用了  
3. 增加对 checkinstall 的安装，以及 checkinstall 设置的修改  
4. 去除之前编译 FD_SETSIZE 的修改（Tr 老版本没有这个=1024的设定）  
考虑明天直接上修改完后的包，不过这样有个问题，不好自定义版本，或者说要自定义版本得增加判断逻辑了，有点麻烦  
5. **估摸着现在能在 Debian 9 编译 Transmission 了**  
6. Transmission 的编译安装换用了 checkinstall  

`IPv6`  
1. 修复 Debian 9 下，默认网卡名多了一个冒号的问题  
2. **修复没有成功删除之前配置文件，导致多次运行脚本可能失败的问题**  
3. 考虑不用 ifup ifdown 了，失败率太高 ……  





## 2018.01.29

`inexistence 0.9.4`  
1. 编译安装 Transmission 时，设定 FD_SETSIZE=666666  
2. **增加 Transmission 2.93 的安装选项**  
3. **修复 qBittorrent 安装 libtorrent-rasterbar 判断逻辑错误的问题**  
这导致了 Ubuntu 16.04 下没装 lt-r-dev，Debian 9 下编译了两次 lt 1.0.11  
4. 修复 Deluge 编译 lt 时没写入版本号的问题  
5. qBittorrent 编译 lt 时采用 checkinstall，写入版本号为实际并不存在的 1.0.12  
6. 进一步缩短某些输出语句，尽量避免排版错位的问题  
7. 加入了新的 alias，查看脚本错误更方便  

`rtinst Aniverse Mod`  
1. 移除升级已安装软件包的步骤，加快安装速度  

`ChangeLOG 0.1.0`  
1. 20171215-20180129  
2. 201710XX-20171015  





## 2018.01.28

`ChangeLOG 0.0.3`  
1. 20180104-20180127  
2. 201710XX-20171015  
3. 创建 WiKi，目前只存放日志  





## 2018.01.27

`inexistence 0.9.4`  
1. **Bump to 0.9.4**  
2. 输出文字调整  
缩短一些文字，以免小窗口下排版混乱  
录入密码部分不隐藏输入的密码  
3. **将 lsb-release 和 virt-what 的安装移到了后面**  
用很笨的办法直接从系统里检测系统版本，同时也不检测虚拟化技术了  
（考虑以后单独用 virt-what 的部分源码来检测）  
同时考虑加入检测是否 64位 和 x86 架构的问题……
4. qBittorrent 选项调整  
Debian 8 下不显示 qb 4.0 的选项，Debian 9 增加 4.0.2 的选项  
将不支持编译的提示增加到了 Ubuntu 16.04 （有待进一步测试）  
5. **qBittorrent 安装调整**  
Debian 9 下仍然选择编译安装 lt 1.0.11，因为 1.1.1 似乎有问题编译不了  
不编译 lt 的情况也都增加了 zlib1g-dev 这个包  
6. 无关紧要的脚本内部修正  
不使用 relno，全部用 CODENAME，此外增加了一些换行  
libtorrent1/2改成de/qb（checkinstall后包名也会变）  
7. rclone 加入了判断系统架构的选项，加了 log 输出  
但其实也就是 x86 和 x64 而已  
8. **不使用 curl 检测 IP 地址，只用 wget**  
在安装第一步还是尽量少安装一点，有些系统默认不带 curl 的  
wget 加入了是否安装的检测，没安装的话再执行安装  

`readme 0.5.1`  
1. 无关紧要的小幅改动  

`ChangeLOG 0.0.2`  
1. 20180104-20180127  





## 2018.01.23

`inexistence 0.9.3`  
1. **运行前先检测一次系统版本，不符合条件的话直接退出（不使用 lsb-release）**  
由于 wget 和 curl 某些精简系统可能没有，保险起见还是留着安装的命令  
2. 去掉了 installed.lock 里的账号密码，相对地增加了安装完输出结果的 log 保存  
3. 部分输出文字的细节优化  

`readme 0.5.0`  
1. 先随便写个初始版本号，就当 0.5.0 好了  
2. 久违的更新，修正了一些不符合最新脚本情况的内容  
3. 截图下次再说吧





## 2018.01.22

`inexistence 0.9.3`  
1. 修改了一些输出文字的问题  
2. 补充一些注释  
3. 增加了脚本文件夹到用户文件夹的软链  
4. 重新加回了隐藏输入密码的设计  
其实主要是我一时半会儿懒得调整这里的界面了  
5. 修复了 Debian 9 下的三个问题
更改了apt源，添加了 --allow-unauthenticated，修复了 qb 4.0.x 版本号  
6. 增加编译安装 libtorrent-rasterbar 的一些输出提示/注释，方便查错  

偶然想去测试下我基本不用的 Debian 9，没想到随便一试就发现了三个 bug ……





## 2018.01.21

`inexistence 0.9.3`  
1. **Bump to 0.9.3**
2. 从 bench.sh 和 军火脚本 参(chao)考(xi)了判断系统的代码  
打算以后用于代替 lsb_release 作系统判断，不然一开始的检测太慢了  
3. 调换了 30/40/50 的显示顺序  
30 自选版本，40 系统源，50 PPA（Debian 下隐藏）  
4. 在 installed.lock 添加了系统硬件参数，添加了打码账号密码的提示  
5. 为 ruTorrent 的 screenshots 插件添加了 m2ts 的支持
6. 增加/修改了部分 alias
7. 修复了之前使用 read -ep 导致两个暂停出不显示的问题
8. flexget 配置文件的存储路径移动到 ~/.config/flexget，更统一
9. 在安装 de/tr/qb 前备份以前可能存在的配置文件
10. **多处排版修改，预先添加了以后(不用root账户运行客户端)时候应该修改的命令**  
11. **BUG FIX libtorrent-rasterbar**  

这是本次更新的重点…… 忍不住吐槽下，辣鸡 VPS 编译一次 libtorrent-rasterbar 要40分钟，让我测试得真是没耐心，并且以前单核1GB跑下来也没压力，这次我不开 swap 就不行了  
之前残留的 bug 这次我在编译完 libtorrent 又安装 python-libtorrent 的时候碰到了，于是先把 deluge 编译时的这个包去掉  
然后考虑了各种可能的情况，把 qb 安装 lt 分成了三种情况来处理，其实有点蛋疼  

- `不需要再安装 libtorrent-rasterbar`  
适用于之前在安装 Deluge 的时候已经编译了 libtorrent-rasterbar 的情况。有一个问题在于这个检查方式依赖 checkinstall  
- `需要安装 libtorrent-rasterbar-dev`  
适用于 Ubuntu16.04 或 Debian9 系统，没装deluge，或者装了 deluge 且用的 libtorrent 是源的版本的情况
- `需要编译安装 libtorrent-rasterbar`  
适用于 Debian8 系统没装 Deluge 或者 Deluge 没有用编译的 libtorrent-rasterbar 1.0/1.1 的情况  
这也是我想避免的情况，因为编译 lt 实在是花时间；考虑到这个情况可能更通用，我就把它写成了 else  

考虑到有的人可能只是用脚本单独安装 qb，所以必须得从系统里检测 deluge 和已编译的 lt 的情况  
这个问题我也挺奇怪的，我和别人都用默认设置安装下来，有的人就是翻车，我自己测试基本就没问题……反正让我这种菜鸡挺头疼的，希望这次是解决了这个 bug 了吧  
这次 commit 偷懒用中文写了（讲道理吧英文写得也很烂，并且反正也没人看，就是写着自嗨的东西）  
说到这个，我挺好奇我这种写着自嗨的东西有没有人看的，如果谁看到了 QQ 敲下我吧 233  
最后再次吐槽下垃圾 VPS，以前全部安装、编译两次 libtorrent 也就50分钟左右，现在 Ubuntu 16.04 不编绎 libtorrent 竟然都要63分钟  





## 2018.01.19

`inexistence 0.9.2`  
1. **Bump to 0.9.2**
1. 大幅修改排版，加了很多换行  
2. read -ep 代替 echo -ne/read -e，不会出现 backspace 后 echo 文字消失的情况  
3. **将 libtorrent-rasterbar for deluge 的默认选项改回了从系统源安装**  
4. Ubuntu 系统默认从 PPA 安装 Deluge  
5. Debian 系统不显示从 PPA 安装的 40 选项  
6. 询问版本时加入了 50 选项，允许自己输入软件版本  
7. 增加对 /etc/systemd/user.conf LimitNOFILE 的修改  
8. **加入了对 /etc/screenrc 的修改**  
9. alias 里 space 改成 yongle  
10. 检查安装软件是否成功，失败的话直接退出脚本  
11. 替换 /etc/apt/sources.list 前先做一个备份  
12. 加入了检查系统和 Deluge 所用的 libtorrent-ratserbar 的功能  
13. 将针对 qBittorrent 是否编译 libtorrent-ratserbar 时判断条件里的是否为 Debian 修正为是否为 Debian 8 系统
14. 有一个严重 bug 我也不知道解决了没有（2018.01.22：没有！）  
在 Online.net 独服的 Ubuntu 16.04 下，安装 Deluge 编译完 libtorrent-rasterbar 后安装 libtorrent-rasterbar-dev ，会导致冲突，然后 apt-get install 就炸了……  





## 2018.01.18

`inexistence 0.9.1`  
1. 先检查 root 权限，再做之后的检查  
2. 将检查IP地址的提示分成了 IPv4 和 IPv6 两部分  
3. 加回了 rtwebmin 但不启用





## 2018.01.15

`inexistence 0.9.1`  
1. 修复系统为 Debian 8，不安装 Deluge 时 qBittorrent 由于 libtorrent-rasterbar-dev 版本过低无法编译的情况  

`rtinst Aniverse Mod`  
1. 去除 log 功能，以免出 bug （暂时懒得修复）  

`ChangeLOG 0.0.1`  
1. 第一次写 changelog，20180104-20180115  





## 2018.01.12

`inexistence 0.9.1`  
1. 修复了一个我自己都不知道什么鬼的 bug  
由于计时不知道怎么回事丢了 starttime 所以无法计算，脚本直接跳过了 _end 的剩余代码，不输出最后结果了  
2. 注释了 PowerFonts 的安装  
3. 取消了检查系统源 OK 后的绿色粗体  





## 2018.01.11 

`inexistence 0.9.1`  
1. **Bump to 0.9.1**  
2. **在某些情况下不编译 libtorrent-rasterbar**  
安装 qBittorrent 时，当 deluge libtorrent 版本选择非 0.16 分支或 Deluge libtorrent 不选择从 Debian 的系统源安装时，不编绎 libtorrent-rasterbar，选择用 libtorrent-rasterbar-dev 这个包代替以节省时间
3. **顺序变动：先安装 Deluge 再安装 qBittorrent**  
4. 安装前检查安装源的网站是否可以访问，系统源出错时直接退出脚本  
5. 选择 qBittorrent 版本后不显示将会使用的 libtorrent 的版本  
6. 不再隐藏 libtorrent-rasterbar 的 1.1 和 from repo 选项  
7. 完善了 log  





## 2018.01.09

`inexistence 0.9.0`  
1. **Bump to 0.9.0**  
2. **系统优化默认选项改成了 Yes**  
3. 隐藏 qBittorrent 4.0.2 的选项  
4. 在 /var/www 建立了到用户文件夹的软链
5. 系统源加入了 wget 的安装（以防万一）  
6. 补充了 wine 的 PPA（尚未启用）  
7. 补充了 oh-my-zsh 的代码（尚未完全启用）  
8. 增加 IPv6 检测的时间到 5 秒  





## 2018.01.04

`ipv6 & xiansu`  
1. 改进判断默认网卡的方式  
先是识别出本机 IPv4 地址，然后再在 ifconfig 的结果里找包含这个地址的上一排里的网卡名  
也不知道靠不靠谱，感觉大概比之前的靠谱吧  





## 2018.01.03

`inexistence 0.8.9`  
1. 抄来了一个 rcloned 用于自动挂载  
2. **aptsources 默认改为 Yes**  
3. 增加 sudo 的安装  
4. **更新 tr-webui 到新版本**  
5. **针对 Ubuntu PPA 安装 deluge，增加了 apt-mark hold 和指定安装 deluge ppa lt 的操作**  
6. ipv6.sh 重命名为 ipv6  

`rtinst Aniverse Mod`  
1. 修复第二次运行 rtinst 由于 unzip 没有用 -O 参数导致安装卡住不动的问题  

`readme 0.4.9`  
1. 更新 ipv6  



## 2018.01.02

`inexistence 0.8.9`  
1. cesu 重命名为 spdtest  
2. 缩短公网 IP 检测时间的长度  


























## 2017.12.29

`inexistence 0.8.9`  
01. 修复 local packages 没有及时更新的问题  
02. 对 rTorrent 和 Transmission-daemon 的 systemd 文件增加了 LimitNOFILE=100000  
03. 更新了 mediainfo 最新版本的安装方法  
04. 在 /etc/profile 增加了 ulimit -SHn 666666  
05. 修改打开文件数上限到 666666  
06. 在 /etc/security/limits.conf 增加了一些行数，应该比之前有用吧  
07. **增加每个软件安装过程的日志记录功能，方便查错**  





## 2017.12.27

`inexistence 0.8.9`  
1. 增加了 Deluge 1.3.5/1.3.6 的隐藏选项  
但其实好像编译出来有问题……  
2. 加了 lt 0.16 支持双栈IP汇报的提示  
3. 在 BBR 处临时指定了另一个 $local_packages  
4. 1926817→192617

`ipv6.sh`  
1. 临时修复把默认网卡 eno1 识别成 eno2 的问题  
治标不治本（已在2018.01.04里修复）





## 2017.12.25

`inexistence 0.8.9`  
1. **Bump to 0.8.9**  
2. alias xuanxiang，同时去掉了双引号（会显示在 cat 里）  
3. 输出文字大小写优化  
4. 隐藏了 qb 3.12/13/15 的选项，Ubuntu 下 4.0.2 改成 4.0.3  
5. **installed.lock 代替 /ect/profile 的安装信息注释**  
6. 脚本版本和修改日期移到了脚本开头  
7. 计时开始处移到了 _setsources  
8. **_setsources 处增加了一些软件的安装**  
9. **文件打开数修改处，会删除之前可能存在的文件打开数设置**  

`readme 0.4.8`  
1. Known Issues、Under Consideration、To Do List  






## 2017.12.23

`inexistence 0.8.8`  
1. 增加了 QBVERSION4 的判断  
2. lt 增加了显示每个系统对应源里版本的功能  
3. 创建脚本文件夹的软链之前先创建 /var/www 文件夹  
4. alias 里 cdde 之类的去掉了 ll
5. 增加一步 locale-gen en_US.UTF-8（不 source 好像也没意思）  
6. 调整 wine 与 VNC 的安装  
7. 安装结束时的 Clients URL 改成 INSTALLATION COMPLETED  
8. _setsources 放在了 _setuser 之前，避免安装不了 git 的问题  

`readme 0.4.7`  
1. 更新开头的介绍  





## 2017.12.22

`readme 0.4.6`  
1. 更新  bdupload 的案例介绍  
2. 部分内容调整  
3. 增加参考资料名单  

`ipv6.sh`  
1. 直接改成增 3次 ifup  
似乎然并卵  





## 2017.12.21

`inexistence 0.8.8`  
1. 已安装 rt 的话，提示改成请使用 rtupdate 更换版本  
2. 增加了到用户文件夹的软链  
3. 增加了 screen 和 vnstat 的安装  

`rtinst Aniverse Mod`  
1. 修复SCGI Server Timeout 设置用户名的问题  

`bdupload`  
1. 修复时间判断不正确的问题  
2. 增加了每张截图的时间间隔  





## 2017.12.17

`inexistence 0.8.8`  
1. 界面、输出文字调整  
2. 账号密码输出到 installed.lock  
3. 脚本运行完毕后删除脚本自身  
4. 移动 rtinst 和 bbr 脚本的 log  

`mingling 0.5.7`  
1. **重写了《一些常用命令》**  
排版真累啊  
2. 更新软件版本的检查方式，awk  

`bdinfo bdjietu bdupload jietu zuozhong`  
1. 优化输出的结果显示  

`readme 0.4.2-0.4.5`  
1. 更新 bdupload、bdjietu、bdinfo 等脚本的用法说明  
2. 修复一些地方标题没有大写的问题  





## 2017.12.16

`inexistence 0.8.8`  
1. **Bump to 0.8.8**  
2. 修复 curl 参数写成 wget 参数的问题  
3. **以防万一，在一开始增加了 wget 和 crul 的安装**  
4. 输出文字调整  
5. cesujiedian 简化  
6. 去掉 IPv4 优先的设定  
某些情况下直接连不上 IPv6 了 orz  
7. **增加已安装客户端版本的检查**  
8. **增加显示会安装的、来自 repo 版本的功能**  
9. **Transmission 默认改为从 repo 安装**  
10. **已安装客户端的话会提示已安装的版本**  
11. **安装失败的话在最后会有检查、提示**  

`ipv6.sh`  
1. **彩色化界面**  
2. **优化默认网卡判断**  
代码来自于 Vicer 大佬的锐速一键脚本  
3. **检查 ifup 是否成功**  
4. **移除可能存在的 IPv6 设置，让脚本在失败的情况下可以多次运行**  

`bdinfo`  
1. 增加了运行出错时的提示  

`xiansu`  
1. 优化网卡判断（eth1的情况）  
2. 使用 bash 代替 sh  

`readme 0.3.6-0.4.1`  
1. 懒得写了……  
2. 大量内容新增、补充、重写  
3. IPv6 脚本公开上线  
4. --no-check-certificate 参数写在了开头的介绍，简化命令  





## 2017.12.15

`inexistence 0.8.7`  
1. **去掉安装 webmin 的安装**  
2. **增加了修改时区的功能**  
3. 完善 alias  
4. **将最大的分区的保留空间设置为 0**  
5. 设定 IPv4 优先  
6. 隐藏从 repo 安装 Deluge 的选项  
应该是从这个时候发现 Deluge 与 qBittorrent libtorrent-rasterbar 冲突的问题  

`mingling 0.5.6`  
1. 对应修改了 alias 的提示  
2. 用 awk 替换之前的一些版本检查方法  
3. 去除了检查 rclone 版本时多余的提示  





## 2017.12.13

`inexistence 0.8.7`  
1. **Bump to 0.8.7**  
2. Bug Fix：修复 tr 装完后可能无法启动的问题  
3. 增加高版本内核需要的 frimware  
4. **增加安装 vncserer 的功能，但不启用**  
5. 增加对于客户端安装情况的检查  
6. UI Change：询问版本时的编号采用绿色字体  
7. 安装 qb 4.0 版本时候的处理的变化  
16.04 强制从 PPA 安装，Debian 8 强制换成 3.3.16  
8. 优化对已安装的 BBR 的判断逻辑，加入了对魔改版 BBR 的识别  
9. Bug Fix：写入 /etc/profile 的版本信息带上引号  
10. 统一采用 libtorrent 1.0 分支用于 qb，不用 1.1  
11. qb 编译时候 prefix=/usr  

`readme 0.3.3-0.3.5`  
1. bdupload 部分完善  
2. 其他还有很多……  





## 2017.12.12

`inexistence 0.8.6`  
1. Bug Fix：tr systemd  

`readme 0.3.1-0.3.2`  





## 2017.12.11

`inexistence 0.8.6`  
1. Bug Fix：修复 IPv4 地址不显示的问题  
2. Bug Fix：修复 Debian 9 下安装 Tr 失败的问题  

`readme 0.2.9-0.3.0`  
1. **加入了 --no-check-certificate 参数**  
2. **加入了 To Do List、Under Consideration、Known Issues**  




## 2017.12.10

`inexistence 0.8.6`  
1. **Bump to 0.8.6**  
2. New Function：先检测内网 IPv4 地址，再检测外网地址  
3. rtorrent：安装 rar 5.5.0  
4. rtorrent：生成 https 证书  
5. **RENAME：去掉了.sh**  
6. **New Function：read -e，允许删掉重写**  
7. 往 /etc/profile 写入更多的安装选项  

`mingling`  
1. New Function：先检测内网 IPv4 地址，再检测外网地址  
2. UI Change  
3. 在网址界面去掉了账号密码的显示  

`rtinst Aniverse Mod`  
1. 修复 rar/unrar 安装的问题  

`readme 0.2.2-0.2.8`  





## 2017.12.09

`inexistence 0.8.5`  
1. UI Change  
2. 修改一些文件的存放路径  
3. tr 的配置文件存放位置改成 /root/.config/transmission-daemon  
4. Bug Fix：换源时添加 key  

`mingling`  
1. 判断逻辑问题修复  

`readme 0.1.0-0.2.1`  
1. 初始化，完善  
2. 写上 bdupload  
3. 写上 Mingling  





## 2017.12.08

`inexistence 0.8.5`  
1. **Bump to 0.8.5**  
2. **第一次写入脚本版本号和日期**  
3. UI Change  
4. 密码长度要求改为至少 9 位
5. **五个新脚本，去掉了 bdshuchu**  
bdinfo、bejietu、guazai、jietu、zuozhong  
6. BDUpload Logo  
7. 一些小问题修复  

`xiansu`  
1. 加入了在命令里填写网卡和网速的功能，适用于开机自启  

`readme 0.0.9`  
1. 修复安装命令错误运用管道的问题  





## 2017.12.07

`inexistence 0.8.4`  
1. 初始化上传 bdupload、mingling、inexistence  

`readme 0.0.8`  
1. 安装命令的 source 改成 bash  












似乎到此为止 GitHub 更新的部分写完了，剩下的是本地的部分了……真麻烦  
还有 rtinst 的部分……  

-------------------











## 2017.11.30





## 2017.11.29





## 2017.11.28






## 2017.11.27





## 2017.11.24





## 2017.11.23





## 2017.11.22






## 2017.11.19






## 2017.11.17






## 2017.11.14






## 2017.11.13






## 2017.11.10






## 2017.11.09

`Seedbox 0.4.2-0.4.4` 
1. 2017.11.09 00:28/01;02/12;09
2.





## 2017.11.08

`Seedbox 0.4.0-0.4.1` 
1. 2017.11.08 20:00/20:07  
2. 





## 2017.11.07

`Seedbox 0.3.9` 
1. 2017.11.07 12:28  
2. 

`Seedbox 0.3.8` 
1. 2017.11.07 10:51  
2. 





## 2017.10.27

`Seedbox 0.3.7` 
1. 2017.10.27 16:29  
2. 

`Seedbox 0.3.6` 
1. 2017.10.27 13:29  
2. 





## 2017.10.26

`Seedbox 0.3.5.2` 
1. 2017.10.26 24:30  
2. 

`Seedbox 0.3.5.1` 
1. 2017.10.26 24:30  
2. 


`Seedbox 0.3.4` 
1. 2017.10.26 20:00  
2. 


`Seedbox 0.3.3` 
1. 2017.10.26 19:02  
2. 


`Seedbox 0.3.2` 
1. 2017.10.26 18:46  
2. 


`Seedbox 0.3.1` 
1. 2017.10.26 18:24  
2. 


`Seedbox 0.3.0` 
1. 2017.10.26 17:33  
2. 

`Seedbox 0.2.9` 
1. 2017.10.26 17:18  
2. 

`Seedbox 0.2.8` 
1. 2017.10.26 17:00  
2. 

`Seedbox 0.2.7` 
1. 2017.10.26 16:18  
2. 

`Seedbox 0.2.6` 
1. 2017.10.26 15:21  
2. 





## 2017.10.25

`Seedbox 0.2.5` 
1. 2017.10.25 20:53  
2. 

`Seedbox 0.2.4` 
1. 2017.10.25 19:30  
2. 

`Seedbox 0.2.3` 
1. 2017.10.25 19:03  
2. 





## 2017.10.24

`Seedbox 0.2.2` 
1. 2017.10.24 23:33  
2. 

`Seedbox 0.2.1` 
1. 2017.10.24 23:15  
2. 

`Seedbox 0.2.0` 
1. 2017.10.24 21:27  
2. 

`Seedbox 0.1.9` 
1. 2017.10.24 21:14  
2. 

`Seedbox 0.1.8` 
1. 2017.10.24 20:18  
2. 

`Seedbox 0.1.7` 
1. 2017.10.24 16:30  
2. 





## 2017.10.21

`Seedbox 0.1.6` 
1. 2017.10.21 22:33  
2. 

`Seedbox 0.1.5` 
1. 2017.10.21 12:45  
2. 

`Seedbox 0.1.4` 
1. 2017.10.21 10:47  
2. 

`Seedbox 0.1.3` 
1. 2017.10.21 00:44  
2. 


`Seedbox 0.1.2` 
1. 2017.10.21 00:19  
2. 





## 2017.10.18

`Seedbox 0.1.1`  
1. 2017.10.18 19:10  
2. 

`Seedbox 0.1.0`  
1. 2017.10.18 18:26  
2. 

`Seedbox 0.0.9`  
1. 2017.10.18 18:40  
2. 

`Seedbox 0.0.8`  
1. 2017.10.18 18:08  
2. 





## 2017.10.15

`Seedbox 0.0.7`  
1. 2017.10.15 23:30  
2. 输出修改  
3. 去掉了手滑写多的 apt-get install  





## 2017.10.13

`Seedbox 0.0.6`  
1. 2017.10.13 13:44  
2. 补充注释  
3. libtorrent-rasterbar 加入了不编绎的选项  
4. 一些默认选项的修改  
5. **增加了安装 rclone 的功能**  
6. 输出修改  





## 2017.10.12

`Seedbox 0.0.5`  
1. 2017.10.12 24:10  
2. libtorrent-rasterbar master branch，Deluge dev branch  
3. alias、排版、补写 fi  

`Seedbox 0.0.4`  
1. 2017.10.12 23:09  
2. **增加了安装 rTorrent 与 ruTorrent 的功能**  
3. **增加了安装 Flexget 的功能**  

`Seedbox 0.0.3`  
1. 2017.10.12 19:37  
2. **Rename to Seedbox Script**  
3. This is the choice of Steins;Gate.  
4. 询问是否创建 log  
5. 补充、完善输出文字，比如正在安装什么的提示  
6. **增加安装 Deluge 以及 libtorrent-rasterbar 的功能**  
7. **增加了 alias**  
8. **增加了滚动条？**  

`qbt 0.0.2`  
1. 2017.10.12 13:14  
2. **加入了部分设置 qb 参数的功能**  
3. **完善界面**  





## 2017.10.XX

`qbt 0.0.1`  
1. 第一个版本，只能安装 qBittorrent  
