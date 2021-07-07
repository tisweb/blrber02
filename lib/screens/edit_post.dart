//Imports for pubspec Packages
import 'package:flutter/material.dart';

//Imports for Constants
import '../constants.dart';

//Imports for Widgets
import '../widgets/post_input_form.dart';

class EditPost extends StatefulWidget {
  final String prodId;
  EditPost({
    this.prodId,
  });
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Edit Post',
        ),
        backgroundColor: bPrimaryColor,
      ),
      body: Container(
        child: PostInputForm(
          // editPost: 'true',
          prodId: widget.prodId,
        ),
      ),
    );
  }
}
