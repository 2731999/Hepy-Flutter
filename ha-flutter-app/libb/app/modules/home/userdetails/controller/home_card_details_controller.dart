import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/report/report_model.dart';
import 'package:hepy/app/model/usercards/user_cards_model.dart';

class HomeCardDetailsController extends GetxController {
  RxInt currentIndex = 0.obs;
  final CarouselController controller = CarouselController();

  Future<void> userReport(UserCardsModel userCardsModel) async {
    String? reportedByUid = "";
    String? reportedByName = "";
    String? reportedByThumbUrl = "";

    String? reportedUid = "";
    String? reportedName = "";
    String? reportedThumbUrl = "";
    if (CommonUtils().auth.currentUser!.uid != userCardsModel.uid) {
      ///other user
      reportedUid = userCardsModel.uid;
      reportedName = userCardsModel.firstName;
      reportedThumbUrl = userCardsModel.thumbnail;
    }

    ///self user
    reportedByUid = CommonUtils().auth.currentUser!.uid;
    reportedByName = PreferenceUtils.getStartModelData?.firstName;
    reportedByThumbUrl = PreferenceUtils.getStartModelData?.thumbnail;

    ReportUserModel reportUserModel = ReportUserModel();
    reportUserModel.conversationId = "";
    reportUserModel.actionTaken = StringsNameUtils.reportedAction;
    reportUserModel.createdAt = Timestamp.fromDate(DateTime.now());
    reportUserModel.reportedBy = ReportedByUserModel(
        uid: reportedByUid, name: reportedByName, thumbUrl: reportedByThumbUrl);
    reportUserModel.reportedUser = ReportedUserModel(
        uid: reportedUid, name: reportedName, thumbUrl: reportedThumbUrl);

    FirebaseFirestore.instance
        .collection(StringsNameUtils.tblReportedUsers)
        .doc()
        .set(reportUserModel.toJson())
        .then(
          (_) {
        Get.back();
      },
    ).catchError((error) {
      Get.back();
    });
  }

  Future<bool> isUserAlreadyReported(
      {required String reportedByUid, required String reportedUserUid}) async {
    bool isUserAlreadyReported = false;
    await FirebaseFirestore.instance
        .collection(StringsNameUtils.tblReportedUsers)
        .get()
        .then((value) {
      List.from(value.docs.map((e) {
        ReportUserModel reportUserModel = ReportUserModel.fromJson(e.data());
        if (reportUserModel.reportedBy?.uid == reportedByUid &&
            reportUserModel.reportedUser?.uid == reportedUserUid) {
          isUserAlreadyReported = true;
        }
      }));
    });
    return isUserAlreadyReported;
  }
}
