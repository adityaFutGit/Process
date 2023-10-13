// ignore_for_file: file_names, unnecessary_this

class Holiday {
  int id;
  DateTime date;
  String name;

  Holiday(
    this.id,
    this.date,
    this.name,
  );

  @override
  String toString() {
    return '{${this.id},${this.date},${this.name}}';
  }

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      json['id'],
      DateTime.parse(json['date']),
      json['name'],
    );
  }
}
