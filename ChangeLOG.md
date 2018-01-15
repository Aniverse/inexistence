# ChangeLog  
-------------------

**2018.01.15，091**  
- 修复系统为 Debian 8，不安装 Deluge 时 qBittorrent 由于 libtorrent-rasterbar-dev 版本过低无法编译的情况  

**2018.01.12，091**  
- 修复了一个我自己都不知道什么鬼的 bug  
由于计时不知道怎么回事丢了 starttime 所以无法计算，脚本直接跳过了 _end 的剩余代码，不输出最后结果了  
- 注释了 PowerFonts 的安装  
- 取消了检查系统源OK后的绿色粗体  

**2018.01.11，091 Second**  
- qBittorrent 在某些情况下不采用编译安装  
使用 libtorrent-rasterbar-dev 这个包代替，节省时间  

**2018.01.11，091 First**  
- 先安装 Deluge 再安装 qBittorrent  
- 安装前检查安装源的网站是否可以访问，系统源出错的话直接退出脚本  
从 rtinst 那边抄来了这部分的代码
- 选择 qBittorrent 版本后不显示 libtorrent 的版本  
- 不再隐藏 libtorrent-rasterbar 的 1.1 和 from repo 选项  
- 完善了 log  

**2018.01.09，090**
- **系统优化默认选项改成了 Yes**  
- 隐藏 qBittorrent 4.0.2 的选项  
- 在 /var/www 建立了到用户文件夹的软链
- 系统源加入了 wget 的安装（以防万一……）  
- 补充了 wine 的 PPA（尚未启用）  
- 补充了 oh-my-zsh 的代码（尚未完全启用）  
- 增加 IPv6 检测的时间到 5 秒  









