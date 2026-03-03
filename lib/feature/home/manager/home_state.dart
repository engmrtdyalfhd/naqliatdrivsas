part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final String phone;
  final String truckName;
  final String carrierType;
  final String? featureName;

  const HomeLoaded({
    required this.phone,
    required this.truckName,
    required this.carrierType,
    this.featureName,
  });
}

final class HomeFailure extends HomeState {
  final String error;
  const HomeFailure(this.error);
}