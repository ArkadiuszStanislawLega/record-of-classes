
abstract class DbModel<T> {
  T? getFromDb();
  void addToDb();
  void removeFromDb();
  void update(T updatedObject);
}
