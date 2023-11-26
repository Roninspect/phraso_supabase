// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:phraso/models/phrases_model.dart';

class PlayButton extends ConsumerStatefulWidget {
  final PhrasesModel phrasesModel;
  const PlayButton({
    super.key,
    required this.phrasesModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayButtonState();
}

class _PlayButtonState extends ConsumerState<PlayButton> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });
    audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        duration = Duration.zero;
      });
    });
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.stop);
    String url = widget.phrasesModel.audioLink;

    await audioPlayer.setSourceUrl(url);
    duration = await audioPlayer.getDuration();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 19,
      backgroundColor: Colors.black,
      child: Center(
        child: CircleAvatar(
          radius: 17,
          child: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 2.0),
              child: GestureDetector(
                  onTap: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.resume();
                    }
                  },
                  child: isPlaying
                      ? const Padding(
                          padding: EdgeInsets.only(right: 2.0, top: 1),
                          child: Icon(Icons.pause),
                        )
                      : const Icon(Ionicons.play_outline))),
        ),
      ),
    );
  }
}
