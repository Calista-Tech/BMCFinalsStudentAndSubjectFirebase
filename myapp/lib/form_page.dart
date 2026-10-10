import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

void main() async {

        WidgetsFlutterBinding.ensureInitialized();

        await Firebase.initializeApp(

            options: DefaultFirebaseOptions.currentPlatform,
        );

        runApp(const MyApp());

        }

        class MyApp extends StatelessWidget {
        const MyApp({super.key});

        @override
        Widget build(BuildContext context) {
            
            return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Subject Enrollment',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: Colors.grey[100],
            ),
            home: const EnrollmentPage(),
            );
        }
    }

        class EnrollmentPage extends StatefulWidget {
        const EnrollmentPage({super.key});

        @override
        State<EnrollmentPage> createState() => _EnrollmentPageState();
        }

        class _EnrollmentPageState extends State<EnrollmentPage> {
  
        int currentStep = 0;


        final nameController = TextEditingController();
        final sectionController = TextEditingController();
        final courseController = TextEditingController();

        final subject1Controller = TextEditingController();
        final time1Controller = TextEditingController();

        final subject2Controller = TextEditingController();
        final time2Controller = TextEditingController();

        final verifiedNameController = TextEditingController();
        final verifiedSectionController = TextEditingController();
        final verifiedCourseController = TextEditingController();

        final verifiedSubject1Controller = TextEditingController();
        final verifiedTime1Controller = TextEditingController();

        final verifiedSubject2Controller = TextEditingController();
        final verifiedTime2Controller = TextEditingController();

        bool isSaving = false;

        @override
        void dispose() {

            nameController.dispose();
            sectionController.dispose();
            courseController.dispose();

            subject1Controller.dispose();
            time1Controller.dispose();
            subject2Controller.dispose();
            time2Controller.dispose();

            verifiedNameController.dispose();
            verifiedSectionController.dispose();
            verifiedCourseController.dispose();

            verifiedSubject1Controller.dispose();
            verifiedTime1Controller.dispose();
            verifiedSubject2Controller.dispose();
            verifiedTime2Controller.dispose();

            super.dispose();
        }


        void nextStep() {

            if (currentStep == 0) {

            if (nameController.text.trim().isEmpty ||
                sectionController.text.trim().isEmpty ||
                courseController.text.trim().isEmpty) {
                showMessage('Please complete the registration form.');
                return;
            }

            setState(() {

                currentStep = 1;
            });

            } else if (currentStep == 1) {

            if (subject1Controller.text.trim().isEmpty ||
                time1Controller.text.trim().isEmpty ||
                subject2Controller.text.trim().isEmpty ||
                time2Controller.text.trim().isEmpty) {
                showMessage('Please complete the subject enrollment infomation.');
                return;
            }

      
            verifiedNameController.text = nameController.text;
            verifiedSectionController.text = sectionController.text;
            verifiedCourseController.text = courseController.text;

            
            verifiedSubject1Controller.text = subject1Controller.text;
            verifiedTime1Controller.text = time1Controller.text;

            verifiedSubject2Controller.text = subject2Controller.text;
            verifiedTime2Controller.text = time2Controller.text;

            setState(() {

                currentStep = 2;
            });
          }
        }


        Future<void> saveEnrollment() async {

            if (verifiedNameController.text.trim().isEmpty ||
                verifiedSectionController.text.trim().isEmpty ||
                verifiedCourseController.text.trim().isEmpty) {

            showMessage('Please complete the verification.');
            return;
            }

            setState(() {
                
            isSaving = true;
            });

            try {
            await FirebaseFirestore.instance.collection('enrollments').add({
                'name': verifiedNameController.text.trim(),
                'section': verifiedSectionController.text.trim(),
                'course': verifiedCourseController.text.trim(),

                'subjects': [

                {
                    'subject': verifiedSubject1Controller.text.trim(),
                    'time': verifiedTime1Controller.text.trim(),
                },

                {
                    'subject': verifiedSubject2Controller.text.trim(),
                    'time': verifiedTime2Controller.text.trim(),
                },
            ],

                'createdAt': FieldValue.serverTimestamp(),
            });

            if (!mounted) return;

            setState(() {

                isSaving = false;
            });

            showMessage(

                'Enrollment saved successfully!',
                color: Colors.green,
            );

            
            setState(() {

                currentStep = 0;
            });

            } catch (e) {

            if (!mounted) return;

            setState(() {

                isSaving = false;

            });

            showMessage(

                'Error saving enrollment: $e',
                color: Colors.red,
            );
          }
        }


        void showMessage(

            String message, {
            Color color = Colors.red,

        }) {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(message),
                backgroundColor: color,
            ),
          );
        }


        Widget inputField(

            String label,
            TextEditingController controller,
        ) {

            return Padding(

            padding: const EdgeInsets.only(bottom: 15),
            child: TextField(
                controller: controller,
                decoration: InputDecoration(
                labelText: label,
                border: const UnderlineInputBorder(),
                ),
            ),
            );
        }


        Widget stepTitle(String title) {
            
            return Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
                title,
                style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                ),
            ),
          );
        }


        Widget nextButton() {

            return Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
                onPressed: nextStep,
                style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                ),
                ),
                child: const Text(

                'Next',
                style: TextStyle(fontSize: 17),
                ),
            ),
          );
        }


        Widget userRegistration() {

            return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                stepTitle('User Registration'),

                inputField(

                'Name',
                nameController,
                ),

                inputField(

                'Section',
                sectionController,
                ),

                inputField(

                'Course',
                courseController,
                ),

                const SizedBox(height: 15),

                nextButton(),
            ],
          );
        }


        Widget subjectEnrollment() {

            return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                stepTitle('Subject Enrollment'),

                inputField(

                'Subject 1',
                subject1Controller,
                ),

                inputField(

                'Time',
                time1Controller,
                ),

                inputField(

                'Subject 2',
                subject2Controller,
                ),

                inputField(

                'Time',
                time2Controller,
                ),

                const SizedBox(height: 15),

                nextButton(),
            ],
          );
        }


        Widget subjectVerification() {

            return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                stepTitle('Subject Verification'),

                inputField(

                'Name',
                verifiedNameController,
                ),

                inputField(

                'Section',
                verifiedSectionController,
                ),

                inputField(

                'Course',
                verifiedCourseController,
                ),

                const SizedBox(height: 10),

                inputField(

                'Subject 1',
                verifiedSubject1Controller,
                ),

                inputField(

                'Time',
                verifiedTime1Controller,
                ),

                inputField(

                'Subject 2',
                verifiedSubject2Controller,
                ),

                inputField(

                'Time',
                verifiedTime2Controller,
                ),

                const SizedBox(height: 15),

                ElevatedButton(

                onPressed: isSaving ? null : saveEnrollment,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                    ),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                        ),
                        )
                    : const Text(
                        'Save',
                        style: TextStyle(fontSize: 17),
                        ),
                    ),
                ],
            );
        }


        @override
        Widget build(BuildContext context) {
            return Scaffold(
            appBar: AppBar(
                title: const Text('Subject Enrollment'),
                centerTitle: true,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
            ),

            body: SingleChildScrollView(
                padding: const EdgeInsets.all(25),

                child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(
                    maxWidth: 500,
                    ),

                    child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),

                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            spreadRadius: 2,
                        ),
                      ],
                    ),

                    child: currentStep == 0
                        ? userRegistration()
                        : currentStep == 1
                            ? subjectEnrollment()
                            : subjectVerification(),
                        ),
                    ),
                ),
            ),
        );
    }
}