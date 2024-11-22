// import 'package:flutter/material.dart';
// import 'package:laborus_app/core/model/laborus/post.dart';
// import 'package:laborus_app/core/utils/theme/colors.dart';

// class ButtonLike extends StatefulWidget {
//   final Post post;
//   const ButtonLike({super.key, required this.post});

//   @override
//   State<ButtonLike> createState() => _ButtonLikeState();
// }

// class _ButtonLikeState extends State<ButtonLike> {
//   @override
//   Widget build(BuildContext context) {
//     bool liked = widget.post.liked('userId');
//     return Tooltip(
//       message: 'curtir',
//       child: TextButton.icon(
//         onPressed: () {
//           widget.post.like('userId');
//           setState(() {});
//         },
//         icon: Icon(
//           liked
//               ? Icons.thumb_up_off_alt_outlined
//               : Icons.thumb_up_off_alt_sharp,
//           color: liked
//               ? Theme.of(context).colorScheme.tertiaryContainer
//               : AppColors.darknessPurple,
//         ),
//         label: Text(
//           widget.post.likesCount.toString(),
//           style: TextStyle(
//             color: liked
//                 ? Theme.of(context).colorScheme.tertiaryContainer
//                 : AppColors.darknessPurple,
//           ),
//         ),
//       ),
//     );
//   }
// }
