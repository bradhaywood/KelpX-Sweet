package KelpX::Sweet;

use warnings;
use strict;
use true;
use Text::ASCIITable;
use base 'Kelp';

our $VERSION = '0.001';

sub import {
    my ($class, %args) = @_;
    strict->import();
    warnings->import();
    true->import();
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

            my $route_tb = Text::ASCIITable->new;
            $route_tb->setCols('Routes');
            for my $mod (@$route_names) {
                my $route_path = "${caller}::Route::${mod}";
                eval "use $route_path;";
                if ($@) {
                    warn "Could not load route ${route_path}: $@";
                    next;
                }

                $route_tb->addRow($route_path);
                push @$routes, $route_path->get_routes();
            }

            print $route_tb . "\n";
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

=head1 NAME

KelpX::Sweet - Kelp with extra sweeteners

=head1 DESCRIPTION

Kelp is good. Kelp is great. But what if you could give it more syntactic sugar and separate your routes from the logic in a cleaner way? KelpX::Sweet attempts to do just that.

=head1 SIMPLE TUTORIAL

For the most part, your original C<app.psgi> will remain the same as Kelps.

B<MyApp.pm>
  
  package MyApp;
  use KelpX::Sweet;

  maps ['Main'];

Yep, that's the complete code for your base. You pass C<maps> an array reference of the routes you want to include. 
It will look for them in C<MyApp::Route::>. So the above example will load C<MyApp::Route::Main>.
Next, let's create that file

B<MyApp/Route/Main.pm>

  package MyApp::Route::Main;

  use KelpX::Sweet::Route;

  get '/' => 'Controller::Root::hello';
  get '/nocontroller' => sub { 'Hello, world from no controller!' };

Simply use C<KelpX::Sweet::Route>, then create your route definitions here. You're welcome to put your logic inside code refs, 
but that makes the whole idea of this module pointless ;) 
It will load C<MyApp::> then whatever you pass to it. So the '/' above will call C<MyApp::Controller::Root::hello>. Don't worry, 
any of your arguments will also be sent the method inside that controller, so you don't need to do anything else!

Finally, we can create the controller

B<MyApp/Controller/Root.pm>

  package MyApp::Controller::Root;

  use KelpX::Sweet::Controller;

  sub hello {
      my ($self) = @_;
      return "Hello, world!";
  }

You now have a fully functional Kelp app! Remember, because this module is just a wrapper, you can do pretty much anything L<Kelp> 
can, like C<$self-&gt;param> for example.

=head1 SUGARY SYNTAX

By sugar, we mean human readable and easy to use. You no longer need a build method, then to call ->add on an object for your 
routes. It uses a similar syntax to L<Kelp::Lite>. You'll also find one called C<bridge>.

=head2 get

This will trigger a standard GET request.

  get '/mypage' => sub { 'It works' };

=head2 post

Will trigger on POST requests only

  post '/someform' => sub { 'Posted like a boss' };

=head2 bridge

Bridges are cool, so please check out the Kelp documentation for more information on what they do and how they work.

  bridge '/users/:id' => sub {
      unless ($self->user->logged_in) {
          return;
      }

      return 1;
  };

  get '/users/:id/view' => 'Controller::Users::view';

=head1 REALLY COOL THINGS TO NOTE

=head2 Default imports

You should be aware that KelpX::Sweet will import warnings, strict and true for you. Because of this, there is no requirement to 
add a true value to the end of your file. I chose this because it just makes things look a little cleaner.

=head2 KelpX::Sweet starter

On installation of KelpX::Sweet, you'll receive a file called C<kelpx-sweet>. Simply run this, passing it the name of your module 
and it will create a working test app with minimal boilerplate so you can get started straight away. Just run it as:

  $ kelpx-sweet MyApp
  $ kelpx-sweet Something::With::A::Larger::Namespace

=head1 AUTHOR

Brad Haywood <brad@perlpowered.com>

=head1 LICENSE

You may distribute this code under the same terms as Perl itself.

=cut

1;
__END__
