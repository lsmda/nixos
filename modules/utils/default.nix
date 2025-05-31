let
  to_attribute = str: {
    name = str;
    value = { };
  };
in

{
  inherit to_attribute;
  keys = {
    frostbite = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5TSKvFG/h8aL9+nEKgsoi32s0Jimvhg0TIPcZ1a5dO contact@lsmda.pm";
    spellbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN25GOi1lQySmv4qRr9fyM1QCbr2Rw3+TqySs8ItbP/h contact@lsmda.pm";
    thornmail = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHx/Kp2acbibKMmvBWLKfXLwtVqGCUwq+FNIY1VGsp0F contact@lsmda.pm";
    wardstone = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtrmraahn6VySFIkRReIY4KksV76zIja4SLP/H1/PBX contact@lsmda.pm";
  };
}
