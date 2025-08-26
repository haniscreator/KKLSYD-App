import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioPlayerPage extends StatefulWidget {
  final String audioUrl;
  final String title;
  final String image;

  const AudioPlayerPage({
    required this.audioUrl,
    required this.title,
    required this.image,
    super.key,
  });

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    await _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(widget.audioUrl),
        tag: MediaItem(
          id: widget.audioUrl,
          album: "Dhamma Talks",
          title: widget.title,
          artUri: Uri.parse(widget.image.startsWith('http')
              ? widget.image
              : 'https://dummyimage.com/300.png/09f/fff'), // fallback if local
        ),
      ),
    );

    _player.durationStream.listen((d) {
      if (d != null) setState(() => _duration = d);
    });

    _player.positionStream.listen((p) {
      setState(() => _position = p);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _skipForward() {
    final newPos = _position + const Duration(seconds: 10);
    _player.seek(newPos < _duration ? newPos : _duration);
  }

  void _skipBackward() {
    final newPos = _position - const Duration(seconds: 10);
    _player.seek(newPos > Duration.zero ? newPos : Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: widget.image.startsWith('http')
                  ? Image.network(
                      widget.image,
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      widget.image,
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 24),
            Slider(
              value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
              min: 0,
              max: _duration.inSeconds.toDouble(),
              onChanged: (value) {
                final pos = Duration(seconds: value.toInt());
                _player.seek(pos);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position)),
                Text(_formatDuration(_duration)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_10),
                  iconSize: 40,
                  onPressed: _skipBackward,
                ),
                const SizedBox(width: 20),
                StreamBuilder<bool>(
                  stream: _player.playingStream,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle,
                        color: Colors.blue,
                      ),
                      iconSize: 64,
                      onPressed: () {
                        isPlaying ? _player.pause() : _player.play();
                      },
                    );
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.forward_10),
                  iconSize: 40,
                  onPressed: _skipForward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
