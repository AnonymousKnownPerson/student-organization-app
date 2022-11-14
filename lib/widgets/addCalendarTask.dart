import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCalendarTask extends StatefulWidget {
  final Function addCalendarTask;
  final DateTime selectedDay;
  const AddCalendarTask(
      {super.key, required this.addCalendarTask, required this.selectedDay});

  @override
  State<AddCalendarTask> createState() => _AddCalendarTaskState();
}

class _AddCalendarTaskState extends State<AddCalendarTask> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _repeatEveryController = TextEditingController();
  final _durationController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime? _pickedDate;
  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _addCalendarTask() {
    final newTitle = _titleController.text;
    final newSubtitle = _subtitleController.text;
    int? newDurationTime = 1;
    if (_durationController.text.isNotEmpty) {
      newDurationTime = int.parse(_durationController.text);
    }
    int? newRepeatEvery;
    _isRepeating
        ? newRepeatEvery = int.parse(_durationController.text)
        : newRepeatEvery = null;
    if (newTitle.isEmpty || _pickedDate == null || _selectedTime == null) {
      return;
    }

    widget.addCalendarTask(
      title: newTitle,
      subtitle: newSubtitle.isEmpty ? newSubtitle : null,
      duration: newDurationTime,
      date: join(_pickedDate as DateTime, _selectedTime),
      repeat: _isRepeating,
      repeatEvery: newRepeatEvery,
    );
    Navigator.of(context).pop();
  }

  void _showDatePick() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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

  @override
  void initState() {
    super.initState();
    _pickedDate = widget.selectedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _isRepeating = false;
  void _toggleSwitch(bool val) {
    setState(() {
      _isRepeating = !_isRepeating;
    });
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
            onSubmitted: (_) => _addCalendarTask(),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Subtitle (Optional)',
            ),
            controller: _subtitleController,
            onSubmitted: (_) => _addCalendarTask(),
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
                      ? 'No Date Chosen!'
                      : '${_selectedTime.hour}:${_selectedTime.minute}',
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
                    onSubmitted: (_) => _addCalendarTask(),
                  )
                : Container(),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Duration Time (minutes)',
            ),
            controller: _durationController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _addCalendarTask(),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: _addCalendarTask,
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
