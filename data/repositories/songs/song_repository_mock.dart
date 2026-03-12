// song_repository_mock.dart

import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  int _fetchCount = 0;

  final List<Song> _songs = [
    Song(
      id: 's1',
      title: 'Mock Song 1',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 2, seconds: 50),
    ),
    Song(
      id: 's2',
      title: 'Mock Song 2',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's3',
      title: 'Mock Song 3',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's4',
      title: 'Mock Song 4',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's5',
      title: 'Mock Song 5',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
  ];

  @override
  Future<List<Song>> fetchSongs() async {
    _fetchCount++;

    await Future.delayed(const Duration(seconds: 3));

    if (_fetchCount % 2 == 0) {
      throw Exception('Failed to fetch songs from the server.');
    }

    return _songs;
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      return _songs.firstWhere((song) => song.id == id);
    } catch (_) {
      throw Exception('no song found for id $id in the database');
    }
  }
}