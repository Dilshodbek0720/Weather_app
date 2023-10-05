import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:n8_default_project/data/models/detail/daily_item/daily_item.dart';
import 'package:n8_default_project/data/models/detail/one_call_data.dart';
import 'package:n8_default_project/data/models/main/lat_lon.dart';
import 'package:n8_default_project/data/models/main/weather_main_model.dart';
import 'package:n8_default_project/data/models/universal_data.dart';
import 'package:n8_default_project/data/network/api_provider.dart';
import 'package:n8_default_project/ui/weather_daily/widgets/weather_daily_screen.dart';
import 'package:n8_default_project/ui/weather_main/widgets/weather_product.dart';
import 'package:n8_default_project/utils/colors.dart';
import 'package:n8_default_project/utils/my_utils.dart';

class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({Key? key, required this.latLong}) : super(key: key);
  final LatLong latLong;
  @override
  State<WeatherMainScreen> createState() => _WeatherMainScreenState();
}

class _WeatherMainScreenState extends State<WeatherMainScreen> {
  String query = "";
  List<String> cities = ["Toshkent", "Samarqand"];
  final TextEditingController _cityController = TextEditingController();
  List<DailyItem> daily = [];

  double lat = 0;
  double long = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: SizedBox(
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SingleChildScrollView(
                            controller: ScrollController(),
                            child: Container(
                              height: size.height * .5,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  TextField(
                                    onSubmitted: (searchText) async {
                                      setState(() async {
                                        query = searchText;
                                        UniversalData data = await ApiProvider
                                            .getMainWeatherDataByQuery(
                                                query: searchText);
                                        WeatherMainModel model = data.data;
                                        lat = model.coordModel.lat;
                                        long = model.coordModel.lon;
                                      });
                                    },
                                    controller: _cityController,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.search,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () => _cityController.clear(),
                                          child: const Icon(
                                            Icons.close,
                                          ),
                                        ),
                                        hintText: 'Search city e.g. London',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  icon: Icon(
                    Icons.search,
                    size: 30.sp,
                  )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      // value: location,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: cities.map((String location) {
                        return DropdownMenuItem(
                            value: location, child: Text(location));
                      }).toList(),
                      onChanged: (String? newValue) async {
                        setState(() {
                          query = newValue!;
                        });
                        UniversalData data =
                            await ApiProvider.getMainWeatherDataByQuery(
                                query: newValue!);
                        WeatherMainModel model = data.data;
                        lat = model.coordModel.lat;
                        long = model.coordModel.lon;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder<UniversalData>(
        future: query.isEmpty
            ? ApiProvider.getMainWeatherDataByLatLong(
                lat: widget.latLong.lat, long: widget.latLong.long)
            : ApiProvider.getMainWeatherDataByQuery(query: query),
        builder: (BuildContext context, AsyncSnapshot<UniversalData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.error.isEmpty) {
              WeatherMainModel weatherMainModel =
                  snapshot.data!.data as WeatherMainModel;
              return SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h),
                      child: Text(
                        weatherMainModel.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.sp,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        DateFormat('EEEE, d MMMM')
                            .format(
                                MyUtils.getDateTime(weatherMainModel.dateTime))
                            .toString(),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      width: size.width,
                      height: 200.h,
                      decoration: BoxDecoration(
                          color: const Color(0xff90B2F9),
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff90B2F9).withOpacity(.5),
                              offset: const Offset(0, 25),
                              blurRadius: 10.r,
                              spreadRadius: -12.r,
                            )
                          ]),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -90.h,
                            left: 0,
                            child: Image.network(
                              "https://openweathermap.org/img/wn/${weatherMainModel.weatherModel[0].icon}@4x.png",
                              fit: BoxFit.cover,
                              width: 240.w,
                            ),
                          ),
                          Positioned(
                            bottom: 30.h,
                            left: 20.w,
                            child: Text(
                              weatherMainModel.weatherModel[0].description
                                  .toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.sp,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20.h,
                            right: 20.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    (weatherMainModel.mainInMain.temp - 273.15)
                                        .round()
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 60.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xA5E1DFFF)
                                        // foreground: Paint()..shader = linearGradient,
                                        ),
                                  ),
                                ),
                                Text(
                                  'o',
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xA5E1DFFF)
                                      // foreground: Paint()..shader = linearGradient,
                                      ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WeatherProduct(
                            text: 'Wind Speed',
                            value: weatherMainModel.windInMain.speed,
                            unit: 'km/h',
                            imageUrl: 'assets/images/windspeed.png',
                          ),
                          WeatherProduct(
                              text: 'Humidity',
                              value: weatherMainModel.mainInMain.humidity,
                              unit: '%',
                              imageUrl: 'assets/images/humidity.png'),
                          WeatherProduct(
                            text: 'Wind Speed',
                            value:
                                (weatherMainModel.mainInMain.tempMax - 273.15)
                                    .round(),
                            unit: 'C',
                            imageUrl: 'assets/images/max-temp.png',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Today",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              UniversalData data =
                                  await ApiProvider.getWeatherOneCallData(
                                      lat: lat, long: long);
                              OneCallData model = data.data;
                              daily = model.daily;
                              if(context.mounted){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return WeatherDailyScreen(
                                        daily: daily,
                                        title: query,
                                      );
                                    }));
                              }
                            },
                            child: Text(
                              "Next 7 days",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff90B2F9)),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    FutureBuilder<UniversalData>(
                      future: query.isEmpty
                          ? ApiProvider.getWeatherOneCallData(
                              lat: widget.latLong.lat,
                              long: widget.latLong.long)
                          : ApiProvider.getWeatherOneCallData(
                              lat: lat, long: long),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        if (snapshot.hasData) {
                          OneCallData oneCallData = snapshot.data!.data;
                          return Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 24,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.h),
                                        margin: EdgeInsets.only(
                                            right: 20.w, bottom: 20.h, top: 10.h),
                                        width: 80.w,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(10.r)),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 1),
                                                blurRadius: 5.r,
                                                color: Colors.black54
                                                    .withOpacity(.2),
                                              ),
                                            ]),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${oneCallData.hourly[index].temp
                                                  .round()}C",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                color: AppColors.C_90B2F9,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Image.network(
                                              "https://openweathermap.org/img/wn/${oneCallData.hourly[index].weather[0].icon}@4x.png",
                                              fit: BoxFit.cover,
                                              width: 45.w,
                                            ),
                                            Text(
                                              MyUtils.getDateTime(oneCallData
                                                      .hourly[index].dt)
                                                  .toString()
                                                  .substring(11, 16),
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                color: AppColors.C_90B2F9,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }));
                        } else {
                          return Text("Error:${snapshot.error.toString()}");
                        }
                      },
                    ),
                  ],
                ),
              );
            }
          }
          return Center(
            child: Text(snapshot.error.toString()),
          );
        },
      ),
    );
  }
}
