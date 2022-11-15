import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/calendar.dart';

class EditCalendarTaskPopup extends StatefulWidget {
  final Function editCalendarTask;
  final Calendar calendarTask;
  const EditCalendarTaskPopup(
      {super.key, required this.editCalendarTask, required this.calendarTask});

  @override
  State<EditCalendarTaskPopup> createState() => _EditCalendarTaskPopupState();
}

class _EditCalendarTaskPopupState extends State<EditCalendarTaskPopup> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _repeatEveryController = TextEditingController();
  final _durationController = TextEditingController();
  bool _isRepeating = false;
  TimeOfDay? _selectedTime;
  DateTime? _pickedDate;
  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.calendarTask.title;
    _subtitleController.text = widget.calendarTask.subtitle ?? '';
    _isRepeating = widget.calendarTask.repeat;
    _durationController.text = widget.calendarTask.duration.toString();
    if (_isRepeating == true) {
      _repeatEveryController.text = widget.calendarTask.repeatEvery.toString();
    }
    _pickedDate = widget.calendarTask.date;
    _selectedTime = TimeOfDay.fromDateTime(widget.calendarTask.date);
  }

  void _toggleSwitch(bool val) {
    setState(() {
      _isRepeating = !_isRepeating;
    });
  }

  void _showDatePick() {
    showDatePicker(
      context: context,
      initialDate: _pickedDate as DateTime,
      firstDate: DateTime.now().isAfter(_pickedDate as DateTime)
          ? _pickedDate as DateTime
          : DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 1095),
      ),
    ).then((chosenData) {
      if (chosenData == null) {
        return;
      }
      setState(() {
        _pickedDate = chosenData;
      });
    });
  }

  void _editCalendarTask() {
    final newTitle = _titleController.text;
    final newSubtitle = _subtitleController.text;
    int? newDurationTime = null;
    if (_durationController.text.isNotEmpty) {
      newDurationTime = int.parse(_durationController.text);
    }
    int? newRepeatEvery;
    _isRepeating
        ? newRepeatEvery = int.parse(_durationController.text)
        : newRepeatEvery = null;
    if (newTitle.isEmpty ||
        _pickedDate == null ||
        _selectedTime == null ||
        newDurationTime == null) {
      return;
    }
    Calendar fixedNote = widget.calendarTask.copy(
      title: newTitle,
      subtitle: newSubtitle,
      duration: newDurationTime,
      date: join(_pickedDate as DateTime, _selectedTime as TimeOfDay),
      repeat: _isRepeating,
      repeatEvery: newRepeatEvery,
    );
    widget.editCalendarTask(fixedNote);
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
            onSubmitted: (_) => _editCalendarTask(),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Subtitle (Optional)',
            ),
            controller: _subtitleController,
            onSubmitted: (_) => _editCalendarTask(),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Text(_pickedDate == null
                    ? 'No Date Chosen!'
                    : DateFormat.yMMMd().format(_pickedDate as DateTime)),
                TextButton(
                    onPressed: _showDatePick,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )),
                Text(
                  _selectedTime == null
                      ? 'Pick Time!'
                      : '${_selectedTime?.hour}:${_selectedTime?.minute}',
                ),
                TextButton(
                  onPressed: () {
                    _selectTime(context);
                  },
                  child: const Text(
                    'Choose Time',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
            child: Row(
              children: [
                const Text('Repeat'),
                Switch(
                  value: _isRepeating,
                  onChanged: _toggleSwitch,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          SizedBox(
            child: _isRepeating
                ? TextField(
                    decoration: const InputDecoration(
                      labelText: 'Repeat Every (days):',
                    ),
                    controller: _repeatEveryController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _editCalendarTask(),
                  )
                : Container(),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Duration Time (minutes)',
            ),
            controller: _durationController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _editCalendarTask(),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: _editCalendarTask,
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

  void _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTime) {
      setState(() {
        _selectedTime = timeOfDay;
      });
    }
  }
}
