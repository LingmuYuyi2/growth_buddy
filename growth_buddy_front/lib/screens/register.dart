import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? dropdownValue;
  String comment = '';
  double selectedEffort = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Category:'),
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
            SizedBox(height: 20),
            Text('Comment:'),
            TextField(
              onChanged: (text) {
                setState(() {
                  comment = text;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your comment here',
              ),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Process your data here
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
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
