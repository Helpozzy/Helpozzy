import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/admin_selection_model.dart';
import 'package:rxdart/rxdart.dart';

class AdminTypesBloc {
  final repo = Repository();

  final adminTypesController = PublishSubject<AdminTypes>();

  Stream<AdminTypes> get getAdminTypesStream => adminTypesController.stream;

  Future getCategories() async {
    final AdminTypes response = await repo.getAdminTypesRepo();
    adminTypesController.sink.add(response);
  }

  void dispose() {
    adminTypesController.close();
  }
}
