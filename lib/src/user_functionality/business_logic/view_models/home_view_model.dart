import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/src/configs/app_strings.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../../../constant/constants.dart';
import '../models/base_model.dart';
import '../models/room_model.dart';
import '../utils/app_preference.dart';

class HomeViewModel extends BaseModel {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  HomeViewModel() {
    roomStream();
  }
  void updateNotifierState() {
    update();
  }

  RxList<RoomModel> roomList = RxList<RoomModel>();
  StreamSubscription<QuerySnapshot>? streamSub;
  roomStream() {
    var uid = AppPreference.getString(PreferencesConstants.UID);
    if (uid != null) {
      streamSub = fireStore
          .collection(AppStrings.roomTable)
          .orderBy("createdAt", descending: true)
          .snapshots()
          .listen((event) {
        roomList.clear();
        for (var element in event.docs) {
          RoomModel roomModel = RoomModel.fromJson(element.id, element.data());
          if (roomModel.roomMember?.contains(uid) ?? false) {
            roomList.add(roomModel);
          }
        }
        roomList.refresh();
      });
    }
  }

  getTotalRoomCount() {
    return roomList.toList().length;
  }

  getTotalOwnRoomCount() {
    return roomList.toList().length;
  }

  logOutCurrentUser() async {
    try {
      streamSub?.cancel();
      roomList.clear();
      await FirebaseAuth.instance.signOut();
      await AppPreference.clear();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }
}
