import 'package:get/get.dart';

class WebviewController extends GetxController {
  RxInt distanceKm = 10.obs;

  RxInt startAge = 18.obs;
  RxInt endAge = 30.obs;

  RxString startAgeLabel = '18'.obs;
  RxString endAgeLabel = '30'.obs;
  RxString retainFor = '1 Week'.obs;
  RxString currentPlan = 'Standard- Free'.obs;

  List<String> lookingForList = ['MEN', 'WOMEN', 'EVERYONE'];
  RxString selectedValue = ''.obs;

  final isInitialized = false.obs;

  @override
  void onInit() async {
    Future f1 = Future.delayed(const Duration(seconds: 2), () {
      print("Wait for 2 seconds");
    });

    Future f2 = Future.delayed(const Duration(seconds: 2), () {
      print("Wait for 2 seconds");
    });

    Future f3 = Future.delayed(const Duration(seconds: 2), () {
      print("Wait for 2 seconds");
    });
    // Future f1 = server.get('service1').then(....)
    // Future f2 = server.get('service1').then(....)
    // Future f3 = server.get('service1').then(....)
    await Future.wait([f1, f2, f3]);
    isInitialized.value = true;
  }
}
