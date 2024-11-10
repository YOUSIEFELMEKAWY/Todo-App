import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Cubit/Todo_Cubit.dart';
import 'package:todoapp/Cubit/Todo_States.dart';
import 'package:todoapp/Widgets/Default_Form_Field.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController titleC = TextEditingController();
  TextEditingController timeC = TextEditingController();
  TextEditingController dateC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createDataBase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {
          if (state is insertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
                BlocProvider.of<TodoCubit>(context)
                    .Titles[BlocProvider.of<TodoCubit>(context).currentIndex],
                style: const TextStyle(
                    color: Color(0XFF407BFF),
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
          ),
          floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0), // Set the border radius for a rounded rectangle
            ),
              elevation: 0,
              backgroundColor: const Color(0XFF407BFF),
              onPressed: () {
                if (BlocProvider.of<TodoCubit>(context).isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    BlocProvider.of<TodoCubit>(context).insertToDatabase(
                        date: dateC.text, time: timeC.text, title: titleC.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        backgroundColor: Colors.white,
                        enableDrag: true,
                        (context) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Container(
                                    width: 60,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ),
                                defaultFormField(
                                  controller: titleC,
                                  icon: Icons.title,
                                  textInputType: TextInputType.text,
                                  title: 'Title',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  controller: timeC,
                                  icon: Icons.timer_sharp,
                                  textInputType: TextInputType.datetime,
                                  title: 'Time',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  ontap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeC.text = value!.format(context);
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  controller: dateC,
                                  icon: Icons.date_range_outlined,
                                  textInputType: TextInputType.datetime,
                                  title: 'Date',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  ontap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2024-12-31'))
                                        .then((value) {
                                      dateC.text =
                                          '${value!.year.toString()} - ${value.month.toString()} - ${value.day.toString()}';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                    titleC.clear();
                    timeC.clear();
                    dateC.clear();
                    BlocProvider.of<TodoCubit>(context)
                        .changeIcon(icon: Icons.add, isShown: false);

                    BlocProvider.of<TodoCubit>(context).isBottomSheetShown =
                        false;
                  });
                  BlocProvider.of<TodoCubit>(context)
                      .changeIcon(icon: Icons.done, isShown: true);
                  BlocProvider.of<TodoCubit>(context).isBottomSheetShown = true;
                }
              },
              child: Icon(BlocProvider.of<TodoCubit>(context).fButton,color: Colors.white,)),
          bottomNavigationBar: BottomNavigationBar(
            selectedIconTheme: const IconThemeData(color: Colors.blue),
            unselectedIconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            currentIndex: BlocProvider.of<TodoCubit>(context).currentIndex,
            onTap: (value) {
              BlocProvider.of<TodoCubit>(context).changeIndex(value);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline_outlined),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined),
                label: 'Archived',
              ),
            ],
          ),
          body: BlocProvider.of<TodoCubit>(context)
              .screens[BlocProvider.of<TodoCubit>(context).currentIndex],
        ),
      ),
    );
  }
}
