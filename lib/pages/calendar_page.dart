import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:student_app/db/database.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/calendar.dart';
import '../widgets/addCalendarTask.dart';
import '../widgets/appbar.dart';
import '../widgets/deleteCalendarTask.dart';
import '../widgets/editCalendarTaskPopup.dart';

class CalendarPage extends StatefulWidget {
  final List<Calendar> calendarTasks;
  final Function refresh;
  final bool isLoading;
  final int checkPage;

  const CalendarPage({
    super.key,
    required this.calendarTasks,
    required this.refresh,
    required this.isLoading,
    required this.checkPage,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  CalendarFormat _calFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Calendar? _editedCalendarTask = null;
  List<Calendar> _calendarDayList = [];
  List<Calendar> _bottomEventList = [];
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
        _bottomEventList = _getEventsForDay(_selectedDay);
      });
    }
  }

  Future _readCalendarTask(int id) async {
    _editedCalendarTask = await StudentDatabase.instance.readCalendarTask(id);
  }

  Future _readBottomList() async {
    _bottomEventList = _getEventsForDay(_selectedDay);
  }

  Future _deleteCalendarTask(int id) async {
    await StudentDatabase.instance.deleteCalendarTask(id);
    widget.refresh();
    _readBottomList();
  }

  Future _editCalendarTask(Calendar calendarTask) async {
    await StudentDatabase.instance.updateCalendarTask(calendarTask);
    widget.refresh();
    _readBottomList();
  }

  Future _addCalendarTask({
    required String title,
    String? subtitle,
    required DateTime date,
    required bool repeat,
    int? repeatEvery,
    required int duration,
  }) async {
    final newCalendarTask = Calendar(
      title: title,
      date: date,
      repeat: repeat,
      duration: duration,
      repeatEvery: repeatEvery,
      subtitle: subtitle,
    );
    await StudentDatabase.instance.createCalendarTask(newCalendarTask);
    await widget.refresh();
    _readBottomList();
  }

  @override
  void initState() {
    super.initState();
    _readBottomList();
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
                child: !widget.isLoading
                    ? Column(
                        children: [
                          Expanded(
                            child: _bottomEventList.isNotEmpty
                                ? FutureBuilder(
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.none &&
                                          !snapshot.hasData) {
                                        return Stack(
                                          children: const [
                                            Positioned.fill(
                                              child: Center(
                                                child: Text('Loading...'),
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder: (contx, index) {
                                          return GestureDetector(
                                            onDoubleTap: () =>
                                                _editCalendarTaskAction(
                                                    context,
                                                    _bottomEventList[index].id
                                                        as int),
                                            child: Card(
                                              elevation: 0.3,
                                              margin: const EdgeInsets.all(5),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ListTile(
                                                  leading: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: _bottomEventList[
                                                                      index]
                                                                  .date
                                                                  .isBefore(DateTime
                                                                      .now()) &&
                                                              _bottomEventList[
                                                                      index]
                                                                  .date
                                                                  .add(
                                                                    Duration(
                                                                        minutes:
                                                                            _bottomEventList[index].duration),
                                                                  )
                                                                  .isAfter(
                                                                    DateTime
                                                                        .now(),
                                                                  )
                                                          ? const Color
                                                                  .fromARGB(255,
                                                              146, 175, 147)
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                    ),
                                                    margin: const EdgeInsets
                                                        .fromLTRB(1, 3, 1, 1),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      child: Text(
                                                        '${DateFormat("Hm").format(_bottomEventList[index].date)} - ${DateFormat("Hm").format(_bottomEventList[index].date.add(Duration(minutes: _bottomEventList[index].duration)))}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.delete,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              DeleteCalendarTask(
                                                                  deleteCalendarTask:
                                                                      _deleteCalendarTask,
                                                                  id: _bottomEventList[
                                                                          index]
                                                                      .id as int));
                                                    },
                                                  ),
                                                  title: Text(
                                                    _bottomEventList[index]
                                                        .title
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                      _bottomEventList[index]
                                                                      .subtitle ==
                                                                  null ||
                                                              _bottomEventList[
                                                                          index]
                                                                      .subtitle! ==
                                                                  ''
                                                          ? 'No more data'
                                                          : _bottomEventList[
                                                                      index]
                                                                  .subtitle
                                                              as String),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: _bottomEventList.length,
                                      );
                                    },
                                    initialData: _readBottomList(),
                                  )
                                : Stack(
                                    children: const [
                                      Positioned.fill(
                                        child: Center(
                                          child: Text(
                                              'No calendar tasks for this day!'),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      )
                    : Stack(
                        children: const [
                          Positioned.fill(
                            child: Center(
                              child: GFLoader(),
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

  void _editCalendarTaskAction(BuildContext ctx, int id) {
    _readCalendarTask(id);
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: EditCalendarTaskPopup(
            editCalendarTask: _editCalendarTask,
            calendarTask: _editedCalendarTask as Calendar,
          ),
        );
      },
    );
  }
}
