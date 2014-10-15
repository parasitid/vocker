 vertx.createHttpServer().requestHandler { req ->
      req.response.end "hello"
  }.listen(3030)