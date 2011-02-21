use MooseX::Declare;

class Bonobo::Ad {
    use utf8;
    use Data::Dumper;
    use HTML::Entities ();

    has filename => ( is => 'ro', isa => 'Str', required => 1 );
    has url      => ( is => 'ro', isa => 'Str', required => 1 );

    has loc   => ( is => 'ro', isa => 'Str', required => 1 );
    has cat   => ( is => 'ro', isa => 'Str', required => 1 );

    has title => ( is => 'ro', isa => 'Str', lazy_build => 1 );
    has thumb => ( is => 'ro', isa => 'Str', lazy_build => 1 );
    has blurb => ( is => 'ro', isa => 'Str', lazy_build => 1 );
    has price => ( is => 'ro', isa => 'Str', lazy_build => 1 );

    has html => ( is => 'ro', isa => 'Str', lazy_build => 1 );

    method to_db {
        my $hash = {};
        for ( qw/url loc cat title price/ ) {
            $hash->{$_} = $self->$_();
        }
        warn Dumper $hash;
    }

    method _decode_html (Str $html) {
        $html =~ s/\Q&nbsp;\E/ /g; #HTML::Entities does something weird
        HTML::Entities::decode_entities($html);
        return $html;
    }

    method _build_html {
        die "file does not exist: " . $self->filename unless -e $self->filename;
        open FH, "<", $self->filename;
        binmode FH, ":utf8";
        my $html = join '', (<FH>);
        utf8::encode($html);
        return $html;
    }

}


