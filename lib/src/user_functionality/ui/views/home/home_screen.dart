import 'package:firebasedemo/src/configs/app_colors.dart';
import 'package:firebasedemo/src/configs/app_strings.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/models/user_entity_model.dart';
import 'package:firebasedemo/src/user_functionality/ui/views/add_member/add_member_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/asset.dart';
import '../../../business_logic/binding/binding_view_models.dart';
import '../../../business_logic/view_models/home_view_model.dart';
import '../../../services/dependency_assembler_education.dart';
import '../add_new_room/add_new_room_screen.dart';
import '../login/login_screen.dart';
import '../room/room_list_screen.dart';
import '../../widgets/ripple_floating_button.dart';

class HomeScreen extends StatelessWidget {
  final HomeViewModel _homeViewModel = dependencyAssembler<HomeViewModel>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Obx(() => CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                elevation: 0,
                pinned: true,
                snap: false,
                floating: false,
                //backgroundColor: Colors.transparent,
                leadingWidth: 40,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Image.asset(Asset.menu, color: AppColor.skyTextColor),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      icon: Image.asset(Asset.logout,
                          color: AppColor.skyTextColor),
                      onPressed: () async {
                        await _homeViewModel.logOutCurrentUser();
                        Get.offAll(() => LoginScreen());
                      },
                    ),
                  ),
                ],
                expandedHeight: 180,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(Asset.skyBackground),
                          fit: BoxFit.fill,
                        )),
                      ),
                      Positioned.fill(
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          color: const Color(0xff4b6495).withOpacity(0.6),
                        ),
                      ),
                      Positioned.fill(
                        top: 0,
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        AppStrings.yourThings,
                                        style: TextStyle(
                                          fontSize: 26,
                                          color: AppColor.skyTextColor,
                                        ),
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                              _homeViewModel
                                                  .getTotalRoomCount()
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: AppColor.tileColor,
                                                  fontWeight: FontWeight.w500)),
                                          Text(AppStrings.totalRoom,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColor.textWhiteColor,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 45),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          height: 235,
                          width: 150,
                          color: Colors.black12,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 20, 20),
                        child: RoomListScreen()),
                  ],
                ),
              ])),
            ],
          )),
      floatingActionButton: RippleFloatingButton(
        color: AppColor.skyBackgroundTextColor,
        repeat: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            Get.to(() => AddMemberScreen())?.then((value) {
              if (value != null) {
                Get.to(() => AddNewRoomScreen(),
                    arguments: value == null
                        ? <String>[]
                        : (value as List<UserModel>)
                            .map((e) => e.uid!)
                            .toList(),
                    binding: RoomBinding());
              }
            });
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
              child: const Icon(Icons.add, color: AppColor.tileColor, size: 35),
            ),
          ),
        ),
      ),
    );
  }
}
