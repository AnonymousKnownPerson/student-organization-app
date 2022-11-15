import 'package:flutter/material.dart';

class DeleteCalendarTask extends StatelessWidget {
  final Function deleteCalendarTask;
  final int id;
  DeleteCalendarTask({
    super.key,
    required this.deleteCalendarTask,
    required this.id,
  });

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
            deleteCalendarTask(id);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calendar Note deleted')));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
