cd ~
echo "！！！本脚本只适用于从未搭建过Node环境的Linux64位版本！！！"
echo "-----------------------------"
echo "[1]长期维护版v18.15.0"
echo "[2]最新尝鲜版版v19.8.1"
echo "[3]17系列最新版v17.9.1"
echo "[4]其他版本"
echo "-----------------------------"
#
versionLinks=(
"https://nodejs.org/dist/latest-v18.x/node-v18.15.0-linux-x64.tar.xz"
"https://nodejs.org/dist/latest-v19.x/node-v19.8.1-linux-x64.tar.xz"
"https://nodejs.org/dist/latest-v17.x/node-v17.9.1-linux-x64.tar.xz"
)
#
downloadVersion() {
    read -p "请选择下载版本（填序号）：" specificVersion
    if [ $specificVersion == "4" ]; then
    read -p "按下回车键打开下载网页并退出脚本"
    xdg-open https://nodejs.org/dist/
    exit
    fi
    #
    if ! [[ "$specificVersion" =~ ^[1-3]$ ]]; then
        echo "错误的输入"
        return 1
    fi
    #
    versionLink=${versionLinks[$specificVersion-1]}
    wget $versionLink
    tar -xvf node-*.tar.xz
    rm node-*.tar.xz
    mv node-* node
    return 0
}
#
while ! downloadVersion; do :; done  # 无限循环，直到downloadVersion返回0
#
echo "如果有输出版本号则成功，若报错请换更低的Node版本"
./node/bin/node -v
./node/bin/npm -v
baocuo(){
    read -p "报错了吗？[y/n]" myVar
    if [ $myVar == "n" ];then
        echo "没报错就好"
    elif [ $myVar == "y" ];then
        echo "即将删除node文件夹以重新搭建环境"
        rm -r node
        dajian
    else
        echo "错误的输入"
        baocuo
    fi
}
baocuo
echo "即将修改~/.bashrc文件以配置环境变量"
sed -i "1i#搭建Node环境时添加的部分" ~/.bashrc
sed -i "1iexport PATH=$PATH:~/node/bin" ~/.bashrc
sed -i "1i#--------分割线--------" ~/.bashrc
sourse ~/.bashrc
echo "已修改，如果有输出版本号则成功"
echo "------------------------"
node -v
npm -v
echo "------------------------"
echo "即将配置cnpm"
echo "以后下载包千万不要用npm！！！"
npm install -g cnpm --registry=https://registry.npmmirror.com
echo "如果有输出版本号则成功"
cnpm -v
echo "------------------------"
echo "初始化项目"
cnpm init electron-app@latest app
echo "------------------------"
echo "项目初始化成功，请将代码放置于./app/src下"
echo "！！！初始页面必须是index.html！！！"
echo "！！！index.js必须保留！！！"
read -p "脚本执行完成，按回车键退出"
exit