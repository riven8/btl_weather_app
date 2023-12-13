import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeeklyWeatherScreen extends StatefulWidget {
  const WeeklyWeatherScreen({Key? key}) : super(key: key);

  @override
  _WeeklyWeatherScreenState createState() => _WeeklyWeatherScreenState();
}

class _WeeklyWeatherScreenState extends State<WeeklyWeatherScreen> {
  late Future<List<WeatherInfo>> weeklyWeather;

  @override
  void initState() {
    super.initState();
    weeklyWeather = fetchWeeklyWeather();
  }

  Future<List<WeatherInfo>> fetchWeeklyWeather() async {
  final response = await http.get(Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast?q=HaNoi&units=metric&appid=82d78aef7a2755507e23056a5b7b885f"));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    List<dynamic> list = jsonResponse['list'];

    // Danh sách để lưu trữ thông tin thời tiết cho mỗi ngày
    List<WeatherInfo> uniqueWeatherList = [];

    for (var weatherJson in list) {
      WeatherInfo weatherInfo = WeatherInfo.fromJson(weatherJson);

      // Lấy ngày từ thông tin thời tiết
      String day = weatherInfo.day;

      // Kiểm tra xem ngày đã được thêm vào danh sách chưa
      if (!uniqueWeatherList.any((element) => element.day == day)) {
        uniqueWeatherList.add(weatherInfo);
      }
    }

    return uniqueWeatherList;
  } else {
    throw Exception('Không thể tải thông tin thời tiết hàng tuần');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thời tiết trong tuần'),
      ),
      body: Container(
        color: const Color(0xFF676BD0),
        child: FutureBuilder<List<WeatherInfo>>(
          future: weeklyWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Lỗi: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Không có thông tin thời tiết.'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  WeatherInfo weatherInfo = snapshot.data![index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      title: Text(
                        weatherInfo.day,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Nhiệt độ: ${weatherInfo.temperature}°C',
                        style: const TextStyle(fontSize: 16),
                      ),
                      leading: Icon(
                        Icons.cloud,
                        color: Colors.blue,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class WeatherInfo {
  final String day;
  final double temperature;

  WeatherInfo({required this.day, required this.temperature});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    // Lấy thời gian từ timestamp
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    String formattedDay = '${dateTime.day}/${dateTime.month}';

    return WeatherInfo(
      day: formattedDay,
      temperature: json['main']['temp'].toDouble(),
    );
  }
}
