.PHONY: help deploy deploy-dry update clean status check-old untrack-old check-large public public-dry public-scan

help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  deploy       Deploy dotfiles (create symlinks)"
	@echo "  deploy-dry   Dry run deploy (show what would happen)"
	@echo "  update       Update all git submodules"
	@echo "  status       Show git status and submodule status"
	@echo "  clean        Remove broken symlinks in HOME"
	@echo "  check-old    Show tracked .old files/dirs"
	@echo "  untrack-old  Untrack all .old files/dirs (keeps local)"
	@echo "  check-large  Show large tracked files (>100KB)"
	@echo "  public       Upload sanitized dotfiles to public repo"
	@echo "  public-dry   Dry run public upload (show what would happen)"
	@echo "  public-scan  Scan for secrets only (no upload)"
	@echo "  help         Show this help message"

deploy:
	@./scripts/deploy.sh -r

deploy-dry:
	@./scripts/deploy.sh

update:
	@echo "Updating submodules..."
	@git submodule update --init --recursive
	@git submodule foreach 'git fetch origin && git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || true'
	@echo "Done."

status:
	@echo "=== Git Status ==="
	@git status -s
	@echo ""
	@echo "=== Submodule Status ==="
	@git submodule status

clean:
	@echo "Finding broken symlinks in $(HOME)..."
	@find $(HOME) -maxdepth 1 -xtype l -print 2>/dev/null || true
	@echo ""
	@echo "To remove them, run: find $(HOME) -maxdepth 1 -xtype l -delete"

check-old:
	@echo "=== Tracked .old files/dirs ==="
	@git ls-files | grep -E '\.old|/\.old' || echo "None found"

untrack-old:
	@echo "=== Untracking .old files/dirs ==="
	@files=$$(git ls-files | grep -E '\.old|/\.old'); \
	if [ -n "$$files" ]; then \
		echo "$$files" | xargs git rm --cached -r; \
		echo "Done. Files kept locally but untracked."; \
	else \
		echo "No .old files being tracked."; \
	fi

check-large:
	@echo "=== Large tracked files (>100KB) ==="
	@git ls-files | xargs -I{} sh -c 'test -f "{}" && du -k "{}" 2>/dev/null' | awk '$$1 > 100 {print $$1"KB\t"$$2}' | sort -rn || echo "None found"

public:
	@./scripts/upload-public.sh --run

public-dry:
	@./scripts/upload-public.sh

public-scan:
	@./scripts/upload-public.sh --scan-only

# EOF
