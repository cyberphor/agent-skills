# ---------------------------------------------------------
# Default settings.
# ---------------------------------------------------------

# Use Bash as the default shell.
SHELL := /bin/bash

# Set the default Make target.
.DEFAULT_GOAL := package

# Set the release directory and archive path.
ARCHIVE_PATH := skills.tar.gz

# Identify top-level directories containing a skill.
SKILL_PATHS := $(wildcard skills/*/)
SKILL_COUNT := $(words $(SKILL_PATHS))
SKILL_WORD  := $(if $(filter 1,$(SKILL_COUNT)),skill,skills)

# ---------------------------------------------------------
# Create the package.
# ---------------------------------------------------------

.PHONY: package
.SILENT: package
package:
	echo "[*] Creating package"
	tar -czf "$(ARCHIVE_PATH)" $(SKILL_PATHS) LICENSE
	echo "[+] Packaged $(SKILL_COUNT) $(SKILL_WORD)"

# ---------------------------------------------------------
# Remove the release archive.
# ---------------------------------------------------------

.PHONY: clean
.SILENT: clean
clean:
	rm -f "$(ARCHIVE_PATH)"
