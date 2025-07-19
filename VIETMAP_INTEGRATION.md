# Tích hợp VietMap vào Taxi App

## Tổng quan
Ứng dụng đã được tích hợp VietMap để cải thiện độ chính xác của việc lấy vị trí và địa chỉ tại Việt Nam.

## Các tính năng đã tích hợp

### 1. VietMap Service (`lib/general_lib/services/vietmap_service.dart`)
- **getAddressFromCoordinates()**: Lấy địa chỉ chi tiết từ tọa độ GPS
- **getCurrentAddress()**: Lấy địa chỉ hiện tại
- **searchPlaces()**: Tìm kiếm địa điểm theo từ khóa
- **getPlaceDetails()**: Lấy thông tin chi tiết về địa điểm

### 2. Location Service cải tiến (`lib/general_lib/services/location_service.dart`)
- Chỉ sử dụng VietMap API (không còn fallback về geocoding)
- Cải thiện độ chính xác địa chỉ tại Việt Nam
- Hỗ trợ địa chỉ chi tiết bao gồm tên đường và số nhà

## Cấu hình

### API Key
API Key VietMap đã được cấu hình trong:
- `lib/general_lib/services/vietmap_service.dart`

### Dependencies
Đã thêm vào `pubspec.yaml`:
```yaml
vietmap_flutter_gl: ^4.0.1
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

## Cải tiến so với phiên bản cũ

### Trước khi tích hợp VietMap:
- Sử dụng geocoding thông thường
- Địa chỉ không chính xác tại Việt Nam
- Chỉ hiển thị thông tin cấp phường/quận/thành phố

### Sau khi tích hợp VietMap:
- Địa chỉ chính xác và chi tiết tại Việt Nam
- Hỗ trợ đầy đủ tiếng Việt
- Hiển thị địa chỉ chi tiết bao gồm tên đường và số nhà
- Ví dụ: "39 Lê Quý Đôn Phường Võ Thị Sáu,Quận 3,Thành Phố Hồ Chí Minh"

## API Endpoints được sử dụng

- **Reverse Geocoding**: `https://maps.vietmap.vn/api/reverse/v3?apikey={key}&lat={lat}&lng={lng}&detail=true`
- **Search**: `https://maps.vietmap.vn/api/search/v3?apikey={key}&text={query}`
- **Place Details**: `https://maps.vietmap.vn/api/place/v3?apikey={key}&ref_id={place_id}`

## Lưu ý

1. **API Key**: Đảm bảo API key có đủ quota và quyền truy cập
2. **Internet**: Cần kết nối internet để sử dụng VietMap API
3. **Permissions**: Cần quyền truy cập vị trí trên thiết bị
4. **Độ chính xác**: VietMap cung cấp địa chỉ chi tiết hơn so với geocoding thông thường

## Troubleshooting

### Lỗi thường gặp:
1. **API Key không hợp lệ**: Kiểm tra lại API key trong service
2. **Không có kết nối internet**: VietMap API cần internet
3. **Quyền vị trí bị từ chối**: Cần cấp quyền truy cập vị trí

### Debug:
- Kiểm tra console log để xem lỗi chi tiết
- Sử dụng `debugPrint()` để theo dõi quá trình lấy địa chỉ
- Test API trực tiếp để kiểm tra key 