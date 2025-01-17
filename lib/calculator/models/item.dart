import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../validators/validators.dart';
import 'models.dart';

class Item extends Equatable {
  /// A unique identifier for this specific item.
  final String uuid; // Helps keep track of the item in the widget tree.

  final double price;
  final double quantity;
  final Unit unit;

  /// Where the item is from, eg: "Walmart", "Amazon", "Costco".
  final String location;

  /// Further details such as brand, specific package, etc.
  final String details;

  /// Cost per gram, milligram, kilogram, etc.
  final List<Cost> costPerUnit;

  const Item._({
    required this.uuid,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.location,
    required this.details,
    required this.costPerUnit,
  });

  factory Item({
    String? uuid,
    required double price,
    required double quantity,
    required Unit unit,
    String? location,
    String? details,
  }) {
    final costPerUnit = CostValidator.validate(
      price: price,
      quantity: quantity,
      unit: unit,
    );

    return Item._(
      uuid: uuid ?? const Uuid().v1(),
      price: price,
      quantity: quantity,
      unit: unit,
      location: location ?? '',
      details: details ?? '',
      costPerUnit: costPerUnit,
    );
  }

  Item copyWith({
    String? uuid,
    double? price,
    double? quantity,
    Unit? unit,
    String? location,
    String? details,
  }) {
    return Item(
      uuid: uuid ?? this.uuid,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      location: location ?? this.location,
      details: details ?? this.details,
    );
  }

  @override
  String toString() => '\n'
      'uuid: $uuid \n'
      'price: $price \n'
      'quantity: $quantity \n'
      'unit: $unit \n'
      'location: $location \n'
      'details: $details \n';

  @override
  List<Object?> get props {
    return [
      uuid,
      price,
      quantity,
      unit,
      costPerUnit,
      location,
      details,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'price': price,
      'quantity': quantity,
      'unit': unit.toString(),
      'location': location,
      'details': details,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    // Handle values from before 'name' was changed to 'location'.
    // This check can probably be simplified after a short time has passed to
    // allow the migration.
    String? location;
    if (map.containsKey('name')) {
      location = map['name'];
    } else {
      location = map['location'] ?? '';
    }

    return Item(
      uuid: map['uuid'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toDouble() ?? 0.0,
      unit: Unit.fromString(map['unit']),
      location: location,
      details: map['details'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));
}
