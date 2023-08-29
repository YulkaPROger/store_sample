import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:market_store/market_effect_widget.dart';
import 'package:market_store/market_state_widget.dart';
import 'package:market_store/market_store_widget.dart';
import 'package:store_sample/state_manager/example_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MarketStateScope<ExampleStore>(
        store: ExampleStore<ExampleState, ExampleAction, ExampleEffect>(),
        child: const MyHomePage(),
      ),
    );
  }

}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ExampleStore scope = MarketStateScope.of<ExampleStore>(context).store;

    var random = math.Random();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    const textStyle = TextStyle(
      color: Colors.white,
    );
    final buttonStyle = TextButton.styleFrom(
      backgroundColor: Colors.deepPurple,
    );
    final buttonErrorStyle = TextButton.styleFrom(
      backgroundColor: Colors.redAccent,
    );
    const text2style = TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
    const text3style = TextStyle(
      fontSize: 24,
      color: Colors.deepPurple,
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("title"),
      ),
      key: scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ObserveEffectMarketScope<ExampleStore>(
              onChangeEffect: (effect) {
                if (effect is ShowMessEffect) {
                  _showSnackBar(context, effect);
                }
              },
            ),
            ObserveStateMarketScope<ExampleStore>(
              onChangeState: (state) {
                switch (state) {
                  case BaseState():
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Имя пылесоса",
                          style: text2style,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          state.vacuumCleaner.name,
                          style: text3style,
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          "Полный?}",
                          style: text2style,
                        ),
                        Text(
                          state.vacuumCleaner.isFull.toString(),
                          style: text3style,
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          "Дата след обслуживания",
                          style: text2style,
                        ),
                        Text(
                          state.vacuumCleaner.serviceDate,
                          style: text3style,
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          "Уровень заряда}",
                          style: text2style,
                        ),
                        Text(
                          state.vacuumCleaner.charge.toString(),
                          style: text3style,
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          "Список команд",
                          style: text2style,
                        ),
                        Text(
                          state.vacuumCleaner.commands.toString(),
                          style: text3style,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  case ErrorState():
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          scope.dispatch(ShowMessAction("Приплыли"));
                        },
                        style: buttonErrorStyle,
                        child: Text(
                          "Показывается только когда состояние в Error State, "
                              "нажатие возвращает к начальному состоянию ${state.reason}",
                          style: textStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                }
                return null;
              },
            ),
            ObserveStateMarketScope<ExampleStore>(
              onChangeState: (state) {
                if (state is BaseState) {
                  if (state.loaded) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Colors.pink,
                      ),
                    );
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              scope.dispatch(InitialAction());
            },
            style: buttonStyle,
            child: const Text(
              "Начальное состояние",
              style: textStyle,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(
            onPressed: () {
              scope.dispatch(
                  ChangeStateCleanerAction(charge: random.nextInt(300)));
            },
            style: buttonStyle,
            child: const Text(
              "Изменить уровень заряда на рандом",
              style: textStyle,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(
            onPressed: () {
              scope.dispatch(GetInfoAction());
            },
            style: buttonStyle,
            child: const Text(
              "Отложенная операция из сети",
              style: textStyle,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(
            onPressed: () {
              scope.dispatch(CloseAction());
            },
            style: buttonStyle,
            child: const Text(
              "Событие показа снекбара",
              style: textStyle,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    ShowMessEffect effect,
  ) {
    final snackBar = SnackBar(
      content: Text(effect.mess),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {},
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}