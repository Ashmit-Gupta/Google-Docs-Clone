import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/repository/auth_repository.dart';
import 'package:google_docs_clone/screens/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authRepositoryProvider).signInWithGoogle();

    void signInWithGoogle(WidgetRef ref, BuildContext context) async {
      final navigator = Navigator.of(context);
      final sMessenger = ScaffoldMessenger.of(context);
      final errorModel =
          await ref.read(authRepositoryProvider).signInWithGoogle();
      if (errorModel.error == null) {
        ref.read(userProvider.notifier).update((state) => errorModel.data);
        navigator
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
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
