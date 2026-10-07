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

# Set the skill validator source.
SKILLS_REF_SOURCE ?= git+https://github.com/agentskills/agentskills.git\#subdirectory=skills-ref

# ---------------------------------------------------------
# Validate the skills.
# ---------------------------------------------------------

.PHONY: validate
.SILENT: validate
validate:
	echo "[*] Validating $(SKILL_COUNT) $(SKILL_WORD)"
	uv run --no-project --with "skills-ref @ $(SKILLS_REF_SOURCE)" \
		bash -c 'for skill_path do skills-ref validate "$$skill_path" || exit $$?; done' -- $(SKILL_PATHS)

# ---------------------------------------------------------
# Create the package.
# ---------------------------------------------------------

.PHONY: package
.SILENT: package
package: validate
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
