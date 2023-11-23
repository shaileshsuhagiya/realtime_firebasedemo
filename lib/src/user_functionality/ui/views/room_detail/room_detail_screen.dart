import 'package:firebasedemo/src/configs/app_colors.dart';
import 'package:firebasedemo/src/configs/app_strings.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/utils/firebase_exception_utility.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/view_models/room_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../business_logic/models/room_model.dart';
import '../../../business_logic/models/user_entity_model.dart';
import '../../shared/fonts.dart';
import '../add_member/add_member_screen.dart';

class RoomDetailScreen extends GetView<RoomDetailViewModel> {
  final RoomModel? roomModel;
  const RoomDetailScreen({
    super.key,
    this.roomModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          roomModel?.roomTitle ?? "",
          style: const TextStyle(
              color: AppColor.backGroundColor,
              fontSize: 17,
              fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back,
              color: AppColor.backGroundColor, size: 25),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (isAdmin(roomModel!)) {
                Get.to(() => AddMemberScreen(),
                        arguments: roomModel?.roomMember ?? [])
                    ?.then((value) {
                  if (value != null) {
                    controller.updateRoomMember(
                        roomModel,
                        value == null
                            ? <String>[]
                            : (value as List<UserModel>)
                                .map((e) => e.uid!)
                                .toList());
                    Get.back();
                  }
                });
              } else {
                Fluttertoast.showToast(msg: AppStrings.notAdmin);
              }
            },
            icon: const Icon(
              Icons.settings,
              size: 25.0,
              color: AppColor.appbarTextColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GetBuilder<RoomDetailViewModel>(
                init: Get.put(RoomDetailViewModel(currentRoomModel: roomModel)),
                builder: (controller) {
                  return TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: controller.textEditingController,
                    minLines: 1,
                    onChanged: (value) {
                      controller.onTyping(roomModel!, value);
                    },
                    decoration: InputDecoration(
                      labelText:
                          "Type here for realtime communication".toUpperCase(),
                      border: InputBorder.none,
                      labelStyle: const TextStyle(
                        color: Color(0xFFACACAC),
                        fontFamily: Fonts.CLANNARROWNEWS,
                        wordSpacing: 1.5,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
