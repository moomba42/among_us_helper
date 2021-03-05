import "package:flutter/material.dart";

MaterialStateProperty<T> materialProperty<T>(
    {T ifContains, T ifNot, List<MaterialState> forStates}) {
  return MaterialStateProperty.resolveWith((states) {
    if (states.intersection(Set.of(forStates)).length > 0) {
      return ifContains;
    }
    return ifNot;
  });
}
