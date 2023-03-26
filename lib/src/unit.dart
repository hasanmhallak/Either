import 'package:meta/meta.dart';

/// The [Unit] class represents the `void` type in Dart.
///
/// Dart does not have a separate `void` type, but rather
/// uses the `void` keyword to indicate that a function
/// does not return a value. However, sometimes it is
/// useful to have a value that represents `void`,
/// for example when defining a generic function or
/// class that takes a parameter of type `void`.
///
/// The [Unit] class provides a single value, `unit`,
/// that represents `void`. This value can be used in
/// place of `void` when defining functions or classes
/// that take a parameter of type `void`.
@immutable
class Unit {
  /// Creates a new instance of the [Unit] class.
  ///
  /// Note: This constructor is private and can
  /// only be accessed from within the class.
  const Unit._();

  /// A single value of type [Unit] that represents
  /// `void`.
  ///
  /// This value can be used in place of `void` when
  /// defining functions or classes that take a parameter
  /// of type `void`.
  static const unit = Unit._();

  /// Compares this [Unit] object to another object to see
  /// if they are equal.
  ///
  /// Since there is only one instance of [Unit], this method
  /// always returns true if the other object is also an
  /// instance of [Unit].
  ///
  /// Returns `true` if the objects are equal (both are
  /// instances of [Unit]), `false` otherwise.
  @override
  bool operator ==(Object other) => other is Unit;

  /// Returns a hash code for this [Unit] object.
  ///
  /// Since there is only one instance of [Unit],
  /// this method always returns the same hash code
  /// for all instances of [Unit].
  ///
  /// Returns a hash code for this [Unit] object.
  @override
  int get hashCode => 0;

  /// Returns a string representation of this Unit
  /// object.
  ///
  /// Since there is only one instance of Unit, this
  /// method always returns the string "Unit".
  ///
  /// Returns a string representation of this Unit
  /// object.
  @override
  String toString() => 'Unit';
}

/// A single value of type [Unit] that represents
/// `void`.
///
/// This value can be used in place of `void` when
/// defining functions or classes that take a parameter
/// of type `void`.
const unit = Unit.unit;
