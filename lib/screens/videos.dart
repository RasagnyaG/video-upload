import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_upload/widgets/pick_vid_dialog.dart';

import '../widgets/video.dart';

final localstorage = LocalStorage("videos");

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  List<File> videos = [];
  onPressed() {
    showDialog(
        context: context, builder: (context) => PickVideo(addVideo: addVideo));
  }

  addVideo(File video) {
    setState(() {
      videos.add(video);
    });
  }

  loadVideos() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = appDocDir.listSync();
    List<File> mp4Files = files
        .where((file) =>
            file is File &&
            (file.path.endsWith('.MOV') || file.path.endsWith('.mp4')))
        .map((file) => File(file.path))
        .toList();

    setState(() {
      videos = mp4Files;
    });
  }

  deleteVideos() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> files = appDocDir.listSync();
      for (var file in files) {
        if (file is File) {
          await file.delete();
        } else if (file is Directory) {
          await file.delete(recursive: true);
        }
      }

      setState(() {
        videos = [];
      });
    } catch (e) {
      print('Error deleting videos: $e');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVideos();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBAD7E9),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Videos'),
        titleTextStyle: const TextStyle(
            fontSize: 30,
            color: Color(0xFF041C32),
            fontWeight: FontWeight.bold),
        backgroundColor: Color(0xFFBAD7E9),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3E6D9C),
                    foregroundColor: Colors.white),
                onPressed: deleteVideos,
                child: const Text('Delete All Videos')),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: videos.length,
              itemBuilder: (context, index) => VideoWidget(
                    video: videos[index],
                  )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
