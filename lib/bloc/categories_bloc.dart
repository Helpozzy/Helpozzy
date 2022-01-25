import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/admin_selection_model.dart';
import 'package:rxdart/rxdart.dart';

class DashboardBloc {
  final repo = Repository();

  final menusController = PublishSubject<DashboardMenus>();

  Stream<DashboardMenus> get getDashBoardMenusStream => menusController.stream;

  Future getCategories() async {
    final DashboardMenus response = await repo.getDashBoardMenusRepo();
    menusController.sink.add(response);
  }

  void dispose() {
    menusController.close();
  }
}
