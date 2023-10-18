import 'package:agora_voip/model/users.dart';
import 'package:agora_voip/repository/call_kit_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  final CallKitRepository callKitRepository = CallKitRepository();
  List<Users> users = [];

  fetchUsers() {
    FirebaseFirestore.instance.collection('Users').get().then((value) {
      users = value.docs.map((e) => Users.fromJson(e.data())).toList();
      notifyListeners();
    });
  }

  sendCallNotification({required Users user, required int callMode}) async {
    callKitRepository.sendCallNotification(user: user, callMode: callMode);
  }
}
