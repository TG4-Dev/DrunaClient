class Field {
  // Генерация данных для времени и полосок
  List<Map<String, dynamic>> generateData(int days) {
    final List<Map<String, dynamic>> data = [];
    for (int i = 0; i < 24 * days; i++) {
      data.add({
        "time": "${(i % 24).toString().padLeft(2, '0')}:00",
        "barWidth": 2,
      });

      data.add({"time": "", "barWidth": 1});
    }
    return data;
  }
}
