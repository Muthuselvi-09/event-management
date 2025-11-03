import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> color1;
  late Animation<Color?> color2;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final rollNoController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String? selectedCourse;
  String? selectedYear;

  final List<String> courses = [
    'B.Sc Computer Science',
    'BCA',
    'B.Tech IT',
    'MBA',
    'MCA',
    'B.Com',
  ];

  final List<String> years = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat(reverse: true);

    color1 = ColorTween(begin: Colors.pinkAccent, end: Colors.deepPurpleAccent)
        .animate(_controller);
    color2 =
        ColorTween(begin: Colors.orangeAccent, end: Colors.indigo).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 3),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "🎉 Student Details Submitted Successfully!",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Student Details'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color1.value!, color2.value!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Enter Your Details',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Name
                      _inputField('Full Name', 'Enter your full name', nameController),

                      // Roll No
                      _inputField('Roll No', 'Enter your roll number', rollNoController),

                      // Course Dropdown
                      _dropdownField(
                        label: 'Select Course',
                        hint: 'Choose your course',
                        value: selectedCourse,
                        items: courses,
                        onChanged: (val) {
                          setState(() => selectedCourse = val);
                        },
                      ),

                      // Year Dropdown
                      _dropdownField(
                        label: 'Select Year',
                        hint: 'Choose your year',
                        value: selectedYear,
                        items: years,
                        onChanged: (val) {
                          setState(() => selectedYear = val);
                        },
                      ),

                      // Email
                      _inputField('Email', 'Enter your email address', emailController,
                          keyboard: TextInputType.emailAddress),

                      // Phone
                      _inputField('Phone No', 'Enter your phone number', phoneController,
                          keyboard: TextInputType.phone),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (selectedCourse == null || selectedYear == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select course and year!"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            } else {
                              _showSuccessMessage();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 15),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _inputField(
      String label, String hint, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white60),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (v) => v!.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: DropdownButtonFormField<String>(
          value: value,
          dropdownColor: Colors.deepPurple.shade200,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          iconEnabledColor: Colors.white,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white60),
            labelStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item,
                        style: const TextStyle(color: Colors.white)),
                  ))
              .toList(),
          onChanged: onChanged,
          validator: (v) => v == null ? 'Please select $label' : null,
        ),
      ),
    );
  }
}
