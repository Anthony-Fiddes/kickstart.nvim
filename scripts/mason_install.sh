#!/bin/sh
nvim --headless -c "MasonInstall gopls golines goimports golangci-lint staticcheck" -c "qall"
nvim --headless -c "MasonInstall bashls shellcheck shfmt" -c "qall"
