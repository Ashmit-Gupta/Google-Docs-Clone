import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/constants/colors.dart';
import 'package:google_docs_clone/models/document_model.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:google_docs_clone/repository/auth_repository.dart';
import 'package:google_docs_clone/repository/document_repository.dart';
import 'package:logger/logger.dart';
import 'package:routemaster/routemaster.dart';

import '../common/widgets/loader.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackBar = ScaffoldMessenger.of(context);
    final errorModel =
        await ref.read(documentRepositoryProvider).createDocument(token);
    if (errorModel.error != null) {
      Logger().i(errorModel.error);
      snackBar.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    } else {
      navigator.push('/document/${errorModel.data.id}');
    }
  }

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              createDocument(context, ref);
            },
            icon: const Icon(
              Icons.add,
              color: kBlackColor,
            ),
          ),
          IconButton(
            onPressed: () {
              signOut(ref);
            },
            icon: const Icon(
              Icons.logout,
              color: kRedColor,
            ),
          )
        ],
      ),
      body: FutureBuilder<ErrorModel>(
        future: ref
            .watch(documentRepositoryProvider)
            .getDocuments(ref.watch(userProvider)!.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.hasError) {
            return Text('Error : ${snapshot.error}');
          }
          return Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 600,
              child: ListView.builder(
                itemCount: snapshot.data!.data.length ?? 0,
                itemBuilder: (context, index) {
                  DocumentModel document = snapshot.data!.data[index];

                  return InkWell(
                    onTap: () {
                      navigateToDocument(context, document.id);
                    },
                    child: SizedBox(
                      height: 50,
                      child: Card(
                        child: Center(
                          child: Text(
                            document.title,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
