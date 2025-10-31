import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:provider/provider.dart';

// Adjust the path as needed
import '../providers/issue_provider.dart';

class IssueDetailScreen extends StatelessWidget {
  /// The ID of the issue to display.
  /// This will be passed from the GoRouter route.
  final int issueId;

  const IssueDetailScreen({
    super.key,
    required this.issueId,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Get the provider
    final issueProvider = context.watch<IssuesProvider>();

    // 2. Find the issue by its ID
    // We use a try-catch block in case the issue isn't found
    Issue? issue;
    try {
      issue = issueProvider.issues.firstWhere((item) => item.id == issueId);
    } catch (e) {
      // Handle the case where the issue is not in the list
      // (e.g., deep link, or list updated)
      return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
        ),
        body: Center(
          child: Text(
            "Issue with ID $issueId not found.",
            style: const TextStyle(
              fontFamily: "AirbnbCereal",
              fontSize: 16.0,
            ),
          ),
        ),
      );
    }

    // 3. Helper function to copy the location link
    void _copyLocationToClipboard() {
      if (issue!.lat == null || issue.long == null) return;

      // Google Maps query URL
      final String mapUrl =
          "https://www.google.com/maps/search/?api=1&query=${issue.lat},${issue.long}";

      Clipboard.setData(ClipboardData(text: mapUrl)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Maps link copied to clipboard!'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
      // We use a SliverAppBar for a nice collapsing image effect
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color.fromRGBO(255, 90, 96, 1.0),
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(
              //   issue.domain,
              //   style: const TextStyle(
              //     fontFamily: "AirbnbCereal",
              //     fontWeight: FontWeight.w700,
              //     color: Colors.white,
              //   ),
              // ),
              background: issue.image_url != null && issue.image_url!.isNotEmpty
                  ? Image.network(
                      issue.image_url!,
                      fit: BoxFit.cover,
                      // Show a loading spinner while the image loads
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      },
                      // Show an error icon if the image fails to load
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade400,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    )
                  // Placeholder if no image is available
                  : Container(
                      color: Colors.grey.shade400,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
            ),
          ),

          // --- This Sliver holds all the other content ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Title ---
                  Text(
                    issue.title,
                    style: const TextStyle(
                      fontFamily: "AirbnbCereal",
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // --- Status and Domain Chips ---
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: issue.isresolved ?? false
                              ? Colors.green.shade700 // Green for Resolved
                              : const Color.fromRGBO(
                                  255, 90, 96, 1.0), // Red for Unresolved
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Text(
                          issue.isresolved ?? false ? "Resolved" : "Pending",
                          style: const TextStyle(
                            color: Color.fromRGBO(255, 251, 230, 1.0),
                            fontSize: 15.0,
                            fontFamily: "AirbnbCereal",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(
                              255, 90, 96, 1.0), // Red for Unresolved
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Text(
                          issue.domain,
                          style: const TextStyle(
                            color: Color.fromRGBO(255, 251, 230, 1.0),
                            fontSize: 15.0,
                            fontFamily: "AirbnbCereal",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // --- Description ---
                  Text(
                    issue.desc,
                    style: const TextStyle(
                      fontFamily: "AirbnbCereal",
                      fontSize: 16.0,
                      height: 1.5, // Line height for readability
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Divider(
                    color: Color.fromRGBO(255, 90, 96, 1.0),
                  ),
                  const SizedBox(height: 12.0),

                  // --- Other Details ---
                  _DetailRow(
                    icon: Icons.star,
                    title: "Critical Level",
                    value: "${issue.critical} / 5",
                  ),
                  _DetailRow(
                    icon: Icons.person_pin,
                    title: "Reported By",
                    value: issue.enr.toString(),
                  ),

                  // --- Location Button (conditionally shown) ---
                  Visibility(
                    visible: issue.lat != null && issue.long != null,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _copyLocationToClipboard,
                          // icon: const Icon(Icons.copy_all_outlined),
                          label: const Text("Copy Location Link"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                const Color.fromRGBO(255, 90, 96, 1.0),
                            side: const BorderSide(
                              color: Color.fromRGBO(255, 90, 96, 1.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// A helper widget to build consistent-looking detail rows
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.grey.shade700,
            size: 20,
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "AirbnbCereal",
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: "AirbnbCereal",
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
