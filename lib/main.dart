import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:ohmyplayer/config/app_theme.dart';
import 'package:ohmyplayer/providers/livetv_player_provider.dart';
import 'package:ohmyplayer/providers/livetv_channels_provider.dart';
import 'package:ohmyplayer/pages/livetv_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

  Wakelock.enable();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LiveTvChannelsProvider()),
      ChangeNotifierProvider(create: (_) => LivePlayerProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LivePlayerProvider livePlayerProvider =
        context.watch<LivePlayerProvider>();

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: FGBGNotifier(
        // to detect the current state of the app.
        onEvent: (event) {
          if (event.toString() == 'FGBGType.background') {
            context.read<LivePlayerProvider>().player.stop();
          }
          if (event.toString() == 'FGBGType.foreground') {
            context
                .read<LivePlayerProvider>()
                .playVideo(livePlayerProvider.playingUrl);
          }
        },
        child: MaterialApp(
          theme: AppTheme.mainTheme(),
          debugShowCheckedModeBanner: false,
          title: 'Oh My Player',
          home: const LiveTvPage(),
        ),
      ),
    );
  }
}
