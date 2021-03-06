package com.github.jknack.antlr4ide.issues

import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.InjectWith
import com.github.jknack.antlr4ide.Antlr4TestInjectorProvider
import org.junit.Test
import static org.junit.Assert.*
import com.google.inject.Inject
import com.github.jknack.antlr4ide.parser.Antlr4ParseHelper
import com.github.jknack.antlr4ide.lang.Grammar

@RunWith(XtextRunner)
@InjectWith(Antlr4TestInjectorProvider)
class Issue57 {

  @Inject extension Antlr4ParseHelper<Grammar>

  @Test
  def void epsilonAsFirstAltMustNotFail() {
    val syntaxErrors = '''
      grammar Issue57;
      
      main:;
      
      LINE_COMMENT
        : '--'
          (            // error (required (...)+ loop did not match anything at input '|')
          | '[' '='*
          | '[' '='* ~('='|'['|'\r'|'\n') ~('\r'|'\n')*
          | ~('['|'\r'|'\n') ~('\r'|'\n')*
          ) ('\r\n'|'\r'|'\n'|EOF)
        -> channel(HIDDEN)
       ;
    '''.parse.hasSyntaxErrors

    assertFalse(syntaxErrors)
  }
}
