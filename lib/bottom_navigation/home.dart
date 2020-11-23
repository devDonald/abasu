import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Home"), backgroundColor: Colors.green),

      body: pageBody(context) ,
    );
  }
}
Widget pageBody(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Flexible(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: [
            GestureDetector(
              onTap: (){

              },
              child: HomeView(
                category: 'Construction Materials',
                image: 'assets/images/building.png',
              ),
            ),

            GestureDetector(
              onTap: (){

              },
              child: HomeView(
                category: 'Manpower',
                image: 'assets/images/manpower.png',
              ),
            )
          ],
        ),

      )
    ],
  );
}
class HomeView extends StatelessWidget {
  final String category;
  final String image;

  const HomeView({Key key, this.category, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(
              0.0,
              2.5,
            ),
            color: Colors.black12,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 7,
              top: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              height: 100.0,
              padding: EdgeInsets.only(
                top: 8,
                left: 9,
                right: 9,
              ),
              child: Image(
                image: AssetImage(
                    image
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
