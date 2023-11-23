import 'package:firebasedemo/src/user_functionality/business_logic/models/room_model.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/utils/firebase_exception_utility.dart';
import 'package:firebasedemo/src/user_functionality/ui/views/room_detail/room_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import '../../../../../configs/app_colors.dart';
import '../../../../../configs/app_strings.dart';
import '../../../../business_logic/view_models/room_view_model.dart';
import '../../../../services/dependency_assembler_education.dart';
import '../../add_new_room/add_new_room_screen.dart';

class RoomTile extends StatelessWidget {
  final RoomViewModel _roomViewModel = dependencyAssembler<RoomViewModel>();
  final RoomModel roomModel;
  final bool hideEdit;
  RoomTile(
    this.roomModel, {
    Key? key,
    this.hideEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.to(
          () => RoomDetailScreen(roomModel: roomModel),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
        child: Slidable(
          key: const ValueKey(0),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              if (!hideEdit)
                SlidableAction(
                  // An action can be bigger than the others.
                  onPressed: (context) {
                    if (isAdmin(roomModel)) {
                      Get.put(RoomViewModel()).setUpdate(roomModel);
                      Get.to(() => AddNewRoomScreen(
                        roomModel: roomModel,
                      ));
                    } else {
                      Fluttertoast.showToast(msg: AppStrings.notAdmin);
                    }
                  },
                  flex: 1,
                  backgroundColor: AppColor.btnColor,
                  foregroundColor: AppColor.tileColor,
                  icon: Icons.edit,
                  label: AppStrings.edit,
                ),
              SlidableAction(
                onPressed: (context) async{
                  if (isAdmin(roomModel)) {
                  await  _roomViewModel.deleteRoom(roomModel);
                  _roomViewModel.clearData();
                  } else {
                    Fluttertoast.showToast(msg: AppStrings.notAdmin);
                  }
                },
                flex: 1,
                backgroundColor: AppColor.redColor,
                foregroundColor: AppColor.tileColor,
                icon: Icons.delete,
                label: AppStrings.delete,
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                const VerticalDivider(
                  thickness: 5,
                  width: 5,
                  color: AppColor.btnColor,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                roomModel.roomTitle ?? "",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    color: AppColor.kDarkPrimaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                roomModel.description ?? "",
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
      ),
    );
  }
}
