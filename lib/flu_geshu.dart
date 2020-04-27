import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FluGeshu {
  static const MethodChannel _channel =
  const MethodChannel('com.ld.fluGeshu');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  /*
  * 初始化个数sdk，可以传入配置，配置只能在初始化里传入，详情请见个推文档，，http://docs.getui.com/geshu/start/android/
  * enableSmartReporting和strategyType可能会有冲突，请自行斟酌
  * */
  static Future<Map> initGS({ //ios端暂时只需要传appid和渠道和上传策略。
    @required String appId, //应用标识 APPID,ios必传
    String channel='flutter', //数据来源，详情请见个推
    bool debugEnable=false, //是否开启开发者模式，实时上传数据
    int strategyType=0, //数据上报策略，1～5
    bool enableSmartReporting=true, //目前默认有 WIFI 的情况实时上传，无 WIFI 则间隔 10 分钟上报数据，以及每次启动时上传。开发者也可以手动关闭有 WIFI 情况下实时上传数据的开关
    int maxBatchReportCount=32, //（仅在发送策略为 GESHU_STRATEGY_BATCH 时有效）设置最大批量发送消息个数（默认 32 ）
    int sessionTimeMillis=30, //单位秒,应用时长统计用于统计启动次数和应用的真实活跃时长，集成 SDK 后不需要开发者调用额外的接口
    int uploadPeriodMinutes=10, //仅在发送策略为 GESHU_STRATEGY_PERIOD 时有效）设置间隔时间（默认为 10 ，单位是分钟）
  }) async {
    assert((strategyType>=0&&strategyType<5),'strategyType有效值为0～5');
    assert(maxBatchReportCount>=1,'maxBatchReportCount不能小于1');
    assert(sessionTimeMillis>=10,'sessionTimoutMillis不能小于10秒');
    assert(uploadPeriodMinutes>=1,'uploadPeriodMinutes不能小于1分钟');
    sessionTimeMillis=Platform.isAndroid?sessionTimeMillis*1:sessionTimeMillis*1000;
    Map config={
      'appId':appId,
      'channel':channel,
      'debugEnable':debugEnable,
      'strategyType':strategyType,
      'enableSmartReporting':enableSmartReporting,
      'maxBatchReportCount':maxBatchReportCount,
      'sessionTimeMillis':sessionTimeMillis,
      'uploadPeriodMinutes':uploadPeriodMinutes,
    };
    Map res={};
    try{
      res = await _channel.invokeMethod('initGS',config);
    }catch(err){
      print('失败了:$err');
    }
    return res;
  }
  static Future<Map> get getConfig async{ //获取配置
    final Map config = await _channel.invokeMethod('getConfig');
    return config;
  }
}
