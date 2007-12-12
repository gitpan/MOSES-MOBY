#-----------------------------------------------------------------
# MOSES::MOBY::Data::Boolean
# Author: Edward Kawas <edward.kawas@gmail.com>,
#         Martin Senger <martin.senger@gmail.com>
# For copyright and disclaimer see below.
#
# $Id: Boolean.pm,v 1.1 2006/10/13 21:51:16 senger Exp $
#-----------------------------------------------------------------

package MOSES::MOBY::Data::Boolean;
use base ("MOSES::MOBY::Data::Object");
use strict;

=head1 NAME

MOSES::MOBY::Data::Boolean - A primite Moby data type for booleans

=head1 SYNOPSIS

 use MOSES::MOBY::Data::Boolean;

 # create a Moby Boolean with initial value of true
 my $data = MOSES::MOBY::Data::Boolean->new ( value=>'true' );
 my $data = MOSES::MOBY::Data::Boolean->new ('true');
 
 # change the value to false
 $data->value ('false');

 # get the value
 print $data->value;
  
 # create a Moby Integer with initial value of -15
 my $data = MOSES::MOBY::Data::Integer->new (value => -15);

=head1 DESCRIPTION
	
An object representing a Boolan, a Moby primitive data type.

=head1 AUTHORS

 Edward Kawas (edward.kawas [at] gmail [dot] com)
 Martin Senger (martin.senger [at] gmail [dot] com)

=cut

#-----------------------------------------------------------------
# A list of allowed attribute names. See MOSES::MOBY::Base for details.
#-----------------------------------------------------------------

=head1 ACCESSIBLE ATTRIBUTES

Details are in L<MOSES::MOBY::Base>. Here just a list of them (additionally
to the attributes from the parent classes)

=over

=item B<value>

A value of this datatype. Must be a boolean.

=back

=cut

{
    my %_allowed =
	(
	 value  => {type => MOSES::MOBY::Base->BOOLEAN},
	 );

    sub _accessible {
	my ($self, $attr) = @_;
	exists $_allowed{$attr} or $self->SUPER::_accessible ($attr);
    }
    sub _attr_prop {
	my ($self, $attr_name, $prop_name) = @_;
	my $attr = $_allowed {$attr_name};
	return ref ($attr) ? $attr->{$prop_name} : $attr if $attr;
	return $self->SUPER::_attr_prop ($attr_name, $prop_name);
    }
}

#-----------------------------------------------------------------
# init
#-----------------------------------------------------------------
sub init {
    my ($self) = shift;
    $self->SUPER::init();
    $self->primitive ('yes');
}

sub _express_value {
    shift;
    my ($value) = shift;
    $value ? 'true' : 'false';
}


1;
__END__
