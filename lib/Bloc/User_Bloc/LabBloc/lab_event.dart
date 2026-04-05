abstract class LabsEvent {}

class FetchLabs extends LabsEvent {}

class LoadMoreLabs extends LabsEvent {}

class RefreshLabs extends LabsEvent {}

class FilterLabs extends LabsEvent {
  final String? name;
  final String? location;
  final List<String>? testIds; // أضف هذا السطر

  FilterLabs({this.name, this.location, this.testIds});
}
