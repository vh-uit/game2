import 'package:peerdart/peerdart.dart';
import 'package:uuid/uuid.dart';

class P2PConnectionProvider {
    late Peer _peer;
    late String _peerId;
    DataConnection? _dataConnection;

    String get peerId => _peerId;

    Future<void> initializePeer({String? id}) async {
        _peerId = const Uuid().v4();
        _peer = Peer(id: _peerId);

        _peer.on('open').listen((_) {
            print('Peer ID: $_peerId');
        });
    }

    Future<void> connectToPeer(String remotePeerId) async {
        _dataConnection = _peer.connect(remotePeerId);
        _setupDataConnection(_dataConnection!);
    }

    void _setupDataConnection(DataConnection conn) {
        
        conn.on<String>('data').listen((data) {
            processData(data);
            print('Received: $data');
        });

        conn.on('close').listen((_) {
            print('Connection closed');
        });
    }

    void sendData(String data) {
        _dataConnection?.send(data);
    }

    void dispose() {
        _dataConnection?.close();
        _peer.dispose();
    }

    void processData(String data) {
        // Handle incoming data
        print('Processing data: $data');
    }
}