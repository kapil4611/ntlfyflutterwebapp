// With mongoDB
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntlfyflutterwebapp/models/note.dart';
import 'package:ntlfyflutterwebapp/pages/add_new_note.dart';
import 'package:ntlfyflutterwebapp/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Notes App"),
        centerTitle: true,
      ),
      body: notesProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : notesProvider.errorMessage != null
              ? Center(child: Text(notesProvider.errorMessage!))
              : SafeArea(
                  child: (notesProvider.notes.isNotEmpty)
                      ? ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    searchQuery = val;
                                  });
                                },
                                decoration:
                                    InputDecoration(labelText: "Search"),
                              ),
                            ),
                            (notesProvider
                                    .getFilteredNotes(searchQuery)
                                    .isNotEmpty)
                                ? GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    // itemCount: notesProvider.notes.length,
                                    itemCount: notesProvider
                                        .getFilteredNotes(searchQuery)
                                        .length,
                                    itemBuilder: (context, index) {
                                      // Note currentNote = notesProvider.notes[index];
                                      Note currentNote = notesProvider
                                          .getFilteredNotes(searchQuery)[index];

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      AddNewNotePage(
                                                        isUpdate: true,
                                                        note: currentNote,
                                                      )));
                                        },
                                        onLongPress: () {
                                          notesProvider.deleteNote(currentNote);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 2)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                currentNote.title!,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 7),
                                              Text(
                                                currentNote.content!,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey[700]),
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      "No notes found",
                                      textAlign: TextAlign.center,
                                    )),
                          ],
                        )
                      : const Center(
                          child: Text("No note is there"),
                        ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const AddNewNotePage(
                        isUpdate: false,
                      )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
