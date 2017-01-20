#! /bin/sh

##############################
# 执行打包 Framework
##############################


# 引用公共的文件
source Scripts/common.sh

if [ ! $SDK_REPO_DIR ]; then
    echo "SDK_REPO_DIR not exist. Exit.";
    exit 1;
fi

# 核心的打包函数
packageFramework() {
    echo "Action - packageFramework - $1"

    if [ $# -lt 1 ]; then
        echo "At least one param is required - debug/release";
        exitAbnormal
    fi

    if [ ! $1 = debug -a ! $1 = release ]; then
        echo "First param should be debug or release";
        exitAbnormal
    fi

    buildVersion=$1;

    # lib build
    cd $SDK_REPO_DIR
    bash ${SDK_REPO_DIR}/MikeKitLib/packageLib.sh $buildVersion

    if [ $? != 0 ]; then
        echo "ERROR: packageSdkSampleLib script fail."
        exitAbnormal
    fi

    # Confirm expect output of last step
    if [ ! -f ${SDK_LIB_FILE} ]; then
        echo "Unexpected - expect file does not exist - ${SDK_LIB_FILE}"
        exitAbnormal
    fi

    # Copy lib file into framework struct 
    cp "${SDK_LIB_FILE}" "${SDK_FRAMEWORK_STRUCT_DIR}/MikeKitFramework"
    if [ $? != 0 ]; then
        echo "ERROR: failed to copy sdkSample lib into framework."
        exitAbnormal
    fi

    cd $SDK_REPO_DIR/dist

    if [ $buildVersion = debug ]; then
        zipDir="MikeKitFramework-debug-${SDK_VERSION}b${SDK_BUILDID}"
    else
        zipDir="MikeKitFramework-${SDK_VERSION}"
    fi
    mkdir $zipDir

    cp -r $SDK_FRAMEWORK_STRUCT_DIR ${zipDir}/
    if [ $? != 0 ]; then
        echo "ERROR: failed to copy sdkSample framework into dist."
        exitAbnormal
    fi

    # # Generate docset into sdk zip
    # docsetName="${SDK_DOCS_DIR}/docset"
    # cp -r $docsetName ${zipDir}/${SDK_PROJECT_NAME}.docset

    # zip -r "$zipDir.zip" $zipDir

} # end of packageFramework

