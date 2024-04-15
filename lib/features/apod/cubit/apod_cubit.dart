import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:future_functions/features/apod/models/apod_model.dart';

part 'apod_state.dart';

class ApodCubit extends Cubit<ApodState> {
  ApodCubit() : super(ApodInitial()) {
    getApod();
  }

  int minusDays = 0;

  Dio dio = Dio();

  final String nasaEndpoint =
      'https://api.nasa.gov/planetary/apod?api_key=${dotenv.get('NASA_API_KEY', fallback: 'DEMO_KEY')}';

  void getApod() async {
    emit(ApodLoading());
    await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await dio.get(nasaEndpoint);
      final apod = ApodModel.fromJson(response.data);
      emit(ApodLoaded(apod: apod));
    } catch (e) {
      emit(ApodError(message: e.toString()));
    }
  }

  void getApodByDate() async {
    emit(ApodLoading());
    minusDays++;
    final date = DateTime.now().subtract(Duration(days: minusDays));
    await Future.delayed(const Duration(seconds: 1));
    debugPrint(date.toIso8601String().substring(0, 10));
    try {
      final response =
          await dio.get('$nasaEndpoint&date=${date.toIso8601String().substring(0, 10)}');
      final apod = ApodModel.fromJson(response.data);
      emit(ApodLoaded(apod: apod));
    } catch (e) {
      emit(ApodError(message: e.toString()));
    }
  }
}
