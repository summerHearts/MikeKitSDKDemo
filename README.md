# MikeKitSDKDemo
问题来源： 逛简书发现一篇关于SDK开发的文章，主要是去看评论，发现这个问题，连接   [问题链接 戳这里](http://www.jianshu.com/p/84027026bc27) 。

我写的Demo地址： [MikeSDK](https://github.com/summerHearts/MikeSDK)
请下下来，边看工程结构边看操作。
 
![问题.png](http://upload-images.jianshu.io/upload_images/325120-6d9974184995d9bf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

那么怎么解决这种问题呢？方法还是有的，请往下看。

文章中提到了一个问题，怎么在两个target之间共用一个或者多个第三方库。本文采用
abstract_target 'CommonPods' do  

# 多个target共用一套pod的写法。

比如我的文件结构是这样的。 如果Interface 这个tagret 和  MikeSDKDemo 这个target都需要使用AFNetworking。那么怎么写pod file文件呢？

![AF2C04AD-C767-4BA9-8D51-CBE4AED66EDD.png](http://upload-images.jianshu.io/upload_images/325120-1b72e5a2eef149a6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)  

更新完毕之后，需要去buildSetting 中设置一些配置信息。

![屏幕快照 2017-01-12 下午9.54.17.png](http://upload-images.jianshu.io/upload_images/325120-e1330e0d6840bf20.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![70AAEEBE-DC8F-4B20-BBC8-2C3B22FA41BE.png](http://upload-images.jianshu.io/upload_images/325120-2ca37519e556fc32.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
