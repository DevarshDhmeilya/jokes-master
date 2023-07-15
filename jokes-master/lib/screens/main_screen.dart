import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:jokes_app/model/jokes_response.dart';
import 'package:jokes_app/services/api_manager.dart';
import 'package:jokes_app/utils/color_list.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: QuoteView(),
    );
  }
}

class QuoteView extends StatefulWidget {
  @override
  _QuoteViewState createState() => _QuoteViewState();
}

class _QuoteViewState extends State<QuoteView> {
  Future _jokeFuture;

  @override
  void initState() {
    _jokeFuture = APIManager().getJoke();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var color = colors[math.Random().nextInt(colors.length)];

    return Container(
      color: color,
      width: double.infinity,
      child: SafeArea(
        child: FutureBuilder<JokeResponse>(
            future: _jokeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return QuoteItem(snapshot.data);
              }
            }),
      ),
    );
  }

  Widget QuoteItem(JokeResponse joke) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              '\n __Jokes__',
              textAlign: TextAlign.center,
              style: GoogleFonts.abel(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    joke.joke,
                    //overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                    style:
                        GoogleFonts.ptSerif(color: Colors.black54, fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),

                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child:ElevatedButton(
            child:Text("--Fetch My Laugh--"),
            onPressed: () {
              _onValueChange();
              BoxDecoration(
                color: Colors.black,
              );
            },
          ),
        )
      ],
    );
  }

  void _onValueChange() {
    _jokeFuture = APIManager().getJoke();
    setState(() {});
  }
}
