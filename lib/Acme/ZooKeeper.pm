package Acme::ZooKeeper;
use strict;
use warnings;

use Term::Screen;
use Term::ANSIColor;
use feature 'switch';

our $VERSION = '0.01';

sub new {
    my ($class, %opts) = @_;

    my $self = +{
        screen  => Term::Screen->new,
        colors  => ['RED', 'GREEN', 'YELLOW', 'BLUE', 'MAGENTA', 'CYAN', 'WHITE'],
        animals => ['猿',  '鰐',    '虎',     '鯨',   '豚',      '象',   '兎'   ],
        cursor  => [0, 0],
        %opts,
    };
    return bless $self, $class;
}

sub play {
    my ($self) = @_;
    $self->_setup_stage;
    $self->_display;

    while ((my $c = $self->{screen}->getch) ne 'q') {
        given ($c) {
            when (/h/i) {
                $self->{cursor}[1]-- if $self->{cursor}[1] > 0;
            }
            when (/j/i) {
                $self->{cursor}[0]++ if $self->{cursor}[0] < 7;
            }
            when (/k/i) {
                $self->{cursor}[0]-- if $self->{cursor}[0] > 0;
            }
            when (/l/i) {
                $self->{cursor}[1]++ if $self->{cursor}[1] < 7;
            }
        }
        $self->_display;
    }
}

sub _setup_stage {
    my ($self) = @_;

    for my $i (1 .. 8) {
        for my $j (1 .. 8) {
            $self->{stage}[$i - 1][$j - 1] = int(rand 7);
        }
    }
}

sub _display {
    my ($self) = @_;

    $self->{screen}->clrscr;
    for my $i (1 .. 8) {
        for my $j (1 .. 8) {
            my $num = $self->{stage}[$i - 1][$j - 1];
            my $color = [
                $self->{colors}[$num],
                ($self->{cursor}[0] == $i - 1 && $self->{cursor}[1] == $j - 1) ? 'ON_BRIGHT_BLACK' : 'ON_BLACK',
            ];
            $self->{screen}->at($i - 1, ($j - 1) * 2)->puts(colored($color, $self->{animals}[$num]));
        }
    }
    $self->{screen}->at($self->{screen}->rows, $self->{screen}->cols);
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

=head3 C<< new() >>

=head3 C<< play() >>

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
