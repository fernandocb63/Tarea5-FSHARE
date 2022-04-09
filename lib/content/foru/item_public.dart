import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:network_to_file_image/network_to_file_image.dart';

class ItemPublic extends StatefulWidget {
  final Map<String, dynamic> publicFData;
  ItemPublic({Key? key, required this.publicFData}) : super(key: key);
  @override
  State<ItemPublic> createState() => _ItemPublicState();
}
class _ItemPublicState extends State<ItemPublic> {
  
  Future<File> _fileFromImageUrl(String url) async {
    final urlimg = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final img = File(join(documentDirectory.path, 'imagetest.png'));
    img.writeAsBytesSync(urlimg.bodyBytes);
    return img;
  }

  @override
  Widget build(BuildContext context) {
    //Timestamp myTimeStamp = new Text("${widget.publicFData["publishedAt"].toDate()}") as Timestamp;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                "${widget.publicFData["picture"]}",
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Text("${widget.publicFData["username"].toString()[0]}"),
              ),
              title: Text("${widget.publicFData["title"]}"),
              subtitle:  new Text("${widget.publicFData["publishedAt"].toDate()}"),
              trailing: Wrap(
                children: [
                  IconButton(
                    icon: Icon(Icons.star_outlined, color: Colors.green),
                    tooltip: "Likes: ${widget.publicFData["stars"]}",
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: "Compartir",
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      File share_image = await _fileFromImageUrl(widget.publicFData["picture"]);
                      List<String> imagesPaths = [];
                      imagesPaths.add(share_image.path);
                      DateTime date = widget.publicFData["publishedAt"].toDate();
                      String date_Toshare = date.toString();
                      Share.shareFiles(imagesPaths,
                        text: widget.publicFData["title"],
                        subject: date_Toshare);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}