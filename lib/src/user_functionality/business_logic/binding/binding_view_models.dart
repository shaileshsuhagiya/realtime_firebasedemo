import 'package:firebasedemo/src/user_functionality/business_logic/view_models/home_view_model.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/view_models/login_view_model.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/view_models/register_view_model.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/view_models/room_view_model.dart';
import 'package:get/get.dart';

import '../view_models/add_member_view_model.dart';

class BindingViewModels extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HomeViewModel(),);
    Get.lazyPut(() => LoginViewModel());
    Get.lazyPut(() => RegisterViewModel());
    Get.lazyPut(() => RoomViewModel());
    Get.lazyPut(() => AddMemberViewModel());
  }
}

class RoomBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => RoomViewModel(),);
  }
}
