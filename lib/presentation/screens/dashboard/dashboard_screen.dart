import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/chat_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Get.find<ChatController>().updateContext('dashboard', {});
      } catch (_) {}
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator()); // Skeleton loader could be here
        }
        return RefreshIndicator(
          onRefresh: () async => controller.fetchProperties(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        _buildStatCard('Properties', '${controller.totalProperties.value}', Icons.home),
                        const SizedBox(width: 16),
                        _buildStatCard('Bookings', '${controller.activeBookings.value}', Icons.calendar_month),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard('Earnings', '\$${controller.totalEarnings.value}', Icons.monetization_on, isWide: true),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Your Properties', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton.icon(
                          onPressed: controller.goToCreateProperty,
                          icon: const Icon(Icons.add),
                          label: const Text('Add New')
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (controller.properties.isEmpty)
                      const Center(child: Text("You don't have any properties yet. Add one!")) // Empty State
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.properties.length,
                        itemBuilder: (context, index) {
                          final prop = controller.properties[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            child: ListTile(
                              leading: Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image),
                              ),
                              title: Text(prop.title),
                              subtitle: Text('${prop.type} • ${prop.rooms} Rooms'),
                              trailing: Text('\$${prop.price}/night', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          );
                        },
                      )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, {bool isWide = false}) {
    return Expanded(
      flex: isWide ? 1 : 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
