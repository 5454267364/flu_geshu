#import "FluGeshuPlugin.h"
#import <GCSDK/GTCountSDK.h>

@implementation FluGeshuPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.ld.fluGeshu"
            binaryMessenger:[registrar messenger]];
  FluGeshuPlugin* instance = [[FluGeshuPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if ([@"initGS" isEqualToString:call.method]) {
      NSDictionary *args = call.arguments;
      NSString *appid=args[@"appId"];
      NSString *channel=args[@"channel"];
      BOOL debugEnable=args[@"debugEnable"];
      [GTCountSDK setDebugEnable:debugEnable];
//      BOOL enableSmartReporting=args[@"enableSmartReporting"];
//      [[GTCountSDK sharedInstance] setSmartReporting:enableSmartReporting];
      NSInteger strategyType=args[@"strategyType"];
      switch (strategyType) {
          case 0:
            break;
          case 1:
            [[GTCountSDK sharedInstance] setReportStrategy:GESHU_STRATEGY_REAL_TIME];
            break;
          case 2:
            [[GTCountSDK sharedInstance] setReportStrategy:GESHU_STRATEGY_WIFI_ONLY];
            break;
          case 3:
            [[GTCountSDK sharedInstance] setReportStrategy:GESHU_STRATEGY_BATCH];
            break;
          case 4:
            [[GTCountSDK sharedInstance] setReportStrategy:GESHU_STRATEGY_LAUNCH_ONLY];
            break;
          case 5:
            [[GTCountSDK sharedInstance] setReportStrategy:GESHU_STRATEGY_PERIOD];
            break;
          default:
              break;
      };
//      NSUInteger maxBatchReportCount=args[@"maxBatchReportCount"];
//      [[GTCountSDK sharedInstance] setMinBatchReportNumber:maxBatchReportCount];
      
//      NSUInteger sessionTimeMillis=args[@"sessionTimeMillis"];
//      [[GTCountSDK sharedInstance] setSessionTime:sessionTimeMillis];

//      NSUInteger uploadPeriodMinutes=args[@"uploadPeriodMinutes"];
//      [[GTCountSDK sharedInstance] setPeriodMinutes:uploadPeriodMinutes];
      
      
      [GTCountSDK startSDKWithAppId:appid withChannelId:channel];
      NSDictionary *ret=@{
          @"msg":@"个数应用统计初始化成功",
          @"isSuccess":@(YES),
      };
      result(ret);
  }else if([@"getConfig" isEqualToString:call.method]){
//      BOOL debugEnable=[GTCountSDK DebugEnable];
      NSUInteger strategyType=[GTCountSDK sharedInstance].reportStrategy;
      BOOL smartReporting=[GTCountSDK sharedInstance].smartReporting;
//      NSString channel=[GTCountSDK sharedInstance];
      NSUInteger maxBatchReportCount=[GTCountSDK sharedInstance].minBatchReportNumber;
      NSUInteger sessionTimeMillis=[GTCountSDK sharedInstance].sessionTime;
      NSUInteger uploadPeriodMinutes=[GTCountSDK sharedInstance].periodMinutes;
      NSDictionary *ret=@{
          @"debugEnable":@(NO), //没有找到ios端获取debugEnable的函数，所以一直返回false
          @"strategyType":@(strategyType),
          @"smartReporting":@(smartReporting),
          @"channel":@(""), //没有找到ios端获取渠道的函数，所以返回空
          @"maxBatchReportCount":@(maxBatchReportCount),
          @"sessionTimeMillis":@(sessionTimeMillis),
          @"uploadPeriodMinutes":@(uploadPeriodMinutes),
      };
      result(ret);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
