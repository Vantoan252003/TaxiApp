class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult.valid()
      : isValid = true,
        errorMessage = null;
  const ValidationResult.invalid(this.errorMessage) : isValid = false;
}

abstract class Validator<T> {
  ValidationResult validate(T value);
}

class PhoneNumberValidator implements Validator<String> {
  @override
  ValidationResult validate(String value) {
    if (value.isEmpty) {
      return const ValidationResult.invalid('Vui lòng nhập số điện thoại');
    }

    // Remove leading zero if exists and check length
    String phoneNumber = value.startsWith('0') ? value.substring(1) : value;

    if (phoneNumber.length != 9) {
      return const ValidationResult.invalid('Số điện thoại không hợp lệ');
    }

    // Check if it's a valid Vietnamese phone number
    if (!RegExp(r'^[3-9]\d{8}$').hasMatch(phoneNumber)) {
      return const ValidationResult.invalid('Số điện thoại không hợp lệ');
    }

    return const ValidationResult.valid();
  }
}

class EmailValidator implements Validator<String> {
  @override
  ValidationResult validate(String value) {
    if (value.isEmpty) {
      return const ValidationResult.invalid('Vui lòng nhập email');
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return const ValidationResult.invalid('Email không hợp lệ');
    }

    return const ValidationResult.valid();
  }
}

class EmailOrPhoneValidator implements Validator<String> {
  final EmailValidator _emailValidator = EmailValidator();

  @override
  ValidationResult validate(String value) {
    if (value.isEmpty) {
      return const ValidationResult.invalid(
          'Vui lòng nhập email hoặc số điện thoại');
    }

    if (RegExp(r'^0?\d+$').hasMatch(value)) {
      String phoneNumber = value.startsWith('0') ? value.substring(1) : value;

      if (phoneNumber.length != 9) {
        return const ValidationResult.invalid('Số điện thoại không hợp lệ');
      }
      if (!RegExp(r'^[3-9]\d{8}$').hasMatch(phoneNumber)) {
        return const ValidationResult.invalid('Số điện thoại không hợp lệ');
      }
      return const ValidationResult.valid();
    }

    // Otherwise, validate as email
    return _emailValidator.validate(value);
  }
}

class PasswordValidator implements Validator<String> {
  @override
  ValidationResult validate(String value) {
    if (value.isEmpty) {
      return const ValidationResult.invalid('Vui lòng nhập mật khẩu');
    }

    if (value.length < 6) {
      return const ValidationResult.invalid('Mật khẩu phải có ít nhất 6 ký tự');
    }

    return const ValidationResult.valid();
  }
}

class ConfirmPasswordValidator implements Validator<String> {
  final String originalPassword;

  ConfirmPasswordValidator(this.originalPassword);

  @override
  ValidationResult validate(String value) {
    if (value.isEmpty) {
      return const ValidationResult.invalid('Vui lòng xác nhận lại mật khẩu');
    }

    if (value != originalPassword) {
      return const ValidationResult.invalid('Mật khẩu không khớp');
    }

    return const ValidationResult.valid();
  }
}

class NameValidator implements Validator<String> {
  @override
  ValidationResult validate(String value) {
    if (value.isEmpty) {
      return const ValidationResult.invalid('Vui lòng nhập họ tên');
    }

    if (value.trim().length < 2) {
      return const ValidationResult.invalid('Họ tên phải có ít nhất 2 ký tự');
    }

    return const ValidationResult.valid();
  }
}

class OtpValidator implements Validator<String> {
  @override
  ValidationResult validate(String value) {
    if (value.isEmpty) {
      return const ValidationResult.invalid('Vui lòng nhập mã OTP');
    }

    if (value.length != 6) {
      return const ValidationResult.invalid('Mã OTP phải có 6 số');
    }

    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return const ValidationResult.invalid('Mã OTP chỉ được chứa số');
    }

    return const ValidationResult.valid();
  }
}
