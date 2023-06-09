import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/todo.dart';
import '../../logic/bloc/todo/todo_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

// created the ScaffoldState key
  final _scaffoldState = GlobalKey<ScaffoldState>();

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: const Text('Todo Firebase'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scaffoldState.currentState?.showBottomSheet(
            (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: 'Enter Todo Title'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<TodoBloc>(context).add(
                        TodoCreated(
                          title: _controller.text,
                        ),
                      );

                      _controller.text = '';

                      Navigator.pop(context);
                    },
                    child: const Text('Save Todo'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          // ! Loading
          if (state is TodoFetchInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // ! Success
          else if (state is TodoFetchSuccess) {
            List<Todo> todos = state.todos;

            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index];

                return Card(
                  child: CheckboxListTile(
                    value: todo.isComplete,
                    title: Text(todo.title),
                    onChanged: (value) {
                      BlocProvider.of<TodoBloc>(context).add(
                        TodoUpdated(
                          todo: todo,
                          isComplete: value ?? false,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          // ! Error
          else if (state is TodoFetchFailure) {
            return Center(
              child: Text(state.message.toString()),
            );
          }
          // ! Other
          else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
