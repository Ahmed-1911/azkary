import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

final isPlayingProvider = StateProvider<bool>((ref) => false);
final currentPlayingIdProvider = StateProvider<String?>((ref) => null); 