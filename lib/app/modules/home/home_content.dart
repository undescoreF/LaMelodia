import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:melodia/app/theme/color.dart';
import 'package:melodia/app/widgets/bottom_bar.dart';
import 'package:sizer/sizer.dart';
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlueGray,
      drawer: const Drawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.vividOrange),
        title: const Text("Melodia"),
        centerTitle: false,
        actions: [
          Icon(LucideIcons.search, size: 25,).paddingOnly(right: 5.w)
        ],
      ),
    );
  }
}
