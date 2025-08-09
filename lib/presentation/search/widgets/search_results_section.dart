import 'package:flutter/material.dart';
import '../../../data/models/place_model.dart';

class SearchResultsSection extends StatelessWidget {
  final List<AutocompleteData> searchResults;
  final Function(AutocompleteData) onPlaceSelected;
  final String Function(double) formatDistance;

  const SearchResultsSection({
    super.key,
    required this.searchResults,
    required this.onPlaceSelected,
    required this.formatDistance,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kết quả tìm kiếm",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...searchResults.map((place) => _buildSearchResultItem(place)),
      ],
    );
  }

  Widget _buildSearchResultItem(AutocompleteData place) {
    return InkWell(
      onTap: () => onPlaceSelected(place),
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
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Icon(Icons.location_on,
                      color: Colors.grey.shade600, size: 16),
                  ...[
                    const SizedBox(height: 2),
                    Text(
                      formatDistance(place.distance),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    place.display,
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
            Icon(Icons.bookmark_border, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}
