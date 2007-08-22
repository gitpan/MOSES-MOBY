#-----------------------------------------------------------------
# MOSES::MOBY::Utils
# Author: Martin Senger <martin.senger@gmail.com>,
#         Edward Kawas <edward.kawas@gmail.com>
# For copyright and disclaimer see below.
#
# $Id: Utils.pm,v 1.1 2006/10/13 21:51:16 senger Exp $
#-----------------------------------------------------------------

package MOSES::MOBY::Generators::Utils;
use File::Spec;
use strict;

=head1 NAME

MOSES::MOBY::Utils - what does not fit elsewhere

=head1 SYNOPSIS

 # find a file located somewhere in @INC
 use MOSES::MOBY::Generators::Utils;
 my $file = MOSES::MOBY::Generators::Utils->find_file ('resource.file');
 
=head1 DESCRIPTION

General purpose utilities.

=head1 AUTHORS

 Martin Senger (martin.senger [at] gmail [dot] com)
 Edward Kawas (edward.kawas [at] gmail [dot] com)

=head1 SUBROUTINES

=cut

#-----------------------------------------------------------------
# find_file
#-----------------------------------------------------------------

=head2 find_file

Try to locate a file whose name is created from the C<$default_start>
and all elements of C<@names>. If it does not exist, try to replace
the C<$default_start> by elements of @INC (one by one). If neither of
them points to an existing file, go back and return the
C<$default_start> and all elements of C<@names> (even - as we know now
- such file does not exist).

There are two or more arguments: C<$default_start> and C<@names>.

=cut

sub find_file {
    my ($self, $default_start, @names) = @_;
    my $fixed_part = File::Spec->catfile (@names);
    my $result = File::Spec->catfile ($default_start, $fixed_part);
    return $result if -e $result;

    foreach my $idx (0 .. $#INC) {
	$result = File::Spec->catfile ($INC[$idx], $fixed_part);
	return $result if -e $result;
    }
    return File::Spec->catfile ($default_start, $fixed_part);
}

1;
__END__
