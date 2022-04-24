import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//ignore_for_file: prefer_const_constructors

class LoadingPassReset extends StatefulWidget {
  const LoadingPassReset({Key? key}) : super(key: key);

  @override
  State<LoadingPassReset> createState() => _LoadingState();
}

class _LoadingState extends State<LoadingPassReset> {
  // late bool _isButtonDisabled;
  // late CancelableOperation _cancelableFuture;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _isButtonDisabled = true;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitFadingCircle(
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}

class Loading2 extends StatefulWidget {
  const Loading2({Key? key}) : super(key: key);

  @override
  State<Loading2> createState() => _Loading2State();
}

class _Loading2State extends State<Loading2> {
  late bool _isButtonEnabled;
  CancelableOperation? _cancelableFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isButtonEnabled = false;
  }

  // void _cancelFuture() async {
  //   await _cancelableFuture?.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      _isButtonEnabled = true;
    });
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SpinKitFadingCircle(
              size: 100,
              color: Color.fromARGB(228, 37, 170, 225),
            ),
            SizedBox(
              height: 10,
            ),
            // IconButton(
            //     onPressed: () async {
            //       _cancelFuture();
            //       Phoenix.rebirth(context);
            //     },
            //     icon: Icon(
            //       Icons.cancel,
            //       size: 35,
            //       color: Colors.white,
            //     ))
          ]),
    );
  }
}
