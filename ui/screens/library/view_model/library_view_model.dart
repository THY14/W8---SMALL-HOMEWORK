import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';

// AsyncValue and its 3 subclasses represent the 3 states of an async operation
abstract class AsyncValue<T> {}

class AsyncLoading<T> extends AsyncValue<T> {}

class AsyncError<T> extends AsyncValue<T> {
  final Object error;
  AsyncError(this.error);
}

class AsyncData<T> extends AsyncValue<T> {
  final T value;
  AsyncData(this.value);
}

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;

  AsyncValue<List<Song>> songsState = AsyncLoading();

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  Future<void> _init() async {
    songsState = AsyncLoading();
    notifyListeners();

    try {
      final songs = await songRepository.fetchSongs();
      songsState = AsyncData(songs);
    } catch (e) {
      songsState = AsyncError(e);
    }

    notifyListeners();
  }
  Future<void> retry() => _init();

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}