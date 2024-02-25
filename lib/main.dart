import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'mentorDetail.dart';
import 'chat.dart';
import 'dart:async';

import 'package:video_player/video_player.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDUx_0m2JtmlUYIEPzm3JAaEtfaaU2VWqg",
      authDomain: "skill-4adfa.firebaseapp.com",
      projectId: "skill-4adfa",
      storageBucket: "skill-4adfa.appspot.com",
      messagingSenderId: "987806169472",
      appId: "1:987806169472:android:71d20bc1823890fd772965",
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mentor/Student Login',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,

        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.blue,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue[800],

        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          color: Colors.blue[800],
        ),
      ),
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/mentor_home': (context) => MentorHomePage(),
        '/student_home': (context) => StudentHomePage(),
        '/settings': (context) => SettingsPage(),
        '/profile': (context) => ProfilePage(),
        '/selection':(context) =>SelectionPage(),
      },
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5), // Animation duration
    );

    // Initialize animation
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    // Start the animation
    _controller.forward();

    // Navigate to the next screen after the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.blue[900],
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SkillMentor',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Unlock your potential\nwith the power of mentorship',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Role')),
      backgroundColor: Colors.white, // Set Scaffold background color
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black,
              Colors.blue[900]!, // Navy Blue
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedButton(
                  context, 'Login as Mentor', '/login', 'mentor'),
              _buildAnimatedButton(
                  context, 'Login as Student', '/login', 'student'),
              _buildAnimatedButton(context, 'Sign Up', '/signup', ''),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(BuildContext context, String text, String route,
      String argument) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (_, double value, __) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, route, arguments: argument);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // Button Color
                  onPrimary: Colors.blue[900], // Font Color
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20, // Increase font size
                    fontFamily: 'Pacifico', // Specify your custom font
                    fontWeight: FontWeight.bold, // Adjust font weight as needed
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? role = ModalRoute.of(context)?.settings.arguments as String?;
    role ??= '';

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black,
              Colors.blue[900]!, // Navy Blue
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login as $role',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: InputBorder.none,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _loginUser(context, role!);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // background color of button
                    onPrimary: Colors.black, // text color of button
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black, // text color of the button text
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    // Forgot password logic
                  },
                  child: Text('Forgot Password?',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _loginUser(BuildContext context, String role) async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential != null && userCredential.user != null) {
        // Determine user role based on email domain
        if (role == 'mentor' && !email.endsWith('@mentor.com')) {
          _showInvalidDomainPopup(context, role);
        } else if (role == 'student' && !email.endsWith('@student.com')) {
          _showInvalidDomainPopup(context, role);
        } else {
          // Navigate to respective user page
          if (role == 'mentor') {
            Navigator.pushReplacementNamed(context, '/mentor_home');
            _showSuccessPopup(context);
          } else if (role == 'student') {
            Navigator.pushReplacementNamed(context, '/student_home');
            _showSuccessPopup(context);
          }
        }
      }
    } catch (e) {
      print('Error logging in: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('An error occurred while logging in. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  void _showInvalidDomainPopup(BuildContext context, String role) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // Set background color to transparent
          title: Text('Invalid Domain', style: TextStyle(color: Colors.white)), // Set text color to white
          content: Text('Please use a valid $role email address.', style: TextStyle(color: Colors.white)), // Set text color to white
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.black)), // Set text color to white
            ),
          ],
        );
      },
    );
  }

  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set background color to transparent
          title: Text('Logged In Successfully', style: TextStyle(color: Colors.black)), // Set text color to white
          content: Text('You have been logged in successfully.', style: TextStyle(color: Colors.black)), // Set text color to white
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.black)), // Set text color to white
            ),
          ],
        );
      },
    );
  }


}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = 'Student';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Sign Up')),
    body: Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
    Colors.black,
    Colors.blue[900]!, // Navy Blue
    ],
    ),
    ),
      child: Center(

    child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedRole,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
              dropdownColor: Colors.blue[900], // Set the background color to dark blue
              style: TextStyle(color: Colors.white), // Set text color to white
              items: <String>['Student', 'Mentor'].map<
                  DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: TextStyle(color: Colors.white),),
                );
              }).toList(),
            ),
            SizedBox(height: 10.0,),


            TextField(

              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            SizedBox(height: 10.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
        ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await _auth
                      .createUserWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );

                  print('User registered: ${userCredential.user!.email}');

                  // Call addStudent or addMentor after successful registration
                  if (_selectedRole == 'Student') {
                    addStudent(_nameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim());
                  } else if (_selectedRole == 'Mentor') {
                    addMentor(_nameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim());
                  }

                  // Navigate to login with the selected role
                  Navigator.pushNamed(context, '/login',
                      arguments: _selectedRole.toLowerCase());
                } catch (e) {
                  print('Error signing up: $e');
                }
              },
              child: Text('Sign Up',style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    ),
    );


  }
}


  void addStudent(String name, String email, String password) {
    FirebaseFirestore.instance.collection('students').add({
      'S_name': name,
      'S_email': email,
      'S_password': password,
    }).then((value) {
      print('Student added successfully');
    }).catchError((error) {
      print('Failed to add student: $error');
    });
  }

  void addMentor(String name, String email, String password) {
    FirebaseFirestore.instance.collection('mentors').add({
      'M_name': name,
      'M_email': email,
      'M_password': password,
    }).then((value) {
      print('Mentor added successfully');
    }).catchError((error) {
      print('Failed to add mentor: $error');
    });
  }


class MentorHomePage extends StatefulWidget {
  final String mentorName; // Change from mentorId to mentorName

  MentorHomePage({this.mentorName = ''});

  @override
  _MentorHomePageState createState() => _MentorHomePageState();
}

class _MentorHomePageState extends State<MentorHomePage> {
  final String mentorId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentor Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black,
                    Colors.blue[900]!, // Navy Blue
                  ],
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              title: Text('Help'),
              onTap: () {
                // Add navigation logic for Help
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.blue[900]!, // Navy Blue
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Empowering minds, inspiring hearts, shaping futures',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,color: Colors.white,backgroundColor:Colors.black54, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _buildSectionTitle('Your Courses'),
            Expanded(
              child: MentorCourseList(mentorId: mentorId),
            ),
            _buildSectionTitle('Requests'),
            Expanded(
              child: MentorshipRequestList(mentorId: mentorId),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCourseDialog(context, mentorId);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(

      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white ),
      ),
    );
  }

  void _addCourseDialog(BuildContext context, String mentorId) {
    TextEditingController _courseController = TextEditingController();
    TextEditingController _yourNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _courseController,
                decoration: InputDecoration(labelText: 'Course Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _yourNameController,
                decoration: InputDecoration(labelText: 'Your Name'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style:TextStyle(color: Colors.black) ,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save',style:TextStyle(color: Colors.black)),
              onPressed: () {
                String courseName = _courseController.text.trim();
                String yourName = _yourNameController.text.trim();
                if (courseName.isNotEmpty && yourName.isNotEmpty) {
                  _saveCourse(mentorId, courseName, yourName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _saveCourse(String mentorId, String courseName, String yourName) {
    FirebaseFirestore.instance.collection('courses').add({
      'mentorId': mentorId,
      'C_name': courseName,
      'M_name': yourName,
    }).then((value) {
      print('Course added successfully');
    }).catchError((error) {
      print('Failed to add course: $error');
    });
  }
}

class MentorshipRequestList extends StatelessWidget {
  final String mentorId;

  MentorshipRequestList({required this.mentorId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mentorship_requests')
          .where('mentor_id', isEqualTo: mentorId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No mentorship requests available.',style: TextStyle(color: Colors.white),));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var request = snapshot.data!.docs[index];
            final studentName = request['student_name'];
            final studentEmail = request['student_email'];
            final studentMessage = request['student_message'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(
                    studentName != null ? studentName : 'Unknown Student',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: $studentEmail'),
                      Text('Message: $studentMessage'),
                    ],
                  ),
                  trailing: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            currentUserId: 'your_current_user_id',
                            currentUserName: 'your_current_user_name',
                            recipientId: 'recipient_user_id',
                            recipientName: 'recipient_user_name',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Chat',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}



class MentorCourseList extends StatelessWidget {
  final String mentorId;

  MentorCourseList({required this.mentorId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .where('mentorId', isEqualTo: mentorId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No courses available.'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var course = snapshot.data!.docs[index];
            final courseName = course['C_name'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),

                ),
                child: ListTile(
                  title: Text(
                    courseName != null ? courseName : 'Unknown Course',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // You can add more UI components here if needed
                ),
              ),
            );
          },
        );
      },
    );
  }
}



class CourseList extends StatelessWidget {
  final String searchQuery;

  CourseList({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('courses').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No courses available.'));
        }
        final List<DocumentSnapshot> filteredCourses = snapshot.data!.docs
            .where((course) => course['C_name'].toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        if (filteredCourses.isEmpty) {
          return Center(child: Text('No matching courses found.'));
        }

        return ListView.builder(
          itemCount: filteredCourses.length,
          itemBuilder: (context, index) {
            var course = filteredCourses[index];
            final courseName = course['C_name'];
            final mentorName = course['M_name'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    courseName != null ? courseName : 'Unknown Course',
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    mentorName != null ? mentorName : 'Unknown Mentor',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    _showCourseDetails(context, mentorName, courseName);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MentorDetailsPage(
                          mentorName: mentorName != null ? mentorName : 'Unknown Mentor',
                          courseName: courseName != null ? courseName : 'Unknown Course',
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );


      },
    );
  }
}
void _showCourseDetails(BuildContext context, String mentorName, String courseName) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Course: $courseName\nMentor: $mentorName'),
    ),
  );
}






class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  String _searchQuery = '';

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black,
                    Colors.blue[900]!, // Navy Blue
                  ],
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(
                    context, '/profile'); // Navigate to ProfilePage
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(
                    context, '/settings'); // Navigate to Settings page
              },
            ),
            ListTile(
              title: Text('Help'),
              onTap: () {
                // Add navigation logic for Help
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black,
              Colors.blue[900]!, // Navy Blue
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Learn Courses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: TextStyle(color: Colors.black), // Text color
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)), // Hint text color
                  prefixIcon: Icon(Icons.search, color: Colors.black), // Search icon color
                  filled: true,
                  fillColor: Colors.white, // Search bar background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: CourseList(searchQuery: _searchQuery),
            ),
          ],
        ),
      ),
    );
  }
}



class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    title: Text('Dark Mode'),
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      _toggleDarkMode(context, value);
                    },
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _logout(context);
                },
                child: Text('Logout',style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDarkMode(BuildContext context, bool isDarkModeEnabled) {
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(isDarkModeEnabled);
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/selection', (route) => false);
    } catch (e) {
      print('Error logging out: $e');
    }
  }

}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkModeEnabled) {
    _themeMode = isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_image.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Update profile logic
                },
                child: Text('Update Profile'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Change password logic
                },
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}