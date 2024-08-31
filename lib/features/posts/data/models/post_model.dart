import 'package:posts_app_clean_arch/features/posts/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel({int? id, required String title, required String body})
      : super(id: id, title: title, body: body);

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(id: json['id'], title: json['title'], body: json['body']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'body': body};
}
