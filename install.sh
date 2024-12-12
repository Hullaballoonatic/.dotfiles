#!/bin/bash

# Define source and target directories
DOTFILES_DIR=~/.dotfiles
TARGET_DIR=~

# Function to create symlinks recursively
link_dotfiles() {
    local src_dir="$1"
    local target_dir="$2"

    # Loop through each item in the source directory
    for src_path in "$src_dir"/.* "$src_dir"/*; do
	# Skip the special entries "." and ".."
	case "$(basename "$src_path")" in "." | "..")
		continue
		;;
	esac

        # Get the relative path
        local rel_path="${src_path#$DOTFILES_DIR/}"
        local target_path="$target_dir/$rel_path"

	case "$rel_path" in
		"README.md" | "install.sh" | ".gitignore" | ".git" | *.DS_Store)
			echo "Skipping: $rel_path"
			continue
			;;
	esac

        # Check if the source path is a directory
        if [[ -d "$src_path" ]]; then
            if [[ -d "$target_path" && ! -L "$target_path" ]]; then
                # If the target is an existing directory (not a symlink), recurse
                echo "Recursing into existing directory: $target_path"
                link_dotfiles "$src_path" "$target_dir"
            else
                # Otherwise, create a symlink for the directory
                echo "Creating symlink for directory: $target_path"
                ln -snf "$src_path" "$target_path"
            fi
        elif [[ -f "$src_path" || -L "$src_path" ]]; then
            # If it's a file or symlink, create a symlink
            echo "Creating symlink for file: $target_path"
            ln -snf "$src_path" "$target_path"
        fi
    done
}

# Start linking process
link_dotfiles "$DOTFILES_DIR" "$TARGET_DIR"
