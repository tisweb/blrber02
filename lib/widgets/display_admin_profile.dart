import 'package:blrber/models/user_detail.dart';
import 'package:blrber/provider/get_current_location.dart';
import 'package:blrber/screens/edit_profile.dart';
import 'package:blrber/screens/settings_screen.dart';
import 'package:blrber/widgets/display_product_catalog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayAdminProfile extends StatefulWidget {
  const DisplayAdminProfile({Key key}) : super(key: key);

  @override
  _DisplayAdminProfileState createState() => _DisplayAdminProfileState();
}

class _DisplayAdminProfileState extends State<DisplayAdminProfile> {
  String currentUserName = "";
  AdminUser adminUser = AdminUser();
  @override
  Widget build(BuildContext context) {
    List<UserDetail> userDetails = Provider.of<List<UserDetail>>(context);
    List<AdminUser> adminUsers = Provider.of<List<AdminUser>>(context);
    final user = FirebaseAuth.instance.currentUser;
    final getCurrentLocation = Provider.of<GetCurrentLocation>(context);

    if (adminUsers.length > 0) {
      adminUsers =
          adminUsers.where((e) => e.userId.trim() == user.uid.trim()).toList();
    }

    if (userDetails.length > 0 && user != null) {
      userDetails = userDetails
          .where((e) => e.email.trim() == user.email.trim())
          .toList();
      if (userDetails.length > 0) {
        currentUserName = userDetails[0].userName;
      }
    }

    return Scaffold(
      body: userDetails.length > 0
          ? Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flag(
                          getCurrentLocation.countryCode,
                          height: 20,
                          width: 25,
                          fit: BoxFit.fill,
                        ),
                        IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SettingsScreen.routeName);
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: userDetails[0].userImageUrl == ""
                              ? AssetImage(
                                  'assets/images/default_user_image.png')
                              : NetworkImage(userDetails[0].userImageUrl),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                userDetails[0].displayName,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).disabledColor),
                              ),
                              Text(
                                userDetails[0].userType,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).disabledColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text(
                        'Edit Profile',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).disabledColor),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) {
                                return EditProfile();
                              },
                              fullscreenDialog: true),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(Icons.category_outlined),
                      title: Text(
                        'Product Catalog',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).disabledColor),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) {
                                return DisplayProductCatalog(
                                  adminUserPermission: adminUsers[0].permission,
                                );
                              },
                              fullscreenDialog: true),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
