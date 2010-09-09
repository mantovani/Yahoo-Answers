use Yahoo::Answers;
use Data::Dumper;
use strict;
use warnings;

{
    my $ya = Yahoo::Answers->new(
        query      => 'teste',
        results    => 50,
        sort       => 'date_desc',
        region     => 'br',
        date_range => '90-130',
        appid =>
'9J_NabHV34Fuzb1qIdxpKfQdBmV6eaMGeva5NESfQ7IDCupidoKd_cSGK7MI5Xvl.eLeQKd9YkPOU0M4DsX73A--'
    );

    my $struct = $ya->get_search;
    if ( $ya->has_error ) {

        die( Dumper $ya->error );

    }
    else {

        print Dumper $struct;

    }

}
