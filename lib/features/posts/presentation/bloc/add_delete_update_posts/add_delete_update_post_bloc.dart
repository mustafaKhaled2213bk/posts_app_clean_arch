import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:posts_app_clean_arch/core/errors/falures.dart';
import 'package:posts_app_clean_arch/core/strings/messages.dart';
import 'package:posts_app_clean_arch/features/posts/domain/entities/post_entity.dart';
import 'package:posts_app_clean_arch/features/posts/domain/usecases/add_post.dart';
import 'package:posts_app_clean_arch/features/posts/domain/usecases/delete_post.dart';
import 'package:posts_app_clean_arch/features/posts/domain/usecases/update_post.dart';

import '../../../../../core/strings/failures.dart';

part 'add_delete_update_post_event.dart';
part 'add_delete_update_post_state.dart';

class AddDeleteUpdatePostBloc
    extends Bloc<AddDeleteUpdatePostEvent, AddDeleteUpdatePostState> {
  final AddPostUseCase addPost;
  final DeletePostUseCase deletePost;
  final UpdatePostUseCase updatePost;
  AddDeleteUpdatePostBloc(
      {required this.addPost,
      required this.deletePost,
      required this.updatePost})
      : super(AddDeleteUpdatePostInitial()) {
    on<AddDeleteUpdatePostEvent>((event, emit) async {
      if (event is AddPostEvent) {
        emit(LoadingAddDeleteUpdatePostState());

        final failureOrDoneMessage = await addPost(event.post);
        emit(_eatherDoneMessgeOrDoneState(
            failureOrDoneMessage, ADD_SUCCESS_MESSAGE));
      } else if (event is UpdatePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());

        final failureOrDoneMessage = await updatePost(event.post);
        failureOrDoneMessage.fold((failure) {
          emit(_eatherDoneMessgeOrDoneState(
            failureOrDoneMessage, UPDATE_SUCCESS_MESSAGE));
        }, (_) {
          emit(
              MessageAddDeleteUpdatePostState(message: UPDATE_SUCCESS_MESSAGE));
        });
      } else if (event is DeletePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());

        final failureOrDoneMessage = await deletePost(event.postId);
        emit(_eatherDoneMessgeOrDoneState(
            failureOrDoneMessage, DELETE_SUCCESS_MESSAGE));
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return SERVER_FAILURE_MESSAGE;

      case OffLineFailure _:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpecte Error , Please try again later";
    }
  }

  AddDeleteUpdatePostState _eatherDoneMessgeOrDoneState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
        (failure) => ErrorAddDeleteUpdatePostState(
            message: _mapFailureToMessage(failure)),
        (_) => MessageAddDeleteUpdatePostState(message: message));
  }
}
