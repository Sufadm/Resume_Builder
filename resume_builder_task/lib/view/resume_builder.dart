import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:resume_builder_task/view/resume_detail_page.dart';
import 'package:resume_builder_task/view/resume_section.dart';

class ResumeBuilder extends StatelessWidget {
  const ResumeBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const ResumeAddPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
      body: const ResumeNameList(),
    );
  }
}

class ResumeNameList extends StatelessWidget {
  const ResumeNameList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _retrieveNameFromHive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final names = snapshot.data!;
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              final name = names[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ResumeDetailPage(name: name);
                  }));
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(name),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<String>> _retrieveNameFromHive() async {
    final personalInfoBox = Hive.box('personal_info');
    final fullName = personalInfoBox.get('full_name', defaultValue: '');
    return [fullName];
  }
}
