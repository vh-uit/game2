import 'dart:convert';
import 'localnet.dart';

class PlayersProvider extends P2PConnectionProvider {
  @override
  void processData(String data) {
    final Map<String, dynamic> jsonData = json.decode(data);
    final String type = jsonData['type'];
    final dynamic content = jsonData['content'];
    final String playerId = jsonData['playerId'];

    // Handle the received data as needed
    // Example:
    print('Type: $type, Content: $content, PlayerId: $playerId');
  }
}