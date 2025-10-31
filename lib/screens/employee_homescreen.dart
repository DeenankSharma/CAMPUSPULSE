import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/employee_details_provider.dart';
import '../providers/issue_provider.dart';
import '../widgets/issuetile.dart'; // Make sure to import your Issue model

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  String? _selectedSort;

  // Helper map for sort labels (copied from your screen)
  final Map<String, String> _sortLabels = {
    'criticality_high_low': 'Criticality (High-Low)',
    'criticality_low_high': 'Criticality (Low-High)',
  };

  @override
  void initState() {
    super.initState();
    // Fetch all issues.
    // A more efficient API would be to fetch issues *by domain*
    // e.g., context.read<IssuesProvider>().fetchIssuesByDomain(domain);
    Provider.of<IssuesProvider>(context, listen: false).fetchAllIssues();
  }

  @override
  Widget build(BuildContext context) {
    // --- Get Employee Details ---
    final employeeAuth = context.watch<EmployeeAuthProvider>();
    final String employeeName = employeeAuth.name;
    final String employeeDomain = employeeAuth.domain;
    // ---

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
        actions: [
          IconButton(
              onPressed: () => context.pushNamed('empprofile'), // <-- New route
              icon: const Icon(Icons.person),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                overlayColor: const Color.fromRGBO(255, 90, 96, 0.1),
              ))
        ],
        title: Text(
          'Hi, $employeeName', // Use employee name
          style: const TextStyle(
              fontFamily: "AirbnbCereal", fontWeight: FontWeight.w900),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // You might want to have a separate fetch for employee issues
          await context.read<IssuesProvider>().fetchAllIssues();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // --- Title replacing filter chips ---
                    Text(
                      "Issues in: $employeeDomain",
                      style: const TextStyle(
                          fontFamily: "AirbnbCereal",
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700),
                    ),
                    // --- Sort Button (Unchanged) ---
                    Theme(
                      data: Theme.of(context).copyWith(
                        popupMenuTheme: PopupMenuThemeData(
                          color: const Color.fromRGBO(255, 251, 230, 1.0),
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
                          overlayColor: const Color.fromRGBO(255, 90, 96, 0.1),
                        ),
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
                                _selectedSort == null
                                    ? "Sort By"
                                    : _sortLabels[_selectedSort!]!,
                                style: TextStyle(
                                  fontFamily: "AirbnbCereal",
                                  fontWeight: FontWeight.w500,
                                  color: _selectedSort == null
                                      ? Colors.black
                                      : const Color.fromRGBO(255, 90, 96, 1.0),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.filter_list,
                                  color: _selectedSort == null
                                      ? Colors.black
                                      : const Color.fromRGBO(255, 90, 96, 1.0),
                                  size: 20.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // --- Issue List Consumer ---
              Consumer<IssuesProvider>(
                builder: (context, provider, child) {
                  // --- KEY CHANGE: Filter by employee's domain ---
                  List<Issue> filteredIssues = provider.issues
                      .where((issue) => issue.domain == employeeDomain)
                      .toList();

                  // Apply sorting
                  if (_selectedSort != null) {
                    if (_selectedSort == 'criticality_high_low') {
                      filteredIssues
                          .sort((a, b) => b.critical.compareTo(a.critical));
                    } else if (_selectedSort == 'criticality_low_high') {
                      filteredIssues
                          .sort((a, b) => a.critical.compareTo(b.critical));
                    }
                  }

                  // --- State 1: Loading ---
                  if (provider.isLoading && filteredIssues.isEmpty) {
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
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text(
                          'No issues found for your domain. All clear!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "AirbnbCereal", fontSize: 16.0),
                        ),
                      ),
                    );
                  }

                  // --- State 4: Success, Show Data ---
                  return ListView.builder(
                    itemCount: filteredIssues.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final issue = filteredIssues[index];
                      final String status =
                          (issue.isresolved ?? false) ? 'Resolved' : 'Pending';

                      return IssueTile(
                        title: issue.title,
                        domain: issue.domain,
                        status: status,
                        isResolved: issue.isresolved ?? false,
                        imageUrl: issue.image_url ?? '',
                        onExpandPressed: () {
                          context.pushNamed(
                            'issueDetail',
                            pathParameters: {'id': issue.id.toString()},
                          );
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
      // --- FAB REMOVED ---
      // floatingActionButton: FloatingActionButton.extended(...)
    );
  }
}
