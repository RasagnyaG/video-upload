import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final Function onTap;
  const PlayButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: GestureDetector(
      onTap: () => onTap(),
      child: Align(
          alignment: Alignment.center,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              size: 50.0,
              color: Colors.white,
            ),
          )),
    ));
  }
}
