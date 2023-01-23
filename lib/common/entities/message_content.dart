import 'package:cloud_firestore/cloud_firestore.dart';

class MessageContent {
  final String? uid;
  final String? content;
  final String? type;
  final Timestamp? addtime;

  MessageContent({
    this.uid,
    this.content,
    this.type,
    this.addtime,
  });

  factory MessageContent.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return MessageContent(
      uid: data?['uid'],
      content: data?['content'],
      type: data?['type'],
      addtime: data?['addtime'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (content != null) "content": content,
      if (type != null) "type": type,
      if (addtime != null) "addtime": addtime,
    };
  }
}
