import '../repositories/auth_repository.dart';
import '../usecases/auth_usecases.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  static ServiceLocator get instance => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};

  // Register services
  void registerServices() {
    // Repositories
    _services[AuthRepository] = AuthRepositoryImpl();

    // Use cases
    _services[SendOtpUseCase] = SendOtpUseCase(_services[AuthRepository]);
    _services[VerifyOtpUseCase] = VerifyOtpUseCase(_services[AuthRepository]);
    _services[LoginUseCase] = LoginUseCase(_services[AuthRepository]);
  }

  // Get service
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type $T is not registered');
    }
    return service as T;
  }

  // Register single service
  void register<T>(T service) {
    _services[T] = service;
  }

  // Check if service is registered
  bool isRegistered<T>() {
    return _services.containsKey(T);
  }

  // Clear all services
  void clear() {
    _services.clear();
  }
}
