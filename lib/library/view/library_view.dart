import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/db/app_database.dart';
import 'package:music_app/library/provider/library_provider.dart';
import 'package:music_app/library/provider/selected_music_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:music_app/services/navigation_service.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/bar/appbar/app_bar.dart';
import 'package:music_app/bar/navbar/nav_bar.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final AppDatabase db = AppDatabase();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isPickingFile = ref.watch(filePickerProvider);
    final filePickerNotifier = ref.read(filePickerProvider.notifier);
    final musicFilesAsyncValue = ref.watch(musicFilesProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: musicFilesAsyncValue.when(
        data: (musicFiles) {
          NavigationService().setContext(context);
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02, vertical: height * 0.02),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Library',
                        style: CustomTheme.textTheme(context).bodyLarge,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.56),
                        child: Image.asset(
                          'assets/icons/mix.png',
                          height: height * 0.029,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.05),
                        child: GestureDetector(
                          onTap: isPickingFile
                              ? null // Eğer zaten dosya seçiliyorsa tıklamayı devre dışı bırak
                              : () async {
                                  await filePickerNotifier.pickMusicFile();
                                },
                          child: Image.asset(
                            'assets/icons/add.png',
                            height: height * 0.029,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  FutureBuilder<List<MusicFile>>(
                    future: db.getAllMusicFiles(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Hata: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/json/not_music.json',
                                  width: width * 0.6),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.2,
                                    right: width * 0.2,
                                    top: height * 0.0),
                                child: Text(
                                  'No Music Yet. Add Music by Pressing the Add Music Button',
                                  style:
                                      CustomTheme.textTheme(context).bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              GestureDetector(
                                onTap: isPickingFile
                                    ? null
                                    : () async {
                                        await filePickerNotifier
                                            .pickMusicFile();
                                      },
                                child: Container(
                                  width: width * 0.4,
                                  height: height * 0.05,
                                  decoration: BoxDecoration(
                                    color: CustomTheme.accentColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'Add Music',
                                    style: CustomTheme.textTheme(context)
                                        .bodyMedium,
                                  )),
                                ),
                              )
                            ],
                          ),
                        );
                      }

                      final musicFiles = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: musicFiles.length,
                        itemBuilder: (context, index) {
                          final music = musicFiles[index];

                          return GestureDetector(
                            // onTap: () {
                            //   final currentIndex = musicFiles.indexOf(music);
                            //   NavigationService().navigateToMusicDetail(
                            //     music,
                            //     musicFiles,
                            //     currentIndex,
                            //   );
                            // },
                            onTap: () {
                              ref.read(selectedMusicProvider.notifier).state =
                                  music;
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: width,
                                  height: height * 0.1,
                                  margin:
                                      EdgeInsets.only(bottom: height * 0.015),
                                  decoration: CustomTheme.customBoxDecoration(),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(width * 0.03,
                                      height * 0.013, 0, height * 0.013),
                                  child: Container(
                                    width: width * 0.16,
                                    height: width * 0.16,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.music_note_rounded,
                                        size: width * 0.1),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(width * 0.22,
                                      height * 0.022, 0, height * 0.022),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            music.fileName.length > 23
                                                ? '${music.fileName.substring(0, 23)}...'
                                                : music.fileName,
                                            style:
                                                CustomTheme.textTheme(context)
                                                    .bodyMedium,
                                          ),
                                          SizedBox(
                                            height: height * 0.002,
                                          ),
                                          Text(
                                            music.createdAt != null
                                                ? '${music.createdAt!.day}/${music.createdAt!.month}/${music.createdAt!.year}'
                                                : 'Tarih bilgisi yok',
                                            style:
                                                CustomTheme.textTheme(context)
                                                    .bodySmall,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width * 0.12,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width * 0.045,
                                            top: height * 0.001),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      height: height * 0.3,
                                                      child: Column(
                                                        children: <Widget>[
                                                          ListTile(
                                                            leading: Icon(Icons
                                                                .music_note_sharp),
                                                            title: Text(
                                                              music.fileName
                                                                          .length >
                                                                      30
                                                                  ? '${music.fileName.substring(0, 30)}...'
                                                                  : music
                                                                      .fileName,
                                                              style: CustomTheme
                                                                      .textTheme(
                                                                          context)
                                                                  .bodyMedium,
                                                            ),
                                                          ),
                                                          ListTile(
                                                            leading: Icon(Icons
                                                                .format_list_bulleted_sharp),
                                                            title: Text(
                                                              'Çalma Listesine Ekle',
                                                              style: CustomTheme
                                                                      .textTheme(
                                                                          context)
                                                                  .bodyMedium,
                                                            ),
                                                            onTap: () {
                                                              context.go(
                                                                  '/playlist-add-music',
                                                                  extra:
                                                                      music.id);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          ListTile(
                                                            leading: Icon(
                                                                Icons.share),
                                                            title: Text(
                                                              'Paylaş',
                                                              style: CustomTheme
                                                                      .textTheme(
                                                                          context)
                                                                  .bodyMedium,
                                                            ),
                                                            onTap: () {
                                                              Share.share(
                                                                  'Check out this music: ${music.fileName}');
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          ListTile(
                                                            leading: Icon(
                                                                Icons.delete),
                                                            title: Text(
                                                              'Sil',
                                                              style: CustomTheme
                                                                      .textTheme(
                                                                          context)
                                                                  .bodyMedium,
                                                            ),
                                                            onTap: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              final shouldDelete =
                                                                  await showDialog<
                                                                      bool>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      'Silinsin mi?',
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      'Bu müzik dosyasını silmek istediğinize emin misiniz?',
                                                                    ),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context,
                                                                              false);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Hayır',
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context,
                                                                              true);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Evet',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );

                                                              if (shouldDelete ??
                                                                  false) {
                                                                await db
                                                                    .deleteMusicFile(
                                                                  music.id,
                                                                );
                                                                ref.invalidate(
                                                                    musicFilesProvider);
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Icon(
                                                Icons.more_vert_rounded,
                                                size: width * 0.07,
                                                color: CustomTheme.regularColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Hata: $error'),
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentLocation: '/library'),
    );
  }
}
