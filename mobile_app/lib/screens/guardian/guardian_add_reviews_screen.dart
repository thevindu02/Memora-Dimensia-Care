import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';

class GuardianAddReviewsScreen extends StatefulWidget {
  @override
  _GuardianAddReviewsScreenState createState() =>
      _GuardianAddReviewsScreenState();
}

class _GuardianAddReviewsScreenState extends State<GuardianAddReviewsScreen> {
  // Hardcoded caregivers
  final List<Map<String, dynamic>> caregivers = [
    {
      'id': 1,
      'name': 'Kamal Perera',
      'period': 'Jan 2023 - Mar 2024',
      'patient': 'John Doe',
    },
    {
      'id': 2,
      'name': 'Nimali Rathnayake',
      'period': 'May 2022 - Dec 2023',
      'patient': 'Jane Smith',
    },
    {
      'id': 3,
      'name': 'David Silva',
      'period': 'Feb 2021 - Nov 2022',
      'patient': 'Sophia Lee',
    },
  ];

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
              backgroundColor:
                  AppColors.surface, // Make dialog background lighter
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
                          'Review ${caregiver['name']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.info, // Restore previous color
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
                                : Colors.grey[300], // Yellow if selected
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
                        ), // More grey
                        filled: true,
                        fillColor: AppColors.primaryLight.withOpacity(
                          0.05,
                        ), // Lighter background
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
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Review submitted!'),
                                backgroundColor:
                                    Colors.green, // Make background green
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.primaryLight, // Button background
                            foregroundColor: AppColors.info, // Button text
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
        iconTheme: IconThemeData(color: Colors.black), // Make back arrow black
      ),
      body: ListView.separated(
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
                      backgroundColor: Colors.grey[300], // Changed to grey
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
                            caregiver['name'],
                                                         style: TextStyle(
                               fontSize: 16, // Reduced from 18
                               fontWeight: FontWeight.w700,
                               color: AppColors.info,
                             ),
                          ),
                          SizedBox(height: 4),
                                                     Text(
                             'Worked with: ${caregiver['patient']}',
                             style: TextStyle(fontSize: 14, color: AppColors.onSurface),
                           ),
                                                     Text(
                             'Period: ${caregiver['period']}',
                             style: TextStyle(fontSize: 14, color: AppColors.onSurface),
                           ),
                        ],
                      ),
                    ),
                                         Icon(Icons.rate_review, color: AppColors.info),
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
