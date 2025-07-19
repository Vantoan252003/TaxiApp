# Tích hợp VietMap vào Taxi App

## Tổng quan
Ứng dụng đã được tích hợp VietMap để cải thiện độ chính xác của việc lấy vị trí và địa chỉ tại Việt Nam.

## Các tính năng đã tích hợp

### 1. VietMap Service (`lib/general_lib/services/vietmap_service.dart`)
- **getAddressFromCoordinates()**: Lấy địa chỉ từ tọa độ GPS
- **getCurrentAddress()**: Lấy địa chỉ hiện tại
- **searchPlaces()**: Tìm kiếm địa điểm theo từ khóa
- **getPlaceDetails()**: Lấy thông tin chi tiết về địa điểm

### 2. Location Service cải tiến (`lib/general_lib/services/location_service.dart`)
- Tự động sử dụng VietMap API trước
- Fallback về geocoding thông thường nếu VietMap không hoạt động
- Cải thiện độ chính xác địa chỉ tại Việt Nam

### 3. Bản đồ VietMap (`lib/user_lib/widgets/vietmap_widget.dart`)
- Widget hiển thị bản đồ VietMap sử dụng WebView
- Hỗ trợ hiển thị vị trí hiện tại
- Tương tác với bản đồ

### 4. Màn hình bản đồ (`lib/user_lib/screens/map_screen.dart`)
- Màn hình hiển thị bản đồ đầy đủ
- Hiển thị vị trí hiện tại và địa chỉ
- Nút refresh vị trí

## Cấu hình

### API Key
API Key VietMap đã được cấu hình trong:
- `lib/general_lib/constants/vietmap_constants.dart`
- `lib/general_lib/services/vietmap_service.dart`

### Dependencies
Đã thêm vào `pubspec.yaml`:
```yaml
webview_flutter: ^4.4.2
```

## Cách sử dụng

### 1. Lấy địa chỉ từ tọa độ
```dart
final address = await VietMapService.getAddressFromCoordinates(
  latitude, 
  longitude
);
```

### 2. Lấy địa chỉ hiện tại
```dart
final address = await VietMapService.getCurrentAddress();
```

### 3. Hiển thị bản đồ
```dart
VietMapWidget(
  latitude: 21.0285,
  longitude: 105.8542,
  zoom: 15.0,
  showUserLocation: true,
)
```

### 4. Mở màn hình bản đồ
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const MapScreen(),
  ),
);
```

## Cải tiến so với phiên bản cũ

### Trước khi tích hợp VietMap:
- Sử dụng geocoding thông thường
- Địa chỉ không chính xác tại Việt Nam
- Thiếu thông tin chi tiết về đường phố, phường/xã

### Sau khi tích hợp VietMap:
- Địa chỉ chính xác hơn tại Việt Nam
- Hỗ trợ đầy đủ tiếng Việt
- Thông tin chi tiết về địa chỉ Việt Nam
- Bản đồ tương tác với dữ liệu Việt Nam
- Fallback an toàn khi VietMap không khả dụng

## Lưu ý

1. **API Key**: Đảm bảo API key có đủ quota và quyền truy cập
2. **Internet**: Cần kết nối internet để sử dụng VietMap API
3. **Permissions**: Cần quyền truy cập vị trí trên thiết bị
4. **Fallback**: Hệ thống tự động chuyển về geocoding thông thường nếu VietMap không hoạt động

## Troubleshooting

### Lỗi thường gặp:
1. **API Key không hợp lệ**: Kiểm tra lại API key trong constants
2. **Không có kết nối internet**: VietMap API cần internet
3. **Quyền vị trí bị từ chối**: Cần cấp quyền truy cập vị trí

### Debug:
- Kiểm tra console log để xem lỗi chi tiết
- Sử dụng `debugPrint()` để theo dõi quá trình lấy địa chỉ
- Test API trực tiếp trên browser để kiểm tra key 