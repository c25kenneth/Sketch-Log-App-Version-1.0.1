import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DrawingCard extends StatefulWidget {
  final String text;
  final String imageUrl;
  final String subtitle;
  final Function() onPressed;

  const DrawingCard(
      {required this.text,
      required this.imageUrl,
      required this.subtitle,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  State<DrawingCard> createState() => _DrawingCardState();
}

class _DrawingCardState extends State<DrawingCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.65,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.settings,
              label: 'Edit',
              onPressed: (BuildContext context) {

              },
            ),
            SlidableAction(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              onPressed: (BuildContext context) {

              },
            ),
          ],
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100, 
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.5),
            boxShadow: [
              BoxShadow(
                offset: const Offset(10, 20),
                blurRadius: 10,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.1),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: const Icon(Icons.draw_outlined, color: Colors.orangeAccent, size:75),
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
