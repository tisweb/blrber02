// Model for Chat Info table

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDetail {
  Timestamp createdAt;
  String text;
  String userIdFrom;
  String userIdTo;
  String userImage;
  String userNameFrom;
  String userNameTo;
  String prodName;
  String chatDetailDocId;

  ChatDetail({
    this.createdAt,
    this.text,
    this.userIdFrom,
    this.userIdTo,
    this.userImage,
    this.userNameFrom,
    this.userNameTo,
    this.prodName,
    this.chatDetailDocId,
  });
}
