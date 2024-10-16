# Weather App 🌤️

A Flutter-based weather application that fetches and displays real-time weather data for any city. It uses the OpenWeather API to show current weather conditions, including temperature, wind speed, humidity, and pressure. Additionally, the app offers hourly forecasts, user-friendly UI, and the ability to search for weather in different cities.

## Features

- 🌍 Fetches weather data for any city entered by the user
- 📍 Default city set as *Aurangabad*
- 🌡️ Displays temperature in Celsius
- 🕒 Shows hourly weather forecast
- 📊 Additional weather information (humidity, wind speed, pressure)
- 🔄 Refresh functionality to get updated weather data
- 🖼️ Beautiful UI with weather icons based on conditions
- ✨ Hourly forecast slider for better visibility

## Demo



https://github.com/user-attachments/assets/5ba2d406-f60b-4ddb-ac4a-8b8e1142b497



## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Siddiqui145/Weather_App_Flutter.git
   cd Weather_App_Flutter
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set up the OpenWeather API key**:
   - Get your API key from [OpenWeather](https://openweathermap.org/api).
   - Add your API key in the `secrets.dart` file:
     ```dart
     const String OpenWeatherAPIkey = 'your_api_key_here';
     ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## Usage

- Launch the app, and you will see the default weather for *Aurangabad*.
- Enter a city name in the search box to get the weather data for that location.
- The app will display the city name along with the current weather conditions.

## File Structure

```
lib/
├── main.dart                   # Entry point of the app
├── weather_screen.dart          # Main screen that handles weather data and UI
├── hourly_forecast.dart         # Displays hourly forecast as a slider
├── additional_info_item.dart    # Shows extra weather details (humidity, wind speed, etc.)
├── secrets.dart                 # Store the OpenWeather API key
```

## Dependencies

- [Flutter](https://flutter.dev) 
- [http](https://pub.dev/packages/http) - For making API requests
- [intl](https://pub.dev/packages/intl) - For handling date and time formats
- [weather](https://pub.dev/packages/weather) - OpenWeather package to fetch weather data

## API Reference

This app uses the [OpenWeather API](https://openweathermap.org/api) to retrieve weather data. Please refer to their documentation for detailed usage information.

## Contributing

1. Fork the repository.
2. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature/your-feature
   ```
3. Commit your changes:
   ```bash
   git commit -m 'Add some feature'
   ```
4. Push to your branch:
   ```bash
   git push origin feature/your-feature
   ```
5. Create a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

