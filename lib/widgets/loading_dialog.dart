import 'package:agora_voip/main.dart';
import 'package:flutter/material.dart';

loadingDialog() {
  Dialog errorDialog = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: const SizedBox(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Loading",style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),),
          SizedBox(height: 16),
          CircularProgressIndicator()
        ],
      ),
    ),
  );
  showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) => errorDialog);
}
