import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/chat_bloc.dart';
import 'package:helpozzy/bloc/members_bloc.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/chat/chat.dart';
import 'package:helpozzy/screens/chat/group_chat.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class RecentChatHistory extends StatefulWidget {
  RecentChatHistory({required this.project});
  final ProjectModel project;
  @override
  _RecentChatHistoryState createState() =>
      _RecentChatHistoryState(project: project);
}

class _RecentChatHistoryState extends State<RecentChatHistory> {
  _RecentChatHistoryState({required this.project});
  final ProjectModel project;
  late TextTheme _textTheme;
  late double width;
  final ChatBloc _chatBloc = ChatBloc();
  final MembersBloc _membersBloc = MembersBloc();

  @override
  void initState() {
    _membersBloc.getProjectMembers(project.projectId!);
    _chatBloc.getCurrentChatHistory(project.projectId!);
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
        final List<SignUpAndUserModel> volunteers = snapshot.data!;
        return volunteers.isNotEmpty &&
                (volunteers.contains(project.ownerId) ||
                    volunteers.contains(prefsObject.getString(CURRENT_USER_ID)))
            ? SizedBox(
                width: width - (width * 0.05),
                child: InkWell(
                  onTap: () async => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => GroupChat(
                        volunteers: volunteers,
                        project: project,
                      ),
                    ),
                  ),
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
                                  imgUrl: volunteers[0].profileUrl,
                                  borderColor: volunteers[0].presence!
                                      ? GREEN
                                      : PRIMARY_COLOR,
                                ),
                                Positioned(
                                  left: 15.0,
                                  child: CommonUserProfileOrPlaceholder(
                                    size: width * 0.10,
                                    imgUrl: volunteers[1].profileUrl,
                                    borderColor: volunteers[1].presence!
                                        ? GREEN
                                        : PRIMARY_COLOR,
                                  ),
                                ),
                                Positioned(
                                  left: 30.0,
                                  child: CommonUserProfileOrPlaceholder(
                                    size: width * 0.10,
                                    imgUrl: volunteers[2].profileUrl,
                                    borderColor: volunteers[2].presence!
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
                              GROUP_CHAT_TITLE,
                              style:
                                  _textTheme.bodyText2!.copyWith(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox();
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
                              ? 'Image'
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
                        CupertinoPageRoute(
                          builder: (context) => Chat(
                            peerUser: chatListItem,
                            project: project,
                          ),
                        ),
                      );
                      await _chatBloc.getCurrentChatHistory(project.projectId!);
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
                        chatListItem.badge != 0
                            ? SizedBox(height: 6)
                            : SizedBox(),
                        chatListItem.badge != 0
                            ? Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: PRIMARY_COLOR,
                                ),
                                child: Center(
                                  child: Text(
                                    chatListItem.badge == 0
                                        ? ''
                                        : chatListItem.badge.toString(),
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
                  START_NEW_CONVERSATION,
                  style: _textTheme.headline6!.copyWith(color: DARK_GRAY),
                ),
              );
      },
    );
  }
}
