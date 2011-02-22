use MooseX::Declare;

class Bonobo::Scraper::MarktDE extends Bonobo::Scraper {
    use Bonobo::Ad::MarktDE;

    method BUILD {
        print "running this first\n";
    }

    method _new_ad (Str $filename, Str $url) {
        Bonobo::Ad::MarktDE->new(
            filename => $filename,
            url => $url,
            cat => $self->cat,
            loc => $self->loc,
        );
    }

    method _build_ad_urls {
        unless ( -e $self->html_filename ) {
            die "no file has been downloaded";
        }
        warn $self->html_filename;
        open FH, $self->html_filename;
        my $html = join '', (<FH>);
        my %urls;
        while ($html =~ m{([^"]+/expose\.htm)["]}g) {
            $urls{$1}++;
        }
        return [keys %urls];
    }

    method _build_prefix { 'markt' }

}

1;
