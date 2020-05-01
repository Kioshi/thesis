import 'ToggableItem.dart';

class Filters {
  List<String> locations;
  List<TogglableItem> prices;
  List<TogglableItem> foodCategories;
  List<TogglableItem> tags;

  Filters({this.locations, this.prices, this.foodCategories, this.tags});
}
