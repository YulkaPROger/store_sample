import 'package:market_store/store.dart';
import 'package:market_store/store_impl.dart';
import 'package:store_sample/models/flat.dart';
import 'package:store_sample/models/room.dart';
import 'package:store_sample/models/vacuum_cleaner.dart';

///СТОР


class ExampleStore<S, A, E>
    extends StoreImpl<ExampleState, ExampleAction, ExampleEffect> {

  @override
  ExampleState doAction(ExampleAction action, ExampleState? oldState) {
    return switch (action) {
      InitialAction() => _initial(action, oldState),
      GetInfoAction() => _getInfo(action, oldState),
      CloseAction() => _close(action, oldState),
      ChangeStateCleanerAction() => _changeState(action, oldState),
      ShowMessAction() => _showMess(action, oldState),
    };
  }

  _initial(InitialAction action, ExampleState? oldState) {
    return BaseState(
      flat: Flat(
        rooms: List.of([
          Room(name: "Спальня", square: 20.2),
          Room(name: "Гостинная", square: 50.4),
          Room(name: "Кухня", square: 5.8),
        ]),
      ),
      vacuumCleaner: VacuumCleaner(
          name: 'Robot',
          isFull: true,
          charge: 100,
          commands: List.of(["Гулять", "Спать", "Убирать"]),
          serviceDate: "32.12.1803"),
    );
  }

  _getInfo(GetInfoAction action, ExampleState? oldState) {
    Future.delayed(const Duration(seconds: 5), () {
      dispatch(ChangeStateCleanerAction(isEmpty: false, charge: 500));
    });
    if (oldState is BaseState) {
      return oldState.copyWith(loaded: true);
    } else {
      return oldState;
    }
  }

  _close(CloseAction action, ExampleState? oldState) {
    sendEffect(ShowMessEffect("Приплыли"));
    return ErrorState(reason: "Конец ${action.runtimeType}");
  }

  _changeState(ChangeStateCleanerAction action, ExampleState? oldState) {
    if (oldState is BaseState) {
      final newVacuumCleaner = oldState.vacuumCleaner.copyWith(
          isFull: action.isEmpty ?? oldState.vacuumCleaner.isFull,
          charge: action.charge ?? oldState.vacuumCleaner.charge,
      );
      return oldState.copyWith(vacuumCleaner: newVacuumCleaner, loaded: false);
    }
  }

  _showMess(ShowMessAction action, ExampleState? oldState) {
    sendEffect(ShowMessEffect(action.mess));
    return oldState;
  }
}

///Стейт

sealed class ExampleState extends MarketState {}

class InitialState extends ExampleState {}

class BaseState implements ExampleState {
  final Flat flat;
  final VacuumCleaner vacuumCleaner;
  final bool loaded;

  const BaseState({
    required this.flat,
    required this.vacuumCleaner,
    this.loaded = false,
  });

  BaseState copyWith({VacuumCleaner? vacuumCleaner, bool? loaded,}) =>
      BaseState(flat: flat,
        vacuumCleaner: vacuumCleaner ?? this.vacuumCleaner,
        loaded: loaded ?? this.loaded,);
}

class ErrorState implements ExampleState {
  final String reason;

  const ErrorState({required this.reason});
}

///Еффекты

sealed class ExampleEffect extends MarketEffect {}

class ShowMessEffect implements ExampleEffect {
  final String mess;

  ShowMessEffect(this.mess);

}

class ShowErrorEffect implements ExampleEffect {}

///Действия

sealed class ExampleAction extends MarketAction {}

class InitialAction implements ExampleAction {}

class GetInfoAction implements ExampleAction {}

class CloseAction implements ExampleAction {}

class ChangeStateCleanerAction implements ExampleAction {
  final bool? isEmpty;
  final int? charge;

  ChangeStateCleanerAction({this.isEmpty, this.charge});
}

class ShowMessAction implements ExampleAction {
  final String mess;

  ShowMessAction(this.mess);
}

