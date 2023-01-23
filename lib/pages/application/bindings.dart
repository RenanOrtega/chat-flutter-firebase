import 'package:chat_flutter_firebase/pages/contact/controller.dart';
import 'package:chat_flutter_firebase/pages/message/controller.dart';
import 'package:get/get.dart';

import 'index.dart';

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<ContactController>(() => ContactController());
    Get.lazyPut<MessageController>(() => MessageController());
  }
}
