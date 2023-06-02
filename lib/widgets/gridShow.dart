import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drum_pad_admin/widgets/gridViewBox.dart';
import 'package:flutter/material.dart';

class GridDisplay extends StatefulWidget {
  bool filter;
  String? ftrending;
  String? fgenre;
  final String user;

  GridDisplay({
    super.key,
    required this.filter,
    required this.ftrending,
    required this.fgenre,
    required this.user,
  });

  @override
  State<GridDisplay> createState() => _GridDisplayState();
}

class _GridDisplayState extends State<GridDisplay> {
  @override
  Widget build(BuildContext context) {
    int songsCount, filteredSongsCount = 0;
    List? songs, filteredSongs;

    void _filter() {
      {
        if (widget.filter) {
          if (widget.ftrending != null && widget.fgenre != null) {
            filteredSongs = songs!.where((song) {
              return song['trending'] == widget.ftrending &&
                  song['genre'] == widget.fgenre;
            }).toList();
          } else if (widget.ftrending != null && widget.fgenre == null) {
            filteredSongs = songs!.where((song) {
              return song['trending'] == widget.ftrending;
            }).toList();
          } else if (widget.ftrending == null && widget.fgenre != null) {
            filteredSongs = songs!.where((song) {
              return song['genre'] == widget.fgenre;
            }).toList();
          }
          filteredSongsCount = filteredSongs!.length;
        }
      }
    }

    return Flexible(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('DemoSongs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error in receiving Data : ${snapshot.error}');
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                songs = filteredSongs = snapshot.data!.docs;
                songsCount = filteredSongsCount = songs!.length;
                _filter();
                if (filteredSongsCount > 0) {
                  return GridView.builder(
                    itemCount: filteredSongsCount,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                    ),
                    itemBuilder: (context, index) {
                      return GridViewBox(
                        id: filteredSongs![index].id,
                        title: filteredSongs![index]['title'],
                        subtitle: filteredSongs![index]['subTitle'],
                        imageurl: filteredSongs![index]['imgUrl'],
                        songurl: filteredSongs![index]['songUrl'],
                        trending: filteredSongs![index]['trending'],
                        genre: filteredSongs![index]['genre'],
                        user: widget.user,
                        premium: filteredSongs![index]['premium'],
                      );
                    },
                  );
                }
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Text(
                        "No songs found.",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
