// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Cubit/Todo_Cubit.dart';
import 'package:todoapp/Cubit/Todo_States.dart';
import 'package:todoapp/Widgets/Task_Container.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    super.key,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) => BlocProvider.of<TodoCubit>(context)
                  .newTasks
                  .length !=
              0
          ? ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => TaskContainer(
                  model: BlocProvider.of<TodoCubit>(context).newTasks[index]),
              separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[200],
              ),
              itemCount: BlocProvider.of<TodoCubit>(context).newTasks.length,
            )
          : const Center(
              child: Image(image: AssetImage("assets/add.png")),
            ),
    );
  }
}
