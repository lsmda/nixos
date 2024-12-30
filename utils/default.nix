let
  with_name = name: { inherit name; };
  with_value = name: with_name name // { value = { }; };

  # map over a list of strings to return a list of attributes
  # "a" -> { a = {}; }
  to_attribute = name: with_value name;
in

{
  inherit to_attribute;
}
