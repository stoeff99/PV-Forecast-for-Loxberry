#!/usr/bin/perl

# Copyright 2016 Michael Schlenstedt, michael@loxberry.de
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##########################################################################
# Modules
##########################################################################

use CGI::Carp qw(fatalsToBrowser);
use CGI qw/:standard/;
use Config::Simple;
use File::HomeDir;
use Cwd 'abs_path';
use warnings;
use strict;
no strict "refs";    # we need it for template system

##########################################################################
# Variables
##########################################################################

our $cfg;
our $pcfg;
our $phrase;
our $namef;
our $value;
our %query;
our $lang;
our $template_title;
our $help;
our @help;
our $helptext;
our $helplink;
our $installfolder;
our $languagefile;
our $version;
our $error;
our $saveformdata = 0;
our $output;
our $message;
our $nexturl;
our $do = "form";
my $home = File::HomeDir->my_home;
our $psubfolder;
our $pname;
our $languagefileplugin;
our $phraseplugin;
our $header_already_sent = 0;

our $system_active_1;
our $system_active_1_selected;
our $lon_1;
our $lat_1;
our $dec_1;
our $az_1;
our $kwp_1;
our $damp_1;
our $reserve_1;

our $system_active_2;
our $system_active_2_selected;
our $lon_2;
our $lat_2;
our $dec_2;
our $az_2;
our $kwp_2;
our $damp_2;
our $reserve_2;

our $system_active_3;
our $system_active_3_selected;
our $lon_3;
our $lat_3;
our $dec_3;
our $az_3;
our $kwp_3;
our $damp_3;
our $reserve_3;

our $miniserver;
our $miniserver_select;
our $udpport;
our $cron;
our $cron_select;

our $today_tomorrow_sum_selected;
our $today_tomorrow_sum;
our $today_hour_selected;
our $today_hour;
our $tomorrow_hour_selected;
our $tomorrow_hour;
our $today_3_6;
our $today_3_6_selected;
our $today_morn_after;
our $today_morn_after_selected;
our $kw;
our $kw_selected;
our $today_tomorrow_sep;
our $today_tomorrow_sep_selected;

our $debug;
our $debug_selected;

our $api_key;

##########################################################################
# Read Settings
##########################################################################

# Version of this script
$version = "0.0.8";

# Figure out in which subfolder we are installed
$psubfolder = abs_path($0);
$psubfolder =~ s/(.*)\/(.*)\/(.*)$/$2/g;

#Read Config
$cfg           = new Config::Simple("$home/config/system/general.cfg");
$installfolder = $cfg->param("BASE.INSTALLFOLDER");
$lang          = $cfg->param("BASE.LANG");
$pcfg = new Config::Simple("$installfolder/config/plugins/$psubfolder/pv_forecast.cfg");
$lon_1 = $pcfg->param("FORECAST_1.LON");
$lat_1 = $pcfg->param("FORECAST_1.LAT");
$dec_1     = $pcfg->param("FORECAST_1.DEC");
$az_1      = $pcfg->param("FORECAST_1.AZ");
$kwp_1     = $pcfg->param("FORECAST_1.KWP");
$damp_1    = $pcfg->param("FORECAST_1.DAMP");
$reserve_1 = $pcfg->param("FORECAST_1.RESERVE");
$system_active_1 = $pcfg->param("FORECAST_1.SYSTEM_ACTIVE");

$lon_2 = $pcfg->param("FORECAST_2.LON");
$lat_2 = $pcfg->param("FORECAST_2.LAT");
$dec_2     = $pcfg->param("FORECAST_2.DEC");
$az_2      = $pcfg->param("FORECAST_2.AZ");
$kwp_2     = $pcfg->param("FORECAST_2.KWP");
$damp_2    = $pcfg->param("FORECAST_2.DAMP");
$reserve_2 = $pcfg->param("FORECAST_2.RESERVE");
$system_active_2 = $pcfg->param("FORECAST_2.SYSTEM_ACTIVE");

$lon_3 = $pcfg->param("FORECAST_3.LON");
$lat_3 = $pcfg->param("FORECAST_3.LAT");
$dec_3     = $pcfg->param("FORECAST_3.DEC");
$az_3      = $pcfg->param("FORECAST_3.AZ");
$kwp_3     = $pcfg->param("FORECAST_3.KWP");
$damp_3    = $pcfg->param("FORECAST_3.DAMP");
$reserve_3 = $pcfg->param("FORECAST_3.RESERVE");
$system_active_3 = $pcfg->param("FORECAST_3.SYSTEM_ACTIVE");


$miniserver = $pcfg->param("MINISERVER.MINISERVER");
$udpport = $pcfg->param("MINISERVER.UDPPORT");
$cron = $pcfg->param("CRON.CRON");
$today_tomorrow_sum = $pcfg->param("DATA.TODAY_TOMORROW_SUM");
$today_hour = $pcfg->param("DATA.TODAY_HOUR");
$tomorrow_hour = $pcfg->param("DATA.TOMORROW_HOUR");
$today_3_6 = $pcfg->param("DATA.TODAY_3_6");
$today_tomorrow_sep = $pcfg->param("DATA.TODAY_TOMORROW_SEP");
$today_morn_after = $pcfg->param("DATA.TODAY_MORN_AFTER");
$kw = $pcfg->param("DATA.KW");
$debug = $pcfg->param("DEBUG.DEBUG");
$api_key = $pcfg->param("API_KEY");

#########################################################################
# Parameter
#########################################################################

# Everything from URL
foreach ( split( /&/, $ENV{'QUERY_STRING'} ) ) {
    ( $namef, $value ) = split( /=/, $_, 2 );
    $namef =~ tr/+/ /;
    $namef =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $value =~ tr/+/ /;
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $query{$namef} = $value;
}

# Set parameters coming in - get over post
if ( !$query{'saveformdata'} ) {
    if ( param('saveformdata') ) {
        $saveformdata = quotemeta( param('saveformdata') );
    }
    else { $saveformdata = 0; }
}
else { $saveformdata = quotemeta( $query{'saveformdata'} ); }
if ( !$query{'lang'} ) {
    if   ( param('lang') ) { $lang = quotemeta( param('lang') ); }
    else                   { $lang = "de"; }
}
else { $lang = quotemeta( $query{'lang'} ); }
if ( !$query{'do'} ) {
    if   ( param('do') ) { $do = quotemeta( param('do') ); }
    else                 { $do = "form"; }
}
else { $do = quotemeta( $query{'do'} ); }

# Clean up saveformdata variable
$saveformdata =~ tr/0-1//cd;
$saveformdata = substr( $saveformdata, 0, 1 );

# Init Language
# Clean up lang variable
$lang =~ tr/a-z//cd;
$lang = substr( $lang, 0, 2 );

# If there's no language phrases file for choosed language, use german as default
if ( !-e "$installfolder/templates/system/$lang/language.dat" ) {
    $lang = "de";
}

# Read translations / phrases
$languagefile = "$installfolder/templates/system/$lang/language.dat";
$phrase       = new Config::Simple($languagefile);
$languagefileplugin ="$installfolder/templates/plugins/$psubfolder/$lang/language.dat";
$phraseplugin = new Config::Simple($languagefileplugin);

##########################################################################
# Main program
##########################################################################

if ($saveformdata) {
    &save;
}
elsif ( $do eq "test_udp" ) {
   	&test_udp;
}
else {
    &form;
}
exit;

#####################################################
#
# Subroutines
#
#####################################################

#####################################################
# Form-Sub
#####################################################

sub form {

    # Filter
    #$lon     = quotemeta($lon);

# Miniserver selection dropdown
for (my $i = 1; $i <= $cfg->param('BASE.MINISERVERS');$i++) {
	if ("MINISERVER$i" eq $miniserver) {
		$miniserver_select .= '<option selected value="'.$i.'">'.$cfg->param("MINISERVER$i.NAME")."</option>\n";
	} else {
		$miniserver_select .= '<option value="'.$i.'">'.$cfg->param("MINISERVER$i.NAME")."</option>\n";
	}
}

# Corn selection dropdown
if ($cron eq "1") {
	$cron_select = '<option selected value="1"> 1 Min. !!Nur zu Testzwecken!!</option><option value="30">30 Min. (halbe Stunde)</option><option value="60">60 Min. (volle Stunde)</option>\n';
} elsif ($cron eq "30") {
	$cron_select = '<option value="1">1 Min. !!Nur zu Testzwecken!!</option><option selected value="30">30 Min. (halbe Stunde)</option><option value="60">60 Min. (volle Stunde)</option>\n';
} elsif ($cron eq "60") {
	$cron_select = '<option value="1">1 Min. !!Nur zu Testzwecken!!</option><option value="30">30 Min. (halbe Stunde)</option><option selected value="60">60 Min. (volle Stunde)</option>\n';
} else {
	$cron_select = '<option value="1">1 Min. !!Nur zu Testzwecken!!</option><option value="30">30 Min. (halbe Stunde)</option><option selected value="60">60 Min. (volle Stunde)</option>\n';
}


#Switches

if ($system_active_1 eq "1") {
	$system_active_1_selected = '<option value="0">Aus</option><option value="1" selected>An</option>';
} else {
	$system_active_1_selected = '<option value="0" selected>Aus</option><option value="1">An</option>';
}

if ($system_active_2 eq "1") {
	$system_active_2_selected = '<option value="0">Aus</option><option value="1" selected>An</option>';
} else {
	$system_active_2_selected = '<option value="0" selected>Aus</option><option value="1">An</option>';
}

if ($system_active_3 eq "1") {
	$system_active_3_selected = '<option value="0">Aus</option><option value="1" selected>An</option>';
} else {
	$system_active_3_selected = '<option value="0" selected>Aus</option><option value="1">An</option>';
}



if ($today_tomorrow_sum eq "1") {
	$today_tomorrow_sum_selected = '<option value="0">Aus</option><option value="1" selected>An</option>';
} else {
	$today_tomorrow_sum_selected = '<option value="0" selected>Aus</option><option value="1">An</option>';
}

if ($today_hour eq "1") {
	$today_hour_selected = '<option value="0">Aus</option><option value="1" selected>An</option>';
} else {
	$today_hour_selected = '<option value="0" selected>Aus</option><option value="1">An</option>';
}

if ($tomorrow_hour eq "1") {
	$tomorrow_hour_selected = '<option value="0">Aus</option><option value="1" selected>An</option>';
} else {
	$tomorrow_hour_selected = '<option value="0" selected>Aus</option><option value="1">An</option>';
}

if ($today_3_6 eq "1") {
	$today_3_6_selected = '<option value="0">Aus</option><option value="1" selected>An</option>';
} else {
	$today_3_6_selected = '<option value="0" selected>Aus</option><option value="1">An</option>';
}

if ($today_morn_after eq "1") {
	$today_morn_after_selected = '<option value="0">Aus</option><option value="1" selected>An</option>';
} else {
	$today_morn_after_selected = '<option value="0" selected>Aus</option><option value="1">An</option>';
}

if ($kw eq "1") {
	$kw_selected = '<option value="0">Aus</option><option value="1" selected>An</option>';
} else {
	$kw_selected = '<option value="0" selected>Aus</option><option value="1">An</option>';
}

if ($debug eq "1") {
	$debug_selected = '<option value="0">Aus</option><option value="1" selected>An</option>';
} else {
	$debug_selected = '<option value="0" selected>Aus</option><option value="1">An</option>';
}

if ($today_tomorrow_sep eq "1") {
	$today_tomorrow_sep_selected = '<option value="0">Aus</option><option value="1" selected>An</option>';
} else {
	$today_tomorrow_sep_selected = '<option value="0" selected>Aus</option><option value="1">An</option>';
}

    if ( !$header_already_sent ) { print "Content-Type: text/html\n\n"; }

    $template_title = "PV Forecast";

    # Print Template
    &lbheader;
    open( F,
        "$installfolder/templates/plugins/$psubfolder/$lang/settings.html" )
      || die "Missing template plugins/$psubfolder/$lang/settings.html";
    while (<F>) {
        $_ =~ s/<!--\$(.*?)-->/${$1}/g;
        print $_;
    }
    close(F);
    &footer;
    exit;
}

#####################################################
# Save-Sub
#####################################################

sub save {

	$pname = "pv_forecast";
    # Everything from Forms
    $lon_1     = param('lon_1');
    $lat_1     = param('lat_1');
    $dec_1     = param('dec_1');
    $az_1      = param('az_1');
    $kwp_1     = param('kwp_1');
    $damp_1    = param('damp_1');
    $reserve_1 = param('reserve_1');
	$system_active_1 = param('system_active_1');

	$lon_2     = param('lon_2');
    $lat_2     = param('lat_2');
    $dec_2     = param('dec_2');
    $az_2      = param('az_2');
    $kwp_2     = param('kwp_2');
    $damp_2    = param('damp_2');
    $reserve_2 = param('reserve_2');
	$system_active_2 = param('system_active_2');

	$lon_3     = param('lon_3');
    $lat_3     = param('lat_3');
    $dec_3     = param('dec_3');
    $az_3      = param('az_3');
    $kwp_3     = param('kwp_3');
    $damp_3    = param('damp_3');
    $reserve_3 = param('reserve_3');
	$system_active_3 = param('system_active_3');

    $udpport = param('udpport');
	$miniserver = param('miniserver');
	$cron = param('cron');
	$today_tomorrow_sum = param('today_tomorrow_sum');
	$today_hour = param('today_hour');
	$tomorrow_hour = param('tomorrow_hour');
	$today_3_6 = param('today_3_6');
	$today_morn_after = param('today_morn_after');
	$today_tomorrow_sep = param('today_tomorrow_sep');
	$kw = param('kw');
	$debug = param('debug');
  $api_key = param('api_key');


	if ($system_active_1 ne 1) { $system_active_1 = 0 }
	if ($system_active_2 ne 1) { $system_active_2 = 0 }
	if ($system_active_3 ne 1) { $system_active_3 = 0 }
	if ($today_tomorrow_sum ne 1) { $today_tomorrow_sum = 0 }
	if ($today_hour ne 1) { $today_hour = 0 }
	if ($tomorrow_hour ne 1) { $tomorrow_hour = 0 }
	if ($today_3_6 ne 1) { $today_3_6 = 0 }
	if ($today_tomorrow_sep ne 1) { $today_tomorrow_sep = 0 }
	if ($today_morn_after ne 1) { $today_morn_after = 0 }
	if ($kw ne 1) { $kw = 0 }
	if ($debug ne 1) { $debug = 0 }


    # Filter
    #$lon   = quotemeta($lon);
    #$lat   = quotemeta($lat);

    # Write configuration file(s)
	$pcfg->param( "MINISERVER.MINISERVER", "MINISERVER$miniserver" );
    $pcfg->param( "MINISERVER.UDPPORT", "$udpport" );

    $pcfg->param( "FORECAST_1.LON",       "$lon_1" );
    $pcfg->param( "FORECAST_1.LAT",       "$lat_1" );
    $pcfg->param( "FORECAST_1.DEC",       "$dec_1" );
    $pcfg->param( "FORECAST_1.AZ",        "$az_1" );
    $pcfg->param( "FORECAST_1.KWP",       "$kwp_1" );
    $pcfg->param( "FORECAST_1.DAMP",      "$damp_1" );
    $pcfg->param( "FORECAST_1.RESERVE",   "$reserve_1" );
	$pcfg->param( "FORECAST_1.SYSTEM_ACTIVE",   "$system_active_1" );

	$pcfg->param( "FORECAST_2.LON",       "$lon_2" );
    $pcfg->param( "FORECAST_2.LAT",       "$lat_2" );
    $pcfg->param( "FORECAST_2.DEC",       "$dec_2" );
    $pcfg->param( "FORECAST_2.AZ",        "$az_2" );
    $pcfg->param( "FORECAST_2.KWP",       "$kwp_2" );
    $pcfg->param( "FORECAST_2.DAMP",      "$damp_2" );
    $pcfg->param( "FORECAST_2.RESERVE",   "$reserve_2" );
	$pcfg->param( "FORECAST_2.SYSTEM_ACTIVE",   "$system_active_2" );

	$pcfg->param( "FORECAST_3.LON",       "$lon_3" );
    $pcfg->param( "FORECAST_3.LAT",       "$lat_3" );
    $pcfg->param( "FORECAST_3.DEC",       "$dec_3" );
    $pcfg->param( "FORECAST_3.AZ",        "$az_3" );
    $pcfg->param( "FORECAST_3.KWP",       "$kwp_3" );
    $pcfg->param( "FORECAST_3.DAMP",      "$damp_3" );
    $pcfg->param( "FORECAST_3.RESERVE",   "$reserve_3" );
	$pcfg->param( "FORECAST_3.SYSTEM_ACTIVE",   "$system_active_3" );

	$pcfg->param( "CRON.CRON", "$cron" );

	$pcfg->param( "DATA.TODAY_TOMORROW_SUM", "$today_tomorrow_sum" );
	$pcfg->param( "DATA.TODAY_HOUR", "$today_hour" );
	$pcfg->param( "DATA.TOMORROW_HOUR", "$tomorrow_hour" );
	$pcfg->param( "DATA.TODAY_3_6", "$today_3_6" );
	$pcfg->param( "DATA.TODAY_MORN_AFTER", "$today_morn_after" );
	$pcfg->param( "DATA.TODAY_TOMORROW_SEP", "$today_tomorrow_sep" );
	$pcfg->param( "DATA.KW", "$kw" );
	$pcfg->param( "DEBUG.DEBUG", "$debug" );
  $pcfg->param( "API_KEY", "$api_key");

    $pcfg->save();

	  if ($cron eq "1")
	  {
	    system ("ln -s $installfolder/data/plugins/$psubfolder/reader.sh $installfolder/system/cron/cron.01min/$pname");
	    unlink ("$installfolder/system/cron/cron.30min/$pname");
	    unlink ("$installfolder/system/cron/cron.hourly/$pname");
	  }
	  if ($cron eq "30")
	  {
	    system ("ln -s $installfolder/data/plugins/$psubfolder/reader.sh $installfolder/system/cron/cron.30min/$pname");
	    unlink ("$installfolder/system/cron/cron.01min/$pname");
	    unlink ("$installfolder/system/cron/cron.hourly/$pname");
	  }
	  if ($cron eq "60")
	  {
	    system ("ln -s $installfolder/data/plugins/$psubfolder/reader.sh $installfolder/system/cron/cron.hourly/$pname");
	    unlink ("$installfolder/system/cron/cron.01min/$pname");
	    unlink ("$installfolder/system/cron/cron.30min/$pname");
	  }


    if ( !$header_already_sent ) { print "Content-Type: text/html\n\n"; }

    $template_title = "PV Forecast";
    $message = $phraseplugin->param("TXT0002");
    $nexturl = "./index.cgi?do=form";

    # Print Template
    &lbheader;
    open( F, "$installfolder/templates/system/$lang/success.html" )
      || die "Missing template system/$lang/succses.html";
    while (<F>) {
        $_ =~ s/<!--\$(.*?)-->/${$1}/g;
        print $_;
    }
    close(F);
    &footer;
    exit;

}

#####################################################
# UDP Test
#####################################################

sub test_udp {

	system("$installfolder/data/plugins/$psubfolder/reader.sh &");

		if ( !$header_already_sent ) { print "Content-Type: text/html\n\n"; }
	$template_title = "PV Forecast";
    $message = $phraseplugin->param("TXT0003");
    $nexturl = "./index.cgi?do=form";

	# Print Template
    &lbheader;
    open( F, "$installfolder/templates/system/$lang/success.html" )
      || die "Missing template system/$lang/succses.html";
    while (<F>) {
        $_ =~ s/<!--\$(.*?)-->/${$1}/g;
        print $_;
    }
    close(F);
    &footer;
    exit;
}

#####################################################
# Page-Header-Sub
#####################################################

sub lbheader {

    # Create Help page
    $helplink = "http://www.loxwiki.eu:80/display/LOXBERRY/Miniserverbackup";
    open( F, "$installfolder/templates/plugins/$psubfolder/$lang/help.html" )
      || die "Missing template plugins/$psubfolder/$lang/help.html";
    @help = <F>;
    foreach (@help) {
        s/[\n\r]/ /g;
        $helptext = $helptext . $_;
    }
    close(F);
    open( F, "$installfolder/templates/system/$lang/header.html" )
      || die "Missing template system/$lang/header.html";
    while (<F>) {
        $_ =~ s/<!--\$(.*?)-->/${$1}/g;
        print $_;
    }
    close(F);
}

#####################################################
# Footer
#####################################################

sub footer {
    open( F, "$installfolder/templates/system/$lang/footer.html" )
      || die "Missing template system/$lang/footer.html";
    while (<F>) {
        $_ =~ s/<!--\$(.*?)-->/${$1}/g;
        print $_;
    }
    close(F);
}
