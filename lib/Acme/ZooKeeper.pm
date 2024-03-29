package Acme::ZooKeeper;
use strict;
use warnings;

use feature 'switch';
use Term::Screen;
use Term::ANSIColor;
use Time::HiRes 'sleep';

our $VERSION = '0.01';

sub new {
    my ($class, %opts) = @_;

    my $self = +{
        screen  => Term::Screen->new,
        colors  => ['RED',    'GREEN',  'YELLOW', 'BLUE',   'MAGENTA', 'CYAN',   'WHITE'],
        animals => ['猿',     '鰐',     '虎',     '鯨',     '豚',      '象',     '兎'   ],
        cursor  => [0, 0],
        %opts,
    };
    return bless $self, $class;
}

sub play {
    my ($self) = @_;
    $self->{screen}->clrscr;
    $self->_setup_stage;
    $self->_display;

    while ((my $c = $self->{screen}->getch) ne 'q') {
        given ($c) {
            when ('h') {
                if ($self->{cursor}[1] > 0) {
                    if ($self->{marked}) {
                        $self->_swap($self->{cursor}[0], $self->{cursor}[1] - 1);
                    }
                    else {
                        $self->{cursor}[1]--;
                    }
                }
                $self->{marked} = 0;
            }
            when ('j') {
                if ($self->{cursor}[0] < 7) {
                    if ($self->{marked}) {
                        $self->_swap($self->{cursor}[0] + 1, $self->{cursor}[1]);
                    }
                    else {
                        $self->{cursor}[0]++;
                    }
                }
                $self->{marked} = 0;
            }
            when ('k') {
                if ($self->{cursor}[0] > 0) {
                    if ($self->{marked}) {
                        $self->_swap($self->{cursor}[0] - 1, $self->{cursor}[1]);
                    }
                    else {
                        $self->{cursor}[0]--;
                    }
                }
                $self->{marked} = 0;
            }
            when ('l') {
                if ($self->{cursor}[1] < 7) {
                    if ($self->{marked}) {
                        $self->_swap($self->{cursor}[0], $self->{cursor}[1] + 1);
                    }
                    else {
                        $self->{cursor}[1]++;
                    }
                }
                $self->{marked} = 0;
            }
            when (/ /) {
                if ($self->{marked}) {
                    $self->{marked} = 0;
                }
                else {
                    $self->{marked} = 1;
                }
            }
        }
        $self->_display;
    }
}

sub _setup_stage {
    my ($self) = @_;

    for my $i (1 .. 8) {
        for my $j (1 .. 8) {
            $self->{stage}[$i - 1][$j - 1] = -1;
        }
    }
}

sub _display {
    my ($self) = @_;

    for my $row (1 .. 8) {
        for my $col (1 .. 8) {
            my $num = $self->{stage}[$row - 1][$col - 1];
            my $color = [
                'BOLD',
                $self->{colors}[$num],
                ($self->{cursor}[0] == $row - 1 && $self->{cursor}[1] == $col - 1) ? 'ON_BRIGHT_BLACK' : 'ON_BLACK',
            ];
            $self->{screen}->at($row - 1, ($col - 1) * 2)->puts(colored($color, $num == -1 ? '　' : $self->{animals}[$num]));
        }
    }
    $self->{screen}->at($self->{screen}->rows, $self->{screen}->cols);
    return $self->_check;
}

sub _check {
    my ($self) = @_;

    my $updated = 0;
    my @deleted = ();
    for my $row (reverse 1 .. 8) {
        for my $col (reverse 1 .. 8) {
            my $num = $self->{stage}[$row - 1][$col - 1];
            if ($num == -1) {
                $updated = 1;
                if ($row == 1) {
                    $self->{stage}[$row - 1][$col - 1] = int(rand 7);
                }
                else {
                    $self->{stage}[$row - 1][$col - 1] = $self->{stage}[$row - 2][$col - 1];
                    $self->{stage}[$row - 2][$col - 1] = -1;
                }
            }
            if ($col < 7 &&
                    $num == $self->{stage}[$row - 1][$col + 0] && $num == $self->{stage}[$row - 1][$col + 1]) {
                push @deleted, [$row - 1, $col - 1], [$row - 1, $col + 0], [$row - 1, $col + 1];
            }
            if ($row < 7 &&
                    $num == $self->{stage}[$row + 0][$col - 1] && $num == $self->{stage}[$row + 1][$col - 1]) {
                push @deleted, [$row - 1, $col - 1], [$row + 0, $col - 1], [$row + 1, $col - 1];
            }
        }
    }

    if ($updated) {
        sleep 0.1;
        $self->_display;
    }
    elsif (@deleted) {
        for my $d (@deleted) {
            $self->{stage}[$d->[0]][$d->[1]] = -1;
        }
        $self->_display;
    }

    return @deleted;
}

sub _swap {
    my ($self, $row, $col) = @_;

    my $tmp = $self->{stage}[$self->{cursor}[0]][$self->{cursor}[1]];
    $self->{stage}[$self->{cursor}[0]][$self->{cursor}[1]] = $self->{stage}[$row][$col];
    $self->{stage}[$row][$col] = $tmp;

    my $deleted = $self->_display;
    if (! $deleted) {
        sleep 0.1;
        # back
        $self->{stage}[$row][$col] = $self->{stage}[$self->{cursor}[0]][$self->{cursor}[1]];
        $self->{stage}[$self->{cursor}[0]][$self->{cursor}[1]] = $tmp;
    }
}

1;
__END__

=head1 NAME

Acme::ZooKeeper - Perl extention to do something

=head1 VERSION

This document describes Acme::ZooKeeper version 0.01.

=head1 SYNOPSIS

    use Acme::ZooKeeper;
    Acme::Zookeeper->new->play;

=head1 DESCRIPTION

    use keyboard. 'h', 'j', 'k', 'l' for moving cursor. space key for swapping. 'q' for quit.

=head1 INTERFACE

=head2 Functions

=head3 C<< new() >>

=head3 C<< play() >>

=head1 DEPENDENCIES

Perl 5.10.1 or later.

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
