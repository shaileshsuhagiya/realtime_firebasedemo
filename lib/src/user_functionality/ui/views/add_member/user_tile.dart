import 'package:firebasedemo/src/configs/app_colors.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/view_models/add_member_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/asset.dart';
import '../../../business_logic/models/user_entity_model.dart';

class UserTile extends GetView<AddMemberViewModel> {
  final UserModel userModel;
  final int index;
  final bool hideEdit;
  const UserTile(
    this.userModel,
    this.index, {
    Key? key,
    this.hideEdit = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        controller.onSelectUser(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: FadeInImage.assetNetwork(
                              placeholder: Asset.userPlaceHolder,
                              image: userModel.profileUrl ?? "",
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Asset.userPlaceHolder,
                                  height: 50,
                                  width: 50,
                                );
                              },
                              width: 50,
                              height: 50,
                            ),
                          ),
                        if(userModel.isSelected)  Positioned(
                              bottom: 0,
                              right: 0,
                              child: Image.asset(
                                Asset.checkmark,
                                height: 20,
                                width: 20,
                              ))
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userModel.name ?? "",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  color: AppColor.kDarkPrimaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              userModel.email ?? "",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  color: AppColor.textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
