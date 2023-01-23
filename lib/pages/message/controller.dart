import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/entities/entities.dart';
import '../../common/store/store.dart';
import './index.dart';

class MessageController extends GetxController {
  MessageController();
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final MessageState state = MessageState();
  var listener;

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  void onRefresh() {
    asyncLoadAllData().then((_) {
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((_) {
      refreshController.refreshFailed();
    });
  }

  void onLoading() {
    asyncLoadAllData().then((_) {
      refreshController.loadComplete();
    }).catchError((_) {
      refreshController.loadFailed();
    });
  }

  asyncLoadAllData() async {
    var from_messages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message message, SetOptions? options) => message.toFirestore(),
        )
        .where("from_uid", isEqualTo: token)
        .get();

    var to_messages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message message, SetOptions? options) => message.toFirestore(),
        )
        .where("to_uid", isEqualTo: token)
        .get();

    state.messageList.clear();
    if (from_messages.docs.isNotEmpty) {
      state.messageList.assignAll(from_messages.docs);
    }

    if (to_messages.docs.isNotEmpty) {
      state.messageList.assignAll(to_messages.docs);
    }
  }
}
