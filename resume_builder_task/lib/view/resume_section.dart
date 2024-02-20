import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';

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
      ),
      home: const ResumeAddPage(),
    );
  }
}

class ResumeAddPage extends StatefulWidget {
  const ResumeAddPage({Key? key}) : super(key: key);

  @override
  _ResumeAddPageState createState() => _ResumeAddPageState();
}

class _ResumeAddPageState extends State<ResumeAddPage> {
  List<Experience> experiences = [];
  List<Education> educations = [];
  List<String> projects = [];
  List<String> skills = [];
  File? _image;

  final picker = ImagePicker();

  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final List<TextEditingController> experienceCompanyControllers = [];
  final List<TextEditingController> experienceDurationControllers = [];
  final List<TextEditingController> experiencePositionControllers = [];
  final List<TextEditingController> educationCollegeControllers = [];
  final List<TextEditingController> educationDegreeControllers = [];
  final List<TextEditingController> educationGraduationYearControllers = [];
  final List<TextEditingController> projectControllers = [];
  final List<TextEditingController> skillControllers = [];

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    for (var controller in experienceCompanyControllers) {
      controller.dispose();
    }
    for (var controller in experienceDurationControllers) {
      controller.dispose();
    }
    for (var controller in experiencePositionControllers) {
      controller.dispose();
    }
    for (var controller in educationCollegeControllers) {
      controller.dispose();
    }
    for (var controller in educationDegreeControllers) {
      controller.dispose();
    }
    for (var controller in educationGraduationYearControllers) {
      controller.dispose();
    }
    for (var controller in projectControllers) {
      controller.dispose();
    }
    for (var controller in skillControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void saveDataToHive() {
    final personalInfoBox = Hive.box('personal_info');
    final experienceBox = Hive.box('experiences');
    final educationBox = Hive.box('educations');
    final projectBox = Hive.box('projects');
    final skillBox = Hive.box('skills');

    try {
      // Save personal information
      personalInfoBox.put('full_name', fullNameController.text);
      personalInfoBox.put('email', emailController.text);
      personalInfoBox.put('phone_number', phoneNumberController.text);

      // Save experiences
      for (int i = 0; i < experiences.length; i++) {
        experienceBox.put('company_$i', experienceCompanyControllers[i].text);
        experienceBox.put('duration_$i', experienceDurationControllers[i].text);
        experienceBox.put('position_$i', experiencePositionControllers[i].text);
      }

      // Save educations
      for (int i = 0; i < educations.length; i++) {
        educationBox.put('college_$i', educationCollegeControllers[i].text);
        educationBox.put('degree_$i', educationDegreeControllers[i].text);
        educationBox.put(
            'graduation_year_$i', educationGraduationYearControllers[i].text);
      }

      // Save projects
      for (int i = 0; i < projects.length; i++) {
        projectBox.put('project_$i', projectControllers[i].text);
      }

      // Save skills
      for (int i = 0; i < skills.length; i++) {
        skillBox.put('skill_$i', skillControllers[i].text);
      }

      print("Data saved successfully");
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resume Add Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Image",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(),
              // Image section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_image != null) ...[
                    Image.file(_image!),
                    const SizedBox(height: 10),
                  ],
                  ElevatedButton(
                    onPressed: getImage,
                    child: const Text("Pick Image"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                "Personal Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(),
              // Personal Information section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormWidget(
                    hinttext: "Full Name",
                    controller: fullNameController,
                  ),
                  const SizedBox(height: 10),
                  TextFormWidget(
                    hinttext: "Email",
                    controller: emailController,
                  ),
                  const SizedBox(height: 10),
                  TextFormWidget(
                    hinttext: "Phone Number",
                    controller: phoneNumberController,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                "Experience",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(),
              // Experience section
              ListView.builder(
                shrinkWrap: true,
                itemCount: experiences.length + 1,
                itemBuilder: (context, index) {
                  // Create controllers for this experience item
                  if (index < experiences.length) {
                    if (experienceCompanyControllers.length <= index) {
                      experienceCompanyControllers.add(TextEditingController());
                      experienceDurationControllers
                          .add(TextEditingController());
                      experiencePositionControllers
                          .add(TextEditingController());
                    }
                  }

                  if (index == experiences.length) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          experiences.add(Experience());
                        });
                      },
                      child: const Text("Add Experience"),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Experience ${index + 1}"),
                      const SizedBox(height: 10),
                      TextFormWidget(
                        hinttext: "Company",
                        controller: experienceCompanyControllers[index],
                        onChanged: (value) {
                          setState(() {
                            experiences[index].company = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormWidget(
                              hinttext: "Duration",
                              controller: experienceDurationControllers[index],
                              onChanged: (value) {
                                setState(() {
                                  experiences[index].duration = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormWidget(
                              hinttext: "Position",
                              controller: experiencePositionControllers[index],
                              onChanged: (value) {
                                setState(() {
                                  experiences[index].position = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            experiences.removeAt(index);
                            // Clean up the controllers when removing an experience
                            experienceCompanyControllers[index].dispose();
                            experienceDurationControllers[index].dispose();
                            experiencePositionControllers[index].dispose();
                            experienceCompanyControllers.removeAt(index);
                            experienceDurationControllers.removeAt(index);
                            experiencePositionControllers.removeAt(index);
                          });
                        },
                        child: const Text("Remove"),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              const Text(
                "Education",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(),
              // Education section
              ListView.builder(
                shrinkWrap: true,
                itemCount: educations.length + 1,
                itemBuilder: (context, index) {
                  // Create controllers for this education item
                  if (index < educations.length) {
                    if (educationCollegeControllers.length <= index) {
                      educationCollegeControllers.add(TextEditingController());
                      educationDegreeControllers.add(TextEditingController());
                      educationGraduationYearControllers
                          .add(TextEditingController());
                    }
                  }

                  if (index == educations.length) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          educations.add(Education());
                        });
                      },
                      child: const Text("Add Education"),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Education ${index + 1}"),
                      const SizedBox(height: 10),
                      TextFormWidget(
                        hinttext: "College",
                        controller: educationCollegeControllers[index],
                        onChanged: (value) {
                          setState(() {
                            educations[index].college = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormWidget(
                              hinttext: "Degree",
                              controller: educationDegreeControllers[index],
                              onChanged: (value) {
                                setState(() {
                                  educations[index].degree = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormWidget(
                              hinttext: "Graduation Year",
                              controller:
                                  educationGraduationYearControllers[index],
                              onChanged: (value) {
                                setState(() {
                                  educations[index].graduationYear = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            educations.removeAt(index);
                            // Clean up the controllers when removing an education
                            educationCollegeControllers[index].dispose();
                            educationDegreeControllers[index].dispose();
                            educationGraduationYearControllers[index].dispose();
                            educationCollegeControllers.removeAt(index);
                            educationDegreeControllers.removeAt(index);
                            educationGraduationYearControllers.removeAt(index);
                          });
                        },
                        child: const Text("Remove"),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              const Text(
                "Projects",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(),
              // Project section
              ListView.builder(
                shrinkWrap: true,
                itemCount: projects.length + 1,
                itemBuilder: (context, index) {
                  // Create controllers for this project item
                  if (index < projects.length) {
                    if (projectControllers.length <= index) {
                      projectControllers.add(TextEditingController());
                    }
                  }

                  if (index == projects.length) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          projects.add('');
                        });
                      },
                      child: const Text("Add Project"),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormWidget(
                        hinttext: "Project",
                        controller: projectControllers[index],
                        onChanged: (value) {
                          setState(() {
                            projects[index] = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            projects.removeAt(index);
                            // Clean up the controllers when removing a project
                            projectControllers[index].dispose();
                            projectControllers.removeAt(index);
                          });
                        },
                        child: const Text("Remove"),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              const Text(
                "Skills",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(),
              // Skill section
              ListView.builder(
                shrinkWrap: true,
                itemCount: skills.length + 1,
                itemBuilder: (context, index) {
                  // Create controllers for this skill item
                  if (index < skills.length) {
                    if (skillControllers.length <= index) {
                      skillControllers.add(TextEditingController());
                    }
                  }

                  if (index == skills.length) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          skills.add('');
                        });
                      },
                      child: const Text("Add Skill"),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormWidget(
                        hinttext: "Skill",
                        controller: skillControllers[index],
                        onChanged: (value) {
                          setState(() {
                            skills[index] = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            skills.removeAt(index);
                            // Clean up the controllers when removing a skill
                            skillControllers[index].dispose();
                            skillControllers.removeAt(index);
                          });
                        },
                        child: const Text("Remove"),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 9, 38, 61),
                    ),
                  ),
                  onPressed: () {
                    saveDataToHive();
                    print("data saved");
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFormWidget extends StatelessWidget {
  final String hinttext;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const TextFormWidget({
    Key? key,
    required this.hinttext,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hinttext,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class Experience {
  String? company;
  String? duration;
  String? position;
}

class Education {
  String? college;
  String? degree;
  String? graduationYear;
}


// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Resume Builder',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const ResumeAddPage(),
//     );
//   }
// }

// class ResumeAddPage extends StatefulWidget {
//   const ResumeAddPage({Key? key}) : super(key: key);

//   @override
//   _ResumeAddPageState createState() => _ResumeAddPageState();
// }

// class _ResumeAddPageState extends State<ResumeAddPage> {
//   List<Experience> experiences = [];
//   List<Education> educations = [];
//   List<String> projects = [];
//   List<String> skills = [];
//   File? _image;

//   final picker = ImagePicker();

//   // Controllers for text fields
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final List<TextEditingController> experienceCompanyControllers = [];
//   final List<TextEditingController> experienceDurationControllers = [];
//   final List<TextEditingController> experiencePositionControllers = [];
//   final List<TextEditingController> educationCollegeControllers = [];
//   final List<TextEditingController> educationDegreeControllers = [];
//   final List<TextEditingController> educationGraduationYearControllers = [];
//   final List<TextEditingController> projectControllers = [];
//   final List<TextEditingController> skillControllers = [];

//   @override
//   void dispose() {
//     // Clean up the controllers when the widget is disposed
//     fullNameController.dispose();
//     emailController.dispose();
//     phoneNumberController.dispose();
//     for (var controller in experienceCompanyControllers) {
//       controller.dispose();
//     }
//     for (var controller in experienceDurationControllers) {
//       controller.dispose();
//     }
//     for (var controller in experiencePositionControllers) {
//       controller.dispose();
//     }
//     for (var controller in educationCollegeControllers) {
//       controller.dispose();
//     }
//     for (var controller in educationDegreeControllers) {
//       controller.dispose();
//     }
//     for (var controller in educationGraduationYearControllers) {
//       controller.dispose();
//     }
//     for (var controller in projectControllers) {
//       controller.dispose();
//     }
//     for (var controller in skillControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   Future getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Resume Add Page"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Image",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const Divider(),
//               // Image section
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (_image != null) ...[
//                     Image.file(_image!),
//                     const SizedBox(height: 10),
//                   ],
//                   ElevatedButton(
//                     onPressed: getImage,
//                     child: const Text("Pick Image"),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               const Text(
//                 "Personal Information",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const Divider(),
//               // Personal Information section
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormWidget(
//                     hinttext: "Full Name",
//                     controller: fullNameController,
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormWidget(
//                     hinttext: "Email",
//                     controller: emailController,
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormWidget(
//                     hinttext: "Phone Number",
//                     controller: phoneNumberController,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               const Text(
//                 "Experience",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const Divider(),
//               // Experience section
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: experiences.length + 1,
//                 itemBuilder: (context, index) {
//                   if (index < experiences.length) {
//                     if (experienceCompanyControllers.length <= index) {
//                       experienceCompanyControllers.add(TextEditingController());
//                       experienceDurationControllers
//                           .add(TextEditingController());
//                       experiencePositionControllers
//                           .add(TextEditingController());
//                     }
//                   }

//                   if (index == experiences.length) {
//                     return ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           experiences.add(Experience());
//                         });
//                       },
//                       child: const Text("Add Experience"),
//                     );
//                   }

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Experience ${index + 1}"),
//                       const SizedBox(height: 10),
//                       TextFormWidget(
//                         hinttext: "Company",
//                         controller: experienceCompanyControllers[index],
//                         onChanged: (value) {
//                           setState(() {
//                             experiences[index].company = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormWidget(
//                               hinttext: "Duration",
//                               controller: experienceDurationControllers[index],
//                               onChanged: (value) {
//                                 setState(() {
//                                   experiences[index].duration = value;
//                                 });
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: TextFormWidget(
//                               hinttext: "Position",
//                               controller: experiencePositionControllers[index],
//                               onChanged: (value) {
//                                 setState(() {
//                                   experiences[index].position = value;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             experiences.removeAt(index);
//                             // Clean up the controllers when removing an experience
//                             experienceCompanyControllers[index].dispose();
//                             experienceDurationControllers[index].dispose();
//                             experiencePositionControllers[index].dispose();
//                             experienceCompanyControllers.removeAt(index);
//                             experienceDurationControllers.removeAt(index);
//                             experiencePositionControllers.removeAt(index);
//                           });
//                         },
//                         child: const Text("Remove"),
//                       ),
//                       const Divider(),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),

//               const Text(
//                 "Education",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const Divider(),
//               // Education section
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: educations.length + 1,
//                 itemBuilder: (context, index) {
//                   // Create controllers for this education item
//                   if (index < educations.length) {
//                     if (educationCollegeControllers.length <= index) {
//                       educationCollegeControllers.add(TextEditingController());
//                       educationDegreeControllers.add(TextEditingController());
//                       educationGraduationYearControllers
//                           .add(TextEditingController());
//                     }
//                   }

//                   if (index == educations.length) {
//                     return ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           educations.add(Education());
//                         });
//                       },
//                       child: const Text("Add Education"),
//                     );
//                   }

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Education ${index + 1}"),
//                       const SizedBox(height: 10),
//                       TextFormWidget(
//                         hinttext: "College",
//                         controller: educationCollegeControllers[index],
//                         onChanged: (value) {
//                           setState(() {
//                             educations[index].college = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormWidget(
//                               hinttext: "Degree",
//                               controller: educationDegreeControllers[index],
//                               onChanged: (value) {
//                                 setState(() {
//                                   educations[index].degree = value;
//                                 });
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: TextFormWidget(
//                               hinttext: "Graduation Year",
//                               controller:
//                                   educationGraduationYearControllers[index],
//                               onChanged: (value) {
//                                 setState(() {
//                                   educations[index].graduationYear = value;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             educations.removeAt(index);
//                             // Clean up the controllers when removing an education
//                             educationCollegeControllers[index].dispose();
//                             educationDegreeControllers[index].dispose();
//                             educationGraduationYearControllers[index].dispose();
//                             educationCollegeControllers.removeAt(index);
//                             educationDegreeControllers.removeAt(index);
//                             educationGraduationYearControllers.removeAt(index);
//                           });
//                         },
//                         child: const Text("Remove"),
//                       ),
//                       const Divider(),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),

//               const Text(
//                 "Projects",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const Divider(),
//               // Project section
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: projects.length + 1,
//                 itemBuilder: (context, index) {
//                   // Create controllers for this project item
//                   if (index < projects.length) {
//                     if (projectControllers.length <= index) {
//                       projectControllers.add(TextEditingController());
//                     }
//                   }

//                   if (index == projects.length) {
//                     return ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           projects.add('');
//                         });
//                       },
//                       child: const Text("Add Project"),
//                     );
//                   }

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextFormWidget(
//                         hinttext: "Project",
//                         controller: projectControllers[index],
//                         onChanged: (value) {
//                           setState(() {
//                             projects[index] = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             projects.removeAt(index);
//                             // Clean up the controllers when removing a project
//                             projectControllers[index].dispose();
//                             projectControllers.removeAt(index);
//                           });
//                         },
//                         child: const Text("Remove"),
//                       ),
//                       const Divider(),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),

//               const Text(
//                 "Skills",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const Divider(),
//               // Skill section
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: skills.length + 1,
//                 itemBuilder: (context, index) {
//                   // Create controllers for this skill item
//                   if (index < skills.length) {
//                     if (skillControllers.length <= index) {
//                       skillControllers.add(TextEditingController());
//                     }
//                   }

//                   if (index == skills.length) {
//                     return ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           skills.add('');
//                         });
//                       },
//                       child: const Text("Add Skill"),
//                     );
//                   }

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextFormWidget(
//                         hinttext: "Skill",
//                         controller: skillControllers[index],
//                         onChanged: (value) {
//                           setState(() {
//                             skills[index] = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             skills.removeAt(index);
//                             // Clean up the controllers when removing a skill
//                             skillControllers[index].dispose();
//                             skillControllers.removeAt(index);
//                           });
//                         },
//                         child: const Text("Remove"),
//                       ),
//                       const Divider(),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 height: 60,
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: const ButtonStyle(
//                     backgroundColor: MaterialStatePropertyAll(
//                       Color.fromARGB(255, 9, 38, 61),
//                     ),
//                   ),
//                   onPressed: () {},
//                   child: const Text(
//                     "Save",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TextFormWidget extends StatelessWidget {
//   final String hinttext;
//   final TextEditingController? controller;
//   final ValueChanged<String>? onChanged;

//   const TextFormWidget({
//     Key? key,
//     required this.hinttext,
//     this.controller,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         hintText: hinttext,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
// }

// class Experience {
//   String? company;
//   String? duration;
//   String? position;
// }

// class Education {
//   String? college;
//   String? degree;
//   String? graduationYear;
// }
