abstract class LabsEvent {}

class FetchLabs extends LabsEvent {}

class LoadMoreLabs extends LabsEvent {}

class RefreshLabs extends LabsEvent {}

class FilterLabs extends LabsEvent {
  final String? name;
  final String? location;

  FilterLabs({this.name, this.location});
}
