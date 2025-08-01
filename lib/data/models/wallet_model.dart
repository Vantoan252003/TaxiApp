class WalletModel {
  final String id;
  final double balance;
  final String currency;
  final List<PaymentMethod> paymentMethods;
  final List<Transaction> recentTransactions;

  WalletModel({
    required this.id,
    required this.balance,
    required this.currency,
    required this.paymentMethods,
    required this.recentTransactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'VNĐ',
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
              ?.map((e) => PaymentMethod.fromJson(e))
              .toList() ??
          [],
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
              ?.map((e) => Transaction.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'currency': currency,
      'paymentMethods': paymentMethods.map((e) => e.toJson()).toList(),
      'recentTransactions': recentTransactions.map((e) => e.toJson()).toList(),
    };
  }
}

class PaymentMethod {
  final String id;
  final String type; // 'card', 'bank', 'ewallet'
  final String name;
  final String? cardNumber;
  final String? bankName;
  final String? ewalletName;
  final bool isDefault;
  final String? icon;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    this.cardNumber,
    this.bankName,
    this.ewalletName,
    required this.isDefault,
    this.icon,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      cardNumber: json['cardNumber'],
      bankName: json['bankName'],
      ewalletName: json['ewalletName'],
      isDefault: json['isDefault'] ?? false,
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'cardNumber': cardNumber,
      'bankName': bankName,
      'ewalletName': ewalletName,
      'isDefault': isDefault,
      'icon': icon,
    };
  }

  String get displayName {
    switch (type) {
      case 'card':
        return cardNumber != null
            ? '•••• ${cardNumber!.substring(cardNumber!.length - 4)}'
            : name;
      case 'bank':
        return bankName ?? name;
      case 'ewallet':
        return ewalletName ?? name;
      default:
        return name;
    }
  }

  String get displayType {
    switch (type) {
      case 'card':
        return 'Thẻ tín dụng';
      case 'bank':
        return 'Tài khoản ngân hàng';
      case 'ewallet':
        return 'Ví điện tử';
      default:
        return 'Phương thức khác';
    }
  }
}

class Transaction {
  final String id;
  final String type; // 'credit', 'debit'
  final double amount;
  final String description;
  final DateTime date;
  final String status; // 'completed', 'pending', 'failed'
  final String? tripId;
  final String? reference;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
    this.tripId,
    this.reference,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? '',
      tripId: json['tripId'],
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'status': status,
      'tripId': tripId,
      'reference': reference,
    };
  }

  String get formattedAmount {
    final prefix = type == 'credit' ? '+' : '-';
    return '$prefix${amount.toStringAsFixed(0)} VNĐ';
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hôm nay';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  bool get isCredit => type == 'credit';
  bool get isCompleted => status == 'completed';
}
