use Yahoo::Answers;
use Data::Dumper;
use strict;
use warnings;

&foo ;

sub foo {
    my $ya = Yahoo::Answers->new(
        results => 10,
        sort    => 'date_desc',
        appid =>
'9J_NabHV34Fuzb1qIdxpKfQdBmV6eaMGeva5NESfQ7IDCupidoKd_cSGK7MI5Xvl.eLeQKd9YkPOU0M4DsX73A--'
    );

	$ya->query('Cultura Inglesa');
    my $struct = $ya->get_search;
    if ( $ya->has_error ) {

        print Dumper $ya->error;
        exit(0);
    }
    else {

        print Dumper $struct;

    }
}
