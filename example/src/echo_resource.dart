part of restlib.example;

IOResource ioAuthenticatedEchoResource(final Route route) =>
    new IOResource.conneg(
        new Resource.authorizingResource(
            new _EchoResource(route), [new _EchoAuthorizer()]),
        (_) => new Option(parseString), 
        new ResponseWriterProvider.alwaysProvides(new ResponseWriter.string(MediaRange.TEXT_PLAIN)));

IOResource ioEchoResource(final Route route) =>
    new IOResource.conneg(
        new _EchoResource(route), 
        (_) => new Option(parseString), 
        new ResponseWriterProvider.alwaysProvides(new ResponseWriter.string(MediaRange.TEXT_PLAIN)));

class _EchoResourceDelegate extends UniformResourceDelegate<String> {
  final bool requireETagForUpdate = false;
  final bool requireIfUnmodifiedSinceForUpdate = false;
  final Route route;
  
  _EchoResourceDelegate(this.route);
  
  Future<Response> get(final Request request) => 
      new Future.value(
          new Response(
              Status.SUCCESS_OK,
              entity : request));
  
  Future<Response> post(final Request<String> request) => 
      new Future.value(
          new Response(
              Status.SUCCESS_OK,
              entity : request));
}

class _EchoResource
    extends Object
    with ForwardingResource<String> {
  final Resource<String> delegate;
  
  _EchoResource(final Route route):
    delegate = new Resource.uniform(new _EchoResourceDelegate(route));
}

class _EchoAuthorizer 
    extends Object 
    with ForwardingAuthorizer {
  static Future<bool> authenticateUserAndPwd(final String user, final String pwd) => 
      new Future.value(user == "test" && pwd == "test");
  
  final Authorizer delegate = new Authorizer.basicAuth("testrealm", authenticateUserAndPwd);
  
  Future<bool> authenticate(final Request request) =>
      (request.method != Method.GET) ? delegate.authenticate(request) : new Future.value(true);
}