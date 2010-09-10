use Yahoo::Answers;
use Data::Dumper;
use strict;
use warnings;

{
    my $ya = Yahoo::Answers->new(
        query   => 'cultura inglesa',
        results => 50,
        sort    => 'date_desc',
        appid =>
'9J_NabHV34Fuzb1qIdxpKfQdBmV6eaMGeva5NESfQ7IDCupidoKd_cSGK7MI5Xvl.eLeQKd9YkPOU0M4DsX73A--'
    );

    $ya->region_by_name('Brazil');
    my $struct = $ya->get_search;
    if ( $ya->has_error ) {

        die( Dumper $ya->error );

    }
    else {

        print Dumper $struct;

    }

}
