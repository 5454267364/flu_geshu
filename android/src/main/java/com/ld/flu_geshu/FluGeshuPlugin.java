package com.ld.flu_geshu;

import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;

import com.getui.gs.ias.core.GsConfig;
import com.getui.gs.sdk.GsManager;

import java.util.HashMap;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FluGeshuPlugin */
public class FluGeshuPlugin implements FlutterPlugin, MethodCallHandler {

  private static final String TAG = "com.ld.fluGeshu";
  private static Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), TAG);
    if(flutterPluginBinding.getApplicationContext()!=null){
      this.context=flutterPluginBinding.getApplicationContext();
    }
    channel.setMethodCallHandler(new FluGeshuPlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), TAG);
    FluGeshuPlugin.context=registrar.context();
    channel.setMethodCallHandler(new FluGeshuPlugin());
  }

  private void initGS(MethodCall call,MethodChannel.Result result) {
    Log.d(TAG,"init geshu sdk...test");
    HashMap ret=new HashMap<>();
    if(this.context==null){
      ret.put("isSuccess",false);
      ret.put("msg","init geshu sdk error:context没获取到");
      result.success(ret);
      return;
    }
    boolean debugEnable=call.argument("debugEnable"); //是否开启开发者模式
    GsConfig.setDebugEnable(debugEnable);
    int strategyType=call.argument("strategyType");
    switch (strategyType){
      case 0:
        GsConfig.setUploadStrategyType(GsConfig.GESHU_STRATEGY_DEFAULT);
        break;
      case 1:
        GsConfig.setUploadStrategyType(GsConfig.GESHU_STRATEGY_REAL_TIME);
        break;
      case 2:
        GsConfig.setUploadStrategyType(GsConfig.GESHU_STRATEGY_WIFI_ONLY);
        break;
      case 3:
        GsConfig.setUploadStrategyType(GsConfig.GESHU_STRATEGY_BATCH);
        break;
      case 4:
        GsConfig.setUploadStrategyType(GsConfig.GESHU_STRATEGY_LAUNCH_ONLY);
        break;
      case 5:
        GsConfig.setUploadStrategyType(GsConfig.GESHU_STRATEGY_PERIOD);
        break;
    }
    String channel=call.argument("channel");
    GsConfig.setInstallChannel(channel);
    boolean enableSmartReporting=call.argument("enableSmartReporting");
    GsConfig.setEnableSmartReporting(enableSmartReporting);
    int maxBatchReportCount=call.argument("maxBatchReportCount");
    GsConfig.setMaxBatchReportCount(maxBatchReportCount);
    int sessionTimeMillis=call.argument("sessionTimeMillis");
    GsConfig.setSessionTimoutMillis(sessionTimeMillis);
    int uploadPeriodMinutes=call.argument("uploadPeriodMinutes");
    GsConfig.setUploadPeriodMinutes(uploadPeriodMinutes);

    GsManager.getInstance().init(this.context);
    ret.put("isSuccess",true);
    ret.put("msg","个数应用统计初始化成功");
    result.success(ret);
  }
  private void getConfig(MethodCall call,MethodChannel.Result result){
    HashMap ret=new HashMap<>();
    boolean debugEnable=GsConfig.isDebugEnable(); //是否开启开发者模式
    int strategyType=GsConfig.getUploadPeriodMinutes();
    String channel=GsConfig.getInstallChannel();
    boolean enableSmartReporting=GsConfig.getEnableSmartReporting();
    int maxBatchReportCount=GsConfig.getMaxBatchReportCount();
    long sessionTimeMillis=GsConfig.getSessionTimoutMillis();
    int uploadPeriodMinutes=GsConfig.getUploadPeriodMinutes();
    ret.put(debugEnable,debugEnable);
    ret.put(strategyType,strategyType);
    ret.put(channel,channel);
    ret.put(enableSmartReporting,enableSmartReporting);
    ret.put(maxBatchReportCount,maxBatchReportCount);
    ret.put(sessionTimeMillis,sessionTimeMillis);
    ret.put(uploadPeriodMinutes,uploadPeriodMinutes);
    result.success(ret);
  }
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + Build.VERSION.RELEASE);
    }else if(call.method.equals("initGS")){
      initGS(call,result);
    }else if(call.method.equals("getConfig")){
      getConfig(call,result);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
