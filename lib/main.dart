import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Todo {
  final String task;
  bool completed;

  Todo({required this.task, this.completed = false});
}

class TodoList extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(String task) {
    _todos.add(Todo(task: task));
    notifyListeners();
  }

  void toggleTodoCompleted(int index) {
    _todos[index].completed = !_todos[index].completed;
    notifyListeners();
  }

  void deleteCompletedTodos() {
    _todos.removeWhere((todo) => todo.completed);
    notifyListeners();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoList(),
      child: MaterialApp(
        title: 'Todo App',
        home: TodoScreen(),
      ),
    );
  }
}

class TodoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TodoList todoList = Provider.of<TodoList>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter a task',
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onSubmitted: (value) {
              todoList.addTodo(value);
              _controller.clear();
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.todos.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  value: todoList.todos[index].completed,
                  title: Text(todoList.todos[index].task),
                  onChanged: (_) {
                    todoList.toggleTodoCompleted(index);
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            child: Text('Delete completed todos'),
            onPressed: () {
              todoList.deleteCompletedTodos();
            },
          ),
        ],
      ),
    );
  }
}