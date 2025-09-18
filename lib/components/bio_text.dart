import 'package:flutter/material.dart';

class Bio_Field extends StatefulWidget {
  final TextEditingController controller;

  const Bio_Field({Key? key, required this.controller}) : super(key: key);

  @override
  State<Bio_Field> createState() => _Bio_FieldState();
}

class _Bio_FieldState extends State<Bio_Field> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xFFA3A380),
            ),
            style: TextStyle(
              fontSize: 17,
              color: Color.fromRGBO(239, 235, 205, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
