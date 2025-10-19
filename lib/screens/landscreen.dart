// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    // Get the full screen height
    final double fullScreenHeight = screenSize.height;
    final double fullScreenWidth = screenSize.width;

    return Scaffold(
        // extendBody: true,

        body: Container(
      color: Color.fromRGBO(255, 251, 230, 1.0),
      height: fullScreenHeight,
      width: fullScreenWidth,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png"),
              Text(
                "CampusPulse",
                style: TextStyle(
                    fontSize: 36,
                    fontFamily: 'AirbnbCereal',
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Campus Issue Resolvent Platform",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'AirbnbCereal',
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: double
                    .infinity, // Makes the button fill the available width
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 90, 96, 1.0),
                    foregroundColor: Color.fromRGBO(255, 251, 230, 1.0),
                    shape: RoundedRectangleBorder(
                      // Add this
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the radius as needed
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Student/Faculty",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AirbnbCereal',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double
                    .infinity, // Makes the button fill the available width
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 90, 96, 1.0),
                    foregroundColor: Color.fromRGBO(255, 251, 230, 1.0),
                    shape: RoundedRectangleBorder(
                      // Add this
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the radius as needed
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Employee",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AirbnbCereal',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      // decoration: BoxDecoration(
      //     gradient: LinearGradient(colors: [
      //   Color.fromRGBO(255, 251, 230, 1.0),
      //   Color.fromRGBO(100, 16, 17, 1.0)
      // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
    ));
  }
}
