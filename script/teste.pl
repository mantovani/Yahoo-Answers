use Yahoo::Answers;
use strict;
use warnings;

{
    my $ya = Yahoo::Answers->new(
        query => 'teste',
        appid =>
'9J_NabHV34Fuzb1qIdxpKfQdBmV6eaMGeva5NESfQ7IDCupidoKd_cSGK7MI5Xvl.eLeQKd9YkPOU0M4DsX73A--'
    );

    my $struct = $ya->get_search;
    use Data::Dumper;
    print Dumper $struct;
}
