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
    // return SingleChildScrollView(
    //   padding: EdgeInsets.only(bottom: 80),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       AnimatedOpacity(
    //         opacity: 1.0,
    //         duration: Duration(microseconds: 600),

    //         child: Padding(
    //           padding: EdgeInsets.all(16),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               SizedBox(height: 12),
    //               Text(
    //                 albumDesc,
    //                 style: TextStyle(fontSize: 14),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return SafeArea(
      top: false,
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text("User Reviews:", style: TextStyle(fontWeight: FontWeight.bold)),
            //SizedBox(height: 12),
            
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
