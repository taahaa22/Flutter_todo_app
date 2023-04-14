// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //a library used to get date and time

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Todo App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [];

  void _addTodo() async {
    final newTodo = await showDialog<Todo>(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String description = '';
        DateTime dateTime = DateTime.now();

        return SingleChildScrollView(
          child: Center(
            child: AlertDialog(
              title: Text('Add Todo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    onChanged: (value) => title = value,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Description'),
                    onChanged: (value) => description = value,
                  ),
                  ListTile(
                    title:
                        Text('Date: ${DateFormat.yMMMEd().format(dateTime)}'),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: dateTime,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          dateTime = DateTime(pickedDate.year, pickedDate.month,
                              pickedDate.day, dateTime.hour, dateTime.minute);
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Time: ${DateFormat.jm().format(dateTime)}'),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(dateTime),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          dateTime = DateTime(dateTime.year, dateTime.month,
                              dateTime.day, pickedTime.hour, pickedTime.minute);
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text('Add'),
                  onPressed: () {
                    final newTodo = Todo(
                      title: title,
                      description: description,
                      isDone: false,
                      dateTime: dateTime,
                    );
                    Navigator.of(context).pop(newTodo);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (newTodo != null) {
      setState(() {
        todos.add(newTodo);
      });
    }
  }

  void _toggleDone(int index) {
    setState(() {
      todos[index].isDone = !todos[index].isDone;
    });
  }

  void _editTodo(BuildContext context, int index) async {
    final editedTodo = await showDialog<Todo>(
      context: context,
      builder: (BuildContext context) {
        String title = todos[index].title;
        String description = todos[index].description;
        DateTime dateTime = todos[index].dateTime;

        return SingleChildScrollView(
          child: Center(
            child: AlertDialog(
              title: const Text('Edit Todo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    onChanged: (value) => title = value,
                    controller: TextEditingController()..text = title,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Description'),
                    onChanged: (value) => description = value,
                    controller: TextEditingController()..text = description,
                  ),
                  ListTile(
                    title:
                        Text('Date: ${DateFormat.yMMMEd().format(dateTime)}'),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: dateTime,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          dateTime = DateTime(pickedDate.year, pickedDate.month,
                              pickedDate.day, dateTime.hour, dateTime.minute);
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Time: ${DateFormat.jms().format(dateTime)}'),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(dateTime),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          dateTime = DateTime(dateTime.year, dateTime.month,
                              dateTime.day, pickedTime.hour, pickedTime.minute);
                        });
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        child: Text('Save'),
                        onPressed: () {
                          final editedTodo = Todo(
                            title: title,
                            description: description,
                            isDone: todos[index].isDone,
                            dateTime: dateTime,
                          );
                          Navigator.of(context).pop(editedTodo);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );

    if (editedTodo != null) {
      setState(() {
        todos[index] = editedTodo;
      });
    }
  }

  void _deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Checkbox(
              value: todos[index].isDone,
              onChanged: (bool? value) {
                _toggleDone(index);
              },
            ),
            title: Text(
              todos[index].title,
              style: TextStyle(
                decoration: todos[index].isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(todos[index].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(DateFormat.yMEd().format(todos[index].dateTime)),
                Text(DateFormat.jm().format(todos[index].dateTime)),
                IconButton(
                  color: Colors.green,
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editTodo(context, index);
                  },
                ),
                IconButton(
                  color: Colors.redAccent,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteTodo(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Todo {
  String title;
  String description;
  bool isDone;
  DateTime dateTime;

  Todo({
    required this.title,
    required this.description,
    required this.isDone,
    required this.dateTime,
  });
}
