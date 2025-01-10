class UserModel {
	final String name;
	final String email;
	final String profilePic;
	final String token;
	final String uid;

	UserModel({
		required this.name,
		required this.email,
		required this.profilePic,
		required this.token,
		required this.uid,
	});

	/// Named constructor to create a UserModel from a JSON object.
	factory UserModel.fromJson(Map<String, dynamic> json) {
		return UserModel(
			name: json['name'] ?? "",
			email: json['email'] ?? "",
			profilePic: json['profilePic'] ?? "",
			token: json['token'] ?? "",
			uid: json['_id'] ?? "",
		);
	}

	/// Method to convert a UserModel into a JSON map.
	Map<String, dynamic> toJson() {
		return {
			'name': name,
			'email': email,
			'profilePic': profilePic,
			'token': token,
			'uid': uid,
		};
	}

	/// Creates a new UserModel with updated fields.
	UserModel copyWith({
		String? name,
		String? email,
		String? profilePic,
		String? token,
		String? uid,
	}) {
		return UserModel(
			name: name ?? this.name,
			email: email ?? this.email,
			profilePic: profilePic ?? this.profilePic,
			token: token ?? this.token,
			uid: uid ?? this.uid,
		);
	}
}
