package org.metasyntactic.automata.compiler.java.scanner;

import org.metasyntactic.automata.compiler.framework.parsers.Source;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.EvaluationResult;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.PackratGrammar;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.Rule;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.Expression;
import static org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.Expression.*;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.FunctionExpression;
import org.metasyntactic.automata.compiler.java.scanner.operators.OperatorToken;
import org.metasyntactic.automata.compiler.java.scanner.separators.SeparatorToken;

import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class JavaLexicalSpecification extends PackratGrammar<JavaToken.Type> {
  private final static Rule javaStartRule;
  private final static Set<Rule> javaRules;

  public static Rule WHITESPACE_RULE =
      new Rule("Whitespace",
               choice(oneOrMore(choice(terminal(" "), terminal("\t"),
                                       terminal("\f"))), variable(
                   "NewLine")));

  public static Rule COMMENT_RULE = new Rule("Comment", choice(variable("TraditionalComment"), variable(
      "EndOfLineComment")));

  public static Rule FLOATING_POINT_LITERAL_RULE = new Rule("FloatingPointLiteral", choice(variable(
      "DecimalFloatingPointLiteral"), variable("HexFloatingPointLiteral")));

  public static Rule INTEGER_LITERAL_RULE = new Rule("IntegerLiteral", choice(variable("HexIntegerLiteral"), variable(
      "OctalIntegerLiteral"), variable("DecimalIntegerLiteral")));

  public static Rule CHARACTER_LITERAL_RULE = new Rule("CharacterLiteral", choice(sequence(terminal("'"), sequence(not(
      choice("'", "\\", "\r", "\n", "\r\n")), anyCharacter()), terminal("'")), sequence(terminal("'"), variable(
      "EscapeSequence"), anyCharacter()), terminal("'")));

  public static Rule STRING_LITERAL_RULE =
      new Rule("StringLiteral",
               sequence(terminal("\""),
                        repetition(variable("StringCharacter")),
                        terminal("\"")));

  private static boolean isJavaIdentifierStart(char c) {
    // can't use Character.isJavaIdentifierStart in GWT
    return Character.isLetter(c) || c == '$' || c == '_';
  }

  private static boolean isJavaIdentifierPart(char c) {
    // can't use Character.isJavaIdentifierPart in GWT
    return isJavaIdentifierStart(c) || Character.isDigit(c);
  }

  public static Rule KEYWORD_OR_IDENTIFIER_RULE =
      new Rule("Identifier",
               new FunctionExpression<Source>("keywordOrIdentifier") {
                 public EvaluationResult apply(Source input, int position) {
                   String text = input.getText();

                   if (position < text.length()) {
                     char firstChar = text.charAt(position);

                     if (isJavaIdentifierStart(firstChar)) {
                       for (int i = position + 1; i < text.length(); i++) {
                         char c = text.charAt(i);

                         if (!isJavaIdentifierPart(c)) {
                           return new EvaluationResult(i, null);
                         }
                       }
                     }
                   }

                   return EvaluationResult.failure;
                 }

                 public boolean isNullable() {
                   return false;
                 }

                 public List<Integer> getShortestDerivableTokenStream() {
                   return Collections.singletonList(IdentifierToken.getTypeValue());
                 }

                 public List<Integer> getShortestPrefix(int token) {
                   if (token == JavaToken.Type.Identifier.ordinal()) {
                     return Collections.emptyList();
                   } else if (JavaToken.getKeywordValues().contains(token)) {
                     return Collections.emptyList();
                   }

                   return null;
                 }
               });

  public static Rule OPERATOR_RULE = new Rule("Operator", choice(OperatorToken.getOperators()));

  public static Rule SEPARATOR_RULE = new Rule("Separator", choice(SeparatorToken.getSeparators()));

  public static Rule ERROR_RULE = new Rule("Error", anyCharacter());

  static {
    javaStartRule = new Rule("Input", repetition(variable("InputElement")));

    javaRules = new LinkedHashSet<Rule>();
    javaRules.add(javaStartRule);

    makeRules(javaRules);
  }

  private JavaLexicalSpecification() {
    super(javaStartRule, javaRules);
  }

  public static final JavaLexicalSpecification instance = new JavaLexicalSpecification();

  private static Set<Rule> makeRules(Set<Rule> rules) {

    // identifiers have to be last so that they don't absorb keywords or literals
    rules.add(new Rule("InputElement", choice(variable("Whitespace"), variable("Comment"), variable("Literal"),
                                              variable("Identifier"), variable("Operator"), variable("Separator"),
                                              variable("Error"))));

    rules.add(WHITESPACE_RULE);

    rules.add(new Rule("NewLine", choice(terminal("\r\n"), terminal("\r"), terminal("\n"))));

    comments(rules);
    literals(rules);
    identifier(rules);
    operators(rules);
    separators(rules);

    rules.add(ERROR_RULE);

    return rules;
  }

  private static void separators(Set<Rule> rules) {
    rules.add(SEPARATOR_RULE);
  }

  private static void operators(Set<Rule> rules) {
    rules.add(OPERATOR_RULE);
  }

  private static void identifier(Set<Rule> rules) {
    rules.add(KEYWORD_OR_IDENTIFIER_RULE);
  }

  private static void comments(Set<Rule> rules) {
    rules.add(COMMENT_RULE);

    rules.add(new Rule("TraditionalComment", sequence(terminal("/*"), repetition(sequence(not(terminal("*/")),
                                                                                          anyCharacter())), terminal(
        "*/"))));

    rules.add(new Rule("EndOfLineComment", sequence(terminal("//"), repetition(sequence(not(variable("NewLine")),
                                                                                        anyCharacter())))));
  }

  private static void literals(Set<Rule> rules) {
    // Floating points have to be before the integers so that the integers don't match first.
    rules.add(new Rule("Literal", choice(variable("FloatingPointLiteral"), variable("IntegerLiteral"), variable(
        "CharacterLiteral"), variable("StringLiteral"))));

    integerLiterals(rules);
    floatingPointLiterals(rules);
    characterLiterals(rules);
    stringLiterals(rules);
  }

  private static void stringLiterals(Set<Rule> rules) {
    rules.add(STRING_LITERAL_RULE);

    rules.add(new Rule("StringCharacter", choice(sequence(not(choice("\"", "\\", "\r", "\n", "\r\n")), anyCharacter()),
                                                 variable("EscapeSequence"))));
  }

  private static void characterLiterals(Set<Rule> rules) {
    rules.add(CHARACTER_LITERAL_RULE);

    Expression octalDigit = range('0', '7');

    rules.add(new Rule("EscapeSequence", sequence(terminal("\\"), choice(terminal("b"), terminal("t"), terminal("n"),
                                                                         terminal("f"), terminal("r"), terminal("\""),
                                                                         terminal("'"), terminal("\\"), sequence(range(
        '0', '3'), octalDigit, octalDigit), sequence(octalDigit, octalDigit), octalDigit))));
  }

  private static void floatingPointLiterals(Set<Rule> rules) {
    rules.add(FLOATING_POINT_LITERAL_RULE);

    rules.add(new Rule("DecimalFloatingPointLiteral", choice(variable("DecimalFloatingPointLiteral1"), variable(
        "DecimalFloatingPointLiteral2"), variable("DecimalFloatingPointLiteral3"), variable(
        "DecimalFloatingPointLiteral4"))));

    Expression digits = oneOrMore(range('0', '9'));
    Expression signedIndicator = optional(choice("-", "+"));
    Expression signedInteger = sequence(signedIndicator, digits);
    Expression exponent = sequence(choice("e", "E"), signedInteger);
    Expression floatTypeSuffix = choice("f", "F", "d", "D");

    rules.add(new Rule("DecimalFloatingPointLiteral1", sequence(digits, terminal("."), optional(digits), optional(
        exponent), optional(floatTypeSuffix))));

    rules.add(new Rule("DecimalFloatingPointLiteral2", sequence(terminal("."), digits, optional(exponent), optional(
        floatTypeSuffix))));

    rules.add(new Rule("DecimalFloatingPointLiteral3", sequence(digits, exponent, optional(floatTypeSuffix))));

    rules.add(new Rule("DecimalFloatingPointLiteral4", sequence(digits, optional(exponent), floatTypeSuffix)));

    Expression hexDigits = oneOrMore(choice(range('0', '9'), range('a', 'f'), range('A', 'F')));

    rules.add(new Rule("HexFloatingPointLiteral", sequence(choice(sequence(terminal("0x"), optional(hexDigits),
                                                                           terminal("."), hexDigits), sequence(terminal(
        "0X"), optional(hexDigits), terminal("."), hexDigits), sequence(variable("HexNumeral"), optional(terminal(
        ".")))), choice("p", "P"), signedInteger, optional(floatTypeSuffix))));
  }

  private static void integerLiterals(Set<Rule> rules) {
    // Note: decimal must come last so that we interpret 01 to be octal.
    rules.add(INTEGER_LITERAL_RULE);

    rules.add(new Rule("DecimalIntegerLiteral", sequence(variable("DecimalNumeral"), optional(variable(
        "IntegerTypeSuffix")))));

    rules.add(new Rule("HexIntegerLiteral", sequence(variable("HexNumeral"), optional(variable("IntegerTypeSuffix")))));

    rules.add(new Rule("OctalIntegerLiteral", sequence(variable("OctalNumeral"), optional(variable(
        "IntegerTypeSuffix")))));

    rules.add(new Rule("DecimalNumeral", choice(sequence(range('1', '9'), repetition(range('0', '9'))), terminal(
        "0"))));

    rules.add(new Rule("HexNumeral", sequence(choice(terminal("0x"), terminal("0X")), repetition(choice(range('0', '9'),
                                                                                                        range('a', 'f'),
                                                                                                        range('A',
                                                                                                              'F'))))));

    rules.add(new Rule("OctalNumeral", sequence(terminal("0"), oneOrMore(range('0', '7')))));

    rules.add(new Rule("IntegerTypeSuffix", choice("l", "L")));
  }

  public JavaToken.Type getTokenFromTerminal(int type) {
    return JavaToken.Type.values()[type];
  }

  protected Set<Integer> getTerminalsWorker() {
    return JavaToken.getValues();
  }

  protected double prefixCost(List<Integer> tokens) {
    return tokens.size();
  }
}