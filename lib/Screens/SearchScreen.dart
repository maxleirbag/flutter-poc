import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sabia_app/Models/UserModel.dart';
import 'package:sabia_app/Screens/ProfileScreen.dart';
import 'package:sabia_app/Services/DatabaseServices.dart';

import '../Constants/ColorPalette.dart';

class SearchScreen extends StatefulWidget {
  final String currentUserId;

  const SearchScreen({super.key, required this.currentUserId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String inputText = '';
  Future<QuerySnapshot>? _users;
  final TextEditingController _searchController = TextEditingController();

  buildUserTile(UserModel user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: Image.asset(user.profilePicture).image,
      ),
      title: Text(user.name),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileScreen(
                currentUserId: widget.currentUserId, visitedUserId: user.id)));
      },
    );
  }

  clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _searchController.clear();
      setState(() {
        _users = null;
      });
    });
  }

  getMatchedUsers() {
    if (inputText.isNotEmpty) {
      var values = DatabaseServices.getUsersByName(inputText);
      setState(() {
        _users = values;
        inputText = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
            color: defaultLightColor,
            onPressed: () {
              getMatchedUsers();
              _searchController.clear();
            },
            icon: const Icon(Icons.search)),
        centerTitle: true,
        elevation: 0.5,
        title: TextField(
          textInputAction: TextInputAction.search,
          controller: _searchController,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: _searchController.clear,
                icon: const Icon(
                  Icons.clear,
                  color: defaultLightColor,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              hintText: inputText.isEmpty ? '(Nome de usu??rio)' : '',
              hintStyle: const TextStyle(color: defaultLightColor),
              border: InputBorder.none,
              filled: true),
          onChanged: (input) => inputText = input,
        ),
      ),
      body: _users == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search, color: tertiaryColor, size: 200),
                  Text(
                    'Buscar perfil do Pombo App...',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: tertiaryColor),
                  )
                ],
              ),
            )
          : FutureBuilder(
              future: _users,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('N??o tem snapshot data'),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Nenhum usu??rio encontrado com esse nome!'),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel user =
                          UserModel.fromDoc(snapshot.data!.docs[index]);
                      return buildUserTile(user);
                    });
              }),
    );
  }
}
