import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/detail/daily_item/daily_item.dart';
import '../../../utils/colors.dart';
import '../../../utils/my_utils.dart';
import '../../weather_main/widgets/weather_product.dart';

class WeatherDailyScreen extends StatefulWidget {
  final List<DailyItem> daily;
  final String title;
  const WeatherDailyScreen({Key? key, required this.daily, required this.title}) : super(key: key);

  @override
  State<WeatherDailyScreen> createState() => _WeatherDailyScreenState();
}

class _WeatherDailyScreenState extends State<WeatherDailyScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var daily = widget.daily;

    return Scaffold(
      backgroundColor: AppColors.C_90B2F9,
      appBar: AppBar(
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(
          fontWeight: FontWeight.w500
        ),),
        centerTitle: true,
        backgroundColor: AppColors.C_90B2F9,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  debugPrint("Settings Tapped!");
                },
                icon: const Icon(Icons.settings)),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 115,),
          Container(
            height: size.height * .75,
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -65,
                  right: 20,
                  left: 20,
                  child: Container(
                    height: 300,
                    width: size.width * .7,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.center,
                          colors: [
                            Color(0xffa9c1f5),
                            Color(0xff6696f5),
                          ]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(.1),
                          offset: const Offset(0, 25),
                          blurRadius: 3,
                          spreadRadius: -10,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -100,
                          left: -25,
                          width: 250,
                          child: Image.network("https://openweathermap.org/img/wn/${daily[7].weather[0].icon}@4x.png", fit: BoxFit.cover,),
                        ),
                        Positioned(
                            top: 100,
                            left: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                  DateFormat('EEEE, d MMMM').format(MyUtils.getDateTime(daily[0].dt)).toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Container(
                            width: size.width * .8,
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                WeatherProduct(
                                  text: 'Wind Speed',
                                  value: daily[0].windSpeed,
                                  unit: 'km/h',
                                  imageUrl: 'assets/images/windspeed.png',
                                ),
                                WeatherProduct(
                                    text: 'Humidity',
                                    value: daily[0].humidity,
                                    unit: '%',
                                    imageUrl: 'assets/images/humidity.png'),
                                WeatherProduct(
                                  text: 'Wind Speed',
                                  value:
                                  (daily[0].dailyTemp.day).round(),
                                  unit: 'C',
                                  imageUrl: 'assets/images/max-temp.png',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                daily[0].dailyTemp.day.toString(),
                                style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.tealAccent
                                ),
                              ),
                              const Text(
                                'o',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 250,
                    left: 20,
                    right: 20,
                    child: SizedBox(
                        height: 450,
                        width: double.infinity,
                        child: ListView(
                          children: List.generate(daily.length, (index) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10,),
                                  Text(DateFormat('EEEE, d MMMM').format(MyUtils.getDateTime(daily[index].dt)).toString()),
                                  const Spacer(),
                                  SizedBox(height: 40, width: 40, child: Image.network("https://openweathermap.org/img/wn/${daily[7].weather[0].icon}@4x.png", fit: BoxFit.cover,),)
                                ],
                              )
                          )),
                        ))
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}