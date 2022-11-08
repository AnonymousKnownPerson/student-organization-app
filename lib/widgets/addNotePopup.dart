import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNotePopup extends StatefulWidget {
  final Function addNote;
  const AddNotePopup({super.key, required this.addNote});

  @override
  State<AddNotePopup> createState() => _AddNotePopupState();
}

class _AddNotePopupState extends State<AddNotePopup> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  int _priorityVal = 3;
  void _addNewNote() {
    final newTitle = _titleController.text;
    final newSubtitle = _subtitleController.text;

    if (newTitle.isEmpty || newSubtitle.isEmpty) {
      return;
    }
    widget.addNote(newTitle, newSubtitle, _priorityVal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
            controller: _titleController,
            onSubmitted: (_) => _addNewNote(), //i don't use val
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Subtitle',
            ),
            controller: _subtitleController,
            onSubmitted: (_) => _addNewNote(),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Priority:',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Slider(
            value: _priorityVal.toDouble(),
            min: 1.0,
            max: 5.0,
            divisions: 4,
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Theme.of(context).colorScheme.secondary,
            label: 'Set priority value',
            onChanged: (double val) {
              setState(() {
                _priorityVal = val.round();
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: _addNewNote,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Add New Note',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
