import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_image_picker_.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({required this.user});
  final SignUpAndUserModel user;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState(user: user);
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  _EditProfileScreenState({required this.user});
  final SignUpAndUserModel user;

  static final _formKey = GlobalKey<FormState>();
  late ThemeData _theme;
  late double height;
  late double width;
  XFile? _imageFile;
  final CommonPicker _commonPicker = CommonPicker();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _theme = Theme.of(context);
    return Scaffold(
      appBar: CommonAppBar(context).show(
        title: 'Edit Profile',
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {}
            },
            icon: Icon(
              CupertinoIcons.checkmark_alt,
              color: DARK_PINK_COLOR,
            ),
          ),
        ],
      ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: width * 0.05, left: width * 0.05, right: width * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelWithTopPadding('Profile Image'),
              Center(child: userProfilePic()),
              SizedBox(height: width * 0.04),
              labelWithTopPadding('Personal Details'),
              Row(
                children: [
                  Expanded(
                    child: CommonSimpleTextfield(
                      controller: _firstNameController,
                      hintText: ENTER_FIRST_NAME_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter your first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CommonSimpleTextfield(
                      controller: _lastNameController,
                      hintText: ENTER_LAST_NAME_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter your last name';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              labelWithTopPadding(ABOUT_TEXT),
              CommonSimpleTextfield(
                controller: _aboutController,
                hintText: ENTER_ABOUT_HINT,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter about your self';
                  }
                  return null;
                },
              ),
              labelWithTopPadding('Email'),
              CommonSimpleTextfield(
                readOnly: true,
                controller: _emailController,
                hintText: ENTER_EMAIL_HINT,
                validator: (val) => null,
              ),
              labelWithTopPadding('Date of Birth'),
              CommonSimpleTextfield(
                readOnly: true,
                controller: _dateOfBirthController,
                hintText: SELECT_DATE_OF_BIRTH_HINT,
                validator: (val) => null,
              ),
              labelWithTopPadding('Gender'),
              genderDropDown(),
            ],
          ),
        ),
      ),
    );
  }

  Widget labelWithTopPadding(String label) {
    return Padding(
      padding: EdgeInsets.only(top: width * 0.05),
      child: SmallInfoLabel(label: label),
    );
  }

  Widget userProfilePic() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(3),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: PRIMARY_COLOR.withOpacity(0.8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: _imageFile != null
                ? Image.file(
                    File(_imageFile!.path),
                    fit: BoxFit.cover,
                    height: width / 4.5,
                    width: width / 4.5,
                  )
                : CachedNetworkImage(
                    imageUrl: user.profileUrl!,
                    fit: BoxFit.cover,
                    height: width / 4.5,
                    width: width / 4.5,
                    alignment: Alignment.center,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress, color: WHITE),
                    errorWidget: (context, url, error) =>
                        Center(child: CommonUserPlaceholder(size: width / 4.5)),
                  ),
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: GestureDetector(
            onTap: () => imageOptionPopup(),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), color: WHITE),
              child: Container(
                height: 22,
                width: 22,
                margin: EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: PRIMARY_COLOR.withOpacity(0.8)),
                child: Icon(
                  Icons.edit_rounded,
                  color: WHITE,
                  size: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future imageOptionPopup() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Select Option'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              'Camera',
              style: _theme.textTheme.bodyText2!.copyWith(color: PRIMARY_COLOR),
            ),
            isDefaultAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              _imageFile = await _commonPicker.onImageButtonPressed(
                  source: ImageSource.camera, isMultiImage: false);
              setState(() {});
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Gallery',
              style: _theme.textTheme.bodyText2!.copyWith(color: PRIMARY_COLOR),
            ),
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              _imageFile = await _commonPicker.onImageButtonPressed(
                  source: ImageSource.gallery, isMultiImage: false);
              setState(() {});
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            'Cancle',
            style: _theme.textTheme.bodyText2!.copyWith(color: PRIMARY_COLOR),
          ),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget genderDropDown() {
    return DropdownButtonFormField<String>(
        decoration: inputSimpleDecoration(getHint: SELCT_GENDER_HINT),
        icon: Icon(Icons.expand_more_outlined),
        validator: (val) {
          if (_genderController.text.isEmpty) {
            return 'Select gender want to continue';
          }
          return null;
        },
        isExpanded: true,
        onTap: () => FocusScope.of(context).unfocus(),
        onChanged: (String? newValue) {
          setState(() {
            _genderController.text = newValue!;
          });
        },
        items: gendersItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              textAlign: TextAlign.center,
            ),
          );
        }).toList());
  }
}
