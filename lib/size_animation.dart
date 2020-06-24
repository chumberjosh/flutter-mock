import 'package:flutter/material.dart';

class SizeAnimation extends StatefulWidget {
  Widget child;
  SizeAnimation(this.child);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SizeAnimationState();
  }
}

class SizeAnimationState extends State<SizeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _heightAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    _heightAnimation = new Tween<double>(begin: 0.01, end: 0.25).animate(
        new CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addListener(() {
      this.setState(() {});
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * _heightAnimation.value,
        width: MediaQuery.of(context).size.width ,
        child: widget.child);
  }
}
