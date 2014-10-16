if ( ! container.env["isten_port"] ){
  container.logger.error("no port specified. exiting prematurely")
  container.exit()
}

PORT = container.env["listen_port"] as Integer

vertx.createHttpServer().requestHandler { req ->
  container.logger.info("received req: ${req}")
  req.response.end "hello"
}.listen(PORT)