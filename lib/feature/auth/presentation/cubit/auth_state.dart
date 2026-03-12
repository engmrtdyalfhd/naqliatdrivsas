part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class OtpSentState extends AuthState {}

final class AuthSuccess extends AuthState {
  final bool hasCollection;

  AuthSuccess({required this.hasCollection});
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}
