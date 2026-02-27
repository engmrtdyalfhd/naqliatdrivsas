part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class CodeSentState extends AuthState {}

final class AuthSuccess extends AuthState {
  // ! Boolean to redirect user to collection_view or home_view
  final bool hasCollection;
  const AuthSuccess(this.hasCollection);
}

final class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
}
