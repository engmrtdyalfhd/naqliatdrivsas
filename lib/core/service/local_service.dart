import '../helper/constant.dart';
import 'package:hive_flutter/hive_flutter.dart';

final class LocalService {
  const LocalService._();
  static LocalService? _instance;
  static LocalService get instance => _instance ??= const LocalService._();

  Future<void> init() async {
    await Hive.initFlutter();
    // await Hive.clear(ConstHive.userKey);
    // Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox(ConstHive.defaultBox);
  }

  // Save a value
  Future<void> save<T>({required String key, required T value}) async {
    final box = Hive.box(ConstHive.defaultBox);
    await box.put(key, value);
  }

  // Get a value
  T? get<T>(String key) {
    final box = Hive.box(ConstHive.defaultBox);
    return box.get(key) as T?;
  }

  // Delete a value
  // Future<void> delete(String key) async {
  //   final box = Hive.box(key);
  //   await box.deleteFromDisk();
  // }

  // Check if a key exists
  bool containsKey(String key) {
    final box = Hive.box(ConstHive.defaultBox);
    return box.containsKey(key);
  }

  // Clear all data in the box
  Future<void> clear(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  // Get saved user model
  // UserModel get user => instance.get(ConstHive.userKey);
}

// extension RecentSearches on LocalService {
//   // ! Save a new search query to recent searches
//   Future<void> saveRecentSearch(String query) async {
//     if (query.isEmpty) return; // Ignore empty queries
//     final recent = get<List<String>>(ConstHive.recentSearchesKey) ?? [];
//     // Remove the query if it already exists to prevent duplicates
//     recent.remove(query);
//     // Add the query to the start of the list
//     recent.insert(0, query);
//     // Ensure the list doesn't exceed the maximum size
//     if (recent.length > ConstNum.maxSearches) recent.removeLast();
//     // Save the updated list back to Hive
//     await save(key: ConstHive.recentSearchesKey, value: recent);
//   }

//   // ! Retrieve the list of recent searches
//   List<String> getRecentSearches() {
//     return get<List<String>>(ConstHive.recentSearchesKey) ?? [];
//   }
// }
