import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/record.dart';

class AchieveListScreen extends StatefulWidget {
  const AchieveListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AchieveListScreenState createState() => _AchieveListScreenState();
}

class _AchieveListScreenState extends State<AchieveListScreen> {
  late Future<List<Record>> _recordList;

  @override
  void initState() {
    super.initState();
    _updateRecordList();
  }

  void _updateRecordList() {
    setState(() {
      _recordList = DatabaseHelper.instance.getRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: FutureBuilder(
        future: _recordList,
        builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            print(snapshot);
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              Record record = snapshot.data![snapshot.data!.length - 1 - index];

              return ListTile(
                title: Text('Category: ${record.category}'),
                subtitle: Text('Comment: ${record.content}\nEffort: ${record.effort.toString()}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteRecord(record.id!);
                    _updateRecordList();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
