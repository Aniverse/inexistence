# ChangeLog  
> 有时候代码内部排版问题、不怎么影响使用的修改就不列出来了  







































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
