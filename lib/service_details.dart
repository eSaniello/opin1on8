import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:opin1on8/components/rounded_button.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'home.dart';

class ServiceDetails extends StatefulWidget {
  static const String id = 'service_details';

  final Map serviceDetails;

  ServiceDetails(
    this.serviceDetails,
  );

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  double rating = 1;
  bool rated = false;
  double userRating = 1;
  FirebaseUser userData;

  @override
  void initState() {
    super.initState();

    Map ratedBy = widget.serviceDetails['rated_by'];
    userData = widget.serviceDetails['userData'];

    for (var uid in ratedBy.keys) {
      if (uid == userData.uid) {
        rated = true;
        userRating = ratedBy[userData.uid];
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceDetails['name']),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: CachedNetworkImage(
                  imageUrl: widget.serviceDetails['imageUrl'],
                  placeholder: (context, url) => LinearProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Text(widget.serviceDetails['description']),
              Text('Location: ' + widget.serviceDetails['location']),
              Text(widget.serviceDetails['owner'] != ''
                  ? 'Owner: ' + widget.serviceDetails['owner']
                  : 'Owner: ' + "Not specified"),
              Text('Current rating:'),
              SmoothStarRating(
                allowHalfRating: false,
                starCount: 5,
                rating: widget.serviceDetails['weightedAverage'],
                size: 40.0,
                isReadOnly: true,
                color: Colors.pink,
                borderColor: Colors.pink,
                spacing: 0.0,
              ),
              Text('1 star reviews: ${widget.serviceDetails['rating']['1']}'),
              Text('2 star reviews: ${widget.serviceDetails['rating']['2']}'),
              Text('3 star reviews: ${widget.serviceDetails['rating']['3']}'),
              Text('4 star reviews: ${widget.serviceDetails['rating']['4']}'),
              Text('5 star reviews: ${widget.serviceDetails['rating']['5']}'),
              Divider(
                color: Colors.black12,
                thickness: 2,
              ),
              rated ? Text('Your rating:') : Text('Rate this service:'),
              rated
                  ? SmoothStarRating(
                      allowHalfRating: false,
                      starCount: 5,
                      rating: userRating,
                      size: 40.0,
                      isReadOnly: true,
                      color: Colors.pink,
                      borderColor: Colors.pink,
                      spacing: 0.0,
                    )
                  : SmoothStarRating(
                      allowHalfRating: false,
                      onRated: (v) {
                        setState(() {
                          rating = v;
                          print(rating);
                        });
                      },
                      starCount: 5,
                      rating: rating,
                      size: 40.0,
                      isReadOnly: false,
                      color: Colors.pink,
                      borderColor: Colors.pink,
                      spacing: 0.0,
                    ),
              rated
                  ? RoundedButton(
                      title: 'Edit Rating',
                      colour: Colors.deepPurpleAccent,
                      onPressed: () {
                        setState(() {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialog(
                              widget.serviceDetails['rating'],
                              widget.serviceDetails['id'],
                              userRating,
                              widget.serviceDetails['userData'].uid,
                              widget.serviceDetails['rated_by'],
                            ),
                          );
                        });
                      },
                    )
                  : RoundedButton(
                      title: 'Rate',
                      colour: Colors.deepPurpleAccent,
                      onPressed: () {
                        Map _rating = widget.serviceDetails['rating'];
                        if (rating == 1) {
                          _rating['1'] += 1;
                        } else if (rating == 2) {
                          _rating['2'] += 1;
                        } else if (rating == 3) {
                          _rating['3'] += 1;
                        } else if (rating == 4) {
                          _rating['4'] += 1;
                        } else if (rating == 5) {
                          _rating['5'] += 1;
                        }

                        Map ratedBy = widget.serviceDetails['rated_by'];
                        ratedBy[userData.uid] = rating;

                        Firestore.instance
                            .collection('services')
                            .document(widget.serviceDetails['id'])
                            .updateData({
                          'rated_by': ratedBy,
                          'rating': _rating,
                        }).whenComplete(() {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.id);
                        });
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  final Map rating;
  final String id;
  final double currentRating;
  final String uid;
  final Map ratedBy;

  CustomDialog(
    this.rating,
    this.id,
    this.currentRating,
    this.uid,
    this.ratedBy,
  );

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  double rating = 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 18.0,
            ),
            margin: EdgeInsets.only(top: 13.0, right: 8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SmoothStarRating(
                      allowHalfRating: false,
                      onRated: (v) {
                        setState(() {
                          rating = v;
                          print(rating);
                        });
                      },
                      starCount: 5,
                      rating: rating,
                      size: 40.0,
                      isReadOnly: false,
                      color: Colors.pink,
                      borderColor: Colors.pink,
                      spacing: 0.0,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0)),
                    ),
                    child: Text(
                      "RATE",
                      style: TextStyle(
                          color: Colors.deepPurpleAccent, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    Map _rating = widget.rating;

                    if (_rating[(widget.currentRating).toInt().toString()] != 0)
                      _rating[(widget.currentRating).toInt().toString()] -= 1;

                    if (rating == 1) {
                      _rating['1'] += 1;
                    } else if (rating == 2) {
                      _rating['2'] += 1;
                    } else if (rating == 3) {
                      _rating['3'] += 1;
                    } else if (rating == 4) {
                      _rating['4'] += 1;
                    } else if (rating == 5) {
                      _rating['5'] += 1;
                    }

                    Map ratedBy = widget.ratedBy;
                    ratedBy[widget.uid] = rating;

                    Firestore.instance
                        .collection('services')
                        .document(widget.id)
                        .updateData({
                      'rated_by': ratedBy,
                      'rating': _rating,
                    }).whenComplete(() {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, HomeScreen.id);
                    });
                  },
                )
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.close, color: Colors.deepOrangeAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
