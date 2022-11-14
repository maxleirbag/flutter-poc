import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sabia_app/Models/User.dart';

import 'FeedScreen.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String _name;
  late String _bio;
  late File? _profileImage;
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

  displayProfielImage() {
    if (_profileImage == null) {
      if (widget.user.profilePicture.isNotEmpty) {
        return NetworkImage(widget.user.profilePicture);
      } else {
        return const AssetImage('assets/zip zop');
      }
    } else {
      return FileImage(_profileImage!);
    }
  }

  saveProfiel() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      String profilePictureUrl = '';
      String coverPictureUrl = '';
      if (_profileImage == null) {
        profilePictureUrl = widget.user.profilePicture;
      } else {
        // profilePictureUrl = await StorageService.uploadProfilePicture(widget.user.profilePicture, _profileImage);
      }
      if (_coverImage == null) {
        coverPictureUrl = widget.user.coverImage;
      } else {
        // coverPictureUrl = await StorageService.uploadCoverPicture(widget.user.coverImage, _coverImage);
      }

      User user = User(
          id: widget.user.id,
          name: _name,
          profilePicture: profilePictureUrl,
          bio: _bio,
          coverImage: coverPictureUrl,
          email: widget.user.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('tela de edição de perfil'),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FeedScreen(currentUserId: widget.user.id)));
            },
            child: const Icon(
              Icons.arrow_left,
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }
}
