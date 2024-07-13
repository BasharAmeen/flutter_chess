import 'package:flutter/material.dart';

errorDialog(String message, BuildContext context) {
  var alert = AlertDialog(
    contentPadding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    content: Container(
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black87,
          width: 0,
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'There is a problem',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red.withOpacity(0.8)),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(message)
        ],
      ),
    ),
  );
  showDialog(
    context: context,
    builder: (context) => alert,
  );
}
