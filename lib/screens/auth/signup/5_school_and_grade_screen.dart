import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/auth/signup/6_target_and_area_of_interest.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class SchoolAndGradeScreen extends StatefulWidget {
  SchoolAndGradeScreen({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;

  @override
  _SchoolAndGradeScreenState createState() =>
      _SchoolAndGradeScreenState(signupAndUserModel: signupAndUserModel);
}

class _SchoolAndGradeScreenState extends State<SchoolAndGradeScreen> {
  _SchoolAndGradeScreenState({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late ThemeData _theme;
  late String stateId = '';
  late double height;
  late double width;
  late List<StateModel> statesList = [];
  late List<String> citiesList = [];
  late List<SchoolDetailsModel> schoolsList = [];

  late GooglePlace googlePlace;
  late List<AutocompletePrediction> predictions = [];
  late DetailsResult? detailsResult;
  late String? addressName = '';
  late String? formatAddress = '';
  late double latitude = 0.0;
  late double longitude = 0.0;

  Future onContinue() async {
    FocusScope.of(context).unfocus();
    signupAndUserModel.schoolName = _schoolController.text;
    signupAndUserModel.gradeLevel = _gradeLevelController.text;
    if (_formKey.currentState!.validate()) {
      if ((addressName != null && addressName!.isNotEmpty) &&
          (formatAddress != null && formatAddress!.isNotEmpty)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TargetAndAreaOfInterest(signupAndUserModel: signupAndUserModel),
          ),
        );
      } else {
        ScaffoldSnakBar()
            .show(context, msg: 'Please Select school to continue');
      }
    }
  }

  Future<void> autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() => predictions = result.predictions!);
    }
  }

  Future<void> getDetails(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      detailsResult = result.result!;
      addressName = detailsResult!.name;
      formatAddress = detailsResult!.formattedAddress;
      latitude = detailsResult!.geometry!.location!.lat!;
      longitude = detailsResult!.geometry!.location!.lng!;
      _schoolController.clear();
      predictions.clear();
      setState(() {});
    }
  }

  @override
  void initState() {
    googlePlace = GooglePlace(ANDROID_MAP_API_KEY);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: SCREEN_BACKGROUND,
      body: GestureDetector(
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CommonWidget(context).showBackForwardButton(
                  onPressedForward: () => onContinue(),
                ),
                TopInfoLabel(label: SCHOOL_NAME),
                addressLocationSelection(),
                TopInfoLabel(label: GRADE_LEVEL),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.10),
                  child: selectGradeDropDown(),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: width * 0.06, horizontal: width * 0.1),
                  child: CommonButton(
                    text: CONTINUE_BUTTON,
                    onPressed: () => onContinue(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addressLocationSelection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: CommonRoundedTextfield(
            textAlignCenter: true,
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: PRIMARY_COLOR,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                longitude = 0.0;
                latitude = 0.0;
                formatAddress = '';
                predictions.clear();
                _schoolController.clear();
                setState(() {});
              },
              icon: Icon(
                Icons.close,
                color: PRIMARY_COLOR,
                size: 20,
              ),
            ),
            // label: PROJECT_LOCATION_LABEL,
            controller: _schoolController,
            hintText: SEARCH_SCHOOL_HINT,
            validator: (val) => null,
            onChanged: (val) {
              if (val.isNotEmpty) {
                autoCompleteSearch(val);
              } else {
                if (predictions.length > 0 && mounted) {
                  setState(() => predictions = []);
                }
              }
            },
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: predictions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => getDetails(predictions[index].placeId!),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: width * 0.1,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      color: PRIMARY_COLOR,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        predictions[index].description!,
                        maxLines: 3,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        (addressName != null && addressName!.isNotEmpty) &&
                (formatAddress != null && formatAddress!.isNotEmpty)
            ? Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0, horizontal: width * 0.08),
                child: Card(
                  elevation: 0,
                  color: WHITE,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: width * 0.05,
                    ),
                    title: Text(
                      addressName!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: _theme.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: DARK_GRAY_FONT_COLOR,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        formatAddress!,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: DARK_GRAY,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      CupertinoIcons.map_pin_ellipse,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Widget selectGradeDropDown() {
    return DropdownButtonFormField<String>(
      icon: Icon(Icons.expand_more_rounded),
      decoration: inputRoundedDecoration(
        getHint: SELECT_GRADE_HINT,
        isDropDown: true,
      ),
      isExpanded: true,
      onChanged: (String? newValue) {
        setState(() => _gradeLevelController.text = newValue!);
      },
      validator: (val) {
        if (val == null) {
          return 'Please select grade';
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
      }).toList(),
    );
  }
}
