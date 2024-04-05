/// Result Pattern: A functional programming technique
/// that provides a clear and expressive way
/// to handle errors without relying on exceptions for flow control.
///
abstract class Result<V, E> {
  const Result();
  bool get isSuccess;

  bool get isFailure;

  ValueResult<V, E> get asValue;

  ErrorResult<V, E> get asError;

  factory Result.value(V value) => ValueResult(value);

  factory Result.error(E error) => ErrorResult(error);
}

class ValueResult<V, E> implements Result<V, E> {
  const ValueResult(this.data);

  final V data;

  @override
  bool get isSuccess => true;

  @override
  bool get isFailure => false;

  @override
  ValueResult<V, E> get asValue => this;

  @override
  ErrorResult<V, E> get asError => throw UnimplementedError();
}

class ErrorResult<V, E> extends Result<V, E> {
  const ErrorResult(this.error);

  final E error;

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;

  @override
  ValueResult<V, E> get asValue => throw UnimplementedError();

  @override
  ErrorResult<V, E> get asError => this;
}
