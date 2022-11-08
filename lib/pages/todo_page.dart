import 'package:flutter/material.dart';

import '../db/note_database.dart';
import '../models/note.dart';
import '../widgets/appbar.dart';

class ToDoPage extends StatefulWidget {
  final Function refresh;
  final List<Note> notesList;
  ToDoPage({required this.refresh, required this.notesList});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mainHeight = MediaQuery.of(context).size.height -
        108 -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarWidget(title: 'To Do List'),
      body: SizedBox(
        height: mainHeight,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: mainHeight / 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  child: FittedBox(
                    alignment: Alignment.topCenter,
                    fit: BoxFit.none,
                    child: Column(
                      children: [
                        Card(
                          child: Text('data'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: mainHeight / 2,
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
                                elevation: 5,
                                margin: EdgeInsets.all(5),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      child: FittedBox(
                                        child: Text(
                                            '${widget.notesList[index].priority}'),
                                      ),
                                    ),
                                    title: Text(
                                      widget.notesList[index].title.toString(),
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
                                        widget.notesList[index].subtitle ??
                                            'No more data'),
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
