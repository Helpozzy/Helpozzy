import 'package:rxdart/rxdart.dart';

class LoginRxDartBloc {
  final PublishSubject<bool> showPasswordController = PublishSubject<bool>();

  Stream<bool> get showPassStream => showPasswordController.stream;

  Future changeShowPass(bool show) async {
    showPasswordController.sink.add(show);
  }

  void dispose() {
    showPasswordController.close();
  }
}
