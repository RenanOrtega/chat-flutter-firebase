import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../common/entities/entities.dart';

class MessageState {
  RxList<QueryDocumentSnapshot<Message>> messageList = <QueryDocumentSnapshot<Message>>[].obs;
  
}
