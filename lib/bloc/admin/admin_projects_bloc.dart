import 'package:helpozzy/firebase_repository/repository.dart';

import 'package:rxdart/rxdart.dart';

class AdminProjectsBloc {
  final repo = Repository();

  final projectDetailsExpandController = PublishSubject<bool>();

  Stream<bool> get getProjectExpandStream =>
      projectDetailsExpandController.stream;

  Future isExpanded(bool isExpanded) async {
    projectDetailsExpandController.sink.add(isExpanded);
  }

  void dispose() {
    projectDetailsExpandController.close();
  }
}
