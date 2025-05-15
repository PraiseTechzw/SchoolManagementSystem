import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/constants.dart';
import '../../../../config/routes.dart';
import '../../../../config/themes.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../widgets/sync_status_widget.dart';

class ClerkDashboard extends ConsumerStatefulWidget {
  const ClerkDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<ClerkDashboard> createState() => _ClerkDashboardState();
}

class _ClerkDashboardState extends ConsumerState<ClerkDashboard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final isConnected = ref.watch(connectivityStatusProvider);
    
    return Theme(
      data: AppThemes.getRoleTheme('clerk'),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.dashboard),
          actions: [
            // Display sync status
            SyncStatusWidget(),
            
            // Display connectivity status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ref.watch(connectivityIndicatorProvider),
            ),
          ],
        ),
        drawer: AppDrawer(currentRoute: AppRoutes.clerkDashboard),
        body: user.when(
          data: (userData) {
            return userData == null
                ? const Center(child: Text('User not found'))
                : _buildDashboard(context, userData?.fullName ?? 'Clerk');
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: ${error.toString()}'),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, String userName) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isSmallScreen = size.width < 600;
    
    return RefreshIndicator(
      onRefresh: () async {
        // Manually trigger a sync when the user pulls to refresh
        await ref.read(connectivityStatusProvider.notifier).manualSync();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.primaryColor.withOpacity(0.2),
                      child: Icon(
                        Icons.monetization_on,
                        size: 30,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, $userName',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Manage school fees and payments',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick stats section
            Text(
              'Financial Overview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isSmallScreen ? 2 : 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  context,
                  'Total Fees Collected',
                  'USD 45,890',
                  Icons.attach_money,
                  Colors.green,
                  () {},
                ),
                _buildStatCard(
                  context,
                  'Outstanding Balance',
                  'USD 12,450',
                  Icons.money_off,
                  Colors.red,
                  () {},
                ),
                _buildStatCard(
                  context,
                  'Payments Today',
                  '7',
                  Icons.payment,
                  Colors.blue,
                  () {},
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Recent payments section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Payments',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('New Payment'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return _buildPaymentItem(context, index);
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Fees by class section
            Text(
              'Fee Collection by Class',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildClassFeeProgress(context, 'Form 1A', 85),
                    const SizedBox(height: 12),
                    _buildClassFeeProgress(context, 'Form 1B', 92),
                    const SizedBox(height: 12),
                    _buildClassFeeProgress(context, 'Form 2A', 78),
                    const SizedBox(height: 12),
                    _buildClassFeeProgress(context, 'Form 2B', 65),
                    const SizedBox(height: 12),
                    _buildClassFeeProgress(context, 'Form 3A', 70),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick actions section
            Text(
              'Quick Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Record Payment',
                    Icons.add_card,
                    () => Navigator.pushNamed(context, AppRoutes.payment),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Print Receipt',
                    Icons.receipt_long,
                    () {},
                  ),
                ),
                if (!isSmallScreen) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Fee Structure',
                      Icons.list_alt,
                      () {},
                    ),
                  ),
                ],
              ],
            ),
            if (isSmallScreen) ...[
              const SizedBox(height: 16),
              _buildActionButton(
                context,
                'Fee Structure',
                Icons.list_alt,
                () {},
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentItem(BuildContext context, int index) {
    final payments = [
      {
        'student': 'Tatenda Moyo',
        'amount': 'USD 150',
        'date': '15 Aug 2023',
        'method': 'Cash',
      },
      {
        'student': 'Chiedza Ndoro',
        'amount': 'USD 200',
        'date': '14 Aug 2023',
        'method': 'Bank Transfer',
      },
      {
        'student': 'Farai Dube',
        'amount': 'USD 100',
        'date': '14 Aug 2023',
        'method': 'Mobile Money',
      },
      {
        'student': 'Tendai Shava',
        'amount': 'USD 150',
        'date': '13 Aug 2023',
        'method': 'Cash',
      },
      {
        'student': 'Chipo Makoni',
        'amount': 'USD 250',
        'date': '12 Aug 2023',
        'method': 'Bank Transfer',
      },
    ];

    final payment = payments[index];

    return ListTile(
      leading: CircleAvatar(
        child: Text(payment['student']!.substring(0, 1)),
      ),
      title: Text(payment['student']!),
      subtitle: Text('${payment['date']} • ${payment['method']}'),
      trailing: Text(
        payment['amount']!,
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.receipt,
          arguments: {'paymentId': index.toString()},
        );
      },
    );
  }

  Widget _buildClassFeeProgress(BuildContext context, String className, int percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(className),
            Text('$percentage%'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            percentage > 75
                ? Colors.green
                : percentage > 50
                    ? Colors.orange
                    : Colors.red,
          ),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}
