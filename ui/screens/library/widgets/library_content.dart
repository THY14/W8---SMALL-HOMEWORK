import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';
import '../../../widgets/song/song_tile.dart';
import '../view_model/library_view_model.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    LibraryViewModel mv = context.watch<LibraryViewModel>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text("Library", style: AppTextStyles.heading),
          const SizedBox(height: 50),

          Expanded(child: _buildBody(mv)),
        ],
      ),
    );
  }

  Widget _buildBody(LibraryViewModel mv) {
    // Uncomplete
    if (mv.songsState is AsyncLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // ERROR
    if (mv.songsState is AsyncError) {
      final error = (mv.songsState as AsyncError).error;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: mv.retry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Complete
    final songs = (mv.songsState as AsyncData<List<Song>>).value;
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) => SongTile(
        song: songs[index],
        isPlaying: mv.isSongPlaying(songs[index]),
        onTap: () => mv.start(songs[index]),
      ),
    );
  }
}