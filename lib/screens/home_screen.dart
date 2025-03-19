import 'package:edu_lab/app_localizations.dart';
import 'package:edu_lab/components/bottom_navbar.dart';
import 'package:edu_lab/entities/course.dart';
import 'package:edu_lab/main.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:edu_lab/utils/language_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Locale _selectedLocale = Locale('kk', '');

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

  void _changeLanguage(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
    MyApp.setLocale(context, locale);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EduLab',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        actions: [
          LanguageDropdown(
            selectedLocale: _selectedLocale,
            onLocaleChange: _changeLanguage,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.translate('courses'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    courses.length, // Use the length of the loaded courses
                itemBuilder: (context, index) {
                  var course = courses[index];
                  var courseTitle =
                      course.title?.getTranslation(
                        _selectedLocale.languageCode,
                      ) ??
                      'No Title'; // Get the course title in Kazakh
                  var courseDescription =
                      course.description?.getTranslation(
                        _selectedLocale.languageCode,
                      ) ??
                      'No Description'; // Get the course description in Kazakh

                  // Truncate the description to the first 100 characters
                  if (courseDescription.length > 200) {
                    courseDescription =
                        '${courseDescription.substring(0, 200)}...';
                  }

                  var courseImage = course.imagePath;
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the course image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'http://localhost:9000/course/$courseImage',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            courseTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            courseDescription,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 15),
                          // Add the "Start Course" button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                localizations.translate('goToCourse'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
      bottomNavigationBar: BottomNavbar(locale: _selectedLocale.languageCode),
    );
  }
}
