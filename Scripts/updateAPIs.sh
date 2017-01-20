#!/bin/sh

##############################
# 更新项目里的对外 API 头文件到本项目，并且做 import 形式的转换工作
##############################

echo "\n=================================================="
echo "Action - updateAPIs"

# 引用公共的文件
source Scripts/common.sh

if [ ! $SDK_REPO_DIR ]; then
    echo "SDK_REPO_DIR not exist. Exit.";
    exit 1;
fi

SOURCE_PATH_ROOT="${SDK_REPO_DIR}/MikeKitLib/MikeKitLib/Public"
#这里可以有SOURCE_PATH_ROOT其它的子目录

DEST_PATH_ROOT="${SDK_REPO_DIR}/MikeKitFramework/MikeKitFramework"
#这里可以有DEST_PATH_ROOT其它的子目录

SOURCE_DIRS=($SOURCE_PATH_ROOT)
DEST_DIRS=($DEST_PATH_ROOT)

## 先确认目录环境是否正常
existDir() {
    theDir=`ls $1`
    if [ ! theDir ]
    then
        echo -e "$1 does not exist. Not the right path to execute the script."
        exit
    fi
}

existDir $SOURCE_PATH_ROOT
existDir $DEST_PATH_ROOT

src_imports=('#import \"MikeSDKInfo.h\"',
		'#import \"SDKConstants.h\"'
    )
dest_imports=('#import <MikeKitFramework\/MikeSDKInfo.h>',
		'#import <MikeKitFramework\/SDKConstants.h>'
    )

replace_imports() {
    len_imports="${#src_imports[@]}"
    for i in `seq $len_imports`
    do
        `sed -i "" "s/${src_imports[$i-1]}/${dest_imports[$i-1]}/g" $1`
    done
}

index=0
for dir in "${SOURCE_DIRS[@]}"
do

    for file in $dir/*.h;
    do
        filename=$(basename $file)
        destFile="${DEST_DIRS[$index]}/$filename"

        `cp "$file" "$destFile"`

        replace_imports "$destFile"
    done

    let "index+=1"
done

## Insert all .h imports into sdkSample.h - the only import file for App
sdkSampeFile="$DEST_PATH_ROOT/MikeSDKInfo.h"
echo "Insert imports into MikeSDKInfo.h - $sdkSampeFile"

sed -i "" '9 a\
    #import <MikeKitFramework\/SDKConstants.h>\
    ' $sdkSampeFile
