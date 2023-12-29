import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Database/user_location_history_tbl.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/user_location_history_model.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class LocationController extends GetxController {
  RxDouble lat = 0.0.obs;
  RxDouble lang = 0.0.obs;
  RxString currentLocation = ''.obs;
  RxString street = ''.obs;
  RxString city = ''.obs;
  RxString country = ''.obs;

  @override
  void onInit() {}

  askLocationPermission(BuildContext context) async {
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.denied) {
      getLocationData(context);
    } else {
      await Geolocator.requestPermission().then((value) async {
        if(value == LocationPermission.deniedForever){
          Get.back();
          WidgetHelper().showMessage(msg: StringsNameUtils.locationPermissionMessage);
        }else if (value != LocationPermission.denied) {
          getLocationData(context);
        }
      });
    }
  }

  getLocationData(BuildContext context) async{
    CommonUtils().startLoading(context);
    Position position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: false,
        desiredAccuracy: LocationAccuracy.high);
    lat.value = position.latitude;
    lang.value = position.longitude;
    final place =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    street.value = place.first.street!;
    city.value = place.first.locality!;
    country.value = place.first.country!;
    currentLocation.value =
    '${place.first.street} ${place.first.subAdministrativeArea} ${place.first.country}';

    try {
      UserTbl().insertUserLocationInToDatabase(
          CommonUtils().auth.currentUser!,
          street.value,
          city.value,
          country.value,
          lat.value,
          lang.value);
      UserLocationHistoryTbl().insertDataToLocationHistoryTbl(
          CommonUtils().auth.currentUser!, lat.value, lang.value,city.value);
      CommonUtils().stopLoading(context);
      navigateToNameScreen();
    } on Exception catch (e) {
      CommonUtils().stopLoading(context);
      e.toString();
    }
  }

  insertLocationIntoDB(BuildContext context) async {
    askLocationPermission(context);
  }

  navigateToNameScreen() {
    Get.toNamed(Routes.NAME);
  }
}
