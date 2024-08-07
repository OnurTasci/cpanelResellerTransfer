#!/usr/local/cpanel/3rdparty/bin/perl
use strict;
use warnings;

use JSON;

use Cpanel::Form();
my %FORM = Cpanel::Form::parseform();


my $server_host =  %FORM{'server_host'};
my $server_port =  %FORM{'server_port'};
my $server_username =  %FORM{'server_username'};
my $server_password =  %FORM{'server_password'};
my $server_ssl = %FORM{'server_ssl'};
my $host = %FORM{'host'};

#POST
use LWP::UserAgent;
use HTTP::Request::Common;
my $ua = LWP::UserAgent->new();
my $request = GET "http$server_ssl://$server_host:$server_port/json-api/passwd?api.version=1&user=$host&password=$server_password&enabledigest=1";

$request->authorization_basic($server_username,$server_password);

my $response = $ua->request($request);

my $json = new JSON;
my $data = $json->allow_nonref->utf8->relaxed->escape_slash->loose->allow_singlequote->allow_barekey->decode($response->content);

my $op = JSON -> new -> utf8 -> pretty(1);
my $json = $op -> encode($data);
print $json;

1;