# sops configuration for Home Manager

{ inputs, userConfig, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    #this is the erwin/dev key and need to have been copied to this location on the host
    age.keyFile = "/home/erwin/.config/sops/age/keys.txt";


    defaultSopsFile = ../../secrets.yaml;
    validateSopsFiles = false;

    secrets = {
      "private_keys/${userConfig.name}" = {
        path = "/home/${userConfig.name}/.ssh/id_ed25519";
      };
    };
  };
}
