import 'dart:convert';
import 'package:new_project/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  Future<void> saveTask(
      String title, String description, bool isDone, String priority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task task = Task(
        title: title,
        description: description,
        isDone: isDone,
        priority: priority);
    tasks.add(jsonEncode(task.toJson()));
    await prefs.setStringList('tasks', tasks);
    print('Tarefa adicionada');
  }

  Future<void> editTask(int index, String title, String description,
      bool isDone, String priority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task task = Task(
        title: title,
        description: description,
        isDone: isDone,
        priority: priority);
    tasks[index] = jsonEncode(task.toJson());
    await prefs.setStringList('tasks', tasks);
    print('Tarefa editada');
  }

  Future<void> deleteTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    tasks.removeAt(index);
    await prefs.setStringList('tasks', tasks);
    print('Tarefa deletada');
  }

  Future<List<Task>> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    return tasks.map((task) => Task.fromJson(jsonDecode(task))).toList();
  }

  Future<void> editTaskByCheckBox(int index, bool isDone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task task = Task.fromJson(jsonDecode(tasks[index]));
    task.isDone = isDone;
    tasks[index] = jsonEncode(task.toJson());
    await prefs.setStringList('tasks', tasks);
  }
}
