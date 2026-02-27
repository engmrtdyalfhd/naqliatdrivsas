abstract class Failure {
  final String ex;
  const Failure(this.ex);
}

final class ResponseFailure extends Failure {
  const ResponseFailure(super.ex);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.ex);
}
