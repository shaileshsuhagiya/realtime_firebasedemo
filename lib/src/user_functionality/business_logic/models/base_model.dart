import 'package:firebasedemo/src/user_functionality/business_logic/enums/view_state.dart';
import 'package:get/get.dart';

class BaseModel extends GetxController {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void updateState(ViewState viewState) {
    updateStateWithoutNotifyListner(viewState);
    update();
  }

  void updateStateWithoutNotifyListner(ViewState viewState) =>
      _state = viewState;
}
