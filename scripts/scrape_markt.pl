use Bonobo::Scraper::MarktDE;

my $destinations = [
    { cat => 'sport-bicycles',
      loc => 'de-berlin',
      url => 'http://www.markt.de/berlin/suche.htm?categoryId=1007000000&geoName=Berlin',
    },
];

for my $listing ( @$destinations ) {
    my $app = Bonobo::Scraper::MarktDE->new( %$listing );
    $app->pull_page_to_disk;
}
