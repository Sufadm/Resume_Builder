// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:resume_builder_task/view/resume_section.dart';

// class ResumeBuilder extends StatelessWidget {
//   const ResumeBuilder({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return const ResumeAddPage();
//           }));
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: const ResumeDisplay(),
//     );
//   }
// }

// class ResumeDisplay extends StatelessWidget {
//   const ResumeDisplay({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ResumeData>(
//       future: _retrieveDataFromHive(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else {
//           final resumeData = snapshot.data!;
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: SafeArea(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: _buildLeftColumn(resumeData),
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     child: _buildRightColumn(resumeData),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }

//   Widget _buildLeftColumn(ResumeData resumeData) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildPersonalInformation(resumeData),
//         _buildSectionTitle("Experience"),
//         _buildExperiences(resumeData.experiences),
//       ],
//     );
//   }

//   Widget _buildRightColumn(ResumeData resumeData) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle("Education"),
//         _buildEducations(resumeData.educations),
//         _buildSectionTitle("Projects"),
//         _buildProjects(resumeData.projects),
//         _buildSectionTitle("Skills"),
//         _buildSkills(resumeData.skills),
//       ],
//     );
//   }

//   Widget _buildPersonalInformation(ResumeData resumeData) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Personal Information",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         const Divider(),
//         Text("Full Name: ${resumeData.fullName}"),
//         Text("Email: ${resumeData.email}"),
//         Text("Phone Number: ${resumeData.phoneNumber}"),
//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         const Divider(),
//       ],
//     );
//   }

//   Widget _buildExperiences(List<Experience> experiences) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         for (var experience in experiences)
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Company: ${experience.company}"),
//               Text("Duration: ${experience.duration}"),
//               Text("Position: ${experience.position}"),
//               const Divider(),
//             ],
//           ),
//       ],
//     );
//   }

//   Widget _buildEducations(List<Education> educations) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         for (var education in educations)
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("College: ${education.college}"),
//               Text("Degree: ${education.degree}"),
//               Text("Graduation Year: ${education.graduationYear}"),
//               const Divider(),
//             ],
//           ),
//       ],
//     );
//   }

//   Widget _buildProjects(List<String> projects) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         for (var project in projects)
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Project: $project"),
//               const Divider(),
//             ],
//           ),
//       ],
//     );
//   }

//   Widget _buildSkills(List<String> skills) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         for (var skill in skills)
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Skill: $skill"),
//               const Divider(),
//             ],
//           ),
//       ],
//     );
//   }

//   Future<ResumeData> _retrieveDataFromHive() async {
//     // Implementation to retrieve data from Hive
//     final personalInfoBox = await Hive.openBox('personal_info');
//     final experienceBox = await Hive.openBox('experiences');
//     final educationBox = await Hive.openBox('educations');
//     final projectBox = await Hive.openBox('projects');
//     final skillBox = await Hive.openBox('skills');

//     final fullName = personalInfoBox.get('full_name', defaultValue: '');
//     final email = personalInfoBox.get('email', defaultValue: '');
//     final phoneNumber = personalInfoBox.get('phone_number', defaultValue: '');

//     final List<Experience> experiences = [];
//     final List<Education> educations = [];
//     final List<String> projects = [];
//     final List<String> skills = [];

//     for (int i = 0; i < experienceBox.length; i++) {
//       final company = experienceBox.get('company_$i', defaultValue: '');
//       final duration = experienceBox.get('duration_$i', defaultValue: '');
//       final position = experienceBox.get('position_$i', defaultValue: '');
//       experiences.add(
//         Experience(company: company, duration: duration, position: position),
//       );
//     }

//     for (int i = 0; i < educationBox.length; i++) {
//       final college = educationBox.get('college_$i', defaultValue: '');
//       final degree = educationBox.get('degree_$i', defaultValue: '');
//       final graduationYear =
//           educationBox.get('graduation_year_$i', defaultValue: '');
//       educations.add(
//         Education(
//           college: college,
//           degree: degree,
//           graduationYear: graduationYear,
//         ),
//       );
//     }

//     for (int i = 0; i < projectBox.length; i++) {
//       final project = projectBox.get('project_$i', defaultValue: '');
//       projects.add(project);
//     }

//     for (int i = 0; i < skillBox.length; i++) {
//       final skill = skillBox.get('skill_$i', defaultValue: '');
//       skills.add(skill);
//     }

//     return ResumeData(
//       fullName: fullName,
//       email: email,
//       phoneNumber: phoneNumber,
//       experiences: experiences,
//       educations: educations,
//       projects: projects,
//       skills: skills,
//     );
//   }
// }

// class ResumeData {
//   final String fullName;
//   final String email;
//   final String phoneNumber;
//   final List<Experience> experiences;
//   final List<Education> educations;
//   final List<String> projects;
//   final List<String> skills;

//   ResumeData({
//     required this.fullName,
//     required this.email,
//     required this.phoneNumber,
//     required this.experiences,
//     required this.educations,
//     required this.projects,
//     required this.skills,
//   });
// }

// class Experience {
//   final String company;
//   final String duration;
//   final String position;

//   Experience({
//     required this.company,
//     required this.duration,
//     required this.position,
//   });
// }

// class Education {
//   final String college;
//   final String degree;
//   final String graduationYear;

//   Education({
//     required this.college,
//     required this.degree,
//     required this.graduationYear,
//   });
// }
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
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
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<String>> _retrieveNameFromHive() async {
    await Hive.initFlutter();
    final personalInfoBox = Hive.box('personal_info');
    final fullName = personalInfoBox.get('full_name', defaultValue: '');
    print('Full Name: $fullName'); // Print the retrieved name for debugging
    return [fullName];
  }
}

class ResumeDetailPage extends StatelessWidget {
  final String name;

  const ResumeDetailPage({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resume Details')),
      body: FutureBuilder<ResumeData>(
        future: _retrieveDataFromHive(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final resumeData = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: $name",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Divider(),
                  Text("Email: ${resumeData.email}"),
                  Text("Phone Number: ${resumeData.phoneNumber}"),
                  const SizedBox(height: 20),
                  const Text(
                    "Experience",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Divider(),
                  for (var experience in resumeData.experiences)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Company: ${experience.company}"),
                        Text("Duration: ${experience.duration}"),
                        Text("Position: ${experience.position}"),
                        const Divider(),
                      ],
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Education",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Divider(),
                  for (var education in resumeData.educations)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("College: ${education.college}"),
                        Text("Degree: ${education.degree}"),
                        Text("Graduation Year: ${education.graduationYear}"),
                        const Divider(),
                      ],
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Projects",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Divider(),
                  for (var project in resumeData.projects)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Project: $project"),
                        const Divider(),
                      ],
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Skills",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Divider(),
                  for (var skill in resumeData.skills)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Skill: $skill"),
                        const Divider(),
                      ],
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<ResumeData> _retrieveDataFromHive() async {
    // Implementation to retrieve data from Hive
    final personalInfoBox = await Hive.openBox('personal_info');
    final experienceBox = await Hive.openBox('experiences');
    final educationBox = await Hive.openBox('educations');
    final projectBox = await Hive.openBox('projects');
    final skillBox = await Hive.openBox('skills');

    final fullName = personalInfoBox.get('full_name', defaultValue: '');
    final email = personalInfoBox.get('email', defaultValue: '');
    final phoneNumber = personalInfoBox.get('phone_number', defaultValue: '');

    final List<Experience> experiences = [];
    final List<Education> educations = [];
    final List<String> projects = [];
    final List<String> skills = [];

    for (int i = 0; i < experienceBox.length; i++) {
      final company = experienceBox.get('company_$i', defaultValue: '');
      final duration = experienceBox.get('duration_$i', defaultValue: '');
      final position = experienceBox.get('position_$i', defaultValue: '');
      experiences.add(
        Experience(company: company, duration: duration, position: position),
      );
    }

    for (int i = 0; i < educationBox.length; i++) {
      final college = educationBox.get('college_$i', defaultValue: '');
      final degree = educationBox.get('degree_$i', defaultValue: '');
      final graduationYear =
          educationBox.get('graduation_year_$i', defaultValue: '');
      educations.add(
        Education(
          college: college,
          degree: degree,
          graduationYear: graduationYear,
        ),
      );
    }

    for (int i = 0; i < projectBox.length; i++) {
      final project = projectBox.get('project_$i', defaultValue: '');
      projects.add(project);
    }

    for (int i = 0; i < skillBox.length; i++) {
      final skill = skillBox.get('skill_$i', defaultValue: '');
      skills.add(skill);
    }

    return ResumeData(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      experiences: experiences,
      educations: educations,
      projects: projects,
      skills: skills,
    );
  }
}

class ResumeData {
  final String fullName;
  final String email;
  final String phoneNumber;
  final List<Experience> experiences;
  final List<Education> educations;
  final List<String> projects;
  final List<String> skills;

  ResumeData({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.experiences,
    required this.educations,
    required this.projects,
    required this.skills,
  });
}

class Experience {
  final String company;
  final String duration;
  final String position;

  Experience({
    required this.company,
    required this.duration,
    required this.position,
  });
}

class Education {
  final String college;
  final String degree;
  final String graduationYear;

  Education({
    required this.college,
    required this.degree,
    required this.graduationYear,
  });
}
