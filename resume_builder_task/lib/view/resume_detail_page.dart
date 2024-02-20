import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ResumeDetailPage extends StatelessWidget {
  final String name;

  const ResumeDetailPage({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildResumeContent(),
        ),
      ),
    );
  }

  Widget _buildResumeContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // _buildSectionTitle('Contact Information'),
          _buildContactInfo(),
          const Divider(),
          const SizedBox(height: 20),
          _buildSectionTitle('Experience'),
          _buildExperience(),
          const SizedBox(height: 20),
          _buildSectionTitle('Education'),
          _buildEducation(),
          const SizedBox(height: 20),
          _buildSectionTitle('Projects'),
          _buildProjects(),
          const SizedBox(height: 20),
          _buildSectionTitle('Skills'),
          _buildSkills(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildContactInfo() {
    final personalInfoBox = Hive.box('personal_info');
    final email = personalInfoBox.get('email', defaultValue: '');
    final phoneNumber = personalInfoBox.get('phone_number', defaultValue: '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text('$email')),
        Center(child: Text('$phoneNumber')),
      ],
    );
  }

  Widget _buildExperience() {
    final experienceBox = Hive.box('experiences');
    final List<String> experiences = [];

    for (int i = 0; i < experienceBox.length; i++) {
      final company = experienceBox.get('company_$i', defaultValue: '');
      final duration = experienceBox.get('duration_$i', defaultValue: '');
      final position = experienceBox.get('position_$i', defaultValue: '');
      experiences.add('$position at $company ($duration)');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: experiences.map((exp) => Text(exp)).toList(),
    );
  }

  Widget _buildEducation() {
    final educationBox = Hive.box('educations');
    final List<String> educations = [];

    for (int i = 0; i < educationBox.length; i++) {
      final college = educationBox.get('college_$i', defaultValue: '');
      final degree = educationBox.get('degree_$i', defaultValue: '');
      final graduationYear =
          educationBox.get('graduation_year_$i', defaultValue: '');
      educations.add('$degree in $college ($graduationYear)');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: educations.map((edu) => Text(edu)).toList(),
    );
  }

  Widget _buildProjects() {
    final projectBox = Hive.box('projects');
    final List<String> projects = [];

    for (int i = 0; i < projectBox.length; i++) {
      final project = projectBox.get('project_$i', defaultValue: '');
      projects.add(project);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: projects.map((proj) => Text(proj)).toList(),
    );
  }

  Widget _buildSkills() {
    final skillBox = Hive.box('skills');
    final List<String> skills = [];

    for (int i = 0; i < skillBox.length; i++) {
      final skill = skillBox.get('skill_$i', defaultValue: '');
      skills.add(skill);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: skills.map((sk) => Text(sk)).toList(),
    );
  }
}
