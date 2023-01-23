import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../common/entities/entities.dart';
import '../../../common/store/store.dart';
import '../../../common/utils/utils.dart';
import 'index.dart';

class ChatController extends GetxController {
  ChatController();

  ChatState state = ChatState();

  var doc_id = null;

  final textController = TextEditingController();
  ScrollController messageScrolling = ScrollController();
  FocusNode contentNode = FocusNode();

  final userId = UserStore.to.token;
  final db = FirebaseFirestore.instance;

  var listener;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print("No image selected");
    }
  }

  Future getImageUrl(String name) async {
    final spaceRef = FirebaseStorage.instance.ref("chat").child(name);
    var downloadUrl = await spaceRef.getDownloadURL();
    return downloadUrl;
  }

  sendImageMessage(String url) async {
    final content = MessageContent(
      uid: userId,
      content: url,
      type: "image",
      addtime: Timestamp.now(),
    );

    await db
        .collection("message")
        .doc(doc_id)
        .collection("messageList")
        .withConverter(
          fromFirestore: MessageContent.fromFirestore,
          toFirestore: (MessageContent messageContent, SetOptions? options) => messageContent.toFirestore(),
        )
        .add(content)
        .then((DocumentReference doc) {
      print("Document snapshot added with id, ${doc.id}");
      textController.clear();
      Get.focusScope?.unfocus();
    });

    await db.collection("message").doc(doc_id).update({
      "last_message": "‖image‖",
      "last_time": Timestamp.now(),
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;

    final fileName = getRandomString(15) + _photo!.path; //extension(_photo!.path);

    try {
      final ref = FirebaseStorage.instance.ref("chat").child(fileName);
      await ref.putFile(_photo!).snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            String imageUrl = await getImageUrl(fileName);
            sendImageMessage(imageUrl);
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            break;
        }
      });
    } catch (e) {
      print("There's an error $e");
    }
  }

  @override
  void onInit() {
    super.onInit();

    var data = Get.parameters;
    doc_id = data['doc_id'];
    state.to_uid.value = data['to_uid'] ?? "";
    state.to_name.value = data['to_name'] ?? "";
    state.to_avatar.value = data['to_avatar'] ?? "";
  }

  sendMessage() async {
    String sendContent = textController.text;
    final content = MessageContent(
      uid: userId,
      content: sendContent,
      type: "text",
      addtime: Timestamp.now(),
    );
    await db
        .collection("message")
        .doc(doc_id)
        .collection("messageList")
        .withConverter(
          fromFirestore: MessageContent.fromFirestore,
          toFirestore: (MessageContent messageContent, SetOptions? options) => messageContent.toFirestore(),
        )
        .add(content)
        .then((DocumentReference doc) {
      print("Document snapshot added with id, ${doc.id}");
      textController.clear();
      Get.focusScope?.unfocus();
    });

    await db.collection("message").doc(doc_id).update({
      "last_message": sendContent,
      "last_time": Timestamp.now(),
    });
  }

  @override
  void onReady() {
    super.onReady();

    var messages = db
        .collection("message")
        .doc(doc_id)
        .collection("messageList")
        .withConverter(
          fromFirestore: MessageContent.fromFirestore,
          toFirestore: (MessageContent messageContent, SetOptions? options) => messageContent.toFirestore(),
        )
        .orderBy("addtime", descending: false);

    state.messageContentList.clear();

    listener = messages.snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              state.messageContentList.insert(0, change.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
    }, onError: (error) => print("Listen failed: $error"));
  }

  @override
  void dispose() {
    messageScrolling.dispose();
    listener.cancel();
    super.dispose();
  }
}
