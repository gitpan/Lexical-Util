##==============================================================================
## Lexical::Util - utilities for lexical item manipulation
##==============================================================================
## Copyright 2004 Kevin Michael Vail
## This program is free software. It may be copied and/or redistributed under
## the same terms as Perl itself.
##==============================================================================
## $Id: Util.pm,v 0.2 2004/05/31 04:39:30 kevin Exp $
##==============================================================================
require 5.006;

package ## don't want this indexed yet
	Lexical::Util;
use strict;
use warnings;
our $VERSION = '0.1';
require XSLoader;
XSLoader::load('Lexical::Util', $VERSION);

use base qw(Exporter);
our @EXPORT_OK = qw(frame_to_cvref lexalias);

=head1 NAME

Lexical::Util - utilities for lexical item manipulation

=head1 SYNOPSIS

	use Lexical::Util qw(alias);

	$cvref = frame_to_cvref($level);
	lexalias($cvref, '$name', \$variable);

=head1 DESCRIPTION

C<Lexical::Util> is a module containing some common routines used by modules
dealing with the lexical variables of routines other than their own. They are
taken from various sources, including L<PadWalker|PadWalker>,
L<Perl6::Binding|Perl6::Binding>, and L<Lexical::Alias|Lexical::Alias>. This
module is used in version 0.7 and greater of Perl6::Binding, as well as in the
L<fields::aliased|fields::aliased> package, to prevent duplication of code.

This package should I<not> be used by end users.

=head1 EXPORTABLE ROUTINES

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
## Revision 0.2  2004/05/31 04:39:30  kevin
## Modify the documentation to reflect the facts.
##
## Revision 0.1  2004/05/31 02:44:52  kevin
## Initial revision
##==============================================================================
