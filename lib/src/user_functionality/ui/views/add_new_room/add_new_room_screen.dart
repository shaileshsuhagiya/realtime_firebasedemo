import 'package:firebasedemo/src/configs/app_colors.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/models/room_model.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/view_models/room_view_model.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/utils/validations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../configs/app_strings.dart';
import '../../../../constant/common_text_form_field.dart';
import '../../shared/unified_app_button.dart';

class AddNewRoomScreen extends GetView<RoomViewModel> {
  final _form = GlobalKey<FormState>(); //for storing form state.
  final RoomModel? roomModel;

  AddNewRoomScreen({
    super.key,
    this.roomModel,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        leading: InkWell(
            onTap: () {
              controller.clearData();
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColor.skyBackgroundTextColor,
              size: 25,
            )),
        centerTitle: true,
        title: Text(
          roomModel == null
              ? AppStrings.addNewRoom
              : AppStrings.updateYourRooms,
          style: const TextStyle(fontSize: 17, color: AppColor.subTitle),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Hero(
          tag: AppStrings.floatingTag,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    CommonTextFormField(
                      hintText: AppStrings.roomName,
                      controller: controller.titleController,
                      validator: Validations().roomValidation,
                    ),
                    CommonTextFormField(
                      hintText: AppStrings.description,
                      validator: Validations().descriptionValidation,
                      controller: controller.descController,
                    ),
                    UnifiedAppButton(
                        buttonTitle: roomModel == null
                            ? AppStrings.createNewRoom
                            : AppStrings.updateYourRoom,
                        onPress: () {
                          if (_form.currentState!.validate()) {
                            if (roomModel != null) {
                              controller.updateRoom(
                                  roomModel,
                                  controller.titleController.text,
                                  controller.descController.text);
                              Get.back();
                            } else {
                              controller.addNewRoom(
                                  controller.titleController.text,
                                  controller.descController.text);
                            }
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
