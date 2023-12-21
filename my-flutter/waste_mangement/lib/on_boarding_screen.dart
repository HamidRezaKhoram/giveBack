import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart'; // Replace with the path to your home screen file

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onBoardingComplete;

  OnboardingScreen({Key? key, required this.onBoardingComplete}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageController,
            itemCount: 3, // Number of pages
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: Text("Page $index"),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(3, (int index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 10,
                  width: (index == _currentPage) ? 30 : 10,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: (index == _currentPage) ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          )
        ],
      ),
         floatingActionButton: _currentPage == 2
          ? FloatingActionButton(
              onPressed: () {
                widget.onBoardingComplete(); // Call the passed callback function
              },
              child: const Icon(Icons.arrow_forward),
            )
          : Container(),
    );
  }
}
