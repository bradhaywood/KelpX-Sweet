{
    modules      => [qw/Template::Toolkit JSON Logger/],
    modules_init => {

        # JSON prints pretty
        JSON => {
            pretty => 1
        },

        'Template::Toolkit' => {
            ENCODING => 'utf8',
            INCLUDE_PATH => ['t/testmods/MyApp/views'],
        }
    }
};
