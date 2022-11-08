import 'package:flutter/material.dart';

class DeletePopup extends StatelessWidget {
  final Function deleteNote;
  final int id;
  DeletePopup({super.key, required this.deleteNote, required this.id});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Alert!!"),
      content: Text("Are you sure about that?"),
      actions: <Widget>[
        TextButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("Yes"),
          onPressed: () {
            deleteNote(id);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Note deleted')));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
