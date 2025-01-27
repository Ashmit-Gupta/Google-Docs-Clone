class DocumentModel {
  final String uid;
  final String createdAt;
  final String title;
  final List<dynamic> content;
  final String id;
  final int v;

  DocumentModel(
      {required this.uid,
      required this.createdAt,
      required this.title,
      required this.content,
      required this.id,
      required this.v});

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        uid: json['uid'] as String? ?? '',
        createdAt: json['createdAt'] as String? ?? '',
        title: json['title'] as String? ?? 'Untitled',
        // content: List<String>.from(json['content'] ?? []),
        content: List<dynamic>.from(json['content'] ?? []),
        id: json['_id'] as String? ?? '',
        v: json['__v'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'createdAt': createdAt,
        'title': title,
        'content': content,
        '_id': id,
        '__v': v,
      };
}
