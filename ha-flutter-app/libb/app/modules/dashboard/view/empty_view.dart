import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';

import '../../../Utils/image_path_utils.dart';

class EmptyView extends StatefulWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  _EmptyViewState createState() => _EmptyViewState();
}

class _EmptyViewState extends State<EmptyView>
    with SingleTickerProviderStateMixin {

  @override
  void didUpdateWidget(EmptyView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorWhite.toColor(),
      body: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 10),
        height: MediaQuery.of(context).size.height,
        child:  Image.asset(
          width: 84,
          ImagePathUtils.appbar_image_white,
          fit: BoxFit.contain
        ),
      ),
    );
  }
}