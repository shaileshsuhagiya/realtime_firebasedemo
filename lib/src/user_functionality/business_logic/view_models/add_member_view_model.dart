import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/src/configs/app_strings.dart';
import 'package:firebasedemo/src/constant/constants.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

import '../models/user_entity_model.dart';
import '../utils/app_preference.dart';

class AddMemberViewModel extends BaseModel {
  RxBool isSearch = RxBool(false);
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  TextEditingController searchTextController = TextEditingController();
  RxInt searchListSelectedIndex = RxInt(0);
  ScrollController scrollController = ScrollController();

  RxList<UserModel> userList = RxList<UserModel>();
  RxList<UserModel> allUserList = RxList<UserModel>();
  RxList<UserModel> selectedUserList = RxList<UserModel>();

  Future<void> getUserList() async {
    EasyLoading.show(status: AppStrings.loading);
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(AppStrings.user).get();
    List docs = snapshot.docs;
    allUserList.clear();
    userList.clear();
    selectedUserList.clear();
    var uid = AppPreference.getString(PreferencesConstants.UID);
    for (var doc in docs) {
      UserModel userModel = UserModel.fromMap(doc.data());
      if(userModel.uid != uid){
        allUserList.add(userModel);
      }
    }
    allUserList.refresh();

    addRoomMember(Get.arguments);
    onSearch("");
    EasyLoading.dismiss();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserList();
  }

  void onSelectUser(int index) {
    userList[index].isSelected = !userList[index].isSelected;

    userList.refresh();
    if (userList[index].isSelected) {
      selectedUserList.insert(0, userList[index]);
    } else {
      selectedUserList
          .removeWhere((element) => element.uid == userList[index].uid);
    }
  }

  void onRemoveUser(index) {
    userList
        .firstWhereOrNull(
          (element) => element.uid == selectedUserList[index].uid,
        )
        ?.isSelected = false;
    selectedUserList.removeAt(index);
    selectedUserList.refresh();
    userList.refresh();
  }

  void onSearch(String text) {
    if (text.isNotEmpty) {
      userList.value = allUserList
          .where((p0) => p0.name.toString().toLowerCase().contains(text))
          .toList();
    } else {
      userList.value = allUserList;
    }
  }

  void addRoomMember(List<String>? currentMember) {
    currentMember?.forEach((element) {
      allUserList.firstWhereOrNull((p0) => p0.uid == element)?.isSelected =
          true;
      UserModel? userModel =
          allUserList.firstWhereOrNull((p0) => p0.uid == element);
      if (userModel != null) {
        selectedUserList.add(userModel);
      }
    });
    allUserList.refresh();
    userList.refresh();
  }
}
