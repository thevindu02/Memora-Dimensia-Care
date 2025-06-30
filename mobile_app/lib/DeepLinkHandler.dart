// import 'package:flutter/material.dart';
// import 'package:uni_links/uni_links.dart';
// import 'package:go_router/go_router.dart';
//
// class DeepLinkHandler extends StatefulWidget {
//   final Widget child;
//   const DeepLinkHandler({required this.child, Key? key}) : super(key: key);
//
//   @override
//   State<DeepLinkHandler> createState() => _DeepLinkHandlerState();
// }
//
// class _DeepLinkHandlerState extends State<DeepLinkHandler> {
//   @override
//   void initState() {
//     super.initState();
//     _handleIncomingLinks();
//   }
//
//   void _handleIncomingLinks() {
//     uriLinkStream.listen((Uri? uri) {
//       if (uri == null) return;
//       switch (uri.path) {
//         case '/reset-password':
//           final token = uri.queryParameters['token'];
//           if (token != null) {
//             context.go('/forgotPassword?token=$token');
//           }
//           break;
//         case '/verify-email':
//           final verificationToken = uri.queryParameters['token'];
//           if (verificationToken != null) {
//             context.go('/verifyEmail?token=$verificationToken');
//           }
//           break;
//         // Add more cases for other deep links here
//         // case '/some-other-action':
//         //   final param = uri.queryParameters['param'];
//         //   context.go('/someRoute?param=$param');
//         //   break;
//         default:
//           // Optionally handle unknown deep links
//           break;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }