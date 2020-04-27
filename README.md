# flu_geshu

个数flutter版，

## TIP
  安卓端和ios端都没有做自定义事件文档里的功能
  
  其他功能都有。。。
  
  设置debugEnable=true能够实时看到结果，正式版建议关闭
  
  ios端初始化暂时只需要传appid和渠道和上传策略（看不懂个推的文档。。。）。
  
  ios端获取配置：
  
    是否开发模式：没有找到ios端获取是否开发模式的函数，所以一直返回false
	 
    渠道：没有找到ios端获取渠道的函数，所以getConfig函数一直返回空

## 安卓  （详情见---[个推文档](http://docs.getui.com/geshu/start/android/)）
  1.到个推获取appid
  
  2.配置个数应用参数,APP_ID 为步骤1中从官方网站获取到的值，APP_CHANNEL 为将要发布的渠道。(渠道若为纯数字字符串不能超过int表示的范围)
  

        manifestPlaceholders = [
			GS_APPID : "APP_ID",
			GT_INSTALL_CHANNEL : "APP_CHANNEL"
        ]
		
  
  3.配置：配置要写在初始化的函数里，只能写在初始化的函数里
  
  4.SDK权限   [SDK权限配置说明1](http://docs.getui.com/geshu/question/sdk/)  [SDK权限配置说明2](http://docs.getui.com/geshu/start/android/#doc-title-2)
  
  5.初始化
  
  
		FluGeshu.initGS(appId: '123qwe').then((res){
		  print(res);
		});
  
  
  6.注意事项，如果使用不了并且排除了其他原因，尝试导入个推的包（getuiflut: 0.1.7 #个推），我自己有引用个推的包进行推送
## ios  （详情见---[个推文档](http://docs.getui.com/geshu/start/ios/)）
  0.[ios端注意事项](http://docs.getui.com/geshu/start/ios/#3-1-2-podfile)
  
  1.到个推获取appid
  
  2.注意: 为了获取精准的统计结果，需添加 AdSupport.framework 库支持
  
  3.初始化
  
  
  		FluGeshu.initGS(appId: '123qwe').then((res){
  		  print(res);
  		});
  
  
## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
