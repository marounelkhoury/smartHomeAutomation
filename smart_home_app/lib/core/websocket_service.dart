import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel channel = IOWebSocketChannel.connect('wss://example.com/ws');

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void dispose() {
    channel.sink.close();
  }
}