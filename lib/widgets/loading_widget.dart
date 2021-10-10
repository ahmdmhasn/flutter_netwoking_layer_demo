import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? loadingMessage;

  const LoadingWidget({
    Key? key,
    this.loadingMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            loadingMessage ?? '',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          )
        ],
      ),
    );
  }
}
