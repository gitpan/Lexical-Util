#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

/*
 * dopoptosub_at - find the index to the specified stack frame
 */
I32 dopoptosub_at(pTHX_ PERL_CONTEXT *cxstk, I32 start)
{
	dTHR;
	I32 i;
	I32 type;

	for (i = start;
		 i >= 0
		  && (type = CxTYPE(&cxstk[i])) != CXt_SUB
#ifdef CXt_FORMAT
		  && type != CXt_FORMAT
#endif
		 ;
		 i--
	)
		;

	return i;
}

MODULE = Lexical::Util		PACKAGE = Lexical::Util

void
lexalias(SV* cvref, char *name, SV* value)
  CODE:
	CV* cv;					/* Code reference, or 0 */
	AV* padn;				/* Pad names */
	AV* padv;				/* Pad values */
	SV* new_sv;				/* Item referenced by value */
	I32 i;					/* index variable */

	if (!SvROK(value))
		croak("third argument to lexalias is supposed to be a reference");

	new_sv = SvRV(value);

	if (SvROK(cvref)) {
		cv = (CV*)SvRV(cvref);
	} else if (SvIOK(cvref) && SvIV(cvref) == 0) {
		cv = NULL;
	} else {
		croak("first argument to lexalias is supposed to be a code ref or 0");
	}

	padn = cv ? (AV*)AvARRAY(CvPADLIST(cv))[0] : PL_comppad_name;
	padv = cv ? (AV*)AvARRAY(CvPADLIST(cv))[CvDEPTH(cv)] : PL_comppad;

	/*
	 * Go through the pad name list and find the one corresponding to 'name'.
	 */
	for (i = 0; i <= av_len(padn); ++i) {
		SV** name_ptr = av_fetch(padn, i, 0);
		if (name_ptr) {
			SV* name_sv = *name_ptr;
			if (SvPOKp(name_sv)) {
				char *name_str = SvPVX(name_sv);
				if (strcmp(name, name_str) == 0) {
					av_store(padv, i, new_sv);
					SvREFCNT_inc(new_sv);
					break;
				}
			}
		}
	}

	if (i > av_len(padn)) {
		croak("Variable '%s' not found in lexalias", name);
	}

SV*
frame_to_cvref(I32 level)
  CODE:
	PERL_CONTEXT *cx = (PERL_CONTEXT *)0;
	PERL_SI *top_si = PL_curstackinfo;
	I32 cxix = dopoptosub_at(aTHX_ cxstack, cxstack_ix);
	PERL_CONTEXT *ccstack = cxstack;
	CV *cur_cv;

	/*
	 * First, find the Perl context for the given level.
	 */
	for (;;) {
		while (cxix < 0 && top_si->si_type != PERLSI_MAIN) {
			top_si  = top_si->si_prev;
			ccstack = top_si->si_cxstack;
			cxix    = dopoptosub_at(aTHX_ ccstack, top_si->si_cxix);
		}
		if (cxix < 0) {
			if (level != 0) {
				cx = (PERL_CONTEXT *)-1;
			}
			break;
		}
		if (PL_DBsub && cxix >= 0 && ccstack[cxix].blk_sub.cv == GvCV(PL_DBsub))
			level++;
		if (level-- == 0) {
			cx = &ccstack[cxix];
			break;
		}
		cxix = dopoptosub_at(aTHX_ ccstack, cxix - 1);
	}
	/*
	 * Perl context is in cx.
	 * Find the associated code reference.
	 */
	if (cx != (PERL_CONTEXT *)-1) {
		if (cx != (PERL_CONTEXT *)0) {
			if (cx->cx_type != CXt_SUB) {
				croak(
					"invalid cx_type in frame_to_cvref: is %d, should be %d",
					cx->cx_type, CXt_SUB
				);
			}
			if ((cur_cv = cx->blk_sub.cv) == 0) {
				croak("frame_to_cvref: context has no associated CV!");
			}
			RETVAL = (SV*)newRV_inc((SV*)cur_cv);
		} else {
			RETVAL = (SV*)newSViv(0);
		}
	} else {
		RETVAL = (SV*)newSV(0);
	}
  OUTPUT:
	RETVAL
