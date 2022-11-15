import 'package:flutter/material.dart';
import 'package:student_app/widgets/deletePopup.dart';
import 'package:getwidget/getwidget.dart';

import '../db/database.dart';
import '../models/note.dart';
import '../widgets/addNotePopup.dart';
import '../widgets/appbar.dart';
import '../widgets/editNotePopup.dart';

class NotesPage extends StatefulWidget {
  final Function refresh;
  final List<Note> notesList;
  final bool isLoading;
  NotesPage(
      {required this.refresh,
      required this.notesList,
      required this.isLoading});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage>
    with AutomaticKeepAliveClientMixin {
  //List<Note> _notesList = [];
  Note? editedNote = null;

  Future _addNote(String title, String? subtitle, int priority) async {
    final newNote = Note(
        title: title,
        subtitle: subtitle,
        priority: priority,
        done: false,
        isActive: false);
    await StudentDatabase.instance.createNote(newNote);
    widget.refresh();
  }

  Future _deleteNote(int id) async {
    await StudentDatabase.instance.deleteNote(id);
    widget.refresh();
  }

  Future _readNote(int id) async {
    editedNote = await StudentDatabase.instance.readNote(id);
  }

  Future _editNote(Note note) async {
    await StudentDatabase.instance.updateNote(note);
    widget.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mainHeight = MediaQuery.of(context).size.height -
        52 -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarWidget(title: 'Notes'),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: mainHeight,
        child: Card(
          elevation: 5,
          child: !widget.isLoading
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (contx, index) {
                          return GestureDetector(
                            onDoubleTap: () => _editNoteAction(
                                context, widget.notesList[index].id as int),
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
                                      widget.notesList[index].subtitle ==
                                                  null ||
                                              widget.notesList[index]
                                                      .subtitle! ==
                                                  ''
                                          ? 'No more data'
                                          : widget.notesList[index].subtitle
                                              as String),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              DeletePopup(
                                                  deleteNote: _deleteNote,
                                                  id: widget.notesList[index].id
                                                      as int));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: widget.notesList.length,
                      ),
                    ),
                    /*IconButton(
                  onPressed: () => _addButtonAction(context),
                  icon: Icon(Icons.add,
                      color: Theme.of(context).colorScheme.primary))*/
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => _addButtonAction(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _addButtonAction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: AddNotePopup(
              addNote: _addNote,
            ),
          );
        });
  }

  void _editNoteAction(BuildContext ctx, int id) {
    _readNote(id);
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: EditNotePopup(
            editNote: _editNote,
            note: editedNote as Note,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
