#!/bin/sh
nvim --headless -c "MasonInstall gopls golines goimports golangci-lint staticcheck" -c "qall"
