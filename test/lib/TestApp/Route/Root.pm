package TestApp::Route::Root;

use KelpX::Sweet::Route;

get '/' => sub { return "Hello, world!"; };
get '/hello/:name' => 'Controller::Root::hello';
bridge '/check/:id' => sub { 
    my ($self) = @_;
    return 1 if $self->param('pass');
};
get '/check/:id/ok' => sub {
    return "ok";
};

1;
__END__
