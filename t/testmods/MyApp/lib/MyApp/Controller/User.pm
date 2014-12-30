package MyApp::Controller::User;

use KelpX::Sweet::Controller;

sub auto {
    my ($self) = @_;
    
    $self->stash->{title} = 'View user';
    return 1;
}

sub view {
    my ($self, $id) = @_;
    return $self->stash('title') . " ${id}";
}
