import 'package:eitherx/eitherx.dart';
import 'package:test/test.dart';

void main() {
  group('Either', () {
    test('left function should return a Left instance', () {
      final either = left<int, String>(42);
      expect(either, isA<Left>());
    });

    test('right function should return a Right instance', () {
      final either = right<int, String>('hello');
      expect(either, isA<Right>());
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

        expect(either, isA<Left>());
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

        expect(either, isA<Right>());
        expect(either.leftOrNull(), isNull);
        expect(either.rightOrNull(), equals('42'));

        final result = either.fold((l) => 'Left: $l', (r) => 'Right: $r');
        expect(result, equals('Right: 42'));
      });

      test('should create a Left instance with a value of type String', () {
        final either = left<String, int>('value');

        expect(either, isA<Left>());
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
    group('toString', () {
      test('Left.toString should return the right string representation', () {
        final either = left<int, String>(42);
        expect(either.toString(), equals('Left(42)'));
      });

      test('Right.toString should return the right string representation', () {
        final either = right<int, int>(42);
        expect(either.toString(), equals('Right(42)'));
      });
    });

    group('map', () {
      test('should transform the right value', () {
        final either = right<String, int>(21);
        expect(either.map((v) => v * 2), equals(right<String, int>(42)));
      });

      test('should leave a left value untouched', () {
        final either = left<String, int>('error');
        expect(either.map((v) => v * 2), equals(left<String, int>('error')));
      });

      test('should allow changing the right type', () {
        final either = right<String, int>(42);
        final result = either.map((v) => v.toString());
        expect(result, equals(right<String, String>('42')));
      });
    });

    group('mapLeft', () {
      test('should transform the left value', () {
        final either = left<String, int>('error');
        expect(either.mapLeft((e) => e.length), equals(left<int, int>(5)));
      });

      test('should leave a right value untouched', () {
        final either = right<String, int>(42);
        expect(either.mapLeft((e) => e.length), equals(right<int, int>(42)));
      });
    });

    group('bimap', () {
      test('should transform a right value with rightFn', () {
        final either = right<String, int>(42);
        final result = either.bimap((e) => e.length, (v) => v * 2);
        expect(result, equals(right<int, int>(84)));
      });

      test('should transform a left value with leftFn', () {
        final either = left<String, int>('error');
        final result = either.bimap((e) => e.length, (v) => v * 2);
        expect(result, equals(left<int, int>(5)));
      });
    });

    group('flatMap', () {
      Either<String, int> parse(String value) {
        final parsed = int.tryParse(value);
        return parsed == null ? left('invalid') : right(parsed);
      }

      test('should chain into the returned Either on a right value', () {
        final either = right<String, String>('42');
        expect(either.flatMap(parse), equals(right<String, int>(42)));
      });

      test('should short-circuit when the callback returns a left', () {
        final either = right<String, String>('x');
        expect(either.flatMap(parse), equals(left<String, int>('invalid')));
      });

      test('should leave an existing left untouched', () {
        final either = left<String, String>('error');
        expect(either.flatMap(parse), equals(left<String, int>('error')));
      });
    });

    group('getOrElse', () {
      test('should return the right value when present', () {
        final either = right<String, int>(42);
        expect(either.getOrElse((e) => -1), equals(42));
      });

      test('should compute a fallback from the left value', () {
        final either = left<String, int>('error');
        expect(either.getOrElse((e) => e.length), equals(5));
      });
    });

    group('orElse', () {
      test('should keep the right value', () {
        final either = right<String, int>(42);
        expect(either.orElse((e) => right(0)), equals(right<String, int>(42)));
      });

      test('should recover a left into a right', () {
        final either = left<String, int>('error');
        expect(either.orElse((e) => right(0)), equals(right<String, int>(0)));
      });

      test('should allow recovering a left into another left', () {
        final either = left<String, int>('error');
        final result = either.orElse((e) => left('failed again'));
        expect(result, equals(left<String, int>('failed again')));
      });
    });

    group('ensure', () {
      test('should keep a right value that satisfies the predicate', () {
        final either = right<String, int>(42);
        final result = either.ensure((v) => v > 0, (v) => 'not positive');
        expect(result, equals(right<String, int>(42)));
      });

      test('should turn a failing right value into a left', () {
        final either = right<String, int>(-1);
        final result = either.ensure((v) => v > 0, (v) => 'not positive');
        expect(result, equals(left<String, int>('not positive')));
      });

      test('should leave an existing left untouched', () {
        final either = left<String, int>('error');
        final result = either.ensure((v) => v > 0, (v) => 'not positive');
        expect(result, equals(left<String, int>('error')));
      });
    });
  });
}
