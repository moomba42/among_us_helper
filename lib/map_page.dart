import 'dart:math';

import "package:flutter/material.dart";
import "package:photo_view/photo_view.dart";

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoView(
          imageProvider: AssetImage("assets/mira_hq.png"),
          backgroundDecoration: BoxDecoration(color: const Color(0xFF2E3444)),
        ),
        SizedBox(
          height: 56,
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            centerTitle: true,
            title: Text("Mira HQ"),
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black87, Colors.transparent]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
