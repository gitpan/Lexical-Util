# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Lexical-Util.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';
use strict;
use Test;
BEGIN { plan tests => 7 };
use Lexical::Util qw(lexalias frame_to_cvref);
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

sub basic {
	my ($one, $two, $three);
	my $cv = frame_to_cvref(0);
	lexalias($cv, '$one', \$_[0]);
	lexalias($cv, '$two', \$_[1]);
	lexalias($cv, '$three', \$_[2]);

	ok($one == 1 && $two == 2 && $three == 3);
	$one = 'one';
	ok($_[0] eq 'one');

}

my @args = qw/1 2 3/;

basic(@args);

ok($args[0] eq 'one');
ok($args[1] == 2);

my $four = 4;
my $afour;

my $cv = frame_to_cvref(0);
lexalias($cv, '$afour', \$four);

ok($afour == 4);
$afour = 'four';
ok($four eq 'four');
