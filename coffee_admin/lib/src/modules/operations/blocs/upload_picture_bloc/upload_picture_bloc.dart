import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';

part 'upload_picture_event.dart';
part 'upload_picture_state.dart';

class UploadPictureBloc extends Bloc<UploadPictureEvent, UploadPictureState> {
  UploadPictureBloc(this._coffeeRepo) : super(UploadPictureLoading()) {
    on<UploadPicture>((event, emit) async {
      try {
        final url = await _coffeeRepo.uploadCoffeeImage(event.file, event.name);
        emit(UploadPictureSuccess(url));
      } catch (_) {
        emit(UploadPictureFailure());
      }
    });
  }

  final CoffeeRepo _coffeeRepo;
}
