import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_arch/core/errors/falures.dart';
import 'package:posts_app_clean_arch/features/posts/domain/entities/post_entity.dart';

abstract class PostsRepository {
  Future<Either<Failure , List<PostEntity>>> getAllPosts();
  Future<Either<Failure,Unit>>deletePost(int id);
  Future<Either<Failure,Unit>>updatePost(PostEntity post);
  Future<Either<Failure,Unit>>addPost(PostEntity post);
  
}
