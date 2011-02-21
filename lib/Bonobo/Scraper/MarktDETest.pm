package Bonobo::Scraper::MarktDETest;

use Test::More;

use base qw/Test::Class/;

sub compilation :Test(startup => 1) {
    use_ok('Bonobo::Scraper::MarktDE');
}

sub find_posting_urls :Tests {
    my $test_dir = './t';
    my $test_data = $test_dir . '/data';
    mkdir $test_data unless -d $test_data;

    my $scraper = Bonobo::Scraper::MarktDE->new(
        cat      => 'sport-bicycles',
        loc      => 'de-berlin',
        data_dir => $test_data,
    );

    warn $scraper->html_filename;
    my @posting_urls = $scraper->find_posting_urls;
}

1;
