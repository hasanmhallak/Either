import 'package:meta/meta.dart';

@immutable
abstract class Either<L, R> {
  const Either._();

  /// A getter that returns a boolean indicating whether
  /// the instance of [Either] is a [Left] instance.
  ///
  /// It's recommend to use `is` operator to check
  /// for types. e.g:
  /// ```dart
  ///   final data = left<String, int>('data');
  ///
  ///   final isLeft = data is Left;
  ///
  ///   print(isLeft); // true
  /// ```
  bool get isLeft;

  /// A getter that returns a boolean indicating whether
  /// the instance of [Either] is a [Right] instance.
  ///
  /// It's recommend to use `is` operator to check
  /// for types. e.g:
  /// ```dart
  ///   final data = right<String, int>(45);
  ///
  ///   final isRight = data is Right;
  ///
  ///   print(isRight); // true
  /// ```
  bool get isRight;

  /// A generic method that takes two functions, [leftFn] and
  /// [rightFn], as parameters.
  ///
  /// Based on the type of the [Either] instance, either
  /// [leftFn] or [rightFn] is called and its result is
  /// returned.
  ///
  /// If the instance is a [Left] instance, [leftFn] is
  /// called with [left] as the argument.
  ///
  /// If the instance is a [Right] instance, [rightFn] is
  /// called with [right] as the argument.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// Either<String, int> number = right(10);
  ///
  /// String result = number.fold(
  ///   (error) => 'Error: $error',
  ///   (value) => 'Value: $value',
  /// );
  ///
  /// print(result); // Output: Value: 10
  /// ```
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn);

  /// Returns the value of the [left] property
  /// if the [Either] instance is a [Left] instance, otherwise
  /// returns `null`.
  ///
  /// Use this method to extract the [left] value from the [Either]
  /// instance, when it exists.
  ///
  /// Returns `null` when the [Either] instance is a [Right]
  /// instance, as there is no [left] value to extract.
  ///
  /// Example usage:
  ///
  /// ```dart
  ///    final either1 = left<int, String>(42);
  ///    final either2 = right<int, String>('hello');
  ///
  ///    either1.leftOrNull(); // returns 42
  ///    either2.leftOrNull(); // returns null
  /// ```
  L? leftOrNull();

  /// Returns the value of the [Right] property
  /// if the [Either] instance is a [Right] instance, otherwise
  /// returns `null`.
  ///
  /// Use this method to extract the [Right] value from the [Either]
  /// instance, when it exists.
  ///
  /// Returns `null` when the [Either] instance is a [Left]
  /// instance, as there is no [Right] value to extract.
  ///
  /// Example usage:
  ///
  /// ```dart
  ///    final either1 = right<int, String>(42);
  ///    final either2 = left<int, String>('hello');
  ///
  ///    either1.rightOrNull(); // returns 42
  ///    either2.rightOrNull(); // returns null
  /// ```
  R? rightOrNull();
}

/// A class that represents the left value in an
/// [Either] instance.
///
/// This class is used to indicate that an instance
/// of [Either] contains a left value of type [L].
///
/// Instances of [Left] are created using the
/// constructor and take a value of type [L] as
/// a parameter.
@immutable
class Left<L, R> extends Either<L, R> {
  /// Creates a new instance of [Left] with a
  /// value of type [L].
  ///
  /// The value of [left] is used to create the
  /// instance of [Left].
  const Left(this.left) : super._();

  /// The left value of type [L].
  final L left;

  @override
  bool get isLeft => true;

  @override
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) => leftFn(left);

  @override
  L? leftOrNull() => left;

  @override
  R? rightOrNull() => null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Left<L, R> && other.left == left;
  }

  @override
  int get hashCode => left.hashCode;

  @override
  bool get isRight => false;
}

/// Creates a new instance of [Left] with a value
/// of type [L].
///
/// The value of [left] is used to create the
/// instance of [Left].
///
/// The resulting instance of [Left] is returned
/// as an instance of [Either] with [R] set to null.
///
/// Example:
///
/// ```
/// final myEither = left<String, int>('hello');
/// ```
///
/// In this example, a new instance of [Left] is
/// created with the value 'hello' of type [String].
/// The resulting instance is then returned as an
/// instance of [Either] with [R] set to null.
///
/// Returns an instance of [Either] with [L] set to
/// [left] and [R] set to null.
Either<L, R> left<L, R>(L left) => Left(left);

/// A class that represents the right value in
/// an [Either] instance.
///
/// This class is used to indicate that an instance
/// of [Either] contains a right value of type [R].
///
/// Instances of [Right] are created using the
/// constructor and take a value of type [R] as
/// a parameter.
class Right<L, R> extends Either<L, R> {
  /// Creates a new instance of [Right] with a
  /// value of type [R].
  ///
  /// The value of [right] is used to create the
  /// instance of [Right].
  const Right(this.right) : super._();

  /// The right value of type [R].
  final R right;

  @override
  bool get isLeft => false;

  @override
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) => rightFn(right);

  @override
  L? leftOrNull() => null;

  @override
  R? rightOrNull() => right;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Right<L, R> && other.right == right;
  }

  @override
  int get hashCode => right.hashCode;

  @override
  bool get isRight => true;
}

/// Creates a new instance of [Right] with a value
/// of type [R].
///
/// The value of [right] is used to create the instance
/// of [Right]. The resulting instance of [Right] is returned
/// as an instance of [Either] with [L] set to null.
///
/// Example:
///
/// ```
/// final myEither = right<String, int>(42);
/// ```
///
/// In this example, a new instance of [Right] is created
/// with the value 42 of type [int]. The resulting instance
/// is then returned as an instance of [Either] with [L] set
/// to null.
///
/// Returns an instance of [Either] with [L] set to null
/// and [R] set to [right].
Either<L, R> right<L, R>(R right) => Right(right);
