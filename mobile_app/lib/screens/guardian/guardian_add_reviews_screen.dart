import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/color_constants.dart';
import '../../services/caregiver_service.dart';
import '../../services/caregiver_review_service.dart';
import '../../services/guardian_service.dart';
import '../../services/auth_service.dart';

class GuardianAddReviewsScreen extends StatefulWidget {
  @override
  _GuardianAddReviewsScreenState createState() =>
      _GuardianAddReviewsScreenState();
}

class _GuardianAddReviewsScreenState extends State<GuardianAddReviewsScreen> {
  List<Map<String, dynamic>> caregivers = [];
  bool _isLoading = true;
  int? guardianId;

  @override
  void initState() {
    super.initState();
    // Ensure guardianId is retrieved first, then fetch caregivers
    _retrieveGuardianId().then((_) {
      _fetchCaregivers();
    });
  }

  Future<void> _retrieveGuardianId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedGuardianId = prefs.getInt('guardianId');
    print('Retrieved guardianId from prefs: $storedGuardianId');
    if (storedGuardianId != null) {
      setState(() {
        guardianId = storedGuardianId;
      });
      return;
    }
    // fallback: try to get current user id and resolve guardian id from server
    try {
      final userId = await AuthService.getCurrentUserId();
      if (userId != null) {
        final fetched = await GuardianService.getGuardianIdByUserId(userId);
        print('Fetched guardianId by userId: $fetched');
        if (fetched != null) {
          setState(() {
            guardianId = fetched;
          });
          SharedPreferences prefs2 = await SharedPreferences.getInstance();
          await prefs2.setInt('guardianId', fetched);
          return;
        }
      }
    } catch (e) {
      print('Error retrieving guardianId fallback: $e');
    }
    // if still null, leave guardianId null — fetch will handle it
  }

  Future<void> _fetchCaregivers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Ensure we have guardianId before requesting caregiver list
      if (guardianId == null) {
        await _retrieveGuardianId();
      }

      if (guardianId == null) {
        // Nothing to fetch without guardianId
        caregivers = [];
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Guardian ID not available. Please login again.'),
                backgroundColor: Colors.red),
          );
        }
        return;
      }

      // Prefer API that accepts guardianId. Fallback to parameterless call if it doesn't exist.
      try {
        caregivers =
            await CaregiverService.getExpiredInactiveCaregiversByGuardianId(
                guardianId!);
      } catch (e) {
        // Fallback to older API (if exists)
        print(
            'Fallback to parameterless getExpiredInactiveCaregivers due to: $e');
        caregivers = await CaregiverService.getExpiredInactiveCaregivers();
      }
    } catch (e) {
      caregivers = [];
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load caregivers: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      } else {
        _isLoading = false;
      }
    }
  }

  void _showReviewDialog(Map<String, dynamic> caregiver) {
    final parentContext = context; // capture scaffold/context for SnackBars
    double rating = 0;
    TextEditingController reviewController = TextEditingController();
    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.reviews_outlined,
                          color: AppColors.info,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Review ${caregiver['fName'] ?? ''} ${caregiver['lName'] ?? ''}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.info,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Your Rating:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        final filled = rating > index;
                        return IconButton(
                          icon: Icon(
                            Icons.star,
                            color: filled ? Colors.amber : Colors.grey[300],
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: reviewController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Write your review...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        ),
                        filled: true,
                        fillColor: AppColors.primaryLight.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.primaryLight),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Close dialog first, then dispose controller
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.onSurfaceVariant),
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            // Resolve caregiver id robustly
                            final dynamic cidValue = caregiver['caregiver_id'] ??
                                caregiver['id'] ??
                                caregiver['caregiverId'];
                            final int? caregiverId =
                                cidValue == null ? null : int.tryParse(cidValue.toString());

                            if (guardianId == null) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Guardian ID not found. Please log in again.'),
                                      backgroundColor: Colors.red),
                                );
                              }
                              return;
                            }
                            if (caregiverId == null) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Missing caregiver ID'),
                                      backgroundColor: Colors.red),
                                );
                              }
                              return;
                            }
                            if (rating == 0) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Please select a rating.'),
                                      backgroundColor: Colors.red),
                                );
                              }
                              return;
                            }
                            if (reviewController.text.trim().isEmpty) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Please enter your review.'),
                                      backgroundColor: Colors.red),
                                );
                              }
                              return;
                            }

                            print(
                                'Submitting review with guardianId: $guardianId, caregiverId: $caregiverId');

                            final success = await CaregiverReviewService.addReview(
                              guardianId: guardianId!,
                              caregiverId: caregiverId,
                              rating: rating.toInt(),
                              reviewText: reviewController.text,
                            );

                            reviewController.dispose();
                            Navigator.pop(context);

                            if (mounted) {
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Review submitted!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                // Optionally refresh list
                                _fetchCaregivers();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to submit review'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            foregroundColor: AppColors.info,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
          'Add Reviews',
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
          : caregivers.isEmpty
              ? Center(child: Text('No expired/inactive caregivers found'))
              : ListView.separated(
                  padding: EdgeInsets.all(24),
                  itemCount: caregivers.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final caregiver = caregivers[index];
                    // Determine if caregiver is inactive/expired using several common keys
                    final status = caregiver['status']?.toString().toLowerCase();
                    final bool isInactive = (status == 'inactive' || status == 'expired') ||
                        (caregiver['isActive'] == false) ||
                        (caregiver['active'] == false) ||
                        (caregiver['expired'] == true);
                    return Material(
                      color: AppColors.primaryLight.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        // Keep inactive caregivers clickable so guardians can add reviews
                        onTap: () => _showReviewDialog(caregiver),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.info,
                                  size: 32,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${caregiver['fName'] ?? ''} ${caregiver['lName'] ?? ''}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.info,
                                            ),
                                          ),
                                        ),
                                        if (isInactive)
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: Colors.redAccent.withOpacity(0.25)),
                                            ),
                                            child: Text(
                                              'INACTIVE',
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Email: ${caregiver['email'] ?? ''}',
                                      style: TextStyle(
                                          fontSize: 14, color: AppColors.onSurface),
                                    ),
                                    Text(
                                      'Experience: ${caregiver['experience'] ?? ''}',
                                      style: TextStyle(
                                          fontSize: 14, color: AppColors.onSurface),
                                    ),
                                    Text(
                                      'Qualifications: ${caregiver['qualifications'] ?? ''}',
                                      style: TextStyle(
                                          fontSize: 14, color: AppColors.onSurface),
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
