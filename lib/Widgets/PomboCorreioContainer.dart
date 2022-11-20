import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/Constants.dart';

import '../Models/PomboCorreio.dart';
import '../Models/UserModel.dart';
import '../Services/DatabaseServices.dart';

class PomboCorreioContainer extends StatefulWidget {
  final PomboCorreio pomboCorreio;
  final UserModel author;
  final String currentUserId;

  const PomboCorreioContainer(
      {key,
      required this.pomboCorreio,
      required this.author,
      required this.currentUserId})
      : super(key: key);
  @override
  _PomboCorreioContainerState createState() => _PomboCorreioContainerState();
}

class _PomboCorreioContainerState extends State<PomboCorreioContainer> {
  int _likesCount = 0;
  bool _isLiked = false;

  initPomboCorreioLikes() async {
    bool isLiked = await DatabaseServices.isLikePomboCorreio(
        widget.currentUserId, widget.pomboCorreio);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likePomboCorreio() {
    if (_isLiked) {
      DatabaseServices.unlikePomboCorreio(
          widget.currentUserId, widget.pomboCorreio);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseServices.likePomboCorreio(
          widget.currentUserId, widget.pomboCorreio);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.pomboCorreio.likes;
    initPomboCorreioLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    Image.asset(widget.author.profilePicture).image,
              ),
              const SizedBox(width: 10),
              Text(
                widget.author.name,
                style: const TextStyle(
                  color: defaultDarkColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            widget.pomboCorreio.text,
            style: const TextStyle(
              color: defaultDarkColor,
              fontSize: 18,
            ),
          ),
          const SizedBox.shrink(),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.blueAccent : Colors.black,
                    ),
                    onPressed: likePomboCorreio,
                  ),
                  Text(
                    '$_likesCount Likes',
                  ),
                ],
              ),
              Text(
                widget.pomboCorreio.timestamp
                    .toDate()
                    .toString()
                    .substring(0, 19),
                style: const TextStyle(color: defaultGrayColor),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: tertiaryColor,
            thickness: 1,
          )
        ],
      ),
    );
  }
}
