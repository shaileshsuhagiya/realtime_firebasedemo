import 'package:firebasedemo/src/configs/app_colors.dart';
import 'package:firebasedemo/src/configs/app_strings.dart';
import 'package:firebasedemo/src/configs/app_text_style.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/models/user_entity_model.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/view_models/add_member_view_model.dart';
import 'package:firebasedemo/src/user_functionality/ui/views/add_member/horizontal_user_tile.dart';
import 'package:firebasedemo/src/user_functionality/ui/views/add_member/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../widgets/custom_animation_searchbar.dart';
import '../../widgets/ripple_floating_button.dart';

class AddMemberScreen extends GetView<AddMemberViewModel> {
  final AddMemberViewModel addMemberViewModel = Get.put(AddMemberViewModel());

  AddMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          AppStrings.selectMember,
          style: TextStyle(
              color: AppColor.backGroundColor,
              fontSize: 17,
              fontWeight: FontWeight.w700),
        ),
        leading: Obx(() => (!controller.isSearch.value)
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back,
                    color: AppColor.backGroundColor, size: 25),
              )
            : const SizedBox()),
        actions: [
          Obx(
            () => Container(
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              child: CustomAnimationSearchBar(
                width: Get.width - 20,
                textController: controller.searchTextController,
                toggle: controller.isSearch.value ? 1 : 0,
                onSuffixTap: () {
                  if (controller.searchTextController.text.isEmpty) {
                    controller.isSearch.value = false;
                  }
                  controller.searchTextController.clear();
                  controller.onSearch("");
                },
                onSubmitted: (value) {
                  controller.isSearch.value = false;
                  controller.onSearch(value);
                },
                onChange: (value) async {
                  controller.onSearch(value);
                },
                searchBarOpen: (value) {
                  if (value == 0) {
                    controller.isSearch.value = false;
                    controller.searchTextController.clear();
                    controller.onSearch("");
                  } else {
                    controller.isSearch.value = true;
                  }
                },
                color: Colors.transparent,
                boxShadow: controller.isSearch.value,
                autoFocus: true,
                closeSearchOnSuffixTap: false,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Obx(() => controller.selectedUserList
                  .toList()
                  .where((element) => element.isSelected)
                  .toList()
                  .isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: controller.scrollController,
                        shrinkWrap: true,
                        itemCount: controller.selectedUserList
                            .toList()
                            .where((element) => element.isSelected)
                            .toList()
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          List<UserModel> data = controller.selectedUserList
                              .toList()
                              .where((element) => element.isSelected)
                              .toList();
                          UserModel userModel = data[index];
                          return HorizontalUserTile(userModel, index);
                        },
                      ),
                    ),
                    const Row(
                      children: [
                        Expanded(
                            child: Divider(
                          height: 1,
                          color: AppColor.textFieldBorder,
                        )),
                      ],
                    ),
                  ],
                )
              : Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Text(
                    AppStrings.noFound,
                    style: const TextStyle(
                        color: AppColor.subTitle,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                )),
          Expanded(
            child: SingleChildScrollView(
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.userList.toList().length,
                  // padding: const EdgeInsets.only(top: 5),
                  itemBuilder: (context, index) {
                    List<UserModel> data = controller.userList.toList();
                    UserModel userModel = data[index];
                    return UserTile(userModel, index);
                  },
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: RippleFloatingButton(
        color: AppColor.skyBackgroundTextColor,
        repeat: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            if (controller.selectedUserList.isNotEmpty) {
              Get.back(result: controller.selectedUserList);
            } else {
              Fluttertoast.showToast(msg: AppStrings.selectMemberMin);
            }
          },
          child: Hero(
            tag: AppStrings.floatingTag,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.skyBackgroundTextColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.btnColor.withOpacity(0.3),
                    spreadRadius: 7,
                    blurRadius: 7,
                    offset: const Offset(3, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_forward,
                  color: AppColor.tileColor, size: 35),
            ),
          ),
        ),
      ),
    );
  }
}
