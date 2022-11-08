import 'package:flutter/material.dart';

import '../models/note.dart';

class EditNotePopup extends StatefulWidget {
  final Note note;
  final Function editNote;
  const EditNotePopup({super.key, required this.note, required this.editNote});
  @override
  State<EditNotePopup> createState() => _EditNotePopupState();
}

class _EditNotePopupState extends State<EditNotePopup> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  bool _isActive = false;
  bool _done = false;
  int _priorityVal = 3;
  void _editNewNote() {
    final newTitle = _titleController.text;
    final newSubtitle = _subtitleController.text;
    if (newTitle.isEmpty) {
      return;
    }
    Note xd = widget.note.copy(
      title: newTitle,
      subtitle: newSubtitle,
      priority: _priorityVal,
      isActive: _isActive,
      done: _done,
    );
    widget.editNote(xd);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _subtitleController.text = widget.note.subtitle ?? '';
    _priorityVal = widget.note.priority;
    _isActive = widget.note.isActive;
    _done = widget.note.done;
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
            onSubmitted: null, //i don't use val
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Subtitle',
            ),
            controller: _subtitleController,
            onSubmitted: null,
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
          Row(
            children: [
              Text('Task for today'),
              Checkbox(
                value: _isActive,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) => setState(() {
                  _isActive = value as bool;
                }),
              ),
            ],
          ),
          Row(
            children: [
              Text('Done'),
              Checkbox(
                value: _done,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) => setState(() {
                  _done = value as bool;
                }),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _editNewNote,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Edit This Note',
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
