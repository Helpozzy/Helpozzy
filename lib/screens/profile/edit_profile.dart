import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/cities_bloc.dart';
import 'package:helpozzy/bloc/edit_profile_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/auth/signup/search_bottomsheets/common_search_bottomsheet.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_image_picker_.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/platform_alert_dialog.dart';
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
  final CityBloc _cityBloc = CityBloc();
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  final EditProfileBloc _editProfileBloc = EditProfileBloc();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _personalPhoneController =
      TextEditingController();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();
  late List<StateModel>? states = [];
  late List<CityModel>? cities = [];
  late CountryCode? countryCode;
  late SignUpAndUserModel? userModel;

  @override
  void initState() {
    listenUser();
    countryCode = _personalPhoneController.text.isNotEmpty
        ? CountryCode(code: countryCode!.dialCode!)
        : CountryCode(code: '+1', name: 'US');
    _cityBloc.getStates();
    listenState();
    super.initState();
  }

  Future listenUser() async {
    userModel =
        await _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
    _firstNameController.text = userModel!.name!.split(' ')[0];
    _lastNameController.text = userModel!.name!.split(' ')[1];
    _aboutController.text = userModel!.about!;
    _addressController.text = userModel!.address!;
    _emailController.text = userModel!.email!;
    _dateOfBirthController.text = DateFormatFromTimeStamp().dateFormatToYMD(
        dateTime: DateTime.fromMillisecondsSinceEpoch(
            int.parse(userModel!.dateOfBirth!)));
    _genderController.text = userModel!.gender!;
    _stateController.text = userModel!.state!;
    _cityController.text = userModel!.city!;
    _zipCodeController.text = userModel!.zipCode!;
    countryCode = CountryCode(code: userModel!.countryCode!);
    _personalPhoneController.text = userModel!.personalPhnNo!;
    _parentEmailController.text = userModel!.parentEmail!;
    _relationController.text = userModel!.relationshipWithParent!;
    _schoolController.text = userModel!.schoolName!;
    _gradeLevelController.text = userModel!.gradeLevel!;
  }

  Future listenState() async {
    final States statesList = await _cityBloc.getStates();
    setState(() => states = statesList.states);
  }

  Future listenCities(String stateName) async {
    final Cities citiesList = await _cityBloc.getCities(stateName);
    setState(() => cities = citiesList.cities);
  }

  Future postModifiedData() async {
    CircularLoader().show(context);
    late String profileUrl = '';
    if (_imageFile != null) {
      profileUrl = await convertAndUpload(_imageFile!);
    }
    final SignUpAndUserModel signUpAndUserModel = SignUpAndUserModel(
      name: _firstNameController.text + ' ' + _lastNameController.text,
      about: _aboutController.text,
      email: _emailController.text,
      gender: _genderController.text,
      address: _addressController.text,
      state: _stateController.text,
      city: _cityController.text,
      zipCode: _zipCodeController.text,
      countryCode: countryCode!.code!,
      personalPhnNo: _personalPhoneController.text,
      parentEmail: _parentEmailController.text,
      relationshipWithParent: _relationController.text,
      schoolName: _schoolController.text,
      gradeLevel: _gradeLevelController.text,
      areaOfInterests: userModel!.areaOfInterests,
      currentYearTargetHours: userModel!.currentYearTargetHours,
      dateOfBirth: userModel!.dateOfBirth,
      joiningDate: userModel!.joiningDate,
      pointGifted: userModel!.pointGifted,
      profileUrl: profileUrl.isEmpty ? userModel!.profileUrl : profileUrl,
      rating: userModel!.rating,
      reviewsByPersons: userModel!.reviewsByPersons,
      volunteerType: userModel!.volunteerType,
    );
    final bool response =
        await _editProfileBloc.editProfile(signUpAndUserModel);
    if (response) {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(context, msg: PROFILE_UPDATED_POPUP_MSG);
      Navigator.of(context).pop();
    } else {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(context, msg: PROFILE_NOT_UPDATED_POPUP_MSG);
    }
  }

  Future convertAndUpload(XFile pickedFile) async {
    final File convertedFile = File(pickedFile.path);
    final String imgUrl = await uploadImage(convertedFile);
    return imgUrl;
  }

  Future<String> uploadImage(File selectedImage) async {
    late String downloadUrl;
    try {
      final String imageName =
          userModel!.name! + DateTime.now().millisecondsSinceEpoch.toString();

      final storageUploadTask = await FirebaseStorage.instance
          .ref()
          .child('user_profile')
          .child(imageName)
          .putFile(selectedImage);

      downloadUrl = await storageUploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      e.toString();
    }
    return downloadUrl;
  }

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
          StreamBuilder<bool>(
            initialData: false,
            stream: _editProfileBloc.parentEmailVerifiedStream,
            builder: (context, snapshot) {
              return IconButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (snapshot.data!) {
                      await postModifiedData();
                    } else {
                      if (userModel!.parentEmail ==
                          _parentEmailController.text) {
                        await postModifiedData();
                      } else {
                        PlatformAlertDialog().show(context,
                            title: ALERT,
                            content:
                                'Parent/Guardian email is not verified, Please verify your email.');
                      }
                    }
                  }
                },
                icon: Icon(
                  CupertinoIcons.checkmark_alt,
                  color: DARK_PINK_COLOR,
                ),
              );
            },
          ),
        ],
      ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: width * 0.1),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                ),
                child: labelWithTopPadding(PROFILE_IMAGE_LABEL),
              ),
              Center(child: userProfilePic()),
              SizedBox(height: width * 0.04),
              Divider(),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  bottom: width * 0.04,
                ),
                child: personalDetails(),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  bottom: width * 0.04,
                ),
                child: livingInfo(),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  bottom: width * 0.04,
                ),
                child: contactInfo(),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  bottom: width * 0.04,
                ),
                child: schoolInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget personalDetails() {
    return Column(
      children: [
        labelWithTopPadding(PERSONAL_DETAILS_LABEL),
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
          maxLines: 2,
          controller: _aboutController,
          hintText: ENTER_ABOUT_HINT,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Enter about your self';
            }
            return null;
          },
        ),
        labelWithTopPadding(EMAIL_LABEL),
        CommonSimpleTextfield(
          readOnly: true,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(
              CupertinoIcons.checkmark_seal_fill,
              color: ACCENT_GREEN,
              size: 18,
            ),
          ),
          controller: _emailController,
          hintText: ENTER_EMAIL_HINT,
          validator: (val) => null,
        ),
        labelWithTopPadding(DATE_OF_BIRTH_LABEL),
        CommonSimpleTextfield(
          readOnly: true,
          controller: _dateOfBirthController,
          hintText: SELECT_DATE_OF_BIRTH_HINT,
          validator: (val) => null,
        ),
        labelWithTopPadding(GENDER_LABEL),
        genderDropDown(),
      ],
    );
  }

  Widget livingInfo() {
    return Column(
      children: [
        labelWithTopPadding(LIVING_INFO_LABEL),
        SizedBox(height: 10),
        TextfieldLabelSmall(label: ADDRESS_LABEL),
        CommonSimpleTextfield(
          controller: _addressController,
          hintText: ADDRESS_HINT,
          validator: (val) => null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            children: [
              Expanded(child: selectStateDropDown(states!)),
              cities!.isNotEmpty ? SizedBox(width: 10) : SizedBox(),
              cities!.isNotEmpty
                  ? Expanded(child: selectCitiesDropDown(cities!))
                  : SizedBox(),
            ],
          ),
        ),
        TextfieldLabelSmall(label: ZIPCODE_LABEL),
        CommonSimpleTextfield(
          controller: _zipCodeController,
          hintText: ENTER_ZIP_CODE,
          validator: (val) => null,
        ),
      ],
    );
  }

  Widget contactInfo() {
    return Column(
      children: [
        labelWithTopPadding(CONTACT_INFO_LABEL),
        SizedBox(height: 10),
        TextfieldLabelSmall(label: PERSONAL_PHN_LABEL),
        CommonSimpleTextfield(
          controller: _personalPhoneController,
          prefixIcon: countryCodePicker(),
          hintText: ENTER_PHONE_NUMBER_HINT,
          maxLength: 10,
          keyboardType: TextInputType.number,
          validator: (phone) {
            if (phone!.isEmpty) {
              return 'Please enter phone number';
            } else if (phone.isNotEmpty && phone.length != 10) {
              return 'Please enter 10 digit number';
            } else {
              return null;
            }
          },
        ),
        TextfieldLabelSmall(label: PARENT_GUARDIAN_EMAIL_LABEL),
        parentEmailSection(),
        TextfieldLabelSmall(label: RELATION_LABEL),
        selectRelationshipDropdown(),
      ],
    );
  }

  Widget parentEmailSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StreamBuilder<bool>(
            initialData: false,
            stream: _editProfileBloc.parentEmailVerifiedStream,
            builder: (context, snapshotEmailVerified) {
              return CommonSimpleTextfield(
                controller: _parentEmailController,
                hintText: ENTER_EMAIL_HINT,
                suffixIcon: Icon(
                  snapshotEmailVerified.data!
                      ? CupertinoIcons.checkmark_seal_fill
                      : userModel!.parentEmail == _parentEmailController.text
                          ? CupertinoIcons.checkmark_seal_fill
                          : CupertinoIcons.checkmark_seal,
                  size: 18,
                  color: snapshotEmailVerified.data!
                      ? ACCENT_GREEN
                      : userModel!.parentEmail == _parentEmailController.text
                          ? ACCENT_GREEN
                          : DARK_GRAY,
                ),
                onChanged: (val) {
                  setState(() => _parentEmailController.selection =
                      TextSelection.fromPosition(
                          TextPosition(offset: val.length)));
                },
                validator: (parentEmail) {
                  if (parentEmail!.isEmpty) {
                    return 'Please enter parents/guardian email';
                  } else if (parentEmail.isNotEmpty &&
                      !EmailValidator.validate(parentEmail)) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              );
            }),
        InkWell(
          onTap: () async {
            FocusScope.of(context).unfocus();
            if (_parentEmailController.text.trim().isNotEmpty)
              _editProfileBloc
                  .sentOtpOfParentEmail(_parentEmailController.text);
            else
              PlatformAlertDialog().show(context,
                  title: ALERT, content: 'Parent/Guardian email is empty');
          },
          child: Container(
            alignment: Alignment.centerRight,
            padding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: width * 0.04),
            child: Text(
              SEND_VERIFICATION_CODE_BUTTON,
              style: _theme.textTheme.bodyText2!.copyWith(color: PRIMARY_COLOR),
            ),
          ),
        ),
        StreamBuilder<bool>(
          initialData: false,
          stream: _editProfileBloc.parentOtpSentStream,
          builder: (context, snapshotSentOtp) {
            return snapshotSentOtp.data!
                ? CommonSimpleTextfield(
                    hintText: ENTER_OTP_HINT,
                    controller: _otpController,
                    maxLength: 6,
                    onChanged: (val) {
                      if (val.isNotEmpty && val.length == 6)
                        _editProfileBloc.verifyParentEmail(
                            _parentEmailController.text, _otpController.text);
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter OTP';
                      } else if (val.isNotEmpty && val.length != 6) {
                        return 'Please enter 6 digit OTP';
                      } else {
                        return null;
                      }
                    },
                  )
                : SizedBox();
          },
        ),
      ],
    );
  }

  Widget countryCodePicker() {
    return CountryCodePicker(
      onChanged: (CountryCode code) => countryCode = code,
      boxDecoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      initialSelection: 'US',
      backgroundColor: WHITE,
      showCountryOnly: false,
      dialogSize: Size(width, height - 30),
      showFlagMain: true,
      dialogTextStyle: Theme.of(context).textTheme.bodyText2,
      flagWidth: 25.0,
      showOnlyCountryWhenClosed: false,
      showFlag: false,
      showFlagDialog: true,
      favorite: ['+1', 'US'],
      textStyle: Theme.of(context).textTheme.bodyText2,
      closeIcon: Icon(Icons.close_rounded),
      searchDecoration: inputRoundedDecoration(getHint: SEARCH_COUNTRY_HINT),
    );
  }

  Widget labelWithTopPadding(String label) {
    return Padding(
      padding: EdgeInsets.only(top: width * 0.03),
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
                    errorWidget: (context, url, error) => Center(
                        child:
                            CommonUserProfileOrPlaceholder(size: width / 4.5)),
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
            CANCEL_BUTTON,
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
        decoration: inputSimpleDecoration(
          getHint: _genderController.text.isNotEmpty
              ? _genderController.text
              : SELCT_GENDER_HINT,
        ),
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

  Widget selectStateDropDown(List<StateModel> states) {
    return Column(
      children: [
        TextfieldLabelSmall(label: STATE_LABEL),
        DropdownButtonFormField<StateModel>(
          hint: Text(
            _stateController.text.isNotEmpty
                ? _stateController.text
                : states.isEmpty
                    ? 'Loading..'
                    : SEARCH_STATE_NAME_HINT,
          ),
          icon: Icon(Icons.expand_more_outlined),
          decoration: inputSimpleDecoration(getHint: SEARCH_STATE_NAME_HINT),
          isExpanded: true,
          onChanged: (StateModel? newValue) async {
            setState(() => _stateController.text = newValue!.stateName!);
            cities!.clear();
            listenCities(newValue!.stateName!);
          },
          validator: (val) {
            if (val == null) {
              return 'Please search state';
            }
            return null;
          },
          items: states.map<DropdownMenuItem<StateModel>>((StateModel? value) {
            return DropdownMenuItem<StateModel>(
              value: value,
              child: Text(
                value!.stateName!,
                textAlign: TextAlign.center,
                style: _theme.textTheme.bodyText2,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget selectCitiesDropDown(List<CityModel> cities) {
    return cities.isNotEmpty
        ? Column(
            children: [
              TextfieldLabelSmall(label: CITY_LABEL),
              DropdownButtonFormField<CityModel>(
                  hint: Text(_stateController.text.isEmpty
                      ? _cityController.text.isNotEmpty
                          ? _cityController.text
                          : SEARCH_CITY_NAME_HINT
                      : cities.isEmpty
                          ? 'Loading..'
                          : SEARCH_CITY_NAME_HINT),
                  icon: Icon(Icons.expand_more_outlined),
                  decoration:
                      inputSimpleDecoration(getHint: SEARCH_CITY_NAME_HINT),
                  isExpanded: true,
                  onChanged: (CityModel? newValue) {
                    setState(() {
                      _cityController.text = newValue!.cityName!;
                    });
                  },
                  validator: (val) {
                    if (val == null) {
                      return 'Please search city';
                    }
                    return null;
                  },
                  items: cities
                      .map<DropdownMenuItem<CityModel>>((CityModel? value) {
                    return DropdownMenuItem<CityModel>(
                      value: value,
                      child: Text(
                        value!.cityName!,
                        textAlign: TextAlign.center,
                        style: _theme.textTheme.bodyText2,
                      ),
                    );
                  }).toList()),
            ],
          )
        : SizedBox();
  }

  Widget selectRelationshipDropdown() {
    return DropdownButtonFormField<String>(
      icon: Icon(Icons.expand_more_outlined),
      isExpanded: true,
      decoration: inputSimpleDecoration(
          getHint: _relationController.text.isNotEmpty
              ? _relationController.text
              : SELECT_RELATION_HINT),
      onChanged: (String? newValue) {
        setState(() {
          _relationController.text = newValue!;
        });
      },
      validator: (val) {
        if (_relationController.text.isEmpty) {
          return 'Select relationship status';
        }
        return null;
      },
      items: relationShips.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Center(
            child: Text(
              value,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget schoolInfo() {
    return Column(
      children: [
        labelWithTopPadding(SCHOOL_INFO_LABEL),
        Column(
          children: [
            schoolField(),
            SizedBox(width: 10),
            selectGradeDropDown(),
          ],
        ),
      ],
    );
  }

  Widget schoolField() {
    return Column(
      children: [
        SizedBox(height: 10),
        TextfieldLabelSmall(label: SCHOOL_NAME_LABEL),
        CommonSimpleTextfield(
          controller: _schoolController,
          readOnly: true,
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
          hintText: SEARCH_SCHOOL_HINT,
          validator: (val) {
            if (val!.isNotEmpty && val == SEARCH_SCHOOL_HINT) {
              return 'Please search school';
            }
            return null;
          },
          onTap: () async {
            final SchoolDetailsModel school =
                await SearchBottomSheet().modalBottomSheetMenu(
              context: context,
              searchBottomSheetType: SearchBottomSheetType.SCHOOL_BOTTOMSHEET,
              state: _stateController.text,
              city: _cityController.text,
            );
            setState(() {
              _schoolController.text = school.schoolName;
            });
          },
        ),
      ],
    );
  }

  Widget selectGradeDropDown() {
    return Column(
      children: [
        SizedBox(height: 10),
        TextfieldLabelSmall(label: GRADE_LEVEL_LABEL),
        DropdownButtonFormField<String>(
            hint: Text(_gradeLevelController.text.isNotEmpty
                ? _gradeLevelController.text
                : GRADE_HINT),
            icon: Icon(Icons.expand_more_outlined),
            decoration: inputSimpleDecoration(getHint: GRADE_HINT),
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                _gradeLevelController.text = newValue!;
              });
            },
            validator: (val) {
              if (_gradeLevelController.text.isNotEmpty &&
                  _gradeLevelController.text == GRADE_HINT) {
                return 'Please select grade level';
              }
              return null;
            },
            items: gradeLevels.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: _theme.textTheme.bodyText2,
                ),
              );
            }).toList()),
      ],
    );
  }
}
