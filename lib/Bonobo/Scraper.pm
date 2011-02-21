use MooseX::Declare;

class Bonobo::Scraper {

#    has [qw/
#        find_posting_urls
#        find_category
#        find_location
#        find_title
#        find_blurb
#        find_attribution
#    /] => (
#        is         => 'ro',
#        isa        => 'CodeRef',
#        required   => 1,
#        lazy_build => 1,
#    );
    use Digest::SHA;
    use LWP::UserAgent;
    my $ua = LWP::UserAgent->new();

    has data_dir => ( is => 'ro', isa => 'Str', default => './' );
    has cat      => ( is => 'ro', isa => 'Str', required => 1 );
    has loc      => ( is => 'ro', isa => 'Str', required => 1 );
    has prefix   => ( is => 'ro', isa => 'Str', lazy_build => 1 );
    has url      => ( is => 'ro', isa => 'Str' );


    method scrape {
        print "scraping stuff here\n";
    }

    method pull_page_to_disk {
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

    method _build_prefix { 'BASECLASS' }
}

1;
