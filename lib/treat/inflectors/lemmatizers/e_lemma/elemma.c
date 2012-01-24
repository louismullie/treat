#include "wn.h"
#include "wnconsts.h"
#include "ruby.h"

/*

Copyright (C) 2004 UTIYAMA Masao <mutiyama@crl.go.jp>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABITreatY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

static VALUE
parse(VALUE klass, VALUE rb_word, VALUE rb_pos)
{
  char *word;
  char *POS = STR2CSTR(rb_pos);
  char *lemma;
  int pos;
  VALUE retval = rb_ary_new();
  
  word = malloc(strlen(STR2CSTR(rb_word))+1);
  if(!word){rb_raise(rb_eStandardError, "malloc failed.\n");}
  strcpy(word, STR2CSTR(rb_word));
  
  if(strcmp(POS,"noun")==0){pos = NOUN;}
  else if(strcmp(POS,"verb")==0){pos = VERB;}
  else if(strcmp(POS,"adj")==0){pos = ADJ;}
  else if(strcmp(POS,"adv")==0){pos = ADV;}
  else{
    rb_raise(rb_eStandardError, "%s should be (noun|verb|adj|adv)\n", POS);
  }
  if(is_defined(word, pos)){
    /*printf("* %s found as is.\n", word);*/
    rb_ary_push(retval, rb_str_new2(word));
  }
  if((lemma=morphstr(word, pos))!=NULL){
    do {
      if(is_defined(lemma, pos)){
	/*printf("* %s => %s found.\n", word, lemma);*/
	rb_ary_push(retval, rb_str_new2(lemma));
      }
    } while((lemma=morphstr(NULL, pos))!=NULL);
  }
  free(word);
  return retval;
}

void
Init_elemma()
{
  VALUE mod = rb_define_module("ELemma");
  rb_define_module_function(mod, "parse", parse, 2);
  if(wninit()){
    rb_raise(rb_eStandardError, "Cannot open WordNet database\n");
  }
}
