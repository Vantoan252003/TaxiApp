# Tích hợp Đăng nhập Sinh trắc học

## Tổng quan

Ứng dụng Taxi App đã được tích hợp tính năng đăng nhập bằng sinh trắc học (dấu vân tay/Face ID) để tăng cường bảo mật và trải nghiệm người dùng.

## Tính năng

### 1. Đăng nhập bằng Sinh trắc học
- Hỗ trợ dấu vân tay trên Android
- Hỗ trợ Face ID trên iOS
- Tự động kiểm tra khả năng sinh trắc học của thiết bị
- Xác thực an toàn trước khi cho phép đăng nhập

### 2. Quản lý Bảo mật
- Bật/tắt tính năng sinh trắc học trong cài đặt
- Lưu trữ trạng thái bảo mật an toàn
- Giao diện thân thiện với người dùng

## Cách sử dụng

### Cho người dùng

1. **Bật tính năng sinh trắc học:**
   - Vào Profile → Bảo mật
   - Bật toggle "Đăng nhập bằng dấu vân tay/Face ID"
   - Xác thực bằng sinh trắc học để kích hoạt

2. **Đăng nhập bằng sinh trắc học:**
   - Trên màn hình đăng nhập, nhấn nút "Đăng nhập bằng [Face ID/Dấu vân tay]"
   - Hoặc khi mở app, hệ thống sẽ tự động yêu cầu xác thực sinh trắc học

3. **Tắt tính năng:**
   - Vào Profile → Bảo mật
   - Tắt toggle "Đăng nhập bằng dấu vân tay/Face ID"

### Cho nhà phát triển

#### Cấu hình Android

Thêm quyền vào `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
```

#### Cấu hình iOS

Thêm mô tả Face ID vào `ios/Runner/Info.plist`:
```xml
<key>NSFaceIDUsageDescription</key>
<string>Ứng dụng sử dụng Face ID để đăng nhập nhanh và bảo mật</string>
```

#### Sử dụng trong code

1. **Kiểm tra khả năng sinh trắc học:**
```dart
final canUse = await BiometricService.canUseBiometric();
```

2. **Xác thực sinh trắc học:**
```dart
final success = await BiometricService.authenticate(
  reason: 'Xác thực để tiếp tục',
);
```

3. **Sử dụng trong AuthProvider:**
```dart
// Bật sinh trắc học
final success = await authProvider.enableBiometric();

// Đăng nhập bằng sinh trắc học
final success = await authProvider.authenticateWithBiometric();

// Kiểm tra trạng thái
final isEnabled = await authProvider.isBiometricEnabled();
```

## Cấu trúc Files

```
lib/
├── general_lib/
│   ├── services/
│   │   └── biometric_service.dart          # Service xử lý sinh trắc học
│   ├── widgets/
│   │   └── biometric_login_button.dart     # Widget nút đăng nhập sinh trắc học
│   └── core/providers/
│       └── auth_provider.dart              # Provider với các phương thức sinh trắc học
└── user_lib/
    ├── screens/
    │   └── security_screen.dart            # Màn hình cài đặt bảo mật
    └── widgets/
        └── security_menu_item.dart         # Widget menu bảo mật
```

## Bảo mật

- Sử dụng `local_auth` package để xử lý sinh trắc học an toàn
- Lưu trữ trạng thái bảo mật trong SharedPreferences
- Xác thực sinh trắc học trước khi cho phép thay đổi cài đặt
- Tự động logout nếu xác thực thất bại

## Lưu ý

1. **Thiết bị không hỗ trợ:** Tính năng sẽ tự động ẩn nếu thiết bị không hỗ trợ sinh trắc học
2. **Quyền:** Người dùng phải cấp quyền sinh trắc học trong cài đặt hệ thống
3. **Fallback:** Nếu sinh trắc học thất bại, người dùng vẫn có thể đăng nhập bằng mật khẩu
4. **Testing:** Test trên thiết bị thật vì simulator có thể không hỗ trợ đầy đủ

## Troubleshooting

### Lỗi thường gặp

1. **"Thiết bị không hỗ trợ sinh trắc học"**
   - Kiểm tra xem thiết bị có cảm biến sinh trắc học không
   - Đảm bảo đã cấp quyền trong cài đặt hệ thống

2. **"Xác thực sinh trắc học thất bại"**
   - Kiểm tra xem sinh trắc học có được thiết lập trên thiết bị không
   - Thử xác thực lại

3. **Nút sinh trắc học không hiển thị**
   - Kiểm tra `BiometricService.canUseBiometric()`
   - Đảm bảo đã cài đặt đúng dependencies

### Debug

Thêm log để debug:
```dart
print('Biometric available: ${await BiometricService.canUseBiometric()}');
print('Available biometrics: ${await BiometricService.getAvailableBiometrics()}');
``` 