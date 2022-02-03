import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/screens/chat/all_user.dart';
import 'package:helpozzy/screens/chat/chat_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late TextTheme _textTheme;
  late double width;
  late List<DocumentSnapshot> usersList = [];
  late String currentUserId;

  @override
  void initState() {
    currentUserId = prefsObject.getString(CURRENT_USER_ID)!;
    getOpenChatUser();
    super.initState();
  }

  Future getOpenChatUser() async {
    final Query query = FirebaseFirestore.instance
        .collection('chat_list')
        .doc(currentUserId)
        .collection(currentUserId);
    final QuerySnapshot querySnapshot =
        await query.orderBy('timestamp', descending: true).get();
    usersList = querySnapshot.docs;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllUsersScreen(),
          ),
        ),
        child: Icon(
          CupertinoIcons.chat_bubble_2,
          color: WHITE,
        ),
      ),
      body: SafeArea(
        child: usersList.isNotEmpty
            ? Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: width * 0.05),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      CHAT_TITLE,
                      textAlign: TextAlign.center,
                      style: _textTheme.headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.separated(
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
                      final ChatListItem chatListItem =
                          ChatListItem.fromJson(json);
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: ListTile(
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(chatListItem.timestamp),
                                  ),
                                ),
                                style: _textTheme.bodyText2!.copyWith(
                                  fontSize: 12,
                                  color: PRIMARY_COLOR,
                                ),
                              ),
                              chatListItem.badge.isNotEmpty &&
                                      chatListItem.badge != '0'
                                  ? SizedBox(height: 6)
                                  : SizedBox(),
                              chatListItem.badge.isNotEmpty &&
                                      chatListItem.badge != '0'
                                  ? Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: PRIMARY_COLOR,
                                      ),
                                      child: Center(
                                        child: Text(
                                          chatListItem.badge == '0'
                                              ? ''
                                              : chatListItem.badge,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: WHITE),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          leading: chatListItem.profileUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: chatListItem.profileUrl,
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.center,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
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
                                fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            chatListItem.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _textTheme.bodyText2,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Chat(peerUser: chatListItem),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              )
            : Center(
                child: Text(
                  'Start new conversation',
                  style: _textTheme.headline6!.copyWith(color: ACCENT_GRAY),
                ),
              ),
      ),
    );
  }
}
