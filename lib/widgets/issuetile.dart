import 'package:flutter/material.dart';

class IssueTile extends StatelessWidget {
  final String imageUrl; // URL for the image
  final String title;
  final String domain;
  final String status;
  final bool isResolved; // To control the status color
  final VoidCallback onExpandPressed; // Action for the button

  const IssueTile({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.domain,
    required this.status,
    required this.isResolved,
    required this.onExpandPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // The main card container
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        // Using the same theme as IconTextCard: same-color bg + shadow
        color: const Color.fromRGBO(255, 251, 230, 1.0),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // ClipRRect ensures the image inside also has rounded corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image
            Image.network(
              imageUrl,
              height: 160.0,
              width: double.infinity,
              fit: BoxFit.cover,
              // Show a loading spinner while the image loads
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 160.0,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(255, 90, 96, 1.0),
                    ),
                  ),
                );
              },
              // Show an error icon if the image fails to load
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 160.0,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                );
              },
            ),

            // 2. Details Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3. Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "AirbnbCereal",
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Domain: $domain',
                    style: TextStyle(
                      fontFamily: "AirbnbCereal",
                      fontSize: 14.0,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // 4. Status and Domain
                  // Row(
                  // children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: isResolved
                          ? Colors.green.shade700 // Green for Resolved
                          : const Color.fromRGBO(
                              255, 90, 96, 1.0), // Red for Unresolved
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 251, 230, 1.0),
                        fontSize: 12.0,
                        fontFamily: "AirbnbCereal",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Domain Text

                  // ],
                  // ),
                  // const SizedBox(height: 8.0),

                  // 5. Expand Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onExpandPressed,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadiusGeometry),
                        // The button's text/icon color
                        foregroundColor: const Color.fromRGBO(255, 90, 96, 1.0),
                        // Splash color
                        overlayColor: const Color.fromRGBO(255, 90, 96, 0.1),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Expand",
                            style: TextStyle(
                              fontFamily: "AirbnbCereal",
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 4.0),
                          // Icon(Icons.arrow_forward, size: 18.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
