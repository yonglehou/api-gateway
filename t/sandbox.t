# vim:set ft= ts=4 sw=4 et:
use File::Basename;
use HTTP::Daemon;
use HTTP::Status;
use Test::Nginx::Socket;
use IO::Socket::Timeout;
use Parallel::ForkManager;
use HTTP::Response;
use Cwd qw(cwd);

sub response {
    my ($code, $content) = @_;
    my $resp = HTTP::Response->new();
    $resp->code($code);
    $resp->content($content);
    return $resp;
}

my $pm = new Parallel::ForkManager(1);
my $httpd = HTTP::Daemon->new( Timeout => 2 ) || die;
my $pid = $pm->start;
if ($pid == 0) {
    if (my $c = $httpd->accept) {
      while (my $r = $c->get_request) {
          if ($r->method eq 'GET' and $r->uri->path =~ "^/x-forwarded-for") {
              $c->send_response(response(200, $r->header('X-Forwarded-For') . "\n"));
          } else {
              $c->send_error(RC_FORBIDDEN)
          }
      }
      $c->close;
      undef($c);
  }

  $pm->finish;
}

END {
    $pm->wait_all_children;
}

repeat_each(1);
plan tests => repeat_each() * (2 * blocks());

our $pwd = cwd();
my $port = $httpd->sockport;

my $filename = $pwd . '/t/lua/configured_locations.lua';
mkdir(dirname($filename));
open(my $configured_locations, '>', $filename) || die "Couldn't open filename $filename!";
print $configured_locations qq{
  local url_routes = {}
  url_routes['test'] = "test"
  return url_routes
};
close $configured_locations;

our $HttpConfig = qq{
  lua_package_path '${pwd}/t/lua/?.lua;${pwd}/src/?.lua;/usr/local/openresty/lualib/?.lua;;';
  upstream test {
    server 127.0.0.1:${port};
  }
};


no_shuffle();
run_tests();

__DATA__

=== TEST 1: sanity
--- http_config eval: $::HttpConfig
--- config
    location /echo {
        echo_before_body hello;
        echo world;
    }
--- request
    GET /echo
--- response_body
hello
world
--- error_code: 200

=== TEST 2: X-Forwarded-For
--- http_config eval: $::HttpConfig
--- config
    location /test {
    proxy_pass_request_headers off;
    content_by_lua '
      local router = require("nginx/router")
      return router.route()
      ';
    }
    location @service {
      set_by_lua $upstream '
        local upstream = require("upstream")
        return upstream.find(ngx.var.request_uri);
      ';

      set_by_lua $stripped_uri '
        local util = require("util")
        local stripped_uri = util.get_rest_after_url_prefix(ngx.var.request_uri)
        return util.strip_leading_slash(stripped_uri)
      ';

      access_by_lua '
        if ngx.var.upstream == "__not_found" then
          ngx.status = ngx.HTTP_NOT_FOUND
          ngx.say("Invalid service resource")
        else
          return
        end';

      proxy_pass http://$upstream/$stripped_uri;
    }
--- more_headers
Fastly-Client-IP: 10.10.10.10
--- request
    GET /test/x-forwarded-for
--- response_body
10.10.10.10
--- error_code: 200
