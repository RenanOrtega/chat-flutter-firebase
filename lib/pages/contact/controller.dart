import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../common/entities/entities.dart';
import '../../common/store/store.dart';
import 'index.dart';

class ContactController extends GetxController {
  ContactController();

  final ContactState state = ContactState();
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;

  @override
  void onReady() {
    super.onReady();
    asyncLoadAllData();
  }

  goChat(UserData toUserData) async {
    var fromMessages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message message, options) => message.toFirestore(),
        )
        .where("from_uid", isEqualTo: token)
        .where("to_uid", isEqualTo: toUserData.id)
        .get();

    var toMessages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message message, SetOptions? options) => message.toFirestore(),
        )
        .where("from_uid", isEqualTo: toUserData.id)
        .where("to_uid", isEqualTo: token)
        .get();

    if (fromMessages.docs.isEmpty && toMessages.docs.isEmpty) {
      String profile = await UserStore.to.getProfile();
      UserLoginResponseEntity userData = UserLoginResponseEntity.fromJson(jsonDecode(profile));

      var messageData = Message(
        from_uid: userData.accessToken,
        to_uid: toUserData.id,
        from_name: userData.displayName,
        to_name: toUserData.name,
        from_avatar: userData.photourl,
        to_avatar: toUserData.photourl,
        last_message: "",
        last_time: Timestamp.now(),
        message_num: 0,
      );

      db
          .collection("message")
          .withConverter(
            fromFirestore: Message.fromFirestore,
            toFirestore: (Message message, SetOptions? options) => message.toFirestore(),
          )
          .add(messageData)
          .then((value) {
        Get.toNamed("/chat", parameters: {
          "doc_id": value.id,
          "to_uid": toUserData.id ?? "",
          "to_name": toUserData.name ?? "",
          "to_avatar": toUserData.photourl ?? "",
        });
      });
    } else {
      if (fromMessages.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          "doc_id": fromMessages.docs.first.id,
          "to_uid": toUserData.id ?? "",
          "to_name": toUserData.name ?? "",
          "to_avatar": toUserData.photourl ?? "",
        });
      }

      if (toMessages.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          "doc_id": toMessages.docs.first.id,
          "to_uid": toUserData.id ?? "",
          "to_name": toUserData.name ?? "",
          "to_avatar": toUserData.photourl ?? "",
        });
      }
    }
  }

  asyncLoadAllData() async {
    var usersbase = await db
        .collection("users")
        .where("id", isNotEqualTo: token)
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userData, SetOptions? options) => userData.toFirestore(),
        )
        .get();

    for (var doc in usersbase.docs) {
      state.contactList.add(doc.data());
    }
  }
}
