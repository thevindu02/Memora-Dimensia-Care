import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/color_constants.dart';
import '../../services/caregiver_service.dart';
import '../../services/caregiver_review_service.dart';
import '../../services/guardian_service.dart';

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
    _fetchCaregivers();
    _retrieveGuardianId();
  }

  Future<void> _retrieveGuardianId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedGuardianId = prefs.getInt('guardianId');
    print('Retrieved guardianId from prefs: $storedGuardianId');
    setState(() {
      guardianId = storedGuardianId;
    });
  }

  Future<void> _fetchCaregivers() async {
    try {
      caregivers = await CaregiverService.getExpiredInactiveCaregivers();
    } catch (e) {
      caregivers = [];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load caregivers'), backgroundColor: Colors.red),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showReviewDialog(Map<String, dynamic> caregiver) {
    double rating = 0;
    TextEditingController reviewController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
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
                        Text(
                          'Review ${caregiver['fName']} ${caregiver['lName']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.info,
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
                        return IconButton(
                          icon: Icon(
                            Icons.star,
                            color: rating > index
                                ? Colors.amber
                                : Colors.grey[300],
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
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.onSurfaceVariant),
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (guardianId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Guardian ID not found. Please log in again.'), backgroundColor: Colors.red),
                              );
                              return;
                            }
                            if (caregiver['caregiver_id'] == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Missing caregiver ID'), backgroundColor: Colors.red),
                              );
                              return;
                            }
                            if (rating == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please select a rating.'), backgroundColor: Colors.red),
                              );
                              return;
                            }
                            if (reviewController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please enter your review.'), backgroundColor: Colors.red),
                              );
                              return;
                            }
                            // If backend returns 'caregiver_id'
                            print('Submitting review with guardianId: $guardianId, caregiverId: ${caregiver['caregiver_id']}');
                            final success = await CaregiverReviewService.addReview(
                              guardianId: guardianId!,
                              caregiverId: int.parse(caregiver['caregiver_id'].toString()), // <-- use 'caregiver_id' if backend returns this
                              rating: rating.toInt(),
                              reviewText: reviewController.text,
                            );
                            Navigator.pop(context);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Review submitted!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to submit review'),
                                  backgroundColor: Colors.red,
                                ),
                              );
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
                    return Material(
                      color: AppColors.primaryLight.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
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
                                    Text(
                                      '${caregiver['fName']} ${caregiver['lName']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.info,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Email: ${caregiver['email']}',
                                      style: TextStyle(fontSize: 14, color: AppColors.onSurface),
                                    ),
                                    Text(
                                      'Experience: ${caregiver['experience'] ?? ''}',
                                      style: TextStyle(fontSize: 14, color: AppColors.onSurface),
                                    ),
                                    Text(
                                      'Qualifications: ${caregiver['qualifications'] ?? ''}',
                                      style: TextStyle(fontSize: 14, color: AppColors.onSurface),
                                    ),
                                  ],
                                ),
                              ),
                              // Remove IconButton for review, keep card tap only
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
