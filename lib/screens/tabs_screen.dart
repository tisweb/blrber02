import 'package:badges/badges.dart';
import 'package:blrber/models/message.dart';
import 'package:blrber/models/user_detail.dart';
import 'package:blrber/screens/generate_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import screens
import './explore_screen.dart';
import './favorites_screen.dart';
import './chat_screen.dart';
import './profile_screen.dart';

// Import services
import '../services/foundation.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<dynamic> _tabs;
  int _selectPageIndex = 0;
  List<ReceivedMsgCount> receivedMsgCounts = [];

  String currentUserName = "";
  User user;
  UserDetail userData;
  int totalNewMsgCount = 0;

  @override
  void initState() {
    _tabs = [
      ExploreScreen(),
      FavoritesScreen(),
      GeneratePost(),
      ChatScreen(),
      ProfileScreen(),
    ];

    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ReceivedMsgCount> receivedMsgCounts =
        Provider.of<List<ReceivedMsgCount>>(context);

    final _bottomNavigationBarItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.explore),
        label: 'Explore',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Favorites',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_box),
        label: 'Sell',
      ),
      BottomNavigationBarItem(
        icon: StreamBuilder<Object>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                user = FirebaseAuth.instance.currentUser;
                List<UserDetail> userDetails =
                    Provider.of<List<UserDetail>>(context);
                print('user id in tab - ${user.uid}');
                print('user email in tab - ${user.email}');
                print('userDetails.length - ${userDetails.length}');
                print('user email in tab11 - ${user.email}');

                if (userDetails.length > 0 && user != null) {
                  print('check tabs screen');
                  // UserDetail userDetailsCU = UserDetail();
                  print('check tabs screen1');
                  var userDetail = userDetails
                      .where((e) => e.email.trim() == user.email.trim())
                      .toList();
                  print('check tabs screen2 - ${userDetail.length}');

                  print('user email in tab1 - ${user.email}');

                  if (userDetail.length > 0) {
                    receivedMsgCounts = receivedMsgCounts
                        .where((e) =>
                            e.receivedUserName.trim() ==
                            userDetail[0].userName.trim())
                        .toList();
                    if (receivedMsgCounts.length > 0) {
                      totalNewMsgCount = 0;
                      for (int i = 0; i < receivedMsgCounts.length; i++) {
                        totalNewMsgCount = totalNewMsgCount +
                            receivedMsgCounts[i].receivedMsgCount;
                      }
                    }
                  } else {
                    totalNewMsgCount = 0;
                    FirebaseAuth.instance.signOut();
                    print('user email in tab2 - ${user.email}');
                  }
                }
                return Stack(
                  children: [
                    Icon(Icons.chat),
                    if (totalNewMsgCount > 0)
                      Positioned(
                        left: 5,
                        top: 0,
                        child: Badge(
                          badgeContent: Text(
                            totalNewMsgCount.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          badgeColor: Colors.red,
                        ),
                      )
                  ],
                );
              } else {
                return Icon(Icons.chat);
              }
            }),
        label: 'Chat',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'My Blrber',
      ),
    ];
    final _bottomNavigationBar = BottomNavigationBar(
      onTap: _selectPage,
      unselectedItemColor: Theme.of(context).disabledColor,
      selectedItemColor: Theme.of(context).primaryColor,
      backgroundColor: Theme.of(context).backgroundColor,
      currentIndex: _selectPageIndex,
      type: BottomNavigationBarType.fixed,
      items: _bottomNavigationBarItems,
      elevation: 0.0,
    );
    return isIos
        ? CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: _bottomNavigationBarItems,
            ),
            tabBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return ExploreScreen();
                case 1:
                  return FavoritesScreen();
                case 2:
                  return GeneratePost();
                case 3:
                  return ChatScreen();
                case 4:
                  return ProfileScreen();
                default:
                  return ExploreScreen();
              }
            },
          )
        : Scaffold(
            body: _tabs[_selectPageIndex],
            bottomNavigationBar: _bottomNavigationBar,
          );
  }
}
