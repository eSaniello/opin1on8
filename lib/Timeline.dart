import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:opin1on8/components/rounded_button.dart';
import 'package:opin1on8/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'service_details.dart';

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final userData = Provider.of<User>(context).user;

    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: Firestore.instance.collection('services').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: LinearProgressIndicator(),
                );

              return RefreshIndicator(
                key: refreshIndicatorKey,
                onRefresh: () async {
                  print('refreshed');
                },
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];

                    Map r = ds['rating'];
                    double weightedAverage = (5 * r['5'] +
                            4 * r['4'] +
                            3 * r['3'] +
                            2 * r['2'] +
                            1 * r['1']) /
                        (r['5'] + r['4'] + r['3'] + r['2'] + r['1']);

                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(ds['name']),
                              subtitle: Text(ds['description']),
                            ),
                            InkWell(
                              onTap: () {
                                Map serviceDetails = {};
                                serviceDetails['id'] = ds.documentID;
                                serviceDetails['name'] = ds['name'];
                                serviceDetails['description'] =
                                    ds['description'];
                                serviceDetails['category'] = ds['category'];
                                serviceDetails['imageUrl'] = ds['imageUrl'];
                                serviceDetails['location'] = ds['location'];
                                serviceDetails['owner'] = ds['owner'];
                                serviceDetails['rating'] = ds['rating'];
                                serviceDetails['weightedAverage'] =
                                    weightedAverage;
                                serviceDetails['rated_by'] = ds['rated_by'];
                                serviceDetails['userData'] = userData;

                                Navigator.pushNamed(context, ServiceDetails.id,
                                    arguments: serviceDetails);
                              },
                              child: Container(
                                width: size.width,
                                child: CachedNetworkImage(
                                  fit: BoxFit.fitWidth,
                                  imageUrl: ds['imageUrl'],
                                  placeholder: (context, url) =>
                                      LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SmoothStarRating(
                                  allowHalfRating: false,
                                  starCount: 5,
                                  rating: weightedAverage,
                                  size: 40.0,
                                  isReadOnly: true,
                                  color: Colors.pink,
                                  borderColor: Colors.pink,
                                  spacing: 0.0,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
