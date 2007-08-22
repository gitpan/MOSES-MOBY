#-----------------------------------------------------------------
# MOSES::MOBY::Cache::Registries
# Author: Martin Senger <martin.senger@gmail.com>
# For copyright and disclaimer see below.
#
# $Id: Registries.pm,v 1.2 2006/12/05 17:18:15 senger Exp $
#-----------------------------------------------------------------

package MOSES::MOBY::Cache::Registries;

use base qw ( MOSES::MOBY::Base);
use strict;

#-----------------------------------------------------------------
# A hard-coded list of the known registries.
#
# Please fill all details if you are adding new registry here.
#
# Do not create synonyms starting with 'http://' (they are in the
# roles of the hash keys) - this is how some methods distinguish
# between synonym and endpoint.
#
#-----------------------------------------------------------------

my %REGISTRIES =
    ( iCAPTURE => { endpoint  => 'http://mobycentral.icapture.ubc.ca/cgi-bin/MOBY05/mobycentral.pl',
		    namespace => 'http://mobycentral.icapture.ubc.ca/MOBY/Central',
		    name      => 'iCAPTURE Centre, Vancouver',
		    contact   => 'Edward Kawas (edward.kawas@gmail.com)',
		    public    => 'yes',
		    text      => 'A curated public registry hosted at the iCAPTURE Centre, Vancouver',
		},
      IRRI     => { endpoint  => 'http://cropwiki.irri.org/cgi-bin/MOBY-Central.pl',
		    namespace => 'http://cropwiki.irri.org/MOBY/Central',
		    name      => 'IRRI, Philippines',
		    contact   => 'Mylah Rystie Anacleto (m.anacleto@cgiar.org)',
		    public    => 'yes',
		    text      => 'The MOBY registry at the International Rice Research Institute (IRRI) is intended mostly for Generation Challenge Program (GCP) developers. It allows the registration of experimental moby entities within GCP.',
	       },
      testing  => { endpoint  => 'http://bioinfo.icapture.ubc.ca/cgi-bin/mobycentral/MOBY-Central.pl',
		    namespace => 'http://bioinfo.icapture.ubc.ca/MOBY/Central',
		    name      => 'Testing BioMoby registry',
		    contact   => 'Edward Kawas (edward.kawas@gmail.com)',
		    public    => 'yes',
		},
      );

$REGISTRIES{default} = $REGISTRIES{iCAPTURE};

#-----------------------------------------------------------------
# init
#-----------------------------------------------------------------
sub init {
    my $self = shift;
    my %cloned = %REGISTRIES;
    $self->{registries} = \%cloned;
}

#-----------------------------------------------------------------
# list
#-----------------------------------------------------------------
sub list {
    my $self = shift;
    return sort keys %{ $self->{registries} } if ref $self;
    return sort keys %REGISTRIES;
}

#-----------------------------------------------------------------
# get
#-----------------------------------------------------------------
sub get {
    my ($self, $abbrev) = @_;
    $abbrev ||= 'default';
    return $self->{registries}->{$abbrev} if ref $self;
    return $REGISTRIES{$abbrev};
}

#-----------------------------------------------------------------
# all
#-----------------------------------------------------------------
sub all {
    my $self = shift;
    return $self->{registries} if ref $self;
    return \%REGISTRIES;
}

1;
__END__

=head1 NAME

MOSES::MOBY::Cache::Registries - List of known BioMoby registries

=head1 SYNOPSIS

  use MOSES::MOBY::Cache::Registries;

  # print synonyms of all available registries
  print "Available registries: ",
        join (", ", MOSES::MOBY::Cache::Registries->list);

  # print all features of a selected registry
  my $regs = new MOSES::MOBY::Cache::Registries;
  my %reg = $regs->get ('IRRI');
  foreach $key (sort keys $reg) {
     print "$key: $reg{$key}\n";
  }

=head1 DESCRIPTION

A list of known BioMoby registries is hard coded here, and their
characteristics (such as their endpoints) can be retrieved by a
user-friendly synonym.

There is not that many registries, so there is (at the moment) no
intention to retrieve details from a database. Hard-coded entries seem
to be sufficient (if you can create a new BioMoby registry, you are
fully qualified and capable to edit also this file).

=head1 SUBROUTINES

All subroutines can be called as object or class methods.

=head2 list

   my @regs = MOSES::MOBY::Cache::Registries->list;

Return a list of synonyms (abbreviations) of all available
registries. At least a synonym C<default> is always present. The
synonyms can be used in the C<get> method.

=head2 get

   my %reg = MOSES::MOBY::Cache::Registries->get ('IRRI');
   my %reg = MOSES::MOBY::Cache::Registries->get;

Return a hash with details about a registry whose abbreviation was
given as an argument. No argument is the same as 'default'. The known
synonyms can be obtained by C<list> method.

Returned hash can contain the following keys:

=over

=item * endpoint

Value is an endpoint (a stringified URL) of this BioMoby registry.

=item * namespace

Value is a namespace (a URI) used by this registry.

=item * name

Value is a full-name of this registry. Often accompanied with the
geographical location.

=item * contact

Value is a contact person, perhaps with en email, who is in charge of
this registry.

=item * public

Indicate (by value 'yes') that this registry is publicly available.

=item * text

A human-readable description explaining reasons, sometimes policies,
of this registry.

=back

=head2 all

   my $regs = MOSES::MOBY::Cache::Registries->all;

Return a hash reference with details about all registries. It is the
same as calling C<get> for all individual entries.

=head1 AUTHORS

 Martin Senger (martin.senger [at] gmail [dot] com)
 Edward Kawas (edward.kawas [at] gmail [dot] com)

=cut

