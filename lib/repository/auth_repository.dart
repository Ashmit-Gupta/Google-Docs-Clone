import 'dart:convert';

import 'package:google_docs_clone/constants/constants.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:google_docs_clone/models/user_model_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:riverpod/riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(googleSignIn: GoogleSignIn(), client: Client()),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepository({required GoogleSignIn googleSignIn, required Client client})
      : _googleSignIn = googleSignIn,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(error: "something went wrong !", data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
            name: user.displayName!,
            email: user.email,
            profilePic: user.photoUrl!,
            token: "",
            uid: "");
        print('log the url is: $kHost/api/signup');
        var res = await _client.post(Uri.parse('$kHost/api/signup'),
            // body: userAcc.toJson(),
            body: jsonEncode(userAcc),
            headers: {'Content-Type': 'application/json;charset=UTF-8'});

        print(
            "log the response status code is : ${res.statusCode} and the data in the res is : ${res.body.toString()}");
        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              // token: "",
            );
            error = ErrorModel(error: null, data: newUser);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
      print(e);
    }
    return error;
  }
}
