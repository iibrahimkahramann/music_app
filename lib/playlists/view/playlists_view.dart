import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/bar/appbar/app_bar.dart';
import 'package:music_app/bar/navbar/nav_bar.dart';
import 'package:music_app/config/theme/custom_theme.dart';

class PlaylistsView extends StatefulWidget {
  const PlaylistsView({super.key});

  @override
  State<PlaylistsView> createState() => _PlaylistsViewState();
}

class _PlaylistsViewState extends State<PlaylistsView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Playlist',
                    style: CustomTheme.textTheme(context).bodyLarge,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.65),
                    child: GestureDetector(
                      onTap: () {
                        if (Platform.isIOS) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController controller =
                                  TextEditingController();
                              return CupertinoAlertDialog(
                                title: Text('Add to Playlist'),
                                content: Column(
                                  children: <Widget>[
                                    Text(
                                        'Do you want to add this song to your playlist?'),
                                    CupertinoTextField(
                                      controller: controller,
                                      placeholder: 'Playlist name',
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text('Create'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/icons/add.png',
                        height: height * 0.035,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.015,
              ),
              GestureDetector(
                onTap: () => context.go('/playlist-detail'),
                child: Stack(
                  children: [
                    Container(
                      width: width,
                      height: height * 0.1,
                      color: Colors.black,
                    ),
                    Container(
                      width: width * 0.22,
                      height: height * 0.1,
                      decoration: CustomTheme.customBoxDecoration(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.25, height * 0.022, 0, height * 0.022),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Playlist1',
                                style:
                                    CustomTheme.textTheme(context).bodyMedium,
                              ),
                              SizedBox(
                                height: height * 0.002,
                              ),
                              Text('3 Music',
                                  style:
                                      CustomTheme.textTheme(context).bodySmall),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // GestureDetector(
              //   onTap: () => context.go('/playlist-detail'),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Container(
              //         alignment: Alignment.center,
              //         width: width * 0.22,
              //         height: height * 0.1,
              //         decoration: CustomTheme.customBoxDecoration(),
              //         child: Image.asset(
              //           'assets/icons/music_filter.png',
              //           height: height * 0.04,
              //           color: Colors.white,
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.only(
              //             left: width * 0.022, bottom: height * 0.008),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               'Song1',
              //               style: CustomTheme.textTheme(context).bodyMedium,
              //             ),
              //             SizedBox(
              //               height: height * 0.002,
              //             ),
              //             Text('3 Parça',
              //                 style: CustomTheme.textTheme(context).bodySmall),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentLocation: '/playlists'),
    );
  }
}
