package Acme::ZooKeeper;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub play {
}

1;
__END__

=head1 NAME

Acme::ZooKeeper - Perl extention to do something

=head1 VERSION

This document describes Acme::ZooKeeper version 0.01.

=head1 SYNOPSIS

    use Acme::ZooKeeper;

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

sugyan E<lt>sugi1982@gmail.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, sugyan. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
