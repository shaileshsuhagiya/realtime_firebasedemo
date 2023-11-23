import 'package:firebasedemo/src/user_functionality/business_logic/models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../configs/app_strings.dart';
import '../../../business_logic/view_models/home_view_model.dart';
import '../../../services/dependency_assembler_education.dart';
import 'widget/room_tile.dart';

class RoomListScreen extends GetView<HomeViewModel> {
  final HomeViewModel _homeViewModel = dependencyAssembler<HomeViewModel>();

  RoomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  AppStrings.room,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _homeViewModel.roomList.toList().length,
                padding: const EdgeInsets.only(top: 10),
                itemBuilder: (context, index) {
                  List<RoomModel> data = _homeViewModel.roomList.toList();
                  RoomModel roomModel = data[index];
                  return RoomTile(
                    roomModel,
                  );
                },
              ),
            ],
          ),
        ));
  }
}
