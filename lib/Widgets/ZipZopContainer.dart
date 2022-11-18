import 'package:flutter/material.dart';
import '../Models/UserModel.dart';
import '../Models/ZipZop.dart';
import '../Services/DatabaseServices.dart';

class ZipZopContainer extends StatefulWidget {
  final ZipZop zipZop;
  final UserModel author;
  final String currentUserId;

  const ZipZopContainer(
      {key,
      required this.zipZop,
      required this.author,
      required this.currentUserId})
      : super(key: key);
  @override
  _ZipZopContainerState createState() => _ZipZopContainerState();
}

class _ZipZopContainerState extends State<ZipZopContainer> {
  int _likesCount = 0;
  bool _isLiked = false;

  initZipZopLikes() async {
    bool isLiked = await DatabaseServices.isLikeZipZop(
        widget.currentUserId, widget.zipZop);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likeZipZop() {
    if (_isLiked) {
      DatabaseServices.unlikeZipZop(widget.currentUserId, widget.zipZop);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseServices.likeZipZop(widget.currentUserId, widget.zipZop);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.zipZop.likes;
    initZipZopLikes();
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
              const CircleAvatar(
                radius: 20,
                backgroundImage:
                    NetworkImage('https://thispersondoesnotexist.com/image'),
              ),
              const SizedBox(width: 10),
              Text(
                widget.author.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            widget.zipZop.text,
            style: const TextStyle(
              fontSize: 15,
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
                      color: _isLiked ? Colors.blue : Colors.black,
                    ),
                    onPressed: likeZipZop,
                  ),
                  Text(
                    '$_likesCount Likes',
                  ),
                ],
              ),
              Text(
                widget.zipZop.timestamp.toDate().toString().substring(0, 19),
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider()
        ],
      ),
    );
  }
}
