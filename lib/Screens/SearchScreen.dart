import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sabia_app/Models/UserModel.dart';
import 'package:sabia_app/Screens/ProfileScreen.dart';
import 'package:sabia_app/Services/DatabaseServices.dart';

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
      leading: const CircleAvatar(
        radius: 20,
        backgroundImage:
            NetworkImage('https://thispersondoesnotexist.com/image'),
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
    print(inputText);
    if (inputText.isNotEmpty) {
      setState(() {
        _users = DatabaseServices.searchUsers(inputText);
      });
    }
    // if (input.toString().isNotEmpty) print(input);
    // if (_isLiked) {
    //   DatabaseServices.unlikeZipZop(widget.currentUserId, widget.zipZop);
    //   setState(() {
    //     _isLiked = false;
    //     _likesCount--;
    //   });
    // } else {
    //   DatabaseServices.likeZipZop(widget.currentUserId, widget.zipZop);
    //   setState(() {
    //     _isLiked = true;
    //     _likesCount++;
    //   });
    // }
    print(_users);
    inputText = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  print('ok $inputText');
                  getMatchedUsers();
                  _searchController.clear();
                },
                icon: const Icon(Icons.search))
          ],
          centerTitle: true,
          elevation: 0.5,
          title: TextField(
            textInputAction: TextInputAction.search,
            controller: _searchController,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: _searchController.clear,
                  icon: const Icon(Icons.clear),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                hintText: inputText.isEmpty ? '(Nome de usuário)' : '',
                hintStyle: const TextStyle(color: Colors.white),
                border: InputBorder.none,
                filled: true),
            onChanged: (input) => inputText = input,
          ),
        ),
        body: _users == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 200),
                    Text(
                      'Buscar perfil do Sabiá App...',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              )
            // : Container(),
            : FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.documents.length == 0) {
                  return Center(
                    child: Text('Nenhum usuário encontrado com esse nome!'),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel user =
                          UserModel.fromDoc(snapshot.data.documents[index]);
                      return buildUserTile(user);
                    });
              }));
  }
}
