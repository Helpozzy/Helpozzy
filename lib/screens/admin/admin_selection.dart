import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_types_bloc.dart';
import 'package:helpozzy/models/admin_selection_model.dart';
import 'package:helpozzy/screens/admin/projects/projects_screen.dart';
import 'package:helpozzy/screens/admin/volunteers/volunteer_screen.dart';
import 'package:helpozzy/screens/user/common_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class AdminSelectionScreen extends StatefulWidget {
  @override
  _AdminSelectionScreenState createState() => _AdminSelectionScreenState();
}

class _AdminSelectionScreenState extends State<AdminSelectionScreen> {
  final AdminTypesBloc _adminTypesBloc = AdminTypesBloc();
  late double height;
  late double width;
  late ThemeData _theme;

  @override
  void initState() {
    _adminTypesBloc.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopAppLogo(height: height / 6.5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Text(
                'Hello, John Smith',
                textAlign: TextAlign.center,
                style: _theme.textTheme.headline6!.copyWith(
                  color: DARK_PINK_COLOR,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: typeSelectionGrid()),
          ],
        ),
      ),
    );
  }

  Widget typeSelectionGrid() {
    return StreamBuilder<AdminTypes>(
      stream: _adminTypesBloc.getAdminTypesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: PRIMARY_COLOR));
        }
        return GridView.count(
          physics: ScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: 1,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          children: snapshot.data!.item.map((AdminTypeModel type) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => type.id == 0
                        ? ProjectsScreen(title: type.label)
                        : type.id == 1
                            ? VolunteerScreen(title: type.label)
                            : CommonSampleScreen('No Available'),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Image.network(
                          type.imgUrl,
                          fit: BoxFit.fill,
                          height: width / 5,
                          width: width / 5,
                        ),
                      ),
                      CommonDivider(),
                      Text(
                        type.label.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: _theme.textTheme.headline6!.copyWith(
                          color: DARK_PINK_COLOR,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
