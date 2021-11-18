import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_categories_bloc.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/signup_model.dart';
import 'package:helpozzy/screens/auth/signup/password_set_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class AreaOfInterest extends StatefulWidget {
  AreaOfInterest({required this.signUpModel});
  final SignUpModel signUpModel;

  @override
  State<AreaOfInterest> createState() =>
      _AreaOfInterestState(signUpModel: signUpModel);
}

class _AreaOfInterestState extends State<AreaOfInterest> {
  _AreaOfInterestState({required this.signUpModel});
  final SignUpModel signUpModel;

  final CategoryBloc _categoryBloc = CategoryBloc();
  late double width;
  late double height;
  late ThemeData _theme;
  late List<int> selectedAreaOfInterests = [];

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
                  child: Column(
                    children: [
                      CommonWidget(context).showBackButton(),
                      TopInfoLabel(label: CHOOSE_YOUR_AREA_OF_INTEREST),
                      categoryView(categories),
                    ],
                  ),
                ),
              ),
              Container(
                margin: bottomContinueBtnEdgeInsets(width, height),
                width: double.infinity,
                child: CommonButton(
                  text: CONTINUE_BUTTON,
                  onPressed: () async =>
                      await getSelectedCategories(categories),
                ),
              ),
            ],
          );
        },
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
    signUpModel.areaOfInterests = selectedAreaOfInterests;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetPasswordScreen(signUpModel: signUpModel),
      ),
    );
  }
}
