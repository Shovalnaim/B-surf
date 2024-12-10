const admin = require("firebase-admin");
const functions = require("firebase-functions");
const axios = require("axios");

// admin.initializeApp(functions.config().firebase);
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

/**
 * Calculate travel times from a user's location to multiple destinations.
 *
 * @param {number} lat - The latitude of the user's location.
 * @param {number} lng - The longitude of the user's location.
 * @return {Promise<Object>} An object containing travel times to destinations.
 * @throws {Error} If an error occurs during the calculation.
 */
async function calculateTravelTimes(lat, lng) {
  try {
    // Get user's origin coordinates from the function parameters
    const userCoords = `${lat},${lng}`;

    // Fetch destination locations from Firestore
    const locationsSnapshot = await admin.firestore().
        collection("locations").get();
    const destinationData = locationsSnapshot.docs.map((doc) => {
      const data = doc.data();
      const geopoint = data.cords;
      return {
        name: data.name, // Retrieve the name
        coords: `${geopoint.latitude},${geopoint.longitude}`,
      };
    });

    console.log(
        "Original Destination Locations:", JSON.stringify(destinationData));


    // Modify the user's location to have a name and coords
    const userLocation = {
      name: "currentUser", // You can choose any name you
      // prefer, e.g., 'currentUser'
      coords: userCoords,
    };

    // Add the user's location to the beginning of the locations array
    const locations = [userLocation, ...destinationData];

    console.log("Updated Destination Locations:", JSON.stringify(locations));

    // Prepare API request for MapQuest Distance Matrix API
    const apiKey = "API_KEY";
    const apiUrl = "https://www.mapquestapi.com/directions/v2/routematrix";

    const requestBody = {
      locations: locations.map((item) => item.coords),
      // Use the modified locations array
      options: {
        allToAll: false,
        // Set to false to calculate travel times
        // from one source to all destinations
        unit: "m", // You can specify the unit you want here (meters)
      },
      key: apiKey,
    };

    // Make API request to MapQuest Distance Matrix API
    const response = await axios.post(apiUrl, requestBody);

    if (response.data.info.statuscode === 0) {
      const travelTimes = response.data.time.map((duration, index) => {
        const minutes = Math.round(duration / 60);
        // Convert duration to rounded minutes
        return {
          duration: duration,
          name: locations[index].name, // Use the modified locations array
          durationMinutes: minutes,
        };
      });

      // Return the extracted travel times with names and duration in minutes
      return {travelTimes};
    } else {
      console.error("MapQuest API Error:", response.data.info.statuscode);
      throw new Error("An error occurred while fetching data from the API");
    }
  } catch (error) {
    console.error("Error:", error);
    throw new Error("An error occurred");
  }
}

/**
 * Find spots with strong winds for specified dates and coordinates.
 *
 * @param {Object} request - The HTTP request object.
 * @param {Object} response - The HTTP response object.
 * @return {void}
 * @throws {Error} If an error occurs during the process.
 */
exports.findSpotsWind = functions.https.onRequest(async (request, response) => {
  try {
    const requestedUid = request.query.uid;
    if (!requestedUid) {
      response.status(403).send("Unauthorized");
      return;
    }
    // Check if the requested UID exists in Firebase Authentication
    const userRecord = await admin.auth().getUser(requestedUid);
    if (!userRecord) {
      response.status(403).send("Unauthorized");
      return;
    }
    const value = request.query.value || null;
    const latitude = request.query.latitude || "unknown";
    const longitude = request.query.longitude || "unknown";

    let totalMinutes;
    if (value) {
      const [hours, minutes] = value.split(":").map(Number);
      totalMinutes = (hours * 60) + minutes;
    }

    const today = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);
    const dayAfterTomorrow = new Date(tomorrow);
    dayAfterTomorrow.setDate(dayAfterTomorrow.getDate() + 1);

    const formattedToday = today.toISOString().substr(0, 10);
    const formattedTomorrow = tomorrow.toISOString().substr(0, 10);
    const formattedDayAfterTomorrow = dayAfterTomorrow.
        toISOString().substr(0, 10);

    // Create an object to save the result from calculateTravelTimes
    let travelTimesData;
    try {
      travelTimesData = await calculateTravelTimes(latitude, longitude);
      console.log("Travel Times:", travelTimesData);
    } catch (error) {
      console.error("Error fetching travel times:", error.message);
    }
    console.log("Travel Times Result:", JSON.stringify(travelTimesData));

    const todayLines = await getStrongWindsData(
        formattedToday, "today", travelTimesData);
    const tomorrowLines = await getStrongWindsData(
        formattedTomorrow, "tomorrow", travelTimesData);
    const dayAfterTomorrowLines = await getStrongWindsData(
        formattedDayAfterTomorrow, "the day after", travelTimesData);

    const allLines = [...todayLines, ...tomorrowLines,
      ...dayAfterTomorrowLines];

    console.log("all lines:", JSON.stringify(allLines));

    // Filter the lines based on travel times
    const filteredLines = filterLinesByTravelTimes(
        allLines, travelTimesData, totalMinutes);

    console.log("filtered lines:", JSON.stringify(filteredLines));

    response.send(JSON.stringify(filteredLines));
  } catch (error) {
    console.error("Error:", error);
    response.status(500).send("An error occurred");
  }
});

/**
 * Filter lines based on travel times.
 *
 * @param {string[]} lines - Array of lines describing strong wind spots.
 * @param {Object} travelTimesData - Travel times data object.
 * @param {number} totalMinutes - Total travel time in minutes.
 * @return {string[]} Filtered array of lines.
 */
function filterLinesByTravelTimes(lines, travelTimesData, totalMinutes) {
  // Assuming travelTimesData is an object with a 'travelTimes' property
  const travelTimesArray = travelTimesData.travelTimes;
  console.log("travelTimesArray:", JSON.stringify(travelTimesArray));

  // Filter the lines based on the totalMinutes
  return lines.filter((line) => {
    // Extract spot name from the line
    const spotName = line.split(" at ")[1];
    console.log("spotName:", spotName);

    // Find the corresponding travel time for the spot
    const spotTravelTime = travelTimesArray.find(
        (data) => data.name === spotName);
    console.log("spotTravelTime:", JSON.stringify(spotTravelTime));

    // Check if the spotTravelTime is less than or equal to the totalMinutes
    return spotTravelTime && spotTravelTime.durationMinutes <= totalMinutes;
  });
}

/**
 * Retrieve data about spots with strong winds for a given date and location.
 *
 * @param {string} date - The date for which to retrieve wind data.
 * @param {string} dayLabel -
 * A label indicating the day (e.g., 'today', 'tomorrow').
 * @param {Object} travelTimesData -
 * Data related to travel times, used to filter or retrieve wind spots.
 * @return {Promise<string[]>} An array of lines describing strong wind spots.
 * @throws {Error} If there is an error while retrieving the data.
 */
async function getStrongWindsData(date, dayLabel, travelTimesData) {
  const response = await getStrongWinds(date, travelTimesData);
  const spotsWithStrongWindsArray = response.spotsWithStrongWinds;

  const lines = [];

  spotsWithStrongWindsArray.forEach((spot) => {
    const location = spot.name;
    const windStartTime = new Date(spot.windStartTime);

    // Adjust the wind start time based on the dayLabel
    if (dayLabel === "tomorrow") {
      windStartTime.setDate(windStartTime.getDate() + 1);
    } else if (dayLabel === "the day after tomorrow") {
      windStartTime.setDate(windStartTime.getDate() + 2);
    }

    windStartTime.setHours(windStartTime.getHours() + 3);
    const formattedWindStartTime = windStartTime.toISOString().substr(11, 5);

    lines.push(`Wind ${dayLabel} at ${location} at ${formattedWindStartTime}`);
  });

  return lines;
}

/**
 * Get spots with strong winds.
 *
 * @param {string} date - The date for which to retrieve data (optional).
 * @param {Object} travelTimesData - Travel times data object.
 * @return {Promise<Object>} An object containing spots with strong winds.
 * @throws {Error} If an error occurs during the process.
 */
async function getStrongWinds(date, travelTimesData) {
  try {
    const locationsRef = db.collection("locations");
    const locationsSnapshot = await locationsRef.get();
    const spotsWithStrongWinds = {};

    const promises = locationsSnapshot.docs.map(async (doc) => {
      const locationData = doc.data();
      const coords = locationData.cords;

      const latitude = parseFloat(coords.latitude);
      const longitude = parseFloat(coords.longitude);

      const currentDate = new Date();
      const formattedDate = date || currentDate.toISOString().substr(0, 10);

      const response = await axios.get(`https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&hourly=windspeed_10m&current_weather=true&windspeed_unit=kn&start_date=${formattedDate}&end_date=${formattedDate}`);

      const hourlyData = response.data.hourly;

      let relevantHourlyData;
      let relevantWindspeedData;

      if (formattedDate === currentDate.toISOString().substr(0, 10)) {
        const currentHour = currentDate.getUTCHours();
        let startIndex = Math.max(currentHour, 5);
        if (travelTimesData) {
          const spotName = locationData.name;
          const durationMinutes = getDurationMinutesForSpot(
              spotName, travelTimesData);
          if (durationMinutes) {
            const additionalStartIndex = Math.ceil(durationMinutes / 60);
            startIndex += additionalStartIndex;
            console.log(
                "Adding ${additionalStartIndex}" +
                " to startIndex for ${spotName}");
          }
        }
        const endIndex = Math.max(16 - startIndex, 0);
        relevantHourlyData = hourlyData.time.slice(
            startIndex, startIndex + endIndex);
        relevantWindspeedData = hourlyData.windspeed_10m.slice(
            startIndex, startIndex + endIndex);
      } else {
        relevantHourlyData = hourlyData.time.slice(5, 5 + 11); // 5:00-15:00utc
        relevantWindspeedData = hourlyData.windspeed_10m.slice(5, 5 + 11);
      }

      const earliestIndex = relevantWindspeedData.findIndex((
          speed) => speed >= 11); // speed in knots

      if (earliestIndex !== -1) {
        const earliestTime = new Date(relevantHourlyData[earliestIndex]);
        if (!spotsWithStrongWinds[locationData.name] ||
          earliestTime < spotsWithStrongWinds[locationData.name]) {
          spotsWithStrongWinds[locationData.name] = earliestTime;
        }
      }
    });

    await Promise.all(promises);

    const spotsWithStrongWindsArray = Object.keys(
        spotsWithStrongWinds).map((name) => ({
      name,
      windStartTime: spotsWithStrongWinds[name].toISOString(),
    }));

    console.log(
        "Spots with strong winds:", JSON.stringify(spotsWithStrongWindsArray));

    return {
      spotsWithStrongWinds: spotsWithStrongWindsArray,
    };
  } catch (error) {
    console.error("Error:", error);
    throw new Error("An error occurred");
  }
}

/**
 * Get the duration in minutes for a specific spot from travelTimesData.
 *
 * @param {string} spotName - The name of the spot.
 * @param {Object} travelTimesData - Travel times data object.
 * @return {number|null} Duration in minutes or null if not found.
 */
function getDurationMinutesForSpot(spotName, travelTimesData) {
  console.log("before travel array:", JSON.stringify(travelTimesData));

  // Assuming travelTimesData is an object with a 'travelTimes' property
  const travelTimesArray = travelTimesData.travelTimes;

  console.log("after travel array:", JSON.stringify(travelTimesArray));

  const spotData = travelTimesArray.find((data) => data.name === spotName);
  return spotData ? spotData.durationMinutes : null;
}


/**
 * Scheduled function to send alerts to users based on
   strong wind forecasts at their favorite spots.
 * @param {Object} context - The context object for the scheduled execution.
 * @return {Promise<null>} A promise that resolves to null after processing.
 * @throws {Error} If an error occurs during the process.
 */
exports.scheduledAlerts = functions.pubsub.schedule("0 7 * * *").
    timeZone("Asia/Jerusalem")
    .onRun(async (context) => {
      try {
        const response = await getStrongWinds();
        const spotsWithStrongWindsArray = response.spotsWithStrongWinds;
        console.log(
            "Response from getStrongWinds:",
            JSON.stringify(spotsWithStrongWindsArray));

        const usersRef = db.collection("users");
        const usersSnapshot = await usersRef.get();

        const promises = usersSnapshot.docs.map(async (doc) => {
          const userData = doc.data();
          if (userData.favoriteSpot && spotsWithStrongWindsArray.some((
              spot) => spot.name === userData.favoriteSpot)) {
            const userDeviceToken =
              userData.deviceToken; // Assuming you have a device token field
            if (userDeviceToken) {
              const windStartTime = spotsWithStrongWindsArray.find(
                  (spot) => spot.name === userData.favoriteSpot).windStartTime;

              const modifiedWindStartTime = new Date(windStartTime);
              modifiedWindStartTime.setHours(
                  modifiedWindStartTime.getHours() + 3);
              const formattedWindStartTime =
                modifiedWindStartTime.toISOString().substr(11, 5);

              const message = {
                token: userDeviceToken,
                notification: {
                  title: "KiteSurf Winds Alert",
                  body: `Wake up! winds at your favorite spot are expected
                    at ${formattedWindStartTime}.`,
                },
              };

              await fcm.send(message);
            }
          }
        });

        await Promise.all(promises);

        return null;
      } catch (error) {
        console.error("Error:", error);
        return null;
      }
    });
