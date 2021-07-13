import 'package:blrber/models/message.dart';
import 'package:blrber/models/user_detail.dart';
import 'package:blrber/screens/user_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart';

import 'package:provider/provider.dart';

import '../../constants.dart';

class UserMsgCount {
  String userNameTo;
  String userIdTo;
  String userNameFrom;
  String userIdFrom;
  String imageUrl;
  int newRecMsgCount;
  String prodName;

  UserMsgCount({
    this.userNameTo,
    this.userIdTo,
    this.userNameFrom,
    this.userIdFrom,
    this.imageUrl,
    this.newRecMsgCount,
    this.prodName,
  });
}

class PrevTargetUsers {
  String targetUserName;
  String prodName;

  PrevTargetUsers({
    this.targetUserName,
    this.prodName,
  });
}

class ListUsers extends StatefulWidget {
  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  List<UserMsgCount> _userMsgCounts = [];
  List<ReceivedMsgCount> receivedMsgCounts;
  List<ReceivedMsgCount> receivedMsgCountsEvery;

  final user = FirebaseAuth.instance.currentUser;

  Future<void> _clearReceivedMsgCount(
      String userNameFrom, String userNameTo, String prodName) async {
    receivedMsgCountsEvery = [];
    if (receivedMsgCounts.length > 0) {
      receivedMsgCountsEvery = receivedMsgCounts
          .where((e) =>
              e.receivedUserName.trim() == userNameFrom.trim() &&
              e.sentUserName.trim() == userNameTo.trim() &&
              e.prodName.trim() == prodName.trim())
          .toList();
    }

    if (receivedMsgCountsEvery.length > 0) {
      receivedMsgCountsEvery[0].receivedMsgCount = 0;
      await FirebaseFirestore.instance
          .collection('receivedMsgCount')
          .doc(receivedMsgCountsEvery[0].receivedMsgCountId)
          .update(
              {'receivedMsgCount': receivedMsgCountsEvery[0].receivedMsgCount})
          .then((value) => print("receivedMsgCount Updated"))
          .catchError(
              (error) => print("Failed to update receivedMsgCount: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<UserDetail> userDetails = Provider.of<List<UserDetail>>(context);
    receivedMsgCounts = Provider.of<List<ReceivedMsgCount>>(context);

    List<UserDetail> userDetailsCU = [];
    if (userDetails.length > 0) {
      userDetailsCU = userDetails
          .where((e) => e.userDetailDocId.trim() == user.uid.trim())
          .toList();

      if (userDetailsCU.length > 0) {
        if (receivedMsgCounts != null) {
          receivedMsgCounts = receivedMsgCounts
              .where((e) =>
                  e.receivedUserName.trim() ==
                      userDetailsCU[0].userName.trim() ||
                  e.sentUserName.trim() == userDetailsCU[0].userName.trim())
              .toList();
        }

        if (receivedMsgCounts.length > 0) {
          receivedMsgCounts.sort((a, b) {
            var aMsgCount = a.receivedMsgCount;
            var bMsgCount = b.receivedMsgCount;
            return bMsgCount.compareTo(aMsgCount);
          });

          List<PrevTargetUsers> prevTargetUsers = [];
          _userMsgCounts = [];
          for (var i = 0; i < receivedMsgCounts.length; i++) {
            UserMsgCount _userMsgCount = UserMsgCount();
            List<UserDetail> userDetailsTU = [];

            if (userDetailsCU[0].userName.trim() ==
                receivedMsgCounts[i].receivedUserName) {
              userDetailsTU = userDetails
                  .where((e) =>
                      e.userName.trim() ==
                      receivedMsgCounts[i].sentUserName.trim())
                  .toList();

              _userMsgCount.userNameTo = receivedMsgCounts[i].sentUserName;
              _userMsgCount.userIdTo = userDetailsTU[0].userDetailDocId;
              _userMsgCount.newRecMsgCount =
                  receivedMsgCounts[i].receivedMsgCount;
            } else {
              userDetailsTU = userDetails
                  .where((e) =>
                      e.userName.trim() ==
                      receivedMsgCounts[i].receivedUserName.trim())
                  .toList();
              _userMsgCount.userNameTo = receivedMsgCounts[i].receivedUserName;
              _userMsgCount.userIdTo = userDetailsTU[0].userDetailDocId;
              _userMsgCount.newRecMsgCount = 0;
            }

            _userMsgCount.userNameFrom = userDetailsCU[0].userName;

            _userMsgCount.userIdFrom = userDetailsCU[0].userDetailDocId;

            _userMsgCount.imageUrl = userDetailsTU[0].userImageUrl;
            _userMsgCount.prodName = receivedMsgCounts[i].prodName;

            if (prevTargetUsers.any((e) =>
                e.targetUserName.trim() == _userMsgCount.userNameTo.trim() &&
                e.prodName.trim() == _userMsgCount.prodName.trim())) {
            } else {
              PrevTargetUsers prevTargetUser = PrevTargetUsers();
              prevTargetUser.targetUserName = _userMsgCount.userNameTo;
              prevTargetUser.prodName = _userMsgCount.prodName;
              prevTargetUsers.add(prevTargetUser);
              _userMsgCounts.add(_userMsgCount);
            }
          }
        }
      }
    }

    return _userMsgCounts.length > 0
        ? ListView.builder(
            itemCount: _userMsgCounts.length,
            itemBuilder: (ctx, index) => Column(
              children: [
                Divider(
                  thickness: 2,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 10,
                  child: ListTile(
                    tileColor: bBackgroundColor,
                    onTap: () {
                      _clearReceivedMsgCount(
                          _userMsgCounts[index].userNameFrom,
                          _userMsgCounts[index].userNameTo,
                          _userMsgCounts[index].prodName);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) {
                              return UserChatScreen(
                                userNameFrom:
                                    _userMsgCounts[index].userNameFrom,
                                userNameTo: _userMsgCounts[index].userNameTo,
                                userIdFrom: _userMsgCounts[index].userIdFrom,
                                userIdTo: _userMsgCounts[index].userIdTo,
                                prodName: _userMsgCounts[index].prodName,
                                imageUrlTo: _userMsgCounts[index].imageUrl,
                              );
                            },
                            fullscreenDialog: true),
                      );
                    },
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: _userMsgCounts[index].imageUrl == ""
                              ? AssetImage(
                                  'assets/images/default_user_image.png')
                              : NetworkImage(_userMsgCounts[index].imageUrl),
                        ),
                        if (_userMsgCounts[index].newRecMsgCount > 0)
                          Badge(
                            badgeContent: Text(
                              _userMsgCounts[index].newRecMsgCount.toString(),
                              style: TextStyle(color: bBackgroundColor),
                            ),
                            badgeColor: Colors.red,
                          )
                      ],
                    ),
                    title: Text(_userMsgCounts[index].userNameTo.contains('@')
                        ? _userMsgCounts[index].userNameTo.substring(0, 10)
                        : _userMsgCounts[index].userNameTo),
                    subtitle: Text(_userMsgCounts[index].prodName),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: Text('No Chats Opened So Far!!'),
          );
  }
}
