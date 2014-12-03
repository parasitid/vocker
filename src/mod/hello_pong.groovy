if ( ! container.env["listen_port"] ){
  container.logger.error("no port specified. exiting prematurely")
  container.exit()
}

PORT = container.env["listen_port"] as Integer

vertx.createHttpServer().requestHandler { req ->
  container.logger.info("received req: ${req}")
  def name = req.params['name']
  req.response.end "hello ${name}"
}.listen(PORT)
