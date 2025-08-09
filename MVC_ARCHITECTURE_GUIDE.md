# Hướng dẫn Tổ chức Code theo Mô hình MVC

## Tổng quan

Mô hình MVC (Model-View-Controller) giúp tách biệt logic nghiệp vụ khỏi giao diện người dùng, làm cho code dễ bảo trì và mở rộng hơn.

## Cấu trúc Thư mục

```
lib/presentation/
├── [feature_name]/
│   ├── controllers/           # Chứa logic xử lý
│   │   ├── [feature]_controller.dart
│   │   └── ...
│   ├── screen/               # Chứa UI chính
│   │   ├── [feature]_screen.dart
│   │   └── ...
│   └── widgets/              # Chứa các widget con
│       ├── [widget_name].dart
│       └── index.dart
```

## 1. Controllers (Logic Layer)

### Đặc điểm:
- Kế thừa từ `ChangeNotifier`
- Chứa tất cả logic xử lý
- Quản lý state của screen
- Xử lý API calls, validation, navigation

### Ví dụ:

```dart
class DestinationSelectionController extends ChangeNotifier {
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadCurrentLocation() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Logic xử lý
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    super.dispose();
  }
}
```

### Quy tắc:
- Mỗi screen có một controller riêng
- Controller không chứa UI code
- Sử dụng `notifyListeners()` để cập nhật UI
- Dispose controllers khi không cần thiết

## 2. Screens (View Layer)

### Đặc điểm:
- Chỉ chứa UI code
- Sử dụng `ListenableBuilder` để lắng nghe controller
- Không chứa logic xử lý

### Ví dụ:

```dart
class DestinationSelectionScreen extends StatefulWidget {
  @override
  State<DestinationSelectionScreen> createState() => _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState extends State<DestinationSelectionScreen> {
  late final DestinationSelectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DestinationSelectionController();
    _controller.loadCurrentLocation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          body: _controller.isLoading 
            ? CircularProgressIndicator()
            : YourWidget(),
        );
      },
    );
  }
}
```

### Quy tắc:
- Screen chỉ khởi tạo và dispose controller
- Sử dụng `ListenableBuilder` để rebuild UI khi controller thay đổi
- Không chứa logic xử lý phức tạp

## 3. Widgets (Reusable Components)

### Đặc điểm:
- Tách các phần UI thành widget riêng biệt
- Có thể tái sử dụng
- Nhận parameters từ controller

### Ví dụ:

```dart
class CurrentLocationButton extends StatelessWidget {
  final bool isGettingCurrentLocation;
  final VoidCallback onTap;

  const CurrentLocationButton({
    required this.isGettingCurrentLocation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isGettingCurrentLocation ? null : onTap,
      child: Container(
        // UI code
      ),
    );
  }
}
```

### Quy tắc:
- Widget nhận data và callbacks từ controller
- Không chứa logic xử lý
- Có thể tái sử dụng ở nhiều nơi

## 4. Cách Tách Code

### Bước 1: Tạo Controller
```dart
// controllers/destination_selection_controller.dart
class DestinationSelectionController extends ChangeNotifier {
  // Di chuyển tất cả logic từ StatefulWidget vào đây
  // Bao gồm: TextEditingController, state variables, methods
}
```

### Bước 2: Tách Widgets
```dart
// widgets/current_location_button.dart
class CurrentLocationButton extends StatelessWidget {
  // Tách UI components thành widget riêng
}

// widgets/search_results_section.dart
class SearchResultsSection extends StatelessWidget {
  // Tách các section UI
}
```

### Bước 3: Cập nhật Screen
```dart
// screen/destination_selection_screen.dart
class DestinationSelectionScreen extends StatefulWidget {
  // Chỉ giữ lại UI structure và sử dụng controller
}
```

## 5. Lợi ích của MVC

### Dễ bảo trì:
- Logic và UI tách biệt rõ ràng
- Dễ debug và test
- Code có cấu trúc rõ ràng

### Dễ mở rộng:
- Thêm tính năng mới không ảnh hưởng UI
- Tái sử dụng logic ở nhiều nơi
- Dễ thay đổi UI mà không ảnh hưởng logic

### Dễ test:
- Test logic riêng biệt
- Mock UI để test controller
- Test UI riêng biệt

## 6. Ví dụ Thực tế

### Trước khi tách:
```dart
class _DestinationSelectionScreenState extends State<DestinationSelectionScreen> {
  final TextEditingController _originController = TextEditingController();
  bool _isLoading = false;
  
  Future<void> _loadCurrentLocation() async {
    setState(() => _isLoading = true);
    // Logic xử lý
    setState(() => _isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _originController),
          if (_isLoading) CircularProgressIndicator(),
          // Nhiều UI code khác
        ],
      ),
    );
  }
}
```

### Sau khi tách:
```dart
// Controller
class DestinationSelectionController extends ChangeNotifier {
  final TextEditingController originController = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  Future<void> loadCurrentLocation() async {
    _isLoading = true;
    notifyListeners();
    // Logic xử lý
    _isLoading = false;
    notifyListeners();
  }
}

// Screen
class DestinationSelectionScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          body: Column(
            children: [
              CustomTextField(controller: _controller.originController),
              if (_controller.isLoading) LoadingWidget(),
              // Các widget khác
            ],
          ),
        );
      },
    );
  }
}
```

## Kết luận

Việc tổ chức code theo mô hình MVC giúp:
- Code dễ đọc và hiểu hơn
- Dễ bảo trì và mở rộng
- Dễ test và debug
- Tái sử dụng code tốt hơn

Hãy áp dụng mô hình này cho tất cả các screen trong ứng dụng để có một codebase sạch và có cấu trúc tốt.
