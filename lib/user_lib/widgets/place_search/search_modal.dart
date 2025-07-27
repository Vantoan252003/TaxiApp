import 'package:flutter/material.dart';
import '../../../general_lib/constants/app_theme.dart';
import '../../../general_lib/models/place_model.dart';
import 'place_item.dart';
import 'place_search_input.dart';

class SearchModal extends StatefulWidget {
  final String title;
  final String hintText;
  final bool isOrigin;
  final Function(PlaceModel) onPlaceSelected;
  final Function(String)? onSearchChanged;
  final List<PlaceModel> searchResults;
  final bool isSearching;
  final String searchQuery;

  const SearchModal({
    super.key,
    required this.title,
    required this.hintText,
    required this.isOrigin,
    required this.onPlaceSelected,
    this.onSearchChanged,
    this.searchResults = const [],
    this.isSearching = false,
    this.searchQuery = '',
  });

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();

    // Auto focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim().isNotEmpty && query.trim().length >= 2) {
      widget.onSearchChanged?.call(query);
    } else {
      widget.onSearchChanged?.call('');
    }
  }

  void _onPlaceSelected(PlaceModel place) {
    widget.onPlaceSelected(place);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          color: Colors.black.withOpacity(0.5 * _fadeAnimation.value),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOutCubic,
            )),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  _buildHeader(),

                  // Search Input
                  _buildSearchInput(),

                  // Results
                  Expanded(
                    child: _buildResults(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color: AppTheme.primaryBlack,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: AppTheme.heading3.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: PlaceSearchInput(
        controller: _searchController,
        focusNode: _searchFocusNode,
        hintText: widget.hintText,
        onChanged: _onSearchChanged,
        onClear: () {
          _searchController.clear();
          widget.onSearchChanged?.call('');
        },
      ),
    );
  }

  Widget _buildResults() {
    if (widget.isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Đang tìm kiếm...',
              style: AppTheme.body2,
            ),
          ],
        ),
      );
    }

    if (widget.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.searchQuery.isEmpty ? Icons.search : Icons.location_off,
              size: 64,
              color: AppTheme.lightGray,
            ),
            const SizedBox(height: 16),
            Text(
              widget.searchQuery.isEmpty
                  ? 'Nhập từ khóa để tìm kiếm địa điểm'
                  : 'Không tìm thấy địa điểm nào',
              style: AppTheme.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: widget.searchResults.length,
      itemBuilder: (context, index) {
        final place = widget.searchResults[index];
        return PlaceItem(
          place: place,
          onTap: () => _onPlaceSelected(place),
        );
      },
    );
  }
}
