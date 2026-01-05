import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cots/config/api_config.dart';
import 'package:cots/models/task.dart';

class TaskService {

  
  Future<List<Task>> getTasks({String? status}) async {
    String url = "${ApiConfig.baseUrl}/tasks?select=*";
    if (status != null && status != 'Semua') {
      url += "&status=eq.$status";
    }

    final response = await http.get(Uri.parse(url), headers: ApiConfig.headers);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> addTask(Task task) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/tasks");
    print("Mencoba POST ke: $url"); // Cek URL
    print("Data dikirim: ${jsonEncode(task.toJson())}"); // Cek Data JSON

    final response = await http.post(
      url,
      headers: ApiConfig.headers,
      body: jsonEncode(task.toJson()),
    );

    print("--- DEBUG RESPONSE ---");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("----------------------");

    if (response.statusCode == 201) {
      List data = jsonDecode(response.body);
      return Task.fromJson(data[0]);
    } else {
      // Sekarang errornya akan membawa pesan asli dari server
      throw Exception('Gagal POST: ${response.statusCode} - ${response.body}');
    }
  }
  
  // Future<Task> addTask(Task task) async {
  //   final response = await http.post(
  //     Uri.parse("${ApiConfig.baseUrl}/tasks"),
  //     headers: ApiConfig.headers,
  //     body: jsonEncode(task.toJson()),
  //   );

  //   if (response.statusCode == 201) {
  //     List data = jsonDecode(response.body);
  //     return Task.fromJson(data[0]);
  //   } else {
  //     throw Exception('Failed to add task');
  //   }
  // }

  Future<void> updateTaskStatus(int id, bool isDone) async {
    final status = isDone ? "SELESAI" : "BERJALAN";
    final body = {
      "is_done": isDone,
      "status": status,
    };

    await http.patch(
      Uri.parse("${ApiConfig.baseUrl}/tasks?id=eq.$id"),
      headers: ApiConfig.headers,
      body: jsonEncode(body),
    );
  }

  Future<void> updateTaskNote(int id, String note) async {
    await http.patch(
      Uri.parse("${ApiConfig.baseUrl}/tasks?id=eq.$id"),
      headers: ApiConfig.headers,
      body: jsonEncode({"note": note}),
    );
  }
}