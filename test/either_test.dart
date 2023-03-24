import 'package:either/either.dart';
import 'package:test/test.dart';

void main() {
  group('Either', () {
    test('isLeft should return true for a Left instance', () {
      final either = left<int, String>(42);
      expect(either.isLeft, isTrue);
    });

    test('isLeft should return false for a Right instance', () {
      final either = right<int, String>('hello');
      expect(either.isLeft, isFalse);
    });

    test('fold should call leftFn if the instance is Left', () {
      final either = left<int, String>(42);
      final result = either.fold(
        (left) => 'Left: $left',
        (right) => 'Right: $right',
      );
      expect(result, equals('Left: 42'));
    });

    test('fold should call rightFn if the instance is Right', () {
      final either = right<int, String>('hello');
      final result = either.fold(
        (left) => 'Left: $left',
        (right) => 'Right: $right',
      );
      expect(result, equals('Right: hello'));
    });

    test('leftOrNull should return the left value for a Left instance', () {
      final either = left<int, String>(42);
      final result = either.leftOrNull();
      expect(result, equals(42));
    });

    test('leftOrNull should return null for a Right instance', () {
      final either = right<int, String>('hello');
      final result = either.leftOrNull();
      expect(result, isNull);
    });

    test('rightOrNull should return the right value for a Right instance', () {
      final either = right<int, String>('hello');
      final result = either.rightOrNull();
      expect(result, equals('hello'));
    });

    test('rightOrNull should return null for a Left instance', () {
      final either = left<int, String>(42);
      final result = either.rightOrNull();
      expect(result, isNull);
    });

    test('== operator and hashCode in Left should return true', () {
      final either1 = left<int, String>(42);
      final either2 = left<int, String>(42);
      expect(either1, either2);
    });
    test('== operator and hashCode in Right should return true', () {
      final either1 = right<int, String>('42');
      final either2 = right<int, String>('42');
      expect(either1, either2);
    });
    group('Left', () {
      test('should create a Left instance with a value of type int', () {
        final either = left<int, String>(42);

        expect(either.isLeft, isTrue);
        expect(either.leftOrNull(), equals(42));
        expect(either.rightOrNull(), isNull);

        final result = either.fold((l) => 'Left: $l', (r) => 'Right: $r');
        expect(result, equals('Left: 42'));
      });

      test('should create a Left instance with a value of type String', () {
        final either = left<String, int>('error');

        expect(either.isLeft, isTrue);
        expect(either.leftOrNull(), equals('error'));
        expect(either.rightOrNull(), isNull);

        final result = either.fold((l) => 'Left: $l', (r) => 'Right: $r');
        expect(result, equals('Left: error'));
      });
    });

    group('Right', () {
      test('should create a Right instance with a value of type String', () {
        final either = right<int, String>('42');

        expect(either.isLeft, isFalse);
        expect(either.leftOrNull(), isNull);
        expect(either.rightOrNull(), equals('42'));

        final result = either.fold((l) => 'Left: $l', (r) => 'Right: $r');
        expect(result, equals('Right: 42'));
      });

      test('should create a Left instance with a value of type String', () {
        final either = left<String, int>('value');

        expect(either.isLeft, isTrue);
        expect(either.rightOrNull(), isNull);
        expect(either.leftOrNull(), equals('value'));

        final result = either.fold((l) => 'Left: $l', (r) => 'Right: $r');
        expect(result, equals('Left: value'));
      });
    });

    group('fold', () {
      test('should call the leftFn function with a value of type int', () {
        final either = left<int, String>(42);

        final result = either.fold((l) => 'Left: $l', (r) => 'Right: $r');
        expect(result, equals('Left: 42'));
      });

      test('should call the rightFn function with a value of type String', () {
        final either = right<int, String>('value');

        final result = either.fold((l) => 'Left: $l', (r) => 'Right: $r');
        expect(result, equals('Right: value'));
      });
    });

    group('leftOrNull', () {
      test('should return null for a Right instance', () {
        final either = right<int, String>('value');

        expect(either.leftOrNull(), isNull);
      });

      test('should return a value of type int for a Left instance', () {
        final either = left<int, String>(42);

        expect(either.leftOrNull(), equals(42));
      });
    });

    group('rightOrNull', () {
      test('should return null for a Left instance', () {
        final either = right<int, String>('error');

        expect(either.leftOrNull(), isNull);
      });

      test('should return a value of type String for a Right instance', () {
        final either = right<int, String>('value');

        expect(either.rightOrNull(), equals('value'));
      });
    });
  });
}
