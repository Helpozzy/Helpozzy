import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/chat/chat.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ChatAllUsers extends StatefulWidget {
  @override
  _ChatAllUsersState createState() => _ChatAllUsersState();
}

class _ChatAllUsersState extends State<ChatAllUsers> {
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
      appBar: CommonAppBar(context).show(title: ALL_USERS_TITLE),
      body: SafeArea(
        child: usersList.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (context, int index) => CommonDivider(),
                shrinkWrap: true,
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> json =
                      usersList[index].data() as Map<String, dynamic>;
                  final SignUpAndUserModel user =
                      SignUpAndUserModel.fromJson(json: json);
                  final ChatListItem chatListItem = ChatListItem(
                    badge: '',
                    content: '',
                    email: user.email!,
                    id: user.userId!,
                    name: user.firstName! + ' ' + user.lastName!,
                    profileUrl: user.profileUrl!,
                    timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
                    type: 0,
                  );
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
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
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        user.email!,
                        style: _textTheme.bodyText2!.copyWith(color: DARK_GRAY),
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
                  'Volunteer not a0vailable',
                  style: _textTheme.headline6!.copyWith(color: ACCENT_GRAY),
                ),
              ),
      ),
    );
  }
}
