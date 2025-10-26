// THIS FILE IS OBSOLETE
// Club selection is now handled by backend CRM sync

import 'package:flutter/material.dart';

class LinkClubPage extends StatelessWidget {
  const LinkClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.info_outline, size: 64),
            SizedBox(height: 16),
            Text(
              'This page is obsolete',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Club selection handled by backend'),
          ],
        ),
      ),
    );
  }
}
