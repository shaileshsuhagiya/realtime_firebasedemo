import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/src/configs/app_strings.dart';
import 'package:firebasedemo/src/constant/constants.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/models/base_model.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/models/room_model.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/utils/app_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RoomDetailViewModel extends BaseModel {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  RoomModel? currentRoomModel;
  TextEditingController textEditingController = TextEditingController();
  RxString initialText = RxString("");
  Timer? _debounce;
  RoomDetailViewModel({this.currentRoomModel}) {
    typingStream();
    textEditingController.value =TextEditingValue(text: currentRoomModel?.documentText ??"");
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    typingStream();
  }

  void onTyping(RoomModel roomModel, String value) {
    _debounce?.cancel();
    _debounce = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updateFirebaseRealTime(roomModel, value);
      _debounce!.cancel();
    });
  }

  typingStream() {
    if (currentRoomModel != null) {
      initialText.value = currentRoomModel?.documentText ?? "";
      initialText.refresh();
      fireStore
          .collection(AppStrings.roomTable)
          .doc(currentRoomModel!.id)
          .snapshots()
          .listen((event) {
       if( event.data()!= null){
         RoomModel roomModel =
         RoomModel.fromJson(currentRoomModel!.id, event.data()!);
         currentRoomModel?.documentText = roomModel.documentText;
         textEditingController.value =TextEditingValue(text: currentRoomModel?.documentText ??"");
         textEditingController.selection =
             TextSelection.collapsed(offset: textEditingController.text.length);
       }
      });
    }
  }

  void updateRoomMember(RoomModel? doc, List<String> roomMember) async {
    EasyLoading.show(status: AppStrings.loading);
    List? queue = await getDocumentRefRoom(doc!.id.toString())
        .get()
        .then((value) => value["roomMember"]);
    List<String> removeMember = [];

    queue?.forEach((element) {
      if (!roomMember.contains(element)) {
        removeMember.add(element);
      }
    });

    await getDocumentRefRoom(doc.id.toString()).update({
      'roomMember': FieldValue.arrayRemove(removeMember.toSet().toList()),
    });
    var uid = AppPreference.getString(PreferencesConstants.UID);
    roomMember.add(uid);
    getDocumentRefRoom(doc.id.toString()).set(<String, dynamic>{
      'roomMember': FieldValue.arrayUnion(roomMember.toSet().toList()),
      'updatedAt': DateTime.now().millisecondsSinceEpoch
    }, SetOptions(merge: true)).then((dynamic success) {
      Fluttertoast.showToast(msg: AppStrings.roomMemberUpdated);
      EasyLoading.dismiss();
    }).catchError((dynamic error) {
      debugPrint(error);
      EasyLoading.dismiss();
    });
  }

  DocumentReference getDocumentRefRoom(String docId) {

    return fireStore
        .collection(AppStrings.roomTable)
        .doc(docId);
  }

  void updateFirebaseRealTime(RoomModel doc, String value) {
    getDocumentRefRoom(doc.id.toString()).set(<String, dynamic>{
      'documentText': value,
      'updatedAt': DateTime.now().millisecondsSinceEpoch
    }, SetOptions(merge: true)).then((dynamic success) {
      EasyLoading.dismiss();
    }).catchError((dynamic error) {
      debugPrint(error);
    });
  }
}
