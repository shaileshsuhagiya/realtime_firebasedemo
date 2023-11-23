import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../configs/app_strings.dart';
import '../../../constant/constants.dart';
import '../models/base_model.dart';
import '../utils/app_preference.dart';

class RoomViewModel extends BaseModel {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  Rx<TextEditingController> realTimeController =
      Rx<TextEditingController>(TextEditingController());

  List<String>? selectedUser = [];

  RoomModel? currentRoomModel;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    selectedUser = Get.arguments ?? [];
  }

  Future addNewRoom(String title, String desc) async {
    EasyLoading.show(status: AppStrings.loading);
    var uid = AppPreference.getString(PreferencesConstants.UID);
    final DocumentReference documentReference = fireStore
        .collection(AppStrings.roomTable)
        .doc(DateTime.now().microsecondsSinceEpoch.toString());
    selectedUser?.add(uid);
    selectedUser?.toSet().toList();
    fireStore.runTransaction((transaction) async {
      transaction.set(documentReference, <String, dynamic>{
        'roomTitle': title,
        'id': documentReference.id,
        'description': desc,
        'createdBy': uid,
        'roomMember': FieldValue.arrayUnion(selectedUser ?? []),
        'createdAt': DateTime.now().millisecondsSinceEpoch
      });
    }).then((value) {
      clearData();
      EasyLoading.dismiss();
      Get.back();
    });
  }

  updateRoom(
    RoomModel? doc,
    String title,
    String desc,
  ) {
    getDocumentRefRoom(doc!.id.toString()).set(<String, dynamic>{
      'roomTitle': title,
      'description': desc,
      'updatedAt': DateTime.now().millisecondsSinceEpoch
    }, SetOptions(merge: true)).then((dynamic success) {
      Fluttertoast.showToast(msg: AppStrings.roomUpdated);
      Get.back();
    }).catchError((dynamic error) {
      clearData();
      debugPrint(error);
    });
  }

  deleteRoom(
    RoomModel doc,
  ) async {
    await fireStore.runTransaction((Transaction myTransaction) async {
      getDocumentRefRoom(doc.id.toString())
          .delete()
          .then((value) => Fluttertoast.showToast(msg: AppStrings.roomDeleted));
    });
    clearData();
  }

  DocumentReference getDocumentRefRoom(String docId) {
    return fireStore
        .collection(AppStrings.roomTable)
        .doc(docId);
  }

  setUpdate(RoomModel roomModel) {
    titleController.text = roomModel.roomTitle ?? "";
    descController.text = roomModel.description ?? "";
  }



  clearData() {
    titleController.clear();
    descController.clear();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clearData();
  }
}
