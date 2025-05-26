import 'package:flutter/material.dart';

class AddEditTextPage extends StatefulWidget {
  const AddEditTextPage({required this.onDone, this.defaultText, super.key});
  final String? defaultText;
  final void Function(String text) onDone;
  @override
  State<AddEditTextPage> createState() => _AddEditTextPageState();
}

class _AddEditTextPageState extends State<AddEditTextPage> {
  TextEditingController textFieldController = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    textFieldController = TextEditingController(text: widget.defaultText ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900.withValues(alpha: 0.9),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned.fill(
            child: Align(
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextField(
                          focusNode: focusNode,
                          controller: textFieldController,
                          autofocus: true,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            fillColor: Colors.black.withValues(alpha: 0.2),
                            filled: true,
                            border: InputBorder.none,
                          ),
                          maxLines:
                              // ignore: lines_longer_than_80_chars
                              null, //Allow the text field to grow as text is added
                          minLines: 1, // Start with a single line
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      margin: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: () {
                          widget.onDone(textFieldController.text);
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
