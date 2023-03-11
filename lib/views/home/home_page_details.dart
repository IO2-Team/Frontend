import 'package:flutter/material.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome',
            style: TextStyle(
                fontWeight: FontWeight.w800, height: 0.9, fontSize: 80),
          ),
          SizedBox(
            height: 30,
          ),
          Flexible(
              child: Text(
                  'Dionizos WebPanel, tutaj jakiś tekst narazie potem pewnie coś bardziej adekwatnego. \n Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec in erat tortor. Vestibulum vulputate mollis felis, et eleifend ipsum mollis et. Pellentesque turpis leo, vehicula sit amet gravida sed, auctor tristique justo. Duis facilisis orci ut leo fermentum, id ornare diam dapibus. Praesent consectetur lacus ac risus pulvinar lobortis. Praesent sed nibh non metus lacinia maximus in a urna. Quisque quis tortor at urna tempus eleifend ac sed velit. Curabitur sodales elementum arcu, ac sollicitudin risus commodo at. Integer aliquam lacus sed felis interdum, interdum porta augue bibendum. Donec sed faucibus nisi. Ut sodales dignissim lectus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',
                  style: TextStyle(
                    fontSize: 21,
                    height: 1.7,
                  ))),
        ],
      ),
    );
  }
}
