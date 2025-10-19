import 'package:flutter/material.dart';

class IconTextCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final double width; // Make width a property for reusability

  const IconTextCard({
    Key? key,
    required this.icon,
    required this.text,
    this.width = 80.0, // Set a default width, you can override it
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Wrap with SizedBox to give the card a fixed width
    return SizedBox(
      width: width,
      height: 80.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        padding: const EdgeInsets.all(5.0), // Space inside the container
        decoration: BoxDecoration(
          // margin
          borderRadius: BorderRadius.circular(12.0), // Slightly rounded corners
          color: const Color.fromRGBO(255, 251, 230, 1.0),
          boxShadow: [
            BoxShadow(
              // color: Color.fromRGBO(255, 90, 96, 0.2), // Shadow color
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0, // How soft the shadow is
              offset: const Offset(0, 0.5), // How far the shadow extends
            ),
          ],
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min, // Makes the card wrap its content
          children: [
            Icon(icon,
                size: 35.0, // Adjust icon size as needed
                color: Colors.grey // Your theme foreground
                ),
            const SizedBox(height: 8), // Added space between icon and text
            Text(
              text,
              textAlign: TextAlign.center,
              // 2. Add these properties to handle long text
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey, // Your theme foreground
                fontSize: 12,
                fontFamily: 'AirbnbCereal', // Your theme font
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
