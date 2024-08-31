import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_arch/core/errors/exceptions.dart';
import 'package:posts_app_clean_arch/features/posts/data/models/post_model.dart';
import 'package:http/http.dart' as http;

const BASE_URL = 'https://jsonplaceholder.typicode.com';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
  Future<Unit> deletePost(int id);
  Future<Unit> updatePost(PostModel post);

  Future<Unit> addPost(PostModel post);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;

  PostRemoteDataSourceImpl({required this.client});
  @override
  Future<List<PostModel>> getAllPosts() async {
    final respose = await client.get(Uri.parse('$BASE_URL/posts/'),
        headers: {'Content-Type': 'application/json'});

    if (respose.statusCode == 200) {
      final List decodedJson = jsonDecode(respose.body) as List;
      final List<PostModel> postModels = decodedJson
          .map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel))
          .toList();
      return postModels;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addPost(PostModel post) async {
    final body = {
      'title': post.title,
      'body': post.body,
    };
    final respose =
        await client.post(Uri.parse('${BASE_URL}posts/'), body: body);
    if (respose.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePost(int id) async {
    final response = await client.delete(Uri.parse('$BASE_URL/posts/${id}'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updatePost(PostModel post) async {
    final postId = post.id;
    final body = {'title': post.title, 'body': post.body};
    final response =
        await client.patch(Uri.parse('$BASE_URL/posts/$postId'), body: body);
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
