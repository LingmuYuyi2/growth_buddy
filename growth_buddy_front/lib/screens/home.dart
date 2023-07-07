// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: const Offset(0, 0),
    ).animate(_animationController);
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

  Future<File?> _getSavedImageFile({bool forceUpdate = false}) async {
    if (forceUpdate) {
      setState(() {});  // 状態の更新をトリガーしてウィジェットを再構築します
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/myImage.png';
    final file = File(filePath);
    bool exist = await file.exists();  // ファイルが存在するかどうかを確認
    if (exist) {
      return file;
    } else {
      return null;
    }
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
              right: 20.0,
              child: Transform.scale(
                scale: 1.5,
                child: Image.asset(
                  'assets/images/inugoya.png',
                ),
              ),
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
                    child: FutureBuilder<File?>(
                      future: _getSavedImageFile(),  // 保存されている画像ファイルを取得
                      builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();  // ローディング表示
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          File? imageFile = snapshot.data;
                          if (imageFile != null) {
                            // 保存されている画像が存在する場合は、その画像を表示
                            return SlideTransition(
                              position: _animation,
                              child: Image.file(imageFile),
                            );
                          } else {
                            // 画像が存在しない場合は、デフォルトの画像を表示
                            return SlideTransition(
                              position: _animation,
                              child: Image.asset('assets/images/niwatori_hiyoko_koushin.png'),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _getSavedImageFile(forceUpdate: true);  // 更新ボタンが押されたときに_getSavedImageFileを再実行
        },
        label: Text('変身'),
        icon: Icon(Icons.transform),
      ),
    );
  }
}






