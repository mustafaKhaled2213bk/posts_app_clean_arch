import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_arch/core/errors/falures.dart';
import 'package:posts_app_clean_arch/features/posts/domain/repositories/posts_repository.dart';

class DeletePostUseCase {
  final PostsRepository repo;

  DeletePostUseCase({required this.repo});
  Future<Either<Failure, Unit>> call(int postId) async {
    return await repo.deletePost(postId);
  }
}
