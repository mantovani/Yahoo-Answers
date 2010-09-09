package Yahoo::Answers;

use warnings;
use strict;

use Moose;
use Moose::Util::TypeConstraints;

use MooseX::Types::Common::String qw/NonEmptySimpleStr SimpleStr/;
use MooseX::Types::Common::Numeric qw/PositiveInt/;

use WWW::Mechanize;
use URI::QueryParam;
use URI;
use JSON;

has 'mechanize' => (
    is      => 'ro',
    isa     => 'WWW::Mechanize',
    default => sub { WWW::Mechanize->new() }
);
has 'url' => (
    is      => 'rw',
    isa     => 'Object',
    default => sub {
        URI->new(
            'http://answers.yahooapis.com/AnswersService/V1/questionSearch');
    }
);

has 'query' => ( is => 'rw', isa => 'Str', required => 1 );

subtype 'Search_in' => as Str =>
  where { /^all$|^question$|^best_answer$/ };
has 'search_in' => (
    is        => 'rw',
    isa       => 'Search_in',
    default   => 'all',
    lazy      => 1,
    predicate => 'has_search_in'
);

has 'category_id' =>
  ( is => 'rw', isa => PositiveInt, predicate => 'has_category_id' );

has 'category_name' =>
  ( is => 'rw', isa => SimpleStr, predicate => 'has_category_name' );

subtype 'Region' => as Str => where {
    /^us$|^uk$|^ca$|^au$|^in$|^es$|^br$|^ar$|^mx$|^e1$|^it$|^de$|^fr$|^sg$/x;
};
has 'region' => (
    isa       => 'rw',
    isa       => 'Region',
    predicate => 'has_region',
    trigger   => \&_region_by_name
);

sub _region_by_name {
    my ( $self, $region ) = @_;
    my %country = (
        'united states'  => 'us',
        'united kingdom' => 'uk',
        'canada'         => 'ca',
        'australia'      => 'au',
        'india'          => 'in',
        'spain'          => 'es',
        'brazil'         => 'br',
        'argentina'      => 'ar',
        'mexico'         => 'mx',
        'en espanol'     => 'e1',
        'italy'          => 'it',
        'germany'        => 'de',
        'france'         => 'fr',
        'singapore'      => 'sg'
    );

    if ( length($region) > 2 ) {
        $self->region( $country{ lc($region) }
              || die "There is no region with the name: {$region}" );
    }
}

subtype 'Date_Range' => as Str =>
  where { /all|\d|\d\-\d|more\d/ };
has 'date_range' => (
    is        => 'rw',
    isa       => 'Date_Range',
    default   => 'all',
    lazy      => 1,
    predicate => 'has_date_range'
);

subtype 'Sort' => as Str =>
  where { /relevance|date_desc|date_asc/ };
has 'sort' => (
    is        => 'rw',
    isa       => 'Sort',
    default   => 'relevance',
    lazy      => 1,
    predicate => 'has_sort'
);

# You can see more information here,
# http://developer.yahoo.com/faq/index.html#appid

has 'appid' => (
    is        => 'rw',
    isa       => NonEmptySimpleStr,
    required  => 1,
    predicate => 'has_appid'
);

subtype 'Search_Type',
  as Str => where { /^all$|^resolved$|^open$|^undecided$/ };
has 'search_type' => ( is => 'rw', isa => 'Type_', predicate => 'has_type' );

has 'start' => ( is => 'rw', isa => PositiveInt, predicate => 'has_start' );

subtype Results => as Int => where { $_[0] <= 50 };
has 'results' => ( is => 'rw', isa => 'Results', predicate => 'has_results' );

has 'output' => ( is => 'ro', isa => NonEmptySimpleStr, default => 'json' );

sub url_builder {
    my $self = shift;
    for my $acr (
        'query',       'search_in',  'category_id', 'category_name',
        'region',      'date_range', 'sort',        'appid',
        'search_type', 'start',      'results',     'output'
      )
    {
        $self->url->query_param( $acr => $self->{$acr} ) if $self->{$acr};
    }
}

sub get_search {
    my $self = shift;
    my $json = JSON->new->allow_nonref;
    return $json->decode( $self->request );
}

before 'request' => sub { shift->url_builder };

sub request {
    my $self = shift;
    $self->mechanize->get( $self->url );
    return $self->mechanize->content;
}

=head1 NAME

Yahoo::Answers - The great new Yahoo::Answers!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Yahoo::Answers;

    my $ya = Yahoo::Answers->new(
        query => 'test',
        appid =>
'9J_NabHV34Fuzb1qIdxpKfQdBmV6eaMGeva5NESfQ7IDCupidoKd_cSGK7MI5Xvl.eLeQKd9YkPOU0M4DsX73A--'
    );

    my $struct = $ya->get_search;
    use Data::Dumper;
    print Dumper $struct;

=head1 AUTHOR

Daniel de O. Mantovani, C<< <daniel.oliveira.mantovani at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-yahoo-ansewers at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Yahoo-Answers>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Yahoo::Answers


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Yahoo-Answers>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Yahoo-Answers>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Yahoo-Answers>

=item * Search CPAN

L<http://search.cpan.org/dist/Yahoo-Answers/>

=back


=head1 ACKNOWLEDGEMENTS

Thiago Rondon

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Daniel de O. Mantovani.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;    # End of Yahoo::Answers
