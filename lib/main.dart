import 'package:flutter/material.dart';
import 'package:ntlfyflutterwebapp/pages/home_page.dart';
import 'package:ntlfyflutterwebapp/providers/notes_provider.dart';
import 'package:provider/provider.dart';

// First goto backend folder then run server then run the flutter notes app
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NotesProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
