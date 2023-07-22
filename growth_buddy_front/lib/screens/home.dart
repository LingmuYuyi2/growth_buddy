// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'dart:convert';

import '../helpers/database_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  File? _imageFile;
  int threshold = 1;
  String apiResponse = '';
  Future<String>? apiResponseFuture;

  int keikenchi = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = TweenSequence<Offset>(
      [
        TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: const Offset(0, 0),
            end: const Offset(-0.1, 0),
          ),
          weight: 0.33,
        ),
        TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: const Offset(-0.1, 0),
            end: const Offset(0.1, 0),
          ),
          weight: 0.33,
        ),
        TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: const Offset(0.1, 0),
            end: const Offset(0, 0),
          ),
          weight: 0.33,
        ),
      ],
    ).animate(_animationController);

    _loadSavedImageFile();
  }

  Widget _buildExperienceWidget() {
    return FutureBuilder<int>(
      future: getExperience(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int experience = snapshot.data!;
          int level = experience ~/ 150 + 1;
          int nextlevel = 150 - (experience % 150);
          return Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.amber,
                width: 4.0,
              ),
              color: Colors.white, // 中身の色を白に設定
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              '現在のレベル: $level\n次のレベルまであと: $nextlevel',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('経験値の取得に失敗しました');
        } else {
          return const Text('経験値を取得中...');
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _loadSavedImageFile({bool forceUpdate = false}) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/myImage.png';
    final file = File(filePath);
    bool exist = await file.exists();
    if (exist) {
      setState(() {
        imageCache.clear();
        imageCache.clearLiveImages();
        _imageFile = file;
      });
    } else {
      setState(() {
        _imageFile = null;
      });
    }
  }

  Future<String> _accessAPIIfThresholdReached() async {
    final helper = DatabaseHelper.instance;

    int count = await helper.getCount();
    // print(count);

    // レコードの総数が一定の閾値に達しているなら、APIへアクセスします。
    if (count >= threshold) {
      // final url = Uri.parse('http://127.0.0.1:8000/generate_image/');
      final url = Uri.parse('http://192.168.143.190:8000/generate_image/');
      // final url = Uri.parse('http://127.0.0.1:8000/sample_image/');
      // final url = Uri.parse('http://127.0.0.1:8000/healthz/');

      // リクエストヘッダーの設定
      Map<String, String> headers = {'Content-Type': 'application/json'};
      // テキストの取得
      List<Map<String, dynamic>> textsAndEfforts =
          await _getTextsAndEffortsFromDatabase();
      // 画像の読み込み
      String image = await _getImageData();
      // last updated
      String lastUpdate = await _getLastUpdated();

      // リクエストボディの設定
      Map<String, dynamic> requestBody = {
        'info': jsonEncode(textsAndEfforts),
        'image': image,
        'position': lastUpdate,
      };

      // POSTリクエストの送信
      // var response = await http.get(url);
      var response =
          await http.post(url, headers: headers, body: jsonEncode(requestBody));
      // print(response.body);
      // print(lastUpdate);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var image = data['image'];
        var lastUpdate = data['changed_position']; // backendの属性名による

        // return data; // return the parsed data
        var imageBytes = base64Decode(image);
        await _writeImageDataToFile(imageBytes);
        // print("finish whiteImage");
        await helper.resetCount();
        await helper.writeLastUpdated(lastUpdate);
        return image;
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load data from API');
      }
    }
    return 'Threshold not reached';
  }

  Future<File> _writeImageDataToFile(Uint8List data) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    // print(path);
    final filePath = '$path/myImage.png';
    final file = File(filePath);
    await file.writeAsBytes(data);
    // print('Wrote image data to $filePath');
    return file;
  }

  Future<String> _getLastUpdated() async {
    final helper = DatabaseHelper.instance;
    String lastUpdate = await helper.getLastUpdated();
    return lastUpdate;
  }

  Future<List<Map<String, dynamic>>> _getTextsAndEffortsFromDatabase() async {
    final helper = DatabaseHelper.instance;
    List<Map<String, dynamic>> textsAndEfforts =
        await helper.getTextsAndEffort();
    return textsAndEfforts;
  }

  Future<String> _getImageData() async {
    List<int> byteList;
    if (_imageFile == null) {
      print("assets");
      ByteData imageBytes = await rootBundle.load('assets/images/basecat.png');
      byteList = imageBytes.buffer.asUint8List();
    } else {
      print("non assets");
      byteList = await _imageFile!.readAsBytes();
    }
    String base64Image = base64Encode(byteList);
    return base64Image;
  }

  Future<int> getExperience() async {
    final helper = DatabaseHelper.instance;
    int experience = await helper.getExperience();
    print(experience);
    return experience;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Home Screen'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/shibahu.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 20.0,
              left: 20.0,
              child: Transform.scale(
                scale: 1.5,
                child: Image.asset(
                  'assets/images/inugoya.png',
                ),
              ),
            ),
            Positioned(
              top: 50.0,
              left: 20.0,
              child: _buildExperienceWidget(), // 経験値を表示するウィジェットを配置
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: GestureDetector(
                  onTap: startAnimation,
                  child: SlideTransition(
                    position: _animation,
                    // child: Image.asset('assets/images/niwatori_hiyoko_koushin.png'),
                    // child: _imageFile != null ? Image.file(_imageFile!) : Image.asset('assets/images/niwatori_hiyoko_koushin.png'),
                    child: _imageFile != null
                        ? Image.file(_imageFile!, key: UniqueKey())
                        : Image.asset('assets/images/basecat.png',
                            key: UniqueKey()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String result =
              await _accessAPIIfThresholdReached(); // ボタンが押されたときにAPIを呼び出す
          if (result == 'Threshold not reached') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('まだ変身できないようです...'),
              ),
            );
          } else {
            await _loadSavedImageFile(forceUpdate: true);
          }
        },
        label: const Text('変身'),
        icon: const Icon(Icons.transform),
      ),
    );
  }
}
