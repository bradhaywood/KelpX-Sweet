package MyApp::Route::Main;

use KelpX::Sweet::Route;

get '/' => 'Controller::Main::hello';
get '/greet' => 'Controller::Main::greet';
