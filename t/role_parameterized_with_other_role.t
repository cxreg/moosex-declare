use strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;

use FindBin;
use lib "$FindBin::Bin/lib";

use MooseX::Declare;

my $stuff = <<'CLASS';
role Bar {
    sub baz { 'baz called' }
}
role Foo(Str :$param) {
    with 'Bar';
    method test { $self->baz }
}
class MyClass {
    with 'Foo' => { param => 'testing' };
}
CLASS

lives_ok(sub {
    eval $stuff;
    die $@ if $@;
}, 'Compiled class successfully');

my $foo = MyClass->new;

ok($foo->does('Bar'), 'Object has role composed from parameterized role');
TODO: {
    local $TODO = 'methods composed into parameterized roles not found';
    is(eval { $foo->test }, 'baz called', 'Composed method called');
}

done_testing;
