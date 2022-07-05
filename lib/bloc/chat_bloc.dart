import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/models/message_model.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  final repo = Repository();
  final _chatHistoryController = BehaviorSubject<ChatList>();
  final _messagesController = BehaviorSubject<Chats>();
  final _groupMessagesController = BehaviorSubject<Chats>();

  Stream<ChatList> get getChatListStream => _chatHistoryController.stream;
  Stream<Chats> get getMessagesStream => _messagesController.stream;
  Stream<Chats> get getGroupMessagesStream => _groupMessagesController.stream;

  Future getCurrentChatHistory(String projectId) async {
    final ChatList chatList = await repo.getChatHistoryRepo(projectId);
    _chatHistoryController.sink.add(chatList);
  }

  Future getChat(String projectId, String groupChatId, int limit) async {
    final Chats messages =
        await repo.getMessagesRepo(projectId, groupChatId, limit);
    _messagesController.sink.add(messages);
  }

  Future getGroupChat(String projectId, int limit) async {
    final Chats messages = await repo.getGroupMessagesRepo(projectId, limit);
    _groupMessagesController.sink.add(messages);
  }

  void dispose() {
    _chatHistoryController.close();
    _messagesController.close();
    _groupMessagesController.close();
  }
}
