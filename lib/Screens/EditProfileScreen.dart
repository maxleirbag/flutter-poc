import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sabia_app/Models/User.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String _name;
  late String _bio;
  late File _profileImage;
  late File? _coverImage;
  late String _imagePickedType;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  displayCoverImage() {
    if (_coverImage == null) {
      if (widget.user.coverImage.isNotEmpty) {
        return NetworkImage(widget.user.coverImage);
      } else {
        return FileImage(_coverImage!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
