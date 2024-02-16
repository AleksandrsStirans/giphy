import 'package:equatable/equatable.dart';

abstract class GifState extends Equatable {
  const GifState();

  @override
  List<Object> get props => [];
}

class GifInitial extends GifState {}

class GifLoading extends GifState {}

class GifLoaded extends GifState {
  final List<String> gifUrls;
  final int timeStamp; 

  const GifLoaded({required this.gifUrls, required this.timeStamp});

  @override
  List<Object> get props => [gifUrls, timeStamp]; 
}


class GifError extends GifState {
  final String errorMessage;

  const GifError({this.errorMessage = "An unknown error has occurred"});

  @override
  List<Object> get props => [errorMessage];
}
