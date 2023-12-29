import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/location/controller/location_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class LocationView extends GetView<LocationController> {
  LocationController locationController = Get.put(LocationController());

  LocationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().showAppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 48, right: 20, left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 332,
                  child: WidgetHelper().titleTextView(
                      titleText: StringsNameUtils.locationTitle, fontSize: 36)),
              WidgetHelper().sizeBox(height: 40),
              Image.asset(
                ImagePathUtils.location_person_marker,
                fit: BoxFit.contain,
              ),
              WidgetHelper().sizeBox(height: 40),
              SizedBox(
                width: 322,
                height: 48,
                child: WidgetHelper().simpleText(
                    text: StringsNameUtils.locationContentMessage,
                    textAlign: TextAlign.center),
              ),
              WidgetHelper().sizeBox(height: 33),
              SizedBox(
                width: 275,
                child: WidgetHelper().fillColorButton(
                  ontap: () {
                    locationController.insertLocationIntoDB(context);
                    // locationController.navigateToNameScreen();
                  },
                  text: StringsNameUtils.enableLocation,
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  height: 48,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
