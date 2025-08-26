import 'package:flutter/material.dart';
import 'package:travel_in_chiangmai/const/const.dart';
import 'package:travel_in_chiangmai/models/data_model.dart';
import 'package:travel_in_chiangmai/widgets/detail_review_tab.dart';


class DetailOverviewTab extends StatelessWidget {
  //final Places place;
  final PopularPlaces place; 
  final int currentIndex;

  const DetailOverviewTab({
    super.key,
    required this.place,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Column(
              children: List.generate(userReviews.length,(index) {
                final review = userReviews[index];
                return ReviewTile(
                  name: review.name, 
                  comment: review.comment, 
                  photo: review.photo,
                  );
              }),
            ),

          ],
        ),
      ),
    );
  }
}
