#!/bin/sh

##########################
# 确认当前运行环境。如果 SDK_REPO_DIR 不存在，则赋值
# 其他脚本只需要单纯地检查，SDK_REPO_DIR 不存在就不执行
# 提供几个常用的方法接口
##########################

#重置并创建路径
clearAndPrepare() {
    cd $SDK_REPO_DIR

    if [ -d ./dist ]; then
        rm -rf ./dist;
    fi
    if [ -d ./build ]; then
        rm -rf ./build;
    fi

    mkdir dist/
    mkdir build/    
}

#异常退出处理
exitAbnormal() {
    resetGitworkspace $SDK_REPO_DIR
    exit 1
}


if [ ! $SDK_REPO_DIR ]; then
    BASEDIR=`pwd`
    if [ ! -d MikeKitLib ]; then
        echo "It is in bad dir to execute script - $BASEDIR"
        exit 1
    fi
    if [ ! -d MikeKitFramework ]; then
        echo "It is in bad dir to execute script - $BASEDIR"
        exit 1
    fi

    SDK_REPO_DIR=$BASEDIR
    export SDK_REPO_DIR
    echo "sdkSample repo base dir: $SDK_REPO_DIR"
fi




######################
### 定义几个常用方法
######################

### 变更内部 debug 开关
### 必须要有一个参数： debug/release
changeInternalVersion() {
    echo "\n Action - changeInternalVersion - $1"
    if [ ! $1 ]; then
        echo "This func expect one param - debug/release";
        return 1;
    fi
    if [ ! $1 = "debug" -a ! $1 = "release" ]; then
        echo "This func expect one param - debug/release";
        return 1;
    fi
    
    if [ $1 = "debug" ]; then
        expectInternalVersion=1;
    else 
        expectInternalVersion=0;
    fi

    currentDir=`pwd`

    # 设置开发测试环境，日志显示内容等等，主要就是为开发都提供文件
    # 可以根据 expectInternalVersion 来控制相关逻辑

    cd $currentDir


}

### 打开或者关闭工程配置文件里的 debug symbol 配置项
### 必须要有一个参数 open/close
symbolConfig() {
    echo "\n Action - symbolConfig - $1"

    if [ ! $1 ]; then
        echo "Expect one param - open/close";
        return 1;
    fi

    if [ ! $1 = "open" -a ! $1 = "close" ]; then
        echo "Expect one param - open/close";
        return 1;
    fi  

    # 工作目录不特定
    echo "Current dir - `pwd`"

    projectFile=`ls *.xcodeproj/project.pbxproj`
    if [ ! projectFile ]; then
        echo "Failed to find project.pbxproj file unser *.xcodeproj dir. Please confirm xcode project exists. "
        return 1
    fi
    
    if [ $1 = open ]; then
        CUR_SYMBOL=NO;
        EXPECT_SYMBOL=YES;
    else
        CUR_SYMBOL=YES;
        EXPECT_SYMBOL=NO;     
    fi

    findResult=`grep -o -c "GCC_GENERATE_DEBUGGING_SYMBOLS = ${CUR_SYMBOL}" $projectFile`

    if [ ${findResult:=0} -gt 0 ]; then
        echo "Find the symbol - GCC_GENERATE_DEBUGGING_SYMBOLS = ${CUR_SYMBOL}. Change it."
        sed -i "" "s/GCC_GENERATE_DEBUGGING_SYMBOLS = ${CUR_SYMBOL}/GCC_GENERATE_DEBUGGING_SYMBOLS = ${EXPECT_SYMBOL}/g" $projectFile

        findResult2=`grep -o -c "GCC_GENERATE_DEBUGGING_SYMBOLS = ${CUR_SYMBOL}" $projectFile`
        if [ ${findResult2:=0} -gt 0 ]; then
            echo "Unepxected - still find the symbol. "
        fi
    else
        echo "No need to change."
    fi
}


### 从代码里获取当前 Version/BuildID
getVersion() {
    echo "\n Action - getVersion"

    cd $SDK_REPO_DIR/MikeKitLib

    VERSION_LINE=`grep -o '^#define SDK_VERSION @\"[0-9.]*\"$' MikeKitLib/Public/MikeSDKInfo.h`
    echo "VERSION_LINE:$VERSION_LINE"
    if [ ! "$VERSION_LINE" ]; then
        echo "Not found version definition. "
        return 1
    fi

    SDK_VERSION=`echo $VERSION_LINE | awk -F \" '{print $2}'`
    echo "Found SDK version: $SDK_VERSION"

    # 得到了版本号，导出到环境变量
    export SDK_VERSION


    BUILDID_LINE=`grep -o '^#define SDK_BUILD [0-9.]*' MikeKitLib/Public/MikeSDKInfo.h`
    if [ ! "$BUILDID_LINE" ]; then
        echo "Not found buildId definition. "
        return 1
    fi

    SDK_BUILDID=`echo $BUILDID_LINE | awk '{print $3}'`
    echo "Found sdkSample buildId: ${SDK_BUILDID}"

    # 得到了Build号，导出到环境变量
    export SDK_BUILDID
}


### 打包时更新代码里的 buildID 
updateBuildID() {
    getVersion
    cd $SDK_REPO_DIR/MikeKitLib
    # 每次构建版本，build + 1
    newbuildID=$((10#${SDK_BUILDID}+1)) 
    # 替换原来的版本号
    sed -i "" "/#define SDK_BUILD /s/$SDK_BUILDID/$newbuildID/g" MikeKitLib/Public/MikeSDKInfo.h
    if [ $? != 0 ]; then return 1; fi

    sed -i "" "/#define SDK_BUILD /s/$SDK_BUILDID/$newbuildID/g" ../MikeKitFramework/MikeKitFramework/MikeSDKInfo.h
    if [ $? != 0 ]; then return 1; fi

    echo "buildID updated to: ${newbuildID}"
    # 将更新提交
    git add MikeKitLib/Public/MikeSDKInfo.h
    git add ../MikeKitFramework/MikeKitFramework/MikeSDKInfo.h
    git commit -m "updateBuildID"
}

# 检查仓库是否干净
checkGitWorkspaceClean() {
    echo "Action - checkGitWorkspaceClean"

    if [ $# -lt 1 ]; then
        echo "One param is required - the check dir.";
        exit 1;
    fi

    if [ ! -d $1 ]; then
        echo "The dir does not exist - $1";
        exit 1;
    fi

    currentDir=`pwd`
    cd $1

    result=`git status -s`
    if [ -n "$result" ]; then
        echo "The git workspace is not clean - $1"
        exit 1
    fi

    cd $currentDir
}


resetGitworkspace() {
    echo "Action - resetGitworkspace"

    if [ $# -lt 1 ]; then
        echo "One param is required - the check dir.";
        exit 1;
    fi

    if [ ! -d $1 ]; then
        echo "The dir does not exist - $1";
        exit 1;
    fi

    currentDir=`pwd`
    cd $1
    git checkout .
    cd $currentDir
}



