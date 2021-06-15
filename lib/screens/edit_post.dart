import 'package:flutter/material.dart';
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Edit Post',
        ),
        backgroundColor: Theme.of(context).primaryColor,
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
