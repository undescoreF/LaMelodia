import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:melodia/app/theme/color.dart';
import 'package:sizer/sizer.dart';

class CustomSearchBar extends StatefulWidget implements PreferredSizeWidget{
  CustomSearchBar({super.key, required this.search, required this.title});
  bool search;
  String title;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
  @override
  Size get preferredSize => Size.fromHeight(10.h);
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return widget.search ? AppBar(
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.vividOrange),
      //backgroundColor: Colors.white,
      title: SizedBox(
        height: 7.h,
        child: SearchBar(
          side: WidgetStatePropertyAll(BorderSide(color: AppColors.vividOrange,width: 1)),
          hintText: "Search...",
          leading: IconButton(
              onPressed:() => setState(() {widget.search=false;}),
              icon:Icon(LucideIcons.arrowLeft, size: 15,)).paddingOnly(right: 3.w),
          trailing: [
            Icon(LucideIcons.search, size: 15,).paddingOnly(right: 5.w)
          ],
        ),
      ).paddingOnly(top: 2.h),
      centerTitle: false,
      toolbarHeight: 10.h,
    ) : AppBar(
      iconTheme: const IconThemeData(color: AppColors.vividOrange),

      title: Text(widget.title, style: TextStyle(color: AppColors.vividOrange),).paddingOnly(left: 2.w),
      centerTitle: false,
      toolbarHeight: 10.h,
      actions: [
        IconButton(
            onPressed:() => setState(() {widget.search=true;}), icon:Icon(LucideIcons.search, size: 20,)),
        //Icon(Icons.more_vert, size: 25,).paddingOnly(right: 5.w),
      ],
    );
  }
}
