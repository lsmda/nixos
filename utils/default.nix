let
  with_name = name: { inherit name; };
  with_value = name: with_name name // { value = { }; };

  # convert a string to an attribute set
  # "a" -> { name = "a"; value = {}; }
  to_attribute = name: with_value name;
in

{
  inherit to_attribute;
}
