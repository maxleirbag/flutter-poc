import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/ColorPalette.dart';
import 'package:sabia_app/Models/UserModel.dart';
import 'package:sabia_app/Services/DatabaseServices.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String _name = '';
  late String _bio = '';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  saveProfile() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }
    // consertar o Model de usuário para não usar mais imagens diferentes
    UserModel user = UserModel(
        id: widget.user.id,
        name: _name,
        bio: _bio,
        email: widget.user.email,
        profilePicture: widget.user.profilePicture,
        coverImage: widget.user.profilePicture);

    DatabaseServices.updateUserData(user);
    Navigator.pop(context);

    @override
    void initState() {
      super.initState();
      _name = widget.user.name;
      _bio = widget.user.bio;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            transform: Matrix4.translationValues(0, -40, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: saveProfile,
                      child: Container(
                        width: 100,
                        height: 300,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryColor,
                        ),
                        child: const Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 17,
                              color: defaultDarkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        TextFormField(
                          initialValue: _name,
                          decoration: InputDecoration(
                            labelText: _name,
                            labelStyle:
                                const TextStyle(color: defaultDarkColor),
                          ),
                          validator: (input) => input!.trim().length < 2
                              ? 'please enter valid name'
                              : null,
                          onSaved: (value) {
                            _name = value!.toString().toLowerCase();
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          initialValue: _bio,
                          decoration: const InputDecoration(
                            labelText: 'Bio',
                            labelStyle: TextStyle(color: defaultDarkColor),
                          ),
                          onSaved: (value) {
                            _bio = value!;
                          },
                        ),
                        const SizedBox(height: 30),
                        _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(primaryColor),
                              )
                            : const SizedBox.shrink()
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
