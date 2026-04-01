abstract class NursesEvent {}

class FetchNurses extends NursesEvent {}

class LoadMoreNurses extends NursesEvent {}

class RefreshNurses extends NursesEvent {}

class FilterNurses extends NursesEvent {
  final String? name;
  final String? cityName; // أضفنا المدينة
  // إذا كان للممرضين تخصصات (مثل رعاية مسنين، أطفال إلخ) أضف specialtyId

  FilterNurses({this.name, this.cityName});
}
