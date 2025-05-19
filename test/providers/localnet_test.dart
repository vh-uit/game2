import 'package:flutter_test/flutter_test.dart';
import 'package:game2/providers/localnet.dart';

void main() {
  group('P2PConnectionProvider', () {
    test('initializes and exposes peerId', () async {
      final provider1 = P2PConnectionProvider();
      await provider1.initializePeer();
      print('provider1: $provider1');
      final provider2 = P2PConnectionProvider();
      await provider2.initializePeer();
      print('provider2: $provider2');
      expect(provider1.peerId, isNotEmpty);
      expect(provider2.peerId, isNotEmpty);

      provider1.connectToPeer(provider2.peerId);
      print('Connected to peer: ${provider2.peerId}');
      await Future.delayed(const Duration(seconds: 1));
      provider1.dispose();
      provider2.dispose();
    });
  });
}
