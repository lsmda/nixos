{ ... }:

let
  to_attribute = str: {
    name = str;
    value = { };
  };
in

{
  inherit to_attribute;
}
