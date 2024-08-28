import 'package:canvas_vault/FirestoreFuncs.dart';
import 'package:canvas_vault/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCarouselFB2 extends StatefulWidget {
  final String sketchbookID;
  final List cards;
  const CustomCarouselFB2(
      {Key? key, required this.sketchbookID, required this.cards})
      : super(key: key);

  @override
  _CustomCarouselFB2State createState() => _CustomCarouselFB2State();
}

class _CustomCarouselFB2State extends State<CustomCarouselFB2> {

  final double carouselItemMargin = 16;

  late PageController _pageController;
  int _position = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: .7);
  }
  @override
  void dispose() {
    _pageController.dispose(); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.cards.length,
      onPageChanged: (int position) {
        setState(() {
          _position = position;
        });
      },
      itemBuilder: (BuildContext context, int position) {
        return AnimatedBuilder(
          animation: _pageController,
          builder: (BuildContext context, Widget? widget) {
            return Container(
              margin: EdgeInsets.all(carouselItemMargin),
              child: Center(child: widget),
            );
          },
          child: widget.cards[position],
        );
      },
    );
  }
}

class CardFb1 extends StatelessWidget {
  final String imageUrl;
  final String sketchbookID;
  final bool isNetworkImage;
  final Function() onPressed;

  const CardFb1({
    required this.imageUrl,
    required this.sketchbookID,
    required this.isNetworkImage,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.5),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(10, 20),
                  blurRadius: 10,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.05),
                ),
              ],
            ),
            child: isNetworkImage
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return Dialog(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            );
                          });
                    },
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Image.asset(
                          fit: BoxFit.cover,
                          "assets/images/undraw_Add_files_re_v09g.png",
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 0, left: 8, right: 8, bottom: 8),
                        child: Text(
                          'Add Image',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          if (isNetworkImage)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 40, 
                height: 40, 
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: IconButton(
                    color: Colors.orangeAccent,
                    icon: const Icon(Icons.close,
                        size: 25),
                    onPressed: () async {
                      dynamic res = await deleteImage(sketchbookID, imageUrl);

                      if (res.runtimeType != String) {
                        await showDialog(
                            context: navigatorKey.currentContext!,
                            builder: (context) {
                              return AlertDialog(
                                surfaceTintColor: Colors.transparent,
                                contentPadding: EdgeInsets.zero,
                                insetPadding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                content: SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.6),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize
                                            .min, 
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/undraw_blank_canvas_re_2hwy.svg",
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                          ),
                                          const SizedBox(height: 35),
                                          const Text(
                                            "Internal Error. Please try again later.",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 20),
                                          TextButton(
                                            child: const Text("OK", style: TextStyle(color: Colors.orange),),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
