package KelpX::Sweet;

use Moo;
extends 'Kelp';
sub import {
    my ($class, %args) = @_;
    my $caller = caller;
    my $routes = [];
    {
        no strict 'refs';
        push @{"${caller}::ISA"}, 'Kelp';
        *{"${caller}::new"} = sub { return shift->SUPER::new(@_); };
        *{"${caller}::maps"} = sub {
            my ($route_names) = @_;
            unless (ref $route_names eq 'ARRAY') {
                die "routes() expects an array references";
            }

            for my $mod (@$route_names) {
                my $route_path = "${caller}::Route::${mod}";
                eval "use $route_path;";
                if ($@) {
                    warn "Could not load route ${route_path}: $@";
                    next;
                }

                push @$routes, $route_path->get_routes();
            }
        };

        *{"${caller}::build"} = sub {
            my ($self) = @_;
            my $r      = $self->routes;
            
            for my $route (@$routes) {
                for my $url (keys %$route) {
                    if ($route->{$url}->{bridge}) {
                        $r->add([ uc($route->{$url}->{type}) => $url ], { to => $route->{$url}->{coderef}, bridge => 1 });
                    }
                    else {
                        $r->add([ uc($route->{$url}->{type}) => $url ], $route->{$url}->{coderef});
                    }
                }
            }
        };
    }
}

sub new {
    bless { @_[ 1 .. $#_ ] }, $_[0];
}

1;
__END__
