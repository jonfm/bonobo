use MooseX::Declare;

class Bonobo::Scraper {

    use Data::Dumper;
    use Digest::SHA;
    use LWP::UserAgent;
    my $ua = LWP::UserAgent->new();

    has data_dir => ( is => 'ro', isa => 'Str', default => './' );
    has cat      => ( is => 'ro', isa => 'Str', required => 1 );
    has loc      => ( is => 'ro', isa => 'Str', required => 1 );
    has prefix   => ( is => 'ro', isa => 'Str', lazy_build => 1 );
    has url      => ( is => 'ro', isa => 'Str' );
    has ad_urls  => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );
    has ads      => ( is => 'ro', isa => 'ArrayRef[Bonobo::Ad]', lazy_build => 1 );

    method scrape {
        $self->fetch_listing;
        $_->to_db for ( @{ $self->ads } );
    }

    method fetch_listing {
        my $response = $ua->get( $self->url );
        if ( $response->is_success ) {
            mkdir $self->dirname unless -d $self->dirname;
            my $content = $response->decoded_content;
            ### TODO last_mod check here?
            my $filename = $self->html_filename;
            open FH, ">", $filename or die "open failed: $!";
            binmode FH, ":utf8";
            print FH $content;
        } else {
            warn "http request failed";
        }
    }

    method html_filename {
        $self->dirname . "/last_fetch.html";
    }

    method filename (Str $content) {
        my $sha = Digest::SHA->new;
        $sha->add( $content );
        my $filename
            = $self->dirname . '/'
            . $sha->hexdigest
        ;
        return $filename;
    }

    method dirname {
        return $self->data_dir . '/' . join "_", $self->prefix, $self->loc, $self->cat;
    }

    method base_url {
        my ($domain) = $self->url =~ m|^(http[s]*\://[^/]+)|;
        return $domain;
    }

    method _build_ads {
        my @ads;
        for my $url ( @{ $self->ad_urls } ) {
            $url = $self->base_url . $url;
            my $response = $ua->get( $url );
            if ( $response->is_success ) {
                my $content = $response->decoded_content;
                my $filename = $self->filename( $content ) . ".ad.html";
                open FH, ">", $filename;
                binmode FH, ":utf8";
                print FH $content;
                push @ads, $self->_new_ad( $filename, $url );
            } else {
                warn "failed to fetch from: $url";
            }
        }
        return \@ads;
    }

    method _build_prefix { 'BASECLASS' }
}

1;
