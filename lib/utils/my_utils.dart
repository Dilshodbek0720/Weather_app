class MyUtils {
  static DateTime getDateTime(int dt) => DateTime.fromMillisecondsSinceEpoch(dt * 1000);

  static List<String> getPlaceNames() => [
        "Tashkent",
        "Andijan",
        "Olmazor",
        "London",
        "Asaka",
        "Chust",
        "Fergana",
        "Samarkand",
        "Bukhara",
        "Moscow",
      ];
}
