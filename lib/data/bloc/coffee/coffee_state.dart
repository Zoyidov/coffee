import 'package:equatable/equatable.dart';

import '../../../utils/form_status.dart';
import '../../model/coffee_model.dart';

class CoffeeState extends Equatable {
  final FormStatus status;
  final List<Coffee> coffeeModel;
  final String statusText;

  const CoffeeState(
      {required this.status,
      required this.coffeeModel,
      required this.statusText});

  CoffeeState copyWith({
    FormStatus? status,
    List<Coffee>? coffeeModel,
    String? statusText,
  }) =>
      CoffeeState(
          status: status ?? this.status,
          coffeeModel: coffeeModel ?? this.coffeeModel,
          statusText: statusText ?? this.statusText);

  @override
  List<Object?> get props => [status, coffeeModel, statusText];
}
