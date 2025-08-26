import 'package:flutter/material.dart';
import 'package:travel_in_chiangmai/const/const.dart';
import 'package:travel_in_chiangmai/pages/audioplayer_page.dart';
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
                    albumDesc,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return SafeArea(
    //   top: false,
    //   bottom: false,
    //   child: SingleChildScrollView(
    //     padding: const EdgeInsets.all(12),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text("User Reviews:", style: TextStyle(fontWeight: FontWeight.bold)),
    //         SizedBox(height: 12),
            
    //         Column(
    //           children: List.generate(userReviews.length,(index) {
    //             final review = userReviews[index];
    //             return ReviewTile(
    //               name: review.name, 
    //               comment: review.comment, 
    //               photo: review.photo,
    //               );
    //           }),
    //         ),

    //       ],
    //     ),
    //   ),
    // );
  }

  
}

class ReviewTile extends StatelessWidget {
  
  final String name;
  final String comment;
  final String photo;

  const ReviewTile({
    super.key,
    required this.name,
    required this.comment,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // padding around the whole tile
      child: ListTile(

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioPlayerPage(
                audioUrl: 'http://dhammadownload.com/MP3Library/Kyaikkalot-Sayadaw-Dr-Candavara-bhivamsa/0068-Dr-Candavara-bhivamsa-2002-03-20-am-Paticcasamuppa.mp3',
                title: name,
                image: 'assets/images/thumbnail/thumbnail4.png', // or use a network image
              ),
            ),
          );
        },

        contentPadding: const EdgeInsets.all(8), // padding inside the tile
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            photo,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(name),
        //subtitle: Text(comment),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: commonAmberColor, // background color for better visibility
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(Icons.play_arrow, color: Colors.white, size: 25),
        ),
      ),
    );
  }

}