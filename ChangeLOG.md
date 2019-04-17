# ChangeLog  








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
距离上次快半年了……其实这次是因为除了修改 naive 外不知道改什么了就干脆升级版本号了  
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





## 2018.05.08

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
PS:OB 最近 https 这方面有改过才导致一些老版本不支持  

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
14. 有一个严重 bug 我也不知道解决了没有（2017.01.22：没有！）  
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












似乎到此为止 GitHub 更新的部分写完了，剩下的是本地的部分了……真麻烦，呸  
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
1. **Rename to Seedbox Script**  
1. 2017.10.12 19:37  
2. This is the choice of Steins;Gate.  
3. 询问是否创建 log  
4. 补充、完善输出文字，比如正在安装什么的提示  
5. **增加安装 Deluge 以及 libtorrent-rasterbar 的功能**  
6. **增加了 alias**  
7. **增加了滚动条？**  

`qbt 0.0.2`  
1. 2017.10.12 13:14  
2. **加入了部分设置 qb 参数的功能**  
3. **完善界面**  





## 2017.10.XX

`qbt 0.0.1`  
1. 第一个版本，只能安装 qBittorrent  
