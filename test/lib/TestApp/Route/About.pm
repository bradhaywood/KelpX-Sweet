package TestApp::Route::About;

use KelpX::Sweet::Route;

get '/about' => sub { "<h2>About us</h2>"; };
get '/about/:thing' => sub { "About " . $_[1]; };
1;
__END__
