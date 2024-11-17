{ ... }: {
  # Used the Energy layout from the upstream repo 
  imports = [
    ../modules/common-headless.nix # It is headless after all, don't need bloated software
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
