import 'ToggableItem.dart';

class Filters {
  List<String> locations;
  List<TogglableItem> prices;
  List<TogglableItem> foodCategories;
  List<TogglableItem> tags;

  Filters({required this.locations, required this.prices, required this.foodCategories, required this.tags});
}
