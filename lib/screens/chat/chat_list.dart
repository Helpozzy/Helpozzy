import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/chat_bloc.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/screens/chat/one_to_one_chat.dart';
import 'package:helpozzy/screens/dashboard/members/members.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _RecentChatHistoryState createState() => _RecentChatHistoryState();
}

class _RecentChatHistoryState extends State<ChatListScreen> {
  late TextTheme _textTheme;
  late double width;
  late double height;
  final ChatBloc _chatBloc = ChatBloc();

  @override
  void initState() {
    _chatBloc.getOneToOneChatHistory(prefsObject.getString(CURRENT_USER_ID)!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: Transform.scale(
        scale: 0.8,
        child: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: PRIMARY_COLOR,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => MembersScreen(fromChat: true),
              ),
            );
          },
          label: Text(
            CHAT_TITLE,
            style: _textTheme.bodyText2!.copyWith(color: WHITE, fontSize: 16),
          ),
          icon: Icon(
            CupertinoIcons.person_add,
            color: WHITE,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.05,
                right: width * 0.05,
                top: 10.0,
                bottom: 3.0,
              ),
              child: SmallInfoLabel(label: CHAT_TITLE),
            ),
            chatList(),
          ],
        ),
      ),
    );
  }

  Widget chatList() {
    return StreamBuilder<ChatList>(
      stream: _chatBloc.getOneToOneChatListStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        final List<ChatListItem> chatList = snapshot.data!.chats;
        return chatList.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (context, int index) => Divider(
                  thickness: 0.0,
                  height: 1,
                  color: GRAY,
                ),
                shrinkWrap: true,
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  final ChatListItem chatListItem = chatList[index];
                  return ListTile(
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
                    subtitle: Row(
                      children: [
                        chatListItem.content.contains('firebasestorage')
                            ? Icon(
                                CupertinoIcons.paperclip,
                                size: 14,
                              )
                            : SizedBox(),
                        chatListItem.content.contains('firebasestorage')
                            ? SizedBox(width: 3)
                            : SizedBox(),
                        Expanded(
                          child: Text(
                            chatListItem.content.contains('firebasestorage')
                                ? 'Image'
                                : chatListItem.content,
                            overflow: TextOverflow.ellipsis,
                            style: _textTheme.bodyText2!.copyWith(
                              color: DARK_GRAY,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              OneToOneChat(peerUser: chatListItem),
                        ),
                      );
                      await _chatBloc.getOneToOneChatHistory(
                          prefsObject.getString(CURRENT_USER_ID)!);
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
                        chatListItem.badge != 0 &&
                                chatListItem.badge.toString().isNotEmpty
                            ? SizedBox(height: 6)
                            : SizedBox(),
                        chatListItem.badge != 0 &&
                                chatListItem.badge.toString().isNotEmpty
                            ? Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: PRIMARY_COLOR,
                                ),
                                child: Center(
                                  child: Text(
                                    chatListItem.badge.toString(),
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
                  );
                },
              )
            : Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: height / 7),
                child: Text(
                  START_NEW_CONVERSATION,
                  style: _textTheme.headline6!.copyWith(color: DARK_GRAY),
                ),
              );
      },
    );
  }
}
