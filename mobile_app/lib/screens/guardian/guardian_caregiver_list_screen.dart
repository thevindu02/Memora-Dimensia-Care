import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/guardian_service.dart';
import '../../services/auth_service.dart';
import '../../constants/color_constants.dart';
import '../../routes/app_routes.dart';
import '../../utils/name_utils.dart';

class GuardianCaregiverListScreen extends StatefulWidget {
  const GuardianCaregiverListScreen({Key? key}) : super(key: key);

  @override
  State<GuardianCaregiverListScreen> createState() => _GuardianCaregiverListScreenState();
}

class _GuardianCaregiverListScreenState extends State<GuardianCaregiverListScreen> {
  List<Map<String, dynamic>> _caregivers = [];
  bool _isLoading = true;
  String? _error;
  int? _guardianId;

  @override
  void initState() {
    super.initState();
    _loadCaregivers();
  }

  Future<int?> _resolveGuardianId() async {
    if (_guardianId != null) return _guardianId;
    
    // Try SharedPreferences first
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('guardianId');
      if (id != null) {
        _guardianId = id;
        return id;
      }
    } catch (_) {}
    
    // Fallback: get from AuthService + GuardianService
    try {
      final userId = await AuthService.getCurrentUserId();
      if (userId != null) {
        final gid = await GuardianService.getGuardianIdByUserId(userId);
        if (gid != null) {
          _guardianId = gid;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('guardianId', gid);
          return gid;
        }
      }
    } catch (_) {}
    
    return null;
  }

  Future<void> _loadCaregivers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final gid = await _resolveGuardianId();
      if (gid == null) {
        setState(() {
          _error = 'Guardian ID not available. Please login again.';
          _isLoading = false;
        });
        return;
      }

      final caregivers = await GuardianService.getAllCaregiversForGuardian(gid);
      setState(() {
        _caregivers = caregivers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load caregivers: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildCaregiverCard(Map<String, dynamic> caregiver) {
    // Backend returns fName/lName (camelCase from CaregiverSummaryResponse)
    final firstName = (caregiver['fName'] ?? caregiver['FName'] ?? '').toString().trim();
    final lastName = (caregiver['lName'] ?? caregiver['LName'] ?? '').toString().trim();
    final name = '$firstName $lastName'.trim();
    final email = caregiver['email'] ?? '';
    final experience = caregiver['experience'] ?? '';
    final status = caregiver['status']?.toString().toLowerCase() ?? 'active';
    final isActive = status == 'active';

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.guardianCaregiverDetails,
            arguments: caregiver,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: isActive ? Colors.green.withOpacity(0.1) : Colors.red.shade50,
                child: Icon(
                  Icons.person,
                  color: isActive ? Colors.green : Colors.red.shade400,
                  size: 32,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name.isNotEmpty ? name : 'Unknown',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.info,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green.withOpacity(0.12) : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isActive ? Colors.green.withOpacity(0.25) : Colors.red.shade200,
                            ),
                          ),
                          child: Text(
                            isActive ? 'ACTIVE' : 'INACTIVE',
                            style: TextStyle(
                              color: isActive ? Colors.green.shade700 : Colors.red.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email: $email',
                      style: TextStyle(fontSize: 14, color: AppColors.onSurface),
                    ),
                    if (experience.isNotEmpty)
                      Text(
                        'Experience: $experience',
                        style: TextStyle(fontSize: 14, color: AppColors.onSurface),
                      ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'My Caregivers',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text(_error!, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadCaregivers,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _caregivers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.group_outlined, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No caregivers found',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(24),
                      itemCount: _caregivers.length,
                      itemBuilder: (context, index) => _buildCaregiverCard(_caregivers[index]),
                    ),
    );
  }
}