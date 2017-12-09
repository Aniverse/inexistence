## Laji Scripts


> 这只是一个不会 shell、不会 Linux 的刷子无聊写着玩的产物 ……


本人不保证本脚本能正常使用，翻车了不负责；上车前还请三思。

-------------------
## Inexistence


#### 使用方法
``` 
wget -q https://github.com/Aniverse/inexistence/raw/master/inexistence.sh && bash inexistence.sh
```
-------------------
#### 安装介绍

`Checking your server's public IP address ...
If you stuck here for a while, please press Ctrl+C to stop the script` 

如果你卡在这一步，应该是获取公网 IP 地址的时候卡了……除了去掉这个检测或者换个检测地址外我暂时不知道这个情况要怎么解决（ifconfig 出来在某些 VPS 上是内网的IP）

![引导界面](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.01.png)

Logo，系统信息显示，检查是否 root，检查系统是不是 Ubuntu 16.04、Debian 8、Debian 9

![安装时的选项](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.02.png)

1. 询问**账号密码**  根据你输入的账号会新建一个 UNIX 用户，rTorrent 的运行也是用这个用户来运行（其他软件用 root 来运行），Deluge auth、qBittorrent 用的也都是这个账号；密码用于各类软件的 WebUI。
目前这个功能有一个问题，脚本不会检测输入的用户名和密码是否合法。所以如果你用了不合法的用户名（比如数字开头）或者不合法的密码（密码复杂度太低），脚本不会提示出错，但实际在软件的使用中你就会碰到问题……
2. 询问你是否更换**系统源**。这个你自己看着办吧。某些VPS默认的源有点问题我才加入了这个选项
3. 问你编译时使用的**线程数量**（四个 BT 客户端默认都是编译安装的）。一般来说独服用默认的选项，也就是全部线程都用于编译就可以了…… 某些 VPS 可能限制下线程数量比较好，不然可能会翻车……
4. **qBittorrent**  其实有安装 4.0.2 版本的选项，不过似乎编译不成功，因此我就没显示出来了.以后再测试这个的编译 （Ubuntu 如果从 PPA 安装的话是这个版本）
5. **Deluge libtorrent** 一般选默认的就可以了
6. **rTorrent + ruTorrent**   这部分是调用我修改的 rtinst 来安装的（SSH端口22，不修改root登陆，安装 webmin 和 h5ai）。目前这个脚本安装的 0.9.6 版本不支持 IPv6，我还不知道哪里出了问题…… 0.9.4 支持 IPv6 用的是打好补丁的版本。理论上来说这是一个修改版，所以是否要安装这个版本就由你自己来定夺了…… 此外如果系统是 Debian 9的话，rTorrent 版本强制会指定成 0.9.6（其他版本不支持）
7. **Transmission**  会安装修改版的 WebUI。Debian 9下的编译安装我失败了，不知道为什么。因此针对 Debian 9 就强制采用 从 repo 安装的办法
8. 实际上针对 tr/de/qb 我加入了不编绎，从 PPA 或者 repo 里安装的选项，不过默认是不显示这些选项的……输入30是从 repo 安装，输入 40 是添加 ppa 后安装（ppa仅对 Ubuntu 有效 ）
9. **Flexget**  默认不安装。我启用了 daemon 模式（关闭shedules）和 WebUI。还预设了一些模板，仅供参考（crontab我没改）
10. **rclone**  这个没什么可以说的……默认不安装
11. **BBR**  这个会检测你的内核版本，大于4.9是默认不安装，高于4.9是默认直接启用BBR（如果你现在没有启用的话）。BBR的安装调用了秋水逸冰菊苣的脚本，会安装最新版本的内核
12. **系统设置**  主要是修改时区为 UTC+8（似乎然并卵，我以后再修复）、alias、编码设置为 UTF-8、提高系统文件打开数。默认是禁用的……

![确认信息是否有误](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.03.png)

由于安装时候没有提示二次确认和删了重新写的功能，所以如果你哪里写错了，只能先退出脚本重新再选择…… 如果没什么问题的话敲回车继续……

![安装完成](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.04.png)

安装完成后会输出各类 WebUI 的网址，以及本次安装花了多少时间。
有一点需要注意的是，Flexget WebUI 的密码强制被指定为 Flexget，无法修改……密码是你之前预设的密码
在我的10欧尚安装这些客户端花了16分钟……感觉比自己手动安装还是更省时间的……

-------------------
## BD Upload

#### 下载与安装
```
wget --no-check-certificate -qO /usr/local/bin/bdupload https://raw.githubusercontent.com/Aniverse/inexistence/master/00.Installation/script/bdupload.sh
chmod +x /usr/local/bin/bdupload
```
#### 运行
```
bdupload
```
#### 介绍

转发 BD 原盘时可以使用的一个脚本。目前可以实现以下功能：

- **判断是BDISO还是BDMV** 输入一个路径，判断是不是文件夹；是文件夹的话认为是BDMV，不是文件夹的话认为是BDISO
- 如果是BDISO，会**自动挂载镜像**成BDMV，并问你是否需要对这个挂载生成的文件夹重命名（有时候BDISO的标题就是DISC1之类的，重命名下可能更好）。操作完成后BDISO会自动解挂
- 对BD进行截图。截图时默认用1920×1080的分辨率，也可以手动填写分辨率
- **扫描 BDinfo**  默认是扫描第一个最长的mpls。也可以手动选择扫描哪一个mpls
- **生成缩略图**  这个功能默认关闭
- **制作种子**  针对BDISO，默认选择重新做种子；针对BDMV，默认选择不重新做种子

#### To Do List

- **自动上传到ptpimg**  调用 ptpimg_uploader 来完成，脚本跑完后会输出ptpimg的链接。运行之前你需要自己设置好 ptpimg_uploader
- **自动上传到 Google Drive**  调用 rclone 来完成，需要你自己在脚本里设置 rclone remote path（我会把这个设置项放在脚本开头的注释里）

![检查是否缺少软件](https://github.com/Aniverse/filesss/raw/master/Images/bdupload.01.png)

这一步脚本会检查是否存在缺少的软件，如缺少会提示你安装，如果不安装的话脚本会退出

![正常运行界面](https://github.com/Aniverse/filesss/raw/master/Images/bdupload.02.png)

![输出结果](https://github.com/Aniverse/filesss/raw/master/Images/bdupload.03.png)


-------------------
## mingling

#### 下载与安装
```
wget --no-check-certificate -qO /usr/local/bin/mingling https://raw.githubusercontent.com/Aniverse/inexistence/master/00.Installation/script/mingling.sh
chmod +x /usr/local/bin/mingling
```

#### 运行
```
mingling
```

#### 介绍

方便刷子们使用的一个脚本。有些功能还没有做完……
 不做过多的介绍了，自己看图吧
 
![mingling.03](https://github.com/Aniverse/filesss/raw/master/Images/mingling.03.png)
![mingling.04](https://github.com/Aniverse/filesss/raw/master/Images/mingling.04.png)
![mingling.05](https://github.com/Aniverse/filesss/raw/master/Images/mingling.05.png)
![mingling.06](https://github.com/Aniverse/filesss/raw/master/Images/mingling.06.png)
![mingling.07](https://github.com/Aniverse/filesss/raw/master/Images/mingling.07.png)
![mingling.08](https://github.com/Aniverse/filesss/raw/master/Images/mingling.08.png)

#### To Do List
- 添加 AutoDL-Irssi 的开关
- 添加 锐速的开关与状态检测
- 完成脚本菜单的功能

 -------------------
## bdjietu

#### 运行
```
bdjietu
```

 #### 介绍

这个是单独抽出来的，用于给BD截图的脚本。输入BDMV的路径后会自动从中找出最大的m2ts文件，截图10张到指定的目录。
其实就是用 ffmepg 来截图，不过指定了分辨率和输出的路径
 
 ![bdjietu输出结果](https://github.com/Aniverse/filesss/raw/master/Images/bdjietu.01.png)
 
  -------------------
 ## bdjietu

####  运行
```
bdinfo
```

#### 介绍

这个是单独抽出来的，用于BDMV扫描 BDino 的脚本。
运行完以后会问你是否在 SSH 上输出 BDinfo Quick Summary. （个人认为直接输出到 SSH 上复制下来就行了，没必要下回本地）

  ![bdinfo输出结果](https://github.com/Aniverse/filesss/raw/master/Images/bdinfo.01.png)
 
 BDinfo 输出结果彩色是使用了 lolcat，如果你没安装 lolcat 的话是不会有彩色的……
 
 
 
 
 