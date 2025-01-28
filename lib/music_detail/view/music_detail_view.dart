import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';

class MusicDetailView extends StatefulWidget {
  const MusicDetailView({super.key});

  @override
  State<MusicDetailView> createState() => _MusicDetailViewState();
}

class _MusicDetailViewState extends State<MusicDetailView> {
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
                'Music Detail',
                style: CustomTheme.textTheme(context)
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: Center(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: CustomTheme.customBoxDecoration()
                      .copyWith(color: Colors.white),
                  child: Image.asset(
                    'assets/icons/music_filter.png',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.12, top: height * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'music name',
                    style: CustomTheme.textTheme(context).bodyLarge,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    'date time',
                    style: CustomTheme.textTheme(context)
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
