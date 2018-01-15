# ChangeLog  
> 代码内部排版问题、不怎么影响使用的修改就不列出来了  

**2018.01.15**  
`inexistence 0.9.1`  
1. 修复系统为 Debian 8，不安装 Deluge 时 qBittorrent 由于 libtorrent-rasterbar-dev 版本过低无法编译的情况  
ChangeLOG 0.0.1`  
1. 第一次写 changelog，20180104-20180115  

**2018.01.12**  
`inexistence 0.9.1`  
1. 修复了一个我自己都不知道什么鬼的 bug  
由于计时不知道怎么回事丢了 starttime 所以无法计算，脚本直接跳过了 _end 的剩余代码，不输出最后结果了  
2. 注释了 PowerFonts 的安装  
3. 取消了检查系统源 OK 后的绿色粗体  

**2018.01.11 Second**  
`inexistence 0.9.1`  
1. qBittorrent 在某些情况下不编译，用 libtorrent-rasterbar-dev 代替以节省时间

**2018.01.11 First**  
`inexistence 0.9.1`  
1. 先安装 Deluge 再安装 qBittorrent  
2. 安装前检查安装源的网站是否可以访问，系统源出错的话直接退出脚本  
3. 选择 qBittorrent 版本后不显示 libtorrent 的版本  
4. 不再隐藏 libtorrent-rasterbar 的 1.1 和 from repo 选项  
5. 完善了 log  

**2018.01.09**
`inexistence 0.9.0`  
1. **系统优化默认选项改成了 Yes**  
2. 隐藏 qBittorrent 4.0.2 的选项  
3. 在 /var/www 建立了到用户文件夹的软链
4. 系统源加入了 wget 的安装（以防万一……）  
5. 补充了 wine 的 PPA（尚未启用）  
6. 补充了 oh-my-zsh 的代码（尚未完全启用）  
7. 增加 IPv6 检测的时间到 5 秒  

**2018.01.04**
`ipv6 & xiansu`
1. 改进判断默认网卡的方式  
先是识别出本机 IPv4 地址，然后再在 ifconfig 的结果里找包含这个地址的上一排里的网卡名  
也不知道靠不靠谱，感觉应该比之前的靠谱……











































