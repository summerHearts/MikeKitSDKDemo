#!/bin/sh

###################################
# Build sdkSample.framework
# If there is one param - debug/release, will package ther version. Otherwise package both debug and release version.
###################################

echo "\n=================================================="
echo "Action - packageDdkSampleeFramework"
echo "Current dir - `pwd`"

# 引用公共的文件
if [ ! -f Scripts/common.sh ]; then
    echo "ERROR: cannot found the Script/common.h"
    exit 1
fi
source Scripts/common.sh

if [ ! -f Scripts/debugOrReleaseFramework.sh ]; then
echo "ERROR: cannot found the Script/common.h"
exit 1
fi
source Scripts/debugOrReleaseFramework.sh


if [ ! $SDK_REPO_DIR ]; then
    echo "SDK_REPO_DIR not exist. Exit.";
    exit 1;
fi

if [ $# -gt 0 ]; then
    if [ ! $1 = debug -a ! $1 = release ]; then
        echo "First param should be debug/release";
        exit 1;
    fi

    buildVersion=$1
fi


# Prepare
clearAndPrepare

# Confirm the git workspace is clean. 
# checkGitWorkspaceClean $SDK_REPO_DIR

# get and set version
updateBuildID
if [ $? != 0 ]; then exitAbnormal; fi
getVersion
if [ $? != 0 ]; then exitAbnormal; fi

# Expect output definitions

PROJECT_NAME="MikeKitSDKDemo"
export PROJECT_NAME

SDK_LIB_FILE="${SDK_REPO_DIR}/build/MikeKitFramework-${SDK_VERSION}b${SDK_BUILDID}.a"
export SDK_LIB_FILE

SDK_FRAMEWORK_STRUCT_DIR="${SDK_REPO_DIR}/build/MikeKitFramework.framework"
export SDK_FRAMEWORK_STRUCT_DIR

SDK_DOCS_DIR="${SDK_REPO_DIR}/build/appledoc"
export SDK_DOCS_DIR


echo "\n\n\n ===================== Begin packaging"

cd $SDK_REPO_DIR
bash ${SDK_REPO_DIR}/MikeKitFramework/packageTempFramework.sh
if [ $? != 0 ]; then
    echo "ERROR: packageTempFramework script fail."
    exitAbnormal
fi

# Check expected outout dir exist
if [ ! -d $SDK_FRAMEWORK_STRUCT_DIR ]; then
    echo "ERROR: expect output dir not exist - $SDK_FRAMEWORK_STRUCT_DIR"
    exitAbnormal
fi

# bash ${SDK_REPO_DIR}/Scripts/sdkSampleDoc.sh
# if [ $? != 0 ]; then
#     echo "ERROR: sdkSample doc script fail."
#     exitAbnormal
# fi


# To package debug/release framework zip
cd $SDK_REPO_DIR/MikeKitLib
if [ $buildVersion ]; then
    packageFramework $buildVersion
else 
    packageFramework debug
    packageFramework release
fi

resetGitworkspace $SDK_REPO_DIR

echo "===================== End packaging \n\n\n "



