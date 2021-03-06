// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class ByteKeywordToken extends KeywordToken {
  public static final ByteKeywordToken instance = new ByteKeywordToken();

  private ByteKeywordToken() {
    super("byte");
  }

  protected Type getTokenType() {
    return Type.ByteKeyword;
  }
}
