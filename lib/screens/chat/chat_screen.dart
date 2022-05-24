import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/full_screen_image_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  const Chat({required this.peerUser});
  final ChatListItem peerUser;

  @override
  _ChatState createState() => _ChatState(peerUser: peerUser);
}

class _ChatState extends State<Chat> {
  _ChatState({required this.peerUser});
  final ChatListItem peerUser;

  late String groupChatId;
  late List listMessage;
  late File imageFile;
  late bool isLoading;
  late bool isLoadingPreviousMsg;
  late String imageUrl;
  int limit = 20;
  Map userData = {};
  Map receiverData = {};
  late double width;
  late ThemeData _theme;

  final imagePicker = ImagePicker();

  final TextEditingController textEditingController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getUserData();
    groupChatId = '';
    isLoading = false;
    isLoadingPreviousMsg = false;
    imageUrl = '';
    readLocal();
    removeBadge();
  }

  Future getUserData() async {
    prefsObject.setString(PEER_USRE_ID, peerUser.id);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(prefsObject.getString(CURRENT_USER_ID))
        .get()
        .then((user) async {
      userData = user.data() as Map<String, dynamic>;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(peerUser.id)
          .get()
          .then((value) async {
        receiverData = value.data() as Map<String, dynamic>;
        setState(() {});
        await FirebaseFirestore.instance
            .collection('user_currently_active')
            .doc(userData['user_id'])
            .collection(userData['user_id'])
            .doc(peerUser.id)
            .set({'user_id': peerUser.id});
      });
    });
  }

  Future removeBadge() async {
    await FirebaseFirestore.instance
        .collection('chat_list')
        .doc(prefsObject.getString(CURRENT_USER_ID))
        .collection(prefsObject.getString(CURRENT_USER_ID)!)
        .doc(peerUser.id)
        .get()
        .then((data) async {
      if (data.data() != null) {
        await FirebaseFirestore.instance
            .collection('chat_list')
            .doc(prefsObject.getString(CURRENT_USER_ID))
            .collection(prefsObject.getString(CURRENT_USER_ID)!)
            .doc(peerUser.id)
            .update({'badge': '0'});
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
        .doc(userData['user_id'])
        .collection(userData['user_id'])
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

  void onResponse() {
    setState(() {
      isLoadingPreviousMsg = false;
      limit = limit + 20;
    });
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
    _theme = Theme.of(context);
    listScrollController = ScrollController()..addListener(_scrollListener);
    return WillPopScope(
      onWillPop: removeActiveUser,
      child: Scaffold(
        key: _key,
        appBar: chatScreenAppBar(),
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

  AppBar chatScreenAppBar() {
    return AppBar(
      centerTitle: false,
      elevation: 1,
      backgroundColor: WHITE,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: DARK_PINK_COLOR),
        onPressed: () => removeActiveUser(),
      ),
      titleSpacing: 0.0,
      title: Row(
        children: <Widget>[
          Container(
            height: width * 0.1,
            width: width * 0.1,
            decoration: BoxDecoration(
              color: DARK_PINK_COLOR,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.all(1.5),
            margin: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              child: peerUser.profileUrl == ''
                  ? Image.asset('assets/images/user_placeholder.png')
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FullScreenView(imgUrl: peerUser.profileUrl),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: peerUser.profileUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          Center(
            child: Text(
              peerUser.name,
              style: _theme.textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: DARK_PINK_COLOR,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: LinearLoader(),
            )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: LinearLoader(),
                  );
                } else {
                  listMessage = snapshot.data!.docs;
                  return listMessage.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          itemBuilder: (context, index) =>
                              buildItem(context, index, listMessage[index]),
                          itemCount: snapshot.data!.docs.length,
                          reverse: true,
                          controller: listScrollController,
                        )
                      : Center(
                          child: Text(
                            'Start Conversation',
                            style: _theme.textTheme.headline6!
                                .copyWith(color: GRAY),
                          ),
                        );
                }
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
        });
  }

  dynamic _cameraPicker() async {
    XFile? captureFile = await imagePicker.pickImage(
        imageQuality: 100,
        maxWidth: 800,
        maxHeight: 800,
        source: ImageSource.camera);

    final File? cameraImage = File(captureFile!.path);
    if (cameraImage != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile(cameraImage);
    }
  }

  dynamic _galleryPicker() async {
    final XFile? pickedFile = await imagePicker.pickImage(
        imageQuality: 100,
        maxWidth: 800,
        maxHeight: 800,
        source: ImageSource.gallery);
    final File? galleryImage = File(pickedFile!.path);
    if (galleryImage != null) {
      setState(() {
        isLoading = true;
      });
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

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage.isNotEmpty &&
            listMessage[index - 1]['id_from'] ==
                prefsObject.getString(CURRENT_USER_ID)) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage.isNotEmpty &&
            listMessage[index - 1]['id_from'] !=
                prefsObject.getString(CURRENT_USER_ID)) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  String contentMsg = '';

  void onSendMessage({
    required String content,
    required bool isImage,
    required int type,
  }) {
    int badgeCount = 0;
    if (content.trim() != '') {
      setState(() {
        contentMsg = textEditingController.text;
      });
      textEditingController.clear();

      final documentReference = FirebaseFirestore.instance
          .collection('messages')
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
            .collection('chat_list')
            .doc(prefsObject.getString(CURRENT_USER_ID))
            .collection(prefsObject.getString(CURRENT_USER_ID)!)
            .doc(peerUser.id)
            .set({
          'user_id': peerUser.id,
          'name': peerUser.name,
          'email': peerUser.email,
          'type': type,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'badge': '0',
          'profile_image': peerUser.profileUrl,
        }).then((onValue) async {
          try {
            await FirebaseFirestore.instance
                .collection('chat_list')
                .doc(peerUser.id)
                .collection(peerUser.id)
                .doc(prefsObject.getString(CURRENT_USER_ID))
                .get()
                .then((doc) async {
              final Map<String, dynamic> json =
                  doc.data() as Map<String, dynamic>;
              debugPrint(json['badge']);
              if (json['badge'] != null) {
                badgeCount = int.parse(json['badge']);
                await FirebaseFirestore.instance
                    .collection('chat_list')
                    .doc(peerUser.id)
                    .collection(peerUser.id)
                    .doc(prefsObject.getString(CURRENT_USER_ID))
                    .set({
                  'user_id': prefsObject.getString(CURRENT_USER_ID),
                  'name': "${userData['name']}",
                  'email': "${userData['emailId']}",
                  'type': type,
                  'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                  'content': content,
                  'badge': '${badgeCount + 1}',
                  'profile_image': userData['photoUrl'],
                }).then((value) async {
                  await FirebaseFirestore.instance
                      .collection('user_currently_active')
                      .doc(peerUser.id)
                      .collection(peerUser.id)
                      .where('user_id', isEqualTo: userData['user_id'])
                      .get();
                });
              }
            });
          } catch (e) {
            await FirebaseFirestore.instance
                .collection('chat_list')
                .doc(peerUser.id)
                .collection(peerUser.id)
                .doc(prefsObject.getString(CURRENT_USER_ID))
                .set({
              'user_id': prefsObject.getString(CURRENT_USER_ID),
              'name': "${userData['name']}",
              'email': "${userData['emailId']}",
              'type': type,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'badge': '${badgeCount + 1}',
              'profile_image': userData['photoUrl'],
            }).then((value) async {
              await FirebaseFirestore.instance
                  .collection('user_currently_active')
                  .doc(peerUser.id)
                  .collection(peerUser.id)
                  .where('user_id', isEqualTo: userData['user_id'])
                  .get();
            });
            print(e);
          }
        });
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Widget buildItem(BuildContext context, int index, DocumentSnapshot document) {
    if (document['id_from'] == prefsObject.getString(CURRENT_USER_ID)) {
      // Sent Message (my message)
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              document['type'] == 0
                  // Text
                  ? GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(
                            ClipboardData(text: document['content']));
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
                            bottom: isLastMessageRight(index) ? 10.0 : 10.0,
                            right: 24,
                            left: 24),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                          child: Text(
                            document['content'],
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
                            imageUrl: document['content'],
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
                                  FullScreenView(imgUrl: document['content']),
                            ),
                          );
                        },
                      ),
                    ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          isLastMessageRight(index)
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
                              int.parse(document['timestamp']),
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
        children: <Widget>[
          Row(
            children: <Widget>[
              document['type'] == 0
                  ? Container(
                      width: MediaQuery.of(context).size.width - 100,
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 10.0 : 10.0,
                          left: 24,
                          right: 24),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        child: Text(document['content'],
                            style: _theme.textTheme.bodyText2!
                                .copyWith(color: WHITE)),
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
                          imageUrl: document['content'],
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
          isLastMessageLeft(index)
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
                            int.parse(document['timestamp']),
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
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    }
  }

  Widget buildInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: 10.0, left: 14.0, top: 8.0, right: 4.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                style: _theme.textTheme.bodyText2,
                controller: textEditingController,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                decoration: InputDecoration(
                  enabledBorder: inputDecoration(),
                  disabledBorder: inputDecoration(),
                  focusedBorder: inputDecoration(),
                  border: inputDecoration(),
                  fillColor: GRAY,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.photo_fill_on_rectangle_fill,
                        color: PRIMARY_COLOR,
                      ),
                      onPressed: () {
                        chooseSourceOfPhoto(context);
                      },
                    ),
                  ),
                  hintText: ENTER_MESSAGE_HINT,
                  filled: true,
                  hintStyle: _theme.textTheme.bodyText2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: IconButton(
                iconSize: 28,
                icon: Image.asset(
                  'assets/images/send.png',
                  color: PRIMARY_COLOR,
                  height: 35,
                  width: 35,
                ),
                onPressed: () async {
                  onSendMessage(
                    content: textEditingController.text,
                    isImage: false,
                    type: 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder inputDecoration() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(width: 1, color: PRIMARY_COLOR),
    );
  }
}
