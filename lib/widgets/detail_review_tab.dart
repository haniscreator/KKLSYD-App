import 'package:flutter/material.dart';
import 'package:travel_in_chiangmai/const/const.dart';

import '../models/data_model.dart';

class DetailReviewTab extends StatelessWidget {
  const DetailReviewTab({super.key});


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(microseconds: 600),

            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text(
                    "This is desc",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    
  }

  
}

