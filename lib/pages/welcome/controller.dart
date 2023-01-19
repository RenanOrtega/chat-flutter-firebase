import 'package:chat_flutter_firebase/common/routes/names.dart';
import 'package:get/get.dart';

import 'index.dart';

class WelcomeController extends GetxController {
  final state = WelcomeState();
  WelcomeController();

  changePage(int index) async {
    state.index.value = index;
  }

  handleSignIn() {
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }
}
