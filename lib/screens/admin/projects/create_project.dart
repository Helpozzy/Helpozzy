import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_date_picker.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class CreateProject extends StatefulWidget {
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projNameController = TextEditingController();
  final TextEditingController _projDesController = TextEditingController();
  final TextEditingController _projStartDateController =
      TextEditingController();
  final TextEditingController _projEndDateController = TextEditingController();
  final TextEditingController _projOwnerController = TextEditingController();
  final TextEditingController _projCollaboraorController =
      TextEditingController();
  final TextEditingController _projMembersController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  late ThemeData _themeData;
  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(title: ADD_NEW_PROJECT_BUTTON),
      body: body(),
    );
  }

  Widget body() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CommonSimpleTextfield(
                      controller: _projNameController,
                      hintText: PROJECT_NAME_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter project name';
                        }
                        return null;
                      },
                    ),
                    CommonSimpleTextfield(
                      controller: _projDesController,
                      hintText: PROJECT_DESCRIPTION_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter project name';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonSimpleTextfield(
                            readOnly: true,
                            controller: _projStartDateController,
                            hintText: PROJECT_START_DATE_HINT,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return ' Select start date';
                              }
                              return null;
                            },
                            onTap: () {
                              CommonDatepicker()
                                  .showPicker(context,
                                      initialDate: _selectedStartDate)
                                  .then((pickedDate) {
                                if (pickedDate != null &&
                                    pickedDate != _selectedStartDate)
                                  setState(() {
                                    _selectedStartDate = pickedDate;
                                  });
                                _projStartDateController.value = TextEditingValue(
                                    text:
                                        '${DateFormat.yMd().format(_selectedStartDate)}');
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CommonSimpleTextfield(
                            readOnly: true,
                            controller: _projEndDateController,
                            hintText: PROJECT_END_HINT,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Select end date';
                              }
                              return null;
                            },
                            onTap: () {
                              CommonDatepicker()
                                  .showPicker(context,
                                      initialDate: _selectedEndDate)
                                  .then((pickedDate) {
                                if (pickedDate != null &&
                                    pickedDate != _selectedEndDate)
                                  setState(() {
                                    _selectedEndDate = pickedDate;
                                  });
                                _projEndDateController.value = TextEditingValue(
                                    text:
                                        '${DateFormat.yMd().format(_selectedEndDate)}');
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    CommonSimpleTextfield(
                      controller: _projOwnerController,
                      hintText: PROJECT_OWNERS_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter owner name';
                        }
                        return null;
                      },
                    ),
                    CommonSimpleTextfield(
                      controller: _projCollaboraorController,
                      hintText: PROJECT_COLLABORATOR_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter Collaborator/Co-admin';
                        }
                        return null;
                      },
                    ),
                    CommonSimpleTextfield(
                      controller: _projMembersController,
                      hintText: PROJECT_MEMBERS_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter members names';
                        }
                        return null;
                      },
                    ),
                    SmallInfoLabel(label: 'Projecct Status Tracking'),
                    SmallInfoLabel(label: 'Projecct Hours'),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: width * 0.2),
              child: CommonButton(
                text: ADD_PROJECT_BUTTON,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
