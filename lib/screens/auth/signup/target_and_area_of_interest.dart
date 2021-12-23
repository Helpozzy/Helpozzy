import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_categories_bloc.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/auth/signup/password_set_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class TargetAndAreaOfInterest extends StatefulWidget {
  TargetAndAreaOfInterest({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;

  @override
  State<TargetAndAreaOfInterest> createState() =>
      _TargetAndAreaOfInterestState(signupAndUserModel: signupAndUserModel);
}

class _TargetAndAreaOfInterestState extends State<TargetAndAreaOfInterest> {
  _TargetAndAreaOfInterestState({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;

  static final _formKey = GlobalKey<FormState>();
  final CategoryBloc _categoryBloc = CategoryBloc();
  late double width;
  late double height;
  late ThemeData _theme;
  late double trackerVal = 0.0;
  late List<int> selectedAreaOfInterests = [];
  final TextEditingController _targetHoursController = TextEditingController();

  @override
  void initState() {
    _categoryBloc.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: SCREEN_BACKGROUND,
      body: StreamBuilder<Categories>(
        stream: _categoryBloc.getCategoriesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: CircularProgressIndicator(color: PRIMARY_COLOR),
              ),
            );
          }
          final List<CategoryModel> categories = snapshot.data!.categories;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CommonWidget(context).showBackButton(),
                        TopInfoLabel(label: CURRENT_YEAR_TARGET_HOURS),
                        targetFields(),
                        TopInfoLabel(label: CHOOSE_YOUR_AREA_OF_INTEREST),
                        categoryView(categories),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: bottomContinueBtnEdgeInsets(width, height),
                width: double.infinity,
                child: CommonButton(
                  text: CONTINUE_BUTTON,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await getSelectedCategories(categories);
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget targetFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '0',
                style: _theme.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Slider(
                  min: 0,
                  max: 225,
                  label: trackerVal.round().toString(),
                  value: trackerVal,
                  activeColor: PRIMARY_COLOR,
                  divisions: 9,
                  onChanged: (value) {
                    setState(() => trackerVal = value);
                    if (trackerVal.round() == 225) {
                      showSnakeBar(context, msg: 'Enter your hrs in field');
                    }
                  },
                ),
              ),
              Text(
                '200 +',
                style: _theme.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              trackerVal >= 225.0
                  ? Expanded(
                      child: CommonRoundedTextfield(
                        controller: _targetHoursController,
                        hintText: ENTER_TARGET_HOURS_HINT,
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          setState(() => _targetHoursController.selection =
                              TextSelection.fromPosition(
                                  TextPosition(offset: val.length)));
                        },
                        validator: (phone) {
                          if (phone!.isEmpty) {
                            return 'Please enter estimated hours';
                          } else {
                            return null;
                          }
                        },
                      ),
                    )
                  : SizedBox(),
              trackerVal >= 225.0 ? SizedBox(width: 15) : SizedBox(),
              Column(
                children: [
                  TextfieldLabelSmall(label: SELECTED_HOURS_LABEL),
                  Text(
                    trackerVal.round() == 225
                        ? '200+'
                        : trackerVal.round().toString(),
                    style: _theme.textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget categoryView(List<CategoryModel> categories) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (2), childAspectRatio: 2.2),
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      itemBuilder: (context, index) {
        final CategoryModel category = categories[index];
        return Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: width * 0.03),
            child: Row(
              children: [
                CachedNetworkImage(
                  placeholder: (context, url) => Center(
                    child: LinearLoader(minheight: 10),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline_rounded),
                  imageUrl: category.imgUrl,
                  fit: BoxFit.fill,
                  color: PRIMARY_COLOR,
                  height: width * 0.09,
                  width: width * 0.09,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category.label,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: _theme.textTheme.bodyText2!.copyWith(
                      fontSize: 12,
                      color: DARK_GRAY_FONT_COLOR,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Checkbox(
                  value: category.isSelected,
                  activeColor: DARK_GRAY,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  onChanged: (val) =>
                      setState(() => category.isSelected = val!),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getSelectedCategories(List<CategoryModel> categories) async {
    selectedAreaOfInterests = [];
    categories.forEach((category) {
      if (category.isSelected) {
        selectedAreaOfInterests.add(category.id);
      }
    });
    signupAndUserModel.currentYearTargetHours = trackerVal.round() <= 225
        ? trackerVal.round()
        : int.parse(_targetHoursController.text);
    signupAndUserModel.areaOfInterests = selectedAreaOfInterests;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SetPasswordScreen(signupAndUserModel: signupAndUserModel),
      ),
    );
  }
}
