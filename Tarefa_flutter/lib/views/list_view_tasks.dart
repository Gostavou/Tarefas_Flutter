import 'package:flutter/material.dart';
import 'package:new_project/models/task_model.dart';
import 'package:new_project/services/task_service.dart';
import 'package:new_project/views/list_form_tasks.dart';

class ListViewTasks extends StatefulWidget {
  const ListViewTasks({super.key});

  @override
  State<ListViewTasks> createState() => _ListViewTasksState();
}

class _ListViewTasksState extends State<ListViewTasks> {
  TaskService taskService = TaskService();
  List<Task> tasks = [];

  getAllTasks() async {
    tasks = await taskService.getTasks();
    setState(() {});
  }

  @override
  void initState() {
    getAllTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          bool localIsDone = tasks[index].isDone ?? false;
          String priority = tasks[index].priority ?? 'Baixa';

          Color priorityColor;
          switch (priority) {
            case 'Alta':
              priorityColor = Colors.red;
              break;
            case 'Média':
              priorityColor = Colors.amber;
              break;
            case 'Baixa':
            default:
              priorityColor = Colors.green;
              break;
          }

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tasks[index].title.toString(),
                      style: TextStyle(
                        fontSize: 27,
                        color: localIsDone ? Colors.grey : Colors.blue,
                      ),
                    ),
                    Checkbox(
                      value: tasks[index].isDone ?? false,
                      onChanged: (value) {
                        if (value != null) {
                          taskService.editTaskByCheckBox(index, value);
                        }
                        setState(() {
                          tasks[index].isDone = value;
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  tasks[index].description.toString(),
                  style: TextStyle(fontSize: 27, color: Colors.black87),
                ),
                Text(
                  'Prioridade: $priority',
                  style: TextStyle(
                    fontSize: 20,
                    color: priorityColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await taskService.deleteTask(index);
                        getAllTasks();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    if (!localIsDone)
                      IconButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateTasks(
                                task: tasks[index],
                                index: index,
                              ),
                            ),
                          ).then((value) => getAllTasks());
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
