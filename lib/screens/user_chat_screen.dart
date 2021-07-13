//Imports for pubspec Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

//Imports for pubspec Packages
import '../constants.dart';

//Imports for Models
import '../models/chat_detail.dart';
import '../models/message.dart';

//Imports for Widgets
import '../widgets/chat/message_bubble.dart';

class UserChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  final String userNameFrom;
  final String userNameTo;
  final String userIdFrom;
  final String userIdTo;
  final String prodName;
  final String imageUrlTo;
  UserChatScreen({
    this.userNameFrom,
    this.userNameTo,
    this.userIdFrom,
    this.userIdTo,
    this.prodName,
    this.imageUrlTo,
  });
  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  var deviceToken = '';
  // final ScrollController _scrollController = ScrollController();
  ItemScrollController _itemScrollController = ItemScrollController();
  List<ReceivedMsgCount> receivedMsgCounts = [];
  final _controller = new TextEditingController();
  var _enteredMessage = '';
  bool _msgRetrieved = false;

  List<ChatDetail> chatDetails,
      chatDetailsFrom,
      chatDetailsTo,
      chatDetailsFromTo = [];

  @override
  void didChangeDependencies() {
    _listChatMessages();
    receivedMsgCounts = Provider.of<List<ReceivedMsgCount>>(context);
    super.didChangeDependencies();
  }

  void _listChatMessages() {
    List<ChatDetail> chatDetails = Provider.of<List<ChatDetail>>(context);

    chatDetailsFrom = [];
    chatDetailsFrom = chatDetails
        .where((e) =>
            (e.userNameFrom.trim() == widget.userNameFrom.trim() &&
                e.userNameTo.trim() == widget.userNameTo.trim()) &&
            e.prodName.trim() == widget.prodName.trim())
        .toList();

    chatDetailsTo = [];
    chatDetailsTo = chatDetails
        .where((e) =>
            (e.userNameFrom.trim() == widget.userNameTo.trim() &&
                e.userNameTo.trim() == widget.userNameFrom.trim()) &&
            e.prodName.trim() == widget.prodName.trim())
        .toList();

    chatDetailsFromTo = [];

    chatDetailsFromTo = chatDetailsFrom + chatDetailsTo;

    if (chatDetailsFromTo.length != null && chatDetailsFromTo.length > 1) {
      chatDetailsFromTo.sort((a, b) {
        var aCreateAt = a.createdAt;
        var bCreateAt = b.createdAt;
        return aCreateAt.compareTo(bCreateAt);
      });
    }
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    _controller.clear();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(user.uid.trim())
          .get();

      if (userData == null) {
        print('user is null');
      } else {
        await FirebaseFirestore.instance.collection('chats').add({
          'text': _enteredMessage,
          'createdAt': Timestamp.now(),
          'userIdFrom': user.uid,
          'userNameFrom': userData['userName'],
          'userIdTo': widget.userIdTo,
          'userNameTo': widget.userNameTo,
          'userImage': userData['userImageUrl'],
          'prodName': widget.prodName,
        }).then((value) async {
          if (receivedMsgCounts.length > 0) {
            receivedMsgCounts = receivedMsgCounts
                .where((e) =>
                    e.receivedUserName.trim() == widget.userNameTo.trim() &&
                    e.sentUserName.trim() == userData['userName'].trim() &&
                    e.prodName.trim() == widget.prodName.trim())
                .toList();
          }

          if (receivedMsgCounts.length > 0) {
            receivedMsgCounts[0].receivedMsgCount =
                receivedMsgCounts[0].receivedMsgCount + 1;
            await FirebaseFirestore.instance
                .collection('receivedMsgCount')
                .doc(receivedMsgCounts[0].receivedMsgCountId)
                .update(
                    {'receivedMsgCount': receivedMsgCounts[0].receivedMsgCount})
                .then((value) => print("receivedMsgCount Updated"))
                .catchError((error) =>
                    print("Failed to update receivedMsgCount: $error"));
          } else {
            await FirebaseFirestore.instance
                .collection('receivedMsgCount')
                .add({
                  'receivedUserName': widget.userNameTo,
                  'receivedUserId': widget.userIdTo,
                  'receivedMsgCount': 1,
                  'sentUserName': userData['userName'],
                  'sentUserId': user.uid,
                  'prodName': widget.prodName,
                })
                .then((value) => print("receivedMsgCount added"))
                .catchError(
                    (error) => print("Failed to add receivedMsgCount: $error"));
          }
        });
      }
    }
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    _itemScrollController.scrollTo(
        index: chatDetailsFromTo.length + 1, duration: Duration(seconds: 2));
  }

  // void _setMsgScreenBottom(bool msgRetrieved) {
  //   if (msgRetrieved) {
  //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _msgRetrieved = false;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage:
                  (widget.imageUrlTo == "" || widget.imageUrlTo == null)
                      ? AssetImage('assets/images/default_user_image.png')
                      : NetworkImage(widget.imageUrlTo),
            ),
            const SizedBox(
              width: 20,
            ),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                      child: Column(
                    children: [
                      Text(
                        widget.userNameTo.contains('@')
                            ? widget.userNameTo.substring(0, 10)
                            : widget.userNameTo,
                        style: TextStyle(
                          color: bDisabledColor,
                        ),
                      ),
                      Text(
                        widget.prodName,
                        style: TextStyle(color: bDisabledColor, fontSize: 12),
                      )
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: bDisabledColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: bBackgroundColor,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: _itemScrollController,
                itemCount: chatDetailsFromTo.length,
                initialScrollIndex: chatDetailsFromTo.length,
                itemBuilder: (context, index) {
                  print("Message no - $index");
                  return MessageBubble(
                    chatDetailsFromTo: chatDetailsFromTo[index],
                  );
                },
              ),
              // child: ListView.builder(
              //   // shrinkWrap: true,

              //   // controller: _scrollController,
              //   // reverse: true,
              //   itemCount: chatDetailsFromTo.length,
              //   itemBuilder: (ctx, index) {
              //     print('index of msg  - $index');
              //     if (index + 1 == chatDetailsFromTo.length) {
              //       print('total msg = $index');

              //       _msgRetrieved = true;
              //       _setMsgScreenBottom(_msgRetrieved);
              //     }
              //     return MessageBubble(
              //       chatDetailsFromTo: chatDetailsFromTo[index],
              //     );
              //   },
              // ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          labelText: 'Enter your message new...'),
                      onChanged: (value) {
                        setState(() {
                          _enteredMessage = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    color: bPrimaryColor,
                    icon: const Icon(
                      Icons.send,
                    ),
                    onPressed:
                        _enteredMessage.trim().isEmpty ? null : _sendMessage,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
