import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const url = 'http://10.0.2.2:5000/todos';

void main() => runApp(MaterialApp(home: TodoApp(), debugShowCheckedModeBanner: false));

class TodoApp extends StatefulWidget {
  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List todos = [];
  final c = TextEditingController();

  void load() async {
    final r = await http.get(Uri.parse(url));
    setState(() => todos = json.decode(r.body));
  }

  void add() async {
    if (c.text.isEmpty) return;
    await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': c.text}));
    c.clear();
    load();
  }

  void toggle(int id) async {
    await http.put(Uri.parse('$url/$id'));
    load();
  }

  void del(int id) async {
    await http.delete(Uri.parse('$url/$id'));
    load();
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('TODO')),
        body: Column(children: [
          Row(children: [
            Expanded(child: TextField(controller: c, decoration: InputDecoration(hintText: 'Task'))),
            IconButton(onPressed: add, icon: Icon(Icons.add))
          ]),
          Expanded(
            child: ListView(
              children: todos.map((t) {
                return ListTile(
                  leading: Checkbox(value: t['done'], onChanged: (_) => toggle(t['id'])),
                  title: Text(t['title']),
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => del(t['id'])),
                );
              }).toList(),
            ),
          )
        ]),
      );
}
