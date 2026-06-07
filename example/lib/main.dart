import 'package:eitherx/eitherx.dart';

/// Parses [input] into an int, returning a [Left] error message when
/// the input is not a valid number.
Either<String, int> parseAge(String input) {
  final age = int.tryParse(input);
  return age == null ? left('"$input" is not a number') : right(age);
}

void main() {
  // fold: collapse both sides into a single value.
  final greeting = right<String, int>(45).fold(
    (error) => 'Error: $error',
    (value) => 'Value: $value',
  );
  print(greeting); // Value: 45

  // map: transform the right value, leaving a left untouched.
  print(right<String, int>(21).map((v) => v * 2)); // Right(42)
  print(left<String, int>('boom').map((v) => v * 2)); // Left(boom)

  // mapLeft: transform the left value, leaving a right untouched.
  print(left<String, int>('boom').mapLeft((e) => e.toUpperCase())); // Left(BOOM)

  // bimap: transform whichever side is present.
  print(right<String, int>(42).bimap((e) => e.length, (v) => v * 2)); // Right(84)

  // flatMap + ensure: chain fallible steps and validate the result.
  final result = parseAge('17')
      .flatMap((age) => parseAge('$age'))
      .ensure((age) => age >= 18, (age) => '$age is too young');

  // getOrElse: extract the right value or fall back.
  final age = result.getOrElse((error) => 0);
  print('Resolved age: $age'); // Resolved age: 0

  // orElse: recover from a failure with another Either.
  final recovered = result.orElse((error) => right(18));
  print(recovered); // Right(18)
}
