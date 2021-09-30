import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/admin_selection_model.dart';
import 'package:rxdart/rxdart.dart';

class AdminProjectsBloc {
  final repo = Repository();

  final adminTypesController = PublishSubject<AdminTypes>();
  final projectDetailsExpandController = PublishSubject<bool>();

  Stream<AdminTypes> get getAdminTypesStream => adminTypesController.stream;

  Stream<bool> get getProjectExpandStream =>
      projectDetailsExpandController.stream;

  Future getCategories() async {
    final AdminTypes response = await repo.getAdminTypesRepo();
    adminTypesController.sink.add(response);
  }

  Future isExpanded(bool isExpanded) async {
    projectDetailsExpandController.sink.add(isExpanded);
  }

  void dispose() {
    adminTypesController.close();
    projectDetailsExpandController.close();
  }
}
