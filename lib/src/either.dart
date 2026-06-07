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

  /// Transforms the [Right] value of this [Either] using [fn],
  /// leaving a [Left] untouched.
  ///
  /// This is the right-biased `map`: [fn] runs only when this is a
  /// [Right]. When this is a [Left], the same error is propagated and
  /// [fn] is never called.
  ///
  /// Example usage:
  ///
  /// ```dart
  ///    right<String, int>(21).map((v) => v * 2); // Right(42)
  ///    left<String, int>('error').map((v) => v * 2); // Left('error')
  /// ```
  Either<L, R2> map<R2>(R2 Function(R right) fn) =>
      fold((l) => Left<L, R2>(l), (r) => Right<L, R2>(fn(r)));

  /// Transforms the [Left] value of this [Either] using [fn],
  /// leaving a [Right] untouched.
  ///
  /// Useful for converting an error into another error type without
  /// touching the success value.
  ///
  /// Example usage:
  ///
  /// ```dart
  ///    left<String, int>('error').mapLeft((e) => e.length); // Left(5)
  ///    right<String, int>(42).mapLeft((e) => e.length); // Right(42)
  /// ```
  Either<L2, R> mapLeft<L2>(L2 Function(L left) fn) =>
      fold((l) => Left<L2, R>(fn(l)), (r) => Right<L2, R>(r));

  /// Transforms both sides of this [Either] at once, applying
  /// [leftFn] to a [Left] value and [rightFn] to a [Right] value.
  ///
  /// Only one of the two functions runs, depending on which side this
  /// [Either] holds.
  ///
  /// Example usage:
  ///
  /// ```dart
  ///    right<String, int>(42).bimap((e) => e.length, (v) => v * 2);
  ///    // Right(84)
  ///    left<String, int>('error').bimap((e) => e.length, (v) => v * 2);
  ///    // Left(5)
  /// ```
  Either<L2, R2> bimap<L2, R2>(
    L2 Function(L left) leftFn,
    R2 Function(R right) rightFn,
  ) =>
      fold(
        (l) => Left<L2, R2>(leftFn(l)),
        (r) => Right<L2, R2>(rightFn(r)),
      );

  /// Transforms the [Right] value of this [Either] using [fn] and
  /// flattens the result, leaving a [Left] untouched.
  ///
  /// Unlike [map], [fn] returns an [Either] itself, so the result is
  /// not nested. Use this to chain operations that can each fail; the
  /// first [Left] short-circuits the chain.
  ///
  /// Example usage:
  ///
  /// ```dart
  ///    Either<String, int> parse(String s) {
  ///      final value = int.tryParse(s);
  ///      return value == null ? left('invalid') : right(value);
  ///    }
  ///
  ///    right<String, String>('42').flatMap(parse); // Right(42)
  ///    right<String, String>('x').flatMap(parse); // Left('invalid')
  ///    left<String, String>('error').flatMap(parse); // Left('error')
  /// ```
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R right) fn) =>
      fold((l) => Left<L, R2>(l), (r) => fn(r));

  /// Returns the [Right] value if this is a [Right], otherwise
  /// computes a fallback from the [Left] value using [orElse].
  ///
  /// Example usage:
  ///
  /// ```dart
  ///    right<String, int>(42).getOrElse((e) => -1); // 42
  ///    left<String, int>('error').getOrElse((e) => -1); // -1
  /// ```
  R getOrElse(R Function(L left) orElse) => fold((l) => orElse(l), (r) => r);

  /// Returns this [Either] if it is a [Right], otherwise computes a
  /// replacement [Either] from the [Left] value using [fn].
  ///
  /// Use this to recover from a failure with another fallible
  /// operation while staying inside [Either].
  ///
  /// Example usage:
  ///
  /// ```dart
  ///    right<String, int>(42).orElse((e) => right(0)); // Right(42)
  ///    left<String, int>('error').orElse((e) => right(0)); // Right(0)
  ///    left<String, int>('error').orElse((e) => left('failed again'));
  ///    // Left('failed again')
  /// ```
  Either<L, R> orElse(Either<L, R> Function(L left) fn) =>
      fold((l) => fn(l), (r) => Right<L, R>(r));

  /// Returns this [Either] unchanged when it is a [Left], or when it
  /// is a [Right] whose value satisfies [predicate]. When this is a
  /// [Right] that fails [predicate], it becomes a [Left] built from
  /// [orLeft].
  ///
  /// Use this to enforce a condition on a success value and turn a
  /// violation into a typed error.
  ///
  /// Example usage:
  ///
  /// ```dart
  ///    right<String, int>(42).ensure((v) => v > 0, (v) => 'not positive');
  ///    // Right(42)
  ///    right<String, int>(-1).ensure((v) => v > 0, (v) => 'not positive');
  ///    // Left('not positive')
  ///    left<String, int>('error').ensure((v) => v > 0, (v) => 'not positive');
  ///    // Left('error')
  /// ```
  Either<L, R> ensure(
    bool Function(R right) predicate,
    L Function(R right) orLeft,
  ) =>
      fold(
        (l) => Left<L, R>(l),
        (r) => predicate(r) ? Right<L, R>(r) : Left<L, R>(orLeft(r)),
      );
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

  @override
  String toString() => 'Left($left)';
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

  @override
  String toString() => 'Right($right)';
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
