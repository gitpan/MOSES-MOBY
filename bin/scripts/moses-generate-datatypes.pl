#!/usr/bin/perl -w
#
# Generate datatypes.
#
# $Id: generate-datatypes.pl,v 1.6 2006/10/13 22:08:39 senger Exp $
# Contact: Martin Senger <martin.senger@gmail.com>
# -----------------------------------------------------------

# some command-line options
use Getopt::Std;
use vars qw/ $opt_h $opt_f $opt_u $opt_d $opt_v $opt_s /;
getopt;

# usage
if ($opt_h) {
    print STDOUT <<'END_OF_USAGE';
Generate datatypes.
Usage: [-vds] [data-type-name] [data-type-name...]
	   [-uf]
	   
    It also needs to get a location of a local cache (and potentially
    a BioMoby registry endpoint, and an output directory). It takes
    it from the 'moby-service.cfg' configuration file.

    If no data type given it generates all of them.

    -s ... show generated code on STDOUT
           (no file is created, disabled when no data type name given)
    -f ... fill the cache
    -u ... update the cache
    -v ... verbose
    -d ... debug
    -h ... help
END_OF_USAGE
    exit (0);
}
# -----------------------------------------------------------

use strict;

use MOSES::MOBY::Base;
use MOSES::MOBY::Generators::GenTypes;

$LOG->level ('INFO') if $opt_v;
$LOG->level ('DEBUG') if $opt_d;

sub say { print @_, "\n"; }


my $generator = new MOSES::MOBY::Generators::GenTypes;
if ($opt_f) {
	my $cache = MOSES::MOBY::Cache::Central->new (
						cachedir => $generator->cachedir,
    					registry => $generator->registry
    );
    say "Creating the datatype cache ... may take a few minutes!";
    eval {$cache->create_datatype_cache();};
    say "There was a problem creating the cache!\n$@" if $@;
    say 'Done.' unless $@;
    exit(0);
} elsif ($opt_u) {
	my $cache = MOSES::MOBY::Cache::Central->new (
						cachedir => $generator->cachedir,
    					registry => $generator->registry
    );
    say "Updating the datatype cache ... may take a few minutes!";
    eval {$cache->update_datatype_cache();};
    say "There was a problem updating the cache. Did you create it first?\n$@" if $@;
    say 'Done.' unless $@; 
    exit(0);
}

if (@ARGV) {
    say 'Generating ' . (@ARGV+0) . '+ data types.';
    if ($opt_s) {
	my $code = '';
	$generator->generate (datatype_names => [@ARGV],
			      with_docs      => 1,
			      outcode        => \$code);
	say $code;
    } else {
	$generator->generate (datatype_names => [@ARGV]);
    }
} else {
    say 'Generating all data types.';
    $generator->generate;
}
say 'Done.';


__END__
