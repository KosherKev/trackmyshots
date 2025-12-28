import 'package:flutter/material.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  // Mock data for demonstration
  List<MarketplaceItem> get _items => [
        MarketplaceItem(
          id: '1',
          name: 'Digital Thermometer',
          description: 'Essential for monitoring post-vaccine fever.',
          price: 'GHS 45.00',
          imageUrl: 'assets/images/thermometer.png', // Placeholder
          affiliateLink: 'https://jumia.com.gh/thermometer', // Placeholder
          category: 'Health',
        ),
        MarketplaceItem(
          id: '2',
          name: 'Baby Paracetamol Syrup',
          description: 'Relief for pain and fever after shots.',
          price: 'GHS 25.00',
          imageUrl: 'assets/images/paracetamol.png', // Placeholder
          affiliateLink: 'https://jumia.com.gh/paracetamol', // Placeholder
          category: 'Medicine',
        ),
        MarketplaceItem(
          id: '3',
          name: 'Premium Diapers (Pack of 50)',
          description: 'Keep your baby dry and comfortable.',
          price: 'GHS 120.00',
          imageUrl: 'assets/images/diapers.png', // Placeholder
          affiliateLink: 'https://jumia.com.gh/diapers', // Placeholder
          category: 'Hygiene',
        ),
        MarketplaceItem(
          id: '4',
          name: 'Baby Wipes (3 Packs)',
          description: 'Gentle on skin, alcohol-free.',
          price: 'GHS 35.00',
          imageUrl: 'assets/images/wipes.png', // Placeholder
          affiliateLink: 'https://jumia.com.gh/wipes', // Placeholder
          category: 'Hygiene',
        ),
      ];

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // In production, handle error
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby Essentials'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: () => _launchUrl(item.affiliateLink),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Placeholder
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.shopping_bag_outlined, size: 40, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.price,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0066B3),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0066B3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Buy Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
