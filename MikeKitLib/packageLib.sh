#!/bin/sh

################################
### 打包 sdkSample lib 库
################################

echo "\n =================================================="
echo "Action - packageLib - $1"
echo "Current dir - `pwd`"

# 引用公共的文件
if [ ! -f Scripts/common.sh ]; then
    echo "ERROR: not found Scripts/common.h"
    exit 1
fi
source Scripts/common.sh


if [ $# -lt 1 ]; then
    echo "At least one param is required - debug/release";
    exit 1;
fi

if [ ! $1 = debug -a ! $1 = release ]; then
    echo "First param should be debug/release";
    exit 1;
fi

buildVersion=$1

# All operations in sdkSample-lib dir
cd $SDK_REPO_DIR/MikeKitLib

preBuild() {
    # 关闭 symbol 配置项
    symbolConfig close    
}

postBuild() {
    # 打开 symbol 配置项
    symbolConfig open

    # 恢复为开发模式
    changeInternalVersion debug
}

exitAbnormal() {
    postBuild
    exit 1
}


######################################
# Begin of building
################

echo "\n\n ====================== Begin of building"

preBuild

if [ $buildVersion = debug ]; then
    changeInternalVersion debug
else
    changeInternalVersion release
fi

### Call the rake to process building with Rakefile
rake

if [ $? == 0 ]; then
    echo "Rake build success."

    # Validdate result of rake    
    if [ ! -f $SDK_LIB_FILE ]; then
        echo "The expect rake build outoput file does not exist - ${SDK_LIB_FILE}"
        exitAbnormal
    fi
else
    echo "Rake build failed."
fi

postBuild

echo "====================== End of building \n\n"

##############
# End of building
##############









