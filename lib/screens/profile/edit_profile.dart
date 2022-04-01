import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:helpozzy/bloc/edit_profile_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/organization_sign_up_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_image_picker_.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/platform_alert_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final EditProfileBloc _editProfileBloc = EditProfileBloc();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _stateController = TextEditingController();
  // final TextEditingController _cityController = TextEditingController();
  // final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _personalPhoneController =
      TextEditingController();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();

  //Organization
  final TextEditingController _organizationNameController =
      TextEditingController();
  final TextEditingController _organizationDiscriptionContntroller =
      TextEditingController();
  final TextEditingController _organizationOtherContntroller =
      TextEditingController();
  final TextEditingController _organizationTaxIdNumberContntroller =
      TextEditingController();
  late OrganizationTypes _organizationType = OrganizationTypes.CORP;
  late bool nonProfitOrganization = false;

  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
    mask: 'XX_XXXXXXX',
    filter: {'X': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  late List<StateModel>? states = [];
  late List<CityModel>? cities = [];
  late CountryCode? countryCode;
  late bool organizationExpanded = false;

  late GooglePlace googlePlace;
  late String? addressLocation = '';
  late List<AutocompletePrediction> addressPredictions = [];
  late DetailsResult? addressDetailsResult;

  late String? schoolLocation = '';
  late List<AutocompletePrediction> schoolPredictions = [];
  late DetailsResult? schoolDetailsResult;

  @override
  void initState() {
    countryCode = CountryCode(code: '+1', name: 'US');
    listenUser();
    googlePlace = GooglePlace(ANDROID_MAP_API_KEY);
    // _cityBloc.getStates();
    // listenState();
    super.initState();
  }

  Future<void> autoCompleteAddressSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() => addressPredictions = result.predictions!);
    }
  }

  Future<void> getAddressDetails(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      addressDetailsResult = result.result!;
      addressLocation = addressDetailsResult!.formattedAddress!;
      _addressController.clear();
      addressPredictions.clear();
      setState(() {});
    }
  }

  Future<void> autoCompleteSchoolSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() => schoolPredictions = result.predictions!);
    }
  }

  Future<void> getSchoolDetails(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      schoolDetailsResult = result.result!;
      schoolLocation =
          schoolDetailsResult!.name! + schoolDetailsResult!.formattedAddress!;
      _schoolController.clear();
      schoolPredictions.clear();
      setState(() {});
    }
  }

  Future listenUser() async {
    _firstNameController.text = user.name!.split(' ')[0];
    _lastNameController.text = user.name!.split(' ')[1];
    _aboutController.text = user.about!;
    _emailController.text = user.email!;
    _dateOfBirthController.text = DateFormatFromTimeStamp().dateFormatToYMD(
        dateTime:
            DateTime.fromMillisecondsSinceEpoch(int.parse(user.dateOfBirth!)));
    _genderController.text = user.gender!;
    // _stateController.text = user.state!;
    // _cityController.text = user.city!;
    // _zipCodeController.text = user.zipCode!;
    countryCode = CountryCode(code: user.countryCode!);
    _personalPhoneController.text = user.personalPhnNo!;
    _parentEmailController.text =
        user.parentEmail != null ? user.parentEmail! : '';
    _relationController.text =
        user.relationshipWithParent != null ? user.relationshipWithParent! : '';

    _gradeLevelController.text =
        user.gradeLevel != null ? user.gradeLevel! : '';
    if (user.isOrganization!) {
      final OrganizationSignUpModel organizationDetails =
          user.organizationDetails!;
      _organizationNameController.text =
          organizationDetails.legalOrganizationName!;
      _organizationDiscriptionContntroller.text =
          organizationDetails.discription!;
      _organizationType = organizationDetails.organizationType! == LLC_RADIO
          ? OrganizationTypes.LLC
          : organizationDetails.organizationType! == PARTNERSHIP_RADIO
              ? OrganizationTypes.PARTNERSHIP
              : organizationDetails.organizationType! == CORP_RADIO
                  ? OrganizationTypes.CORP
                  : OrganizationTypes.SOLE_PROP;
      nonProfitOrganization = organizationDetails.isNonProfitOrganization!;
      _organizationOtherContntroller.text = organizationDetails.other!;
      _organizationTaxIdNumberContntroller.text =
          organizationDetails.taxIdNumber!;
    }
    setState(() {});
  }

  // Future listenState() async {
  //   final States statesList = await _cityBloc.getStates();
  //   setState(() => states = statesList.states);
  // }

  // Future listenCities(String stateName) async {
  //   final Cities citiesList = await _cityBloc.getCities(stateName);
  //   setState(() => cities = citiesList.cities);
  // }

  Future postModifiedData() async {
    CircularLoader().show(context);
    late String profileUrl = '';
    if (_imageFile != null) {
      profileUrl = await convertAndUpload(_imageFile!);
    }
    final SignUpAndUserModel signUpAndUserModel = SignUpAndUserModel(
      name: _firstNameController.text + ' ' + _lastNameController.text,
      isOrganization: user.isOrganization,
      about: _aboutController.text,
      email: _emailController.text,
      gender: _genderController.text,
      address: addressLocation,
      // state: _stateController.text,
      // city: _cityController.text,
      // zipCode: _zipCodeController.text,
      countryCode: countryCode!.code!,
      personalPhnNo: _personalPhoneController.text,
      parentEmail: _parentEmailController.text,
      relationshipWithParent: _relationController.text,
      schoolName: schoolLocation,
      gradeLevel: _gradeLevelController.text,
      areaOfInterests: user.areaOfInterests,
      currentYearTargetHours: user.currentYearTargetHours,
      dateOfBirth: user.dateOfBirth,
      joiningDate: user.joiningDate,
      pointGifted: user.pointGifted,
      profileUrl: profileUrl.isEmpty ? user.profileUrl : profileUrl,
      rating: user.rating,
      reviewsByPersons: user.reviewsByPersons,
      volunteerType: user.volunteerType,
    );
    //Edit Organization
    if (user.isOrganization!) {
      final OrganizationSignUpModel organizationSignUpModel =
          OrganizationSignUpModel(
        isNonProfitOrganization: nonProfitOrganization,
        legalOrganizationName: _organizationNameController.text,
        discription: _organizationDiscriptionContntroller.text,
        organizationType: _organizationType.index == 0
            ? LLC_RADIO
            : _organizationType.index == 1
                ? PARTNERSHIP_RADIO
                : _organizationType.index == 2
                    ? CORP_RADIO
                    : SOLE_PROP_RADIO,
        other: _organizationOtherContntroller.text,
        otherAdmins: user.organizationDetails!.otherAdmins,
        taxIdNumber: _organizationTaxIdNumberContntroller.text,
      );
      signUpAndUserModel.organizationDetails = organizationSignUpModel;
    }
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
          user.name! + DateTime.now().millisecondsSinceEpoch.toString();

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
        title: EDIT_PROFILE_APPBAR,
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
                      if (user.parentEmail != null) {
                        if (user.parentEmail == _parentEmailController.text) {
                          await postModifiedData();
                        } else {
                          PlatformAlertDialog().show(context,
                              title: ALERT,
                              content:
                                  'Parent/Guardian email is not verified, Please verify your email.');
                        }
                      } else {
                        await postModifiedData();
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
              user.isOrganization!
                  ? SizedBox()
                  : user.schoolName != null && user.schoolName!.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.05,
                            right: width * 0.05,
                            bottom: width * 0.04,
                          ),
                          child: schoolInfo(),
                        )
                      : SizedBox(),
              user.isOrganization! ? organizationDetails() : SizedBox(),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: width * 0.05),
                width: double.infinity,
                child: CommonButton(
                  text: SAVE_BUTTON,
                  onPressed: () {},
                ),
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
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  TextfieldLabelSmall(label: FIRST_NAME),
                  CommonSimpleTextfield(
                    controller: _firstNameController,
                    hintText: ENTER_FIRST_NAME_HINT,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                children: [
                  TextfieldLabelSmall(label: LAST_NAME),
                  CommonSimpleTextfield(
                    controller: _lastNameController,
                    hintText: ENTER_LAST_NAME_HINT,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 15),
        TextfieldLabelSmall(label: ABOUT_TEXT),
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
        SizedBox(height: 15),
        TextfieldLabelSmall(label: EMAIL_LABEL),
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
        SizedBox(height: 15),
        TextfieldLabelSmall(label: DATE_OF_BIRTH_LABEL),
        CommonSimpleTextfield(
          readOnly: true,
          controller: _dateOfBirthController,
          hintText: SELECT_DATE_OF_BIRTH_HINT,
          validator: (val) => null,
        ),
        SizedBox(height: 15),
        TextfieldLabelSmall(label: GENDER_LABEL),
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
        addressLocationView(),
        // CommonSimpleTextfield(
        //   controller: _addressController,
        //   hintText: ADDRESS_HINT,
        //   validator: (val) => null,
        // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 15.0),
        //   child: Row(
        //     children: [
        //       Expanded(child: selectStateDropDown(states!)),
        //       cities!.isNotEmpty ? SizedBox(width: 10) : SizedBox(),
        //       cities!.isNotEmpty
        //           ? Expanded(child: selectCitiesDropDown(cities!))
        //           : SizedBox(),
        //     ],
        //   ),
        // ),
        // TextfieldLabelSmall(label: ZIPCODE_LABEL),
        // CommonSimpleTextfield(
        //   controller: _zipCodeController,
        //   hintText: ENTER_ZIP_CODE,
        //   validator: (val) => null,
        // ),
      ],
    );
  }

  Widget addressLocationView() {
    return Column(
      children: [
        CommonSimpleTextfield(
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: PRIMARY_COLOR,
            size: 18,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              addressPredictions.clear();
              addressLocation = '';
              _addressController.clear();
              setState(() {});
            },
            icon: Icon(
              Icons.close,
              color: PRIMARY_COLOR,
              size: 18,
            ),
          ),
          controller: _addressController,
          hintText: ADDRESS_HINT,
          validator: (val) => null,
          onChanged: (val) {
            if (val.isNotEmpty) {
              autoCompleteAddressSearch(val);
            } else {
              if (addressPredictions.length > 0 && mounted) {
                setState(() => addressPredictions = []);
              }
            }
          },
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: addressPredictions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () =>
                  getAddressDetails(addressPredictions[index].placeId!),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0, horizontal: width * 0.03),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.location,
                      color: PRIMARY_COLOR,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        addressPredictions[index].description!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        user.address != null && user.address!.isNotEmpty
            ? locationCard(user.address!)
            : addressLocation != null && addressLocation!.isNotEmpty
                ? locationCard(addressLocation!)
                : SizedBox(),
      ],
    );
  }

  Widget locationCard(String address) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        elevation: 0,
        color: GRAY,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: width * 0.05,
          ),
          title: Text(
            LOCATION,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            address,
            style: _theme.textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600,
              color: DARK_GRAY,
            ),
          ),
          trailing: Icon(
            CupertinoIcons.map_pin_ellipse,
            color: PRIMARY_COLOR,
          ),
        ),
      ),
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
        user.parentEmail != null && user.parentEmail!.isNotEmpty
            ? TextfieldLabelSmall(label: PARENT_GUARDIAN_EMAIL_LABEL)
            : SizedBox(),
        user.parentEmail != null && user.parentEmail!.isNotEmpty
            ? parentEmailSection()
            : SizedBox(),
        user.relationshipWithParent != null &&
                user.relationshipWithParent!.isNotEmpty
            ? TextfieldLabelSmall(label: RELATION_LABEL)
            : SizedBox(),
        user.relationshipWithParent != null &&
                user.relationshipWithParent!.isNotEmpty
            ? selectRelationshipDropdown()
            : SizedBox(),
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
                    : user.parentEmail == _parentEmailController.text
                        ? CupertinoIcons.checkmark_seal_fill
                        : CupertinoIcons.checkmark_seal,
                size: 18,
                color: snapshotEmailVerified.data!
                    ? ACCENT_GREEN
                    : user.parentEmail == _parentEmailController.text
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
          },
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: SmallCommonButton(
            fontSize: 12,
            text: SEND_VERIFICATION_CODE_BUTTON,
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (_parentEmailController.text.trim().isNotEmpty)
                _editProfileBloc
                    .sentOtpOfParentEmail(_parentEmailController.text);
              else
                PlatformAlertDialog().show(context,
                    title: ALERT, content: 'Parent/Guardian email is empty');
            },
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
      initialSelection: countryCode!.code,
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
        title: Text(SELECT_OPTION),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              CAMERA_OPTION,
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
              GALLERY_OPTION,
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
        icon: Icon(Icons.expand_more_rounded),
        validator: (val) {
          if (val != null && _genderController.text.isNotEmpty) {
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

  Widget schoolInfo() {
    return Column(
      children: [
        labelWithTopPadding(SCHOOL_INFO_LABEL),
        Column(
          children: [
            SizedBox(height: 10),
            TextfieldLabelSmall(label: SCHOOL_NAME_LABEL),
            schoolLocationView(),
            // schoolField(),
            SizedBox(width: 10),
            selectGradeDropDown(),
          ],
        ),
      ],
    );
  }

  Widget schoolLocationView() {
    return Column(
      children: [
        CommonSimpleTextfield(
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: PRIMARY_COLOR,
            size: 18,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              schoolPredictions.clear();
              schoolLocation = '';
              _schoolController.clear();
              setState(() {});
            },
            icon: Icon(
              Icons.close,
              color: PRIMARY_COLOR,
              size: 18,
            ),
          ),
          controller: _schoolController,
          hintText: SEARCH_SCHOOL_HINT,
          validator: (val) => null,
          onChanged: (val) {
            if (val.isNotEmpty) {
              autoCompleteSchoolSearch(val);
            } else {
              if (schoolPredictions.length > 0 && mounted) {
                setState(() => schoolPredictions = []);
              }
            }
          },
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: schoolPredictions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => getSchoolDetails(schoolPredictions[index].placeId!),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0, horizontal: width * 0.02),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.location,
                      color: PRIMARY_COLOR,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        schoolPredictions[index].description!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        user.schoolName != null && user.schoolName!.isNotEmpty
            ? locationCard(user.schoolName!)
            : schoolLocation != null && schoolLocation!.isNotEmpty
                ? locationCard(schoolLocation!)
                : SizedBox(),
      ],
    );
  }
  // Widget selectStateDropDown(List<StateModel> states) {
  //   return Column(
  //     children: [
  //       TextfieldLabelSmall(label: STATE_LABEL),
  //       DropdownButtonFormField<StateModel>(
  //         hint: Text(
  //           _stateController.text.isNotEmpty
  //               ? _stateController.text
  //               : states.isEmpty
  //                   ? 'Loading..'
  //                   : SEARCH_STATE_NAME_HINT,
  //         ),
  //         icon: Icon(Icons.expand_more_rounded),
  //         decoration: inputSimpleDecoration(getHint: SEARCH_STATE_NAME_HINT),
  //         isExpanded: true,
  //         onChanged: (StateModel? newValue) async {
  //           setState(() => _stateController.text = newValue!.stateName!);
  //           cities!.clear();
  //           listenCities(newValue!.stateName!);
  //         },
  //         validator: (val) {
  //           if (val == null) {
  //             return 'Please search state';
  //           }
  //           return null;
  //         },
  //         items: states.map<DropdownMenuItem<StateModel>>((StateModel? value) {
  //           return DropdownMenuItem<StateModel>(
  //             value: value,
  //             child: Text(
  //               value!.stateName!,
  //               textAlign: TextAlign.center,
  //               style: _theme.textTheme.bodyText2,
  //             ),
  //           );
  //         }).toList(),
  //       ),
  //     ],
  //   );
  // }

  // Widget selectCitiesDropDown(List<CityModel> cities) {
  //   return cities.isNotEmpty
  //       ? Column(
  //           children: [
  //             TextfieldLabelSmall(label: CITY_LABEL),
  //             DropdownButtonFormField<CityModel>(
  //                 hint: Text(_stateController.text.isEmpty
  //                     ? _cityController.text.isNotEmpty
  //                         ? _cityController.text
  //                         : SEARCH_CITY_NAME_HINT
  //                     : cities.isEmpty
  //                         ? 'Loading..'
  //                         : SEARCH_CITY_NAME_HINT),
  //                 icon: Icon(Icons.expand_more_rounded),
  //                 decoration:
  //                     inputSimpleDecoration(getHint: SEARCH_CITY_NAME_HINT),
  //                 isExpanded: true,
  //                 onChanged: (CityModel? newValue) {
  //                   setState(() {
  //                     _cityController.text = newValue!.cityName!;
  //                   });
  //                 },
  //                 validator: (val) {
  //                   if (val == null) {
  //                     return 'Please search city';
  //                   }
  //                   return null;
  //                 },
  //                 items: cities
  //                     .map<DropdownMenuItem<CityModel>>((CityModel? value) {
  //                   return DropdownMenuItem<CityModel>(
  //                     value: value,
  //                     child: Text(
  //                       value!.cityName!,
  //                       textAlign: TextAlign.center,
  //                       style: _theme.textTheme.bodyText2,
  //                     ),
  //                   );
  //                 }).toList()),
  //           ],
  //         )
  //       : SizedBox();
  // }

  Widget selectRelationshipDropdown() {
    return DropdownButtonFormField<String>(
      icon: Icon(Icons.expand_more_rounded),
      isExpanded: true,
      decoration: inputSimpleDecoration(
        getHint: _relationController.text.isNotEmpty
            ? _relationController.text
            : SELECT_RELATION_HINT,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _relationController.text = newValue!;
        });
      },
      validator: (val) {
        if (val != null && _relationController.text.isEmpty) {
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

  // Widget schoolField() {
  //   return Column(
  //     children: [
  //       SizedBox(height: 10),
  //       TextfieldLabelSmall(label: SCHOOL_NAME_LABEL),
  //       CommonSimpleTextfield(
  //         controller: _schoolController,
  //         readOnly: true,
  //         suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
  //         hintText: SEARCH_SCHOOL_HINT,
  //         validator: (val) {
  //           if (val!.isNotEmpty && val == SEARCH_SCHOOL_HINT) {
  //             return 'Please search school';
  //           }
  //           return null;
  //         },
  //         onTap: () async {
  //           final SchoolDetailsModel school =
  //               await SearchBottomSheet().modalBottomSheetMenu(
  //             context: context,
  //             searchBottomSheetType: SearchBottomSheetType.SCHOOL_BOTTOMSHEET,
  //             state: _stateController.text,
  //             city: _cityController.text,
  //           );
  //           setState(() {
  //             _schoolController.text = school.schoolName;
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget selectGradeDropDown() {
    return Column(
      children: [
        SizedBox(height: 10),
        TextfieldLabelSmall(label: GRADE_LEVEL_LABEL),
        DropdownButtonFormField<String>(
            hint: Text(_gradeLevelController.text.isNotEmpty
                ? _gradeLevelController.text
                : GRADE_HINT),
            icon: Icon(Icons.expand_more_rounded),
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

  Widget organizationDetails() {
    return StreamBuilder<bool>(
      initialData: organizationExpanded,
      stream: _editProfileBloc.getOrganizationDetailsExpandedStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() => organizationExpanded = !organizationExpanded);
                _editProfileBloc
                    .organizationDetailsIsExpanded(organizationExpanded);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: width * 0.06),
                child: Row(
                  children: [
                    Expanded(
                      child: SmallInfoLabel(label: ORGANIZATION_DETAILS_TEXT),
                    ),
                    Icon(
                      snapshot.data!
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                    ),
                  ],
                ),
              ),
            ),
            snapshot.data! ? expandedOrganizationDetails() : SizedBox(),
          ],
        );
      },
    );
  }

  Widget expandedOrganizationDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
      child: Column(
        children: [
          SizedBox(height: 15),
          TextfieldLabelSmall(label: LEGAL_ORGANIZATION_NAME_LABEL),
          organizationName(),
          SizedBox(height: 15),
          TextfieldLabelSmall(label: ORAGANIZATION_DISCRIPTION_LABEL),
          organizationDiscription(),
          SizedBox(height: 15),
          TextfieldLabelSmall(label: ORAGANIZATION_TYPE_LABEL),
          organizationTypes(),
          SizedBox(height: 15),
          TextfieldLabelSmall(label: OTHER_LABEL),
          organizationOtherType(),
          SizedBox(height: 15),
          TextfieldLabelSmall(label: TAX_ID_NUMBER_LABEL),
          taxIdNumber(),
        ],
      ),
    );
  }

  //Organization Details

  Widget organizationName() {
    return CommonSimpleTextfield(
      controller: _organizationNameController,
      hintText: ORGANIZATION_NAME_HINT,
      validator: (val) {
        if (val!.isEmpty) {
          return 'Please enter organization name';
        }
        return null;
      },
    );
  }

  Widget organizationDiscription() {
    return CommonSimpleTextfield(
      controller: _organizationDiscriptionContntroller,
      hintText: ORGANIZATION_DISCRIPTION_HINT,
      validator: (val) {
        if (val!.isEmpty) {
          return 'Please enter organization discription';
        }
        return null;
      },
    );
  }

  Widget organizationTypes() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RadioTile(
                  label: CORP_RADIO,
                  widget: Radio(
                    value: OrganizationTypes.CORP,
                    groupValue: _organizationType,
                    onChanged: (OrganizationTypes? value) {
                      setState(() => _organizationType = value!);
                    },
                  ),
                ),
                RadioTile(
                  label: LLC_RADIO,
                  widget: Radio(
                    value: OrganizationTypes.LLC,
                    groupValue: _organizationType,
                    onChanged: (OrganizationTypes? value) {
                      setState(() => _organizationType = value!);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RadioTile(
                  label: PARTNERSHIP_RADIO,
                  widget: Radio(
                    value: OrganizationTypes.PARTNERSHIP,
                    groupValue: _organizationType,
                    onChanged: (OrganizationTypes? value) {
                      setState(() => _organizationType = value!);
                    },
                  ),
                ),
                RadioTile(
                  label: SOLE_PROP_RADIO,
                  widget: Radio(
                    value: OrganizationTypes.SOLE_PROP,
                    groupValue: _organizationType,
                    onChanged: (OrganizationTypes? value) {
                      setState(() => _organizationType = value!);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: nonProfitOrganization,
              onChanged: (val) {
                setState(() => nonProfitOrganization = val!);
              },
            ),
            Text(
              NON_PROFIT_ORGANIZATION_CHECKBOX,
              style: _theme.textTheme.bodyText2!.copyWith(
                color: DARK_GRAY,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget organizationOtherType() {
    return CommonSimpleTextfield(
      controller: _organizationOtherContntroller,
      hintText: ENTER_STRUCTURE_HINT,
      validator: (val) {
        if (val!.isEmpty) {
          return 'Please enter structure';
        }
        return null;
      },
    );
  }

  Widget taxIdNumber() {
    return Row(
      children: [
        Expanded(
          child: CommonSimpleTextfield(
            controller: _organizationTaxIdNumberContntroller,
            hintText: TAX_ID_NUM_HINT,
            inputFormatters: [maskFormatter],
            validator: (val) {
              if (val!.isEmpty) {
                return 'Please enter tax id number';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 10),
        Text(
          '0/9',
          style: _theme.textTheme.bodyText2!
              .copyWith(fontWeight: FontWeight.w600, color: DARK_GRAY),
        ),
      ],
    );
  }
}
