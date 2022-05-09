import 'package:ether_wallet/utils/loading_status.dart';
import 'package:flutter/material.dart';

class FullScreenCircularProgressIndicator extends StatefulWidget {
  Color backgroundColor;
  LoadingStatus loadingStatus;
  Widget child;

  FullScreenCircularProgressIndicator({
    this.backgroundColor = Colors.white70,
    required this.loadingStatus,
    required this.child,
});
  @override
  _FullScreenCircularProgressIndicatorState createState() => _FullScreenCircularProgressIndicatorState();
}

class _FullScreenCircularProgressIndicatorState extends State<FullScreenCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        widget.loadingStatus.isLoading() ?
        Container(
          alignment: Alignment.center,
          color: widget.backgroundColor,
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        ) : Container(),
      ],
    );
  }
}
