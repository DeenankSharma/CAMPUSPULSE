import 'package:campus_pulse/providers/student_details_provider.dart';
// import 'package:campus_pulse/widgets/selection_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/issue_provider.dart';
import '../utils/issuecategories.dart';
// import '../utils/issuelist.dart';
import '../widgets/issuetile.dart';

class StudentHomescreen extends StatefulWidget {
  const StudentHomescreen({super.key});

  @override
  State<StudentHomescreen> createState() => _StudentHomescreenState();
}

class _StudentHomescreenState extends State<StudentHomescreen> {
  String? _selectedDomain;
  String? _selectedSort;

  // Helper map to make the sort button text look nice
  final Map<String, String> _sortLabels = {
    'criticality_high_low': 'Criticality (High-Low)',
    'criticality_low_high': 'Criticality (Low-High)',
  };
  @override
  void initState() {
    super.initState();
    // 3. Call your fetch function here
    // We use context.read (or listen: false) inside initState
    // to call the function without listening for changes here.
    Provider.of<IssuesProvider>(context, listen: false).fetchAllIssues();
  }

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
              onPressed: () => context.pushNamed('profile'),
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
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<IssuesProvider>().fetchAllIssues();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                height: 60.0, // Adjusted height for chips
                child: ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: issueCategories.length,
                  itemBuilder: (context, index) {
                    final category = issueCategories[index];
                    final String categoryText = category['text'] as String;
                    final bool isSelected = _selectedDomain == categoryText;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      // Use ChoiceChip for built-in selection state
                      child: ChoiceChip(
                        label: Text(
                          categoryText,
                          style: TextStyle(
                            fontFamily: "AirbnbCereal",
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        avatar: Icon(
                          category['icon'] as IconData,
                          size: 18.0,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                        selected: isSelected,
                        // This is the color when selected
                        selectedColor: Color.fromRGBO(255, 90, 96, 1.0),
                        // This is the color when not selected
                        backgroundColor: Color.fromRGBO(255, 251, 230, 1.0),
                        // Style the border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: isSelected
                                ? Color.fromRGBO(255, 90, 96, 1.0)
                                : Colors.grey.shade400,
                          ),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            // If selected, set the domain. If un-selected, set to null.
                            _selectedDomain = selected ? categoryText : null;
                          });
                        },
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
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      // ... (Your theme data is unchanged)
                      popupMenuTheme: PopupMenuThemeData(
                        color: Color.fromRGBO(255, 251, 230, 1.0),
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: PopupMenuButton<String>(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        overlayColor: Color.fromRGBO(255, 90, 96, 0.1),
                      ),
                      // --- This function now updates the state ---
                      onSelected: (String result) {
                        setState(() {
                          if (result == 'default') {
                            _selectedSort = null; // Clear the sort
                          } else {
                            _selectedSort = result;
                          }
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        // --- Added a "Default" option ---
                        const PopupMenuItem<String>(
                          value: 'default',
                          child: Text(
                            'Default',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "AirbnbCereal"),
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                          value: 'criticality_high_low',
                          child: Text(
                            'Criticality (High-Low)',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "AirbnbCereal"),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'criticality_low_high',
                          child: Text(
                            'Criticality (Low-High)',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "AirbnbCereal"),
                          ),
                        )
                      ],
                      // --- The button's child now reflects the state ---
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color.fromRGBO(255, 251, 230, 1.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              // Show "Sort By" or the selected sort label
                              _selectedSort == null
                                  ? "Sort By"
                                  : _sortLabels[_selectedSort!]!,
                              style: TextStyle(
                                fontFamily: "AirbnbCereal",
                                fontWeight: FontWeight.w500,
                                // Make text red if a sort is active
                                color: _selectedSort == null
                                    ? Colors.black
                                    : Color.fromRGBO(255, 90, 96, 1.0),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.filter_list,
                                color: _selectedSort == null
                                    ? Colors.black
                                    : Color.fromRGBO(255, 90, 96, 1.0),
                                size: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Consumer<IssuesProvider>(
                builder: (context, provider, child) {
                  List<Issue> filteredIssues = List.from(provider.issues);
                  if (_selectedDomain != null) {
                    filteredIssues = filteredIssues
                        .where((issue) => issue.domain == _selectedDomain)
                        .toList();
                  }
                  if (_selectedSort != null) {
                    if (_selectedSort == 'criticality_high_low') {
                      // Sort by critical level, high to low
                      filteredIssues
                          .sort((a, b) => b.critical.compareTo(a.critical));
                    } else if (_selectedSort == 'criticality_low_high') {
                      // Sort by critical level, low to high
                      filteredIssues
                          .sort((a, b) => a.critical.compareTo(b.critical));
                    }
                  }
                  // --- State 1: Loading ---
                  if (provider.isLoading && filteredIssues.isEmpty) {
                    // Show a spinner only on initial load
                    return Container(
                      padding: EdgeInsets.all(40.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // --- State 2: Error ---
                  if (provider.error != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Error: ${provider.error}\nPull down to try again.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  // --- State 3: Empty List ---
                  if (filteredIssues.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Text(
                          // Show a different message if filters are active
                          _selectedDomain == null
                              ? 'No issues have been reported yet. Be the first!'
                              : 'No issues found for $_selectedDomain.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "AirbnbCereal", fontSize: 16.0),
                        ),
                      ),
                    );
                  }

                  // --- State 4: Success, Show Data ---
                  return ListView.builder(
                    itemCount: filteredIssues.length, // Use provider data
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final issue =
                          filteredIssues[index]; // Get issue from provider

                      // Derive status since it's commented out in your model
                      final String status =
                          (issue.isresolved ?? false) ? 'Resolved' : 'Pending';

                      return IssueTile(
                        title: issue.title,
                        domain: issue.domain,
                        status: status, // Use the derived status
                        isResolved: issue.isresolved ?? false,
                        imageUrl: issue.image_url ??
                            '', // Handle null image URL gracefully
                        onExpandPressed: () {
                          print("Tapped on issue ${issue.id}");
                          context.pushNamed(
                            'issueDetail',
                            pathParameters: {'id': issue.id.toString()},
                          );
                          // Handle navigation to a detail screen
                        },
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('report'),
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
