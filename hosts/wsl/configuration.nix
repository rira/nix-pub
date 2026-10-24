{ pkgs, ... }:

{
  # User richard definition
  users.users.richard = {
    isNormalUser = true;
    description = "Richard";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBFMhAwmth99uLCtyQx9qr/oQn1nRfQY5vpTnpLFBacL"
    ];
  };

  # Passwordless sudo for local administration
  security.sudo.wheelNeedsPassword = false;

  # Host-specific shell navigation / aliases
  programs.zsh.shellAliases = {
    cdn = "cd ~/nix-pub";
  };
}
