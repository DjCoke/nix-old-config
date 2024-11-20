{ inputs
, hostname
, ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd #decided to keep this module, as this is a VM on a SSD
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko # partition manager
    ./hardware-configuration.nix
    ../modules/common.nix
    ../modules/sops.nix
  ];

  # Set hostname
  networking.hostName = hostname;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.11"; # We are in 24.11 now
}
