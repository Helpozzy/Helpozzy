import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/screens/user/chat/chat_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class AllUsersScreen extends StatefulWidget {
  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late TextTheme _textTheme;
  late double width;
  late List<DocumentSnapshot> usersList = [];
  late String currentUserId;

  @override
  void initState() {
    currentUserId = prefsObject.getString('uID')!;
    getOpenChatUser();
    super.initState();
  }

  Future getOpenChatUser() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user_id', isNotEqualTo: currentUserId)
        .get();
    usersList = querySnapshot.docs;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(elevation: 0, title: ALL_USERS_TITLE),
      body: SafeArea(
        child: usersList.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (context, int index) => Divider(
                  thickness: 0.0,
                  height: 1,
                  color: GRAY,
                ),
                shrinkWrap: true,
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> json =
                      usersList[index].data() as Map<String, dynamic>;
                  final ChatListItem chatListItem = ChatListItem.fromJson(json);
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: chatListItem.profileUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: chatListItem.profileUrl,
                                fit: BoxFit.cover,
                                height: 45,
                                width: 45,
                                alignment: Alignment.center,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                    color: PRIMARY_COLOR,
                                    strokeWidth: 1.5,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  radius: 24,
                                  child: Image.asset(
                                      'assets/images/user_placeholder.png'),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(
                                  'assets/images/user_placeholder.png'),
                            ),
                      title: Text(
                        chatListItem.name,
                        style: _textTheme.bodyText2!.copyWith(
                          fontSize: 16,
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chat(peerUser: chatListItem),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'Persons not Available',
                  style: _textTheme.headline6!.copyWith(color: ACCENT_GRAY),
                ),
              ),
      ),
    );
  }
}
