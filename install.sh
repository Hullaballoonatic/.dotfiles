#!/bin/bash

DOTFILES_DIR=~/.dotfiles

TARGET_DIR=~

SYMLINK_LOG="$DOTFILES_DIR/symlinks.log"

if [[ -f "$SYMLINK_LOG" ]]; then
	echo "removing previous symlinks"
	
	while read symlink; do
		if [[ -L "$symlink" ]]; then
			rm "$symlink"
		fi
	done < "$SYMLINK_LOG"

	> "$SYMLINK_LOG"
fi

find "$DOTFILES_DIR" -mindepth 1 -print | while read src; do

	rel_path="${src#$DOTFILES_DIR/}"

	if [[ "$rel_path" == "install.sh" || "$rel_path" == ".git"* || "$rel_path" == "symlinks.log" || "$rel_path" == "README.md" ]]; then
		continue
	fi

	target="$TARGET_DIR/$rel_path"

	mkdir -p "$(dirname "$target")"

	ln -sf "$src" "$target"

	echo "$target" >> "$SYMLINK_LOG"
done
