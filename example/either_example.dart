import 'package:eitherx/eitherx.dart';

void main() {
  final myEither = right<String, int>(45);

  final String result = myEither.fold(
    (error) => 'Error: $error',
    (value) => 'Value: $value',
  );

  print(result); // Output: Value: 45
}
