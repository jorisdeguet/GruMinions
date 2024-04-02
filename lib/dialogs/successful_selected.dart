import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SuccessfulSelected extends StatefulWidget {
  const SuccessfulSelected({super.key, required this.characterName});

  final String characterName;

  @override
  State<SuccessfulSelected> createState() => _SuccessfulSelectedState();
}

class _SuccessfulSelectedState extends State<SuccessfulSelected> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Successful selected : ${widget.characterName} !',
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
            const SizedBox(width: 15),
            const Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}
