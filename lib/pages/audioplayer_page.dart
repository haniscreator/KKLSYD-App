import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioPlayerPage extends StatefulWidget {
  final String audioUrl;
  final String title;
  final String image;
  final String description;

  const AudioPlayerPage({
    required this.audioUrl,
    required this.title,
    required this.image,
    required this.description,
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
          artUri: Uri.parse(
            widget.image.startsWith('http')
                ? widget.image
                : 'https://dummyimage.com/300.png/09f/fff',
          ),
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: colors.onSurface),
        ),
        leading: BackButton(color: colors.onSurface),
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:
                  widget.image.startsWith('http')
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

            const SizedBox(height: 16),

            // ✅ Description text under the image
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: colors.onSurface.withOpacity(0.8),
              ),
            ),

            const SizedBox(height: 24),

            // Slider
            Slider(
              activeColor: colors.primary,
              inactiveColor: colors.primary.withOpacity(0.3),
              value: _position.inSeconds.toDouble().clamp(
                0.0,
                _duration.inSeconds.toDouble(),
              ),
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
                Text(
                  _formatDuration(_position),
                  style: TextStyle(color: colors.onSurface),
                ),
                Text(
                  _formatDuration(_duration),
                  style: TextStyle(color: colors.onSurface),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Controls with labels
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _controlButton(
                  icon: Icons.replay_10,
                  label: "Rewind",
                  onTap: _skipBackward,
                ),
                const SizedBox(width: 32),
                StreamBuilder<bool>(
                  stream: _player.playingStream,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return _controlButton(
                      icon: isPlaying ? Icons.pause_circle : Icons.play_circle,
                      label: isPlaying ? "Pause" : "Play",
                      color: colors.primary,
                      size: 64,
                      onTap: () {
                        isPlaying ? _player.pause() : _player.play();
                      },
                    );
                  },
                ),
                const SizedBox(width: 32),
                _controlButton(
                  icon: Icons.forward_10,
                  label: "Forward",
                  onTap: _skipForward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
    double size = 40,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color ?? colors.onSurface),
          iconSize: size,
          onPressed: onTap,
        ),
        Text(label, style: TextStyle(color: colors.onSurface, fontSize: 12)),
      ],
    );
  }
}
