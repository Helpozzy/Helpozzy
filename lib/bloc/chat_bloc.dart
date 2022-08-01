import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/models/message_model.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  final repo = Repository();
  final _projectChatHistoryController = BehaviorSubject<ChatList>();
  final _projectMessagesController = BehaviorSubject<Chats>();
  final _groupMessagesController = BehaviorSubject<Chats>();

  Stream<ChatList> get getChatListStream =>
      _projectChatHistoryController.stream;
  Stream<Chats> get getProjectMessagesStream =>
      _projectMessagesController.stream;
  Stream<Chats> get getGroupMessagesStream => _groupMessagesController.stream;

  Future getProjectChatHistory(String projectId) async {
    final ChatList chatList = await repo.getProjectChatHistoryRepo(projectId);
    _projectChatHistoryController.sink.add(chatList);
  }

  Future getProjectChat(String projectId, String groupChatId, int limit) async {
    final Chats messages =
        await repo.getProjectMessagesRepo(projectId, groupChatId, limit);
    _projectMessagesController.sink.add(messages);
  }

  Future getGroupChat(String projectId, int limit) async {
    final Chats messages = await repo.getGroupMessagesRepo(projectId, limit);
    _groupMessagesController.sink.add(messages);
  }

  void dispose() {
    _projectChatHistoryController.close();
    _projectMessagesController.close();
    _groupMessagesController.close();
  }
}
