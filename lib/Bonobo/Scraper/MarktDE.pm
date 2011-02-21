use MooseX::Declare;

class Bonobo::Scraper::MarktDE extends Bonobo::Scraper {

    method BUILD {
        print "running this first\n";
    }

    method find_posting_urls {
        unless ( -e $self->html_filename ) {
            die "no file has been downloaded";
        }
        warn $self->html_filename
    }

    method _build_prefix { 'markt' }

}

1;
