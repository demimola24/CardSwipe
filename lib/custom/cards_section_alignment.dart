import 'package:flutter/material.dart';
import 'profile_card_alignment.dart';
import 'dart:math';

List<Alignment> cardsAlign = [
  Alignment(0.0, 1.2),
  Alignment(0.0, 0.8),
  Alignment(0.0, 0.0)
];
List<Size> cardsSize = List(3);

class CardsSectionAlignment extends StatefulWidget {
  CardsSectionAlignment(BuildContext context,{@required this.key}) :super() {
      cardsSize[0] = Size(MediaQuery.of(context).size.width * 0.9,
          MediaQuery.of(context).size.height * 0.6);
      cardsSize[1] = Size(MediaQuery.of(context).size.width * 0.85,
          MediaQuery.of(context).size.height * 0.55);
      cardsSize[2] = Size(MediaQuery.of(context).size.width * 0.8,
          MediaQuery.of(context).size.height * 0.5);

  }

  final Key key;

  @override
  _CardsSectionState createState() => _CardsSectionState();
}

class _CardsSectionState extends State<CardsSectionAlignment>
    with SingleTickerProviderStateMixin {
  int cardsCounter = 3;

  var originalList = ['Jane', 'Mike', 'Paul', 'Chuks', 'Femi','Kemi','James','Folu','Dare'];
  var cards  = List();

  AnimationController _controller;

  final Alignment defaultFrontCardAlign = Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;

  @override
  void initState() {
    super.initState();
    // Init cards
    cards = originalList;
    frontCardAlign = cardsAlign[2];

    // Init the animation controller
    _controller =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        changeCardsOrder();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/image/sample_image.jpg"), fit: BoxFit.cover)),
      child: Column(
        children: <Widget>[
          SizedBox(height: 12,),
          Expanded(
              child:Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                   noCards(),
                  backCard(),
                  middleCard(),
                  frontCard(),
                  // Prevent swiping if the cards are animating
                  _controller.status != AnimationStatus.forward
                      ? SizedBox.expand(
                      child: GestureDetector(
                        // While dragging the first card
                        onPanUpdate: (DragUpdateDetails details) {
                          // Add what the user swiped in the last frame to the alignment of the card
                          setState(() {
                            // 20 is the "speed" at which moves the card
                            frontCardAlign = Alignment(
                                frontCardAlign.x +
                                    20 *
                                        details.delta.dx /
                                        MediaQuery.of(context).size.width,
                                frontCardAlign.y +
                                    40 *
                                        details.delta.dy /
                                        MediaQuery.of(context).size.height);

                            frontCardRot = frontCardAlign.x; // * rotation speed;
                          });
                        },
                        // When releasing the first card
                        onPanEnd: (_) {
                          // If the front card was swiped far enough to count as swiped
                          if (frontCardAlign.x > 3.0) {
                            animateCards();
                          }else if (frontCardAlign.x < -3.0) {
                           // animateCards();
                            setState(() {
                              frontCardAlign = defaultFrontCardAlign;
                              frontCardRot = 0.0;
                            });
                          }else {
                            // Return to the initial rotation and alignment
                            setState(() {
                              frontCardAlign = defaultFrontCardAlign;
                              frontCardRot = 0.0;
                            });
                          }
                        },
                      ))
                      : Container(),
                ],
              )),
          buttonsRow()
        ],
      ),
    );
  }
  Widget noCards(){
    if(cards.isEmpty){
      return Container(
        alignment: Alignment.center,
        child: Icon(Icons.grid_off,size: 40,),
      );
    }else{
      return SizedBox();
    }
  }

  Widget backCard() {
    if(cards.length>2){
      return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.backCardAlignmentAnim(_controller).value
            : cardsAlign[0],
        child: SizedBox.fromSize(
            size: _controller.status == AnimationStatus.forward
                ? CardsAnimation.backCardSizeAnim(_controller).value
                : cardsSize[2],
            child:ProfileCardAlignment(cards[2],cardsCounter+1)),
      );
    }
    return SizedBox();
  }

  Widget middleCard() {
    if(cards.length>1){
      return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.middleCardAlignmentAnim(_controller).value
            : cardsAlign[1],
        child: SizedBox.fromSize(
            size: _controller.status == AnimationStatus.forward
                ? CardsAnimation.middleCardSizeAnim(_controller).value
                : cardsSize[1],
            child: ProfileCardAlignment(cards[1],cardsCounter+2)),
      );
    }
    return SizedBox();
  }

  Widget frontCard() {
    if(cards.length>0){
      return Align(
          alignment: _controller.status == AnimationStatus.forward
              ? CardsAnimation.frontCardDisappearAlignmentAnim(
              _controller, frontCardAlign)
              .value
              : frontCardAlign,
          child: Transform.rotate(
            angle: (pi / 180.0) * frontCardRot,
            child: SizedBox.fromSize(size: cardsSize[0], child: ProfileCardAlignment(cards[0],cardsCounter)),
          ));
    }
    return SizedBox();
  }


  Widget buttonsRow() {
    return (cards.length>0) ? Container(
      margin: EdgeInsets.symmetric(vertical: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 16.0)),
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              //animateCardsAndRemove();
            },
            backgroundColor: Colors.white,
            child: Icon(Icons.close, color: Colors.red),
          ),
          Padding(padding: EdgeInsets.only(right: 8.0)),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              animateCards();
            },
            backgroundColor: Colors.white,
            child: Text("Skip",textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Heebo',fontWeight: FontWeight.normal,fontSize:12,color: Colors.black),),
          ),
          Padding(padding: EdgeInsets.only(right: 8.0)),
          FloatingActionButton(
            heroTag: "btn3",
            onPressed: () {
            },
            backgroundColor: Colors.white,
            child: Icon(Icons.done, color: Colors.green),
          ),
          Padding(padding: EdgeInsets.only(right: 16.0)),
        ],
      ),
    ): SizedBox();
  }

  void changeCardsOrder() {

    if(cards.isEmpty){
      return;
    }
    setState(() {
      // Swap cards (back card becomes the middle card; middle card becomes the front card, front card becomes a  bottom card)
      if(cardsCounter>=cards.length+3){
        cards =  originalList;
        cardsCounter=3;
        print("Reset @ $cardsCounter");
      }
      if(cards.length > 2){
      //  print(cardsCounter);
        var temp = cards[0];
        cards[0] = cards[1];
      //  print("${cards[0].recipient}");
        cards[1] = cards[2];
      //  print("${cards[1].recipient}");
       // cards[2] = temp;
        cards[2] = originalList[cardsCounter%originalList.length];
      //  print("${cards[2].recipient}");
      }
      else if(cards.length > 1){
        print(cardsCounter);
        var temp = cards[0];
        cards[0] = cards[1];
        cards[1] = temp;
      }else if(cards.length == 1){
        var temp = cards[0];
//        cards[0] = cards[1];
//        cards[1] = cards[2];
        cards[0] = temp;
        //cards[0] = cards[cardsCounter];
      }
      cardsCounter++;
     // cardsCounter++;
      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;

    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
//    if(cardsCounter%10==2 && cards.total>cards.length){
//      print("top up @: $cardsCounter");
//      widget.onLoadNewItems(cards.offset+10);
//    }else if((cardsCounter-3+cards.offset)==cards.total&& cards.offset!=0){
//      print("reset @: $cardsCounter");
//      widget.onLoadNewItems(0);
//    }else{
//
//    }
  //  cardsCounter++;
  }
  void animateCardsAndRemove() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();

    if(cards.isNotEmpty){
      cards.removeLast();
      //cardsCounter++;
    }
  }
}

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> middleCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    return AlignmentTween(
            begin: beginAlign,
            end: Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(CurvedAnimation(
            parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
