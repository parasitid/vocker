import static java.util.UUID.randomUUID  

verticle_unique_name = randomUUID()

if ( ! container.env["listen_port"] ){
  container.logger.error("no port specified. exiting prematurely")
  container.exit()
}

PORT = container.env["listen_port"] as Integer

vertx.createHttpServer().requestHandler { req ->
  container.logger.info("received req: ${req}")
  def name = req.params['name']
  req.response.end "hello ${name}"
  vertx.eventBus.publish("name.listener", name )
}.listen(PORT)


vertx.eventBus.registerHandler( "name.listener" ) { message ->
  println "incoming people: $message.body"
}