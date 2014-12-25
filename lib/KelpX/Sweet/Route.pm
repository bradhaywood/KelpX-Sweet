package KelpX::Sweet::Route;

sub import {
    my $routes = {};
    my $caller = caller;
    {
        no strict 'refs';
        push @{"${caller}::ISA"}, 'Kelp';
        *{"${caller}::new"} = sub { return shift->SUPER::new(@_); };

        *{"${caller}::get"} = sub {
            my ($name, $coderef) = @_;
            $routes->{$name} = {
                type    => 'get',
                coderef => $coderef,
            };
        };

        *{"${caller}::post"} = sub {
            my ($name, $coderef) = @_;
            $routes->{$name} = {
                type    => 'post',
                coderef => $coderef,
            };
        };

        *{"${caller}::bridge"} = sub {
            my ($name, $coderef, $type) = @_;
            $type //= 'get';
            $routes->{$name} = {
               type     => $type,
               coderef  => $coderef,
               bridge   => 1,
            };
        };

        *{"${caller}::get_routes"} = sub {
            return $routes;
        };
    }
}

1;
__END__
