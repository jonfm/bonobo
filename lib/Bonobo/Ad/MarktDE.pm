use MooseX::Declare;

class Bonobo::Ad::MarktDE extends Bonobo::Ad {
    use utf8;
    method _build_title {
        my ($title) = $self->html =~ m{<h1>(.+)</h1>};
        return $self->_decode_html( $title );
    }
    method _build_thumb {
        my ($thumb) = $self->html =~ m{image['"] content=['"]([^"']+)}is;
        return $thumb;
    }
    method _build_blurb {
        my ($blurb) = $self->html =~ m{markt_expose_description_body.+\<p\>(.+)\</p\>}i;
        return $self->_decode_html( $blurb );
    }
    method _build_price {
        my ($price) = $self->html =~ m{price["']\>\D+([\d\.,]+)}s;
        return $price;
    }
}
