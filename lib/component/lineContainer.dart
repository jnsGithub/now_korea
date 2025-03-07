import 'package:flutter/material.dart';

import '../global.dart';

class LineContainer extends StatelessWidget {
  const LineContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 1,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
         color: C9C9C9
      ),
    );
  }
}
