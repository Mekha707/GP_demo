// Events
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavigationEvent {}

class TabChanged extends NavigationEvent {
  final int index;
  TabChanged(this.index);
}

// States
class NavigationState {
  final int selectedIndex;
  NavigationState(this.selectedIndex);
}

// Bloc
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(0)) {
    on<TabChanged>((event, emit) {
      emit(NavigationState(event.index));
    });
  }
}
