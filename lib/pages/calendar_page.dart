import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widgets/appbar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  CalendarFormat _calFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List _calendarDayList = [];
  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calFormat = format;
    });
  }

  void _onDaySelected(DateTime focusedD, DateTime selectedD) {
    setState(() {
      _focusedDay = focusedD;
      _selectedDay = selectedD;
      _calendarDayList = _getEventsForDay(selectedD);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarWidget(title: 'Calendar'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
            child: Card(
              elevation: 2,
              margin: EdgeInsets.fromLTRB(2, 3, 2, 5),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
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
                  //eventLoader: (day) {
                  //  return _getEventsForDay(day);
                  //},
                ),
              ),
            ),
          ),
          Card(
            child: Container(
                height: 200,
                child: _calendarDayList.isEmpty
                    ? const Text(
                        "No transactions yet!",
                      )
                    : const Text(
                        "No transactions yet!",
                      ) /* 
                  ListView.builder(
                      itemBuilder: (contx, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          elevation: 5,
                          child: ListTile(title: _calendarDayList[index]),
                        );
                      },
                      itemCount: _calendarDayList.length,
                    ),*/
                ),
          ),
        ],
      ),
    );
  }

  List<String> _getEventsForDay(DateTime day) {
    List<String> todaysEvents = ['Test', 'qwdqwqw', 'qwdwqwq'];
    _calendarDayList = todaysEvents;
    return todaysEvents;
  }

  @override
  bool get wantKeepAlive => true;
}
