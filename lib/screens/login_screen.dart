import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/repository/auth_repository.dart';
import 'package:google_docs_clone/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = Routemaster.of(context);
    final sMessenger = ScaffoldMessenger.of(context);

    void signInWithGoogle(WidgetRef ref, BuildContext context) async {
      final errorModel =
          await ref.read(authRepositoryProvider).signInWithGoogle();
      if (errorModel.error == null) {
        ref.read(userProvider.notifier).update((state) => errorModel.data);
        navigator.replace('/');
      } else {
        print("log error in the login screen , ${errorModel.error} ");
        sMessenger.showSnackBar(
          SnackBar(
            content: Text(errorModel.error!),
          ),
        );
      }
    }

    return Scaffold(
        body: Center(
      child: ElevatedButton.icon(
        onPressed: () {
          print("log in the onPress button !!");
          signInWithGoogle(ref, context);
        },
        label: Text(
          "Sign in with Google",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: Image.asset(
          'assets/images/g-logo-2.png',
          height: 22,
          width: 22,
        ),
        style: ElevatedButton.styleFrom(minimumSize: const Size(150, 50)),
      ),
    ));
  }
}
