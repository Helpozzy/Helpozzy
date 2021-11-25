import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/cities_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/helper/state_city_helper.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_image_picker_.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  final CityInfoBloc _cityInfoBloc = CityInfoBloc();
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
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
  final TextEditingController _relationController = TextEditingController();
  late List<String>? states = [];
  late List<CityModel>? cities = [];
  CountryCode? countryCode;

  @override
  void initState() {
    countryCode = CountryCode(code: '+1', name: 'US');
    listenUser();
    _cityInfoBloc.getStates();
    listenState();
    super.initState();
  }

  Future listenUser() async {
    final SignUpAndUserModel userModel =
        await _userInfoBloc.getUser(prefsObject.getString('uID')!);
    _firstNameController.text = userModel.name!.split(' ')[0];
    _lastNameController.text = userModel.name!.split(' ')[1];
    _aboutController.text = userModel.about!;
    _addressController.text = userModel.address!;
    _emailController.text = userModel.email!;
    _dateOfBirthController.text = DateFormat.yMd().format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(userModel.dateOfBirth!)));
    _genderController.text = userModel.gender!;
    _stateController.text = userModel.state!;
    _cityController.text = userModel.city!;
    _zipCodeController.text = userModel.zipCode!;
    _personalPhoneController.text =
        userModel.personalPhnNo!.characters.takeLast(10).string;
    _parentEmailController.text = userModel.parentEmail!;
    _relationController.text = userModel.relationshipWithParent!;
  }

  Future listenState() async {
    final StatesHelper statesHelper = await _cityInfoBloc.getStates();
    setState(() => states = statesHelper.states);
  }

  Future listenCities(String stateName) async {
    final Cities citiesList = await _cityInfoBloc.getCities(stateName);
    setState(() => cities = citiesList.cities);
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
                child: labelWithTopPadding('Profile Image'),
              ),
              Center(child: userProfilePic()),
              SizedBox(height: width * 0.04),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                ),
                child: personalDetails(),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                ),
                child: livingInfo(),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                ),
                child: contactInfo(),
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
    );
  }

  Widget livingInfo() {
    return Column(
      children: [
        labelWithTopPadding('Living Info'),
        CommonSimpleTextfield(
          controller: _addressController,
          hintText: ADDRESS_HINT,
          validator: (val) => null,
        ),
        Row(
          children: [
            Expanded(child: selectStateDropDown(states!)),
            cities!.isNotEmpty ? SizedBox(width: 10) : SizedBox(),
            cities!.isNotEmpty
                ? Expanded(child: selectCitiesDropDown(cities!))
                : SizedBox(),
          ],
        ),
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
        labelWithTopPadding('Contact Info'),
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
        CommonSimpleTextfield(
          controller: _parentEmailController,
          hintText: ENTER_PARENTS_EMAIL_HINT,
          validator: (parentEmail) {
            if (parentEmail!.isEmpty) {
              return 'Please enter parents/guardian email';
            } else if (parentEmail.isNotEmpty &&
                !EmailValidator.validate(parentEmail)) {
              return 'Please enter valid email';
            }
            return null;
          },
        ),
        selectRelationshipDropdown(),
      ],
    );
  }

  Widget countryCodePicker() {
    return CountryCodePicker(
      onChanged: (CountryCode code) {
        countryCode = code;
      },
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

  Widget selectStateDropDown(List<String> states) {
    return DropdownButtonFormField<String>(
      hint: Text(
        _stateController.text.isNotEmpty
            ? _stateController.text
            : states.isEmpty
                ? 'Loading..'
                : SELECT_STATE_HINT,
      ),
      icon: Icon(Icons.expand_more_outlined),
      decoration: inputSimpleDecoration(getHint: SELECT_STATE_HINT),
      isExpanded: true,
      onChanged: (String? newValue) async {
        setState(() => _stateController.text = newValue!);
        cities!.clear();
        listenCities(newValue!);
      },
      validator: (val) {
        if (_stateController.text.isNotEmpty &&
            _stateController.text == SELECT_STATE_HINT) {
          return 'Please select state';
        }
        return null;
      },
      items: states.map<DropdownMenuItem<String>>((String? value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value!,
            textAlign: TextAlign.center,
            style: _theme.textTheme.bodyText2,
          ),
        );
      }).toList(),
    );
  }

  Widget selectCitiesDropDown(List<CityModel> cities) {
    return cities.isNotEmpty
        ? DropdownButtonFormField<CityModel>(
            hint: Text(_stateController.text.isEmpty
                ? _cityController.text.isNotEmpty
                    ? _cityController.text
                    : SELECT_CITY_HINT
                : cities.isEmpty
                    ? 'Loading..'
                    : SELECT_CITY_HINT),
            icon: Icon(Icons.expand_more_outlined),
            decoration: inputSimpleDecoration(getHint: SELECT_CITY_HINT),
            isExpanded: true,
            onChanged: (CityModel? newValue) {
              setState(() {
                _cityController.text = newValue!.city!;
              });
            },
            validator: (val) {
              if (_cityController.text.isNotEmpty &&
                  _cityController.text == SELECT_CITY_HINT) {
                return 'Please select city';
              }
              return null;
            },
            items: cities.map<DropdownMenuItem<CityModel>>((CityModel? value) {
              return DropdownMenuItem<CityModel>(
                value: value,
                child: Text(
                  value!.city!,
                  textAlign: TextAlign.center,
                  style: _theme.textTheme.bodyText2,
                ),
              );
            }).toList())
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
}
