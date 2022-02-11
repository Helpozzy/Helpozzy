import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:rxdart/rxdart.dart';

class NotificationBloc {
  final repo = Repository();

  final notificationsController = PublishSubject<Notifications>();

  Stream<Notifications> get getNotificationsStream =>
      notificationsController.stream;

  Future getNotifications() async {
    final Notifications response = await repo.getNotificationsRepo();
    notificationsController.sink.add(response);
  }

  Future<ResponseModel> postNotification(NotificationModel notification) async {
    final ResponseModel response =
        await repo.postNotificationRepo(notification);
    return response;
  }

  Future<ResponseModel> updateNotifications(
      NotificationModel notification) async {
    final ResponseModel response =
        await repo.updateNotificationRepo(notification);
    return response;
  }

  void dispose() {
    notificationsController.close();
  }
}
