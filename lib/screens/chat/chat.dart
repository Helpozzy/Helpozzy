import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpozzy/bloc/chat_bloc.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/models/message_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/full_screen_image_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  const Chat({required this.peerUser, required this.project});
  final ChatListItem peerUser;
  final ProjectModel project;
  @override
  _ChatState createState() => _ChatState(peerUser: peerUser, project: project);
}

class _ChatState extends State<Chat> {
  _ChatState({required this.peerUser, required this.project});
  final ChatListItem peerUser;
  final ProjectModel project;
  late double width;
  late double height;
  late ThemeData _theme;
  late String groupChatId = '';
  late File imageFile;
  late bool isLoading = false;
  late bool isLoadingPreviousMsg = false;
  late String imageUrl = '';
  int limit = 20;
  late SignUpAndUserModel userModel;

  final ImagePicker imagePicker = ImagePicker();
  final TextEditingController textEditingController = TextEditingController();
  late ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final ChatBloc _chatBloc = ChatBloc();

  @override
  void initState() {
    super.initState();
    getUserData();
    readLocal();
    removeBadge();
    listenUserData();
    _chatBloc.getChat(project.projectId!, groupChatId, limit);
  }

  Future listenUserData() async {
    final String? userDataString = prefsObject.getString(CURRENT_USER_DATA);
    if (userDataString != null && userDataString.isNotEmpty) {
      userModel = SignUpAndUserModel.fromJson(json: jsonDecode(userDataString));
    }
  }

  Future getUserData() async {
    prefsObject.setString(PEER_USRE_ID, peerUser.id);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(peerUser.id)
        .get()
        .then((value) async {
      setState(() {});
      await FirebaseFirestore.instance
          .collection('user_currently_active')
          .doc(project.projectId)
          .collection(userModel.userId!)
          .doc(peerUser.id)
          .set({'user_id': peerUser.id});
    });
  }

  Future removeBadge() async {
    await FirebaseFirestore.instance
        .collection('chat_list')
        .doc(project.projectId)
        .collection(prefsObject.getString(CURRENT_USER_ID)!)
        .doc(peerUser.id)
        .get()
        .then((data) async {
      if (data.data() != null) {
        await FirebaseFirestore.instance
            .collection('chat_list')
            .doc(project.projectId)
            .collection(prefsObject.getString(CURRENT_USER_ID)!)
            .doc(peerUser.id)
            .update({'badge': 0});
      }
    });
  }

  void _scrollListener() {
    if (listScrollController.position.pixels ==
        listScrollController.position.maxScrollExtent) {
      startLoader();
    }
  }

  Future<bool> removeActiveUser() async {
    prefsObject.remove(PEER_USRE_ID);
    await FirebaseFirestore.instance
        .collection('user_currently_active')
        .doc(project.projectId)
        .collection(userModel.userId!)
        .doc(peerUser.id)
        .delete();
    Navigator.pop(context, true);
    return false;
  }

  void startLoader() {
    setState(() {
      isLoadingPreviousMsg = true;
      fetchData();
    });
  }

  Future fetchData() async {
    final _duration = Duration(seconds: 2);
    return Timer(_duration, onResponse);
  }

  Future onResponse() async {
    setState(() {
      isLoadingPreviousMsg = false;
      limit = limit + 20;
    });
    await _chatBloc.getChat(project.projectId!, groupChatId, limit);
  }

  void readLocal() {
    if (prefsObject.getString(CURRENT_USER_ID).hashCode <=
        peerUser.id.hashCode) {
      groupChatId = '${prefsObject.getString(CURRENT_USER_ID)}-${peerUser.id}';
    } else {
      groupChatId = '${peerUser.id}-${prefsObject.getString(CURRENT_USER_ID)}';
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(prefsObject.getString(CURRENT_USER_ID))
        .update({'chattingWith': peerUser.id});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _theme = Theme.of(context);
    listScrollController = ScrollController()..addListener(_scrollListener);
    return WillPopScope(
      onWillPop: removeActiveUser,
      child: GestureDetector(
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: _key,
          appBar: appBar(),
          body: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      WHITE,
                      MATE_WHITE,
                      PRIMARY_COLOR.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  buildListMessage(),
                  buildInput(),
                ],
              ),
              isLoadingPreviousMsg
                  ? LinearProgressIndicator(color: PRIMARY_COLOR)
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() => AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: WHITE,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: DARK_PINK_COLOR),
          onPressed: () => removeActiveUser(),
        ),
        titleSpacing: 0.0,
        title: Row(
          children: <Widget>[
            CommonUserProfileOrPlaceholder(
              size: width * 0.08,
              imgUrl: peerUser.profileUrl,
            ),
            SizedBox(width: 5),
            Center(
              child: Text(
                peerUser.name,
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: DARK_PINK_COLOR,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(child: LinearLoader())
          : StreamBuilder<Chats>(
              stream: _chatBloc.getMessagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: LinearLoader());
                }
                final List<MessageModel> chat = snapshot.data!.messages;
                return chat.isNotEmpty
                    ? ListView.builder(
                        controller: listScrollController,
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        itemBuilder: (context, index) =>
                            buildItem(context, chat, index, chat[index]),
                        itemCount: chat.length,
                        reverse: true,
                      )
                    : Center(
                        child: Text(
                          'Start Conversation',
                          style: _theme.textTheme.headline6!
                              .copyWith(color: DARK_GRAY),
                        ),
                      );
              },
            ),
    );
  }

  Future chooseSourceOfPhoto(context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 72,
          color: GRAY,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _cameraPicker();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.photo_camera),
                  color: PRIMARY_COLOR,
                  iconSize: 32.0,
                ),
                IconButton(
                  onPressed: () {
                    _galleryPicker();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.photo_library),
                  color: PRIMARY_COLOR,
                  iconSize: 32.0,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future _cameraPicker() async {
    XFile? captureFile = await imagePicker.pickImage(
        imageQuality: 100,
        maxWidth: 800,
        maxHeight: 800,
        source: ImageSource.camera);

    final File? cameraImage = File(captureFile!.path);
    if (cameraImage != null) {
      setState(() => isLoading = true);
      await uploadFile(cameraImage);
    }
  }

  Future _galleryPicker() async {
    final XFile? pickedFile = await imagePicker.pickImage(
        imageQuality: 100,
        maxWidth: 800,
        maxHeight: 800,
        source: ImageSource.gallery);
    final File? galleryImage = File(pickedFile!.path);
    if (galleryImage != null) {
      setState(() => isLoading = true);
      await uploadFile(galleryImage);
    }
  }

  Future uploadFile(image) async {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final storageUploadTask = await FirebaseStorage.instance
        .ref()
        .child('chat_media')
        .child(fileName)
        .putFile(image);
    final String imageUrl = await storageUploadTask.ref.getDownloadURL();

    setState(() => isLoading = false);
    await onSendMessage(content: imageUrl, isImage: true, type: 1);
  }

  bool isLastMessageLeft(List<MessageModel> chat, int index) {
    if ((index > 0 &&
            chat.isNotEmpty &&
            chat[index - 1].idFrom == prefsObject.getString(CURRENT_USER_ID)) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(List<MessageModel> chat, int index) {
    if ((index > 0 &&
            chat.isNotEmpty &&
            chat[index - 1].idFrom != prefsObject.getString(CURRENT_USER_ID)) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  String contentMsg = '';

  Future onSendMessage({
    required String content,
    required bool isImage,
    required int type,
  }) async {
    if (content.trim() != '') {
      setState(() => contentMsg = textEditingController.text);
      textEditingController.clear();

      final documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(project.projectId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'id_from': prefsObject.getString(CURRENT_USER_ID),
            'id_to': peerUser.id,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type,
          },
        );
      }).then((onValue) async {
        await FirebaseFirestore.instance
            .collection('chat_list')
            .doc(project.projectId)
            .collection(prefsObject.getString(CURRENT_USER_ID)!)
            .doc(peerUser.id)
            .set({
          'user_id': peerUser.id,
          'name': peerUser.name,
          'email': peerUser.email,
          'type': type,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'badge': 0,
          'profile_image': peerUser.profileUrl,
        }).then((onValue) async {
          try {
            await FirebaseFirestore.instance
                .collection('chat_list')
                .doc(project.projectId)
                .collection(peerUser.id)
                .doc(prefsObject.getString(CURRENT_USER_ID))
                .get()
                .then((doc) async {
              final ChatListItem chatItem =
                  ChatListItem.fromJson(doc.data() as Map<String, dynamic>);
              await FirebaseFirestore.instance
                  .collection('chat_list')
                  .doc(project.projectId)
                  .collection(peerUser.id)
                  .doc(prefsObject.getString(CURRENT_USER_ID))
                  .set({
                'user_id': prefsObject.getString(CURRENT_USER_ID),
                'name': userModel.firstName! + ' ' + userModel.lastName!,
                'email': userModel.email,
                'type': type,
                'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                'content': content,
                'badge': chatItem.badge + 1,
                'profile_image': userModel.profileUrl,
              }).then((value) async {
                await FirebaseFirestore.instance
                    .collection('user_currently_active')
                    .doc(peerUser.id)
                    .collection(peerUser.id)
                    .where('user_id', isEqualTo: userModel.userId)
                    .get();
              });
            });
            await _chatBloc.getChat(project.projectId!, groupChatId, limit);
          } catch (e) {
            await FirebaseFirestore.instance
                .collection('chat_list')
                .doc(project.projectId)
                .collection(peerUser.id)
                .doc(prefsObject.getString(CURRENT_USER_ID))
                .set({
              'user_id': prefsObject.getString(CURRENT_USER_ID),
              'name': userModel.firstName! + ' ' + userModel.lastName!,
              'email': userModel.email,
              'type': type,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'badge': 1,
              'profile_image': userModel.profileUrl,
            }).then((value) async {
              await FirebaseFirestore.instance
                  .collection('user_currently_active')
                  .doc(peerUser.id)
                  .collection(peerUser.id)
                  .where('user_id', isEqualTo: userModel.userId)
                  .get();
            });
            await _chatBloc.getChat(project.projectId!, groupChatId, limit);
          }
        });
      });
    }
  }

  Widget buildItem(BuildContext context, List<MessageModel> chat, int index,
      MessageModel message) {
    if (message.idFrom == prefsObject.getString(CURRENT_USER_ID)) {
      // Sent Message (my message)
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              message.type == 0
                  // Text
                  ? GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(text: message.content));
                        ScaffoldSnakBar()
                            .show(context, msg: MESSAGE_COPIED_POPUP_MSG);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        decoration: BoxDecoration(
                          color: BLUE_GRAY,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: EdgeInsets.only(
                            bottom:
                                isLastMessageRight(chat, index) ? 10.0 : 10.0,
                            right: 24,
                            left: 24),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                          child: Text(
                            message.content,
                            style: _theme.textTheme.bodyText2!
                                .copyWith(color: WHITE),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      //photo message
                      margin:
                          EdgeInsets.only(bottom: 10.0, left: 24, right: 24),
                      child: InkWell(
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: Center(child: LinearLoader()),
                              width: MediaQuery.of(context).size.width - 100,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: PRIMARY_COLOR,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Icon(Icons.error_outline_rounded),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: message.content,
                            width: MediaQuery.of(context).size.width - 100,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FullScreenView(imgUrl: message.content),
                            ),
                          );
                        },
                      ),
                    ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          isLastMessageRight(chat, index)
              ? Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 28, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(CupertinoIcons.arrow_up_circle_fill,
                          size: 18, color: BLUE_GRAY),
                      SizedBox(width: 5),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          DateFormat('dd MMM hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(message.timestamp),
                            ),
                          ),
                          style: _theme.textTheme.bodyText2!.copyWith(
                            color: PRIMARY_COLOR,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox()
        ],
      );
    } else {
      // Left message (Peer message)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              message.type == 0
                  ? Container(
                      width: MediaQuery.of(context).size.width - 100,
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(chat, index) ? 10.0 : 10.0,
                          left: 24,
                          right: 24),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        child: Text(
                          message.content,
                          style: _theme.textTheme.bodyText2!
                              .copyWith(color: WHITE),
                        ),
                      ),
                    )
                  : Container(
                      margin:
                          EdgeInsets.only(left: 24, right: 24, bottom: 10.0),
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: Center(
                              child: LinearLoader(),
                            ),
                            width: MediaQuery.of(context).size.width - 100,
                            height: 200.0,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              color: GRAY,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Text('Chat not available'),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          imageUrl: message.content,
                          width: MediaQuery.of(context).size.width - 100,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
            ],
          ),
          // Time
          isLastMessageLeft(chat, index)
              ? Container(
                  padding: EdgeInsets.fromLTRB(28, 0, 0, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(CupertinoIcons.arrow_down_circle_fill,
                          size: 18, color: PRIMARY_COLOR),
                      SizedBox(width: 5),
                      Text(
                        DateFormat('dd MMM hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(message.timestamp),
                          ),
                        ),
                        style: TextStyle(
                          color: PRIMARY_COLOR,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox()
        ],
      );
    }
  }

  Widget buildInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: CommonRoundedTextfield(
              controller: textEditingController,
              textAlignCenter: false,
              borderEnable: false,
              textCapitalization: TextCapitalization.sentences,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.photo_fill_on_rectangle_fill,
                    color: PRIMARY_COLOR,
                  ),
                  onPressed: () => chooseSourceOfPhoto(context),
                ),
              ),
              suffixIcon: InkWell(
                child: Icon(
                  CupertinoIcons.play_circle_fill,
                  color: PRIMARY_COLOR,
                  size: width * 0.09,
                ),
                onTap: () async => onSendMessage(
                  content: textEditingController.text,
                  isImage: false,
                  type: 0,
                ),
              ),
              fillColor: GRAY,
              hintText: ENTER_MESSAGE_HINT,
              validator: (val) => null,
            ),
          ),
        ],
      ),
    );
  }
}
