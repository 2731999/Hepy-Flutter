import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/uploadphoto/user_upload_photo_model.dart';

class UserPhotosTbl {

  Future<List<UserUploadPhotoModel>>getUsersPhotos(String uid) async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    List<UserUploadPhotoModel> lstUserPhoto = [];
    await firebaseFirestore
    .collection(StringsNameUtils.tblUserUploadedPhotos)
    .where('uid', isEqualTo: uid)
    .get()
    .then((value) {
      List.from(value.docs.map((e) {
        lstUserPhoto.add(UserUploadPhotoModel.fromJson(e.data()));
        debugPrint("Get User photos ====> ${lstUserPhoto.length}");
      }));
    });
    return lstUserPhoto;
  }
}
