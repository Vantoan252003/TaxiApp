import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_theme.dart';

class OtpInputField extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(String) onChanged;
  final Function()? onCompleted;

  const OtpInputField({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 50,
          height: 60,
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            style: AppTheme.heading2.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.lightGray,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.lightGray,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.primaryBlack,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.warningRed,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.warningRed,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              onChanged(value);

              if (value.isNotEmpty) {
                if (index < 5) {
                  FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                } else {
                  FocusScope.of(context).unfocus();
                  // Check if all fields are filled
                  if (controllers
                      .every((controller) => controller.text.isNotEmpty)) {
                    onCompleted?.call();
                  }
                }
              } else {
                if (index > 0) {
                  FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                }
              }
            },
            onTap: () {
              // Clear the field when tapped
              controllers[index].clear();
            },
          ),
        );
      }),
    );
  }
}
