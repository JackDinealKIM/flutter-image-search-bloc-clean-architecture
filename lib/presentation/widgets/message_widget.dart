import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final BuildContext context;

  const MessageWidget({super.key, required this.message, required this.context});

  @override
  Widget build(BuildContext _) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
