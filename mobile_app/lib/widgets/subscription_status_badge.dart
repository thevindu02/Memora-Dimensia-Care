import 'package:flutter/material.dart';

class SubscriptionStatusBadge extends StatelessWidget {
  final String status;
  final bool isActive;
  final DateTime? expiryDate;
  final bool compact;

  const SubscriptionStatusBadge({
    Key? key,
    required this.status,
    required this.isActive,
    this.expiryDate,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(compact ? 12 : 16),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            size: compact ? 14 : 16,
            color: _getIconColor(),
          ),
          SizedBox(width: compact ? 4 : 6),
          Text(
            _getLabel(),
            style: TextStyle(
              fontSize: compact ? 11 : 13,
              fontWeight: FontWeight.w600,
              color: _getTextColor(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    if (!isActive) {
      return Colors.red[50]!;
    }

    switch (status) {
      case 'TRIAL':
        return Colors.purple[50]!;
      case 'ACTIVE':
        return Colors.green[50]!;
      case 'PENDING':
        return Colors.orange[50]!;
      default:
        return Colors.grey[50]!;
    }
  }

  Color _getBorderColor() {
    if (!isActive) {
      return Colors.red[300]!;
    }

    switch (status) {
      case 'TRIAL':
        return Colors.purple[300]!;
      case 'ACTIVE':
        return Colors.green[300]!;
      case 'PENDING':
        return Colors.orange[300]!;
      default:
        return Colors.grey[300]!;
    }
  }

  Color _getIconColor() {
    if (!isActive) {
      return Colors.red[700]!;
    }

    switch (status) {
      case 'TRIAL':
        return Colors.purple[700]!;
      case 'ACTIVE':
        return Colors.green[700]!;
      case 'PENDING':
        return Colors.orange[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  Color _getTextColor() {
    if (!isActive) {
      return Colors.red[900]!;
    }

    switch (status) {
      case 'TRIAL':
        return Colors.purple[900]!;
      case 'ACTIVE':
        return Colors.green[900]!;
      case 'PENDING':
        return Colors.orange[900]!;
      default:
        return Colors.grey[900]!;
    }
  }

  IconData _getIcon() {
    if (!isActive) {
      return Icons.error_outline;
    }

    switch (status) {
      case 'TRIAL':
        return Icons.card_giftcard;
      case 'ACTIVE':
        return Icons.check_circle_outline;
      case 'PENDING':
        return Icons.hourglass_empty;
      default:
        return Icons.info_outline;
    }
  }

  String _getLabel() {
    if (!isActive && status == 'EXPIRED') {
      return 'Expired';
    }

    switch (status) {
      case 'TRIAL':
        if (expiryDate != null) {
          final daysLeft = expiryDate!.difference(DateTime.now()).inDays;
          if (daysLeft <= 7) {
            return 'Trial - $daysLeft days left';
          }
          return 'Free Trial';
        }
        return 'Free Trial';
      case 'ACTIVE':
        if (expiryDate != null) {
          final daysLeft = expiryDate!.difference(DateTime.now()).inDays;
          if (daysLeft <= 7) {
            return 'Active - $daysLeft days left';
          }
          return 'Active';
        }
        return 'Active';
      case 'PENDING':
        return 'Pending';
      case 'EXPIRED':
        return 'Expired';
      default:
        return status;
    }
  }
}

/// Full subscription info card widget
class SubscriptionInfoCard extends StatelessWidget {
  final Map<String, dynamic> subscription;
  final VoidCallback? onRenew;
  final VoidCallback? onViewDetails;

  const SubscriptionInfoCard({
    Key? key,
    required this.subscription,
    this.onRenew,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = subscription['status'] as String;
    final isActive = subscription['isActive'] as bool? ?? false;
    
    DateTime? trialEndDate;
    DateTime? paidEndDate;
    
    if (subscription['trialEndDate'] != null) {
      trialEndDate = DateTime.parse(subscription['trialEndDate']);
    }
    if (subscription['paidEndDate'] != null) {
      paidEndDate = DateTime.parse(subscription['paidEndDate']);
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subscription Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SubscriptionStatusBadge(
                  status: status,
                  isActive: isActive,
                  expiryDate: paidEndDate ?? trialEndDate,
                ),
              ],
            ),
            const Divider(height: 24),

            // Trial period info
            if (trialEndDate != null) ...[
              _buildPeriodInfo(
                'Free Trial Period',
                subscription['trialStartDate'] != null
                    ? DateTime.parse(subscription['trialStartDate'])
                    : null,
                trialEndDate,
                Icons.card_giftcard,
                Colors.purple,
              ),
              const SizedBox(height: 12),
            ],

            // Paid period info
            if (paidEndDate != null) ...[
              _buildPeriodInfo(
                'Paid Subscription Period',
                subscription['paidStartDate'] != null
                    ? DateTime.parse(subscription['paidStartDate'])
                    : null,
                paidEndDate,
                Icons.payment,
                Colors.green,
              ),
              const SizedBox(height: 12),
            ],

            // Duration
            if (subscription['durationMonths'] != null) ...[
              Row(
                children: [
                  Icon(Icons.schedule, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Duration: ${subscription['durationMonths']} months',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],

            // Action buttons
            if (!isActive && onRenew != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRenew,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Renew Subscription'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],

            if (onViewDetails != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onViewDetails,
                  child: const Text('View Details'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodInfo(
    String title,
    DateTime? startDate,
    DateTime endDate,
    IconData icon,
    Color color,
  ) {
    final now = DateTime.now();
    final isExpired = endDate.isBefore(now);
    final daysRemaining = endDate.difference(now).inDays;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (startDate != null)
            Text(
              'Started: ${_formatDate(startDate)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          Text(
            '${isExpired ? 'Ended' : 'Ends'}: ${_formatDate(endDate)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: isExpired ? FontWeight.normal : FontWeight.w600,
            ),
          ),
          if (!isExpired && daysRemaining <= 30)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '$daysRemaining days remaining',
                style: TextStyle(
                  fontSize: 12,
                  color: daysRemaining <= 7 ? Colors.red[700] : Colors.orange[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
