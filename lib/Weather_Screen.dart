import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';
import 'AdditionalInfoItem.dart';
import 'Hourly_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:weather/weather.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherFactory _wf = WeatherFactory(OpenWeatherAPIkey);
  Weather? _weather;
  String _city = "Aurangabad";

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  // Fetch weather data based on provided city
  Future<void> _fetchWeather() async {
    try {
      Weather weather = await _wf.currentWeatherByCityName(_city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $errorMessage')),
    );
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    final res = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?lat=${_weather?.latitude}&lon=${_weather?.longitude}&APPID=$OpenWeatherAPIkey"),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getCurrentWeather(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("No data available"));
        }

        final data = snapshot.data!;
        // Convert temperature from Kelvin to Celsius
        final currentTemp = data['list'][0]['main']['temp'] - 273.15;
        final currentSky = data['list'][0]['weather'][0]['main'];
        final humidity = data['list'][0]['main']['humidity'];
        final pressure = data['list'][0]['main']['pressure'];
        final speed = data['list'][0]['wind']['speed'];

        return Padding(
          padding: const EdgeInsets.all(0),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Weather App'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _fetchWeather();
                    });
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Enter city name",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  _fetchWeather();
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            _city = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        if (_weather != null)
                          Text(
                            "Weather for ${_weather?.areaName ?? _city}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${currentTemp.toStringAsFixed(2)} °C",
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 60,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  currentSky,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Hourly Forecast",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 39,
                            itemBuilder: (context, index) {
                              final hourlyForecast = data['list'][index + 1];
                              final hourlySky =
                                  data['list'][index + 1]['weather'][0]['main'];
                              final time =
                                  DateTime.parse(hourlyForecast['dt_txt']);
                              final hourlyTemp =
                                  hourlyForecast['main']['temp'] - 273.15;
                              return HourlyForecast(
                                  time: DateFormat.Hm().format(time),
                                  icon: hourlySky == "Clouds" ||
                                          hourlySky == "Rain"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  temp: hourlyTemp.toStringAsFixed(2) + " °C");
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Additional Information",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AdditionalInfoItem(
                                icon: Icons.water_drop,
                                label: "Humidity",
                                value: humidity.toString()),
                            AdditionalInfoItem(
                              icon: Icons.air,
                              label: "Wind Speed",
                              value: speed.toString(),
                            ),
                            AdditionalInfoItem(
                              icon: Icons.umbrella,
                              label: "Pressure",
                              value: pressure.toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
