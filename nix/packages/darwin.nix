{ pkgs }:

(import ./core.nix { inherit pkgs; })
++
(with pkgs; [
	ghostty
])

