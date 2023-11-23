import 'package:firebasedemo/src/configs/app_colors.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/view_models/add_member_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/asset.dart';
import '../../../business_logic/models/user_entity_model.dart';

class HorizontalUserTile extends GetView<AddMemberViewModel> {
  final UserModel userModel;
  final int index;
  final bool hideEdit;
  const HorizontalUserTile(
    this.userModel,
    this.index, {
    Key? key,
    this.hideEdit = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      height: 100,
      width: 80,
      child: Column(
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
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                       onTap: () {
                         controller.onRemoveUser(index);
                       },
                      child: Image.asset(
                        Asset.close,
                        height: 20,
                        width: 20,
                      ),
                    ))
            ],
          ),
          const SizedBox(height: 5),
          Text(
            userModel.name ?? "",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: AppColor.kDarkPrimaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
