#!/usr/bin/perl -w
#
# Generate services.
#
# $Id: generate-services.pl,v 1.7 2006/10/13 22:08:39 senger Exp $
# Contact: Martin Senger <martin.senger@gmail.com>
# -----------------------------------------------------------

# some command-line options
use Getopt::Std;
use vars qw/ $opt_h $opt_d $opt_v $opt_a $opt_s $opt_b $opt_f $opt_u $opt_F $opt_S $opt_t /;
getopt;

# usage
if (not($opt_u or $opt_f)) {
if ($opt_h or (not $opt_a and @ARGV == 0)) {
    print STDOUT <<'END_OF_USAGE';
Generate Services.
Usage: [-vds] [-b|S|t] authority [service-name] [service-name...]
       [-vds] [-b|S|t] authority
       [-vd]  [-b|S|t]a
       [-fu]

    It also needs to get a location of a local cache (and potentially
    a BioMoby registry endpoint, and an output directory). It takes
    it from the 'moby-service.cfg' configuration file.

    -f ... fill the cache
    -u ... update the cache
    
    -b ... generate base[s] of given service[s]
    -S ... generate implementation and the base of service[s], the
           implementation module has enabled option to read the base
           statically (that is why it is also generated here)
    -t ... update dispatch table of services (a table used by the
	   cgi-bin script and SOAP::Lite to dispatch requests);
           this table is also updated automatically when options
           -i or -S are given
    If none of -b, -S, -t is given, it generates/show implementation
    (not a base) of service[s].

    -s ... show generated code on STDOUT
           (no file is created, disabled when -a given)
    -a ... generate all services (good only for generator testing)

    -v ... verbose
    -d ... debug
    -h ... help
END_OF_USAGE
    exit (0);
}
}
# Undocumented options
# (because it is dangerous, you can loose your code):
#   -F ... force to overwrite existing implementtaion
# -----------------------------------------------------------

use strict;

use MOSES::MOBY::Base;
use MOSES::MOBY::Generators::GenServices;

$LOG->level ('INFO') if $opt_v;
$LOG->level ('DEBUG') if $opt_d;

sub say { print @_, "\n"; }


my $generator = new MOSES::MOBY::Generators::GenServices;

if ($opt_f) {
	my $cache = MOSES::MOBY::Cache::Central->new (
						cachedir => $generator->cachedir,
    					registry => $generator->registry
    );
    say "Creating the services cache ... may take a few minutes!";
    eval{$cache->create_service_cache();};
    say "There was a problem creating the cache:\n$@" if $@;
    say 'Done.' unless $@;
    exit(0);
} elsif ($opt_u) {
	my $cache = MOSES::MOBY::Cache::Central->new (
						cachedir => $generator->cachedir,
    					registry => $generator->registry
    );
    say "Updating the services cache ... may take a few minutes!";
    eval{$cache->update_service_cache();};
    say "There was a problem updating the cache. Did you create it first?\n$@" if $@;
    say 'Done.' unless $@;
    exit(0);
}

if ($opt_a) {
    say 'Generating all services.';
    if ($opt_b) {
	$generator->generate_base;
    } elsif ($opt_S) {
	$generator->generate_impl (static_impl => 1);
	$generator->generate_base;
	$generator->update_table;
    } elsif ($opt_t) {
	$generator->update_table;
    } else {
	$generator->generate_impl;
	$generator->update_table;
    }
} else {
    my $authority = shift;
    say "Generating services from $authority:";
    if ($opt_s) {
	my $code = '';
	if ($opt_b) {
	    $generator->generate_base (service_names => [@ARGV],
				       authority     => $authority,
				       outcode       => \$code);
	} else {
	    $generator->generate_impl (service_names => [@ARGV],
				       authority     => $authority,
				       outcode       => \$code);
	}
	say $code;
    } else {
	if ($opt_b) {
	    $generator->generate_base (service_names => [@ARGV],
				       authority     => $authority);
	} elsif ($opt_S) {
	    $generator->generate_impl (service_names => [@ARGV],
				       authority     => $authority,
				       force_over    => $opt_F,
				       static_impl   => 1);
	    $generator->generate_base (service_names => [@ARGV],
				       authority     => $authority);
	    $generator->update_table (service_names => [@ARGV],
				      authority     => $authority);
	} elsif ($opt_t) {
	    $generator->update_table (service_names => [@ARGV],
				      authority     => $authority);
	} else {
	    $generator->generate_impl (service_names => [@ARGV],
				       authority     => $authority,
				       force_over    => $opt_F);
	    $generator->update_table (service_names => [@ARGV],
				      authority     => $authority);
	}
    }
}
say 'Done.';


__END__
