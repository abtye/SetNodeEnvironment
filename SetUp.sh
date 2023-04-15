# 脚本功能：自动搭建Node环境和初始化Electron项目
# 使用场景：从未搭建过Node环境的Linux64位版本
#
a=$(node -v)
if [ ${a:1:1} != 1 ];then
    echo -e "\033[31m你已经安装了Node，但是版本过低\033[0m"
    read -rp "[y/n]你是通过apt安装的吗？" isAptInstall
    if [ $isAptInstall == y ];then
        read -rp "[y/n]要删除Node并安装最新版本吗" isAptInstall
        if [ $isAptInstall == n ];then
            read -rp "按下回车键退出程序"
        else
            #判断是否有sudo权限
            sudo -n ls
            if [ $? != 0 ];then
                echo -e "\033[31m你没有sudo权限\033[0m"
                read -rp "按下回车键退出"
            else
                sudo apt purge node
            fi
        fi
    fi
fi
# 检查是否安装git
git --version
if [ $? != 0 ];then
    echo -e "\033[34m你好像没有安装git\033[0m"
    read -rp "按下回车键安装git"
    sudo apt install git
fi
#
cd ~
echo -e "\033[34m！！！本脚本只适用于从未搭建过Node环境的Linux64位版本！！！\033[0m"
echo -e "\033[34m2023-04-14版本\033[0m"
echo -e "\033[34m[1]长期维护版v18.16.0\033[0m"
echo -e "\033[34m[2]最新尝鲜版v19.8.1\033[0m"
echo -e "\033[34m[3]17系列最新版v17.9.1\033[0m"
echo -e "\033[34m[4]其他版本\033[0m"
echo -e "\033[34m---------------------------------------\033[0m"
#
versionLinks=(
"https://mirror.tuna.tsinghua.edu.cn/nodejs-release/v18.6.0/node-v18.6.0-linux-x64.tar.xz"
"https://mirror.tuna.tsinghua.edu.cn/nodejs-release/v19.9.0/node-v19.9.0-linux-x64.tar.xz"
"https://mirror.tuna.tsinghua.edu.cn/nodejs-release/v17.9.1/node-v17.9.1-linux-x64.tar.xz"
)
#
downloadVersion() {
    read -rp "请选择下载版本（填序号）：" specificVersion
    if [ $specificVersion == "4" ]; then
    read -rp "按下回车键打开下载网页并退出脚本"
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
    wget -q $versionLink
    tar -xvf node-*.tar.xz -q
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
#
wget -q "https://objects.githubusercontent.com/github-production-release-asset-2e65be/625408126/cbbd19f9-c38e-4ef6-97b7-79577d0c2ac3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230415%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230415T031845Z&X-Amz-Expires=300&X-Amz-Signature=d796ea11342a68545016af40df10c15f02e5bf76479813a7909505f6effe21e6&X-Amz-SignedHeaders=host&actor_id=123047756&key_id=0&repo_id=625408126&response-content-disposition=attachment%3B%20filename%3Dapp.tar.xz&response-content-type=application%2Foctet-stream"
if [ $? != 0 ]; then
    echo -e "\033[31m下载压缩包失败\033[0m"
    echo -e "\033[32m[1]重新下载\033[0m"
    echo -e "\033[32m[2]从兰奏云下载（不一定行）\033[0m"
    echo -e "\033[32m[3]通过浏览器打开兰奏云下载页面（大概率行）\033[0m"
    echo -e "\033[32m[4]通过浏览器打开GitHub下载页面（肯定行）\033[0m"
    echo -e "\033[32m[5]用cnpm初始化（极其不推荐，神之bug，需要安装git）\033[0m"
    read -rp "请选择解决方案: " choose
#
    case $choose in
        1)
            wget -cq "https://objects.githubusercontent.com/github-production-release-asset-2e65be/625408126/cbbd19f9-c38e-4ef6-97b7-79577d0c2ac3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230415%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230415T031845Z&X-Amz-Expires=300&X-Amz-Signature=d796ea11342a68545016af40df10c15f02e5bf76479813a7909505f6effe21e6&X-Amz-SignedHeaders=host&actor_id=123047756&key_id=0&repo_id=625408126&response-content-disposition=attachment%3B%20filename%3Dapp.tar.xz&response-content-type=application%2Foctet-stream"
            ;;
        2)
            wget https://developer.lanzoug.com/file/?BmBbZQ8+U2IDCgM7ADVVOVNsAztRbwFzVyAGLlw3UCsEIgY3DztQaAIxBA1Tbl04AGcANFE/ADIGOAAwVjxXZQY3Wz8PdFNhAyYDaABsVWRTPAMxUToBN1diBjhcJlAhBHQGbA9gUDQCZgRhUyhdbABuACpRPwA3Bi4AMlY+V2MGZ1s/D2pTNANkA2IAMlU3UzoDYlFtAWdXZAYzXDZQNARlBjIPZ1A1AmUENlMwXWoAOwBgUTsAZgY5AChWPVcsBiBbeQ8hU2IDJwM8ADBVaVM6AzdRPQExV2MGMVw4UHcEcAY4Dz9QYQIyBG9TNl1qAGIANFE7ADAGNgA0VjNXbgYoWyIPdFNhAzkDIgBpVWRTLwNzUX4BdFdtBjFcNlBpBDUGZA9gUDICZQRjUz5degAvAGxRfgA/BjAAN1Y4V3gGMls7D3xTMQNhA3sAZlVlUzs=
            ;;
        3)
            echo -e "\033[32m密码：1111\033[0m"
            read -rp "按下回车键跳转"
            xdg-open https://wwlf.lanzoue.com/iTgyQ0t1d4kd
            ;;
        4)
            xdg-open https://github.com/abtye/SetNodeEnvironment/tags
            ;;
        5)
            cnpm init electron-app@latest app
            ;;
        *)
            echo -e "\033[31m错误的输入\033[0m"
            ;;
    esac
fi
#
echo -e "\033[32m项目初始化成功，请将代码放置于./app/src下\033[0m"
echo -e "\033[31m！！！初始页面必须是index.html！！！\033[0m"
echo -e "\033[31m！！！index.js必须保留！！！\033[0m"
read -rp "脚本执行完成，按回车键退出"
exit
