import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/admin_selection_model.dart';
import 'package:rxdart/rxdart.dart';

class AdminCategoriesBloc {
  final repo = Repository();

  final adminCategoriesController = PublishSubject<AdminTypes>();

  Stream<AdminTypes> get getAdminCategoriesStream =>
      adminCategoriesController.stream;

  Future getCategories() async {
    final AdminTypes response = await repo.getAdminCategoriesRepo();
    adminCategoriesController.sink.add(response);
  }

  void dispose() {
    adminCategoriesController.close();
  }
}
