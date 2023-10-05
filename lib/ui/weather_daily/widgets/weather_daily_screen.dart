import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    int selectedIndex = 0;
    void init({required int id}){
      setState(() {
        selectedIndex = id;
      });
    }

    return Scaffold(
      backgroundColor: AppColors.C_90B2F9,
      appBar: AppBar(
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(
          fontWeight: FontWeight.w500
        ),),
        centerTitle: true,
        backgroundColor: AppColors.C_90B2F9.withOpacity(0.3),
        elevation: 0.0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
                onPressed: () {
                  selectedIndex = 1;
                },
                icon: const Icon(Icons.settings)),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 115.h,),
          Container(
            height: size.height * .74,
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.r),
                topRight: Radius.circular(50.r),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -65.h,
                  right: 20.w,
                  left: 20.w,
                  child: Container(
                    height: 300.h,
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
                          blurRadius: 3.r,
                          spreadRadius: -10.r,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -100.h,
                          left: -25.w,
                          width: 250.w,
                          child: Image.network("https://openweathermap.org/img/wn/${daily[selectedIndex].weather[0].icon}@4x.png", fit: BoxFit.cover,),
                        ),
                        Positioned(
                            top: 100.h,
                            left: 30.w,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Text(
                                  DateFormat('EEEE, d MMMM').format(MyUtils.getDateTime(daily[selectedIndex].dt)).toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.sp),
                              ),
                            )),
                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          child: Container(
                            width: size.width * .8,
                            padding:
                            EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                WeatherProduct(
                                  text: 'Wind Speed',
                                  value: daily[selectedIndex].windSpeed,
                                  unit: 'km/h',
                                  imageUrl: 'assets/images/windspeed.png',
                                ),
                                WeatherProduct(
                                    text: 'Humidity',
                                    value: daily[selectedIndex].humidity,
                                    unit: '%',
                                    imageUrl: 'assets/images/humidity.png'),
                                WeatherProduct(
                                  text: 'Wind Speed',
                                  value:
                                  (daily[selectedIndex].dailyTemp.day).round(),
                                  unit: 'C',
                                  imageUrl: 'assets/images/max-temp.png',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20.h,
                          right: 20.w,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                daily[selectedIndex].dailyTemp.day.toString(),
                                style: TextStyle(
                                    fontSize: 42.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.tealAccent
                                ),
                              ),
                              Text(
                                'o',
                                style: TextStyle(
                                  fontSize: 25.sp,
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
                    top: 250.h,
                    left: 20.w,
                    right: 20.w,
                    child: SizedBox(
                        height: 450*MediaQuery.of(context).size.height/812,
                        width: double.infinity,
                        child: ListView(
                          children: [...List.generate(daily.length, (index) => GestureDetector(
                            onTap: (){
                              init(id: index);
                              debugPrint(selectedIndex.toString());
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8.h),
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                height: 60.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 10.w,),
                                    Text(DateFormat('EEEE, d MMMM').format(MyUtils.getDateTime(daily[index].dt)).toString()),
                                    const Spacer(),
                                    SizedBox(height: 40.h, width: 40.w, child: Image.network("https://openweathermap.org/img/wn/${daily[7].weather[0].icon}@4x.png", fit: BoxFit.cover,),)
                                  ],
                                )
                            ),
                          )),
                          SizedBox(height: 100.h,)]
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