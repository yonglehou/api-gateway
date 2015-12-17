package TestHelper;
use strict;
use Exporter;
use File::Basename;

our @ISA= qw( Exporter );

# these are exported by default.
our @EXPORT = qw( create_configured_locations create_http_config );

sub create_configured_locations {
    my ($filename) = @_;
    mkdir(dirname($filename));
    open(my $configured_locations, '>', $filename) || die "Couldn't open filename $filename!";
    print $configured_locations qq{
      local url_routes = {}
      url_routes['test'] = "test"
      return url_routes
    };
    close $configured_locations;
}

sub create_http_config {
    my ($pwd, $backend) = @_;
    return qq{
  lua_package_path '${pwd}/t/lua/?.lua;${pwd}/src/?.lua;/usr/local/openresty/lualib/?.lua;;';
  upstream test {
    server ${backend};
  }
};

}

1;
