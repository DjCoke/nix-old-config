{ outputs, ... }: {
  # This common file reflects that it is for non-Desktop machines/users
  # TODO: check which modules we might or might not need
  imports = [
    ../modules/atuin.nix
    ../modules/bat.nix
    ../modules/btop.nix
    ../modules/fastfetch.nix
    ../modules/fzf.nix
    ../modules/git.nix
    #   ../modules/go.nix
    #   ../modules/gpg.nix I do not use gpg

    ../modules/home.nix # Do not remove! It's required!
    #   ../modules/krew.nix
    ../modules/lazygit.nix
    #   ../modules/neovim.nix
    #   ../modules/saml2aws.nix
    #   ../modules/scripts.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
    ../modules/ssh.nix
    ../modules/sops.nix
  ];

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  # Catpuccin flavor and accent
  catppuccin = {
    flavor = "macchiato";
    accent = "lavender";
  };
}
