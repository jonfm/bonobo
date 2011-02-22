package Bonobo::Scraper::MarktDETest;

use strict;
use warnings;

use utf8;

use Data::Dumper;
use Test::More;
use Test::Deep;

use base qw/Test::Class/;

my $test_dir = './t';
my $test_data = $test_dir . '/data';
mkdir $test_data unless -d $test_data;

sub compilation :Test(startup => 1) {
    use_ok('Bonobo::Scraper::MarktDE');
}

sub single_ad :Tests {
    my $test_ad = "./t/data/markt_de-berlin_sport-bicycles/test.ad.html";
    my $ad = Bonobo::Ad::MarktDE->new(
        filename => $test_ad,
        url      => 'http://www.markt.de/berlin/Mountainbikes%2C+MTB/stevens+scope+mit+xtr+2011/recordId,8d45cd01/expose.htm',
        loc => 'de-berlin',
        cat => 'sport-bicycles',
    );
    ok( $ad->html, "loaded ad html" );
    is( $ad->title, "Stevens Scope mit XTR 2011", "extracted title" );
    is( $ad->thumb, "http://bilder.markt.de/images/2011021315/8d45cd01/thumbnail_0.jpg?lastModified=1297608684000", "extracted thumbnail" );
    my $blurb = 'Stevens Scope, Carbonhardtail, 20", mit kompletter XTR 2011, Ritchey WCS Carbonlaufrädern mit DT Swiss 190 Naben, Ritchey Superlogic Lenker, Vorbau und Sattelstütze. ';
    utf8::encode($blurb);
    is( $ad->blurb, $blurb, "extracted title" );
    is( $ad->price, "2.999", "extracted price" );

}

sub full_run { # Does a real fetch
    my $scraper = Bonobo::Scraper::MarktDE->new(
        cat      => 'sport-bicycles',
        loc      => 'de-berlin',
        data_dir => $test_data,
        url      => 'http://www.markt.de/berlin/suche.htm?categoryId=1007000000&geoName=Berlin',
    );

    $scraper->scrape;
}

sub find_ads :Tests {
    my $class = shift;

    for my $case ( $class->find_ads_cases ) {
        my $scraper = Bonobo::Scraper::MarktDE->new(
            cat      => $case->{cat},
            loc      => $case->{loc},
            url      => $case->{url},
            data_dir => $test_data,
        );

        my $posting_urls = $scraper->ad_urls;
        is_deeply( $posting_urls, $case->{expect}, "got expected posting urls" );

    }
}

my @find_ads_cases = (
    {
        cat      => 'sport-bicycles',
        loc      => 'de-berlin',
        url => 'http://www.markt.de/berlin/suche.htm?categoryId=1007000000&geoName=Berlin',
        expect   => [
          '/berlin/BMX/20%22+bmx+felt/recordId,dc7dbf70/expose.htm',
          '/berlin/Faltr%C3%A4der%2C+Klappr%C3%A4der/falt-oder+klapprad+guenstig/recordId,b897e63b/expose.htm',
          '/berlin/Cityr%C3%A4der/bikepark-+riesen+fahrrad+markt%3A+28%E2%80%98er+damenrad%2C+wheeler+ecorider/recordId,49b2a78a/expose.htm',
          '/berlin/Trekkingr%C3%A4der/bikepark-+riesen+fahrrad+markt%3A+28%22+trekkingrad%2C+hercules+x24/recordId,707b2b96/expose.htm',
          '/berlin/Fahrradteile/bontrager+laufraeder+mit+scheiben-aufnahme/recordId,c10c8c6a/expose.htm',
          '/berlin/Mountainbikes%2C+MTB/bikepark-+riesen+gebraucht+fahrrad+markt%3A+1x+26%22+cycle+wolf+mtb+xt-gruppe/recordId,c2e2c064/expose.htm',
          '/berlin/Mountainbikes%2C+MTB/mountainbike+auch+defekt/recordId,50bbe1ef/expose.htm',
          '/berlin/Mountainbikes%2C+MTB/bikepark-+riesen+fahrrad+markt%3A+26+mtb%2C+wheeler+pro09/recordId,7e7fc9f3/expose.htm',
          '/berlin/Faltr%C3%A4der%2C+Klappr%C3%A4der/klapprad/recordId,93373ca5/expose.htm',
          '/berlin/Fahrradteile/laufradsatz+26+alexrims%21%21%21/recordId,283a7086/expose.htm',
          '/berlin/Cityr%C3%A4der/damenfahrrad+zu+verkaufen/recordId,1d7f9413/expose.htm',
          '/berlin/Hollandr%C3%A4der/bikepark-+riesen+gebraucht+fahrrad+markt%3A+28%22+amsterdam+hollandrad+*top/recordId,4c6698b3/expose.htm',
          '/berlin/Trekkingr%C3%A4der/bikepark-+riesen+fahrrad+markt%3A+28+trekking%2C+wheeler/recordId,3062530b/expose.htm',
          '/berlin/Rennr%C3%A4der/bikepark-+riesen+gebraucht+fahrrad+markt%3A+28%22+giant+rennrad+*top*/recordId,c8928c58/expose.htm',
          '/berlin/Cityr%C3%A4der/herren-oder+damenrad/recordId,3322919a/expose.htm',
          '/berlin/Tandem/tandem+auch+defekt/recordId,121a9bfd/expose.htm',
          '/berlin/BMX/mongoose+bmx+%22t-mobile+extreme+playgrounds%22+fraction+-+neu+%26+ovp/recordId,24cc503c/expose.htm',
          '/berlin/Trekkingr%C3%A4der/bikepark-+riesen+fahrrad+markt%3A+28%22+cross%2C+wheeler/recordId,3de58dae/expose.htm',
          '/berlin/Mountainbikes%2C+MTB/mountain-/trekking-bike+robust/recordId,28c0dbf0/expose.htm',
          '/berlin/Mountainbikes%2C+MTB/stevens+scope+mit+xtr+2011/recordId,8d45cd01/expose.htm',
        ],
    },
);

sub find_ads_cases { return @find_ads_cases; }

1;
