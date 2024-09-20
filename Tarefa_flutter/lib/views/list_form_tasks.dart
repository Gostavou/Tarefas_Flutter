import 'package:flutter/material.dart';
import 'package:new_project/models/task_model.dart';
import 'package:new_project/services/task_service.dart';

class CreateTasks extends StatefulWidget {
  final Task? task;
  final int? index;
  const CreateTasks({super.key, this.task, this.index});

  @override
  State<CreateTasks> createState() => _CreateTasksState();
}

class _CreateTasksState extends State<CreateTasks> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TaskService taskService = TaskService();

  String _priority = 'Baixa';
  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title!;
      _descriptionController.text = widget.task!.description!;
      _priority = widget.task!.priority ?? 'Baixa';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.task != null ? 'Editar tarefa' : 'Criar nova tarefa'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* Titulo não preenchido';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Titulo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* Descrição não preenchida';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prioridade'),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text('Baixa'),
                            leading: Radio<String>(
                              value: 'Baixa',
                              groupValue: _priority,
                              onChanged: (value) {
                                setState(() {
                                  _priority = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text('Média'),
                            leading: Radio<String>(
                              value: 'Média',
                              groupValue: _priority,
                              onChanged: (value) {
                                setState(() {
                                  _priority = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text('Alta'),
                            leading: Radio<String>(
                              value: 'Alta',
                              groupValue: _priority,
                              onChanged: (value) {
                                setState(() {
                                  _priority = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String titleNewTask = _titleController.text;
                    String descriptionNewTask = _descriptionController.text;
                    if (widget.task != null && widget.index != null) {
                      await taskService.editTask(
                        widget.index!,
                        titleNewTask,
                        descriptionNewTask,
                        false,
                        _priority,
                      );
                    } else {
                      await taskService.saveTask(
                        titleNewTask,
                        descriptionNewTask,
                        false,
                        _priority,
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.task != null
                    ? 'Alterar Tarefa'
                    : 'Adicionar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
