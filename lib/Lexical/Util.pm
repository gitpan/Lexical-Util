##==============================================================================
## Lexical::Util - utilities for lexical item manipulation
##==============================================================================
## Copyright 2004 Kevin Michael Vail
## This program is free software. It may be copied and/or redistributed under
## the same terms as Perl itself.
##==============================================================================
## $Id: Util.pm,v 0.7 2004/07/27 02:23:02 kevin Exp $
##==============================================================================
require 5.006;

package ## don't want this indexed yet
	Lexical::Util;
use strict;
use warnings;
our ($VERSION) = q$Revision: 0.7 $ =~ /Revision:\s+(\S+)/ or $VERSION = '0.0';
use Carp;

BEGIN {
	## Check to see that the version of Perl isn't too new.
	if ($^V && $^V ge 5.9.0) {
		croak "Lexical::Util not supported on version of Perl past 5.8.x";
	}
}

require XSLoader;
XSLoader::load('Lexical::Util', $VERSION);

use base qw(Exporter);
our @EXPORT_OK = qw(frame_to_cvref lexalias ref_to_lexical);

=head1 NAME

Lexical::Util - utilities for lexical item manipulation

=head1 SYNOPSIS

	use Lexical::Util qw(frame_to_cvref lexalias ref_to_lexical);

	$cvref = frame_to_cvref($level);
	lexalias($cvref, '$name', \$variable);
	$ref = ref_to_lexical($cvref, '$name');

=head1 DESCRIPTION

C<Lexical::Util> is a module containing some common routines used by modules
dealing with the lexical variables of routines other than their own. They are
taken from various sources, including L<PadWalker|PadWalker>,
L<Perl6::Binding|Perl6::Binding>, and L<Lexical::Alias|Lexical::Alias>. This
module is used in version 0.7 and greater of Perl6::Binding, as well as in the
L<Object::Variables|Object::Variables> and L<Sub::Declaration|Sub::Declaration>
packages, to prevent duplication of code.

This package should I<not> be needed or used by end users.

Note: this module uses the L<CvPADLIST|perlintern/CvPADLIST> and CvDEPTH macros,
which are listed in L<perlintern|perlintern> and not part of the perl API. They
work in the versions I've been able to test on (5.6.1 and 5.8.4), but may change
in the future. To avoid possible problems, this module tests to see that the
Perl version is less than 5.9.0.

=head1 EXPORTABLE ROUTINES

Nothing is exported by default, but you can request the following:

=over 4

=item frame_to_cvref

C<< I<$cvref> = frame_to_cvref(I<$level>); >>

Finds the code reference (subroutine) for the stack frame indicated by
I<$level>, which is similar to the argument for L<perlfunc/caller>. If the
return value is true, the function succeeded.

=item lexalias

C<< lexalias(I<$cvref>, 'I<$name>', I<\$value>); >>

Creates a lexical alias for a variable called I<$name> pointing to the variable
I<$value>. I<$cvref> is a code reference returned by L<"frame_to_cvref">. If
I<$cvref> is B<undef>, this routine dies.

=item ref_to_lexical

C<< I<$ref> = ref_to_lexical(I<$cvref>, 'I<$name>'); >>

Returns a reference to the named lexical variable in the specified stack frame.
I<$cvref> is a code reference returned by L<"frame_to_cvref">. If I<$cvref> is
B<undef> or the specified name isn't found, this routine dies.

=back

=head1 KNOWN ISSUES

=over 4

=item *

If I<$cvref> is the scalar 0, then B<lexalias> must have been called
from the top level of the program (outside of any subroutines) and the
variable being aliased must also exist at the top level. This doesn't
appear to work under the debugger, however. I hope to eliminate this
restriction with more research.

=back

=head1 COPYRIGHT AND LICENSE

Copyright 2004 Kevin Michael Vail

This program is free software.  It may be copied and/or redistributed under the
same terms as Perl itself.

=head1 AUTHOR

Kevin Michael Vail <F<kevin>@F<vaildc>.F<net>>

=cut

1;

##==============================================================================
## $Log: Util.pm,v $
## Revision 0.7  2004/07/27 02:23:02  kevin
## POD change just to bump version number for CPAN.
##
## Revision 0.6  2004/07/25 04:44:44  kevin
## Update POD; change the way the version number is computed.
##
## Revision 0.5  2004/07/10 01:14:32  kevin
## Add ref_to_lexical function.
##
## Revision 0.4  2004/06/06 01:01:33  kevin
## Bump version number.
##
## Revision 0.3  2004/06/06 00:46:47  kevin
## Add check for Perl version >= 5.9.0.
##
## Revision 0.2  2004/05/31 04:39:30  kevin
## Modify the documentation to reflect the facts.
##
## Revision 0.1  2004/05/31 02:44:52  kevin
## Initial revision
##==============================================================================
