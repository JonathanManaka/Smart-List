import 'package:flutter/material.dart';
import 'package:smart_grocery_list/routes/app_router.dart';
import 'package:video_player/video_player.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = VideoPlayerController.asset('assets/splashAnimation.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0.0);
    _playVideo();
  }

  void _playVideo() async {
    _controller.play();

    await Future.delayed(const Duration(seconds: 4));

    context.router.replace(HomeRoute());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        heightFactor: 50,
        widthFactor: 50,
        child: _controller.value.isInitialized
            ? Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: VideoPlayer(_controller),
                ),
              )
            : Container(),
      ),
    );
  }
}
