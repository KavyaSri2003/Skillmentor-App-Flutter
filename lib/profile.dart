import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_currentUser.photoURL ?? ''),
            ),
            SizedBox(height: 20),
            Text('Name: ${_currentUser.displayName ?? 'N/A'}'),
            Text('Email: ${_currentUser.email ?? 'N/A'}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to change password page
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
