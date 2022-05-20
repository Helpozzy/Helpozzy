import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/review_model.dart';
import 'package:rxdart/rxdart.dart';

class ProjectReviewsBloc {
  final repo = Repository();

  final projectReviewsController = PublishSubject<Reviews>();

  Stream<Reviews> get getProjectReviewsStream =>
      projectReviewsController.stream;

  Future<ResponseModel> postReview(ReviewModel reviewModel) async {
    final ResponseModel response = await repo.postReviewRepo(reviewModel);
    return response;
  }

  Future getProjectReviews(String projectId) async {
    final Reviews response = await repo.getProjectReviewsRepo(projectId);
    projectReviewsController.sink.add(response);
  }

  Future dispose() async {
    projectReviewsController.close();
  }
}
