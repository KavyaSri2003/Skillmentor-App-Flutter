
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class MentorDetailsPage extends StatelessWidget {
  final String mentorName;
  final String courseName;

  MentorDetailsPage({required this.mentorName, required this.courseName});

  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentEmailController = TextEditingController();
  final TextEditingController _studentMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentor Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mentor Name: $mentorName',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Course Name: $courseName',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _studentNameController,
              decoration: InputDecoration(labelText: 'Your Name'),
            ),
            TextField(
              controller: _studentEmailController,
              decoration: InputDecoration(labelText: 'Your Email'),
            ),
            TextField(
              controller: _studentMessageController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendMentorshipRequest(context, mentorName, courseName);
              },
              child: Text('Request Mentorship',style: TextStyle(color: Colors.black),),
            ),

          ],
        ),
      ),
    );
  }

  void _sendMentorshipRequest(BuildContext context, String mentorName,
      String courseName) {
    // Extract student details
    String studentName = _studentNameController.text.trim();
    String studentEmail = _studentEmailController.text.trim();
    String studentMessage = _studentMessageController.text.trim();

    // Check if student details are not empty
    if (studentName.isNotEmpty && studentEmail.isNotEmpty &&
        studentMessage.isNotEmpty) {
      // Query the courses collection to get the mentorId
      FirebaseFirestore.instance.collection('courses')
          .where('M_name', isEqualTo: mentorName)
          .where('C_name', isEqualTo: courseName)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          String mentorId = snapshot.docs.first['mentorId'];

          // Store the mentorship request in Firebase Firestore along with mentorId
          FirebaseFirestore.instance.collection('mentorship_requests').add({
            'mentor_id': mentorId,
            'mentor_name': mentorName,
            'student_name': studentName,
            'student_email': studentEmail,
            'student_message': studentMessage,
            'timestamp': FieldValue.serverTimestamp(),
          }).then((value) {
            // Show a confirmation dialog or snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Mentorship request sent successfully!'),
              ),
            );
          }).catchError((error) {
            print('Failed to send mentorship request: $error');
            // Handle the error gracefully
          });
        } else {
          // Show an error message if course not found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Course not found!'),
            ),
          );
        }
      }).catchError((error) {
        print('Error querying courses collection: $error');
        // Handle the error gracefully
      });
    } else {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all the fields.'),
        ),
      );
    }
  }
}