import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';

class PlaylistDetailView extends StatefulWidget {
  const PlaylistDetailView({super.key});

  @override
  State<PlaylistDetailView> createState() => _PlaylistDetailViewState();
}

class _PlaylistDetailViewState extends State<PlaylistDetailView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/playlists');
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(left: width * 0.19),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Playlist Detail',
                style: CustomTheme.textTheme(context)
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
              Image.asset(
                'assets/icons/search.png',
                height: height * 0.029,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: Center(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: CustomTheme.customBoxDecoration(),
                  child: Image.asset(
                    'assets/icons/music_filter.png',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Image.asset(
              'assets/icons/music_square.png',
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.2, right: width * 0.2, top: height * 0.02),
              child: Text(
                'No Music Yet. Add Music by Pressing the Add Music Button',
                style: CustomTheme.textTheme(context).bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              width: width * 0.4,
              height: height * 0.05,
              decoration: BoxDecoration(
                color: CustomTheme.accentColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                  child: Text(
                'Add Music',
                style: CustomTheme.textTheme(context).bodyMedium,
              )),
            )
          ],
        ),
      ),
    );
  }
}
