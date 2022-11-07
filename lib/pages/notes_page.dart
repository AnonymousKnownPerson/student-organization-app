import 'package:flutter/material.dart';
import 'package:student_app/widgets/deletePopup.dart';
import 'package:getwidget/getwidget.dart';

import '../db/note_database.dart';
import '../models/note.dart';
import '../widgets/addNotePopup.dart';
import '../widgets/appbar.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = false;
  List<Note> _notesList = [];

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NoteDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => _isLoading = true);
    _notesList = await NoteDatabase.instance.readNotes(false);
    setState(() => _isLoading = false);
  }

  Future _addNote(String title, String? subtitle, int? priority) async {
    final newNote = Note(
        title: title,
        subtitle: subtitle,
        priority: priority,
        done: false,
        isActive: false);
    await NoteDatabase.instance.create(newNote);
    refreshNotes();
  }

  Future _deleteNote(int id) async {
    await NoteDatabase.instance.delete(id);
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mainHeight = MediaQuery.of(context).size.height -
        52 -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarWidget(title: 'Notes'),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: mainHeight,
        child: Card(
          elevation: 5,
          child: !_isLoading
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (contx, index) {
                          return GestureDetector(
                            //onLongPress: () => ,
                            child: Card(
                              elevation: 5,
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
                                          '${_notesList[index].priority ?? '?'}'),
                                    ),
                                  ),
                                  title: Text(
                                    _notesList[index].title.toString(),
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
                                      _notesList[index].subtitle ??
                                          'No more data'),
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
                                                  id: _notesList[index].id
                                                      as int));
                                      //_deleteNote(_notesList[index].id as int);
                                      ///ScaffoldMessenger.of(context)
                                      //    .showSnackBar(const SnackBar(
                                      //         content: Text('Note deleted')));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: _notesList.length,
                      ),
                    ),
                    /*IconButton(
                  onPressed: () => _addButtonAction(context),
                  icon: Icon(Icons.add,
                      color: Theme.of(context).colorScheme.primary))*/
                  ],
                )
              : const Positioned.fill(
                  child: Center(child: GFLoader()),
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

  @override
  bool get wantKeepAlive => true;
}
