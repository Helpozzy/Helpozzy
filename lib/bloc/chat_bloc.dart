import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  final repo = Repository();
  final _chatHistoryController = BehaviorSubject<ChatList>();

  Stream<ChatList> get getChatListStream => _chatHistoryController.stream;

  Future getCurrentChatHistory() async {
    final ChatList chatList = await repo.getChatHistoryRepo();
    _chatHistoryController.sink.add(chatList);
  }

  void dispose() {
    _chatHistoryController.close();
  }
}
