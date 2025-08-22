# OpenWeather Proxy API

This project is a proxy REST API for OpenWeather, built with Node.js v22.18.0. It exposes four endpoints to fetch weather and air pollution data using the OpenWeather API.

## Stack

- **Node.js** v22.18.0
- **Express**
- **Axios**
- **Swagger UI**
- **js-yaml**
- **dotenv**

## Endpoints

| Endpoint                      | Method | Description                        |
|-------------------------------|--------|------------------------------------|
| `/weather/current`            | GET    | Current weather by city            |
| `/weather/forecast`           | GET    | 5-day forecast (3h intervals)      |
| `/weather/coordinates`        | GET    | Current weather by coordinates     |
| `/weather/air_pollution`      | GET    | Air quality by coordinates         |

## Setup

1. **Clone the repository**

   ```
   git clone <repo-url>
   cd teste-devops
   ```

2. **Install dependencies**

   ```
   npm install
   ```

3. **Set your OpenWeather API key**

   Create a `.env` file in the project root:

   ```
   OPENWEATHER_API_KEY=your_openweather_api_key
   PORT=3000
   ```

4. **Run the server**

   ```
   node run dev
   ```

5. **Access Swagger documentation**

   Open [http://localhost:3000/docs](http://localhost:3000/docs) in your browser.

##