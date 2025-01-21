import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/constants/constants.dart';
import 'package:google_docs_clone/models/document_model.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

final documentRepositoryProvider = Provider(
  (ref) => DocumentRepository(
    client: Client(),
  ),
);

class DocumentRepository {
  final Client _client;
  var logger = Logger();

  DocumentRepository({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel(error: "Something Went Wrong", data: null);
    try {
      // final token = await _localStorageRepository.getToken();
      // if (token != null) {
      var response = await _client.post(
        Uri.parse('$kHost/api/doc/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token,
        },
        body: jsonEncode(
          {
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          },
        ),
      );
      // logger.i(jsonDecode(response.body));

      switch (response.statusCode) {
        case 200:
          final json = jsonDecode(response.body);
          DocumentModel document = DocumentModel.fromJson(json['document']);
          // logger.i(document.uid);
          // logger.i(document.content);
          // logger.i(document.createdAt);
          error = ErrorModel(error: null, data: document);
          break;

        case 401:
          error = ErrorModel(
              error: "Unauthorized access , ${response.body}", data: null);
          break;
        case 500:
          error = ErrorModel(
              error: "Server error. Please try again later. ${response.body}",
              data: null);
          break;
        default:
          error = ErrorModel(error: response.body, data: null);
      }
      // }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
      logger.e("error message $e");
    }
    return error;
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel error = ErrorModel(error: "Unexpected Error !!", data: null);
    try {
      var response = await _client.get(
        Uri.parse('$kHost/api/docs/me'),
        headers: {'token': token},
      );

      switch (response.statusCode) {
        case 200:
          List<DocumentModel> documentsList = [];

          for (int i = 0; i < jsonDecode(response.body).length; i++) {
            // Logger().i("single data is : ${jsonDecode(response.body)[i]}");
            // documentsList.add(jsonDecode(response.body)[i]);
            documentsList
                .add(DocumentModel.fromJson(jsonDecode(response.body)[i]));
          }
          error = ErrorModel(error: null, data: documentsList);
          break;
        case 401:
          error = ErrorModel(
              error: "Unauthorized access , ${response.body}", data: null);
          break;
        case 500:
          error = ErrorModel(
              error: "Server error. Please try again later. ${response.body}",
              data: null);
          break;
        default:
          error = ErrorModel(error: response.body, data: null);
      }
    } catch (e) {
      logger.e("error message $e");
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  //this will update the documents title
  Future<ErrorModel> updateDocumentTitle(
      {required String token,
      required String id,
      required String title}) async {
    ErrorModel error =
        ErrorModel(error: "Unexpected Exception Occurred", data: null);
    try {
      var response = await _client.post(
        Uri.parse('$kHost/api/docs/update'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token,
        },
        body: jsonEncode({
          'documentId': id,
          'docTitle': title,
        }),
      );
      switch (response.statusCode) {
        case 200:
          error = ErrorModel(error: null, data: null);
          break;
        case 401:
          error = ErrorModel(
              error: "Unauthorized access , ${response.body}", data: null);
          break;
        case 500:
          error = ErrorModel(
              error: "Server error. Please try again later. ${response.body}",
              data: null);
          break;
        default:
          error = ErrorModel(error: response.body, data: null);
      }
    } catch (e, stackTrace) {
      error = ErrorModel(error: e.toString(), data: null);
      logger.e("error updating the Document : $e\n$stackTrace");
    }
    return error;
  }

  //fetching the data from the document id
  Future<ErrorModel> getDocumentById(String token, String id) async {
    ErrorModel error = ErrorModel(error: "Unexpected Error", data: null);
    try {
      var response = await _client.get(
        Uri.parse('$kHost/api/doc/$id'),
        headers: {
          "token": token,
        },
      );
      switch (response.statusCode) {
        case 200:
          error =
              // ErrorModel(error: null, data: Document.fromJson(response.body));
              ErrorModel(
                  error: null,
                  data: DocumentModel.fromJson(jsonDecode(response.body)));
          break;
        case 401:
          error = ErrorModel(
              error: "Unauthorized access , ${response.body}", data: null);
          break;
        case 500:
          error = ErrorModel(
              error: "Server error. Please try again later. ${response.body}",
              data: null);
          break;
        default:
          throw 'This Document Doesnt Exist , please create a new one';
      }
    } catch (e, stackTrace) {
      error = ErrorModel(error: e.toString(), data: null);
      logger.e("error updating the Document : $e\n$stackTrace");
    }
    return error;
  }
}
