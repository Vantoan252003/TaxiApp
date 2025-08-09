import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/auth_provider.dart';

class MainHomeController extends ChangeNotifier {
  bool _isLoadingUserInfo = false;

  // Getters
  bool get isLoadingUserInfo => _isLoadingUserInfo;

  Future<void> loadUserInfo(BuildContext context) async {
    _isLoadingUserInfo = true;
    notifyListeners();

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.loadUserInfo();
    } finally {
      _isLoadingUserInfo = false;
      notifyListeners();
    }
  }

  void showFeatureInDevelopment(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature ${AppConstants.featureInDevelopment}')),
    );
  }
}
