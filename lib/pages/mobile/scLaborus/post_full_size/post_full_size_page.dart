// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:laborus_app/core/model/laborus/post.dart';
// import 'package:laborus_app/core/components/cards/button_comment.dart';
// import 'package:laborus_app/core/components/cards/button_like.dart';

// class PostFullSizePage extends StatelessWidget {
//   final Post post;

//   const PostFullSizePage({Key? key, required this.post}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 80,
//         elevation: 0,
//         leading: _buildPostHeader(context),
//         leadingWidth: double.infinity,
//       ),
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       body: SingleChildScrollView(
//         child: Card(
//           elevation: 0,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(15)),
//           ),
//           color: Colors.transparent,
//           child: SizedBox(
//             width: double.infinity,
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 13),
//                   _buildPostContent(context),
//                   const SizedBox(height: 13),
//                   _buildPostImage(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildPostActions(context),
//     );
//   }

//   Widget _buildPostHeader(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () {
//                   context.pop();
//                 },
//                 icon: const Icon(Icons.arrow_back_ios_new),
//               ),
//               IconButton(
//                 iconSize: 40,
//                 icon: Container(
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/img/profile.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 onPressed: null,
//               ),
//               const SizedBox(width: 8),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     post.user.name, // Usar o nome do usuário do post
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 3),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.school,
//                         size: 12,
//                         color: Theme.of(context).colorScheme.tertiaryContainer,
//                       ),
//                       const SizedBox(width: 5),
//                       Text(
//                         post.user
//                             .course!, // Usar a instituição do usuário do post
//                         style: TextStyle(
//                           fontSize: 12,
//                           color:
//                               Theme.of(context).colorScheme.tertiaryContainer,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'Roboto',
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const IconButton(
//             onPressed: null,
//             icon: Icon(Icons.more_horiz),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPostContent(BuildContext context) {
//     return Text(
//       post.text,
//       textAlign: TextAlign.left,
//       style: TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: Theme.of(context).colorScheme.tertiaryContainer,
//       ),
//     );
//   }

//   Widget _buildPostImage() {
//     return Image.asset(
//       post.media,
//       width: double.infinity,
//       fit: BoxFit.cover,
//     );
//   }

//   Widget _buildPostActions(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           ButtonLike(post: post),
//           ButtonComment(post: post),
//         ],
//       ),
//     );
//   }
// }
