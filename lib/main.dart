import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Audio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.playbackEventStream.listen((event) {
      setState(() {});
      print("OK");
    }, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    player.playingStream.listen((event) {
      setState(() {});
      print("OK");
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  File? audioFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<Duration?>(
                stream: player.positionStream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(
                      value: player.playing
                          ? (player.position.inSeconds /
                              player.duration!.inSeconds)
                          : 0,
                    ),
                  );
                }),
            RaisedButton(
                child: const Text(
                  "Pick File",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.audio,
                  );
                  if (result != null) {
                    audioFile = File(result.files.single.path);
                    await player.setFilePath(audioFile!.path);
                  } else {
                    // User canceled the picker
                  }
                  // final url = 'https://www.applesaucekids.com/sound%20effects/moo.mp3';
                  // await player.setUrl(url);
                }),
            RaisedButton(
                child: const Text(
                  "Play",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () async {
                  player.play();
                }),
            RaisedButton(
                child: const Text(
                  "Pause",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () async {
                  player.pause();
                }),
            RaisedButton(
                child: const Text(
                  "Stop",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () async {
                  player.stop();
                })
          ],
        ),
      ),
    );
  }
}
