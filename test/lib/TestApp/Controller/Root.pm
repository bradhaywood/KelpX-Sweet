package TestApp::Controller::Root;

sub hello {
    my ($self, $name) = @_;
    if (my $query = $self->param('q')) {
        return "<h3>Searching for $query</h3>";
    }

    return "<h2>Hello, ${name}";
}

1;
__END__
