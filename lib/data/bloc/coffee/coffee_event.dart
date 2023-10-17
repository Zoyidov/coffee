import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../model/coffee_model.dart';

@immutable
abstract class CoffeeEvent extends Equatable {}

class AddCoffee extends CoffeeEvent {
  final Coffee newCoffee;

  AddCoffee({required this.newCoffee});

  @override
  List<Object?> get props => [newCoffee];
}

class GetCoffee extends CoffeeEvent {
  @override
  List<Object?> get props => [];
}

class DeleteAllCoffeeEvent extends CoffeeEvent {
  @override
  List<Object?> get props => [];
}

class DeleteCoffeeEvent extends CoffeeEvent {
  final int id;

  DeleteCoffeeEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateCoffee extends CoffeeEvent {
  final Coffee newCoffee;

  UpdateCoffee({required this.newCoffee});

  @override
  List<Object?> get props => [newCoffee];
}
