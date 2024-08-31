import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_arch/core/errors/exceptions.dart';
import 'package:posts_app_clean_arch/core/errors/falures.dart';
import 'package:posts_app_clean_arch/core/network/network_info.dart';
import 'package:posts_app_clean_arch/features/posts/data/datasourses/post_local_data_source.dart';
import 'package:posts_app_clean_arch/features/posts/data/datasourses/post_remote_data_source.dart';
import 'package:posts_app_clean_arch/features/posts/data/models/post_model.dart';
import 'package:posts_app_clean_arch/features/posts/domain/entities/post_entity.dart';
import 'package:posts_app_clean_arch/features/posts/domain/repositories/posts_repository.dart';
typedef Future<Unit> DeleteOrUpdateOrAddPost();
class PostRepositoryImp implements PostsRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  PostRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, Unit>> addPost(PostEntity post) async {
    PostModel postModel =
        PostModel( title: post.title, body: post.body);
    return _getMessage(() => remoteDataSource.addPost(postModel));
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int id) async {
    return _getMessage(() => remoteDataSource.deletePost(id));
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final posts = await remoteDataSource.getAllPosts();
        localDataSource.cachePosts(posts);
        return Right(posts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final posts = await localDataSource.getCachedPosts();
        return Right(posts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePost(PostEntity post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);
    return _getMessage(() {
      return remoteDataSource.updatePost(postModel);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OffLineFailure());
    }
  }
}
