import 'package:blrber/models/company_detail.dart';
import 'package:blrber/models/user_detail.dart';
import 'package:blrber/provider/get_current_location.dart';
import 'package:blrber/widgets/chat/to_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenter extends StatefulWidget {
  HelpCenter({Key key}) : super(key: key);

  @override
  _HelpCenterState createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  List<CompanyDetail> companyDetails = [];
  GetCurrentLocation getCurrentLocation = GetCurrentLocation();
  List<AdminUser> adminUsers = [];
  // AdminUser adminUser = AdminUser();
  User user;
  // CompanyDetail companyDetail = CompanyDetail();
  String _countryCode = "";

  @override
  void didChangeDependencies() {
    user = FirebaseAuth.instance.currentUser;
    getCurrentLocation = Provider.of<GetCurrentLocation>(context);
    _countryCode = getCurrentLocation.countryCode;
    adminUsers = Provider.of<List<AdminUser>>(context);
    companyDetails = Provider.of<List<CompanyDetail>>(context);

    // companyDetail = CompanyDetail();
    // if (companyDetails != null) {
    print('comp1');
    if (companyDetails.length > 0) {
      print('comp2 - ${companyDetails[0].countryCode}');
      if (companyDetails
          .any((e) => e.countryCode.trim() == _countryCode.trim())) {
        companyDetails = companyDetails
            .where((e) => e.countryCode.trim() == _countryCode.trim())
            .toList();
      } else {
        companyDetails = companyDetails
            .where((e) => e.countryCode.trim() == "SE".trim())
            .toList();
      }
    }
    // }

    // adminUser = AdminUser();
    // if (adminUsers != null) {
    print('comp4');
    if (companyDetails.length > 0) {
      print('comp5');
      if (adminUsers.length > 0) {
        print('comp6');
        if (adminUsers
            .any((e) => e.countryCode.trim() == _countryCode.trim())) {
          adminUsers = adminUsers
              .where((e) => e.countryCode.trim() == _countryCode.trim())
              .toList();
        } else {
          adminUsers =
              adminUsers.where((e) => e.countryCode.trim() == "SE").toList();
        }
      }
    }
    // }

    super.didChangeDependencies();
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _createEmail(String emailContent) async {
    if (await canLaunch(emailContent)) {
      await launch(emailContent);
    } else {
      throw 'Could not launch $emailContent';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Center'),
      ),
      body: companyDetails.length > 0
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            NetworkImage(companyDetails[0].logoImageUrl),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Text('Company Name'),
                            ),
                            Text(': '),
                            Text(companyDetails[0].companyName),
                          ],
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Text('Web Site'),
                            ),
                            Text(': '),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _launchInBrowser(
                                      'https://+${companyDetails[0].webSite}/');
                                });
                              },
                              // icon: Icon(Icons.http),
                              child: Text(companyDetails[0].webSite),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Text('Email'),
                            ),
                            Text(': '),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _createEmail(
                                      'mailto:${companyDetails[0].email}?subject=Need Support&body=Please assist..');
                                });
                              },
                              // icon: Icon(Icons.http),
                              child: Text(companyDetails[0].email),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Text('Customer Care'),
                            ),
                            Text(': '),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _makePhoneCall(
                                      'tel:${companyDetails[0].customerCareNumber}');
                                });
                              },
                              icon: Icon(Icons.phone),
                              label: Text(companyDetails[0].customerCareNumber),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Text('Address'),
                            ),
                            Text(': '),
                            Text(companyDetails[0].address1),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                            ),
                            Text('  '),
                            Text(companyDetails[0].address2),
                          ],
                        ),
                      ],
                    ),
                    if (user.uid.trim() != adminUsers[0].userId.trim())
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Chat with Support team?'),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) {
                                        return ToChat(
                                            userIdFrom: user.uid.trim(),
                                            userIdTo:
                                                adminUsers[0].userId.trim(),
                                            prodName: 'Enquiry');
                                      },
                                      fullscreenDialog: true),
                                );
                              },
                              child: Text('Chat'),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            )
          : Container(
              child: Center(
                child: Text('Company Detail not available'),
              ),
            ),
      backgroundColor: Colors.white,
    );
  }
}
