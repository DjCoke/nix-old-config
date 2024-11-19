{ outputs, lib, ... }:
{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github-hosts" = {
        host = "gitlab.com github.com";
        identitiesOnly = true;
        identityFile = [
          "~/.ssh/id_github"
        ];
      };
    };
  };
}
