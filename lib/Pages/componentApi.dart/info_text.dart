import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoText extends StatelessWidget {
  const InfoText({super.key, required this.label, required this.info});
  final String label;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.rubikMonoOne(
            textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                letterSpacing: .3,
                fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(width: 1),
        Container(
            width: 110,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromRGBO(238, 227, 171, 1.0),
            ),
            child: Center(
                child: Text(info,
                    style: const TextStyle(fontWeight: FontWeight.w600)))),
      ],
    );
  }
}
