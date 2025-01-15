import 'dart:convert';

import 'package:google_docs_clone/constants/constants.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:google_docs_clone/models/user_model_entity.dart';
import 'package:google_docs_clone/repository/local_storage_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:riverpod/riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      googleSignIn: GoogleSignIn(),
      client: Client(),
      localStorageRepository: LocalStorageRepository()),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorageRepository localStorageRepository})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(error: "something went wrong !", data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
            name: user.displayName!,
            email: user.email,
            profilePic: user.photoUrl ??
                "https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg",
            token: "",
            uid: "");

        var res = await _client.post(Uri.parse('$kHost/api/signup'),
            body: jsonEncode(userAcc),
            headers: {'Content-Type': 'application/json;charset=UTF-8'});

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;

          case 401:
            error = ErrorModel(error: "Unauthorized access", data: null);
            break;
          case 500:
            error = ErrorModel(
                error: "Server error. Please try again later.", data: null);
            break;
          default:
            error = ErrorModel(error: "Unexpected error occurred", data: null);
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
      print(e);
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(data: null, error: "error ");

    try {
      String? token = await _localStorageRepository.getToken();
      if (token != null) {
        var response = await _client.get(
          Uri.parse('$kHost/api/me'),
          headers: {
            'token': token,
          },
        );

        switch (response.statusCode) {
          case 200:
            //the data contains 2 keys userData and the token
            var responseData = jsonDecode(response.body);
            //getting only the userData
            var userJsonData = responseData['userData'];
            //converting that json userData to UserModel
            UserModel userData = UserModel.fromJson(userJsonData);
            userData = userData.copyWith(token: token);

            error = ErrorModel(error: null, data: userData);
            break;
          case 401:
            error = ErrorModel(error: "Unauthorized access", data: null);
            break;
          case 500:
            error = ErrorModel(
                error: "Server error. Please try again later.", data: null);
            break;
          default:
            error = ErrorModel(error: "Unexpected error occurred", data: null);
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
      print("error $e");
    }
    return error;
  }

  void signOut() async {
    _localStorageRepository.setToken('');
    await _googleSignIn.signOut();
  }
}
