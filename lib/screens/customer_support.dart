//Imports for pubspec Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//Imports for Constants
import '../constants.dart';

//Imports for Models
import '../models/company_detail.dart';
import '../models/user_detail.dart';

//Imports for Providers
import '../provider/get_current_location.dart';

//Imports for Widgets
import '../widgets/chat/to_chat.dart';

class CustomerSupport extends StatefulWidget {
  CustomerSupport({Key key}) : super(key: key);

  @override
  _CustomerSupportState createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
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

    if (companyDetails.length > 0) {
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

    if (companyDetails.length > 0) {
      if (adminUsers.length > 0) {
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
        title: const Text('Customer Support'),
      ),
      body: companyDetails.length > 0
          ? Padding(
              padding: const EdgeInsets.all(18.0),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.business,
                          color: bPrimaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            flex: 1,
                            child:
                                SelectableText(companyDetails[0].companyName)),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     const Icon(
                    //       FontAwesomeIcons.globe,
                    //       color: bPrimaryColor,
                    //     ),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    //     Flexible(
                    //       flex: 1,
                    //       child: TextButton(
                    //         onPressed: () async {
                    //           await launch(
                    //               'http://${companyDetails[0].webSite}/');
                    //         },
                    //         child: SelectableText(companyDetails[0].webSite),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     const Icon(
                    //       Icons.email,
                    //       color: bPrimaryColor,
                    //     ),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    //     Flexible(
                    //       flex: 1,
                    //       child: TextButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             _createEmail(
                    //                 'mailto:${companyDetails[0].email}?subject=Need Support&body=Please assist..');
                    //           });
                    //         },
                    //         child: SelectableText(companyDetails[0].email),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.phone,
                          color: bPrimaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _makePhoneCall(
                                    'tel:${companyDetails[0].customerCareNumber}');
                              });
                            },
                            child: SelectableText(
                                companyDetails[0].customerCareNumber),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          FontAwesomeIcons.building,
                          color: bPrimaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: Wrap(
                            children: [
                              SelectableText(companyDetails[0].address1),
                              SelectableText(companyDetails[0].address2)
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (user.uid.trim() != adminUsers[0].userId.trim())
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.support_agent,
                            color: bPrimaryColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('Chat with Support team?'),
                          SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) {
                                      return ToChat(
                                          userIdFrom: user.uid.trim(),
                                          userIdTo: adminUsers[0].userId.trim(),
                                          prodName: 'Enquiry');
                                    },
                                    fullscreenDialog: true),
                              );
                            },
                            child: const Text('Chat'),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            )
          : Container(
              child: const Center(
                child: const Text('Company Detail not available'),
              ),
            ),
      backgroundColor: bBackgroundColor,
    );
  }
}
