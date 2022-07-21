import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/chat_bloc.dart';
import 'package:helpozzy/bloc/members_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/chat/project_chat.dart';
import 'package:helpozzy/screens/chat/group_chat.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

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
  late double height;
  final ChatBloc _chatBloc = ChatBloc();
  final MembersBloc _membersBloc = MembersBloc();
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();

  @override
  void initState() {
    _membersBloc.getProjectMembers(project.projectId!);
    _chatBloc.getProjectChatHistory(project.projectId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        CommonDivider(),
        groupChatCard(),
        CommonDivider(),
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
        return volunteers.isNotEmpty
            ? ListTile(
                tileColor: BLACK.withOpacity(0.05),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: width * 0.04),
                onTap: () async => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => GroupChat(
                      volunteers: volunteers,
                      project: project,
                    ),
                  ),
                ),
                leading: CommonUserProfileOrPlaceholder(
                  size: width * 0.11,
                  borderColor: PRIMARY_COLOR,
                ),
                title: Text(
                  project.projectName!,
                  style: _textTheme.bodyText2!.copyWith(
                    fontSize: 16,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: Icon(
                  CupertinoIcons.person_2,
                  color: DARK_PINK_COLOR,
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
                        fontSize: 14,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                      ),
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
                          builder: (context) => ProjectChat(
                            peerUser: chatListItem,
                            project: project,
                          ),
                        ),
                      );
                      await _chatBloc.getProjectChatHistory(project.projectId!);
                    },
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dateFormatFromTimeStamp
                              .lastSeenFromTimeStamp(chatListItem.timestamp),
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
                            ? Badge(
                                counter: chatListItem.badge.toString(),
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
