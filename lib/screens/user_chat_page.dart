import 'package:blrber/widgets/chat/messages.dart';
import 'package:blrber/widgets/chat/new_message.dart';
import 'package:flutter/material.dart';

class UserChatPage extends StatefulWidget {
  static const routeName = '/chat-page';

  final String userNameFrom;
  final String userNameTo;
  final String userIdFrom;
  final String userIdTo;
  final String prodName;
  UserChatPage({
    this.userNameFrom,
    this.userNameTo,
    this.userIdFrom,
    this.userIdTo,
    this.prodName,
  });
  @override
  _UserChatPageState createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  var deviceToken = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: RichText(
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
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  Text(
                    widget.prodName,
                    style: TextStyle(
                        color: Theme.of(context).disabledColor, fontSize: 12),
                  )
                ],
              )),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).disabledColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(
                  userNameFrom: widget.userNameFrom,
                  userNameTo: widget.userNameTo,
                  prodName: widget.prodName),
            ),
            NewMessage(
              userIdTo: widget.userIdTo,
              userNameTo: widget.userNameTo,
              prodName: widget.prodName,
            ),
          ],
        ),
      ),
    );
  }
}
