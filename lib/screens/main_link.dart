import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class MainLink extends StatefulWidget {
  const MainLink({Key key}) : super(key: key);

  @override
  _MainLinkState createState() => _MainLinkState();
}

class _MainLinkState extends State<MainLink> {
  String _linkMessage;
  bool _isCreatingLink = false;
  String _testString =
      'To test: long press link and then copy and click from a non-browser '
      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
      'is properly setup. Look at firebase_dynamic_links/README.md for more '
      'details.';

  @override
  void initState() {
    super.initState();
    initDynamicLinks(context);
  }

  Future<void> initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      print("Deep link1 - ${deepLink.toString()}");

      if (deepLink != null) {
        // ignore: unawaited_futures
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    print('data - $data');
    final Uri deepLink = data?.link;
    print("Deep link2 - ${deepLink.toString()}");
    print("Deep link21 - ${deepLink.path}");
    if (deepLink != null) {
      // ignore: unawaited_futures
      print("Deep link21 - ${deepLink.path}");
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://newworkspaceproduction.page.link/',
      link:
          Uri.parse('https://newworkspaceproduction.com/view?title=helloworld'),
      androidParameters: AndroidParameters(
        packageName: 'com.newworkspaceproduction.brlber',
        minimumVersion: 1,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      // iosParameters: IosParameters(
      //   bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
      //   minimumVersion: '0',
      // ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Links Example'),
        ),
        body: Builder(builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        initDynamicLinks(context);
                      },
                      child: const Text('initial link'),
                    ),
                    ElevatedButton(
                      onPressed: !_isCreatingLink
                          ? () => _createDynamicLink(false)
                          : null,
                      child: const Text('Get Long Link'),
                    ),
                    ElevatedButton(
                      onPressed: !_isCreatingLink
                          ? () => _createDynamicLink(true)
                          : null,
                      child: const Text('Get Short Link'),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    if (_linkMessage != null) {
                      await launch(_linkMessage);
                    }
                  },
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: _linkMessage));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied Link!')),
                    );
                  },
                  child: Text(
                    _linkMessage ?? '',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                Text(_linkMessage == null ? '' : _testString)
              ],
            ),
          );
        }),
      ),
    );
  }
}
