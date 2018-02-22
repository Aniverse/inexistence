> 警告：不保证本脚本能正常使用，翻车了不负责；上车前还请三思  
> 作者是个菜鸡，本脚本的主要内容是抄袭 + 百度谷歌得来的  
  
虽然这本来就是公开的 repo，不过希望使用者不要宣传这个垃圾脚本，我想做得更完善一点再说……  
本文内容不会及时更新；目前最新的脚本在界面上和截图里有一些不一样  
如果 `wget` 时出错，请先运行   `alias wget="wget --no-check-certificate"`  

-------------------
# Inexistence

#### 使用方法

```
无非就是 wget 和 bash，自己看着办吧  _(:з」∠)_  
```

#### 安装介绍

![引导界面](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.01.png)

检查是否 root，检查系统是不是 `Ubuntu 16.04、Debian 8、Debian 9`  
如果没用 root 权限运行或者系统不是如上的三个，脚本会自动退出  
你可以通过修改脚本第⑨行的 SYSTEMCHECK=1 来关闭对于系统的检查，不过嘛脚本能不能正常工作就是另一回事了  

![欢迎界面](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.03.png)

显示系统信息以及注意事项  

![安装时的选项](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.04.png)


1. **账号密码**  
你输入的账号密码会被用于各类软件以及 SSH 的登录验证  
用户名需要以字母开头，长度 4-16 位；密码最好同时包含字母和数字，长度至少 8 位
恩，目前我话是这么说，但脚本里还没有检查账号密码是否合乎要求，所以还是自己注意点吧  

2. **系统源**  
其实大多数情况下无需换源；但某些盒子默认的源可能有点问题，所以我干脆做成默认都换源了  

3. **线程数量**    
编译时使用几个线程进行编译。一般来说独服用默认的选项，也就是全部线程都用于编译就行了  
某些 VPS 可能限制下线程数量比较好，不然可能会翻车  
下面四大客户端的安装，指定版本的一般都是编译安装，安装速度相对较慢但可以任选版本  
选择 `30` 是从系统源里安装，安装速度快但版本往往比较老，且无法指定版本  
选择 `40` 是从 PPA 安装  **( 不支持 Debian 系统所以自动隐藏了 )**  同样无法指定版本不过一般软件都是最新版  
选择 `50` 是自己指定另外的版本来安装  **（不会检查这个版本是否可用；可能会翻车）**  

4. **qBittorrent**  
在 `Debian 8` 下由于不满足依赖的要求，无法完成 4.0 及以后版本的编译  
新增加的 qb 3.3.11 Skip Hash Check 是可以在 WebUI 下跳过校验的 3.3.11 版本  
**使用修改版客户端、跳过校验 存在风险，后果自负**  

5. **Deluge**  
在 `Ubuntu 16.04` 下默认选项为从 PPA 安装，在其他系统中默认选项为 1.3.15  
此外还会安装一些实用的 Deluge 第三方插件：  
- `ltconfig` 是一个调整 `libtorrent-rasterbar` 参数的插件，在安装完后就启用了 `High Performance Seed` 模式  
- `Stats` 和 `TotalTraffic` 需要 GtkUI 才能显示出来，分别可以显示速度曲线和 Deluge 的总传输流量  
- `YaRSS2` 是用于 RSS 的插件；`LabelPlus` 是加强版的标签管理；这两个也需要 GtKUI  
- `AutoRemovePlus` 是自动删种插件，支持 WebUI 与 GtKUI  
隐藏选项 11-15 ，分别对应 1.3.5-1.3.9 的老版本  
隐藏选项 21，是可以跳过校验、全磁盘预分配的 1.3.15 版本  
**使用修改版客户端、跳过校验 存在风险，后果自负**  

6. **libtorrent-rasterbar**  
如果你对这个不了解的话，敲回车选择默认的选项就可以了  
最新的 1.1.X 版本在 Deluge 和 qBittorrent 上或多或少都有些问题，因此不建议选择这个版本  

7. **rTorrent**  
这部分是调用我修改的 `rtinst` 来安装的，默认选项为安装原版 0.9.4  
- 安装 rTorrent，ruTorrent，nginx，ffmpeg，rar  
- 0.9.4 支持 IPv6 用的是打好补丁的版本，属于修改版客户端  
- 0.9.6 用的是最新的 feature-bind 分支，原生支持 IPv6；Debian 9 强制使用本版本  
- FTP，端口号 21；SSH，端口号 22  
- h5ai 目录列表程序  
- ruTorrent 版本为 3.8，包含一些第三方插件和主题  
- `club-QuickBox` `MaterialDesign` 第三方主题  
- `AutoDL-Irssi` 这个其实是 rtinst 安装的  
- `Filemanager` 插件可以在 ruTorrent 上管理文件、创建压缩包、生成 mediaino 和截图  
- `ruTorrent Mobile` 插件可以优化 ruTorrent 在手机上的显示效果  
- `spectrogram` 插件可以在 ruTorrent 上获取音频文件的频谱  

8. **Transmission**  
Transmission 一般无论哪个版本PT站都支持，并且用起来没多大差别，因此默认选择从仓库里安装，节省时间  
此外还会安装修改版的 WebUI，更方便易用  
11 和 12 这两个隐藏选项，分别对应可以跳过校验、无文件打开数限制的 2.92、2.93 版本  
**使用修改版客户端、跳过校验 存在风险，后果自负**  

9. **Flexget**  
默认不安装；我启用了 daemon 模式和 WebUI，还预设了一些模板，仅供参考  
因为配置文件里的 passkey 需要用户自己修改，所以我也没有启用 schedules 或 crontab，需要的话自己打开  

10. **rclone**  
默认不安装。安装好后自己输入 rclone config 进行配置  

11. **BBR**  
会检测你当前的内核版本，大于 4.9 是默认不安装，高于 4.9 是默认启用BBR（不更换内核）  
由于 BBR 需要 4.9 以上的内核，而更换内核或多或少是有点危险性的操作，因此需要考虑一下  
不过针对常见的 Online.net 的独服我是准备了五个 firmware，应该没什么问题  
BBR 的安装调用了秋水逸冰菊苣的脚本，会安装最新版本的内核  

12. **系统设置**  
默认启用，具体操作如下：  
- 修改时区为 UTC+8  
- 语言编码设置为 UTF-8  
- 设置 `alias` 简化命令  
- 提高系统文件打开数  
- 修改 screen 设置  

13. **确认信息**  
如果你哪里写错了，先退出脚本重新选择；没什么问题的话就敲回车继续  


![安装完成界面](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.05.png)

安装完成后会输出各类 WebUI 的网址，以及本次安装花了多少时间，然后问你是否重启系统（默认是不重启）  

![Web界面](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.06.png)

最后打开浏览器检查下各客户端是否都在正常运行  


#### To Do List

- **安装 VNC**  
打算把 mono 和 wine 也加上  
- **发种相关**  
安装新版本的 ffmepg、mediainfo、mkvtoolnix  
- **Flexget 模板**  
补充更多的站点预设  
- **检查安装完成后客户端是否正在运行**  
- **MiMA**  
修改 SSH、Deluge、ruTorrent、Transmission、qBittorrent 的密码的脚本  

#### Under Consideration

- **不使用 root 运行**  
将 Tr/De/Qb 的运行用户换成普通用户  

#### Known Issues

- 有时候 ruTorrent 会有一些插件有问题或者插件需要的依赖没装  
本人水平菜+人懒，这部分等 rtinst 作者处理  
- 没有检查用户输入的账号、密码的有效性  


  -------------------
### Usage for Inexistence

```
bash -c "$(wget --no-check-certificate -qO- https://github.com/Aniverse/inexistence/raw/master/inexistence.sh)"
```

-------------------
## mingling

#### 运行
```
mingling
```

#### 介绍

方便刷子们使用的一个脚本，有很多功能如果你没安装 `inexistence` 的话是用不了的  
此外有些功能还没做完  
不做具体的介绍了，直接看图吧  

![mingling.00](https://github.com/Aniverse/filesss/raw/master/Images/mingling.00.png)
![mingling.01](https://github.com/Aniverse/filesss/raw/master/Images/mingling.01.png)
![mingling.02](https://github.com/Aniverse/filesss/raw/master/Images/mingling.02.png)
![mingling.03](https://github.com/Aniverse/filesss/raw/master/Images/mingling.03.png)
![mingling.04](https://github.com/Aniverse/filesss/raw/master/Images/mingling.04.png)
![mingling.05](https://github.com/Aniverse/filesss/raw/master/Images/mingling.05.png)
![mingling.06](https://github.com/Aniverse/filesss/raw/master/Images/mingling.06.png)
![mingling.07](https://github.com/Aniverse/filesss/raw/master/Images/mingling.07.png)
![mingling.08](https://github.com/Aniverse/filesss/raw/master/Images/mingling.08.png)

#### Known Issues
- rTorrent 的操作很可能没啥卵用  

#### To Do List
- 完善说明文档  
- 添加 AutoDL-Irssi 的开关  
- 添加锐速的开关与状态检测  
- 完成脚本菜单的功能  

 -------------------
## bdjietu

（更新完新版 jietu 后这个看起来没啥卵用了，考虑删掉……）
这个是单独抽出来的，用于给 BD 截图的脚本  
输入 BDMV 的路径后会自动从中找出最大的 m2ts 文件，截图 10 张到特定的目录  
其实就是用 ffmepg 来截图，不过指定了 1920x1080 的分辨率和输出的路径  
 
 ![bdjietu输出结果](https://github.com/Aniverse/filesss/raw/master/Images/bdjietu.01.png)
 
  -------------------
## bdinfo

这个是单独抽出来的，用于给 BDMV 扫描 BDinfo 的脚本  
运行完以后可以直接在 SSH 上输出 BDinfo Quick Summary  

![bdinfo输出结果](https://github.com/Aniverse/filesss/raw/master/Images/bdinfo.01.png)

如果没有 mono 或 BDinfo-Cli 的话，可以先运行 `bdupload` 脚本安装需要的软件  

![bdinfo运行过程](https://github.com/Aniverse/filesss/raw/master/Images/bdinfo.02.png)

可以选择需要扫描的 mpls  

![bdinfo输出结果](https://github.com/Aniverse/filesss/raw/master/Images/bdinfo.03.png)
 
BDinfo 输出结果看起来五颜六色是因为使用了 lolcat，如果你没安装 lolcat 的话是不会有彩色的  
 
  -------------------
## IPv6

用于配置 IPv6 的脚本  
如果第一次运行不成功，可以试着再跑一遍  

``` 
wget https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6
bash ipv6  
bash ipv6 [interface] [address] [subnet] [DUID]  
bash ipv6 enp2s0 2001:3bc8:2490:: 48 00:03:00:02:19:c4:c9:e3:75:26  
```

![ipv6.01](https://github.com/Aniverse/filesss/raw/master/Images/ipv6.01.png)

  -------------------
## xiansu

用于给盒子限制全局上传速度的脚本，适用于保证带宽有限的盒子，比如 Online.net 的一些独服    
更改限速速率时无需事先解除限速，脚本执行新的限速前会自动解除该网卡已经存在的限速  
直接输入 `xiansu eth0 300` 的话会直接限速，不会有任何提示，适合用于需要开机自启的情况  

``` 
xiansu  
xiansu [interface] [uploadspeed,Mbps]
xiansu eth0 300
```

![xiansu.01](https://github.com/Aniverse/filesss/raw/master/Images/xiansu.01.png)


  -------------------
## jietu

用于截图和生成 mediainfo 的脚本，适合非原盘类的视频  
输入文件名则对这个文件进行操作，输入文件夹则寻找该文件夹内最大的文件当做视频文件进行操作  
你可以指定分辨率进行截图，也可以不写分辨率让脚本自动计算 DAR 后的分辨率  
比如有一张 DVD 的原始分辨率是 720x576，DAR 是 16:9，那么脚本就会采用 1024x576 来截图  

``` 
jietu [path/to/file] [resloution]  
jietu "/home/aniverse/[VCB-Studio][Saenai Heroine no Sodatekata Flat][01][Ma10p_1080p][x265_flac_aac]" 1920x1080  
jietu [path/to/folder]  
jietu "/home/aniverse/deluge/download/Your Name (2016) PAL DVD9"  
```

![jietu.01](https://github.com/Aniverse/filesss/raw/master/Images/jietu.01.png)


  -------------------
## guazai

用于把 ISO 挂载成文件夹的脚本，使用的是 mount 命令，因此需要 root 权限才能运行  


![guazai.03](https://github.com/Aniverse/filesss/raw/master/Images/guazai.03.png)

`guazai` 后输入文件名则挂载那个文件  

![guazai.01](https://github.com/Aniverse/filesss/raw/master/Images/guazai.01.png)
![guazai.02](https://github.com/Aniverse/filesss/raw/master/Images/guazai.02.png)

`guazai` 后输入路径则会寻找该路径下的所有 ISO 进行挂载  
直接输入 `guazai`，会在当前目录下寻找 ISO 挂载  


  -------------------
## jiegua

解除挂载用的脚本，会把能检测到的所有已挂载的 ISO 全部解除挂载

![jiegua.01](https://github.com/Aniverse/filesss/raw/master/Images/jiegua.01.png)

`guazai` + `jietu` + `jiegua` 三连


  -------------------
## Blu-ray

关于 bluray 脚本的介绍与使用，请移步到 [这里](https://github.com/Aniverse/bluray)  
inexistence 自带 bluray，不过不包括它的软件库  


  -------------------


还有一些脚本，比如 `zuozhong`，在此不作介绍了，基本看名字都知道是干什么用的了  

  -------------------
### Something else

有 bug 的话请告诉我 **但不保证能解决**  有意见或者改进也欢迎告知  

如需提交 bug ，请告诉我如下的信息：  
1. 具体日志，日志的查看方法在最后安装出错后会有显示  
2. 你使用的是什么盒子   
3. 你具体碰到了什么问题  

需要注意的是有些问题可能不是本脚本造成的  



  -------------------
### Some references

https://github.com/arakasi72/rtinst  
https://github.com/QuickBox/QB  
https://github.com/qbittorrent/qBittorrent  
https://flexget.com  
https://rclone.org/install  
http://dev.deluge-torrent.org/wiki/UserGuide    
https://mkvtoolnix.download/downloads.html  
http://outlyer.net/etiq/projects/vcs  
https://www.dwhd.org  
https://moeclub.org  
https://sometimesnaive.org  
https://www.94ish.me  
https://blog.gloriousdays.pw  
http://wilywx.com  
https://github.com/teddysun/across  
https://github.com/oooldking/script  
https://github.com/gutenye/systemd-units  
https://github.com/outime/ipv6-dhclient-script  
https://github.com/jxzy199306/ipv6_dhclient_online_net  
https://github.com/GalaxyXL/qBittorrent-autoremove  
https://xxxxxx.org/forums/viewtopic?topicid=61434  
https://tieba.baidu.com/p/5536354634  
https://tieba.baidu.com/p/5532509017  
https://tieba.baidu.com/p/5158974574  


