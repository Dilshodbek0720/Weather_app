import 'package:flutter/material.dart';
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
                    showModalBottomSheet(context: context, builder: (context){
                      return SingleChildScrollView(
                        controller: ScrollController(),
                        child: Container(
                          height: size.height * .5,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              TextField(
                                onSubmitted: (searchText) async{
                                  setState(() async{
                                    query = searchText;
                                    UniversalData data = await ApiProvider.getMainWeatherDataByQuery(query: searchText);
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
                                      onTap: () =>
                                          _cityController
                                              .clear(),
                                      child: Icon(
                                        Icons.close,
                                      ),
                                    ),
                                    hintText:
                                    'Search city e.g. London',
                                    focusedBorder:
                                    OutlineInputBorder(
                                      borderSide: BorderSide(
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(
                                          10),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 30,
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
                        onChanged: (String? newValue)async{
                          setState(() {
                            query = newValue!;
                          });
                          UniversalData data = await ApiProvider.getMainWeatherDataByQuery(query: newValue!);
                          WeatherMainModel model = data.data;
                          lat = model.coordModel.lat;
                          long = model.coordModel.lon;
                        },),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder<UniversalData>(
        future: query.isEmpty ? ApiProvider.getMainWeatherDataByLatLong(lat: widget.latLong.lat, long: widget.latLong.long) :
        ApiProvider.getMainWeatherDataByQuery(query: query),
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
                // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: Text(
                        weatherMainModel.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
          DateFormat('EEEE, d MMMM').format(MyUtils.getDateTime(weatherMainModel.dateTime)).toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      width: size.width,
                      height: 200,
                      decoration: BoxDecoration(
                          color: const Color(0xff90B2F9),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff90B2F9).withOpacity(.5),
                              offset: const Offset(0, 25),
                              blurRadius: 10,
                              spreadRadius: -12,
                            )
                          ]),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -90,
                            left: 0,
                            child: Image.network(
                              "https://openweathermap.org/img/wn/${weatherMainModel.weatherModel[0].icon}@4x.png",
                              fit: BoxFit.cover,
                              width: 240,
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            left: 20,
                            child: Text(
                              weatherMainModel.weatherModel[0].description.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20, right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    (weatherMainModel.mainInMain.temp - 273.15)
                                        .round()
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xA5E1DFFF)
                                        // foreground: Paint()..shader = linearGradient,
                                        ),
                                  ),
                                ),
                                const Text(
                                  'o',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xA5E1DFFF)
                                      // foreground: Paint()..shader = linearGradient,
                                      ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 40),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Today",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async{
                              UniversalData data = await ApiProvider.getWeatherOneCallData(lat: lat, long: long);
                              OneCallData model = data.data;
                              daily = model.daily;
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return WeatherDailyScreen(daily: daily, title: query,);
                              }));
                            },
                            child: Text(
                              "Next 7 days",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff90B2F9)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<UniversalData>(
                      future: query.isEmpty ? ApiProvider.getWeatherOneCallData(
                          lat: widget.latLong.lat, long: widget.latLong.long) :
                      ApiProvider.getWeatherOneCallData(lat: lat, long: long),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 24,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
// Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(consolidatedWeatherList: consolidatedWeatherList, selectedId: index, location: location,)));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        margin: const EdgeInsets.only(
                                            right: 20, bottom: 20, top: 10),
                                        width: 80,
                                        decoration: BoxDecoration(
// color: selectedDay == today
//     ? myConstants.primaryColor
//     : Colors.white,
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 1),
                                                blurRadius: 5,
// color: selectedDay == today
//     ? myConstants.primaryColor
                                                color: Colors.black54
                                                    .withOpacity(.2),
                                              ),
                                            ]),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
// consolidatedWeatherList[index]['the_temp']
                                              (oneCallData.hourly[index].temp)
                                                      .round()
                                                      .toString() +
                                                  "C",
                                              style: const TextStyle(
                                                fontSize: 15,
// color: selectedDay == today
//     ? Colors.white
//     : myConstants.primaryColor,
                                                color: AppColors.C_90B2F9,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Image.network(
                                              "https://openweathermap.org/img/wn/${oneCallData.hourly[index].weather[0].icon}@4x.png",
                                              fit: BoxFit.cover,
                                              width: 45,
                                            ),
                                            Text(
                                              MyUtils.getDateTime(oneCallData
                                                      .hourly[index].dt)
                                                  .toString()
                                                  .substring(11, 16),
                                              style: TextStyle(
                                                fontSize: 15,
// color: selectedDay == today
//     ? Colors.white
//     : myConstants.primaryColor,
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