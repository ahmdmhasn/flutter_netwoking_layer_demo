import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final Function onRetryPressed;

  const ErrorWidget({
    Key? key,
    this.errorMessage,
    required this.onRetryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          ElevatedButton(
            child: Text('Retry'),
            onPressed: () => onRetryPressed(),
          ),
        ],
      ),
    );
  }
}
