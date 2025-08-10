import 'package:flutter/material.dart';
import '../../../../core/services/recent_destinations_service.dart';

class PopularDestinationsSection extends StatefulWidget {
  final Function(String destination, double? latitude, double? longitude)
      onDestinationSelected;
  final VoidCallback? onGetCurrentLocation;
  final bool showCurrentLocation;

  const PopularDestinationsSection({
    super.key,
    required this.onDestinationSelected,
    this.onGetCurrentLocation,
    this.showCurrentLocation = false,
  });

  @override
  State<PopularDestinationsSection> createState() =>
      _PopularDestinationsSectionState();
}

class _PopularDestinationsSectionState
    extends State<PopularDestinationsSection> {
  List<RecentDestination> _recentDestinations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentDestinations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRecentDestinations();
  }

  Future<void> _loadRecentDestinations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final destinations =
          await RecentDestinationsService.getRecentDestinations();
      setState(() {
        _recentDestinations = destinations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeDestination(RecentDestination destination) async {
    await RecentDestinationsService.removeRecentDestination(destination);
    await _loadRecentDestinations();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Điểm đi gần đây",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            if (_recentDestinations.isNotEmpty)
              TextButton(
                onPressed: () async {
                  await RecentDestinationsService.clearAllRecentDestinations();
                  await _loadRecentDestinations();
                },
                child: const Text(
                  "Xóa tất cả",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (_recentDestinations.isEmpty)
          Center(child: _buildEmptyState())
        else
          ..._recentDestinations.map(
            (destination) => _buildDestinationItem(destination),
          ),
        if (widget.showCurrentLocation &&
            widget.onGetCurrentLocation != null) ...[
          const SizedBox(height: 8),
          _buildCurrentLocationItem(widget.onGetCurrentLocation!),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            "Chưa có điểm đi gần đây",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Các điểm đi của bạn sẽ xuất hiện ở đây",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationItem(RecentDestination destination) {
    return Dismissible(
      key: Key(destination.name + destination.address),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        _removeDestination(destination);
      },
      child: InkWell(
        onTap: () => widget.onDestinationSelected(
          destination.name,
          destination.latitude,
          destination.longitude,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.history, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      destination.address,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const SizedBox(height: 2),
                    Text(
                      _formatTimestamp(destination.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: Colors.grey.shade400, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLocationItem(VoidCallback onGetCurrentLocation) {
    return InkWell(
      onTap: onGetCurrentLocation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.my_location, color: Colors.blue.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vị trí hiện tại",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Nhấn để lấy vị trí hiện tại",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: Colors.blue.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
