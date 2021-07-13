//Imports for pubspec Packages
import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports for Constants
import '../constants.dart';

// Imports for Models
import '../models/message.dart';
import '../models/user_detail.dart';

// Imports for Screens
import '../screens/explore_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/generate_post.dart';

// Imports for Services
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
    initDynamicLinks(context);

    super.initState();
  }

// To handel dynamic links
  Future<void> initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      print("Deep link1 - ${deepLink.toString()}");

      if (deepLink != null) {
        var routeName = '/${deepLink.queryParameters["view"]}';
        var id = '${deepLink.queryParameters["id"]}';

        Navigator.of(context).pushNamed(routeName, arguments: id);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final Uri deepLink = data?.link;

    print("Deep link2 - ${deepLink.toString()}");
    if (deepLink != null) {
      var routeName = '/${deepLink.queryParameters["view"]}';
      var id = '${deepLink.queryParameters["id"]}';

      Navigator.of(context).pushNamed(routeName, arguments: id);
    }
  }

  //

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
      const BottomNavigationBarItem(
        icon: const Icon(Icons.explore),
        label: 'Explore',
      ),
      const BottomNavigationBarItem(
        icon: const Icon(Icons.favorite),
        label: 'Favorites',
      ),
      const BottomNavigationBarItem(
        icon: const Icon(Icons.add_box),
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

                if (userDetails.length > 0 && user != null) {
                  // UserDetail userDetailsCU = UserDetail();

                  var userDetail = userDetails
                      .where((e) => e.email.trim() == user.email.trim())
                      .toList();

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
                    // Following signOut is to sign out the user if he is deleted from the firebase manually.
                    // But it is not allowed to deleted the user manually if he is logged in.
                    // FirebaseAuth.instance.signOut();
                  }
                }
                return Stack(
                  children: [
                    const Icon(Icons.chat),
                    if (totalNewMsgCount > 0)
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          height: 22,
                          width: 22,
                          child: Badge(
                            badgeContent: Text(
                              totalNewMsgCount.toString(),
                              style: TextStyle(
                                  color: bBackgroundColor, fontSize: 9),
                            ),
                            badgeColor: Colors.red,
                          ),
                        ),
                      )
                  ],
                );
              } else {
                return const Icon(Icons.chat);
              }
            }),
        label: 'Chat',
      ),
      const BottomNavigationBarItem(
        icon: const Icon(Icons.person),
        label: 'My Blrber',
      ),
    ];
    final _bottomNavigationBar = BottomNavigationBar(
      onTap: _selectPage,
      unselectedItemColor: bDisabledColor,
      selectedItemColor: bPrimaryColor,
      backgroundColor: bBackgroundColor,
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
