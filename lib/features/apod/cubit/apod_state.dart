part of 'apod_cubit.dart';

@immutable
sealed class ApodState {}

final class ApodInitial extends ApodState {}

final class ApodLoading extends ApodState {}

final class ApodLoaded extends ApodState {
  final ApodModel apod;

  ApodLoaded({required this.apod});
}

final class ApodError extends ApodState {
  final String message;

  ApodError({required this.message});
}
