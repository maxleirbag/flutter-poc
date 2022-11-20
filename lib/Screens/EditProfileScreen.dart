import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/ColorPalette.dart';
import 'package:sabia_app/Models/UserModel.dart';
import 'package:sabia_app/Services/DatabaseServices.dart';
import 'package:sabia_app/Widgets/RoundedButton.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _name = '';
  String _bio = '';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  saveProfile() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }
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
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Editar perfil',
          style: TextStyle(
              color: defaultDarkColor,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            transform: Matrix4.translationValues(0, 50, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        TextFormField(
                          initialValue: _name,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            labelStyle: TextStyle(color: defaultDarkColor),
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
                            labelText: 'Biografia',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: RoundedButton(
                        btnText: 'Salvar alterações',
                        onBtnPressed: () => saveProfile(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
