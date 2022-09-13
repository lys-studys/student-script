#!/bin/bash
#sudo adduser new_user
#sudo usermod -G sudo new_user
#sudo su - new_user
#echo "用户配置完成"
#配置sshd
new_user=$1
n=`sudo grep -n "ClientAliveInterval " /etc/ssh/sshd_config | awk -F':' '{print $1}'`
TMPn='ClientAliveInterval 60'
m=`sudo grep -n "ClientAliveCountMax " /etc/ssh/sshd_config | awk -F':' '{print $1}'`
TMPm='ClientAliveCountMax 3'
sudo sed -i "$[ n ]c $TMPn" /etc/ssh/sshd_config
sudo sed -i "$[ m ]c $TMPm" /etc/ssh/sshd_config

#sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 60' /etc/ssh/sshd_config
#sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 3'
#sudo service sshd restart
# 配置vim
#echo "配置vim\n"> kkb_env_log
sudo apt update
sudo apt install git
if [ ! -f "/home/$new_user/install_vim.sh" ]; then
    echo "install_vim.sh 文件不存在"
else
    echo "install_vim.sh 文件已存在，已删除"
    rm /home/$new_user/install_vim.sh*
fi
wget 47.93.11.51:88/install_vim.sh
bash install_vim.sh
echo "配置vim成功\n" >> kkb_env_log
# zsh的安装及配置

echo "配置zsh\n" >> kkb_env_log
sudo apt install zsh
chsh -s /bin/zsh
if [ ! -f "/home/$new_user/install_zsh.sh" ]; then
    echo "install_zsh.sh 文件不存在"
else
    echo "install_zsh.sh 文件已存在，已删除"
    rm /home/$new_user/install_zsh.sh*
fi

wget 47.93.11.51:88/install_zsh.sh
bash install_zsh.sh kkb
#exec zsh -l
#kii exex zsh
#pid='ps -A |grep ’zsh -l‘| awk ‘{print $1}’'
#kill -9 $!


git clone https://gitee.com/suyelu/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 
# 替换文件中的内容
sed -i 's/plugins=()/plugins=(git zsh-syntax-highlighting)/' ~/.zshrc
echo "配置zsh成功，内容替换完成">> kkb_env_log
#vim ~/.zshrc
# 使用命令`vim ~/.zshrc`打开.zshrc文件，找到`plugins=()`这一行，将zsh-syntax-highlighting添加进去
#plugins=(git zsh-syntax-highlighting)
#命令自动补全插件
echo "自动补全插件配置\n">> kkb_env_log
mkdir ~/.oh-my-zsh/plugins/incr
wget http://mimosa-pudica.net/src/incr-0.2.zsh -O ~/.oh-my-zsh/plugins/incr/incr.plugin.zsh
echo "自动补全插件完成\n" >> kkb_env_log
##目录自动跳转插件

echo "目录跳转插件配置\n" >> kkb_env_log
sudo apt install autojump
echo 'autoload -U colors && colors'  >> ~/.zshrc
echo 'PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%1~ %{$reset_color%}%# "' >> ~/.zshrc
echo 'RPROMPT="[%{$fg[yellow]%}%?%{$reset_color%}]"' >> ~/.zshrc
echo '[ -r "/etc/zshrc_$TERM_PROGRAM" ] && . "/etc/zshrc_$TERM_PROGRAM"' >> ~/.zshrc
echo 'source /usr/share/autojump/autojump.sh' >> ~/.zshrc
echo 'source ~/.oh-my-zsh/plugins/incr/incr*.zsh' >> ~/.zshrc
sudo apt install ctags 
ctags -I __THROW -I __attribute_pure__ -I __nonnull -I __attribute__ --file-scope=yes --langmap=c:+.h --languages=c,c++ --links=yes --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q  -f ~/.vim/systags /usr/include/* /usr/include/x86_64-linux-gnu/sys/* /usr/include/x86_64-linux-gnu/bits/*  /usr/include/arpa/*

#  使用命令`vim ~/.vimrc`编辑.vimrc，在最后添加以下内容
#  set tags+=~/.vim/systags
echo 'set tags+=~/.vim/systags' >> ~/.vimrc

echo "配置开课吧检测命令" >> kkb_env_log
sudo apt install glibc-doc

# 文件直接覆盖
# 文件直接覆盖
if [[ "$`echo arch`" ==  x86* ]];then
    echo "这个是x86架构"
    wget http://123.57.102.65/data/kkb_check_ubuntu_18.04 -O kkb_check
else 
    echo "这个是arm架构"	
    wget http://123.57.102.65/data/kkb_check_ubuntu_18.04_arm -O kkb_check
fi
chmod a+x kkb_check
sudo mv kkb_check /usr/bin
echo "配置gcc  g++命令" >> kkb_env_log
# 配置gcc
sudo apt install gcc

# 配置g++
sudo apt install g++

# sudo cd ~
rm kkb_env_log
echo "云主机配置完成，请重新连接云服务器"
exit


