
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Доходи/Витрати',
      home: const TransactionsPage(),
    );
  }
}

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Доходи і витрати')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final amount = data['amount'] as int;
              final description = data['description'] ?? '';
              final color = amount < 0 ? Colors.red : Colors.green;

              return ListTile(
                leading: Icon(amount < 0 ? Icons.remove : Icons.add, color: color),
                title: Text(description),
                trailing: Text(
                  '$amount ₴',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
