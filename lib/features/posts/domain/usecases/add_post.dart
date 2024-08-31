import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_arch/core/errors/falures.dart';
import 'package:posts_app_clean_arch/features/posts/domain/entities/post_entity.dart';
import 'package:posts_app_clean_arch/features/posts/domain/repositories/posts_repository.dart';

class AddPostUseCase {
  final PostsRepository repository;

  AddPostUseCase( {required this.repository});

  Future<Either<Failure, Unit>> call(PostEntity post) async{
    return await repository.addPost(post);
  }
}