import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      title: 'Appinio Video Player Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CachedVideoPlayerPlusController _videoPlayerController, _videoPlayerController2, _videoPlayerController3;

  late CustomVideoPlayerController _customVideoPlayerController;
  late CustomVideoPlayerWebController _customVideoPlayerWebController;

  final CustomVideoPlayerSettings _customVideoPlayerSettings = const CustomVideoPlayerSettings(showSeekButtons: true);

  final CustomVideoPlayerWebSettings _customVideoPlayerWebSettings = CustomVideoPlayerWebSettings(
    src: longVideo,
  );

  @override
  void initState() {
    super.initState();

    _videoPlayerController = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(longVideo),
    )..initialize().then((value) => setState(() {}));
    _videoPlayerController2 = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(video240),
    );
    _videoPlayerController3 = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(video480),
    );
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
      additionalVideoSources: {
        "240p": _videoPlayerController2,
        "480p": _videoPlayerController3,
        "720p": _videoPlayerController,
      },
    );

    _customVideoPlayerWebController = CustomVideoPlayerWebController(
      webVideoPlayerSettings: _customVideoPlayerWebSettings,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Appinio Video Player"),
      ),
      child: SafeArea(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            kIsWeb
                ? Expanded(
                    child: CustomVideoPlayerWeb(
                      customVideoPlayerWebController: _customVideoPlayerWebController,
                    ),
                  )
                : CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController,
                  ),
            CupertinoButton(
              child: const Text("Play Fullscreen"),
              onPressed: () {
                if (kIsWeb) {
                  _customVideoPlayerWebController.setFullscreen(true);
                  _customVideoPlayerWebController.play();
                } else {
                  _customVideoPlayerController.setFullscreen(true);
                  _customVideoPlayerController.videoPlayerController.play();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

String videoUrlLandscape = "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
String videoUrlPortrait =
    'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';
String longVideo =
    "https://nsp-images-dev.s3.amazonaws.com/b0c41a2b-a9ef-428c-8fbe-f536305c146c/5be5e5b9-45d0-489f-a258-f69578aab8bb.weba?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250416T132254Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIAYIYREEVWO6CU2MSL%2F20250416%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Expires=600&X-Amz-Signature=8f5eeca0636ed811389f0f19d455694a5d191ff5ebc2996da957fc9098d47ed0";

String video720 = "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4";

String video480 = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";

String video240 = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";
