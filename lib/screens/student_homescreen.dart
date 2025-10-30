import 'package:campus_pulse/providers/student_details_provider.dart';
import 'package:campus_pulse/widgets/selection_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/issuecategories.dart';
import '../utils/issuelist.dart';
import '../widgets/issuetile.dart';

class StudentHomescreen extends StatelessWidget {
  const StudentHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    String name = context.watch<LoginDetailsProvider>().name.toString();
    // Get the full screen height
    final double fullScreenHeight = screenSize.height;
    final double fullScreenWidth = screenSize.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 251, 230, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 251, 230, 1.0),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.person),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                overlayColor: Color.fromRGBO(255, 90, 96, 0.1),
              ))
        ],
        title: Text(
          'Hi, $name',
          style: TextStyle(
              fontFamily: "AirbnbCereal", fontWeight: FontWeight.w900),
        ),
      ),
      body: SingleChildScrollView(
        // width: fullScreenWidth,
        // height: fullScreenHeight,
        // decoration: BoxDecoration(
        //   color: Color.fromRGBO(255, 251, 230, 1.0),
        // ),
        child: Column(
          children: [
            // IconTextCard(
            //   icon: Icons.school, // Prop for icon
            //   text: "Academics", // Prop for text
            // ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
              child: Text(
                "Search issues related to",
                style: TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),
              ),
              alignment: Alignment.topLeft,
            ),
            SizedBox(
              height: 90.0, // Give the list a fixed height
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                scrollDirection: Axis.horizontal,
                // Set itemCount to the length of your data list
                itemCount: issueCategories.length,
                itemBuilder: (context, index) {
                  // Get the current item's data
                  final category = issueCategories[index];

                  // Add padding so the cards aren't touching
                  // Use EdgeInsets.only for better spacing on the first and last items
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    // padding: EdgeInsets.only(
                    //   left: index == 0
                    //       ? 16.0
                    //       : 8.0, // More padding for the first item
                    //   right: index == issueCategories.length - 1
                    //       ? 16.0
                    //       : 8.0, // More for the last
                    //   top: 8.0,
                    //   bottom: 8.0,
                    // ),
                    child: IconTextCard(
                      // Use the data from the list
                      icon: category['icon'] as IconData,
                      text: category['text'] as String,
                    ),
                  );
                },
              ),
            ),
            // const SizedBox(
            //   height: 5.0,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                alignment: Alignment.topRight,
                // This widget handles the pop-up menu UI
                child: Theme(
                  data: Theme.of(context).copyWith(
                    popupMenuTheme: PopupMenuThemeData(
                      color: Color.fromRGBO(
                          255, 251, 230, 1.0), // Your theme bg color
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Adjust radius here
                      ), // You can keep the shadow
                    ),
                  ),
                  child: PopupMenuButton<String>(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      // --- ADD THIS ---
                      // This sets the splash color
                      overlayColor: Color.fromRGBO(255, 90, 96, 0.1), //
                    ),
                    onSelected: (String result) {
                      // No logic here, as requested
                    },
                    // This builds the list of menu items
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'criticality_high_low',
                        child: Text(
                          'Criticality level (high to low)',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "AirbnbCereal"),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'criticality_low_high',
                        child: Text(
                          'Criticality level (low to high)',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "AirbnbCereal"),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'newest_first',
                        child: Text(
                          'Newest first',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "AirbnbCereal"),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'oldest_first',
                        child: Text(
                          'Oldest first',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "AirbnbCereal"),
                        ),
                      ),
                    ],
                    // This is the child that is tapped (styled as a button)
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        // border: Border.all(
                        //     color: Colors.grey.shade400), // The outline
                        // Set background to your theme color
                        color: const Color.fromRGBO(255, 251, 230, 1.0),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Keep the row compact
                        children: [
                          Text(
                            "Sort By",
                            style: TextStyle(
                                fontFamily: "AirbnbCereal",
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          SizedBox(width: 4),
                          // Add an icon to show it's a dropdown
                          // Icon(Icons.filter_list,
                          //     color: Colors.black, size: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListView.builder(
              itemCount: mockIssues.length,
              shrinkWrap:
                  true, // Important: Tells ListView to be size of its children
              physics:
                  NeverScrollableScrollPhysics(), // Disables ListView's own scroll
              itemBuilder: (context, index) {
                final issue = mockIssues[index];
                return IssueTile(
                  title: issue['title'] as String,
                  domain: issue['domain'] as String,
                  status: issue['status'] as String,
                  isResolved: issue['isResolved'] as bool,
                  imageUrl: issue['imageUrl'] as String,
                  onExpandPressed: () {
                    print("Tapped on issue ${issue['id']}");
                    // Handle navigation to a detail screen
                  },
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},

        // Use the 'label' and 'icon' properties
        label: Text(
          "Report Issue",
          style: TextStyle(
              fontFamily: "AirbnbCereal", fontWeight: FontWeight.w500),
        ),
        icon: Icon(Icons.add),

        // Your styles
        foregroundColor: Color.fromRGBO(255, 251, 230, 1.0),
        backgroundColor: Color.fromRGBO(255, 90, 96, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(100.0), // This will give it the pill shape
        ),
      ),
    );
  }
}
