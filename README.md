# Either

`Either` is a generic class in Dart that represents a value of one of two possible types: `L` or `R`. The class is useful when you want to return a value that can either be of type `L` or of type `R`, but not both.

This class is inspired by the Either data type in functional programming and provides a way to handle errors and exceptions in a more expressive and concise way.

## Installation

To use Either in your Flutter or Dart project, follow these steps:

1. Add the package to your pubspec.yaml file:

```yaml
dependencies:
  either: ^2.1.0
```

2. Install the package by running flutter pub get in your terminal.

## Usage

### Either

To create an instance of `Either`, you can use the `left` or `right` methods. The `left` method takes a value of type `L` as a parameter and returns an instance of `Either` with `L` set to the provided value and `R` set to `null`. The `right` method takes a value of type `R` as a parameter and returns an instance of `Either` with `R` set to the provided value and `L` set to `null`.

```dart
final myEither = left<String, int>('hello');
final myOtherEither = right<String, int>(42);

Either<String, int> foo() {
  return left('hello');
}

Either<String, int> bar() {
  return right(42);
}
```

You can then use the `fold` method to get the value of `either` the `left` or `right` property, depending on which one is set.

```dart
  final myEither = right<String, int>(45);

  final String result = myEither.fold(
    (error) => 'Error: $error',
    (value) => 'Value: $value',
  );

  print(result); // Output: Value: 45
```

You can also use the `leftOrNull` and `rightOrNull` methods to get the value of either the `left` or `right` property, but return `null` if the corresponding property is not set.

```dart
   final either1 = left<int, String>(42);
   final either2 = right<int, String>('hello');
   either1.leftOrNull(); // returns 42
   either2.leftOrNull(); // returns null
```

### Transforming and chaining

`Either` is right-biased: the `Right` side is treated as the success value and the `Left` side as the error. The methods below make it easy to transform and chain results without unwrapping them by hand.

#### `map`

Transforms the `Right` value and leaves a `Left` untouched.

```dart
right<String, int>(21).map((v) => v * 2); // Right(42)
left<String, int>('error').map((v) => v * 2); // Left('error')
```

#### `mapLeft`

Transforms the `Left` value and leaves a `Right` untouched. Handy for converting one error type into another.

```dart
left<String, int>('error').mapLeft((e) => e.length); // Left(5)
right<String, int>(42).mapLeft((e) => e.length); // Right(42)
```

#### `bimap`

Transforms whichever side is present, applying `leftFn` to a `Left` and `rightFn` to a `Right`.

```dart
right<String, int>(42).bimap((e) => e.length, (v) => v * 2); // Right(84)
left<String, int>('error').bimap((e) => e.length, (v) => v * 2); // Left(5)
```

#### `flatMap`

Like `map`, but the callback itself returns an `Either`, so the result is flattened instead of nested. Use it to chain steps that can each fail; the first `Left` short-circuits the chain.

```dart
Either<String, int> parse(String s) {
  final value = int.tryParse(s);
  return value == null ? left('invalid') : right(value);
}

right<String, String>('42').flatMap(parse); // Right(42)
right<String, String>('x').flatMap(parse); // Left('invalid')
left<String, String>('error').flatMap(parse); // Left('error')
```

#### `getOrElse`

Returns the `Right` value, or computes a fallback from the `Left` value.

```dart
right<String, int>(42).getOrElse((e) => -1); // 42
left<String, int>('error').getOrElse((e) => -1); // -1
```

#### `orElse`

Returns the `Either` unchanged when it is a `Right`, otherwise computes a replacement `Either` from the `Left` value. Use it to recover from a failure while staying inside `Either`.

```dart
right<String, int>(42).orElse((e) => right(0)); // Right(42)
left<String, int>('error').orElse((e) => right(0)); // Right(0)
left<String, int>('error').orElse((e) => left('failed again')); // Left('failed again')
```

#### `ensure`

Keeps a `Right` value only when it satisfies a predicate, otherwise turns it into a `Left`. A `Left` is always left untouched.

```dart
right<String, int>(42).ensure((v) => v > 0, (v) => 'not positive'); // Right(42)
right<String, int>(-1).ensure((v) => v > 0, (v) => 'not positive'); // Left('not positive')
left<String, int>('error').ensure((v) => v > 0, (v) => 'not positive'); // Left('error')
```

### Unit

The `Unit` class represents the `void` type in Dart, which is used to indicate that a function does not return a value. While Dart does not have a separate `void` type, `Unit` provides a way to represent `void` as a value. This is especially useful when defining generic functions or classes that take a parameter of type `void`. You can use `Unit` in conjunction with the `Either` class to handle cases where a function may return a value or fail and return an error.

```dart
import 'package:eitherx/eitherx.dart';

// Define a function that simulates an API call and returns an Either
Either<String, Unit> fetchData() {
  // Simulate a successful API call
  int statusCode = 200;

  if (statusCode == 200) {
    // If the status code is 200, return Unit to represent success
    return right(unit);
  } else {
    // Otherwise, return a failure message
    return left('Error: Failed to fetch data');
  }
}

void main() {
  // Call the fetchData function and handle the Either result
  fetchData().fold(
    (failure) => print(failure),
    (unit) => print('Data fetched successfully'),
  );
}


```

## Author

This either package is authored by Hasan M. Hallak and can be found on [GitHub](https://github.com/hasanmhallak).
