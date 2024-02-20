import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:resume_builder_task/view/resume_builder.dart';
import 'package:resume_builder_task/view/resume_section.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('experiences');
  await Hive.openBox('educations');
  await Hive.openBox('projects');
  await Hive.openBox('skills');
  await Hive.openBox('personal_info'); // Add this line
  print('Boxes opened successfully'); // Add this line

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ResumeBuilder(),
    );
  }
}
