import 'package:blrber/screens/tabs_screen.dart';
import 'package:flutter/material.dart';

class PostAddedResultScreen extends StatelessWidget {
  final String editPost;
  const PostAddedResultScreen({Key key, this.editPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: [
              Center(
                child: Text('Your post added successfully!'),
              ),
              TextButton(
                onPressed: () {
                  editPost == "true"
                      ? Navigator.of(context).pop()
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) {
                                return TabsScreen();
                              },
                              fullscreenDialog: true),
                        );
                },
                child: Text('Continue'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
