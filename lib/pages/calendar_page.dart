import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_app/db/database.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/calendar.dart';
import '../widgets/addCalendarTask.dart';
import '../widgets/appbar.dart';

class CalendarPage extends StatefulWidget {
  final List<Calendar> calendarTasks;
  final Function refresh;

  const CalendarPage({
    super.key,
    required this.calendarTasks,
    required this.refresh,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  CalendarFormat _calFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Calendar> _calendarDayList = [];
  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calFormat = format;
    });
  }

  void _onDaySelected(DateTime focusedD, DateTime selectedD) {
    if (!isSameDay(_selectedDay, selectedD)) {
      setState(() {
        _focusedDay = focusedD;
        _selectedDay = selectedD;
        _calendarDayList = _getEventsForDay(selectedD);
      });
    }
  }

  Future _addCalendarTask(
      {required String title,
      String? subtitle,
      required DateTime date,
      required bool repeat,
      int? repeatEvery,
      required int duration}) async {
    final newCalendarTask = Calendar(
      title: title,
      date: date,
      repeat: repeat,
      duration: duration,
      repeatEvery: repeatEvery,
      subtitle: subtitle,
    );
    await StudentDatabase.instance.createCalendarTask(newCalendarTask);
    widget.refresh();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarWidget(title: 'Calendar'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => _addButtonAction(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.fromLTRB(2, 3, 2, 5),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                child: TableCalendar<Calendar>(
                  firstDay: DateTime.utc(2022, 10, 1),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  onDaySelected: _onDaySelected,
                  calendarFormat: _calFormat,
                  onFormatChanged: _onFormatChanged,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: _getEventsForDay,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (contx, index) {
                          return GestureDetector(
                            child: Card(
                              elevation: 0.3,
                              margin: const EdgeInsets.all(5),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: _calendarDayList[index]
                                                  .date
                                                  .isAfter(DateTime.now()) &&
                                              _calendarDayList[index]
                                                  .date
                                                  .add(
                                                    Duration(
                                                        minutes:
                                                            _calendarDayList[
                                                                    index]
                                                                .duration),
                                                  )
                                                  .isBefore(
                                                    DateTime.now(),
                                                  )
                                          ? const Color.fromARGB(
                                              255, 146, 175, 147)
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                    margin:
                                        const EdgeInsets.fromLTRB(1, 3, 1, 1),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        '${DateFormat("Hm").format(_calendarDayList[index].date)} - ${DateFormat("Hm").format(_calendarDayList[index].date.add(Duration(minutes: _calendarDayList[index].duration)))}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    _calendarDayList[index].title.toString(),
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      _calendarDayList[index].subtitle ==
                                                  null ||
                                              _calendarDayList[index]
                                                      .subtitle! ==
                                                  ''
                                          ? 'No more data'
                                          : _calendarDayList[index].subtitle
                                              as String),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: _calendarDayList.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Calendar> _getEventsForDay(DateTime specifiedDay) {
    _calendarDayList = widget.calendarTasks
        .where((element) => isSameDay(element.date, specifiedDay))
        .toList();
    return _calendarDayList;
  }

  void _addButtonAction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: AddCalendarTask(
              addCalendarTask: _addCalendarTask,
              selectedDay: _selectedDay,
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
