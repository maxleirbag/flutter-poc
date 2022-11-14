import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String currentUserId;

  const SearchScreen({super.key, required this.currentUserId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Explorar'),
      ),
    );
  }
}
