import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/config/router/router.dart';
import 'package:music_app/config/theme/custom_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final bool _appIsReady = true;

  // @override
  // void initState() {
  //   super.initState();

  //   _initializeAdapty().then((_) {
  //     setState(() {
  //       _appIsReady = true;
  //     });
  //   });
  // }

  // Future<void> _initializeAdapty() async {
  //   try {
  //     await Adapty().activate(
  //       configuration: AdaptyConfiguration(
  //         apiKey: 'public_live_Qk6D5MTR.Vp3iWwsX5dmvj8QAIDmB',
  //       )
  //         ..withLogLevel(AdaptyLogLevel.verbose)
  //         ..withObserverMode(false),
  //     );

  //     print("Adapty SDK başarıyla aktifleştirildi!");
  //   } catch (e) {
  //     print("Adapty başlatma hatası: $e");
  //     setState(() {
  //       _appIsReady = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (!_appIsReady) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp.router(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.themeData(context),
      routerConfig: router,
    );
  }
}

// class MyAdaptyUIObserver extends AdaptyUIObserver {
//   final BuildContext context;

//   MyAdaptyUIObserver(this.context);

//   @override
//   void paywallViewDidFailRendering(AdaptyUIView view, AdaptyError error) {
//     print("Paywall rendering failed: ${error.message}");
//   }

//   @override
//   void paywallViewDidFinishRestore(AdaptyUIView view, AdaptyProfile profile) {
//     print("Restore finished: ${profile.accessLevels}");
//   }

//   @override
//   void paywallViewDidFinishPurchase(AdaptyUIView view,
//       AdaptyPaywallProduct product, AdaptyPurchaseResult purchaseResult) {
//     switch (purchaseResult) {
//       case AdaptyPurchaseResultSuccess(profile: final profile):
//         print("Purchase successful: ${profile.accessLevels}");
//         final isPremium = profile.accessLevels['premium']?.isActive ?? false;

//         if (isPremium) {
//           print("Premium özellikler etkinleştirildi.");
//           GoRouter.of(context).go('/home');
//         } else {
//           print("Premium erişim seviyesi etkinleştirilmedi.");
//         }
//         break;
//       case AdaptyPurchaseResultPending():
//         print("Purchase pending");
//         break;
//       case AdaptyPurchaseResultUserCancelled():
//         print("Purchase cancelled by user");
//         break;
//     }
//   }

//   @override
//   void paywallViewDidFailPurchase(
//       AdaptyUIView view, AdaptyPaywallProduct product, AdaptyError error) {
//     print("Purchase failed: ${error.message}");
//   }

//   @override
//   void paywallViewDidSelectProduct(AdaptyUIView view, String productId) {
//     print("Product selected: $productId");
//   }

//   @override
//   void paywallViewDidStartPurchase(
//       AdaptyUIView view, AdaptyPaywallProduct product) {
//     print("Purchase started for product: ${product.vendorProductId}");
//   }

//   @override
//   void paywallViewDidPerformAction(AdaptyUIView view, AdaptyUIAction action) {
//     switch (action) {
//       case const CloseAction():
//         view.dismiss();
//         GoRouter.of(context).go('/home');
//         break;
//       case const AndroidSystemBackAction():
//         view.dismiss();
//         GoRouter.of(context).go('/home');
//         break;
//       case OpenUrlAction(url: final url):
//         final Uri uri = Uri.parse(url);
//         launchUrl(uri, mode: LaunchMode.inAppBrowserView);
//         break;
//       default:
//         break;
//     }
//   }
// }
