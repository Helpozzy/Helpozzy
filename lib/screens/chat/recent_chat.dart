import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/screens/chat/chat_all_users.dart';
import 'package:helpozzy/screens/chat/chat.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class RecentChatHistory extends StatefulWidget {
  @override
  _RecentChatHistoryState createState() => _RecentChatHistoryState();
}

class _RecentChatHistoryState extends State<RecentChatHistory> {
  late TextTheme _textTheme;
  late double width;
  late List<DocumentSnapshot> usersList = [];

  @override
  void initState() {
    getOpenChatUser();
    super.initState();
  }

  Future getOpenChatUser() async {
    final Query query = FirebaseFirestore.instance
        .collection('chat_list')
        .doc(prefsObject.getString(CURRENT_USER_ID)!)
        .collection(prefsObject.getString(CURRENT_USER_ID)!);
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
            builder: (context) => ChatAllUsers(),
          ),
        ),
        child: Icon(
          CupertinoIcons.chat_bubble_2,
          color: WHITE,
        ),
      ),
      body: usersList.isNotEmpty
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
                return Align(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    leading: CommonUserProfileOrPlaceholder(
                      size: width * 0.11,
                      imgUrl: chatListItem.profileUrl,
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
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(peerUser: chatListItem),
                        ),
                      );
                      await getOpenChatUser();
                    },
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
                  ),
                );
              },
            )
          : Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: width * 0.2),
              child: Text(
                'Start new conversation',
                style: _textTheme.headline6!.copyWith(color: DARK_GRAY),
              ),
            ),
    );
  }
}
