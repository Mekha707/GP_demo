import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';

abstract class TestStates {}

class TestInitial extends TestStates {}

class TestLoading extends TestStates {}

class TestLoaded extends TestStates {
  final List<Test> tests;
  TestLoaded(this.tests);
}

class TestError extends TestStates {
  final String message;
  TestError(this.message);
}
