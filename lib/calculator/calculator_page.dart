import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpers/helpers.dart';
import 'package:multi_split_view/multi_split_view.dart';

import '../app/app.dart';
import '../app/widgets/widgets.dart';
import '../purchases/pages/purchases_page.dart';
import '../settings/cubit/settings_cubit.dart';
import 'calculator_cubit/calculator_cubit.dart';
import 'widgets/widgets.dart';

class CalculatorPage extends StatelessWidget {
  static const id = 'calculator_page';

  CalculatorPage({Key? key}) : super(key: key);

  final focusNode = FocusNode(
    debugLabel: 'Background node',
    skipTraversal: true,
  );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    Widget? drawer;
    if (mediaQuery.isHandset) {
      drawer = const Drawer(child: SidePanel());
    }

    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {
        if (state.promptForProUpgrade) {
          Navigator.pushNamed(context, PurchasesPage.id);
        }
      },
      child: SafeArea(
        // GestureDetector & FocusNode allow clicking outside input areas in
        // order to deselect them as expected on web & desktop platforms.
        child: GestureDetector(
          onTap: () => focusNode.requestFocus(),
          child: FocusableActionDetector(
            focusNode: focusNode,
            child: Scaffold(
              appBar: const CustomAppBar(),
              drawer: drawer,
              body: CalculatorView(),
            ),
          ),
        ),
      ),
    );
  }
}

class CalculatorView extends StatelessWidget {
  CalculatorView({Key? key}) : super(key: key);

  final focusNode = FocusNode(
    debugLabel: 'CalculatorView node',
    skipTraversal: true,
  );

  final MultiSplitViewController multiSplitViewController =
      MultiSplitViewController(
    areas: Area.weights([settingsCubit.state.navigationAreaRatio]),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorCubit, CalculatorState>(
      builder: (context, state) {
        return MultiSplitView(
          controller: multiSplitViewController,
          onWeightChange: () {
            final navigationAreaRatio = multiSplitViewController //
                .getArea(0)
                .weight;

            if (navigationAreaRatio == null) return;

            settingsCubit.updateNavigationAreaRatio(navigationAreaRatio);
          },
          children: [
            if (defaultTargetPlatform != TargetPlatform.android)
              const ExcludeFocusTraversal(
                child: SidePanel(),
              ),
            GestureDetector(
              onTap: () => focusNode.requestFocus(),
              child: Focus(
                focusNode: focusNode,
                child: const ScrollingItemsList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ScrollingItemsList extends StatelessWidget {
  const ScrollingItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorCubit, CalculatorState>(
      builder: (context, state) {
        if (state.activeSheet == null) {
          return Center(
            child: ElevatedButton(
              onPressed: () => calcCubit.addSheet(),
              child: const Text('New sheet'),
            ),
          );
        }

        final Widget compareButton = ElevatedButton(
          onPressed: () => calcCubit.compare(),
          child: const Text('Compare'),
        );

        final Widget addButton = IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => calcCubit.addItem(),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Wrap(
                  runSpacing: 20.0,
                  alignment: WrapAlignment.center,
                  children: [
                    const SizedBox(width: double.infinity),
                    for (var item in state.activeSheet!.items)
                      ItemCard(item: item),
                  ],
                ),
              ),
            ),
            Card(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CompareByDropdownButton(),
                  compareButton,
                  addButton,
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
