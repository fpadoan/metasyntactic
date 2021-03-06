package org.metasyntactic.automata.compiler.java.scanner.operators;

public class EqualsEqualsOperatorToken extends OperatorToken {
  public final static EqualsEqualsOperatorToken instance = new EqualsEqualsOperatorToken();

  private EqualsEqualsOperatorToken() {
    super("==");
  }

  protected Type getTokenType() {
    return Type.EqualsEqualsOperator;
  }
}
