
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../general_lib/constants/app_theme.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import 'main_home_screen.dart';
import 'rides_screen.dart';
import 'wallet_screen.dart';
import 'activity_screen.dart';
import 'profile_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// TaskHandler giữ kết nối WebSocket trong foreground service
class MyTaskHandler extends TaskHandler {
  WebSocketChannel? _channel;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    // Kết nối WebSocket khi bắt đầu foreground service
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://echo.websocket.events'), // Thay bằng URL WebSocket thực tế của bạn
    );
    _channel!.stream.listen((message) {
      print('Received from WebSocket: $message');
      // Xử lý dữ liệu nhận được nếu cần
    });
    // Gửi một message test
    _channel!.sink.add('TaxiApp foreground service started!');
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    // Có thể gửi ping hoặc giữ kết nối WebSocket ở đây nếu cần
    print('Foreground service is running at: $timestamp');
    _channel?.sink.add('Ping at $timestamp');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // Đóng kết nối WebSocket khi foreground service bị destroy
    await _channel?.sink.close();
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();
    _requestPermissionsAndOpenBatterySettings();
  }


  Future<void> _requestPermissionsAndOpenBatterySettings() async {
    await Permission.ignoreBatteryOptimizations.request();
    await Permission.locationAlways.request();
    await Permission.notification.request();
    // Mở trang tắt tối ưu pin trên Android
    await _openBatteryOptimizationSettings();
    await FlutterForegroundTask.startService(
      notificationTitle: 'Taxi App đang chạy nền',
      notificationText: 'Ứng dụng đang hoạt động ở chế độ nền.',
      callback: startCallback,
    );
  }

  Future<void> _openBatteryOptimizationSettings() async {
    // Mở trang cài đặt ứng dụng để người dùng tự tắt tối ưu pin
    await openAppSettings();
  }

  // Hàm callback cho foreground task
  static void startCallback() {
    FlutterForegroundTask.setTaskHandler(MyTaskHandler());
  }

  final List<Widget> _screens = [
    const MainHomeScreen(),
    const RidesScreen(),
    const WalletScreen(),
    const ActivityScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
