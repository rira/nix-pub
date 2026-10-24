{ pkgs, ... }:

{
  # Nix settings and experimental features
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Essential bootstrap packages
  environment.systemPackages = with pkgs; [
    git
    gh
    age
    sops
    curl
    wget
    openssh
    zsh
  ];

  # Enable zsh shell system-wide
  programs.zsh.enable = true;

  # Set default non-root user richard shell
  users.users.richard = {
    shell = pkgs.zsh;
  };

  # Harden and enable OpenSSH daemon
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  # NixOS state version
  system.stateVersion = "24.11";
}
