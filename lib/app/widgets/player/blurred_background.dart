import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BlurredBackground extends StatelessWidget {
  final Future<Uint8List?> artworkFuture;
  final double blurIntensity;
  final double opacity;
  final bool visible;

  const BlurredBackground({
    Key? key,
    required this.artworkFuture,
    this.blurIntensity = 30,
    this.opacity = 0.3,
    this.visible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Positioned.fill(
      child: FutureBuilder<Uint8List?>(
        future: artworkFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Stack(
              children: [
                Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurIntensity,
                    sigmaY: blurIntensity,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(opacity),
                  ),
                ),
              ],
            );
          } else {
            return Container(color: Colors.grey[900]);
          }
        },
      ),
    );
  }
}
