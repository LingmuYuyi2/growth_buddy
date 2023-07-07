import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../models/record.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? dropdownValue;
  String comment = '';
  double selectedEffort = 1;
  int threshold = 1;
  String apiResponse = ''; // APIからのレスポンスを保持する
  Future<String>? apiResponseFuture;
  DateTime selectedDate = DateTime.now(); // 日付を保持
  

  Future<void> _saveRecord() async {
    final record = Record(
      category: dropdownValue ?? '',
      content: comment,
      effort: selectedEffort,
      date: DateFormat('yyyy-MM-dd').format(selectedDate), // 直接代入
    );


    final helper = DatabaseHelper.instance;
    await helper.insertRecord(record);
    await helper.incrementCount();

    // レコードの保存が完了した後の処理
    _showSaveSuccessMessage();
  }
 
  void _showSaveSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('保存が完了しました'),
      ),
    );
  }

  
  

  Future<void> _selectDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime.now().subtract(const Duration(days: 1)),
    lastDate: DateTime.now(),
  );

  if (pickedDate != null) {
    setState(() {
      selectedDate = pickedDate; // 日付を文字列に変換して保存
    });
  }
}
 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Category:'),
            DropdownButton<String>(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['勉強', '趣味', '家事', 'サークル', '就活']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: TextEditingController(text: DateFormat('yyyy/M/d').format(selectedDate)),
              onTap: () => _selectDate(context),
              readOnly: true,  // ユーザーが直接入力できないようにします
              decoration: const InputDecoration(
                labelText: "Date",
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Comment:'),
            TextField(
              onChanged: (text) {
                setState(() {
                  comment = text;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your comment here',
              ),
            ),
            const SizedBox(height: 20),
            Text('Effort: ${_getEffortLabel(selectedEffort)}'),
            Slider(
              value: selectedEffort,
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (double values) {
                setState(() {
                  selectedEffort = values;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecord,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
          ],
      ),
        )
    )
    );
  }


  String _getEffortLabel(double value) {
    switch (value.toInt()) {
      case 1:
        return 'ちょっと';
      case 2:
        return 'まあまあ';
      case 3:
        return '普通';
      case 4:
        return 'かなり';
      case 5:
        return 'とても';
      default:
        return '';
    }
  }
}