dict 为QstarDict的字典文件

repo 为fedora常用的库

tmux 为tmux基本配置

cmdvpn 为linux命令行启用http代码设置

config 为linux ssh session保持配置，需要放置在 ~/.ssh/中

wps-office为wps可以替代openOffice

fedora 字体安装:
在安装了fedora系统后，默认带的字体比较少，甚至于我在用五笔输入法的时候都会出现一些字无法显示的情况，这里就将windows 7系统下的字体都安装到fedora系统中。

1.首先从windows 7中的windows目录下，复制一份Fonts目录，除了ttf字体文件外，其它文件没有用，都清理掉

2.将刚才准备好的Fonts目录复制到fedora系统中，改名为win-font (名字以好记为主)。

3.安装字体
打开终端，执行下面的命令，非root用户可能需要在命令前加sudo命令。 将字体目录复制到系统的字体目录中：

cd /usr/share/fonts
mkdir win-fonts
cp ****.ttf win-fonts/
cp *.TTF win-fonts/
mkfontscale
mkfontdir
fc-cache -fv

4.在字体目录中会生成fonts.dir和fonts.scale文件，这表示已经安装成功了。
