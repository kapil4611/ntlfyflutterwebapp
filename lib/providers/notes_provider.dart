// With mongoDB
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ntlfyflutterwebapp/models/note.dart';
import 'package:ntlfyflutterwebapp/services/api_service.dart';

class NotesProvider with ChangeNotifier {
  bool _isLoading = false;
  List<Note> notes = [];
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Apicalling
  NotesProvider() {
    fetchNotes();
  }

  void fetchNotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      notes = await ApiService.fetchNotes("kapilchouhan");
      sortNotes();
    } catch (e) {
      log("k: $e");
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  List<Note> getFilteredNotes(String searchQuery) {
    return notes
        .where((element) =>
            element.title!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            element.content!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void sortNotes() {
    notes.sort((a, b) => b.dateadded!.compareTo(a.dateadded!));
  }

  void addNote(Note note) {
    notes.add(note);
    sortNotes();
    notifyListeners();
    // Apicalling
    ApiService.addNote(note);
  }

  void updateNote(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote] = note;
    sortNotes();
    notifyListeners();
    // Apicalling
    ApiService.addNote(note);
  }

  void deleteNote(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(indexOfNote);
    notifyListeners();
    // Apicalling
    ApiService.deleteNote(note);
  }
}
