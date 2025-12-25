import 'package:flutter/material.dart';
import '../../../widgets/app_scaffold.dart';

class ConstantSplashScreen extends StatelessWidget {
  const ConstantSplashScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AppScaffold(
      body: FittedBox(
        child: Container(
          width: size.width,
          height: size.height,
          // color: Color(0xff101010),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SizedBox(height: size.height * .32),
              Container(
                width: 230,
                height: 200,
                // height: _controller.value.size.height * 0.25,
                child: Image.asset(
                  'assets/images/logo.jpg',
                  height: 200,
                  width: 230,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
