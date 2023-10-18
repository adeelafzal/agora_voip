import 'package:agora_voip/main.dart';
import 'package:agora_voip/model/users.dart';
import 'package:agora_voip/view_model/user_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseMessaging.instance.deleteToken();
                FirebaseAuth.instance.signOut();
                navigatorKey.currentState!
                    .pushReplacementNamed("/SignInScreen");
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => UserViewModel()..fetchUsers(),
        child: Consumer<UserViewModel>(builder: (context, user, child) {
          return user.users.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (BuildContext context, int index) {
                    Users userData = user.users[index];
                    return Card(
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(
                            left: 16, right: 8, top: 8, bottom: 8),
                        leading: const CircleAvatar(
                            child: Icon(CupertinoIcons.person_alt,
                                color: Colors.purple)),
                        title: Text(
                          userData.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: FirebaseAuth.instance.currentUser!.uid !=
                                userData.userId
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        user.sendCallNotification(
                                            user: userData, callMode: 0);
                                      },
                                      icon: const Icon(
                                        Icons.call,
                                        color: Colors.purple,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        user.sendCallNotification(
                                            user: userData, callMode: 1);
                                      },
                                      icon: const Icon(
                                        Icons.videocam_rounded,
                                        color: Colors.purple,
                                      )),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                  itemCount: user.users.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 16),
                );
        }),
      ),
    );
  }
}
