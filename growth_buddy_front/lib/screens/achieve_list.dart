import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/record.dart';

class AchieveListScreen extends StatefulWidget {
  const AchieveListScreen({Key? key}) : super(key: key);

  @override
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

  String getEffortText(double effort) {
    if (effort == 1.0) {
      return 'ちょっと';
    } else if (effort == 2.0) {
      return 'まあまあ';
    } else if (effort == 3.0) {
      return '普通';
    } else if (effort == 4.0) {
      return 'かなり';
    } else if (effort == 5.0) {
      return 'とても';
    } else {
      return '不明';
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case '勉強':
        return Colors.orange;
      case '趣味':
        return Colors.purpleAccent;
      case '家事':
        return Colors.red;
      case 'サークル':
        return Colors.lightBlue;
      case '就活':
        return Colors.green;
      default:
        return Colors.black;
    }
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Colors.grey.withOpacity(0.5),
                thickness: 1.0,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              Record record = snapshot.data![snapshot.data!.length - 1 - index];

              return ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'Category: ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: record.category,
                        style: TextStyle(
                          color: getCategoryColor(record.category),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Effort: ${getEffortText(record.effort)}'),
                    Text('Date: ${record.date.toString()}'), // 日付を表示する部分
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        color: Colors.grey.withOpacity(0.2),
                        padding: EdgeInsets.all(10.0),
                        child: Text(record.content),
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteRecord(record.id!);
                    _updateRecordList();
                  },
                ),
              );
            }
          );
         })
    );
  }
}
              