#!/bin/bash
cp ./kkb_env.sh /root/
cp ./kkb.sh /root/
cd /root/
sudo hostnamectl set-hostname kkb_xiaokai
echo "名字切换完成"
host_ip=`sudo ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
#echo $host_ip
host_kkb_xiaokai=`sudo grep -n "$host_ip" /etc/hosts | awk -F':' '{print $1}'`
host_kkb_xiaokai=${host_kkb_xiaokai[0]}

if [ ! -n "$host_kkb_xiaokai" ]; then
    echo "未查询到，尾部追加数据"
    echo "$host_ip	kkb_xiaokai	kkb_xiaokai" >> /etc/hosts
else 
    echo "已查询到，文件内容替换"
    host_kkb_xiaokai_TMP="$host_ip	kkb_xiaokai	kkb_xiaokai"
    #bool_kkb_xiaokai=`sudo grep -n '%sudo	ALL=(ALL:ALL) ALL' /etc/sudoers | awk -F':' '{print $1}'`
    sudo sed -i "$[ host_kkb_xiaokai ]c $host_kkb_xiaokai_TMP" /etc/hosts
fi
echo "kkb_xiaokai 欢迎新学员"
echo "输入名字尽量全英文哦~别的格式可能会报错，在此处报错就是名字输入的问题"
read -p "please input your username :" username

#username=new_user16
sudo adduser $username --force-badname
sudo usermod -G sudo $username
echo "用户配置完成"
#sudo cp kkv_env.sh /home/new_user/


cp kkb_env.sh /home/$username/
chown $username /home/$username/kkb_env.sh
chgrp $username /home/$username/kkb_env.sh
chmod 777 /home/$username/kkb_env.sh

#sudo cp kkv_env.sh /home/new_user/
#su new_user -c "sudo bash kkv_env.sh"
#su -oracle -s new_user -c `sudo bash kkv_env.sh`
#sudo echo 'root ALL = NOPASSWD:ALL' >> /etc/sudoers
q=`sudo grep -n '%sudo	ALL=(ALL:ALL) ALL' /etc/sudoers | awk -F':' '{print $1}'`
#echo "q"$q

if [ ! -n "$q" ]; then
    echo "sudo命令权限已经改变"
else 
    TMPq='%sudo	ALL=(ALL:ALL) NOPASSWD: ALL'
    sudo sed -i "$[ q ]c $TMPq" /etc/sudoers
    echo "sudo权限修改完成"
fi
#num=`cat -n /etc/sudoers|grep 'Defaults   visiblepw'|awk '{print $1}'`
num=`sudo grep -n 'Defaults   visiblepw' /etc/sudoers | awk -F':' '{print $1}'`
#echo $num
if [ ! -n "$num" ]; then
  echo "Defaults visiblepw IS NULL"
  sudo echo 'Defaults   visiblepw' >> /etc/sudoers
else
  echo "Defaults visiblepw NOT NULL"
fi

#if [ $num ]; then
#    echo "有内容"
#else 
#    echo "没有内容，添加内容"
#    sudo echo 'Defaults   visiblepw' >> /etc/sudoers
#fi
su - $username -c "bash kkb_env.sh $username"

rm /home/$username/install_vim.sh*
rm /home/$username/kkb_env.sh*
rm /home/$username/install_zsh.sh*


l=`sudo grep -n '%sudo	ALL=(ALL:ALL) NOPASSWD: ALL' /etc/sudoers | awk -F':' '{print $1}'`
if [ ! -n "$l" ]; then
    echo "sudo 命令不用修改或检查命令是否为原文件"
else 
    TMPl='%sudo	ALL=(ALL:ALL) ALL'
    sudo sed -i "$[ l ]c $TMPl" /etc/sudoers
    echo "sudo 内容已经恢复"
fi

#rm $username /home/$username/install_vim.sh*
#rm $username /home/$username/kkb_env.sh
#rm $username /home/$username/install_zsh.sh*
cd /home/$username
su $username
#sudo bash kkb_env.sh
