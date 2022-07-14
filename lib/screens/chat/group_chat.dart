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
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/models/message_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/full_screen_image_view.dart';
import 'package:image_picker/image_picker.dart';

class GroupChat extends StatefulWidget {
  GroupChat({required this.volunteers, required this.project});
  final List<SignUpAndUserModel> volunteers;
  final ProjectModel project;
  @override
  _ChatState createState() =>
      _ChatState(volunteers: volunteers, project: project);
}

class _ChatState extends State<GroupChat> {
  _ChatState({required this.volunteers, required this.project});
  final List<SignUpAndUserModel> volunteers;
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

  final ImagePicker imagePicker = ImagePicker();
  final TextEditingController textEditingController = TextEditingController();
  late ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final ChatBloc _chatBloc = ChatBloc();
  late SignUpAndUserModel userModel;
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();

  @override
  void initState() {
    super.initState();
    groupChatId = project.projectId!;
    listScrollController = ScrollController()..addListener(_scrollListener);
    listenUserData();
    _chatBloc.getGroupChat(groupChatId, limit);
    removeBadge();
  }

  Future listenUserData() async {
    final String? userDataString = prefsObject.getString(CURRENT_USER_DATA);
    if (userDataString != null && userDataString.isNotEmpty) {
      userModel = SignUpAndUserModel.fromJson(json: jsonDecode(userDataString));
    }
  }

  Future removeBadge() async {
    await FirebaseFirestore.instance
        .collection('group_chat')
        .doc(project.projectId)
        .get()
        .then((data) async {
      if (data.data() != null) {
        await FirebaseFirestore.instance
            .collection('group_chat')
            .doc(project.projectId)
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

  Future startLoader() async {
    setState(() => isLoadingPreviousMsg = true);
    await fetchData();
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
    await _chatBloc.getGroupChat(groupChatId, limit);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _theme = Theme.of(context);
    return GestureDetector(
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _key,
        appBar: appBar(),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
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
    );
  }

  AppBar appBar() => AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: WHITE,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: DARK_PINK_COLOR),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0.0,
        title: Row(
          children: <Widget>[
            CommonUserProfileOrPlaceholder(
              size: width * 0.08,
              borderColor: PRIMARY_COLOR,
            ),
            SizedBox(width: 5),
            Text(
              project.projectName!,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.w600,
                color: DARK_PINK_COLOR,
                fontSize: 18,
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
              stream: _chatBloc.getGroupMessagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: LinearLoader());
                }
                final List<MessageModel> chat = snapshot.data!.messages;
                return chat.isNotEmpty
                    ? ListView.builder(
                        reverse: true,
                        controller: listScrollController,
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        itemBuilder: (context, index) =>
                            buildItem(context, chat[index]),
                        itemCount: chat.length,
                      )
                    : Center(
                        child: Text(
                          SART_CONVERSATION,
                          style: _theme.textTheme.headline6!
                              .copyWith(color: DARK_GRAY),
                        ),
                      );
              },
            ),
    );
  }

  Widget buildItem(BuildContext context, MessageModel message) {
    return Row(
      mainAxisAlignment:
          message.idFrom == prefsObject.getString(CURRENT_USER_ID)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onLongPress: () {
            if (message.type == 0) {
              Clipboard.setData(ClipboardData(text: message.content));
              ScaffoldSnakBar().show(context, msg: MESSAGE_COPIED_POPUP_MSG);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: message.idFrom == prefsObject.getString(CURRENT_USER_ID)
                  ? DARK_PINK_COLOR.withOpacity(0.3)
                  : DARK_BLUE.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: EdgeInsets.only(bottom: 10.0, right: 18, left: 18),
            child: Column(
              crossAxisAlignment:
                  message.idFrom == prefsObject.getString(CURRENT_USER_ID)
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.start,
              children: [
                message.idFrom != prefsObject.getString(CURRENT_USER_ID)
                    ? Text(
                        message.userName!,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          color: DARK_PINK_COLOR,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : SizedBox(),
                message.idFrom != prefsObject.getString(CURRENT_USER_ID)
                    ? SizedBox(height: 3)
                    : SizedBox(),
                message.type == 0
                    ? SizedBox(
                        width: message.content.length > 40 ? width - 100 : null,
                        child: Text(
                          message.content,
                          style: _theme.textTheme.bodyText2!
                              .copyWith(color: BLACK),
                        ),
                      )
                    : imageContent(message.content),
                SizedBox(height: 3),
                Align(
                  alignment:
                      message.idFrom == prefsObject.getString(CURRENT_USER_ID)
                          ? Alignment.bottomRight
                          : Alignment.bottomLeft,
                  child: timeStamp(message),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Text timeStamp(MessageModel message) {
    return Text(
      _dateFormatFromTimeStamp.lastSeenFromTimeStamp(message.timestamp),
      style: _theme.textTheme.bodyText2!.copyWith(
        color: DARK_GRAY,
        fontSize: 9.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget imageContent(String image) => InkWell(
        child: ClipRRect(
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              child: Center(child: LinearLoader()),
              width: MediaQuery.of(context).size.width / 2,
              padding: EdgeInsets.all(70.0),
              decoration: BoxDecoration(
                color: BLACK.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            errorWidget: (context, url, error) => Material(
              child: Icon(Icons.error_outline_rounded),
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
              clipBehavior: Clip.hardEdge,
            ),
            imageUrl: image,
            width: MediaQuery.of(context).size.width / 2,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenView(imgUrl: image),
            ),
          );
        },
      );

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
                  onPressed: () => imageOptionPopup(),
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

  Future imageOptionPopup() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(SELECT_OPTION),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              CAMERA_OPTION,
              style: _theme.textTheme.bodyText2!.copyWith(color: PRIMARY_COLOR),
            ),
            isDefaultAction: true,
            onPressed: () async {
              _cameraPicker();
              Navigator.of(context).pop();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              GALLERY_OPTION,
              style: _theme.textTheme.bodyText2!.copyWith(color: PRIMARY_COLOR),
            ),
            isDestructiveAction: true,
            onPressed: () async {
              _galleryPicker();
              Navigator.of(context).pop();
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            CANCEL_BUTTON,
            style: _theme.textTheme.bodyText2!.copyWith(color: PRIMARY_COLOR),
          ),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
      uploadFile(cameraImage);
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
      uploadFile(galleryImage);
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

    setState(() {
      isLoading = false;
      onSendMessage(content: imageUrl, isImage: true, type: 1);
    });
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
          .collection('group_messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'user_name': userModel.firstName! + ' ' + userModel.lastName!,
            'id_from': prefsObject.getString(CURRENT_USER_ID),
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type,
          },
        );
      }).then((onValue) async {
        try {
          await FirebaseFirestore.instance
              .collection('group_chat')
              .doc(project.projectId)
              .get()
              .then((doc) async {
            final ChatListItem chatItem =
                ChatListItem.fromJson(doc.data() as Map<String, dynamic>);

            await FirebaseFirestore.instance
                .collection('group_chat')
                .doc(project.projectId)
                .set({
              'user_id': prefsObject.getString(CURRENT_USER_ID),
              'name': userModel.firstName! + ' ' + userModel.lastName!,
              'email': userModel.email,
              'type': type,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'badge': chatItem.badge + 1,
              'profile_image': userModel.profileUrl,
            });
          });
          await _chatBloc.getGroupChat(groupChatId, limit);
        } catch (e) {
          await FirebaseFirestore.instance
              .collection('group_chat')
              .doc(project.projectId)
              .set({
            'user_id': prefsObject.getString(CURRENT_USER_ID),
            'name': userModel.firstName! + ' ' + userModel.lastName!,
            'email': userModel.email,
            'type': type,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'badge': 1,
            'profile_image': userModel.profileUrl,
          });
          await _chatBloc.getGroupChat(groupChatId, limit);
        }
      });
      await listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}
