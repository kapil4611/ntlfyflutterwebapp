import 'dart:convert';
import 'dart:developer';
import 'package:ntlfyflutterwebapp/models/note.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Hosted api on render server
  static String _baseUrl = "https://newrndr.onrender.com/notes";

  // Fetch Note
  static Future<List<Note>> fetchNotes(String userid) async {
    Uri requestUri = Uri.parse("$_baseUrl/list");
    log(requestUri.toString());

    try {
      var response = await http.post(requestUri, body: {"userId": userid});
      log(response.statusCode.toString());
      var decoded = jsonDecode(response.body);
      log(decoded.toString());
      // return [];
      List<Note> notes = [];
      for (var noteMap in decoded) {
        Note newNote = Note.fromMap(noteMap);
        notes.add(newNote);
      }
      return notes;
    } catch (e) {
      log(e.toString());
      throw "Error: $e";
    }
  }

  // Add Note
  static Future<void> addNote(Note note) async {
    Uri requestUri = Uri.parse("$_baseUrl/add");
    var response = await http.post(requestUri, body: note.toMap());
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  // Delete Note
  static Future<void> deleteNote(Note note) async {
    Uri requestUri = Uri.parse("$_baseUrl/delete");
    var response = await http.post(requestUri, body: note.toMap());
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }
}
