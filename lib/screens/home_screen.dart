import 'package:edu_lab/entities/course.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      context.go('/profile');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/discussion');
    }
  }

  var courseService = CourseService();

  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() async {
    var response = await courseService.getCourses();
    if (response.success) {
      setState(() {
        response.data.forEach((course) {
          courses.add(Course.fromJson(course));
        });
      });
    } else {
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EduLab',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Courses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    courses.length, // Replace with your dynamic course count
                itemBuilder: (context, index) {
                  var course = courses[index];
                  return Card(
                    child: ListTile(
                      title: Text(course.title?.getTranslation('kk') ?? ''),
                      subtitle: Text(
                        course.description?.getTranslation('kk') ?? '',
                      ),
                      onTap: () {
                        // Handle course tap
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'Discussion',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: Text('Join the discussion!'),
                  subtitle: Text('Click here to view or start discussions.'),
                  onTap: () {
                    // Navigate to discussion screen
                    Navigator.pushNamed(context, '/discussion');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Discussion'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
