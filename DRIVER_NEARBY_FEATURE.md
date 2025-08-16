# Chức năng Tìm kiếm Tài xế Gần đây

## Tổng quan
Chức năng này cho phép tìm kiếm và hiển thị các tài xế gần đây trên bản đồ trong ứng dụng taxi.

## Các thành phần đã thêm

### 1. Model
- `lib/data/models/driver_model.dart` - Model để lưu trữ thông tin tài xế

### 2. Service
- `lib/core/services/driver_service.dart` - Service để gọi API findNearby
- `lib/core/services/driver_service_test.dart` - File test để kiểm tra API

### 3. Widgets
- `lib/presentation/booking/widgets/driver_markers_widget.dart` - Widget hiển thị markers tài xế trên bản đồ
- `lib/presentation/booking/widgets/driver_info_overlay.dart` - Widget overlay hiển thị thông tin tài xế

### 4. Controller
- Cập nhật `lib/presentation/search/controllers/destination_selection_controller.dart` để tích hợp chức năng tìm kiếm tài xế

## API Endpoint
```
GET {{url}}/api/v1/drivers/nearby?lat={{pickupLat}}&lng={{pickupLng}}&vehicleType={{vehicleType}}&radiusMeters=3000
```

### Parameters
- `lat`: Vĩ độ của vị trí hiện tại
- `lng`: Kinh độ của vị trí hiện tại
- `vehicleType`: Loại xe (motorcycle, car, etc.)
- `radiusMeters`: Bán kính tìm kiếm (mặc định 3000m)

### Response
```json
[
    {
        "latitude": 10.7783,
        "userId": "597ed758-fbb9-4a39-af5b-0175d6492395",
        "longitude": 106.6953
    }
]
```

## Cách sử dụng

### 1. Tìm kiếm tài xế xe máy
```dart
final drivers = await DriverService.findNearbyMotorcycles(
  lat: 10.762317,
  lng: 106.654551,
  radiusMeters: 3000,
);
```

**Lưu ý**: `vehicleType` được hardcode thành `MOTORCYCLE` (chữ hoa) để phù hợp với API.

### 2. Tìm kiếm tài xế ô tô
```dart
final drivers = await DriverService.findNearbyCars(
  lat: 10.762317,
  lng: 106.654551,
  radiusMeters: 3000,
);
```

### 3. Tìm kiếm tài xế theo loại xe tùy chỉnh
```dart
final drivers = await DriverService.findNearbyDrivers(
  lat: 10.762317,
  lng: 106.654551,
  vehicleType: 'MOTORCYCLE', // Sử dụng chữ hoa
  radiusMeters: 3000,
);
```

## Tích hợp vào DestinationSelectionController

### Các phương thức đã thêm:
- `findNearbyDrivers()` - Tìm kiếm tài xế dựa trên vị trí hiện tại
- `findNearbyDriversAtLocation(lat, lng)` - Tìm kiếm tài xế tại tọa độ cụ thể
- `clearNearbyDrivers()` - Xóa danh sách tài xế

### Các thuộc tính đã thêm:
- `isLoadingDrivers` - Trạng thái loading
- `nearbyDrivers` - Danh sách tài xế gần đây

## Hiển thị trên bản đồ

### 1. Markers tài xế
- Sử dụng icon `motorcycle.png` từ `assets/images/booking/`
- Hiển thị tại vị trí lat/lng của từng tài xế
- Kích thước icon: 0.6

### 2. Overlay thông tin
- Hiển thị số lượng tài xế gần đây
- Vị trí: Góc trên bên phải màn hình
- Màu sắc: Xanh lá nếu có tài xế, xám nếu không có

## Test chức năng

Sử dụng trong code:
```dart
import 'lib/core/services/driver_service.dart';

final drivers = await DriverService.findNearbyMotorcycles(
  lat: 10.762317,
  lng: 106.654551,
  radiusMeters: 3000,
);
print('Found ${drivers.length} drivers');
```

## Lưu ý
1. API sẽ được gọi tự động khi người dùng chọn điểm đến và chuyển sang màn hình booking
2. Tọa độ sử dụng để tìm kiếm tài xế là tọa độ điểm đi (origin)
3. Bán kính tìm kiếm mặc định là 3000m
4. `vehicleType` được hardcode thành `MOTORCYCLE` (chữ hoa) để phù hợp với API
5. Nếu không tìm thấy tài xế, danh sách sẽ rỗng và overlay sẽ hiển thị "Không có tài xế"
6. Icon motorcycle được hiển thị với kích thước 0.8 để dễ nhìn

## Xử lý lỗi
- Nếu API gọi thất bại, danh sách tài xế sẽ rỗng
- Lỗi được log ra console để debug
- Không ảnh hưởng đến luồng chính của ứng dụng
