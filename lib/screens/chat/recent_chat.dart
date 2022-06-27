import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/chat_bloc.dart';
import 'package:helpozzy/bloc/members_bloc.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/chat/chat.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class RecentChatHistory extends StatefulWidget {
  RecentChatHistory({required this.projectId});
  final String projectId;
  @override
  _RecentChatHistoryState createState() =>
      _RecentChatHistoryState(projectId: projectId);
}

class _RecentChatHistoryState extends State<RecentChatHistory> {
  _RecentChatHistoryState({required this.projectId});
  final String projectId;
  late TextTheme _textTheme;
  late double width;
  final ChatBloc _chatBloc = ChatBloc();
  final MembersBloc _membersBloc = MembersBloc();

  @override
  void initState() {
    _membersBloc.getProjectMembers(projectId);
    _chatBloc.getCurrentChatHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;
    width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        groupChatCard(),
        chatList(),
      ],
    );
  }

  Widget groupChatCard() {
    return StreamBuilder<List<SignUpAndUserModel>>(
      stream: _membersBloc.getProjectMembersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: LinearLoader(),
          );
        }
        final List<SignUpAndUserModel> volunteer = snapshot.data!;
        return SizedBox(
          width: width - (width * 0.05),
          child: InkWell(
            onTap: () async {},
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: <Widget>[
                          CommonUserProfileOrPlaceholder(
                            size: width * 0.10,
                            imgUrl: volunteer[0].profileUrl,
                            borderColor:
                                volunteer[0].presence! ? GREEN : PRIMARY_COLOR,
                          ),
                          Positioned(
                            left: 15.0,
                            child: CommonUserProfileOrPlaceholder(
                              size: width * 0.10,
                              imgUrl: volunteer[1].profileUrl,
                              borderColor: volunteer[1].presence!
                                  ? GREEN
                                  : PRIMARY_COLOR,
                            ),
                          ),
                          Positioned(
                            left: 30.0,
                            child: CommonUserProfileOrPlaceholder(
                              size: width * 0.10,
                              imgUrl: volunteer[2].profileUrl,
                              borderColor: volunteer[2].presence!
                                  ? GREEN
                                  : PRIMARY_COLOR,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Group Chat',
                        style: _textTheme.bodyText2!.copyWith(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget chatList() {
    return StreamBuilder<ChatList>(
      stream: _chatBloc.getChatListStream,
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
                        Text(
                          chatListItem.content.contains('firebasestorage')
                              ? 'Attachment'
                              : chatListItem.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: _textTheme.bodyText2!.copyWith(
                            color: DARK_GRAY,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(peerUser: chatListItem),
                        ),
                      );
                      await _chatBloc.getCurrentChatHistory();
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
              );
      },
    );
  }
}
