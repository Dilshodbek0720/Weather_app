import 'package:flutter/material.dart';
import 'package:n8_default_project/data/models/main/weather_main_model.dart';
import 'package:n8_default_project/data/models/universal_data.dart';
import 'package:n8_default_project/data/network/api_provider.dart';
import 'package:n8_default_project/ui/home/widgets/weather_product.dart';
import 'package:n8_default_project/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String location = "Samarqand";
  List<String> cities = ["Tashkent", "Payariq"];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Container(
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(onPressed: (){ }, icon: Icon(Icons.search, size: 30,)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon(Icons.location_on, color: Colors.teal,),
                  DropdownButtonHideUnderline(child: DropdownButton(
                     // value: location,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: cities.map((String location) {
                        return DropdownMenuItem(
                            value: location, child: Text(location));
                      }).toList(),
                      onChanged: (String? newValue) {
                      }),)
                ],
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder<UniversalData>(
        future: ApiProvider.getMainWeatherDataByQuery(query: "Tashkent"),
        builder: (BuildContext context, AsyncSnapshot<UniversalData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.error.isEmpty) {
              WeatherMainModel weatherMainModel =
                  snapshot.data!.data as WeatherMainModel;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                    Text(
                      weatherMainModel.dateTime.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: size.width,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Color(0xff90B2F9),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff90B2F9).withOpacity(.5),
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
                              "https://openweathermap.org/img/wn/02d@4x.png",
                              fit: BoxFit.cover,
                              width: 220,
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
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                      (weatherMainModel.mainInMain.temp-273.15).round().toString(),
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xA5E1DFFF)
                                      // foreground: Paint()..shader = linearGradient,
                                    ),
                                  ),
                                ),
                                Text(
                                  'o',
                                  style: TextStyle(
                                    fontSize: 20,
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
                    const SizedBox(height: 40,),
                    Container(
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
                              unit: '',
                              imageUrl: 'assets/images/humidity.png'),
                          WeatherProduct(
                            text: 'Wind Speed',
                            value: (weatherMainModel.mainInMain.tempMax-273.15).round(),
                            unit: 'C',
                            imageUrl: 'assets/images/max-temp.png',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
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
                        Text(
                          "Next 7 days",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff90B2F9)
                          ),
                        )
                    ],),
                    SizedBox(height: 20,),
                    Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 7,
                            itemBuilder: (BuildContext context, int index) {
                              String today = DateTime.now().toString().substring(0, 10);
                              // var selectedDay =
                              // consolidatedWeatherList[index]['applicable_date'];
                              // var futureWeatherName =
                              // consolidatedWeatherList[index]['weather_state_name'];
                              // var weatherUrl =
                              // futureWeatherName.replaceAll(' ', '').toLowerCase();
                              //
                              // var parsedDate = DateTime.parse(
                              //     consolidatedWeatherList[index]['applicable_date']);
                              // var newDate = DateFormat('EEEE')
                              //     .format(parsedDate)
                              //     .substring(0, 3); //formateed date

                              return GestureDetector(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(consolidatedWeatherList: consolidatedWeatherList, selectedId: index, location: location,)));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  margin: const EdgeInsets.only(
                                      right: 20, bottom: 10, top: 10),
                                  width: 80,
                                  decoration: BoxDecoration(
                                      // color: selectedDay == today
                                      //     ? myConstants.primaryColor
                                      //     : Colors.white,
                                    color: Colors.white,
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 1),
                                          blurRadius: 5,
                                          // color: selectedDay == today
                                          //     ? myConstants.primaryColor
                                           color  : Colors.black54.withOpacity(.2),
                                        ),
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        // consolidatedWeatherList[index]['the_temp']
                                      (weatherMainModel.mainInMain.temp-273.15)
                                            .round()
                                            .toString() +
                                            "C",
                                        style: TextStyle(
                                          fontSize: 15,
                                          // color: selectedDay == today
                                          //     ? Colors.white
                                          //     : myConstants.primaryColor,
                                          color: AppColors.C_90B2F9,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Image.network(
                                        "https://openweathermap.org/img/wn/02d@4x.png",
                                        fit: BoxFit.cover,
                                        width: 38,
                                      ),
                                      Text(
                                        "Mon",
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
                            }))
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
