import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

// my app bar
/// My App Bar
class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  MyAppBar({
    Key ? key,
    required this.drawerKey,
  }): super(key: key);
  GlobalKey < SliderDrawerState > drawerKey;

  @override
  State < MyAppBar > createState() => _MyAppBarState();

  @override
  Size get preferredSize =>
    const Size.fromHeight(100);
}

class _MyAppBarState extends State < MyAppBar > with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isDrawerOpen = false;
 @override
    void initState() {
      super.initState();

      controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      );
    }
    @override
    void dispose() {
      controller.dispose();
      super.dispose();
    }
   /// toggle for drawer and icon aniamtion
    void toggle() {
      setState(() {
        isDrawerOpen = !isDrawerOpen;
        if (isDrawerOpen) {
          controller.forward();
          widget.drawerKey.currentState!.openSlider();
        } else {
          controller.reverse();
          widget.drawerKey.currentState!.closeSlider();
        }
      });
    }
     @override
    Widget build(BuildContext context) {
      return SizedBox(
      
        width: double.infinity,
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.only(bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Animated Icon - Menu & Close
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      color: Colors.grey[300],
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.menu_close,
                        progress: controller,
                        size: 40,
                      ),
                      onPressed: toggle),
                ),
              ],
            ),
        ),
      );
    }
}