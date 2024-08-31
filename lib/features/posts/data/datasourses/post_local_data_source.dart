import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_arch/core/errors/exceptions.dart';
import 'package:posts_app_clean_arch/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_POSTS = 'CACHED';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getCachedPosts();
  Future<Unit> cachePosts(List<PostModel> posts);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<Unit> cachePosts(List<PostModel> posts) {
    // final SharedPreferences sharedPreferences=
    List postModelsToJson = posts
        .map<Map<String, dynamic>>((postModel) => postModel.toJson())
        .toList();
    sharedPreferences.setString(CACHED_POSTS, jsonEncode(postModelsToJson));

    return Future.value(unit);
  }

  @override
  Future<List<PostModel>> getCachedPosts() async {
    String? jsonString = sharedPreferences.getString(CACHED_POSTS);
    if (jsonString != null) {
      List decodedJsonData = jsonDecode(jsonString);
      List<PostModel> jsonPostModel =
          decodedJsonData.map((e) => PostModel.fromJson(e)).toList();
      return await jsonPostModel;
    } else {
      throw EmptyCacheException();
    }
  }
}
