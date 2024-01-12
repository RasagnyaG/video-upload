import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PickVideo extends StatefulWidget {
  final Function addVideo;
  const PickVideo({super.key, required this.addVideo});

  @override
  State<PickVideo> createState() => _PickVideoState();
}

class _PickVideoState extends State<PickVideo> {
  final _picker = ImagePicker();

  pickVideo(ImageSource source) async {
    try {
      final video = await _picker.pickVideo(source: source);
      if (video != null) {
        final appDocDir = await getApplicationDocumentsDirectory();

        String videoFileName = video.name;
        String videoFilePath = '${appDocDir.path}/$videoFileName';

        await video.saveTo(videoFilePath);
        widget.addVideo(File(video.path));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xFF051367),
          content: Text("Video Added"),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Couldn't upload the video"),
      ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("How do you want to upload", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () {
                pickVideo(ImageSource.gallery);
              },
              child: Text('Gallery', style: TextStyle(fontSize: 16)),
            ),
            TextButton(
                onPressed: () {
                  pickVideo(ImageSource.camera);
                },
                child: Text('Camera', style: TextStyle(fontSize: 16)))
          ],
        ));
  }
}
