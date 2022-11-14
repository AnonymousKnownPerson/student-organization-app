import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/database.dart';
import '../models/calendar.dart';
import '../models/note.dart';
import '../widgets/appbar.dart';

class ToDoPage extends StatefulWidget {
  final Function refresh;
  final List<Note> notesList;
  final List<Calendar> todayCalendarList;
  ToDoPage({
    required this.refresh,
    required this.notesList,
    required this.todayCalendarList,
  });

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage>
    with AutomaticKeepAliveClientMixin {
  Future noteDoneChange(Note note) async {
    await StudentDatabase.instance.updateNote(note);
    widget.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mainHeight = MediaQuery.of(context).size.height -
        108 -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    bool isCalendarTaskActive(int index) {
      return widget.todayCalendarList[index].date.isBefore(DateTime.now()) &&
          widget.todayCalendarList[index].date
              .add(
                Duration(minutes: widget.todayCalendarList[index].duration),
              )
              .isAfter(
                DateTime.now(),
              );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarWidget(title: 'To Do List'),
      body: SizedBox(
        height: mainHeight,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: mainHeight * 2 / 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 0.3,
                  child: Column(
                    children: [
                      Expanded(
                        child: widget.todayCalendarList.isNotEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (contx, index) {
                                  return Container(
                                    child: GestureDetector(
                                      child: Card(
                                        elevation: 0.4,
                                        margin: EdgeInsets.all(2),
                                        child: ListTile(
                                          leading: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: isCalendarTaskActive(index)
                                                  ? const Color.fromARGB(
                                                      255, 146, 175, 147)
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                            ),
                                            margin: const EdgeInsets.fromLTRB(
                                                1, 3, 1, 1),
                                            child: Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Text(
                                                '${DateFormat("Hm").format(widget.todayCalendarList[index].date)} - ${DateFormat("Hm").format(widget.todayCalendarList[index].date.add(Duration(minutes: widget.todayCalendarList[index].duration)))}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            widget
                                                .todayCalendarList[index].title
                                                .toString(),
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
                                              widget.todayCalendarList[index]
                                                              .subtitle ==
                                                          null ||
                                                      widget
                                                              .todayCalendarList[
                                                                  index]
                                                              .subtitle! ==
                                                          ''
                                                  ? 'No more data'
                                                  : widget
                                                      .todayCalendarList[index]
                                                      .subtitle as String),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: widget.todayCalendarList.length,
                              )
                            : Text(
                                "Nothing is added, add more events!",
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: mainHeight * 3 / 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 0.3,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (contx, index) {
                            return GestureDetector(
                              onTap: () {
                                noteDoneChange(Note(
                                    id: widget.notesList[index].id,
                                    title: widget.notesList[index].title,
                                    priority: widget.notesList[index].priority,
                                    done: !widget.notesList[index].done,
                                    isActive:
                                        widget.notesList[index].isActive));
                              },
                              child: InkWell(
                                splashColor:
                                    Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15),
                                child: widget.notesList[index].done
                                    //
                                    ? Card(
                                        elevation: 0.5,
                                        margin: EdgeInsets.all(5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: ListTile(
                                            trailing: CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              foregroundColor: Colors.white,
                                              child: FittedBox(
                                                child: Text('0'),
                                              ),
                                            ),
                                            leading: Icon(
                                              size: 30,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              Icons.check_box,
                                            ),
                                            title: Text(
                                              widget.notesList[index].title
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                            subtitle: Text(
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                                widget.notesList[index]
                                                        .subtitle ??
                                                    'No more data'),
                                          ),
                                        ),
                                      )
                                    //
                                    : Card(
                                        elevation: 0.5,
                                        margin: EdgeInsets.all(5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: ListTile(
                                            trailing: CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              foregroundColor: Colors.white,
                                              child: FittedBox(
                                                child: Text(
                                                    '${widget.notesList[index].priority}'),
                                              ),
                                            ),
                                            leading: Icon(
                                                size: 30,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                Icons.check_box_outline_blank),
                                            title: Text(
                                              widget.notesList[index].title
                                                  .toString(),
                                              style: TextStyle(
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
                                                widget.notesList[index]
                                                        .subtitle ??
                                                    'No more data'),
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          },
                          itemCount: widget.notesList.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
