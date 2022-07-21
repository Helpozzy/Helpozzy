import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:helpozzy/bloc/cities_bloc.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/auth/signup/organization_sign_up.dart';
import 'package:helpozzy/screens/auth/signup/6_target_and_area_of_interest.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import '4_contact_info.dart';

class LivingInfoScreen extends StatefulWidget {
  LivingInfoScreen({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;

  @override
  _LivingInfoScreenState createState() =>
      _LivingInfoScreenState(signupAndUserModel: signupAndUserModel);
}

class _LivingInfoScreenState extends State<LivingInfoScreen> {
  _LivingInfoScreenState({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;
  final _formKey = GlobalKey<FormState>();
  final CityBloc _cityInfoBloc = CityBloc();
  final TextEditingController _addressLocationController =
      TextEditingController();
  late ThemeData _theme;
  late double width;
  late double height;
  late GooglePlace googlePlace;
  late List<AutocompletePrediction> predictions = [];
  late DetailsResult? detailsResult;
  late String? location = '';
  late double latitude = 0.0;
  late double longitude = 0.0;
  late List<StateModel>? states = [];
  late List<CityModel>? cities = [];
  late bool showParentFields = false;

  @override
  void initState() {
    _cityInfoBloc.getStates();
    googlePlace = GooglePlace(ANDROID_MAP_API_KEY);
    super.initState();
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
      location = detailsResult!.formattedAddress!;
      latitude = detailsResult!.geometry!.location!.lat!;
      longitude = detailsResult!.geometry!.location!.lng!;
      _addressLocationController.clear();
      predictions.clear();
      setState(() {});
    }
  }

  Future onContinue() async {
    FocusScope.of(context).unfocus();
    signupAndUserModel.address = location;
    if (_formKey.currentState!.validate()) {
      if (location != null && location!.isNotEmpty) {
        if (signupAndUserModel.isOrganization!) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrganizationSignUp(signupAndUserModel: signupAndUserModel),
            ),
          );
        } else {
          final bool requiredParentInfo = await getAgeFromDOB();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => requiredParentInfo
                  ? ContactInfoScreen(signupAndUserModel: signupAndUserModel)
                  : TargetAndAreaOfInterest(
                      signupAndUserModel: signupAndUserModel),
            ),
          );
        }
      } else {
        ScaffoldSnakBar()
            .show(context, msg: 'Please select location to continue');
      }
    }
  }

  Future<bool> getAgeFromDOB() async {
    final dateOfBirth = DateTime.fromMillisecondsSinceEpoch(
        int.parse(signupAndUserModel.dateOfBirth!));
    final currentDate = DateTime.now();
    final Duration duration = currentDate.difference(dateOfBirth);
    final int diff = (duration.inDays / 365).floor();
    if (diff > 18)
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _theme = Theme.of(context);
    return GestureDetector(
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: SCREEN_BACKGROUND,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CommonWidget(context).showBackForwardButton(
                  onPressedForward: () => onContinue(),
                ),
                TopInfoLabel(label: RESIDENTAL_ADDRESS),
                addressLocationSelection(),
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
                predictions.clear();
                _addressLocationController.clear();
                setState(() {});
              },
              icon: Icon(
                Icons.close,
                color: PRIMARY_COLOR,
                size: 20,
              ),
            ),
            // label: PROJECT_LOCATION_LABEL,
            controller: _addressLocationController,
            hintText: PROJECT_LOCATION_HINT,
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
                      CupertinoIcons.location,
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
        location != null && location!.isNotEmpty
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
                        vertical: 4.0, horizontal: width * 0.05),
                    title: Text(
                      RESIDENTAL_ADDRESS,
                      style: _theme.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        location!,
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
}
