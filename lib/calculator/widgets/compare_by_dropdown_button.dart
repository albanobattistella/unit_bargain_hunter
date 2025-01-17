import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../calculator_cubit/calculator_cubit.dart';
import '../models/models.dart';

class CompareByDropdownButton extends StatelessWidget {
  const CompareByDropdownButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorCubit, CalculatorState>(
      builder: (context, state) {
        return DropdownButton<Unit>(
          underline: const SizedBox(),
          value: state.activeSheet!.compareBy,
          items: UnitType.all
              .map(
                (unitType) => DropdownMenuItem(
                  value: unitType,
                  child: Text('$unitType'),
                ),
              )
              .toList(),
          onChanged: (value) => calcCubit.updateCompareBy(value!),
        );
      },
    );
  }
}
