# Either

`Either` is a generic class in Dart that represents a value of one of two possible types: `L` or `R`. The class is useful when you want to return a value that can either be of type `L` or of type `R`, but not both.

This class is inspired by the Either data type in functional programming and provides a way to handle errors and exceptions in a more expressive and concise way.

## Installation

To use Either in your Flutter or Dart project, follow these steps:

1. Add the package to your pubspec.yaml file:

```yaml
dependencies:
  either: ^1.0.3
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
