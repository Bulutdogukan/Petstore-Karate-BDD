function fn() {
  var config = {
    baseUrl: 'https://petstore.swagger.io/v2'
  };

  // Enable full request/response logging
  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);

  // Set connection and read timeouts (milliseconds)
  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 15000);

  return config;
}
