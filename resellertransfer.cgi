#!/usr/local/cpanel/3rdparty/bin/perl
# SCRIPT: resellertransfer
# AUTHOR: Onur TAŞCI <my@onurtasci.com>
# PURPOSE: WHM Reseller Transfer Tools
# CREATED 19/5/2021

#Configuration
my $self  = 'resellertransfer/resellertransfer.cgi';


##############################
use strict;
use lib '/usr/local/cpanel/';

use Whostmgr::ACLS();
Whostmgr::ACLS::init_acls();

use warnings;
use Cpanel::Template();
use Cpanel::Form();

my %FORM  = Cpanel::Form::parseform();

require 'whostmgr/docroot/cgi/resellertransfer/functions.pl';

# Check privileges
if ( !Whostmgr::ACLS::hasroot() ) {
    print "Content-type: text/html\n\n";
    resellertransferCustomHeader( 'Reseller Transfer Tools', $self );
    require 'whostmgr/docroot/cgi/resellertransfer/page/hasroot.pl';
    resellertransferFooter();
    exit;
}

if(defined $FORM{'action'}){
my $cgiaction = $FORM{'action'};
print "Cache-Control: no-cache, must-revalidate\n";
print "Content-type: text/html; charset=utf-8\n\n";
my $ajaxFile = "/usr/local/cpanel/whostmgr/docroot/cgi/resellertransfer/ajax/$cgiaction.pl";
if (-e $ajaxFile) {
    require $ajaxFile;
} else {
    print '<div class="alert alert-danger" role="alert">File not found in ajax folder!</div>';
}
exit;
}

print "Content-type: text/html; charset=utf-8\n\n";
resellertransferCustomHeader( 'Reseller Transfer Tools', $self);
require 'whostmgr/docroot/cgi/resellertransfer/page/home.pl';
resellertransferAjaxJs();
defFooter();
exit;
