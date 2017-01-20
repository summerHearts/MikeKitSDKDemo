#!/bin/sh

#######################################################
### Package sdkSample.framework folder structure.
#######################################################

echo "\n=================================================="
echo "Action - packageTempFramework"
echo "Current dir - `pwd`"

# 引用公共的文件
if [ ! -f Scripts/common.sh ]; then
    echo "ERROR: not found Scripts/common.h"
    exit 1
fi
source Scripts/common.sh


# 更新 API 文件
source Scripts/updateAPIs.sh

cd $SDK_REPO_DIR/MikeKitFramework

# rake build
rake

if [ $? == 0 ]; then 
    echo "Rake build success"

    # Validdate result of rake    
    if [ ! -d $SDK_FRAMEWORK_STRUCT_DIR ]; then
        echo "The expect rake build outoput dir does not exist - ${SDK_FRAMEWORK_STRUCT_DIR}"
        exit 1
    fi

    # Write version/buildId into framework info.plist
    defaults write $SDK_FRAMEWORK_STRUCT_DIR/Info CFBundleVersion $SDK_BUILDID
    defaults write $SDK_FRAMEWORK_STRUCT_DIR/Info CFBundleShortVersionString $SDK_VERSION
else 
    echo "Rake build failed"
fi


