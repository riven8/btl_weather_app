import 'package:btl_weather_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3)) //sau khi màn hình WelcomeScreen được khởi tạo, nó sẽ chờ 3 giây
        .then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()))); //Điều hướng người dùng đến HomeScreen()
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF676BD0), // Màu backgroud
      body: Container(
        height: MediaQuery.of(context).size.height, // Tự thích ứng kích thước với màn hình điện thoại
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            height: 250,
            width: 250,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(
                  'assets/weather.png',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
