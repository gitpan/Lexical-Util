##==============================================================================
## Lexical-Util.t - test code for Lexical::Util
##==============================================================================
## $Id: Lexical-Util.t,v 1.2 2004/07/10 01:04:40 kevin Exp $
##==============================================================================
use strict;
use Test;
BEGIN { plan tests => 9 };
use Lexical::Util qw(lexalias frame_to_cvref ref_to_lexical);
ok(1); # If we made it this far, we're ok.

sub basic {
	my ($one, $two, $three, $four);
	my $cv = frame_to_cvref(0);
	lexalias($cv, '$one', \$_[0]);
	lexalias($cv, '$two', \$_[1]);
	lexalias($cv, '$three', \$_[2]);

	ok($one == 1 && $two == 2 && $three == 3);
	$one = 'one';
	ok($_[0] eq 'one');

	$four = 4;
	test_ref_lexical(\$four);
}

sub test_ref_lexical {
	my ($lexref) = @_;
	my $cv = frame_to_cvref(1);
	my $rv = ref_to_lexical($cv, '$four');
	ok($lexref eq $rv);
	ok($$rv == 4);
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
