# Either

`Either` is a generic class in Dart that represents a value of one of two possible types: `L` or `R`. The class is useful when you want to return a value that can either be of type `L` or of type `R`, but not both.

This class is inspired by the Either data type in functional programming and provides a way to handle errors and exceptions in a more expressive and concise way.

## Installation

To use Either in your Flutter or Dart project, follow these steps:

1. Add the package to your pubspec.yaml file:

```yaml
dependencies:
  either: ^1.0.0
```

2. Install the package by running flutter pub get in your terminal.

## Usage

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

## Author

This either package is authored by Hasan M. Hallak and can be found on [GitHub](https://github.com/hasanmhallak).
