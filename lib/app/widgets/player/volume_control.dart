import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/theme/color.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';
import 'package:sizer/sizer.dart';

class VolumeControlWidget extends StatelessWidget {
  final SongsController playerController;

  const VolumeControlWidget({super.key, required this.playerController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(playerController.volume > 0
                ? Icons.volume_down
                : Icons.volume_off),
            onPressed: () => playerController.setVolume(0.0),
          ),
          Container(
            width: 60.w,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 1,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
              ),
              child: Slider(
                min: 0.0,
                max: 1.0,
                value: playerController.volume.value,
                activeColor: AppColors.vividOrange,
                inactiveColor: Colors.grey,
                onChanged: playerController.setVolume,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () => playerController.setVolume(1.0),
          ),
        ],
      );
    });
  }
}
