# 脚本功能：自动搭建Node环境和初始化Electron项目
# 使用场景：从未搭建过Node环境的Linux64位版本
#
a=$(node -v)
if [ ${a:1:1} != 1 ];then
    echo -e "\033[31m你已经安装了Node，但是版本过低\033[0m"
    read -p "[y/n]你是通过apt安装的吗？" isAptInstall
    if [ $isAptInstall == y ];then
        read -p "[y/n]要删除Node并安装最新版本吗" isAptInstall
        if [ $isAptInstall == n ];then
            read -p "按下回车键退出程序"
        else
            #判断是否有sudo权限
            sudo -n ls
            if [ $? != 0 ];then
                echo -e "\033[31m你没有sudo权限\033[0m"
                read -p "按下回车键退出"
            else
                sudo apt purge node
            fi
        fi
    fi
fi
# 检查是否安装git
git --version
if [ $? != 0 ];then
    echo "你好像没有安装git"
    read -p "按下回车键安装git"
    sudo apt install git
fi
#
cd ~
echo "！！！本脚本只适用于从未搭建过Node环境的Linux64位版本！！！"
echo "2023-04-14版本"
echo "-----------------------------"
echo "[1]长期维护版v18.16.0"
echo "[2]最新尝鲜版v19.8.1"
echo "[3]17系列最新版v17.9.1"
echo "[4]其他版本"
echo "-----------------------------"
#
versionLinks=(
"https://mirror.tuna.tsinghua.edu.cn/nodejs-release/v18.6.0/node-v18.6.0-linux-x64.tar.xz"
"https://mirror.tuna.tsinghua.edu.cn/nodejs-release/v19.9.0/node-v19.9.0-linux-x64.tar.xz"
"https://mirror.tuna.tsinghua.edu.cn/nodejs-release/v17.9.1/node-v17.9.1-linux-x64.tar.xz"
)
#
downloadVersion() {
    read -p "请选择下载版本（填序号）：" specificVersion
    if [ $specificVersion == "4" ]; then
    read -p "按下回车键打开下载网页并退出脚本"
    xdg-open https://mirror.tuna.tsinghua.edu.cn/nodejs-release/
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
    mv node-* .node
    return 0
}
#
while ! downloadVersion; do :; done  # 无限循环，直到downloadVersion返回0
#
echo -e "\033[34m即将修改~/.bashrc文件以配置环境变量\033[0m"
sed -i "1i#--------分割线--------" ~/.bashrc
sed -i "1iexport PATH=$PATH:~/.node/bin" ~/.bashrc
sed -i "1i#搭建Node环境时添加的部分" ~/.bashrc
source ~/.bashrc
echo -e "\033[34m已修改，如果有输出版本号则成功\033[0m"
echo -e "\033[34m---------------------------------------\033[0m"
node -v
npm -v
echo -e "\033[34m---------------------------------------\033[0m"
echo -e "\033[34m即将配置cnpm\033[0m"
echo -e "\033[31m！！！以后下载包千万不要用npm！！！\033[0m"
npm config set registry https://registry.npmmirror.com
npm install -g cnpm --registry=https://registry.npmmirror.com
echo -e "\033[34m如果有输出版本号则成功\033[0m"
cnpm -v
echo -e "\033[34m---------------------------------------\033[0m"
echo -e "\033[34m初始化项目\033[0m"

wget https://i91.lanzoug.com/04150800110955609bb/2023/04/15/321630ad92f290f4106befef137b3427.7z?st=Jv3mO4rNUzsWzxwAReOQvQ&e=1681518834&b=U2APfwZ2AygHZQIu&fi=110955609&pid=112-47-64-212&up=2&mp=0&co=1
if [ $? != 0 ];then
    echo -e "\033[32m下载压缩包失败\033[0m"
    echo -e "\033[32m[1]通过浏览器打开下载页面\033[0m"
    echo -e "\033[32m[2]通过GitHub下载\033[0m"
    echo -e "\033[32m[3]用npm初始化（极其不推荐，需魔法）\033[0m"
    read -p "请选择解决方案"
fi
echo "------------------------"
echo -e "\033[32m项目初始化成功，请将代码放置于./app/src下\033[0m"
echo -e "\033[31m！！！初始页面必须是index.html！！！[0m"
echo -e "\033[31m！！！index.js必须保留！！！[0m"
read -p "脚本执行完成，按回车键退出"
exit
