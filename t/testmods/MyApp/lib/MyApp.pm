package MyApp;

use KelpX::Sweet;
maps ['Main'];

around 'build' => sub {
    my $method = shift;
    my $self   = shift;
    $self->routes->add('/aroundtest' => sub { 'Works' });
    
    $self->$method(@_);
};
