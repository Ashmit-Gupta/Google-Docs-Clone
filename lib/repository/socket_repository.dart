import 'package:google_docs_clone/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  //joining the room using the document id cause it will always be unique
  void joinRoom(String documentId) {
    _socketClient.emit('join', documentId);
  }

  //sending the data for the collaborative editing , as if i am editing and it shows in someones else document also
  void typing(Map<String, dynamic> data) {
    _socketClient.emit('typing', data);
  }

  //getting the data from the server if someone else is editing the document , and we will change the quill document from it
  void changeListener(Function(Map<String, dynamic>) func) {
    _socketClient.on('changes', (data) => func(data));
  }

  void autoSave(Map<String, dynamic> data) {
    _socketClient.emit('save', data);
  }
}
