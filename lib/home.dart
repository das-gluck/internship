import 'dart:convert';


import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:internship_project/constant.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CarouselController carouselController = CarouselController();
  int currIndex = 0;

  Future Data() async
  {
    String url = urls;
    http.Response response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  Widget Scroll(){
    return FutureBuilder(
      future: Data(),
      builder: (context , snapshot){
        if(snapshot.hasData){
          Map content = snapshot.data;
          return FlexibleSpaceBar(

            background: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: content['bannerImages'].length,
                  itemBuilder: (context , index , currIndex) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(image: NetworkImage(content['bannerImages'][index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                      scrollPhysics: BouncingScrollPhysics(),
                      autoPlay: true,
                      height: double.infinity,
                      viewportFraction: 2,
                      onPageChanged: (index , reason){
                        setState(() {
                          currIndex = index;
                        });
                      }
                  ),
                ),
                Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(content['bannerImages'].length, (index) {
                        return GestureDetector(
                          onTap: ()=> carouselController.animateToPage(index),
                          child: Container(
                            width: currIndex == index ? 17 : 7,
                            height: 7.0,
                            margin: EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currIndex == index ? Colors.white : Colors.grey,
                            ),
                          ),
                        );
                      }),
                    ),
                ),
              ],
            ),
            title: Text(content['bannerTitle'],style: TextStyle(color: Colors.white),),
            titlePadding: EdgeInsets.only(left: 15,right: 200,bottom: 20),
          );
        }else{
          return Center(child:Text('Wait Data is Loading'),);
        }
      },
    );
  }

  Widget updateData(){
    return FutureBuilder(
        future: Data(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            Map content = snapshot.data;
            return FlexibleSpaceBar(
              background: Container(
                color: Colors.orange,
                height: 200,
                child: PageView.builder(
                  itemCount: content['bannerImages'].length,
                  itemBuilder: (context , index){
                    return Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(image: NetworkImage(content['bannerImages'][index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              title: Text(content['bannerTitle'],style: TextStyle(color: Colors.white),),
              titlePadding: EdgeInsets.only(left: 15,right: 200,bottom: 20),
            );
          }else{
            return Center(child:Text('Wait Data is Loading'),);
          }
        },
    );
  }

  Widget DescriptionStar(){
    return FutureBuilder(
        future: Data(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            Map content = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Container(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Wrap(
                            children: List.generate(content['rating'].round(), (index) => Icon(Icons.star, color: Colors.orangeAccent,)),
                          ),
                        ],
                      ),

                      SizedBox(height: 10,),
                      Text(
                        content['description'],
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87
                        ),
                      ),


                      SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(content['details'].length, (index){
                          return ListTile(
                            leading: Icon(Icons.circle,size: 7,color: Colors.black,),
                            title: Text("${content['details'][index]}.",style: TextStyle(fontSize: 19,color: Colors.black),),
                          );
                        }),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }else{
            return Container();
          }
        },
    );
  }

  Widget BottomPage(){
    return FutureBuilder(
        future: Data(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            Map content = snapshot.data;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(content['popularTreks'].length, (index){
                  return Container(
                    margin: EdgeInsets.only(left: 20,bottom: 30,top: 20,right: 10),
                    height: 220,
                    width: 165,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.redAccent,
                      image: DecorationImage(image: NetworkImage(content['popularTreks'][index]['thumbnail']),fit: BoxFit.cover),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 10,top: 170),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(content['popularTreks'][index]['title'],style: TextStyle(color: Colors.white),),
                          Wrap(
                            children: List.generate(content['rating'].round(), (index) => Icon(Icons.star_outlined, color: Colors.orangeAccent,size: 16,)),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );


          }else{
            return Container();
          }
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.teal,
            expandedHeight: 250,
            flexibleSpace: Scroll(),
            leading: IconButton(
              onPressed: (){},
              icon: Icon(Icons.arrow_back_ios),
            ),
            actions: [
              IconButton(
                onPressed: (){} ,
                icon: Icon(Icons.search,),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: DescriptionStar(),
           ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(right: 200,top: 20),
              child: Text("Popular Trek",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          ),
          BottomPage(),
        ],
      ),
    );
  }
}
