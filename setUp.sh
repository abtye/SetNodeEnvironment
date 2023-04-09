banBen = 0
dajian(){
    read -p "请选择下载版本（填序号）：" banBen
    if [ $banBen == "1" ];then
        wget https://nodejs.org/dist/latest-v18.x/node-v18.15.0-linux-x64.tar.xz
        tar -xvf node-v18.15.0-linux-x64.tar.xz
        mv node-v18.15.0-linux-x64 node
    elif [ $banBen == "2" ];then
        wget https://nodejs.org/dist/latest-v19.x/node-v19.8.1-linux-x64.tar.xz
        tar -xvf node-v19.8.1-linux-x64.tar.xz
        mv node-v19.8.1-linux-x64 node
    elif [ $banBen == "3" ];then
        wget https://nodejs.org/dist/latest-v17.x/node-v17.9.1-linux-x64.tar.xz
        tar -xvf node-v17.9.1-linux-x64.tar.xz
        mv node-v17.9.1-linux-x64 node
    elif [ $banBen == "4" ];then
        read -p "按下回车键打开下载网页并退出脚本"
        xdg-open https://nodejs.org/dist/
        exit
    else
        echo "错误的输入"
        dajian
    fi
}
cd ~
echo "！！！本脚本只适用于从未搭建过Node环境的Linux64位版本！！！"
echo "-----------------------------"
echo "[1]长期维护版v18.15.0"
echo "[2]最新尝鲜版版v19.8.1"
echo "[3]17系列最新版v17.9.1"
echo "[4]其他版本"
echo "-----------------------------"
dajian
echo "如果有输出版本号则成功，若报错请换更低的Node版本"
./node/bin/node -v
./node/bin/npm -v
sed -i "1iexport PATH=$PATH:~/node/bin" ~/.bashrc
read -p "脚本执行完成，按回车键退出"
exit
