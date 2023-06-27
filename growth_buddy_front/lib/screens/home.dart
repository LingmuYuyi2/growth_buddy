import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
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
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0.2, 0),
      end: Offset(0, 0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Home Screen'),
      ),
      body: Container(
        decoration: BoxDecoration(
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
                    child: Image.asset('assets/images/niwatori_hiyoko_koushin.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






