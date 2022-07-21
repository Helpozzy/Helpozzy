import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bubble/bubble.dart';
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
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/full_screen_image_view.dart';
import 'package:image_picker/image_picker.dart';

class OneToOneChat extends StatefulWidget {
  const OneToOneChat({required this.peerUser});
  final ChatListItem peerUser;
  @override
  _ProjectChatState createState() => _ProjectChatState(peerUser: peerUser);
}

class _ProjectChatState extends State<OneToOneChat> {
  _ProjectChatState({required this.peerUser});
  final ChatListItem peerUser;
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
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();
  late ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final ChatBloc _chatBloc = ChatBloc();

  @override
  void initState() {
    super.initState();
    readLocal();
    removeBadge();
    listenUserData();
    _chatBloc.getOneToOneChat(groupChatId, limit);
  }

  Future listenUserData() async {
    final String? userDataString = prefsObject.getString(CURRENT_USER_DATA);
    if (userDataString != null && userDataString.isNotEmpty) {
      userModel = SignUpAndUserModel.fromJson(json: jsonDecode(userDataString));
    }
  }

  Future removeBadge() async {
    await FirebaseFirestore.instance
        .collection('one_to_one_chat_list')
        .doc(prefsObject.getString(CURRENT_USER_ID)!)
        .collection(prefsObject.getString(CURRENT_USER_ID)!)
        .doc(peerUser.id)
        .get()
        .then((data) async {
      if (data.data() != null) {
        await FirebaseFirestore.instance
            .collection('one_to_one_chat_list')
            .doc(prefsObject.getString(CURRENT_USER_ID)!)
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
    await _chatBloc.getOneToOneChat(groupChatId, limit);
  }

  void readLocal() {
    if (prefsObject.getString(CURRENT_USER_ID).hashCode <=
        peerUser.id.hashCode) {
      groupChatId = '${prefsObject.getString(CURRENT_USER_ID)}-${peerUser.id}';
    } else {
      groupChatId = '${peerUser.id}-${prefsObject.getString(CURRENT_USER_ID)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _theme = Theme.of(context);
    listScrollController = ScrollController()..addListener(_scrollListener);
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
              stream: _chatBloc.getOneToOneMessagesStream,
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

  Widget buildItem(BuildContext context, List<MessageModel> chat, int index,
      MessageModel message) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: message.content));
        ScaffoldSnakBar().show(context, msg: MESSAGE_COPIED_POPUP_MSG);
      },
      child: Bubble(
        margin: BubbleEdges.only(top: 12, left: 8, right: 8),
        padding: BubbleEdges.symmetric(vertical: 8.0, horizontal: 12.0),
        elevation: 0,
        radius: Radius.circular(13),
        nipWidth: 10,
        nipHeight: 10,
        nipRadius: 2.0,
        alignment: message.idFrom == prefsObject.getString(CURRENT_USER_ID)
            ? Alignment.topRight
            : Alignment.topLeft,
        nip: message.idFrom == prefsObject.getString(CURRENT_USER_ID)
            ? BubbleNip.rightTop
            : BubbleNip.leftTop,
        color: message.idFrom == prefsObject.getString(CURRENT_USER_ID)
            ? ACCENT_PINK_COLOR
            : GRAY,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.type == 0
                ? Text(
                    message.content,
                    style: _theme.textTheme.bodyText2!.copyWith(color: BLACK),
                  )
                : InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: Center(child: LinearLoader()),
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: message.idFrom ==
                                    prefsObject.getString(CURRENT_USER_ID)
                                ? DARK_PINK_COLOR.withOpacity(0.3)
                                : DARK_GRAY.withOpacity(0.2),
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
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.cover,
                      ),
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
            SizedBox(height: 3),
            isLastMessage(chat, index)
                ? Text(
                    _dateFormatFromTimeStamp
                        .lastSeenFromTimeStamp(message.timestamp),
                    style: _theme.textTheme.bodyText2!.copyWith(
                      color: DARK_GRAY,
                      fontSize: 9.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
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
                    color: PRIMARY_COLOR.withOpacity(0.8),
                  ),
                  onPressed: () => imageOptionPopup(),
                ),
              ),
              suffixIcon: InkWell(
                child: Icon(
                  CupertinoIcons.play_circle_fill,
                  color: PRIMARY_COLOR.withOpacity(0.8),
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

  bool isLastMessage(List<MessageModel> chat, int index) {
    if ((index > 0 &&
            chat.isNotEmpty &&
            chat[index - 1].idFrom != prefsObject.getString(CURRENT_USER_ID)) ||
        index == 0) {
      return true;
    } else if ((index > 0 &&
            chat.isNotEmpty &&
            chat[index - 1].idFrom == prefsObject.getString(CURRENT_USER_ID)) ||
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
          .collection('one_to_one_messages')
          .doc(groupChatId)
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
            .collection('one_to_one_chat_list')
            .doc(prefsObject.getString(CURRENT_USER_ID)!)
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
                .collection('one_to_one_chat_list')
                .doc(peerUser.id)
                .collection(peerUser.id)
                .doc(prefsObject.getString(CURRENT_USER_ID))
                .get()
                .then((doc) async {
              final ChatListItem chatItem =
                  ChatListItem.fromJson(doc.data() as Map<String, dynamic>);
              await FirebaseFirestore.instance
                  .collection('one_to_one_chat_list')
                  .doc(peerUser.id)
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
              });
            });
            await _chatBloc.getOneToOneChat(groupChatId, limit);
          } catch (e) {
            await FirebaseFirestore.instance
                .collection('one_to_one_chat_list')
                .doc(peerUser.id)
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
            });
            await _chatBloc.getOneToOneChat(groupChatId, limit);
          }
        });
      });
      await listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}
