import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc {
  final repo = Repository();

  final categoriesController = PublishSubject<Categories>();

  Stream<Categories> get getCategoriesStream => categoriesController.stream;

  Future<bool> postCategories(List categories) async {
    final bool response = await repo.postCategoriesRepo(categories);
    return response;
  }

  Future getCategories() async {
    final Categories response = await repo.getCategoriesRepo();
    categoriesController.sink.add(response);
  }

  void dispose() {
    categoriesController.close();
  }
}
