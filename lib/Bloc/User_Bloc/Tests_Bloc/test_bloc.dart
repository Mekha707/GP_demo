import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_events.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_states.dart';

class TestBloc extends Bloc<TestEvent, TestStates> {
  final UserService repository;

  TestBloc(this.repository) : super(TestInitial()) {
    on<FetchLabTests>((event, emit) async {
      emit(TestLoading());
      try {
        final tests = await repository.fetchTests();
        emit(TestLoaded(tests));
      } catch (e) {
        emit(TestError(e.toString()));
      }
    });
  }
}
