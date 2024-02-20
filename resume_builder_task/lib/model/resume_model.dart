import 'package:hive/hive.dart';
part 'resume_model.g.dart';

@HiveType(typeId: 0)
class ResumeSection {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  ResumeSection({required this.title, required this.content});
}
