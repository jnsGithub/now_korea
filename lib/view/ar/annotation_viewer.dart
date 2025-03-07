// import 'package:flutter/material.dart';
//
// import 'annotations.dart';
//
// class AnnotationViewer extends StatelessWidget {
//   const AnnotationViewer({
//     Key? key,
//     required this.annotation,
//   }) : super(key: key);
//
//   final Annotation annotation;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//         color: Colors.white,
//         image: DecorationImage(image: NetworkImage('https://cdn.pixabay.com/animation/2023/09/14/07/21/07-21-23-507_512.gif'), fit: BoxFit.fitWidth),
//       ),
//     );
//   }
//
//   Widget typeFactory(AnnotationType type) {
//     IconData iconData = Icons.ac_unit_outlined;
//     Color color = Colors.teal;
//     switch (type) {
//       case AnnotationType.pharmacy:
//         iconData = Icons.local_pharmacy_outlined;
//         color = Colors.red;
//         break;
//       case AnnotationType.hotel:
//         iconData = Icons.hotel_outlined;
//         color = Colors.green;
//         break;
//       case AnnotationType.library:
//         iconData = Icons.library_add_outlined;
//         color = Colors.blue;
//         break;
//     }
//     return Image(
//       image: NetworkImage('https://cdn.pixabay.com/animation/2023/09/14/07/21/07-21-23-507_512.gif'),
//       width: 40,
//     );
//   }
// }