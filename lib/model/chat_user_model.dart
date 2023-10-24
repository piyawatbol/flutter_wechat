class ChatUserModel {
  bool? isOnline;
  String? id;
  String? createdAt;
  String? pushToken;
  String? image;
  String? email;
  String? about;
  String? lastActive;
  String? name;

  ChatUserModel(
      {this.isOnline,
      this.id,
      this.createdAt,
      this.pushToken,
      this.image,
      this.email,
      this.about,
      this.lastActive,
      this.name});

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    isOnline = json['is_online'];
    id = json['id'];
    createdAt = json['created_at'];
    pushToken = json['push_token'];
    image = json['image'];
    email = json['email'];
    about = json['about'];
    lastActive = json['last_active'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_online'] = this.isOnline;
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['push_token'] = this.pushToken;
    data['image'] = this.image;
    data['email'] = this.email;
    data['about'] = this.about;
    data['last_active'] = this.lastActive;
    data['name'] = this.name;
    return data;
  }
}
