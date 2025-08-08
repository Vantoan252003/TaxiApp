import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/place_provider.dart';
import '../../../data/models/place_model.dart';

class AutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Color iconColor;
  final bool isActive;
  final bool isLoading;
  final Function(AutocompleteData) onPlaceSelected;
  final Function(bool) onFocusChanged;
  final VoidCallback? onGetLocation;

  const AutocompleteField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.iconColor,
    required this.isActive,
    this.isLoading = false,
    required this.onPlaceSelected,
    required this.onFocusChanged,
    this.onGetLocation,
  });

  @override
  State<AutocompleteField> createState() => _AutocompleteFieldState();
}

class _AutocompleteFieldState extends State<AutocompleteField> {
  final FocusNode _focusNode = FocusNode();
  bool _showClearIcon = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChanged);
    _showClearIcon = widget.controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onFocusChange() {
    widget.onFocusChanged(_focusNode.hasFocus);
    setState(() {});
  }

  void _onTextChanged() {
    setState(() {
      _showClearIcon = widget.controller.text.isNotEmpty;
    });

    if (_focusNode.hasFocus) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted && _focusNode.hasFocus) {
          final provider = context.read<PlaceProvider>();
          provider.searchPlaces(widget.controller.text);
        }
      });
    }
  }

  void _clearText() {
    widget.controller.clear();
    setState(() {
      _showClearIcon = false;
    });
    _onTextChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _focusNode.hasFocus ? Colors.blue : Colors.grey.shade300,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(widget.icon, color: widget.iconColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Focus(
                    focusNode: _focusNode,
                    onFocusChange: widget.onFocusChanged,
                    child: TextField(
                      controller: widget.controller,
                      enabled: !widget.isLoading,
                      decoration: InputDecoration(
                        hintText: widget.isLoading
                            ? "Đang lấy địa chỉ..."
                            : widget.hintText,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, // Dịch văn bản xuống một chút
                          horizontal: 0,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(
                            Icons.clear,
                            color: _showClearIcon
                                ? Colors.grey.shade600
                                : Colors.transparent,
                            size: 20,
                          ),
                          onPressed: _showClearIcon ? _clearText : null,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
