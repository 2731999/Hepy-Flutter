import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/modules/setting/controller/setting_controller.dart';
import 'package:hepy/app/modules/webview/controller/webview_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebView extends GetView<SettingController> {
  WebviewController mWebViewController = WebviewController();

  CommonWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getArguments = Get.arguments;
    return Scaffold(
      appBar: WidgetHelper().showAppBarText(
          onDone: () {
            Get.back();
          },
          title: getArguments[0]),
      body: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        height: double.infinity,
        child: WebView(
          initialUrl: getArguments[1],
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted:(_) => CommonUtils().startLoading(context),
          onPageFinished: (_) => CommonUtils().stopLoading(context),
        ),
      ),
    );
  }
}
