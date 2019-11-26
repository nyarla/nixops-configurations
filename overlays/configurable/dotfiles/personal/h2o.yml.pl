#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(state);

use YAML::Tiny;

sub path {
  my $PREFIX = '/data';
  return join q{/}, $PREFIX, @_;
}

sub log_format {
  state $LOG ||= [
    time        => '%{%Y-%m-%dT%H:%M:%S}t.%{msec_frac}t',
    remote_addr => '%h',
    request     => '%r',
    status      => '%s',
    size        => '%b',
    referrer    => '%{referrer}i',
    useragent   => '%{user-agent}i',
    vhost       => '%{host}i',
  ];

  state $format ||= do {
    my @out = ();

    while ( my ( $key, $val ) = splice $LOG->@*, 0, 2 ) {
      push @out, (join q{:}, ($key, $val));
    }

    my $out = join qq{\t}, @out;

    $out;
  };

  return $format;
}

sub access_log {
  my ( $proto, $filename ) = @_;
  return +{
    path    => path('log', $proto, "${filename}.log"),
    format  => log_format,
  }
}

sub host {
  my ( $proto, $host, $paths, $certificate ) = @_;
  
  my $port    = ( $proto eq 'https' ) ? 443 : 80 ;
  my $config  = +{
    'access-log'    => access_log($proto, $host),
    'http2-casper'  => 'ON',
    'listen'        => +{
      port  => $port,
    }
  };

  if ( $proto eq 'https' ) {
    $config->{'listen'}->{'ssl'} = +{
      'certificate-file'  => path('certificates', $certificate, 'fullchain.pem'),
      'key-file'          => path('certificates', $certificate, 'key.pem'),
    };
  }

  $config->{'paths'} = $paths;

  return ("${host}:${port}" => $config);
}

sub website {
  my $domain = shift;
  return +{
    '/' => {
      'file.dir'    => path('dist', $domain),
      'file.index'  => [ 'index.html' ],
      'error-doc'   => [
        { status => 404, url => '/404.html' },
      ], 
    }, 
  };
}

sub redirect {
  my $path = shift;
  return +{
    '/' => {
      'redirect' => { status => 303, url => "https://the.kalaclista.com${path}" },
    } 
  }
}

sub config {
  my @paths = ();

  # WebSites
  # ========

  # the.kalaclista.com:443
  # ----------------------
  push @paths, host( https => 'the.kalaclista.com' => website('the.kalaclista.com') => 'kalaclista.com' );

  # kalaclista.com:80
  # -----------------
  push @paths, host( http => 'kalaclista.com' => website('kalaclista.com') );

  # analysis.nyarla.net:443
  # -----------------------
  push @paths, host( https => 'analysis.nyarla.net' => +{
    '/' => {
      'proxy.reverse.url' => 'http://127.0.0.1:10001',
    }
  } => 'nyarla.net' );

  # analysis.nyarla.net:80
  # ----------------------
  push @paths, host( http => 'analysis.nyarla.net' => +{
    '/' => {
      'redirect' => { status => 303, url => "https://analysis.nyarla.net/" },
    },
  } );

  # Redirections
  # ============
  
  # HTTP
  # ----
  my @http = (
    [ 'the.kalaclista.com'  => '/'            ],
    [ 'nyarla.net'          => '/nyarla/'     ],
    [ 'favs.nyarla.net'     => '/bookmarks/'  ],
    [ 'let.nyarla.net'      => '/echos/'      ],
    [ 'life.nyarla.net'     => '/posts/'      ],
    [ 'tech.nyarla.net'     => '/posts/'      ],
    [ 'the.nyarla.net'      => '/'            ],
    [ 'the.nyadgets.net'    => '/'            ],
  );

  for my $rule ( @http ) {
    push @paths, host( http => $rule->[0] => redirect($rule->[1]) );
  }

  # HTTPS
  # -----
  my @https = (
    [ 'kalaclista.com'  => 'kalaclista.com'   => '/'            ],
    [ 'nyarla.net'      => 'nyarla.net'       => '/nyarla/'     ],
    [ 'nyarla.net'      => 'favs.nyarla.net'  => '/bookmarks/'  ],
    [ 'nyarla.net'      => 'let.nyarla.net'   => '/echos/'      ],
    [ 'nyarla.net'      => 'life.nyarla.net'  => '/posts/'      ],
    [ 'nyarla.net'      => 'tech.nyarla.net'  => '/posts/'      ],
    [ 'nyarla.net'      => 'the.nyarla.net'   => '/'            ],
    [ 'nyadgets.net'    => 'the.nyadgets.net' => '/'            ],
  );

  for my $rule ( @https ) {
    push @paths, host( https => $rule->[1] => redirect($rule->[2]) => $rule->[0] );
  }

  # Configuration
  # =============
  
  my $config = +{
    'pid-file'    => '/app/h2o/h2o.pid',
    'user'        => 'www-data',

    'access-log'  => access_log( http => 'access' ),
    'error-log'   => path(qw( log error errors.log )),

    'http2-reprioritize-blocking-assets'  => 'ON',
    'ssl-session-resumption'              => { mode => 'all' },

    'hosts'       => { @paths },
  };

  return $config;
}

sub main {
  print YAML::Tiny::Dump(config);
}

main;
