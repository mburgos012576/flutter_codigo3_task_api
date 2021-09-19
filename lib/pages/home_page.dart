import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo3_api_tasks/models/task_models.dart';
import 'package:flutter_codigo3_api_tasks/widgets/input_widget_dialog.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List listTask = [];
  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  TextEditingController _controllerCompleted = TextEditingController();

  @override
  initState() {
    super.initState();
    getData();
  }

  getData() async {
    String _path = "http://192.168.1.9:8000/api/task-list/";
    Uri _uri = Uri.parse(_path);
    http.Response response = await http.get(_uri);
    //print(response.body);
    if (response.statusCode == 200) {
      listTask = json.decode(response.body);
      setState(() {});
    }
  }

  updateTask(Map task) async {
    String _path = "http://192.168.1.9:8000/api/task-update/${task["id"]}/";
    Uri _uri = Uri.parse(_path);
    http.Response response = await http.post(
      _uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "title": task["title"], //"Editado desde Flutter",
        "description": task["description"], //"Descripcion desde flutter",
        "completed": task["completed"],
      }),
    );
    //print(response.body);
    if (response.statusCode == 200) {
      print("actualizadoooooooooo");
      setState(() {});
    }
  }

  deleteTask(int id) async {
    String _path = "http://192.168.1.9:8000/api/task-delete/$id/";
    Uri _uri = Uri.parse(_path);
    http.Response response = await http.delete(_uri);
    //print(response.body);
    if (response.statusCode == 200) {
      print("Eliminado");
      setState(() {
        getData();
      });
    }
  }

  addTask(Map task) async {
    String _path = "http://192.168.1.9:8000/api/task-create/";
    Uri _uri = Uri.parse(_path);
    http.Response response = await http.post(
      _uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "title": task["title"],
        "description": task["description"],
        "completed": task["completed"],
      }),
    );
    //print(response.body);
    if (response.statusCode == 200) {
      print("creadoooooooo");
      setState(() {
        getData();
      });
    }
  }

  showModalAdd(BuildContext context, bool add) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ingresar Task"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "images/task.png",
                  fit: BoxFit.cover,
                  height: 60.0,
                ),
                SizedBox(
                  height: 10,
                ),
                InputWidgetDialog(
                  controller: _controllerTitle,
                  icon: Icons.title_outlined,
                  hint: "Title",
                ),
                SizedBox(
                  height: 10,
                ),
                InputWidgetDialog(
                  controller: _controllerDescription,
                  icon: Icons.description_outlined,
                  hint: "Description",
                ),
                SizedBox(
                  height: 10,
                ),
                InputWidgetDialog(
                  controller: _controllerCompleted,
                  icon: Icons.check,
                  hint: "Completed",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.black38),
              ),
            ),
            TextButton(
              onPressed: () {
                Task data = new Task(
                  title: _controllerTitle.text,
                  description: _controllerDescription.text,
                  completed: _controllerCompleted.text,
                );
                addTask(data.convertirAMap());
                getData();
                Navigator.pop(context);
                },
              child: Text(
                "Aceptar",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: IconButton(
        icon: Icon(
          Icons.add_circle,
          color: Colors.blue,
          size: 40.0,
        ),
        onPressed: () {
          showModalAdd(context, true);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bienvenido",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        "My Tasks",
                        style: TextStyle(
                          color: Color(0xff454545),
                          fontWeight: FontWeight.w700,
                          fontSize: 40.0,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 26.0,
                    backgroundImage: NetworkImage(
                        "https://cdn.alfabetajuega.com/wp-content/uploads/2021/06/Dragon-Ball-Super-Las-batallas-del-manga-que-nunca-vimos-en-la-serie-animada.jpg"),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //ListTaskWidget(),
              ListView.builder(
                itemCount: listTask.length,
                primary: true,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onLongPress: () {
                      deleteTask(listTask[index]["id"]);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12.withOpacity(0.04),
                              offset: Offset(2, 6),
                              blurRadius: 12.0),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          listTask[index]["title"],
                          style: TextStyle(
                            decoration: listTask[index]["completed"]
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(listTask[index]["description"]),
                        trailing: Checkbox(
                          value: listTask[index]["completed"],
                          onChanged: (bool? value) {
                            listTask[index]["completed"] =
                                value; //cambia valor del checkbox
                            updateTask(listTask[index]);
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
