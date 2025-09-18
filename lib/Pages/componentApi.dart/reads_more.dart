import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadMoreText extends StatefulWidget {
  const ReadMoreText({
    super.key,
    required this.longText,
  });

  final String longText;

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool readMore = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          widget.longText,
          style: GoogleFonts.bentham(
            textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                letterSpacing: .3,
                fontWeight: FontWeight.w500),
          ),
          maxLines: readMore ? 1000 : 5,
          overflow: TextOverflow.ellipsis,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              readMore = !readMore;
            });
          },
          child: Text(readMore ? 'Read less' : 'Read more'),
        ),
      ],
    );
  }
}
