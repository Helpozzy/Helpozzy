import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/profile_bloc.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_details.dart';
import 'package:helpozzy/screens/dashboard/projects/volunteer_sign_up.dart';
import 'package:helpozzy/screens/dashboard/projects/project_card.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class CategorisedProjectsScreen extends StatefulWidget {
  const CategorisedProjectsScreen(
      {required this.category, required this.fromPrefs});
  final CategoryModel category;
  final bool fromPrefs;

  @override
  _CategorisedProjectsScreenState createState() =>
      _CategorisedProjectsScreenState(category: category, fromPrefs: fromPrefs);
}

class _CategorisedProjectsScreenState extends State<CategorisedProjectsScreen> {
  _CategorisedProjectsScreenState(
      {required this.category, required this.fromPrefs});
  final CategoryModel category;
  final bool fromPrefs;
  late ThemeData _theme;
  late double height;
  late double width;
  final ProjectsBloc _projectsBloc = ProjectsBloc();
  final ProfileBloc _profileBloc = ProfileBloc();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    if (fromPrefs)
      _profileBloc.getPrefsProjects(categoryId: category.id!, searchText: '');
    else
      _projectsBloc.getCategorisedProjects(
        categoryId: category.id!,
        searchText: '',
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: WHITE,
        appBar: CommonAppBar(context).show(
          elevation: 0,
          title: category.label!,
          bottom: topSearchWithTab(),
        ),
        body: projectListView(),
      ),
    );
  }

  PreferredSize topSearchWithTab() => PreferredSize(
        preferredSize: Size(width, width / 12),
        child: Container(
          height: 37,
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          margin: EdgeInsets.only(bottom: 5.0),
          child: CommonRoundedTextfield(
            textAlignCenter: false,
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: DARK_MARUN,
              size: 18,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                _searchController.clear();
                fromPrefs
                    ? _profileBloc.getPrefsProjects(
                        categoryId: category.id!,
                        searchText: '',
                      )
                    : _projectsBloc.getCategorisedProjects(
                        categoryId: category.id!,
                        searchText: '',
                      );
              },
              icon: Icon(
                CupertinoIcons.clear,
                color: DARK_MARUN,
                size: 18,
              ),
            ),
            fillColor: GRAY,
            controller: _searchController,
            hintText: TYPE_KEYWORD_HINT,
            onChanged: (val) => fromPrefs
                ? _profileBloc.getPrefsProjects(
                    categoryId: category.id!,
                    searchText: val,
                  )
                : _projectsBloc.getCategorisedProjects(
                    categoryId: category.id!,
                    searchText: val,
                  ),
            validator: (val) => null,
          ),
        ),
      );

  Widget projectListView() {
    return StreamBuilder<List<ProjectModel>>(
      stream: fromPrefs
          ? _profileBloc.getPrefsProjectStream
          : _projectsBloc.getCategorisedSignedUpProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LinearLoader(),
            ),
          );
        }
        return snapshot.data!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final ProjectModel project = snapshot.data![index];
                  return ProjectCard(
                    project: project,
                    onProjectLiked: () =>
                        setState(() => project.isLiked = !project.isLiked!),
                    onTapCard: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetailsInfo(project: project),
                      ),
                    ),
                    onPressedSignUpButton: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VolunteerProjectTaskSignUp(project: project),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        NO_PROJECTS_FOUNDS,
                        style: _theme.textTheme.headline5!.copyWith(
                            color: DARK_GRAY, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        PLEASE_VISIT_OTHER,
                        textAlign: TextAlign.center,
                        style: _theme.textTheme.bodyText2!
                            .copyWith(color: DARK_GRAY),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
