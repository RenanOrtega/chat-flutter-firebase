import 'package:get/get.dart';

import '../../../common/entities/entities.dart';

class ChatState {
  RxList<MessageContent> messageContentList = <MessageContent>[].obs;
  var to_uid = "".obs;
  var to_name = "".obs;
  var to_avatar = "".obs;
  var to_location = "unknown".obs;
}
